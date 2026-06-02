:Require file://t0062.dyalog
:Namespace t0062_tests

 tn←'t0062' ⋄ cn←'c0062'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0062←tn #.codfns.Fix ⎕SRC dy}

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

∆identity∆01_TEST←'identity' MK∆T1 (⍬)
∆identity∆02_TEST←'identity' MK∆T1 (0)
∆identity∆03_TEST←'identity' MK∆T1 (I32 ⍳5)
∆identity∆04_TEST←'identity' MK∆T1 (I16 ⍳5)
∆identity∆05_TEST←'identity' MK∆T1 (I8 ⍳5)
∆identity∆06_TEST←'identity' MK∆T1 (I32 2 3 4⍴⍳5)
∆identity∆07_TEST←'identity' MK∆T1 (I16 2 3 4⍴⍳5)
∆identity∆08_TEST←'identity' MK∆T1 (I8 2 3 4⍴⍳5)
∆identity∆09_TEST←'identity' MK∆T1 (2 3 4⍴0 1 1)
∆identity∆10_TEST←'identity' MK∆T1 (4⍴0 1 1)
∆identity∆11_TEST←'identity' MK∆T1 (24⍴0 1 1)
∆identity∆12_TEST←'identity' MK∆T1 (1j1×⍳10)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
