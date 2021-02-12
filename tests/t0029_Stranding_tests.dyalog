:Require file://t0029.dyalog
:Namespace t0029_tests

 tn←'t0029' ⋄ cn←'c0029' ⋄ cd←⎕NS⍬ ⋄ dy←#.⍎tn

 TEST1←{Y  ←⍵⍵ ⋄ #.UT.expect← dy.(⍎⍺⍺) Y ⋄   cd.(⍎⍺⍺) Y}
 TEST2←{X Y←⍵⍵ ⋄ #.UT.expect←X dy.(⍎⍺⍺) Y ⋄ X cd.(⍎⍺⍺) Y}

 ∆0000_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0029←tn #.codfns.Fix ⎕SRC dy}

 ∆0001_TEST←'F' TEST1 5

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
