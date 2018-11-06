:Require file://t0010.dyalog
:Namespace t0010_tests

 tn←'t0010' ⋄ cn←'c0010'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0010←tn #.codfns.Fix ⎕SRC dy}
 
 bindings←'Lit' 'R1' 'R2' 'R3' 'R4' 'R5' 'R6' 'R7' 'R8' 'R9' 'Run'
 ∆01_TEST←{#.UT.expect←↑bindings ⋄ cd.⎕NL 3}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}

 ∆02_TEST←'Run'MK∆T2 (⍳10) (5)
 ∆03_TEST←'Run'MK∆T2 (⍳10) (⍳5)
 ∆04_TEST←'Run'MK∆T2 (,1)  (0)
 ∆05_TEST←'Lit'MK∆T1 (⍳5)
 ∆06_TEST←'Run'MK∆T2 (7 5) (0 1 0 0 1 1)
 ∆07_TEST←{#.UT.expect←(5 5⍴⍳25)dy.R1 ⍳3 ⋄ (5 5⍴⍳25)cd.R1 ⍳3}
 ∆08_TEST←{#.UT.expect←dy.R2 5 5⍴⍳25 ⋄ cd.R2 5 5⍴⍳25}
 ∆09_TEST←{#.UT.expect←dy.R3 3 3 3⍴⍳27 ⋄ cd.R3 3 3 3⍴⍳27}
 ∆10_TEST←{#.UT.expect←dy.R4 5 5⍴⍳25 ⋄ cd.R4 5 5⍴⍳25}
 ∆11_TEST←{#.UT.expect←(5 5⍴⍳25)dy.R1 3 ⋄ (5 5⍴⍳25)cd.R1 3}
 ∆12_TEST←{#.UT.expect←(5 5⍴⍳25)dy.R5 0 ⋄ (5 5⍴⍳25)cd.R5 0}
 ∆13_TEST←{#.UT.expect←(5 5⍴⍳25)dy.R5 1 ⋄ (5 5⍴⍳25)cd.R5 1}
 ∆14_TEST←{#.UT.expect←(5 5⍴⍳25)dy.R5 1 3 ⋄ (5 5⍴⍳25)cd.R5 1 3}
 ∆15_TEST←{#.UT.expect←(5 5⍴⍳25)dy.R6 0 ⋄ (5 5⍴⍳25)cd.R6 0}
 ∆16_TEST←{#.UT.expect←(5 5⍴⍳25)dy.R6 1 ⋄ (5 5⍴⍳25)cd.R6 1}
 ∆17_TEST←{#.UT.expect←(5 5⍴⍳25)dy.R6 1 3 ⋄ (5 5⍴⍳25)cd.R6 1 3}
 ∆18_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R7 0 ⋄ (5 5 5⍴⍳125)cd.R7 0}
 ∆19_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R7 1 ⋄ (5 5 5⍴⍳125)cd.R7 1}
 ∆20_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R7 1 3 ⋄ (5 5 5⍴⍳125)cd.R7 1 3}
 ∆21_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R8 0 ⋄ (5 5 5⍴⍳125)cd.R8 0}
 ∆22_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R8 1 ⋄ (5 5 5⍴⍳125)cd.R8 1}
 ∆23_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R8 1 3 ⋄ (5 5 5⍴⍳125)cd.R8 1 3}
 ∆24_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R9 0 ⋄ (5 5 5⍴⍳125)cd.R9 0}
 ∆25_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R9 1 ⋄ (5 5 5⍴⍳125)cd.R9 1}
 ∆26_TEST←{#.UT.expect←(5 5 5⍴⍳125)dy.R9 1 3 ⋄ (5 5 5⍴⍳125)cd.R9 1 3}

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
