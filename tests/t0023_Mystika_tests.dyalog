:Require file://t0023.dyalog
:Namespace t0023_tests

 tn←'t0023' ⋄ cn←'c0023'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 aa←256⍪0⍪0⍪?2 4 8⍴256
 ba←256⍪0⍪0⍪?2 4 8⍴256
 ab←256⍪0⍪0⍪?32 512 1024⍴256
 bb←256⍪0⍪0⍪?32 512 1024⍴256
 ac←512 1024∘⍴⍤0⊢¯35↑(⌽,1∘↓)(×⍨255)×-∘⍳⍨16
 ad←(¯1∘↑,∘⊂⍨¯1↓⊂⍤¯1)?14 16 8⍴2
 c←2
 m←3↑256+2*16


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
 ∆14_TEST←{#.UT.expect←dy.cr1 ac ⋄ cd.cr1 ac}
 ∆15_TEST←{#.UT.expect←dy.aew ad ⋄ cd.aew ad}

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
