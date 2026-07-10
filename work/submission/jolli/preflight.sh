#!/usr/bin/env sh
set -eu

MODE="${1:-draft}"
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)"
MANUSCRIPT="$ROOT/work/paper/submission.tex"
TITLE_PAGE="$ROOT/work/submission/jolli/title-page.tex"
ARTIFACT_MAP="$ROOT/work/submission/jolli/ARTIFACTS.md"

if [ "$MODE" != "draft" ] && [ "$MODE" != "ready" ]; then
  printf 'usage: %s [draft|ready]\n' "$0" >&2
  exit 2
fi

abstract_words=$(awk '
  /\\begin\{abstract\}/ { in_abstract = 1; next }
  /\\end\{abstract\}/ { in_abstract = 0 }
  in_abstract { print }
' "$MANUSCRIPT" | tr '\n' ' ' | tr -cd '[:alnum:] -' | wc -w | tr -d ' ')

if [ "$abstract_words" -lt 150 ] || [ "$abstract_words" -gt 250 ]; then
  printf 'Abstract has %s words; JoLLI requires 150--250.\n' "$abstract_words" >&2
  exit 1
fi

keywords=$(sed -n 's/^\\keywords{\(.*\)}/\1/p' "$MANUSCRIPT")
if [ -z "$keywords" ]; then
  printf 'Missing JoLLI keywords.\n' >&2
  exit 1
fi

keyword_count=$(printf '%s\n' "$keywords" | awk -F, '{ print NF }')
if [ "$keyword_count" -lt 4 ] || [ "$keyword_count" -gt 6 ]; then
  printf 'Expected 4--6 keywords; found %s.\n' "$keyword_count" >&2
  exit 1
fi

if ! grep -Fq 'authoryear]{natbib}' "$MANUSCRIPT"; then
  printf 'JoLLI author-year citation configuration is missing.\n' >&2
  exit 1
fi

if ! grep -Fq '\bibitem[' "$MANUSCRIPT"; then
  printf 'JoLLI author-year bibliography labels are missing.\n' >&2
  exit 1
fi

if [ ! -f "$ARTIFACT_MAP" ]; then
  printf 'Missing reproducibility artifact map.\n' >&2
  exit 1
fi

printf 'JoLLI drafting preflight passed: abstract=%s words; keywords=%s.\n' \
  "$abstract_words" "$keyword_count"

if [ "$MODE" = "ready" ]; then
  if grep -Eq '\[[A-Z][A-Z -]*\]' "$TITLE_PAGE"; then
    printf 'JoLLI ready preflight blocked: complete title-page.tex placeholders.\n' >&2
    exit 3
  fi
  if grep -Fq 'ARCHIVE URL' "$TITLE_PAGE"; then
    printf 'JoLLI ready preflight blocked: add the public code-archive URL.\n' >&2
    exit 3
  fi
  printf 'JoLLI ready preflight passed.\n'
fi
