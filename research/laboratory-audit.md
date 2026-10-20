# Computational laboratory audit

Chapter: `15-computational-laboratory.qmd`.
Literature cutoff remains 20 October 2026; laboratory verification performed
21 October 2026. This chapter is an original pedagogical numerical laboratory,
not a report of new research or a numerical reproduction of frontier papers.

## Scope and scientific distinctions

- Explicit normalized coefficient convention C[a,z]; actual Born weights;
  exact first-moment identity C*C'; zero-probability handling.
- Correct Haar symmetric-subspace target and exact qubit Dicke-basis matrix.
- Bell ensemble exact second-moment trace distance 1/3.
- Global Haar finite-bath figure is a random-state concentration benchmark,
  not a proof of dynamical deep thermalization.
- Original exact average frame potential derived using independent Haar
  directions and Dirichlet(dA,...,dA) weights:
  1/Dk + (1-1/Dk)*(dA+1)/(dA*dB+1).
- Independent-state sampling bias and unbiased U-statistic distinguished from
  the exact Born-weighted frame potential of one physical ensemble.
- Scrooge sampler includes adjustment q/lambda_max; predicted acceptance
  1/(d*lambda_max); rank and roundoff policy specified.
- Fibonacci recursion averages every pre-gate prefix uniformly in gate number;
  exponentially spaced endpoints sample a different measure.
- Channel vectorization uses kron(conj(Uk),Uk), chronological concatenation
  Y.V*X.V, and averaging Y.S*Ad(X.V).
- Dense PXP construction has open boundaries and flip amplitude g=Omega/2;
  exact two-site and Z2 short-time-curvature checks.
- Small-chain revivals are not presented as thermodynamic scar stability or
  graph fragmentation. Haar allowed-space control is not matched in energy.
- Experimental conditioning, pure-state access costs, readout mixing, finite
  blockade leakage, physical-time weighting, and reproducibility are discussed.

## Bibliography

Uses existing verified keys only: HoChoi2022, IppolitiHo2022, Jozsa1994,
GoldsteinGAP2006, Mok2026, ergPilatowsky2023, ergPilatowsky2025,
turner2018scars, ho2019periodic, Chang2025. No bibliography changes.
The chapter attributes source-specific physics to those sources and derives
the elementary numerical and statistical identities independently.

## Figure-generator verification

Command: `julia --project=. scripts/generate_figures.jl`.
Julia: 1.12.6; standard libraries only.
Exit status: 0.

Numerical checks from the successful laboratory verification:

```
Scrooge empirical mean: 0.8012206944103777 (target 0.8)
Fragmentation sector: 8 vertices, 6 edges
```

The current generator produces 10 original SVG figures and 3 CSV files;
three conceptual diagrams were subsequently added during book integration.
The installed Julia version was independently reconfirmed as 1.12.6 with
`julia --version`. The laboratory author made no generator modifications.
Figure captions explicitly identify sample counts, finite-size assumptions,
and what the computations establish.

## Chapter-code verification

All nine Julia blocks were extracted in source order to the temporary file
`/tmp/ww-ho-laboratory-check.jl`, then executed with
`julia --project=. /tmp/ww-ho-laboratory-check.jl` (Julia 1.12.6).
All assertions passed, exit status 0. They cover Hermiticity, normalization,
positivity to roundoff, reduced-state identity, Bell second-moment distance,
Haar third-moment purity/rank, Scrooge sample normalization, independent
direct-versus-recursive Fibonacci prefix moments, Fibonacci final gate,
exact two-site PXP evolution, norm preservation, Z2 energy variance, initial
return probability, and initial imbalance.

The chapter contains over 3,800 prose words (code excluded), nine runnable
code blocks, ten substantial exercises, and three original generated figures.
Every equation label has the chapter-specific `eq-lab-` prefix; the chapter
identifier is `sec-computational-laboratory`. Cross-chapter labels were checked
against the existing chapter headings. No bibliography or script edits, Git
operations, or Quarto builds were performed by the laboratory author, to avoid
ownership and concurrent-build conflicts.
