# Source audit: temporal ergodicity, aperiodic driving, resource transitions

Checked against primary arXiv metadata and complete HTML manuscripts on 2026-10-20. All exposition is original; no publication figures were copied. Files owned by this contribution: `08-temporal-ergodicity.qmd`, `09-aperiodic-drives.qmd`, `10-resource-transitions.qmd`, this audit, and `ergodicity-sources.bib`. No Git mutation or render performed by this contributor.

## Primary research backbone

| Key | Primary source checked | Metadata / status | Scientific scope retained in text |
|---|---|---|---|
| ergPilatowsky2023 | https://arxiv.org/html/2306.11792v2 | PRL **131**,250401(2023); 10.1103/PhysRevLett.131.250401 | Canonical generalized Fibonacci theorem identifies Haar time-average **assuming existence of the limit**; almost-all gate pairs SU(d), arbitrary finite d. Limit existence for suitable almost-all phase-shifted relatives, canonical word supported numerically. No universal power-law rate theorem. |
| ergPilatowsky2024 | https://arxiv.org/html/2402.06720v2 | PRX **14**,041059(2024); 10.1103/PhysRevX.14.041059 | Static population obstruction; finite-action Floquet all-order obstruction; m<2(d−1) state obstruction assumes piecewise-smooth quasienergy eigenstate; m<d(d−1) unitary obstruction assumes a basis; construction m=d²−2, not proof necessity=sufficiency. Fixed-k periodic possibility differs from all-k. Action lower bound Eq14 checked. |
| ergPilatowsky2025 | https://arxiv.org/html/2502.06936v2 | PRL **135**,140402(2025); 10.1103/dmfd-lgcq | Theorem1: almost every pair **SU(2)** gives Thue–Morse CUE/CHSE. Higher d and other substitutions: numerical. Exact qubit xi map, recurrence plus monotone proof distinguished from numerical first-return exponent n^(−3/2), heavy-tail physical clock. Thue–Morse is aperiodic/morphic, not smoothly finite-tone quasiperiodic. |
| ergLiu2026 | https://arxiv.org/abs/2507.05706 and full HTML | PRL **136**,020401(2026); 10.1103/6msb-cxbc | NV diamond spin, tomography, finite-time hierarchy evidence. Author **Zouwei Pan**, verified primary (search aggregators incorrectly give Zhiqiang). Does not experimentally prove all moments or infinite time. |
| ergLiuIppoliti2026 | https://arxiv.org/html/2510.18369v2 and abs | PRL **136**,100404(2026); 10.1103/mjgs-y2z9 | Mixed-basis support-counting threshold α0+αm=1; Born conditional sparse outcomes essential; complex vs real Haar distinguished. Tilted entropy matching approximate: 0.181π prediction vs 0.193π observed. Generic thermalizing input restrictions, including uniform-plus invariant exception. |
| ergFeng2026 | https://arxiv.org/html/2606.08756v1 and abs | 2026 preprint; no journal metadata asserted | Block-sharpening / localizability framework; collision entropy density criterion in specified scrambling models, no universal theorem for every abstract QRT. Pauli coherence is not magic; Clifford permutations preserve algebra and independent-intersection step is conjectural. Doubled operator-space threshold2 and generic numerical magic agreement, Clifford exceptions. |
| ergMark2026 | https://arxiv.org/abs/2609.30248 and full HTML | Review preprint submitted2026-09-24 | Authors Daniel K.Mark, Manuel Endres, Matteo Ippoliti, Wen Wei Ho, Soonwon Choi. Used for conceptual orientation; research claims cite original papers. |

## Foundational bibliography verification

- Gross, Audenaert, Eisert: arXiv quant-ph/0611002 metadata; J.Math.Phys.48,052104(2007); DOI10.1063/1.2716992. Design/frame-potential toolkit.
- Baumgratz, Cramer, Plenio: arXiv1311.0275 plus APS full text; PRL113,140401(2014); DOI10.1103/PhysRevLett.113.140401. Coherence relative to specified basis.
- Chitambar, Gour: arXiv1806.06107 plus APS accepted manuscript; RMP91,025001(2019); DOI10.1103/RevModPhys.91.025001. Resource-theory definitions.
- Leone, Oliviero, Hamma: arXiv2106.12587 metadata; PRL128,050402(2022); DOI10.1103/PhysRevLett.128.050402. Pure-state stabilizer Rényi diagnostic; no unsupported all-order resource monotonicity claim.

## Original derivations and exact checks

- Qubit equatorial temporal second moment: symmetric eigenvalues(1/4,1/2,1/4), Haar(1/3,1/3,1/3), trace distance1/6.
- Static population witness: matching first order forces p_a=1/d, inconsistent with Haar E[p_a²]=2/[d(d+1)]. No nonresonance assumption needed for this witness.
- State frame-potential identity: ||M−M_H||₂²=F−1/D_k and trace-norm bounds with rank D_k.
- Prefix-channel concatenation / Fibonacci / Thue–Morse recurrences derived with chronological products reversed. Sample prefixes include t=0, omit final endpoint.
- Bitstring-vs-Haar second-moment trace distance(d−1)/(d+1), IPR1 vs2/(d+1).
- Real-Haar IPR3/(d+2), complex-Haar average coherence(H_d−1)/ln2, explicitly distinguishes imaginarity.
- Subsystem-specific support count λ_a=KM/2^N retains the fixed-N_A prefactor; threshold exponent agrees with source.
- U(1) block collision entropy: sum binomial(N,q)²/4^N=binomial(2N,N)/4^N, H₂~(1/2)log₂(πN), hence zero extensive density.
- T-state stabilizer Rényi2: M₂=log₂(4/3), while coherence matches the stabilizer |+> state.

## Integration requirements

Include `research/ergodicity-sources.bib` in Quarto bibliography, or merge the entries while preserving unique `erg...` citation keys. All equation labels begin `eq-te-`, `eq-ad-`, or `eq-rt-`. Chapter anchors are `sec-temporal-ergodicity`, `sec-aperiodic-drives`, `sec-resource-transitions`. Each file has one H1. Exercise lists include hints and distinguish proposed projects from established claims. Parent render/QA should check all formulas, citations, and cross-references. The source manuscript downloads used during research are temporary files under `/tmp`, not tracked redistributions.
