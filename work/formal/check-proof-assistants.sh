#!/usr/bin/env sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"

load_coq_platform_env() {
  for env_script in \
    "/Applications/Rocq-Platform~9.0~2025.08.app/Contents/Resources/bin/coq-env.sh" \
    "/Applications/Coq-Platform~9.0~2025.08.app/Contents/Resources/bin/coq-env.sh"
  do
    if [ -f "$env_script" ]; then
      eval "$("$env_script")"
      return 0
    fi
  done
  return 1
}

load_coq_platform_env >/dev/null 2>&1 || true

case "${1:-coq}" in
  dry-run)
    printf 'cd %s/work/formal/coq && coqc CNQuotientHit.v\n' "$ROOT"
    printf 'cd %s/work/formal/agda && agda CNQuotientHitSkeleton.agda\n' "$ROOT"
    ;;
  probe)
    command -v coqc
    command -v agda
    ;;
  coq)
    cd "$ROOT/work/formal/coq"
    exec coqc CNQuotientHit.v
    ;;
  agda)
    cd "$ROOT/work/formal/agda"
    exec agda CNQuotientHitSkeleton.agda
    ;;
  all)
    # Optional cross-check across both mechanisations; not the SCI gate.
    "$0" coq
    "$0" agda
    ;;
  *)
    printf 'usage: %s [dry-run|probe|coq|agda|all]\n' "$0" >&2
    exit 2
    ;;
esac
