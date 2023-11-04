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
 ∆0018_TEST←'ncla'TEST2 (0) (⍳6)
 ∆0019_TEST←'ncla'TEST2 (0 1) (⍳6 6)
 ∆0020_TEST←'ncla'TEST2 (0) (2 3⍴⍳6)
 ∆0021_TEST←'ncla'TEST2 (0 1) (2 3⍴⍳6)
 ∆0022_TEST←'ncla'TEST2 (0 1) (2 3 4⍴⍳24)
 ∆0023_TEST←'ncla'TEST2 (0) (2 3 4⍴⍳24)
 ∆0024_TEST←'ncla'TEST2 (1) (2 3 4⍴⍳24)
 ∆0025_TEST←'ncla'TEST2 (2) (2 3 4⍴⍳24)
 ∆0026_TEST←'ncla'TEST2 (1 2) (2 3 4⍴⍳24)
 ∆0027_TEST←'ncla'TEST2 (0 2) (2 3 4⍴⍳24)
 ∆0028_TEST←'ncla'TEST2 (2 0) (2 3 4⍴⍳24)
 ∆0029_TEST←'ncla'TEST2 (1 0) (2 3 4⍴⍳24)
 ∆0030_TEST←'ncla'TEST2 (2 1) (2 3 4⍴⍳24)
 ∆0031_TEST←'ncla'TEST2 (0 1) (2 3 4⍴⍳24)
 ∆0032_TEST←'ncla'TEST2 (0 1 2) (2 3 4⍴⍳24)
 ∆0033_TEST←'mix'TEST1 (⊂¨⍳5 5)
 ∆0034_TEST←'rnk'TEST1 (2 3⍴⍳6)
 ∆0035_TEST←'rnk'TEST1 (2 3 4⍴⍳24)
 ∆0036_TEST←'rnk'TEST1 (⍳2 3 4)
 ∆0037_TEST←'red1'TEST1 (⊂⍤¯1⊢2 3 4⍴⍳24)
 ∆0038_TEST←'red2'TEST1 (⊂⍤¯1⊢2 3 4⍴⍳24)
 ∆0039_TEST←'red1'TEST1 (2 3 4⍴⍳24)
 ∆0040_TEST←'red2'TEST1 (2 3 4⍴⍳24)
 ∆0041_TEST←'red3'TEST1 (⊂⍤¯1⊢2 3 4⍴⍳24)
 ∆0042_TEST←'mix'TEST1 (5)
 ∆0043_TEST←'mix'TEST1 (⍳5)
 ∆0044_TEST←'mix'TEST1 (⍳5 5)
 ∆0045_TEST←'mix'TEST1 (⊂⍤¯1⊢2 3 4⍴⍳24)
 ∆0046_TEST←'mix'TEST1 (⍳¨⍳5)
 ∆0047_TEST←'mix'TEST1 ({⍵⍴⍳×⌿⍵}¨⍳2 3)
 ∆0048_TEST←'drp'TEST2 (3)(,⍳5 5)
 ∆0049_TEST←'ncl'TEST1 (⊂3 4⍴⍳12)
 ∆0050_TEST←'cat'TEST2 (,¨⍳5)(⊂2 3⍴⍳6)
 ∆0051_TEST←'nst'TEST1 (0)
 ∆0052_TEST←'nst'TEST1 (⍳5)
 ∆0053_TEST←'nst'TEST1 (2 3⍴⍳4)
 ∆0054_TEST←'nst'TEST1 (⊂2 3⍴⍳4)
 ∆0055_TEST←'nst'TEST1 (3⍴⊂⍳4)
 ∆0056_TEST←'reshape'TEST2 0 (⊂2 5⍴⊂'abc')
 ∆0057_TEST←'id'TEST1 (0⍴⊂⍬)
 ∆0058_TEST←'mix'TEST1 (0⍴⊂⍬)
 ∆0059_TEST←'get'TEST2 (⍳3) (⍳5)
 ∆0060_TEST←'brk'TEST2 (⍳¨⍳5) (2)
 ∆0061_TEST←'cat'TEST2 (⍳¨⍳5) (2)

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
