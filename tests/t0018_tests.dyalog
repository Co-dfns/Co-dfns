:Require file://t0018.dyalog
:Namespace t0018_tests

 tn←'t0018' ⋄ cn←'c0018'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0018←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←dy.m17∆small 0 ⋄ cd.m17∆small 0}
 ∆02_TEST←{#.UT.expect←dy.m17∆small 1 ⋄ cd.m17∆small 1}

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
