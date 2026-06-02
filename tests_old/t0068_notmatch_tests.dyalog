:Require file://t0068.dyalog
:Namespace t0068_tests

 tn←'t0068' ⋄ cn←'c0068'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0068←tn #.codfns.Fix ⎕SRC dy}

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

∆notmatch∆01_TEST←'notmatch' MK∆T2 (⍬)(⍬)
∆notmatch∆02_TEST←'notmatch' MK∆T2 (0)(0)
∆notmatch∆03_TEST←'notmatch' MK∆T2 (⍬)(0)
∆notmatch∆04_TEST←'notmatch' MK∆T2 (⍬)(⍳5)
∆notmatch∆05_TEST←'notmatch' MK∆T2 (⍳7)(⍳5)
∆notmatch∆06_TEST←'notmatch' MK∆T2 (0)(⍳5)
∆notmatch∆07_TEST←'notmatch' MK∆T2 (2 2⍴⍳4)(2 2⍴⍳4)
∆notmatch∆08_TEST←'notmatch' MK∆T2 (2 2 3⍴⍳12)(2 2⍴⍳4)
∆notmatch∆09_TEST←'notmatch' MK∆T2 (2 2⍴⍳4)(2 2 3⍴⍳12)
∆notmatch∆10_TEST←'notmatch' MK∆T2 (2 2 3⍴⍳12)(2 2 3⍴1+⍳12)
∆notmatch∆11_TEST←'notmatch' MK∆T2 (0)(2 2⍴⍳4)
∆notmatch∆12_TEST←'notmatch' MK∆T2 (,0)(2 2⍴⍳4)
∆notmatch∆13_TEST←'notmatch' MK∆T2 (,0)(,0)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
