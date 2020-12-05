:Require file://t0027.dyalog
:Namespace t0027_tests

 tn←'t0027' ⋄ cn←'c0027' ⋄ cd←⎕NS⍬ ⋄ dy←#.⍎tn

 TEST1←{Y  ←⍵⍵ ⋄ #.UT.expect← dy.(⍎⍺⍺) Y ⋄   cd.(⍎⍺⍺) Y}
 TEST2←{X Y←⍵⍵ ⋄ #.UT.expect←X dy.(⍎⍺⍺) Y ⋄ X cd.(⍎⍺⍺) Y}

 ∆0000_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0027←tn #.codfns.Fix ⎕SRC dy}

 ∆0001_TEST←'F'         TEST1 (2 2 2 2 2⍴⍳32)
 ∆0002_TEST←'shape'     TEST1 (5 4 3 2 1⍴⍳120)
 ∆0003_TEST←'reshape'   TEST2 (5 4 3 2 1)(⍳120)
 ∆0004_TEST←'transpose1'TEST1 (5 4 3 2 1⍴⍳120)
 ∆0005_TEST←'transpose2'TEST2 (0 1 1 2 3)(1 2 3 4 5⍴⍳120)
 ∆0006_TEST←'transpose2'TEST2 (0 2 1 3 4)(1 2 3 4 5⍴⍳120)
 ∆0007_TEST←'gradeup1'  TEST1 (?1 2 3 4 5⍴10)
 ∆0008_TEST←'add'       TEST2 (?2⍴⊂1 2 3 4 5⍴10)
 ∆0009_TEST←'neg'       TEST1 (?1 2 3 4 5⍴10)
 ∆0010_TEST←'addax'     TEST2 (3)(1 2 4 3 5⍴⍳120)
 ∆0011_TEST←'sign'      TEST1 (¯2+?20 1 1 1 1 1⍴5)
 ∆0012_TEST←'recip'     TEST1 (1+1 5 1 5 1⍴⍳25)
 ∆0013_TEST←'mag'       TEST1 (¯2+?1 5 4 1 1 1⍴5)
 ∆0014_TEST←'floor'     TEST1 (7×?1 2 3 4 5⍴0)
 ∆0015_TEST←'ceil'      TEST1 (7×?1 2 3 4 5⍴0)
 ∆0016_TEST←'expt'      TEST1 (¯2+?1 2 3 4 5⍴5)
 ∆0017_TEST←'loge'      TEST1 (1+1 2 3 4 5⍴⍳120)
 ∆0018_TEST←'piti'      TEST1 (1 2 3 4 5⍴⍳120)
 ∆0019_TEST←'trig'      TEST2 (1)(1 2 3 4 5⍴⍳120)
 ∆0020_TEST←'trig'      TEST2 (1+?1 2 3 4 5⍴2)(1 2 3 4 5⍴⍳120)
 ∆0021_TEST←'fact'      TEST1 (1 2 3 4 5⍴⍳10)
 ∆0022_TEST←'not'       TEST1 (?1 2 3 4 5⍴2)
 ∆0023_TEST←'enlist'    TEST1 (1 2 3 4 5⍴⍳120)
 ∆0024_TEST←'member'    TEST2 (1 2 3 4 5⍴⍳120)(⌊(⍳120)÷2)
 ∆0025_TEST←'lor'       TEST2 (?1 2 3 4 5⍴2)(?1 2 3 4 5⍴2)
 ∆0026_TEST←'and'       TEST2 (?1 2 3 4 5⍴2)(?1 2 3 4 5⍴2)
 ∆0027_TEST←'idxof'     TEST2 (⌽⍳75)(1 2 3 4 5⍴⍳120)
 ∆0028_TEST←'sqd'       TEST2 (0 1 1)(1 2 3 4 5⍴⍳120)
 ∆0029_TEST←'ravel'     TEST1 (1 2 3 4 5⍴⍳120)
 ∆0030_TEST←'catenate'  TEST2 (1 2 3 4 5⍴⍳120)(1 2 3 4 5⍴⍳120)

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
