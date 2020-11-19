:Require file://t0027.dyalog
:Namespace t0027_tests

 tn←'t0027' ⋄ cn←'c0027' ⋄ cd←⎕NS⍬ ⋄ dy←#.⍎tn

 EXEC←{0::⊃⎕DM ⋄ ⍺ ⍺⍺ ⍵}
 TEST1←{Y  ←⍵⍵ ⋄ #.UT.expect← dy.(⍎⍺⍺)EXEC Y ⋄   cd.(⍎⍺⍺)EXEC Y}
 TEST2←{X Y←⍵⍵ ⋄ #.UT.expect←X dy.(⍎⍺⍺)EXEC Y ⋄ X cd.(⍎⍺⍺)EXEC Y}

 ∆0000_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0027←tn #.codfns.Fix ⎕SRC dy}

 ∆0001_TEST←'F'      TEST1 ((5⍴2)⍴⍳32)
 ∆0002_TEST←'shape'  TEST1 ((⌽1+⍳5)⍴⍳×/1+⍳5)
 ∆0003_TEST←'reshape'TEST2 (⌽1+⍳5)(⍳×/1+⍳5)

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
