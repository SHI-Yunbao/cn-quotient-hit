# 325-Page Draft: Research Archive Audit

## Scope and Method

This audit concerns `outputs/CN-quotient-HIT-draft.pdf` (325 pages) and its
source snapshot `work/paper/main.tex` (21,023 lines).  Classification follows
the source structure rather than the PDF page count.  In particular, it
separates semantic and formal results from automatically generated verification
ledgers.  The audit does not delete the long draft or its output artifacts.

## Findings

The source has eight top-level sections.  The first six, at lines 44--620,
form a coherent research-paper spine: introduction, related work, formal
account, three case studies, a comparison of setoid bookkeeping with quotient
elimination, and a statement of metatheoretic scope.  At line 621 it begins a
verification section.  Its opening summary is useful, but from line 643 onward
the document expands into a large, automatically generated inventory of proof
obligations, environment gates, and repeated stage records.  The inventory
continues until the short porting-obligations section at line 20,933.

The 325 pages therefore contain three different kinds of work, only one of
which belongs in a journal article.  They should be preserved, but released
and cited according to their different roles.

## Disposition

| Long-draft material | Evidence in source | Destination | Rationale |
| --- | --- | --- | --- |
| Motivation, related work, quotient-HIT proposal, and semantic scope | `main.tex`, lines 44--215 | Main JoLLI article, rewritten and condensed | This states the research question and contribution. |
| Passenger/person-times, modified CN, and book/copredication analyses | lines 216--401 | Main JoLLI article | These are the three linguistic tests; each now has checked Rocq anchors. |
| Setoid-bookkeeping comparison and adequacy target | lines 402--586 | Main JoLLI article, selectively expanded | This is the conceptual argument that distinguishes the paper from a code report. |
| Metatheoretic boundary and conditional converse | lines 587--620 | Main JoLLI article | This defines exactly what is and is not claimed. |
| Concise formalization summary | lines 621--642 | Main article plus selected appendix | Keep only the current Rocq gate and exact assumption boundary. |
| `CNSetoid`, quotient interface, passenger counterexample, one projection beta lemma, and assumption audit | `work/formal/coq/CNQuotientHit.v`; `AssumptionAudit.v` | Readable appendix (2--5 pages) and public repository | Enough code to let reviewers inspect the formal shape without turning the article into a listing. |
| Proof-obligation matrix, porting checklist, roadmap, and native-HIT migration plan | lines 20,933--20,953; `work/formal/coq/PORTING-OBLIGATIONS.md` | Supplementary research note / repository documentation | Valuable future-work and replication plan, but not evidence that the present interface is native. |
| Generated stage gates, installation ledgers, repeated rollups, and TSV filenames | principally lines 643--20,932 and `outputs/CN-quotient-HIT-stage*.tsv` | Archive only; exclude from submission and ordinary supplement | These preserve provenance of development, but are engineering traces rather than scientific exposition. |
| Limitations and next steps | lines 20,954--21,023 | Main JoLLI article, rewritten | Retain the honest boundary, remove references to obsolete automation states. |

## Publication Package

The publication package should have the following layers.

1. **Article.** The present `work/paper/submission.tex` is the controlled
   rewrite of the main-paper rows above.  It remains focused on the semantic
   claim, the conditional theorem, and the three linguistic tests.
2. **Readable appendix.** The manuscript appendix shows the setoid record,
   quotient interface, passenger counterexample, one quotient-recursion beta
   lemma, and the exact assumption-audit boundary.
3. **Versioned code release.** A public repository must contain the complete
   Rocq source, `AssumptionAudit.v`, Makefiles, artifact map, and a tag or
   commit hash.  Its URL and immutable revision identifier will be added to
   the manuscript only after the release exists.
4. **Research archive.** Retain the 325-page PDF, `main.tex`, and generated
   outputs outside the submission bundle.  It is a valuable laboratory record
   and source for a later methods/porting paper, but should not be offered as
   a journal supplement in its current generated form.

## Candidate Follow-on Paper

The strongest standalone follow-on direction is not a paper about the
automation ledger.  It is a native quotient-HIT realization and comparison:
implement the interface in a system with native quotient HIT support, prove
which of the five current interface parameters are supplied by that system,
and compare the Rocq interface fragment against the native development.  The
existing `PORTING-OBLIGATIONS.md` and matrix provide a starting roadmap, but
they require a genuine implementation before they become a publishable result.

## Acceptance Rule

No generated stage table, environment warning, or unexecuted porting gate may
be cited as a theorem or as machine-checked evidence in the article.  Only
the current Rocq compilation, the exact assumption audit, and named lemmas in
the released source may support such a claim.
