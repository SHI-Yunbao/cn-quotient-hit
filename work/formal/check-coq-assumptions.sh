#!/usr/bin/env sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
COQ_DIR="$ROOT/work/formal/coq"

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

audit_output="/tmp/cn_qhit_coq_assumptions_output.$$"
actual_assumptions="/tmp/cn_qhit_coq_assumptions_actual.$$"
expected_assumptions="/tmp/cn_qhit_coq_assumptions_expected.$$"

cleanup() {
  rm -f "$audit_output" "$actual_assumptions" "$expected_assumptions"
  rm -f "$COQ_DIR"/*.vo "$COQ_DIR"/*.vok "$COQ_DIR"/*.vos
  rm -f "$COQ_DIR"/*.glob "$COQ_DIR"/.*.aux
}
trap cleanup EXIT HUP INT TERM

cd "$COQ_DIR"
coqc CNQuotientHit.v >/dev/null
if ! coqc AssumptionAudit.v >"$audit_output" 2>&1; then
  sed -n '1,120p' "$audit_output" >&2
  exit 1
fi

awk '
  /^Axioms:/ { in_axioms = 1; next }
  in_axioms && /^[A-Za-z0-9_.]+[[:space:]]*:/ {
    name = $0
    sub(/[[:space:]]*:.*/, "", name)
    print name
  }
' "$audit_output" | sort -u >"$actual_assumptions"

printf '%s\n' \
  'QuotientHIT.embed' \
  'QuotientHIT.glue' \
  'QuotientHIT.qrec' \
  'QuotientHIT.qrec_beta' \
  'QuotientHIT.qtype' \
  >"$expected_assumptions"

if ! diff -u "$expected_assumptions" "$actual_assumptions"; then
  printf '%s\n' 'Unexpected global assumptions for conditional_observation_equivalence' >&2
  exit 1
fi

for forbidden in \
  Phi_Psi_inverse \
  Psi_Phi_inverse \
  funext_global_axiom \
  proof_irrelevance_global_axiom \
  quotient_induction_global_axiom
do
  if grep -Fq "$forbidden" "$audit_output"; then
    printf 'Forbidden global assumption found: %s\n' "$forbidden" >&2
    exit 1
  fi
done

printf '%s\n' 'Exact global assumption set verified for conditional_observation_equivalence'
sed -n '/^Axioms:/,$p' "$audit_output"
