#!/usr/bin/env python3
"""Check book sources without third-party Python packages.

Run from any directory: python3 scripts/check_sources.py [PROJECT_ROOT].
This is a lexical consistency check, not a TeX compiler or a scientific
correctness test. Quarto and LuaLaTeX remain the rendering authorities.
"""

from __future__ import annotations

import argparse
from collections import defaultdict
import html
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit


IGNORED_DIRS = {".git", ".quarto", "_site", "_book", "node_modules", ".venv"}
CROSSREF_PREFIXES = {
    "eq", "fig", "tbl", "sec", "lst", "thm", "lem", "cor", "prp",
    "cnj", "def", "exm", "exr", "sol", "rem", "alg", "nte",
}
# Pandoc's suppress-author marker @* and Quarto's special document references
# do not denote bibliography records or a user-defined cross-reference target.
SPECIAL_REFS = {"fig", "tbl", "eq", "sec", "lst", "ref", "refs"}
REFERENCE = re.compile(r"(?<![\w/@])@([A-Za-z0-9_][A-Za-z0-9_:.+-]*[A-Za-z0-9_+-]|[A-Za-z0-9_])")
ATTRIBUTE = re.compile(r"\{[^{}\n]*#([A-Za-z][\w:.-]*)[^{}\n]*\}")
IMAGE = re.compile(r"!\[[^\]]*\]\(\s*(<[^>]+>|[^\s)]+)(?:\s+[^)]*)?\)")
IMAGE_TAG = re.compile(r"<img\b[^>]*\bsrc\s*=\s*[\"']([^\"']+)[\"']", re.I)
LATEX_IMAGE = re.compile(r"\\includegraphics(?:\[[^\]]*\])?\{([^}]+)\}")


def line_number(text: str, offset: int) -> int:
    return text.count("\n", 0, offset) + 1


def blank_keep_lines(value: str) -> str:
    return "".join("\n" if c == "\n" else " " for c in value)


def prose_only(text: str) -> str:
    """Mask code/comments/front matter while preserving source line numbers."""
    lines = text.splitlines(keepends=True)
    in_fence: tuple[str, int] | None = None
    in_frontmatter = bool(lines and lines[0].strip() == "---")
    result = []
    for i, line in enumerate(lines):
        if in_frontmatter:
            result.append(blank_keep_lines(line))
            if i > 0 and line.strip() in {"---", "..."}:
                in_frontmatter = False
            continue
        fence = re.match(r"^\s*(`{3,}|~{3,})", line)
        if in_fence:
            result.append(blank_keep_lines(line))
            if fence and fence[1][0] == in_fence[0] and len(fence[1]) >= in_fence[1]:
                in_fence = None
            continue
        if fence:
            in_fence = (fence[1][0], len(fence[1]))
            result.append(blank_keep_lines(line))
            continue
        result.append(line)
    value = "".join(result)
    for pattern in (
        r"<!--[\s\S]*?-->",
        r"<(?:script|style)\b[^>]*>[\s\S]*?</(?:script|style)\s*>",
        r"(`+)(?:(?!\1)[\s\S])*?\1",
    ):
        value = re.sub(pattern, lambda m: blank_keep_lines(m[0]), value, flags=re.I)
    return value


def is_escaped(text: str, offset: int) -> bool:
    slashes = 0
    offset -= 1
    while offset >= 0 and text[offset] == "\\":
        slashes += 1
        offset -= 1
    return bool(slashes % 2)


def math_errors(text: str) -> list[tuple[int, str]]:
    """Check paired Markdown/TeX math delimiters and TeX environments."""
    errors: list[tuple[int, str]] = []
    opener: tuple[str, int] | None = None
    environments: list[tuple[str, int]] = []
    tokens = re.compile(r"\$\$|\$|\\[()[\]]|\\(?:begin|end)\{([^}]+)\}")
    expected = {"$": "$", "$$": "$$", r"\(": r"\)", r"\[": r"\]"}
    for match in tokens.finditer(text):
        token = match[0]
        if is_escaped(text, match.start()):
            continue
        line = line_number(text, match.start())
        if token.startswith((r"\begin", r"\end")):
            if opener is None:
                # Some supported raw LaTeX environments stand outside Markdown
                # math. Their pairing is still checked below.
                pass
            name = match[1]
            if token.startswith(r"\begin"):
                environments.append((name, line))
            elif not environments or environments[-1][0] != name:
                errors.append((line, f"unmatched TeX environment end: {name}"))
            else:
                environments.pop()
            continue
        if opener is None:
            if token in {r"\)", r"\]"}:
                errors.append((line, f"math closing delimiter {token} has no opener"))
            else:
                opener = (token, line)
        elif token == expected[opener[0]]:
            opener = None
        elif token in {"$", "$$"} or token in {r"\)", r"\]"}:
            errors.append((line, f"math delimiter {token} does not close {opener[0]} from line {opener[1]}"))
    if opener:
        errors.append((opener[1], f"unclosed math delimiter {opener[0]}"))
    errors.extend((line, f"unclosed TeX environment: {name}") for name, line in environments)
    return errors


