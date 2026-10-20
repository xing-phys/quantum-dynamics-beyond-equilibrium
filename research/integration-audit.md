# Bibliography and scientific integration audit

Completed 2026-10-21 for the graduate Quarto textbook. This contributor initially owned the master bibliography, literature guide, and three research audits; the parent subsequently authorized direct expansion of chapters05/06. No Git operations, build, deployment, new source downloads for redistribution, or publication-figure reuse were performed by this contributor.

## Deliverables

- `assets/bibliography.bib`:47 unique records, from43 fragment records plus4 additional foundational works. Every entry has author/title/year; all BibTeX braces balance; no duplicate citation keys or DOI values.
- `c-literature-guide.qmd`: concept-organized annotated routes covering every master citation key, with a15-row status/chronology table for relevant2024–2026 publications/preprints.
- `research/ensemble-audit.md`: source and formula review for05–07, including authorized expansions in05/06.
- `research/channels-audit.md`: source and formula review for11–14.
- Existing `research/ergodicity-audit.md` remains the detailed specialist audit for08–10; its caveats were preserved in the guide and checked against the chapters.

## Canonical keys and metadata

All fragment keys are preserved except the parent-approved consolidation `Hughston1993 → hjw1993`. Chapter05 was changed to the canonical key; chapter02 already used it. The duplicate alias was deliberately not retained. The review key is `ergMark2026`; parent replaced the earlier index reference `mark2026review` rather than adding another record.

Additional foundational keys are `deutsch1991`, `srednicki1994`, `popescu2006`, and `ambainis2007`. The HJW record already existed in the ensemble fragment and was canonicalized, not duplicated. Popescu's published title and different arXiv title are distinguished in the record. Ambainis/Emerson is cited through the verified arXiv record without inventing proceedings metadata. The master Mark2024 title now includes the initial “A” present in the primary record.

The project uses only the master bibliography. Research fragments retain their provenance and are not intended to be concatenated with the master at render time.

## Critical recent status checks

| Topic | Citation | Verified status |
|---|---|---|
| Scrooge universality | Mok2026 | PRX16,041003 (2026); DOI10.1103/tb52-jxmx. arXiv2601.00266v3 checked. |
| Coherence transition | ergLiuIppoliti2026 | PRL136,100404 (2026); DOI10.1103/mjgs-y2z9. |
| Quantum-resource localizability | ergFeng2026 | arXiv2606.08756v1, preprint. |
| Kraus universality | huang2026kraus | arXiv2609.12689v1, submitted11September2026, preprint. |
| Temporal entanglement transition | vilkoviskiy2025transition | arXiv2511.03846v2, preprint; no journal publication asserted. |
| Statistical localization experiment | datla2026statistical | NaturePhysics22,355–361 (2026), DOI10.1038/s41567-026-03183-w; online18February2026. |
| Single-spin ergodicity experiment | ergLiu2026 | PRL136,020401 (2026), DOI10.1103/6msb-cxbc; author name Zouwei Pan verified. |
| General overview | ergMark2026 | arXiv2609.30248v1, submitted24September2026, review preprint. |

Primary metadata links are in the master records; specific source links and distinctions between proof/numerics/conjecture are recorded in the other audits. Journal publication status was not inferred from a preprint's year or from an arXiv-issued DOI.

## Scientific review of chapters05–14

The review found no unresolved substantive formula error in the existing chapters. Their central distinctions are correct: a reduced density operator is a first moment; Scrooge sampling requires a Born adjustment; finite bath rank limits exact designs; static populations obstruct global Haar moments; smooth-quasiperiodic no-go statements need reducibility hypotheses; generic Kraus universality is conjectural; influence-vector entropy depends on representation/cut; scars and graph fragmentation are different mechanisms; and a prethermal theorem does not prove equilibration or an eternally stable phase.

Parent was informed of two pedagogical gaps: no explicitly specified kicked Ising exact-design model in05 and no quantitative2026 design bounds in06. Both were filled with authorization. Added hypotheses and calculations were checked against primary equations and independently derived where elementary. These include the coisometry/Born-weight Haar reduction, the normalization variance, the flat random-phase trace distance, and the probability conversion of a generator-average bound.

One minor clarity suggestion remains for chapter11: explicitly give lambda≥0 and gamma>1 after the displayed Kraus scaling. The source requires these ranges. Parent was notified; this contributor did not edit chapter11.

## Source-level validation

A source scan found47 keys, zero duplicate keys, zero duplicate DOIs, balanced BibTeX entries, all47 keys explicitly mapped by the guide, and no unresolved citations or cross-references introduced by this contribution. A naive all-QMD regex reports Julia's `@assert` macro as a citation; this is a code-fence false positive rather than a missing reference. The guide's initial anchor typo was corrected from `sec-states-information` to the actual `sec-states` before handoff.

Display-math delimiters in the edited chapters are balanced. Final HTML/PDF typography, equation wrapping, cross-reference rendering, bibliography rendering, and deployed navigation require the parent's build and visual QA. This audit does not claim those checks were performed here.
