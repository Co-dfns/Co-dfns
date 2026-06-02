:Require file://t0013.dyalog
:Namespace t0013_tests

 tn←'t0013' ⋄ cn←'c0013'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0013←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑'R1' 'R2' ⋄ cd.⎕NL 3}

 ∆02_TEST←{#.UT.expect←dy.R1 5 ⋄ cd.R1 5}
 ∆03_TEST←{#.UT.expect←dy.R2 5 ⋄ cd.R1 5}

 ∆04_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
