# Quantum Dynamics Beyond Thermal Equilibrium

A self-contained graduate web textbook on ensembles, ergodicity, quantum
resources, memory, and constrained many-body dynamics. Its scientific backbone
is research by Wen Wei Ho and collaborators, particularly 2024–2026, organized
by concepts rather than by authors.

**Read:** https://xing-phys.github.io/quantum-dynamics-beyond-equilibrium/

## Build

Required: Quarto **1.10.18**. For PDF, install LuaLaTeX with TeX Gyre Pagella,
Heros, and Pagella Math plus DejaVu Sans Mono (or run quarto install tinytex).
SVG figures also require rsvg-convert. On Ubuntu the system packages are
librsvg2-bin, fonts-texgyre, fonts-texgyre-math, and fonts-dejavu-core.
For regenerating original numerical figures: Julia **1.10+**, standard
libraries only. No Python notebook or external plotting package is required.

    julia --project=. scripts/generate_figures.jl
    julia --project=. scripts/check_laboratory.jl
    python3 scripts/check_sources.py
    quarto render
    python3 scripts/check_site.py _site
    quarto preview --no-browser

HTML is written to _site/; the combined PDF is
_site/quantum-dynamics-beyond-equilibrium.pdf. Build only the website with
quarto render --to html. Use --no-clean when rendering a single format if
you want to retain the other format's existing output. MathJax 3.2.2 and fonts
are bundled locally. The vector macro vct uses matching bold italic symbols
in HTML and PDF.

## Organization

- Numbered QMD files: sixteen teaching chapters.
- Appendices: mathematical tools, selected solutions, annotated literature.
- assets/: typography, matching HTML/PDF macros, bibliography and CSL.
- figs/: original figures and source data.
- scripts/: reproducible Julia computations and source/link checks.
- research/: source audit notes and the teaching architecture.
- .github/workflows/publish.yml: build, check, GitHub Pages deployment.

Edit a chapter, commit, and push to main; GitHub Actions renders and deploys
the site. The repository Pages source is GitHub Actions. Pull requests build
without deploying. The workflow also builds the PDF with TinyTeX and installs
the TeX Gyre font packages into that TeX installation before rendering.
Local generated output and caches are ignored by Git.

Optional mathematical syntax validation uses the matching pinned MathJax parser:

    npm ci
    npm run check:math

This compiles all formulas and checks custom macros. It does not prove
scientific claims or replace visual layout inspection.

## Scientific and editorial policy

Literature cutoff: **20 October 2026**. Exact identities, source-specific
theorems, numerical observations, and conjectures are identified in the text.
References were checked against primary papers and publication records.
Derivations are independently written; figures are original. This is an
AI-assisted educational synthesis, not an endorsement by the cited researchers.
Report scientific or pedagogical errors through GitHub Issues. Selected
solutions are supplied; other exercises remain open for study and discussion.

## License

Original prose and figures: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
Original code: MIT. See LICENSE. MathJax retains its Apache 2.0 license.
The APS CSL retains its upstream attribution and license.
