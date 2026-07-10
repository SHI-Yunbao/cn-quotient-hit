# JoLLI Submission Target

Primary target: *Journal of Logic, Language and Information* (JoLLI).

## Why This Journal

JoLLI is the best topical match for the current manuscript: its scope covers
the theoretical foundations of natural, formal, and programming languages and
interdisciplinary work on logic, language, and information.  The publisher
currently lists the journal in Science Citation Index Expanded (SCIE).

Sources checked on 2026-07-10:

- https://link.springer.com/journal/10849
- https://link.springer.com/journal/10849/submission-guidelines

`Mathematical Structures in Computer Science` remains a secondary target only
if the paper is reframed around a stronger formal or computational result.  Its
scope is theoretical computer science, whereas the current manuscript's main
contribution lies at the logic-language interface.

## Package Contents

- `../../paper/submission.tex`: anonymous review manuscript.
- `title-page.tex`: author-supplied title page and declarations template.
- `cover-letter.md`: cover-letter template.
- `preflight.sh`: machine checks for the manuscript; `ready` mode also rejects
  unfilled title-page placeholders.

## JoLLI Requirements Captured Here

The current guidelines require a 150--250 word abstract, 4--6 keywords,
author-year citations, editable source files plus a compiled PDF, and a title
page with author information.  They also require appropriate declarations.
Because the review copy must remain anonymous, author-specific material is kept
out of `submission.tex` and must be completed in `title-page.tex` before
submission.

Run `make -C work/paper jolli-preflight` during drafting.  Run
`make -C work/paper jolli-ready` only after completing the title page and
declarations; it intentionally fails while placeholders remain.
