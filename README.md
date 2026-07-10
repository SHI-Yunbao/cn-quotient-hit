# CN-as-setoids to CNs-as-quotient-HITs

This repository is the reproducibility artifact for the manuscript
*Internalizing Common-Noun Identity Criteria with Quotient Higher Inductive
Types*.

It contains a Rocq-checked semantic fragment for the transition from common
nouns represented as setoids to quotient-HIT presentations.  The artifact
checks a deliberately explicit interface rather than claiming a native
quotient-HIT implementation in plain Rocq.

## What is checked

The Rocq development defines common-noun setoids, an explicit quotient-HIT
interface, and three linguistic test fragments:

- passenger identity is finer than person identity when journeys differ;
- distinct modifier witnesses do not produce extra modified-CN instances;
- physical and informational observations of a book descend separately while
  book identity is conjunctive.

The packaged conditional converse theorem is audited to depend globally only
on the five quotient-interface parameters `qtype`, `embed`, `glue`, `qrec`,
and `qrec_beta`.  Function extensionality, proof irrelevance, and quotient
proposition induction are explicit theorem premises, not global axioms.

## Reproduce

The artifact was checked with Rocq Platform 9.0.1.  From the repository root:

```sh
make -C work/formal proof-assistant-sci
make -C work/paper jolli-preflight
make -C work/paper submission.pdf
```

The first command compiles the Rocq source and performs the exact
global-assumption audit.  The second checks the JoLLI drafting constraints; the
third builds the anonymous manuscript PDF.

## Repository layout

- `work/formal/coq/`: Rocq source and the assumption audit.
- `work/paper/`: anonymous JoLLI manuscript source and reviewed PDF.
- `work/submission/jolli/`: artifact map, title-page template, cover-letter
  template, and submission preflight.

The 325-page research archive and historical generated automation tables are
intentionally excluded.  Their publication role and disposition are recorded
in `work/submission/jolli/RESEARCH-ARCHIVE-AUDIT.md`.

## Citation and license

Please cite the associated manuscript and this tagged release.  Metadata are
provided in `CITATION.cff`.  The artifact code is released under the MIT
License; the manuscript remains subject to its publication status and any
publisher terms.
