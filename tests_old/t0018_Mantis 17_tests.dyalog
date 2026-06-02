:Require file://t0018.dyalog
:Namespace t0018_tests

 tn←'t0018' ⋄ cn←'c0018'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0018←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←dy.f1 0 ⋄ cd.f1 0}
 ∆02_TEST←{#.UT.expect←dy.f2 0 ⋄ cd.f2 0}
 ∆03_TEST←{#.UT.expect←dy.f3 1 ⋄ cd.f3 1}
 ∆04_TEST←{#.UT.expect←dy.f4 1 ⋄ cd.f4 1}
 ∆05_TEST←{#.UT.expect←dy.f5 1 ⋄ cd.f5 1}
 ∆06_TEST←{#.UT.expect←dy.m17∆small 0 ⋄ cd.m17∆small 0}
 ∆07_TEST←{#.UT.expect←dy.m17∆small 1 ⋄ cd.m17∆small 1}

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
