#!/bin/bash
mkdir woven
noweave -delay -index codfns.nw > woven/codfns.tex
cd woven
xelatex codfns
xelatex codfns
