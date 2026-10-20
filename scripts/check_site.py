#!/usr/bin/env python3
"""Validate a rendered Quarto book using only Python's standard library.

Checks local links/assets and cross-page anchors, navigation, local MathJax,
unresolved references, and the combined PDF and its download link. External
links are deliberately not requested; source repositories and papers are not
part of this deployment's local file tree.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass, field
from html.parser import HTMLParser
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit


@dataclass
class Page:
    path: Path
    ids: set[str] = field(default_factory=set)
    links: list[tuple[str, str, int]] = field(default_factory=list)
    text: list[str] = field(default_factory=list)
    has_navigation: bool = False
    has_math: bool = False
    has_mathjax: bool = False
    unresolved: list[int] = field(default_factory=list)


class InspectHTML(HTMLParser):
    def __init__(self, page: Page):
        super().__init__(convert_charrefs=True)
        self.page = page
        self.skip_depth = 0

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        classes = set(attrs.get("class", "").split())
        if tag in {"script", "style"}:
            self.skip_depth += 1
        if attrs.get("id"):
            self.page.ids.add(attrs["id"])
        if tag == "a" and attrs.get("name"):
            self.page.ids.add(attrs["name"])
        if tag == "nav" or "sidebar-navigation" in classes or attrs.get("id") == "quarto-sidebar":
            self.page.has_navigation = True
        if "math" in classes:
            self.page.has_math = True
        if "quarto-unresolved-ref" in classes:
            self.page.unresolved.append(self.getpos()[0])
        if tag == "script" and "mathjax" in attrs.get("src", "").lower():
            self.page.has_mathjax = True
        for attribute in ("href", "src", "poster", "data"):
            if value := attrs.get(attribute):
                self.page.links.append((value, f"{tag}[{attribute}]", self.getpos()[0]))
        # A srcset is a list of URLs with optional pixel-density/width hints.
        # Data URLs may contain commas, so leave those to the ordinary src.
        if attrs.get("srcset") and not attrs["srcset"].lstrip().startswith("data:"):
            for item in attrs["srcset"].split(","):
                if item.strip():
                    self.page.links.append((item.strip().split()[0], "srcset", self.getpos()[0]))

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        if tag in {"script", "style"}:
            self.skip_depth = max(0, self.skip_depth - 1)

    def handle_endtag(self, tag):
        if tag in {"script", "style"}:
            self.skip_depth = max(0, self.skip_depth - 1)

    def handle_data(self, data):
        if not self.skip_depth:
            self.page.text.append(data)
        elif "MathJax" in data:
            # Configuration alone does not establish that a renderer was
            # shipped; has_mathjax is intentionally set only by script src.
            pass


def configuration(root: Path) -> tuple[str, str]:
    config = root / "_quarto.yml"
    text = config.read_text(encoding="utf-8") if config.is_file() else ""
    url = re.search(r"(?m)^\s*site-url:\s*[\"']?([^\s\"']+)", text)
    output = re.search(r"(?m)^\s*output-file:\s*[\"']?([^\s\"']+)", text)
    return url[1] if url else "", output[1].removesuffix(".pdf") if output else ""


def local_target(raw: str, page: Path, site: Path, site_url: str) -> tuple[Path, str] | None:
    # Quarto's JS templates can contain literal interpolation placeholders.
    # They are not actual browser destinations at static validation time.
    if any(token in raw for token in ("${", "{{", "<%")):
        return None
    parts = urlsplit(raw)
    published = urlsplit(site_url)
    if parts.scheme or parts.netloc:
        if (parts.scheme not in {"http", "https"} or not published.netloc
                or parts.netloc != published.netloc):
            return None
        # An absolute same-origin URL is local only within this book's base.
        base = published.path.rstrip("/") + "/"
        if not (parts.path.startswith(base) or parts.path == base.rstrip("/")):
            return None
    path = unquote(parts.path)
    fragment = unquote(parts.fragment)
    if not path:
        return page, fragment
    if path.startswith("/"):
        base = published.path.rstrip("/")
        if base and (path == base or path.startswith(base + "/")):
            path = path[len(base):]
        candidate = site / path.lstrip("/")
    else:
        candidate = page.parent / path
    candidate = candidate.resolve()
    if candidate.is_dir():
        candidate = candidate / "index.html"
    return candidate, fragment


def check(site: Path, root: Path, site_url: str) -> int:
    errors: list[str] = []
    if not site.is_dir():
        print(f"ERROR: site directory is missing: {site}", file=sys.stderr)
        return 1
    configured_url, output_name = configuration(root)
    site_url = site_url or configured_url
    pages: dict[Path, Page] = {}
    for path in sorted(site.rglob("*.html")):
        page = Page(path.resolve())
        parser = InspectHTML(page)
        parser.feed(path.read_text(encoding="utf-8"))
        parser.close()
        pages[page.path] = page
    if not pages:
        print(f"ERROR: no HTML pages in {site}", file=sys.stderr)
        return 1
    links_checked = 0
    pdf_links: set[Path] = set()
    math_pages = 0
    for path, page in pages.items():
        name = path.relative_to(site)
        if not page.has_navigation:
            errors.append(f"{name}: no book navigation was found")
        if page.has_math:
            math_pages += 1
            if not page.has_mathjax:
                errors.append(f"{name}: mathematical content has no MathJax script")
        for line in page.unresolved:
            errors.append(f"{name}:{line}: Quarto marked an unresolved reference")
        visible_text = " ".join(page.text)
        for match in re.finditer(r"\?@(?:eq|fig|tbl|sec|lst|thm|lem|cor|def|exm|exr)-[\w:.-]+", visible_text):
            errors.append(f"{name}: unresolved cross-reference {match[0]}")
        for raw, attribute, line in page.links:
            target = local_target(raw, path, site, site_url)
            if target is None:
                continue
            destination, fragment = target
            links_checked += 1
            try:
                destination.relative_to(site)
            except ValueError:
                errors.append(f"{name}:{line}: local link escapes the published site: {raw}")
                continue
            if not destination.is_file():
                errors.append(f"{name}:{line}: missing local {attribute} target: {raw}")
                continue
            if destination.suffix.lower() == ".pdf":
                pdf_links.add(destination)
            if fragment and destination.suffix.lower() == ".html":
                target_page = pages.get(destination)
                # Text fragments are browser search directives, not HTML IDs.
                anchor = fragment.split(":~:text=", 1)[0]
                if anchor and (target_page is None or anchor not in target_page.ids):
                    errors.append(f"{name}:{line}: missing anchor #{anchor} in {destination.relative_to(site)}")
    pdfs = sorted(site.glob("*.pdf"))
    if output_name:
        expected_pdf = site / f"{output_name}.pdf"
        if expected_pdf not in pdfs:
            errors.append(f"missing combined PDF: {expected_pdf.name}")
    if not pdfs:
        errors.append("no combined PDF exists at the site root")
    for pdf in pdfs:
        with pdf.open("rb") as handle:
            header = handle.read(5)
        if header != b"%PDF-" or pdf.stat().st_size < 1024:
            errors.append(f"{pdf.name}: invalid or unexpectedly empty PDF")
        if pdf.resolve() not in pdf_links:
            errors.append(f"{pdf.name}: no HTML download link points to the PDF")
    if not math_pages:
        errors.append("no rendered mathematical content was found")
    # A self-contained deployment must ship the configured renderer locally.
    mathjax_files = list((site / "assets" / "mathjax").glob("tex-*.js"))
    if not mathjax_files:
        errors.append("local MathJax renderer is missing from assets/mathjax")
    if errors:
        # Sidebar repetition can expose one broken target on every page.
        # Preserve useful locations but avoid printing identical diagnostics.
        for error in dict.fromkeys(errors):
            print(f"ERROR: {error}", file=sys.stderr)
        print(f"Site checks failed: {len(errors)} error(s).", file=sys.stderr)
        return 1
    print(f"Site checks passed: {len(pages)} pages, {links_checked} local links/assets, "
          f"{math_pages} math pages, {len(pdfs)} linked PDF(s).")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("site", nargs="?", type=Path, default=Path(__file__).resolve().parents[1] / "_site")
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--site-url", default="", help="override configured deployment URL/base path")
    args = parser.parse_args()
    return check(args.site.resolve(), args.root.resolve(), args.site_url)


if __name__ == "__main__":
    raise SystemExit(main())
