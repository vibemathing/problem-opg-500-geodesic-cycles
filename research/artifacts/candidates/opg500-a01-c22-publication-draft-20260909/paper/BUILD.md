# Paper build

**DRAFT — NOT YET EXTERNALLY PEER REVIEWED**

Required existing tools: `pdflatex`, `bibtex`, and a TeX installation containing `amsart`, `booktabs`, `hyperref`, and `tikz`.

```bash
cd paper/figures
pdflatex -halt-on-error -interaction=nonstopmode figure-standalone.tex
cp figure-standalone.pdf counterexample-graph.pdf
cd ..
latexmk -pdf -halt-on-error -interaction=nonstopmode main.tex
pdfinfo main.pdf
pdffonts main.pdf
```

The manuscript inputs the TikZ source directly; `counterexample-graph.pdf` is also supplied as the independently viewable vector figure. The authoritative construction is the printed edge list, not the drawing.

For a clean rebuild, remove only generated TeX auxiliaries in a disposable copy of this publication directory. Do not modify the fixed sources under `inputs/fixed-revision/`.
