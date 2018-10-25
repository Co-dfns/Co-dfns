:Require file://t0009.dyalog
:Namespace t0009_tests

 tn←'t0009' ⋄ cn←'c0009'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn
 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0009←tn #.codfns.Fix ⎕SRC dy}

 bindings←{⍵[⍋⍵;]}⍉⍪'Run' 'blackscholes','bs'∘,∘⍕¨1+⍳9
 ∆01_TEST←{#.UT.expect←bindings ⋄ cd.⎕NL 3}

 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 D←{⍉1+?⍵ 3⍴1000}25 ⋄ L←,¯1↑D ⋄ R←2↑D
 ∆03_TEST←'Run' 1e¯10 MK∆T3 L R

 GD←{⍉↑(5+?⍵⍴25)(1+?⍵⍴100)(0.25+100÷⍨?⍵⍴1000)}
 D←⍉GD 7 ⋄ R←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L←,¯1↑D
 coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442

 ∆04_TEST←{#.UT.expect←L dy.bs1 R ⋄ L cd.bs1 R}
 ∆05_TEST←'bs2' 1e¯10 MK∆T3 L R
 ∆06_TEST←'bs3' 1e¯10 MK∆T3 L R
 ∆07_TEST←{#.UT.expect←L dy.bs4 R ⋄ L cd.bs4 R}
 ∆08_TEST←{#.UT.expect←L dy.bs5 R ⋄ L cd.bs5 R}
 ∆09_TEST←{#.UT.expect←dy.bs6 coeff ⋄ L cd.bs6 coeff}
 ∆10_TEST←{#.UT.expect←dy.bs7 coeff ⋄ L cd.bs7 coeff}
 ∆11_TEST←{#.UT.expect←L dy.bs8 R ⋄ L cd.bs8 R}
 ∆12_TEST←'bs9' 1e¯10 MK∆T3 L R
 ∆13_TEST←{#.UT.expect←L dy.blackscholes R ⋄ L cd.blackscholes R}
 ∆14_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
