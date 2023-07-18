:Require file://t0056.dyalog
:Namespace t0056_tests

 tn←'t0056' ⋄ cn←'c0056'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0056←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}
 MK∆T4←{fn tl←⍺⍺ ⋄ nv←(⍎'dy.',fn)⍵⍵ ⋄ cv←(⍎'cd.',fn)⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}

F←{⊃((⎕DR ⍵)645)⎕DR ⍵}
B←{⊃((⎕DR ⍵)11)⎕DR ⍵}
I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

∆take∆01_TEST←'take∆R1' MK∆T2 5	(⍳35)
∆take∆02_TEST←'take∆R2' MK∆T2 (7 5)	(⍳12)
∆take∆03_TEST←'take∆R1' MK∆T2 (¯5)	(⍳12)
∆take∆04_TEST←'take∆R1' MK∆T2 (0)	(⍳12)
∆take∆05_TEST←'take∆R1' MK∆T2 (1)	(12)
∆take∆06_TEST←'take∆R1' MK∆T2 (⍬)	(12)
∆take∆07_TEST←'take∆R1' MK∆T2 (⍬)	(⍳12)
∆take∆08_TEST←'take∆R1' MK∆T2 (2)	(5 5⍴⍳25)
∆take∆09_TEST←'take∆R1' MK∆T2 (2 2)	(5 5⍴⍳25)
∆take∆10_TEST←'take∆R1' MK∆T2 (¯2 2)	(5 5⍴⍳25)
∆take∆11_TEST←'take∆R1' MK∆T2 (¯2 ¯3)	(5 5⍴⍳25)
∆take∆12_TEST←'take∆R1' MK∆T2 (¯2)	(5 5⍴⍳25)
∆take∆13_TEST←'take∆R1' MK∆T2 (¯2 2)	(5 5 3⍴⍳75)
∆take∆14_TEST←'take∆R1' MK∆T2 (25)	(⍳12)
∆take∆15_TEST←'take∆R1' MK∆T2 (10 10)	(5 5⍴⍳25)
∆take∆16_TEST←'take∆R1' MK∆T2 (10 10)	(5)
∆take∆17_TEST←'take∆R1' MK∆T2 (10)	(5)
∆take∆18_TEST←'take∆R1' MK∆T2 (2 5 5)	(3 3 3⍴⍳27)
∆take∆19_TEST←'take∆R1' MK∆T2 (2 ¯5 5)	(3 3 3⍴⍳27)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
