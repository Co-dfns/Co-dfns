:Require file://t0035.dyalog
:Namespace t0035_tests

 tn←'t0035' ⋄ cn←'c0035'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0035←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆commute∆ii_TEST←'commute∆Run' MK∆T2 I I
∆commute∆ff_TEST←'commute∆Run' MK∆T2 F F
∆commute∆if_TEST←'commute∆Run' MK∆T2 I F
∆commute∆fi_TEST←'commute∆Run' MK∆T2 F I
∆commute∆bb_TEST←'commute∆Run' MK∆T2 B B
∆commute∆bi_TEST←'commute∆Run' MK∆T2 B I
∆commute∆bf_TEST←'commute∆Run' MK∆T2 B F
∆commute∆ib_TEST←'commute∆Run' MK∆T2 I B
∆commute∆fb_TEST←'commute∆Run' MK∆T2 F B
∆commute∆i_TEST←'commute∆Rm' MK∆T1 I
∆commute∆f_TEST←'commute∆Rm' MK∆T1 F
∆commute∆b_TEST←'commute∆Rm' MK∆T1 B

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace