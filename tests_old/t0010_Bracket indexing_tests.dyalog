:Require file://t0010.dyalog
:Namespace t0010_tests

 tn←'t0010' ⋄ cn←'c0010'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0010←tn #.codfns.Fix ⎕SRC dy}

 bindings← 'Lit' 'R1' 'R10' 'R11' 'R12' 'R13'
 bindings,←'R2' 'R3' 'R4' 'R5' 'R6' 'R7' 'R8' 'R9' 'Run'
 ∆01_TEST←{#.UT.expect←↑bindings ⋄ cd.⎕NL 3}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}

 ∆02_TEST←'Run'MK∆T2 (⍳10) (5)
 ∆03_TEST←'Run'MK∆T2 (⍳10) (⍳5)
 ∆04_TEST←'Run'MK∆T2 (,1)  (0)
 ∆05_TEST←'Lit'MK∆T1 (⍳5)
 ∆06_TEST←'Run'MK∆T2 (7 5) (0 1 0 0 1 1)
 ∆07_TEST←'R1' MK∆T2 (5 5⍴⍳25) (⍳3)
 ∆08_TEST←'R2' MK∆T1 (5 5⍴⍳25)
 ∆09_TEST←'R3' MK∆T1 (3 3 3⍴⍳27)
 ∆10_TEST←'R4' MK∆T1 (5 5⍴⍳25)
 ∆11_TEST←'R1' MK∆T2 (5 5⍴⍳25) (3)
 ∆12_TEST←'R5' MK∆T2 (5 5⍴⍳25) (0)
 ∆13_TEST←'R5' MK∆T2 (5 5⍴⍳25) (1)
 ∆14_TEST←'R5' MK∆T2 (5 5⍴⍳25) (1 3)
 ∆15_TEST←'R6' MK∆T2 (5 5⍴⍳25) (0)
 ∆16_TEST←'R6' MK∆T2 (5 5⍴⍳25) (1)
 ∆17_TEST←'R6' MK∆T2 (5 5⍴⍳25) (1 3)
 ∆18_TEST←'R7' MK∆T2 (5 5 5⍴⍳125) (0)
 ∆19_TEST←'R7' MK∆T2 (5 5 5⍴⍳125) (1)
 ∆20_TEST←'R7' MK∆T2 (5 5 5⍴⍳125) (1 3)
 ∆21_TEST←'R8' MK∆T2 (5 5 5⍴⍳125) (0)
 ∆22_TEST←'R8' MK∆T2 (5 5 5⍴⍳125) (1)
 ∆23_TEST←'R8' MK∆T2 (5 5 5⍴⍳125) (1 3)
 ∆24_TEST←'R9' MK∆T2 (5 5 5⍴⍳125) (0)
 ∆25_TEST←'R9' MK∆T2 (5 5 5⍴⍳125) (1)
 ∆26_TEST←'R9' MK∆T2 (5 5 5⍴⍳125) (1 3)
 ∆27_TEST←'R10'MK∆T2 (1 ¯1) (¯.5+?100⍴0)
 ∆28_TEST←{#.UT.expect←⍳5 ⋄ cd.R11⍬}
 ∆29_TEST←{#.UT.expect←1 ⋄ 4::1 ⋄ 0⊣cd.R12⍬}
 ∆30_TEST←'R13'MK∆T1 (⍬)
 ∆31_TEST←'Run'MK∆T2 (⍳10)(⍬)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
