# Reproducibility Artifact Map

This map is the source-package counterpart of Table 2 in the JoLLI manuscript.
All commands are run from the repository root.

| Paper claim | Source artifact | Verification command |
| --- | --- | --- |
| Quotient interface and linguistic lemmas | `work/formal/coq/CNQuotientHit.v` | `make -C work/formal proof-assistant-coq` |
| Conditional converse representation | `conditional_observation_equivalence` in `CNQuotientHit.v` | `make -C work/formal proof-assistant-sci` |
| Exact global-assumption boundary | `work/formal/coq/AssumptionAudit.v`, `work/formal/check-coq-assumptions.sh` | `make -C work/formal proof-assistant-coq-assumptions` |
| JoLLI anonymous-manuscript formatting | `work/paper/submission.tex`, `work/submission/jolli/preflight.sh` | `make -C work/paper jolli-preflight` |

## Versioned Release

The public reproducibility repository is
[`SHI-Yunbao/cn-quotient-hit`](https://github.com/SHI-Yunbao/cn-quotient-hit),
tagged `v0.1.0-jolli-submission`.  It contains the exact anonymous manuscript
source, Rocq source, assumption audit, and build instructions used for this
submission package.  Zenodo deposition is not part of this submission.
