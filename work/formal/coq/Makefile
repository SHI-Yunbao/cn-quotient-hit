COQC ?= coqc

.PHONY: all clean

all: CNQuotientHit.vo

CNQuotientHit.vo: CNQuotientHit.v
	$(COQC) CNQuotientHit.v

clean:
	rm -f *.vo *.vok *.vos *.glob .*.aux
