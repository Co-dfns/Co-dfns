:Require file://t0008.dyalog
:Namespace t0008_tests
 tn←'t0008' ⋄ cn←'t0008'

 bindings←⍉⍪'Run'

 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0008←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←bindings ⋄ cd.⎕NL 3}

 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 D←{⍉1+?⍵ 3⍴1000}25 ⋄ L←,¯1↑D ⋄ R←2↑D

 ∆03_TEST←'Run' 1e¯10 MK∆T3 L R
 ∆04_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
