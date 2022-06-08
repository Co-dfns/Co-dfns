:Require file://t0032.dyalog
:Namespace t0032_tests

 tn←'t0032' ⋄ cn←'c0032' ⋄ cd←⎕NS⍬ ⋄ dy←#.⍎tn

 TEST1←{Y  ←⍵⍵ ⋄ #.UT.expect← dy.(⍎⍺⍺) Y ⋄   cd.(⍎⍺⍺) Y}
 TEST2←{X Y←⍵⍵ ⋄ #.UT.expect←X dy.(⍎⍺⍺) Y ⋄ X cd.(⍎⍺⍺) Y}

 ∆0000_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0032←tn #.codfns.Fix ⎕SRC dy}

 ∆0001_TEST←'add' TEST2 (1 2 3)(3 4 5)

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
