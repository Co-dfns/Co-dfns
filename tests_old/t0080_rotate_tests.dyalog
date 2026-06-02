:Require file://t0080.dyalog
:Namespace t0080_tests

 tn←'t0080' ⋄ cn←'c0080'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0080←tn #.codfns.Fix ⎕SRC dy}

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

∆rotate∆01_TEST←'rotate∆S' MK∆T2 ¯1         ⍬
∆rotate∆02_TEST←'rotate∆S' MK∆T2 ¯1         0
∆rotate∆03_TEST←'rotate∆S' MK∆T2 ¯1         (⍳5)
∆rotate∆04_TEST←'rotate∆S' MK∆T2 ¯1         (2 3 4⍴⍳5)
∆rotate∆05_TEST←'rotate∆S' MK∆T2 ¯1         (17⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotate∆06_TEST←'rotate∆S' MK∆T2 ¯1         (0 1 1 0 0 1 1)
∆rotate∆07_TEST←'rotate∆S' MK∆T2 ¯1         (2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotate∆08_TEST←'rotate∆S' MK∆T2 1          (0 1 1 0 0 1 1)
∆rotate∆09_TEST←'rotate∆S' MK∆T2 7          (17⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotate∆10_TEST←'rotate∆S' MK∆T2 7          (17⍴⍳17)
∆rotate∆11_TEST←'rotate∆R' MK∆T1            (17⍴⍳17)
∆rotate∆12_TEST←'rotate∆T' MK∆T1            (2 3 4⍴⍳5)
∆rotate∆13_TEST←'rotate∆T' MK∆T1            (⍳5)
∆rotate∆14_TEST←'rotate∆T' MK∆T1            0
∆rotate∆15_TEST←'rotate∆T' MK∆T1            (17⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotate∆16_TEST←'rotate∆T' MK∆T1            (0 1 1 0 0 1 1)
∆rotate∆17_TEST←'rotate∆T' MK∆T1            (2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotate∆18_TEST←'rotate∆R' MK∆T1            (17⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotate∆19_TEST←'rotate∆S' MK∆T2 ¯1         (32 32⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotate∆20_TEST←'rotate∆S' MK∆T2 ¯1         (64 20⍴0 1 1 0 0 1 1 1 1 0 0)
∆rotate∆21_TEST←'rotate∆S' MK∆T2 ¯1         (?15 15⍴2)
∆rotate∆22_TEST←'rotate∆S' MK∆T2 ¯1         (?80 80⍴2)
∆rotate∆23_TEST←'rotate∆S' MK∆T2 ¯1         (?800 800⍴2)
∆rotate∆24_TEST←'rotate∆S' MK∆T2 ¯1         (?90 90⍴2)
∆rotate∆25_TEST←'rotate∆S' MK∆T2 ¯1         (?8100⍴2)
∆rotate∆26_TEST←'rotate∆S' MK∆T2 ¯1         (?8133⍴2)
∆rotate∆27_TEST←'rotate∆S' MK∆T2 (⍳5)       (5 7⍴⍳35)
∆rotate∆28_TEST←'rotate∆S' MK∆T2 (2 3⍴⍳6)   (2 3 5⍴⍳30)
∆rotate∆29_TEST←'rotate∆U' MK∆T2 (1 2 3⍴⍳6) (1 2 3 5⍴⍳30)
∆rotate∆30_TEST←'rotate∆U' MK∆T2 (1 6⍴⍳6)   (1 6 5⍴⍳30)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
