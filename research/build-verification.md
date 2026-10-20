# Build verification

Local verification completed 21 October 2026. Literature cutoff: 20 October 2026.

- Quarto 1.10.18; LuaHBTeX/TeX Live 2023; rsvg-convert2.58.0.
- Julia1.12.6: all nine laboratory examples and analytical assertions pass.
- Original figure generator succeeds:10 SVGs and3 CSV data files.
- Source validator:21 documents,302 labels,47 cited works,13 figure uses.
- Matching MathJax3.2.2 parser compiles all2866 math expressions.
- Full multi-format render succeeds. Combined PDF:170 A4 pages.
- Site validator:21 pages,1913 local links/assets,21 math pages, one linked PDF.
- Front matter is unnumbered; teaching chapters run1–16; appendices runA–C.
- PDF log has no undefined references, missing glyphs, overfull boxes, or
  substituted bold-math fonts. One underfull paragraph is a harmless spacing
  diagnostic; representative page images show readable output.
- Visually inspected title, equations, quantitative theorem, numerical figure,
  and laboratory pages using Poppler rasterization.
- Browser inventory was empty and the in-app browser was unavailable. Live
  interactive browser checks of responsive navigation, search, and theme
  switching could not be performed. The local assets, search index, generated
  navigation links, responsive CSS, and math syntax were checked statically.

The workflow runs the numerical and mathematical checks, renders HTML and PDF
together, validates links, and deploys the resulting artifact through GitHub
Pages. A single-format Quarto render clears the output directory unless
--no-clean is passed; building both formats in one invocation avoids that trap.

These checks verify build integrity and the stated examples. They do not
constitute an independent proof of every scientific claim. Source-specific
theorem assumptions and preprint status remain explicit in the textbook.
