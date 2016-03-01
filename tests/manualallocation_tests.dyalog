:Namespace manualallocation

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'F←{⊢⍵}' ':EndNamespace'

RUN∆TEST←{~(⊂⍺⍺)∊#.codfns.TEST∆COMPILERS:0⊣#.UT.expect←0
  #.codfns.COMPILER←⍺⍺ ⋄ CS←'manualallocation'#.codfns.Fix S
  #.UT.expect←⍳5
  ptr←'manualallocation'#.codfns.MKA ⍳5
  pt2←'manualallocation'#.codfns.MKA ⍳5
  _←'manualallocation'#.codfns.FREA pt2
  'manualallocation'#.codfns.EXA ptr 1
}

MANUALALLOCATION∆GCC_TEST←'gcc'RUN∆TEST
MANUALALLOCATION∆ICC_TEST←'icc'RUN∆TEST
MANUALALLOCATION∆PGCC_TEST←'pgcc'RUN∆TEST
MANUALALLOCATION∆VSC_TEST←'vsc'RUN∆TEST


:EndNamespace