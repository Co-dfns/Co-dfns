:Require file://t0023.dyalog
:Namespace t0023_tests

 tn←'t0023' ⋄ cn←'c0023'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 aa←256⍪0⍪0⍪?2 4 8⍴256
 ba←256⍪0⍪0⍪?2 4 8⍴256
 ab←256⍪0⍪0⍪?4 4 8⍴256
 bb←256⍪0⍪0⍪?4 4 8⍴256
 ac←8 16∘⍴⍤0⊢¯35↑(⌽,1∘↓)(×⍨255)×-∘⍳⍨16
 ad←(¯1∘↑,∘⊂⍨¯1↓⊂⍤¯1)?14 16 8⍴2
 ae←?4 16⍴256
 af←256⍪0⍪0⍪?4 3 2 1⍴256
 c←2
 m←3↑256+2*16
 ra←8 8
 t←3?3

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0023←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←dy.rav aa ⋄ cd.rav aa}
 ∆02_TEST←{#.UT.expect←dy.cat aa ⋄ cd.cat aa}
 ∆03_TEST←{#.UT.expect←dy.pic aa ⋄ cd.pic aa}
 ∆04_TEST←{#.UT.expect←dy.bas aa ⋄ cd.bas aa}
 ∆05_TEST←{#.UT.expect←dy.sg0 aa ⋄ cd.sg0 aa}
 ∆06_TEST←{#.UT.expect←dy.neg aa ⋄ cd.neg aa}
 ∆07_TEST←{#.UT.expect←dy.top aa ⋄ cd.top aa}
 ∆08_TEST←{#.UT.expect←dy.isb aa ⋄ cd.isb aa}
 ∆09_TEST←{#.UT.expect←dy.isr aa ⋄ cd.isr aa}
 ∆10_TEST←{#.UT.expect←dy.ful aa ⋄ cd.ful aa}
 ∆11_TEST←{#.UT.expect←dy.zer aa ⋄ cd.zer aa}
 ∆12_TEST←{#.UT.expect←256 0 0 dy.mta aa ⋄ 256 0 0 cd.mta aa}
 ∆13_TEST←{#.UT.expect←dy.cr1 ab-bb ⋄ cd.cr1 ab-bb}
 ∆14_TEST←{#.UT.expect←dy.cr2 ab-bb ⋄ cd.cr2 ab-bb}
 ∆15_TEST←{#.UT.expect←dy.cr1 ac ⋄ cd.cr1 ac}
 ∆16_TEST←{#.UT.expect←dy.cr2 ac ⋄ cd.cr2 ac}
 ∆17_TEST←{#.UT.expect←dy.cr4 ac ⋄ cd.cr4 ac}
 ∆18_TEST←{#.UT.expect←cd.get_sb0_sm0⍬ ⋄ dy.(sb0 sm0)←cd.get_sb0_sm0⍬ ⋄ dy.(sb0 sm0)}
 ∆19_TEST←{#.UT.expect←dy.aew ad ⋄ cd.aew ad}
 ∆20_TEST←{#.UT.expect←ra dy.rho m ⋄ ra cd.rho m}
 ∆21_TEST←{#.UT.expect←dy.fft ae ⋄ cd.fft ae}
 ∆22_TEST←{#.UT.expect←t dy.trn2 af ⋄ t cd.trn2 af}

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
