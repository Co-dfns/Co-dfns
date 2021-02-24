:Require file://t0028.dyalog
:Namespace t0028_tests

 tn←'t0028' ⋄ cn←'c0028' ⋄ cd←⎕NS⍬ ⋄ dy←#.⍎tn

 TEST1←{Y  ←⍵⍵ ⋄ #.UT.expect← dy.(⍎⍺⍺) Y ⋄   cd.(⍎⍺⍺) Y}
 TEST2←{X Y←⍵⍵ ⋄ #.UT.expect←X dy.(⍎⍺⍺) Y ⋄ X cd.(⍎⍺⍺) Y}

 ∆0000_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0028←tn #.codfns.Fix ⎕SRC dy}

 ∆0001_TEST←'id' TEST1 (⊂⍬)
 ∆0002_TEST←'id' TEST1 (⊂⍳5)
 ∆0003_TEST←'id' TEST1 (⊂2 5⍴⍳10)
 ∆0004_TEST←'id' TEST1 (⊂2 3⍴(1 2 3)(4 5 6))
 ∆0005_TEST←'id' TEST1 (2 3⍴(1 2 3)(4 5 6))
 ∆0006_TEST←'ncl'TEST1 5
 ∆0007_TEST←'ncl'TEST1 (,5)
 ∆0008_TEST←'ncl'TEST1 (⍳5)
 ∆0009_TEST←'ncl'TEST1 (2 3⍴⍳5)
 ∆0010_TEST←'strand'TEST1 (0)
 ∆0011_TEST←'strand'TEST1 (⍳5)
 ∆0012_TEST←'strand'TEST1 (2 3⍴⍳5)
 ∆0013_TEST←'strand2'TEST1 (2 3⍴⍳5)
 ∆0014_TEST←'strand3'TEST1 (2 3⍴⍳5)
 ∆0015_TEST←'strand3'TEST1 (5)
 ∆0016_TEST←'ncla'TEST2 (⍬) (2 3⍴⍳6)
 ∆0017_TEST←'ncla'TEST2 (⍬) (2 3⍴⍳2 3)

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
