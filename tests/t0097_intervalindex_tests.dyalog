:Require file://t0097.dyalog
:Namespace t0097_tests

 tn←'t0097' ⋄ cn←'c0097'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0097←tn #.codfns.Fix ⎕SRC dy}

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

∆intervalindex∆00_TEST←'intervalindex' MK∆T2 (⍬)(⍬)
∆intervalindex∆01_TEST←'intervalindex' MK∆T2 (,0)(,5)
∆intervalindex∆02_TEST←'intervalindex' MK∆T2 (,1)(,5)
∆intervalindex∆03_TEST←'intervalindex' MK∆T2 (,2)(,5)
∆intervalindex∆04_TEST←'intervalindex' MK∆T2 (0 1)(⍳2)
∆intervalindex∆05_TEST←'intervalindex' MK∆T2 (1 1)(⍳2)
∆intervalindex∆06_TEST←'intervalindex' MK∆T2 (1 2)(⍳2)
∆intervalindex∆07_TEST←'intervalindex' MK∆T2 (0 2)(⍳2)
∆intervalindex∆08_TEST←'intervalindex' MK∆T2 (1 2)(⍳2)
∆intervalindex∆09_TEST←'intervalindex' MK∆T2 (2 2)(⍳2)
∆intervalindex∆10_TEST←'intervalindex' MK∆T2 (0 3)(⍳2)
∆intervalindex∆11_TEST←'intervalindex' MK∆T2 (1 3)(⍳2)
∆intervalindex∆12_TEST←'intervalindex' MK∆T2 (2 3)(⍳2)
∆intervalindex∆13_TEST←'intervalindex' MK∆T2 (5⍴0)(⍳5)
∆intervalindex∆14_TEST←'intervalindex' MK∆T2 (5⍴1)(⍳5)
∆intervalindex∆15_TEST←'intervalindex' MK∆T2 (,1)(⍳5)
∆intervalindex∆16_TEST←'intervalindex' MK∆T2 (,0)(⍳5)
∆intervalindex∆17_TEST←'intervalindex' MK∆T2 (5⍴2)(⍳5)
∆intervalindex∆18_TEST←'intervalindex' MK∆T2 (0 1 2)(⍳5)
∆intervalindex∆19_TEST←'intervalindex' MK∆T2 (0 2 4)(⍳5)
∆intervalindex∆20_TEST←'intervalindex' MK∆T2 (0 0 0 2 2)(⍳5)
∆intervalindex∆21_TEST←'intervalindex' MK∆T2 (0 4 4)(⍳5)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
