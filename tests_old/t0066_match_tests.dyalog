:Require file://t0066.dyalog
:Namespace t0066_tests

 tn←'t0066' ⋄ cn←'c0066'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0066←tn #.codfns.Fix ⎕SRC dy}

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

∆match∆01_TEST←'match' MK∆T2 (⍬)	(⍬)
∆match∆02_TEST←'match' MK∆T2 (0)	(0)
∆match∆03_TEST←'match' MK∆T2 (⍬)	(0)
∆match∆04_TEST←'match' MK∆T2 (⍬)	(⍳5)
∆match∆05_TEST←'match' MK∆T2 (⍳7)	(⍳5)
∆match∆06_TEST←'match' MK∆T2 (0)	(⍳5)
∆match∆07_TEST←'match' MK∆T2 (2 2⍴⍳4)	(2 2⍴⍳4)
∆match∆08_TEST←'match' MK∆T2 (2 2 3⍴⍳12)	(2 2⍴⍳4)
∆match∆09_TEST←'match' MK∆T2 (2 2⍴⍳4)	(2 2 3⍴⍳12)
∆match∆10_TEST←'match' MK∆T2 (2 2 3⍴⍳12)	(2 2 3⍴1+⍳12)
∆match∆11_TEST←'match' MK∆T2 (0)	(2 2⍴⍳4)
∆match∆12_TEST←'match' MK∆T2 (,0)	(2 2⍴⍳4)
∆match∆13_TEST←'match' MK∆T2 (,0)	(,0)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
