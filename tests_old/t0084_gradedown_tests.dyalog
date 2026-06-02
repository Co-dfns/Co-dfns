:Require file://t0084.dyalog
:Namespace t0084_tests

 tn←'t0084' ⋄ cn←'c0084'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0084←tn #.codfns.Fix ⎕SRC dy}

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

∆gradedown∆01_TEST←'gradedown' MK∆T1 (⍬)
∆gradedown∆02_TEST←'gradedown' MK∆T1 (,1)
∆gradedown∆03_TEST←'gradedown' MK∆T1 (1 0)
∆gradedown∆04_TEST←'gradedown' MK∆T1 (⍳3)
∆gradedown∆05_TEST←'gradedown' MK∆T1 (⌽⍳3)
∆gradedown∆06_TEST←'gradedown' MK∆T1 (?25⍴20)
∆gradedown∆07_TEST←'gradedown' MK∆T1 (?100⍴50)
∆gradedown∆08_TEST←'gradedown' MK∆T1 (10⍴50)
∆gradedown∆09_TEST←'gradedown' MK∆T1 (F ⍬)
∆gradedown∆10_TEST←'gradedown' MK∆T1 (F ,1)
∆gradedown∆11_TEST←'gradedown' MK∆T1 (F ⍳3)
∆gradedown∆12_TEST←'gradedown' MK∆T1 (F ⌽⍳3)
∆gradedown∆13_TEST←'gradedown' MK∆T1 (F ?25⍴20)
∆gradedown∆14_TEST←'gradedown' MK∆T1 (F ?100⍴50)
∆gradedown∆15_TEST←'gradedown' MK∆T1 (F 10⍴50)
∆gradedown∆16_TEST←'gradedown' MK∆T1 (?10 10⍴50)
∆gradedown∆17_TEST←'gradedown' MK∆T1 (?10 10 15⍴50)
∆gradedown∆18_TEST←'gradedown' MK∆T1 (F ?10 10⍴50)
∆gradedown∆19_TEST←'gradedown' MK∆T1 (F ?10 10 15⍴50)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
