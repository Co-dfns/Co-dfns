:Namespace manualallocation_tests

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

manualallocation∆gcc_TEST←'gcc'RUN∆TEST
manualallocation∆icc_TEST←'icc'RUN∆TEST
manualallocation∆pgcc_TEST←'pgcc'RUN∆TEST
manualallocation∆vsc_TEST←'vsc'RUN∆TEST


:EndNamespace
