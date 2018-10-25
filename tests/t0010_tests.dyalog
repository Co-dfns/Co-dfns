:Require file://t0010.dyalog
:Namespace t0010_tests

 tn←'t0010' ⋄ cn←'c0010'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0010←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑'Lit' 'Run' ⋄ cd.⎕NL 3}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}

 ∆02_TEST←'Run'MK∆T2 (⍳10) (5)
 ∆03_TEST←'Run'MK∆T2 (⍳10) (⍳5)
 ∆04_TEST←'Run'MK∆T2 (,1)  (0)
 ∆05_TEST←'Lit'MK∆T1 (⍳5)
 ∆06_TEST←'Run'MK∆T2 (7 5) (0 1 0 0 1 1)

 ∆07_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
