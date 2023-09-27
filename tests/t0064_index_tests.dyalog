:Require file://t0064.dyalog
:Namespace t0064_tests

 tn←'t0064' ⋄ cn←'c0064'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0064←tn #.codfns.Fix ⎕SRC dy}

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

∆index∆01_TEST←'index∆R1' MK∆T2 (⍬)	(5)
∆index∆02_TEST←'index∆R1' MK∆T2 (⍬)	(⍳5)
∆index∆03_TEST←'index∆R1' MK∆T2 (,1)	(⍳5)
∆index∆04_TEST←'index∆R1' MK∆T2 (1)	(⍳5)
∆index∆05_TEST←'index∆R1' MK∆T2 (⊂⍬)	(3⍴⍳5)
∆index∆06_TEST←'index∆R1' MK∆T2 (1 2)	(3 3⍴⍳5)
∆index∆07_TEST←'index∆R1' MK∆T2 (1 2)	(3 3 3⍴⍳27)
∆index∆08_TEST←'index∆R2' MK∆T1  	(⍳5)
∆index∆09_TEST←'index∆R3' MK∆T2 (5)	(?30 30⍴5)
∆index∆10_TEST←'index∆R4' MK∆T2 (7 15,,?7 15⍴30)	(?50 50⍴10)
∆index∆11_TEST←'index∆R1' MK∆T2 (1)	(3 3 3⍴⍳27)
∆index∆12_TEST←'index∆R1' MK∆T2 (0)	(20 20⍴⍳400)
∆index∆13_TEST←'index∆R2' MK∆T1  	(20 20⍴⍳400)
∆index∆14_TEST←'index∆R1' MK∆T2 (0)	(?3 20⍴1000)
∆index∆15_TEST←'index∆R1' MK∆T2 (5 9)  (?6 10⍴1000)
∆index∆16_TEST←'index∆R1' MK∆T2 (9 5)  (?10 6⍴1000)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
