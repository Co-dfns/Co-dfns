:Require file://t0085.dyalog
:Namespace t0085_tests

 tn←'t0085' ⋄ cn←'c0085'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0085←tn #.codfns.Fix ⎕SRC dy}

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

∆gradeup∆01_TEST←'gradeup' MK∆T1 (⍬)
∆gradeup∆02_TEST←'gradeup' MK∆T1 (,1)
∆gradeup∆03_TEST←'gradeup' MK∆T1 (1 0)
∆gradeup∆04_TEST←'gradeup' MK∆T1 (⍳3)
∆gradeup∆05_TEST←'gradeup' MK∆T1 (⌽⍳3)
∆gradeup∆06_TEST←'gradeup' MK∆T1 (?25⍴20)
∆gradeup∆07_TEST←'gradeup' MK∆T1 (?100⍴50)
∆gradeup∆08_TEST←'gradeup' MK∆T1 (10⍴50)
∆gradeup∆09_TEST←'gradeup' MK∆T1 (F ⍬)
∆gradeup∆10_TEST←'gradeup' MK∆T1 (F ,1)
∆gradeup∆11_TEST←'gradeup' MK∆T1 (F ⍳3)
∆gradeup∆12_TEST←'gradeup' MK∆T1 (F ⌽⍳3)
∆gradeup∆13_TEST←'gradeup' MK∆T1 (F ?25⍴20)
∆gradeup∆14_TEST←'gradeup' MK∆T1 (F ?100⍴50)
∆gradeup∆15_TEST←'gradeup' MK∆T1 (F 10⍴50)
∆gradeup∆16_TEST←'gradeup' MK∆T1 (?10 10⍴50)
∆gradeup∆17_TEST←'gradeup' MK∆T1 (?10 10 15⍴50)
∆gradeup∆18_TEST←'gradeup' MK∆T1 (F ?10 10⍴50)
∆gradeup∆19_TEST←'gradeup' MK∆T1 (F ?10 10 15⍴50)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
