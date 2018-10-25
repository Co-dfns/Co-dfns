:Require file://t0011.dyalog
:Namespace t0011_tests

 tn←'t0011' ⋄ cn←'c0011'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0011←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑'R1' 'R2' ⋄ cd.⎕NL 3}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}

 ∆02_TEST←{#.UT.expect←dy.R1 ⍳5 ⋄ cd.R1 ⍳5}
 ∆03_TEST←{#.UT.expect←dy.R2 ⍳5 ⋄ cd.R2 ⍳5}

 ∆04_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
