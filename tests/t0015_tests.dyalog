:Require file://t0015.dyalog
:Namespace t0015_tests

 tn←'t0015' ⋄ cn←'c0015'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0015←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑'R',∘⍕¨1+⍳8 ⋄ cd.⎕NL 3}
 ∆02_TEST←{#.UT.expect←dy.R1 ⍳5 ⋄ cd.R1 ⍳5}
 ∆03_TEST←{#.UT.expect←dy.R2 ⍳5 ⋄ cd.R2 ⍳5}
 ∆04_TEST←{#.UT.expect←dy.R3 ⍳5 ⋄ cd.R3 ⍳5}
 ∆05_TEST←{#.UT.expect←dy.R4 ⍳5 ⋄ cd.R4 ⍳5}
 ∆06_TEST←{#.UT.expect←dy.R5 ⍳5 ⋄ cd.R5 ⍳5}
 ∆07_TEST←{#.UT.expect←dy.R6 ⍳5 ⋄ cd.R6 ⍳5}
 ∆08_TEST←{#.UT.expect←dy.R7 ⍳5 ⋄ cd.R7 ⍳5}
 ∆09_TEST←{#.UT.expect←⍬⍴5 6 7 8 ⋄ cd.R8 5 6 7 8}
 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
