:Namespace manualallocation_tests

S←':Namespace' 'F←{⊢⍵}' ':EndNamespace'

manualallocation_TEST←{CS←'manualallocation'#.codfns.Fix S
 #.UT.expect←⍳5
 ptr←'manualallocation'#.codfns.MKA ⍳5
 z←'manualallocation'#.codfns.EXA ptr
 _←'manualallocation'#.codfns.FREA ptr
 z}

:EndNamespace
