:Require file://t0089.dyalog
:Namespace t0089_tests

 tn←'t0089' ⋄ cn←'c0089'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0089←tn #.codfns.Fix ⎕SRC dy}

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

∆intersection∆01_TEST←'intersection' MK∆T2 (⍬)(⍬)
∆intersection∆02_TEST←'intersection' MK∆T2 (1)(⍬)
∆intersection∆03_TEST←'intersection' MK∆T2 (⍳5)(⍬)
∆intersection∆04_TEST←'intersection' MK∆T2 (?10⍴5)(⍬)
∆intersection∆05_TEST←'intersection' MK∆T2 (1)(1)
∆intersection∆06_TEST←'intersection' MK∆T2 (⍬)(1)
∆intersection∆07_TEST←'intersection' MK∆T2 (⍬)(⍳5)
∆intersection∆08_TEST←'intersection' MK∆T2 (⍬)(?10⍴5)
∆intersection∆09_TEST←'intersection' MK∆T2 (1)(⍳5)
∆intersection∆10_TEST←'intersection' MK∆T2 (1)(?10⍴5)
∆intersection∆11_TEST←'intersection' MK∆T2 (⍳5)(⍳5)
∆intersection∆12_TEST←'intersection' MK∆T2 (⍳5)(?10⍴5)
∆intersection∆13_TEST←'intersection' MK∆T2 (⍳5)(20+?10⍴5)
∆intersection∆14_TEST←'intersection' MK∆T2 (10+⍳5)(?10⍴5)
∆intersection∆15_TEST←'intersection' MK∆T2 (?10⍴5)(?10⍴5)
∆intersection∆16_TEST←'intersection' MK∆T2 (10+?10⍴5)(?10⍴5)
∆intersection∆17_TEST←'intersection' MK∆T2 (?10⍴5)(10+?10⍴5)
∆intersection∆18_TEST←'intersection' MK∆T2 (?50⍴100)(?50⍴100)
∆intersection∆19_TEST←'intersection' MK∆T2 (F ⍬)(⍬)
∆intersection∆20_TEST←'intersection' MK∆T2 (F 1)(⍬)
∆intersection∆21_TEST←'intersection' MK∆T2 (F ⍳5)(⍬)
∆intersection∆22_TEST←'intersection' MK∆T2 (F ?10⍴5)(⍬)
∆intersection∆23_TEST←'intersection' MK∆T2 (F 1)(1)
∆intersection∆24_TEST←'intersection' MK∆T2 (F ⍬)(1)
∆intersection∆25_TEST←'intersection' MK∆T2 (F ⍬)(⍳5)
∆intersection∆26_TEST←'intersection' MK∆T2 (F ⍬)(?10⍴5)
∆intersection∆27_TEST←'intersection' MK∆T2 (F 1)(⍳5)
∆intersection∆28_TEST←'intersection' MK∆T2 (F 1)(?10⍴5)
∆intersection∆29_TEST←'intersection' MK∆T2 (F ⍳5)(⍳5)
∆intersection∆30_TEST←'intersection' MK∆T2 (F ⍳5)(?10⍴5)
∆intersection∆31_TEST←'intersection' MK∆T2 (F ⍳5)(20+?10⍴5)
∆intersection∆32_TEST←'intersection' MK∆T2 (F 10+⍳5)(?10⍴5)
∆intersection∆33_TEST←'intersection' MK∆T2 (F ?10⍴5)(?10⍴5)
∆intersection∆34_TEST←'intersection' MK∆T2 (F 10+?10⍴5)(?10⍴5)
∆intersection∆35_TEST←'intersection' MK∆T2 (F ?10⍴5)(10+?10⍴5)
∆intersection∆36_TEST←'intersection' MK∆T2 (F ?50⍴100)(?50⍴100)
∆intersection∆37_TEST←'intersection' MK∆T2 (⍬)(F ⍬)
∆intersection∆38_TEST←'intersection' MK∆T2 (1)(F ⍬)
∆intersection∆39_TEST←'intersection' MK∆T2 (⍳5)(F ⍬)
∆intersection∆40_TEST←'intersection' MK∆T2 (?10⍴5)(F ⍬)
∆intersection∆41_TEST←'intersection' MK∆T2 (1)(F 1)
∆intersection∆42_TEST←'intersection' MK∆T2 (⍬)(F 1)
∆intersection∆43_TEST←'intersection' MK∆T2 (⍬)(F ⍳5)
∆intersection∆44_TEST←'intersection' MK∆T2 (⍬)(F ?10⍴5)
∆intersection∆45_TEST←'intersection' MK∆T2 (1)(F ⍳5)
∆intersection∆46_TEST←'intersection' MK∆T2 (1)(F ?10⍴5)
∆intersection∆47_TEST←'intersection' MK∆T2 (⍳5)(F ⍳5)
∆intersection∆48_TEST←'intersection' MK∆T2 (⍳5)(F ?10⍴5)
∆intersection∆49_TEST←'intersection' MK∆T2 (⍳5)(F 20+?10⍴5)
∆intersection∆50_TEST←'intersection' MK∆T2 (10+⍳5)(F ?10⍴5)
∆intersection∆51_TEST←'intersection' MK∆T2 (?10⍴5)(F ?10⍴5)
∆intersection∆52_TEST←'intersection' MK∆T2 (10+?10⍴5)(F ?10⍴5)
∆intersection∆53_TEST←'intersection' MK∆T2 (?10⍴5)(F 10+?10⍴5)
∆intersection∆54_TEST←'intersection' MK∆T2 (?50⍴100)(?F 50⍴100)
∆intersection∆55_TEST←'intersection' MK∆T2 (F ⍬)(F ⍬)
∆intersection∆56_TEST←'intersection' MK∆T2 (F 1)(F ⍬)
∆intersection∆57_TEST←'intersection' MK∆T2 (F ⍳5)(F ⍬)
∆intersection∆58_TEST←'intersection' MK∆T2 (F ?10⍴5)(F ⍬)
∆intersection∆59_TEST←'intersection' MK∆T2 (F 1)(F 1)
∆intersection∆60_TEST←'intersection' MK∆T2 (F ⍬)(F 1)
∆intersection∆61_TEST←'intersection' MK∆T2 (F ⍬)(F ⍳5)
∆intersection∆62_TEST←'intersection' MK∆T2 (F ⍬)(F ?10⍴5)
∆intersection∆63_TEST←'intersection' MK∆T2 (F 1)(F ⍳5)
∆intersection∆64_TEST←'intersection' MK∆T2 (F 1)(F ?10⍴5)
∆intersection∆65_TEST←'intersection' MK∆T2 (F ⍳5)(F ⍳5)
∆intersection∆66_TEST←'intersection' MK∆T2 (F ⍳5)(F ?10⍴5)
∆intersection∆67_TEST←'intersection' MK∆T2 (F ⍳5)(F 20+?10⍴5)
∆intersection∆68_TEST←'intersection' MK∆T2 (F 10+⍳5)(F ?10⍴5)
∆intersection∆69_TEST←'intersection' MK∆T2 (F ?10⍴5)(F ?10⍴5)
∆intersection∆70_TEST←'intersection' MK∆T2 (F 10+?10⍴5)(F ?10⍴5)
∆intersection∆71_TEST←'intersection' MK∆T2 (F ?10⍴5)(F 10+?10⍴5)
∆intersection∆72_TEST←'intersection' MK∆T2 (F ?50⍴100)(?F 50⍴100)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
