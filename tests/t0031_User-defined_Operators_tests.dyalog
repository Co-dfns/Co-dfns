:Require file://t0031.dyalog
:Namespace t0031_tests

 tn←'t0031' ⋄ cn←'c0031' ⋄ cd←⎕NS⍬ ⋄ dy←#.⍎tn

 TEST1←{Y  ←⍵⍵ ⋄ #.UT.expect← dy.(⍎⍺⍺) Y ⋄   cd.(⍎⍺⍺) Y}
 TEST2←{X Y←⍵⍵ ⋄ #.UT.expect←X dy.(⍎⍺⍺) Y ⋄ X cd.(⍎⍺⍺) Y}

 ∆0000_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0031←tn #.codfns.Fix ⎕SRC dy}

 ∆0001_TEST←'Fn1' TEST1 5
 ∆0002_TEST←'Fn1' TEST2 5 3
 ∆0003_TEST←'Fn2' TEST1 7
 ∆0004_TEST←'Fn2' TEST2 7 13

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
