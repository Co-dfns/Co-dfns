:Namespace indexgen

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'Run←{⍳⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

INDEXGEN∆I∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/indexgeni'C.Fix S
  #.UT.expect←NS.Run∘I¨⍳5 ⋄ CS.Run∘I¨⍳5
}

INDEXGEN∆I∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/indexgeni'C.Fix S
  #.UT.expect←NS.Run∘I¨⍳5 ⋄ CS.Run∘I¨⍳5
}

INDEXGEN∆I∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'indexgeni'C.Fix S
  #.UT.expect←NS.Run∘I¨⍳5 ⋄ CS.Run∘I¨⍳5
}

:EndNamespace