def figure_target(raw: str, source: Path, root: Path) -> Path | None:
    raw = html.unescape(raw.strip().strip("<>"))
    parts = urlsplit(raw)
    if parts.scheme or parts.netloc or not parts.path:
        return None
    path = unquote(parts.path)
    return root / path.lstrip("/") if path.startswith("/") else source.parent / path


def check(root: Path) -> int:
    errors: list[str] = []
    sources = sorted(p for p in root.rglob("*.qmd") if not (set(p.relative_to(root).parts) & IGNORED_DIRS))
    if not sources:
        print(f"ERROR: no .qmd sources in {root}", file=sys.stderr)
        return 1
    config = root / "_quarto.yml"
    if not config.is_file():
        errors.append("_quarto.yml: book configuration is missing")
    else:
        config_text = config.read_text(encoding="utf-8")
        # The book's chapter/appendix paths use YAML list entries. Checking
        # these before Quarto starts gives a direct error for an unfinished
        # or accidentally renamed chapter, without a PyYAML dependency.
        for match in re.finditer(r"(?m)^\s*-\s*[\"']?([^\s\"'#]+\.qmd)[\"']?\s*(?:#.*)?$", config_text):
            path = match[1]
            if not any(char in path for char in "*?[") and not (root / path).is_file():
                errors.append(f"_quarto.yml:{line_number(config_text, match.start())}: listed chapter is missing: {path}")
    bibliography = root / "assets" / "bibliography.bib"
    bibkeys: set[str] = set()
    if not bibliography.is_file():
        errors.append("assets/bibliography.bib: merged bibliography is missing")
    else:
        bibtext = bibliography.read_text(encoding="utf-8")
        seen_bib: set[str] = set()
        for entry in re.finditer(r"(?mi)^\s*@([A-Za-z]+)\s*[({]\s*([^,\s]+)", bibtext):
            if entry[1].lower() in {"comment", "preamble", "string"}:
                continue
            key = entry[2]
            if key in seen_bib:
                errors.append(f"assets/bibliography.bib: duplicate bibliography key {key}")
            seen_bib.add(key)
        bibkeys = seen_bib

    labels: dict[str, list[tuple[Path, int]]] = defaultdict(list)
    documents: dict[Path, tuple[str, str]] = {}
    for source in sources:
        raw = source.read_text(encoding="utf-8")
        prose = prose_only(raw)
        documents[source] = (raw, prose)
        for match in ATTRIBUTE.finditer(prose):
            labels[match[1]].append((source, line_number(prose, match.start())))
        # Executable cells use labels in code options rather than prose attrs.
        for match in re.finditer(r"(?m)^\s*#\|\s*label:\s*[\"']?([A-Za-z][\w:.-]*)", raw):
            labels[match[1]].append((source, line_number(raw, match.start())))
    for label, occurrences in labels.items():
        if len(occurrences) > 1:
            locations = ", ".join(f"{p.relative_to(root)}:{n}" for p, n in occurrences)
            errors.append(f"duplicate label {label}: {locations}")

    citations: set[str] = set()
    figure_count = 0
    for source, (_, prose) in documents.items():
        relative = source.relative_to(root)
        for match in REFERENCE.finditer(prose):
            key = match[1]
            if key in SPECIAL_REFS:
                continue
            location = f"{relative}:{line_number(prose, match.start())}"
            if key.partition("-")[0] in CROSSREF_PREFIXES:
                if key not in labels:
                    errors.append(f"{location}: cross-reference @{key} has no target")
            else:
                citations.add(key)
                if key not in bibkeys:
                    errors.append(f"{location}: citation @{key} is absent from the merged bibliography")
        for line, message in math_errors(prose):
            errors.append(f"{relative}:{line}: {message}")
        for pattern in (IMAGE, IMAGE_TAG, LATEX_IMAGE):
            for match in pattern.finditer(prose):
                target = figure_target(match[1], source, root)
                if target is not None:
                    figure_count += 1
                    if not target.is_file():
                        errors.append(f"{relative}:{line_number(prose, match.start())}: missing local figure {match[1]}")
        # Also support reference-style Markdown images, which need a separate
        # definition lookup rather than treating their label as a file path.
        definitions = {
            m[1].strip().casefold(): m[2]
            for m in re.finditer(r"(?m)^\s*\[([^\]]+)\]:\s*(<[^>]+>|\S+)", prose)
        }
        for match in re.finditer(r"!\[([^\]]*)\]\[([^\]]*)\]", prose):
            label = (match[2] or match[1]).strip().casefold()
            location = f"{relative}:{line_number(prose, match.start())}"
            if label not in definitions:
                errors.append(f"{location}: missing image reference definition [{label}]")
                continue
            target = figure_target(definitions[label], source, root)
            if target is not None:
                figure_count += 1
                if not target.is_file():
                    errors.append(f"{location}: missing local figure {definitions[label]}")
    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        print(f"Source checks failed: {len(errors)} error(s).", file=sys.stderr)
        return 1
    print(f"Source checks passed: {len(sources)} documents, {len(labels)} labels, "
          f"{len(citations)} cited works, {figure_count} local figure references.")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("root", nargs="?", type=Path, default=Path(__file__).resolve().parents[1])
    return check(parser.parse_args().root.resolve())


if __name__ == "__main__":
    raise SystemExit(main())
