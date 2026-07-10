LATEXMK ?= latexmk

.PHONY: all main submission submission-author jolli-preflight jolli-ready clean

all: main submission

main: main.pdf

submission: submission.pdf

submission-author: submission-author.pdf

jolli-preflight: submission.pdf
	sh ../submission/jolli/preflight.sh draft

jolli-ready: submission.pdf
	sh ../submission/jolli/preflight.sh ready

main.pdf: main.tex
	$(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error main.tex

submission.pdf: submission.tex
	$(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error submission.tex

submission-author.pdf: submission-author.tex
	$(LATEXMK) -xelatex -interaction=nonstopmode -halt-on-error submission-author.tex

clean:
	$(LATEXMK) -C main.tex
	$(LATEXMK) -C submission.tex
