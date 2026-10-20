# Source and derivation audit: projected ensembles and constrained randomness

Verification date: 2026-10-21. Primary arXiv metadata and available complete HTML manuscripts were checked; journal metadata were compared with publisher records when available. This audit covers chapters 05–07. Text, examples, and new derivations are original. No paper figures or manuscript files are redistributed.

## Primary sources and retained scope

| Key | Primary record | Status and scope retained |
|---|---|---|
| HoChoi2022 | https://arxiv.org/html/2109.07491v2 | PRL 128, 060601 (2022), DOI10.1103/PhysRevLett.128.060601. Exact all-fixed-order design statement for the specified self-dual kicked Ising protocol, edge subsystem, initial + product state, Z measurement, and infinite-bath limit. |
| IppolitiHo2022 | https://arxiv.org/abs/2208.10542 | Quantum6,886 (2022), DOI10.22331/q-2022-12-29-886. Solvable constriction/random-matrix-bath model with distinct design times; no generic-system formula inferred. |
| IppolitiHo2023 | https://arxiv.org/abs/2204.13657 | PRXQuantum4,030322 (2023), DOI10.1103/PRXQuantum.4.030322. Purification and dual-circuit mechanism, with compatible-state/measurement hypotheses. |
| Chang2025 | https://arxiv.org/html/2408.15325v2 | PRXQuantum6,020343 (2025), first preprint2024. Fixed-charge revealing result rigorous; restricted additional cases replica analytic; fully general case numerical. |
| Liu2024 | https://arxiv.org/html/2405.05470v2 | PRL133,260401 (2024). Heterodyne random-passive model theorem; general squeezed seeds and deep local optical circuits numerical. Covariances translated from vacuumI to vacuumI/2. |
| Shrotriya2025 | https://arxiv.org/html/2305.08437v3 | SciPostPhys18,107 (2025), first preprint2023. Specified bulk geometry, replica continuation and numerical support; OBC/PBC decay scales retained without claiming a general locality theorem. |
| Mok2026 | https://arxiv.org/html/2601.00266v3 | PRX16,041003 (2026), DOI10.1103/tb52-jxmx. Version3 theorem1 and corollary1 bounds transcribed with original regimes and error conventions. |
| Mark2024 | https://arxiv.org/abs/2403.11970 | PRX14,041051 (2024). Title includes initial “A”; corrected in master bibliography. |
| hjw1993 | https://www.sciencedirect.com/science/article/pii/0375960193908809 | PhysLettA183,14–18 (1993), DOI10.1016/0375-9601(93)90880-9. Canonical key replaces fragment key Hughston1993. |
| Jozsa1994 | https://journals.aps.org/pra/abstract/10.1103/PhysRevA.49.668 | PRA49,668–677 (1994). Single-copy accessible-information minimum, not an unqualified differential-entropy maximum. |
| GoldsteinGAP2006 | https://arxiv.org/abs/quant-ph/0309021 | JStatPhys125,1193–1221 (2006). Gaussian adjust-then-project construction. |
| Holevo2020, Holevo2021 | https://arxiv.org/abs/1908.03038 ; https://arxiv.org/abs/2102.01981 | Gaussian optimization; gauge symmetry/threshold conditions retained. |
| Weedbrook2012 | https://arxiv.org/abs/1110.3234 | RMP84,621–669 (2012). Explicitly a background review. |

## New chapter05/06 integration

Parent authorized substantive enhancements to chapters05/06 during the audit. Added complete kicked Ising specification with boundary phases, explicit theorem and bath limit, elementary gate matrices, and an original coisometry/Haar/Born-weight calculation. Added temporal Scrooge bound O(k/sqrt(d_eff)) for d_eff≫k^4, multiset no-resonance criterion, normalization-variance derivation, exact flat-phase second moment comparison, global2k-to-local-k bound, and Markov probability interpretation. Parent owns subsequent figure insertion. No further chapter edits planned after handoff.

## Exact algebra reviewed

- Born projected moments reproduce the reduced state at first order and reduce correctly under replica partial traces.
- Haar symmetric dimensions, frame-potential excess, and rank-derived trace-distance bounds have correct normalization.
- Scrooge qubit density is 2a²b²/[a+(b−a)y]³; omitting adjustment gives the stated incorrect mean.
- Haar accessible information is log(d)+1−H_d, with natural-log units.
- Charge-revealing hypergeometric weights use one sector probability, not its kth power; conditional mean R_nu follows directly from sector projectors.
- New normalization variable X=D<phi|sigma|phi> has variance [D Tr(sigma²)−1]/(D+1), bounded by Tr(sigma²).
- Flat random-phase versus Haar second-moment distance is (D−1)/[D(D+1)]; D=2 gives1/6.
- Gaussian Schur complement, conditional-mean covariance, two-mode squeezed-pair heterodyne/homodyne limits, thermal coherent mixture, and heterodyne mutual information agree with vacuum covarianceI/2 conventions.
- Cluster-chain conditional amplitudes produce the stated X/Z ensembles while preserving the unconditioned density matrix.
- Explicit two-qubit Ising identity uses local S phases and CZ; no claim is made that the isolated diagonal gate is itself dual-unitary.

## Findings and limits

No unresolved formula error was identified in chapters05–07. Initial pedagogical gaps in model specification and quantitative 2026 design bounds were filled with parent authorization. The canonical HJW citation replacement was made directly in chapter05. Higher-order exact design claims continue to state the infinite-bath limit. Gaussian universality continues to distinguish proved coherent-measurement cases from numerically supported extensions. Rendering, links, and displayed mathematical layout remain the parent's build/QA task.
