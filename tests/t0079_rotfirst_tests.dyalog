:Require file://t0079.dyalog
:Namespace t0079_tests

 tn←'t0079' ⋄ cn←'c0079'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0079←tn #.codfns.Fix ⎕SRC dy}

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

MK∆T←{nv←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ cv←⊃(⍎'cd.',⍺⍺)/⍵⍵
 res←|1-(0.5⌈(⌈/1⊃⍵⍵)÷2)÷(+⌿÷≢)cv ⋄ _←{0.05≤⍵:⎕←⍵ ⋄ ⍬}res
 ##.UT.expect←(⍴nv)(1) ⋄ (⍴cv)(0.05>res)}

∆rotfirst∆01_TEST←'rotfirst∆S' MK∆T2 ¯1	⍬
∆rotfirst∆02_TEST←'rotfirst∆S' MK∆T2 ¯1	0
∆rotfirst∆03_TEST←'rotfirst∆S' MK∆T2 ¯1	(⍳5)
∆rotfirst∆04_TEST←'rotfirst∆S' MK∆T2 ¯1	(2 3 4⍴⍳5)
∆rotfirst∆05_TEST←'rotfirst∆S' MK∆T2 ¯1	(17⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆06_TEST←'rotfirst∆S' MK∆T2 ¯1	(0 1 1 0 0 1 1)
∆rotfirst∆07_TEST←'rotfirst∆S' MK∆T2 ¯1	(2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆08_TEST←'rotfirst∆S' MK∆T2 1	(0 1 1 0 0 1 1)
∆rotfirst∆09_TEST←'rotfirst∆S' MK∆T2 7	(17⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆10_TEST←'rotfirst∆S' MK∆T2 7	(17⍴⍳17)
∆rotfirst∆11_TEST←'rotfirst∆R' MK∆T1 	(17⍴⍳17)
∆rotfirst∆12_TEST←'rotfirst∆T' MK∆T1 	(2 3 4⍴⍳5)
∆rotfirst∆13_TEST←'rotfirst∆T' MK∆T1 	(⍳5)
∆rotfirst∆14_TEST←'rotfirst∆T' MK∆T1 	0
∆rotfirst∆15_TEST←'rotfirst∆T' MK∆T1 	(17⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆16_TEST←'rotfirst∆T' MK∆T1 	(0 1 1 0 0 1 1)
∆rotfirst∆17_TEST←'rotfirst∆T' MK∆T1 	(2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆18_TEST←'rotfirst∆R' MK∆T1 	(17⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆19_TEST←'rotfirst∆S' MK∆T2 ¯1	(32 32⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆20_TEST←'rotfirst∆S' MK∆T2 ¯1	(64 20⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆21_TEST←'rotfirst∆S' MK∆T2 ¯1	(?15 15⍴2)
∆rotfirst∆22_TEST←'rotfirst∆S' MK∆T2 ¯1	(?80 80⍴2)
∆rotfirst∆23_TEST←'rotfirst∆S' MK∆T2 ¯1	(?800 800⍴2)
∆rotfirst∆24_TEST←'rotfirst∆S' MK∆T2 ¯1	(?90 90⍴2)
∆rotfirst∆25_TEST←'rotfirst∆S' MK∆T2 ¯1	(?8100⍴2)
∆rotfirst∆26_TEST←'rotfirst∆S' MK∆T2 ¯1	(?8133⍴2)
∆rotfirst∆27_TEST←'rotfirst∆S' MK∆T2 2	(32 32⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆28_TEST←'rotfirst∆S' MK∆T2 2	(64 20⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotfirst∆29_TEST←'rotfirst∆S' MK∆T2 2	(?15 15⍴2)
∆rotfirst∆30_TEST←'rotfirst∆S' MK∆T2 2	(?80 80⍴2)
∆rotfirst∆31_TEST←'rotfirst∆S' MK∆T2 2	(?30 30⍴2)
∆rotfirst∆32_TEST←'rotfirst∆S' MK∆T2 2	(?800 800⍴2)
∆rotfirst∆33_TEST←'rotfirst∆S' MK∆T2 2	(?90 90⍴2)
∆rotfirst∆34_TEST←'rotfirst∆S' MK∆T2 2	(?8100⍴2)
∆rotfirst∆35_TEST←'rotfirst∆S' MK∆T2 2	(?8133⍴2)
∆rotfirst∆36_TEST←'rotfirst∆S' MK∆T2 (⍳5)       (7 5⍴⍳35)
∆rotfirst∆37_TEST←'rotfirst∆S' MK∆T2 (2 3⍴⍳6)   (5 2 3⍴⍳30)
∆rotfirst∆38_TEST←'rotfirst∆U' MK∆T2 (1 2 3⍴⍳6) (1 5 2 3⍴⍳30)
∆rotfirst∆39_TEST←'rotfirst∆U' MK∆T2 (1 6⍴⍳6)   (1 5 6⍴⍳30)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
