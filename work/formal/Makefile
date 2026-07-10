.PHONY: proof-assistant-dry-run proof-assistant-probe proof-assistant-coq proof-assistant-coq-assumptions proof-assistant-sci proof-assistant-agda proof-assistant-all

proof-assistant-dry-run:
	sh check-proof-assistants.sh dry-run

proof-assistant-probe:
	sh check-proof-assistants.sh probe

proof-assistant-coq:
	sh check-proof-assistants.sh coq

proof-assistant-coq-assumptions:
	sh check-coq-assumptions.sh

# Required mechanisation gate for the current SCI submission.  Agda remains an
# optional cross-check and is intentionally not a prerequisite of this target.
proof-assistant-sci: proof-assistant-coq proof-assistant-coq-assumptions

proof-assistant-agda:
	sh check-proof-assistants.sh agda

proof-assistant-all:
	sh check-proof-assistants.sh all
