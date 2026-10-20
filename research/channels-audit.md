# Source and derivation audit: channels, memory, and constraints

Verification date: 2026-10-21. Reviewed chapters11–14 without editing them. Primary abstracts, metadata, and selected full manuscripts checked. No downloaded source manuscripts or publication figures are redistributed.

## Recent primary sources

| Key | Primary record | Verified status / qualification |
|---|---|---|
| huang2026kraus | https://arxiv.org/html/2609.12689v1 | Submitted11September2026, preprint. Author order Huang, Mok, Haug, Ho. Generic-circuit Ginibre×log-normal statement is a conjecture supported by analysis and numerics; specified global-Haar/dual-unitary limits have proofs. |
| vilkoviskiy2025transition | https://arxiv.org/html/2511.03846v2 | Submitted5November2025, v2 revised26November2025; no journal citation asserted. Solved random-unitary bath, kicked Ising analysis, generic-model numerics distinguished. |
| liuho2025solvable | https://arxiv.org/abs/2312.12239 | PRResearch7,L012011 (2025), DOI10.1103/PhysRevResearch.7.L012011; first preprint2023. First author Chuan Liu, not Chang Liu. Special compatible initial-state families yield simple influence matrices. |
| datla2026statistical | https://www.nature.com/articles/s41567-026-03183-w | NatPhys22,355–361 (2026), DOI10.1038/s41567-026-03183-w; online18February2026, March issue. Journal title differs slightly from preprint2505.18143. |
| foligno2023temporal | https://arxiv.org/abs/2302.08502 | PRX13,041008 (2023). Entanglement of specified influence representation, not an unrestricted computational-hardness theorem. |

## Foundational sources checked

- Stinespring1955: ProcAMS6,211–216; DOI10.1090/S0002-9939-1955-0069403-4. Direct AMS article access unavailable; metadata confirmed in publisher-hosted AMS references and original issue archive. Chapter11 supplies an independent finite-dimensional proof.
- Choi1975: LinearAlgebraAppl10,285–290; DOI10.1016/0024-3795(75)90075-0; publisher record verified via indexed primary page.
- Pollock2018framework/operational: arXiv1512.00589 and1801.09811; PRA97,012127 / PRL120,040405. Whole-intervention Markov condition distinguished from CP divisibility.
- Turner2018scars and Ho2019periodic: arXiv1711.03528 /1807.01815; PRL122,040603 for the latter; variational orbit is not asserted to be an exact quantum trajectory.
- Sala2020fragmentation, Khemani2020shattering, Rakovszky2020statistical: arXiv1904.04266 /1910.01137 /1910.06341; strong-vs-weak statistical weighting retained.
- Abanin2017effective/rigorous: arXiv1510.03405 /1509.05386; PRB95,014112 / CMP354,809–827. The rigorous bound has logarithmic corrections; chapter14 does not replace it with an unconditional pure exponential.
- Else2017prethermal /Else2020quasiperiodic: arXiv1607.05277 /1910.03584; PRX7,011026 /PRX10,021032. Effective ordering, smoothness, arithmetic, and heating-window hypotheses preserved.

## Exact calculations reviewed

- Amplitude-damping Kraus completeness, channel output, and output-first unnormalized Choi matrix agree. Reconstruction uses rho transpose correctly; Choi trace equals d_S.
- Double SWAP stores the initial input in the bath across an identical system reset, correctly witnessing operational memory.
- Kraus universality normalization sqrt(d_S d_B) and logY mean−sigma²/variance sigma² match the primary conjecture; E Y²=1 and E Y⁴=exp(4sigma²). Born tilting preserves normalized Haar directions because radial factors are independent of direction.
- Multi-time process contraction conventions consistently transpose complete intervention Choi matrices; initial correlated states are included at process level.
- Controlled influence functional is a positive history Gram matrix; factorization follows for fresh independent baths.
- Entropies belong to the specified normalized influence vector and cut. Classical shared-label vectorization need not imply distillable quantum memory. The example spectrum has S1=log2+(logD)/2 and S2→log4.
- Two-site PXP bright/dark solution and the graph-connectivity argument are correct. Bond-dimension-two matrices kill adjacent excitations and reproduce allowed product amplitudes. Real-coordinate projected TDVP has the displayed sign.
- Six-site pair-hopping example preserves Q=2,P=7 and decomposes into frozen1D plus active2D fragments. The fragment-projector Mazur bound uses correct dimension weights.
- Order-statistic variance is exact for the stated independent continuous positions; the chapter explicitly treats lattice/exclusion modifications and does not infer a fixed localization length.
- Two-step BCH commutator sign, induced YZ couplings, high-frequency optimal-truncation estimate, finite-order symmetry algebra, and small-denominator Fourier generator checked.

## Findings and caution for final QA

No substantive unresolved mathematical error was identified in chapters11–14. The generic Kraus scaling source requires lambda≥0 and gamma>1; chapter11's formula uses these constants but should display their range if touched again. This is a clarity improvement, not a contradiction in its stated law. The temporal-entanglement manuscript remains labeled a preprint, including the mixed analytic/numerical level of evidence. Generic freezing, universal efficient simulation, and exact infinitely lived prethermal order are not claimed.
