:Require file://t0027.dyalog
:Namespace t0027_tests

 tn←'t0027' ⋄ cn←'c0027' ⋄ cd←⎕NS⍬ ⋄ dy←#.⍎tn

 EXEC←{0::⊃⎕DM ⋄ ⍺ ⍺⍺ ⍵}
 TEST1←{Y  ←⍵⍵ ⋄ #.UT.expect← dy.(⍎⍺⍺)EXEC Y ⋄   cd.(⍎⍺⍺)EXEC Y}
 TEST2←{X Y←⍵⍵ ⋄ #.UT.expect←X dy.(⍎⍺⍺)EXEC Y ⋄ X cd.(⍎⍺⍺)EXEC Y}

 ∆0000_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0027←tn #.codfns.Fix ⎕SRC dy}

 ∆0001_TEST←'F'         TEST1 (2 2 2 2 2⍴⍳32)
 ∆0002_TEST←'shape'     TEST1 (5 4 3 2 1⍴⍳120)
 ∆0003_TEST←'reshape'   TEST2 (5 4 3 2 1)(⍳120)
 ∆0004_TEST←'transpose1'TEST1 (5 4 3 2 1⍴⍳120)
 ∆0005_TEST←'transpose2'TEST2 (0 1 1 2 3)(1 2 3 4 5⍴⍳120)
 ∆0006_TEST←'transpose2'TEST2 (0 2 1 3 4)(1 2 3 4 5⍴⍳120)

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
