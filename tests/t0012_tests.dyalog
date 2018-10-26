:Require file://t0012.dyalog
:Namespace t0012_tests

 tn←'t0012' ⋄ cn←'c0012'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0012←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑'R1' 'R2' 'R3' ⋄ cd.⎕NL 3}

 ∆02_TEST←{#.UT.expect←dy.R1 0 ⋄ cd.R1 0}
 ∆03_TEST←{#.UT.expect←dy.R1 1 ⋄ cd.R2 1}
 ∆04_TEST←{#.UT.expect←dy.R2 0 ⋄ cd.R1 0}
 ∆05_TEST←{#.UT.expect←dy.R2 1 ⋄ cd.R2 1}
 ∆06_TEST←{#.UT.expect←dy.R3 0 ⋄ cd.R1 0}
 ∆07_TEST←{#.UT.expect←dy.R3 1 ⋄ cd.R2 1}

 ∆08_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
