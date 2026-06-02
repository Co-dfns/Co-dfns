:Require file://t0098.dyalog
:Namespace t0098_tests

 tn←'t0098' ⋄ cn←'c0098'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0098←tn #.codfns.Fix ⎕SRC dy}

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
 
key←{
	0=⎕NC'⍺':⍵ ∇⍳≢⍵
	3=⎕NC'⍺⍺':⍺(⊣⍺⍺∘(⌿∘⍵)⍤¯1 1≡⍤99 ¯1⍤¯1 99)⍨∪⍺

	mask←(≢≥⍳∘⍺)⍺⍺  ⍝ high-rank ∊
	keys←⍺⍺⍪mask⌿⍺
	vals←(-≢keys)↑mask⌿⍵

	1↓¨keys{⊂⍵}∇∇ vals
}
key3←{⍺ key ⍵}
dy.key3←key3
dy.key←key

∆key∆00_TEST←'key2' MK∆T2 (⍬)(⍬)
∆key∆01_TEST←'key2' MK∆T2 (0 1)(⍳2)
∆key∆02_TEST←'key2' MK∆T2 (1 1)(⍳2)
∆key∆03_TEST←'key2' MK∆T2 (1 2)(⍳2)
∆key∆04_TEST←'key2' MK∆T2 (0 2)(⍳2)
∆key∆05_TEST←'key2' MK∆T2 (1 2)(⍳2)
∆key∆06_TEST←'key2' MK∆T2 (2 2)(⍳2)
∆key∆07_TEST←'key2' MK∆T2 (0 3)(⍳2)
∆key∆08_TEST←'key2' MK∆T2 (1 3)(⍳2)
∆key∆09_TEST←'key2' MK∆T2 (2 3)(⍳2)
∆key∆10_TEST←'key2' MK∆T2 (5⍴0)(⍳5)
∆key∆11_TEST←'key2' MK∆T2 (5⍴1)(⍳5)
∆key∆12_TEST←'key2' MK∆T2 (5⍴0 1 2)(⍳5)
∆key∆13_TEST←'key2' MK∆T2 (5⍴0 2 4)(⍳5)
∆key∆14_TEST←'key2' MK∆T2 (5⍴0 0 0 2 2)(⍳5)
∆key∆15_TEST←'key2' MK∆T2 (5⍴0 4 4)(⍳5)
∆key∆16_TEST←'key2' MK∆T2 (5⍴0 1 2)(5 6 2⍴⍳30)
∆key∆17_TEST←'key2' MK∆T2 (5⍴0 2 4)(5 6 2⍴⍳30)
∆key∆18_TEST←'key2' MK∆T2 (5⍴0 0 0 2 2)(5 6 3⍴⍳30)
∆key∆19_TEST←'key2' MK∆T2 (5⍴0 4 4)(5 6 3⍴⍳30)
∆key∆20_TEST←'key1' MK∆T1 (⍬)
∆key∆21_TEST←'key1' MK∆T1 (0 1)
∆key∆22_TEST←'key1' MK∆T1 (1 1)
∆key∆23_TEST←'key1' MK∆T1 (1 2)
∆key∆24_TEST←'key1' MK∆T1 (0 2)
∆key∆25_TEST←'key1' MK∆T1 (1 2)
∆key∆26_TEST←'key1' MK∆T1 (2 2)
∆key∆27_TEST←'key1' MK∆T1 (0 3)
∆key∆28_TEST←'key1' MK∆T1 (1 3)
∆key∆29_TEST←'key1' MK∆T1 (2 3)
∆key∆30_TEST←'key1' MK∆T1 (5⍴0)
∆key∆31_TEST←'key1' MK∆T1 (5⍴1)
∆key∆32_TEST←'key1' MK∆T1 (5⍴0 1 2)
∆key∆33_TEST←'key1' MK∆T1 (5⍴0 2 4)
∆key∆34_TEST←'key1' MK∆T1 (5⍴0 0 0 2 2)
∆key∆35_TEST←'key1' MK∆T1 (5⍴0 4 4)
∆key∆36_TEST←'key1' MK∆T1 (5⍴0 1 2)
∆key∆37_TEST←'key1' MK∆T1 (5⍴0 2 4)
∆key∆38_TEST←'key1' MK∆T1 (5⍴0 0 0 2 2)
∆key∆39_TEST←'key1' MK∆T1 (5⍴0 4 4)
∆key∆40_TEST←'key3' MK∆T2 (⍳10)(⍬)
∆key∆41_TEST←'key3' MK∆T2 (⍳10)(0)
∆key∆42_TEST←'key3' MK∆T2 (⍳10)(0 1)
∆key∆43_TEST←'key3' MK∆T2 (⍳10)(1 1)
∆key∆44_TEST←'key3' MK∆T2 (⍳10)(1 2)
∆key∆45_TEST←'key3' MK∆T2 (⍳10)(0 2)
∆key∆46_TEST←'key3' MK∆T2 (⍳10)(1 2)
∆key∆47_TEST←'key3' MK∆T2 (⍳10)(2 2)
∆key∆48_TEST←'key3' MK∆T2 (⍳10)(0 3)
∆key∆49_TEST←'key3' MK∆T2 (⍳10)(1 3)
∆key∆50_TEST←'key3' MK∆T2 (⍳10)(2 3)
∆key∆51_TEST←'key3' MK∆T2 (⍳10)(5⍴0)
∆key∆52_TEST←'key3' MK∆T2 (⍳10)(5⍴1)
∆key∆53_TEST←'key3' MK∆T2 (⍳10)(5⍴0 1 2)
∆key∆54_TEST←'key3' MK∆T2 (⍳10)(5⍴0 2 4)
∆key∆55_TEST←'key3' MK∆T2 (⍳10)(5⍴0 0 0 2 2)
∆key∆56_TEST←'key3' MK∆T2 (⍳10)(5⍴0 4 4)
∆key∆57_TEST←'key3' MK∆T2 (⍳10)(5⍴0 1 2)
∆key∆58_TEST←'key3' MK∆T2 (⍳10)(5⍴0 2 4)
∆key∆59_TEST←'key3' MK∆T2 (⍳10)(5⍴0 0 0 2 2)
∆key∆60_TEST←'key3' MK∆T2 (⍳10)(5⍴0 4 4)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
