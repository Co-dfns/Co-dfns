#!/bin/bash
mkdir -p woven
noweave -delay -index codfns.nw > woven/codfns.tex
cd woven
xelatex --shell-escape codfns
xelatex --shell-escape codfns
