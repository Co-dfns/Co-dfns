:Require file://t0023.dyalog
:Namespace t0023_tests

 tn←'t0023' ⋄ cn←'c0023'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 aa←256⍪⌊?32⍪2⍪1 2 0⍉⌽256⍴⍤0⍨32⌊0⌈¯32+?8 16⍴96
 ab←256⍪⌊?32⍪2⍪1 2 0⍉⌽256⍴⍤0⍨32⌊0⌈¯32+?8 16⍴96
 ac←256@0⊢0@1 2⊢aa-ab
 ad←0J256⍪(?16 8⍴32)⍪0⍪0J256|1 0J1+.×?2 32 16 8⍴256
 p1←64
 p2←16
 r0←0
 r1←?8 16⍴32
 
 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0023←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←dy.rav aa ⋄ cd.rav aa}
 ∆02_TEST←{#.UT.expect←dy.cat aa ⋄ cd.cat aa}
 ∆03_TEST←{#.UT.expect←dy.pic aa ⋄ cd.pic aa}
 ∆04_TEST←{#.UT.expect←dy.bas aa ⋄ cd.bas aa}
 ∆05_TEST←{#.UT.expect←dy.sg0 aa ⋄ cd.sg0 aa}
 ∆06_TEST←{#.UT.expect←dy.isn aa ⋄ cd.isn aa}
 ∆07_TEST←{#.UT.expect←dy.top aa ⋄ cd.top aa}
 ∆08_TEST←{#.UT.expect←dy.v01 aa ⋄ cd.v01 aa}
 ∆09_TEST←{#.UT.expect←dy.isr aa ⋄ cd.isr aa}
 ∆10_TEST←{#.UT.expect←dy.ful aa ⋄ cd.ful aa}
 ∆11_TEST←{#.UT.expect←dy.zer aa ⋄ cd.zer aa}
 ∆12_TEST←{#.UT.expect←256 0 0 dy.mta aa ⋄ 256 0 0 cd.mta aa}
 ∆13_TEST←{#.UT.expect←dy.ovr aa ⋄ cd.ovr aa}
 ∆14_TEST←{#.UT.expect←p1 dy.pla1 aa ⋄ p1 cd.pla1 aa}
 ∆15_TEST←{#.UT.expect←p2 dy.pla2 aa ⋄ p2 cd.pla2 aa}
 ∆16_TEST←{#.UT.expect←r0 dy.mov aa ⋄ r0 cd.mov aa}
 ∆17_TEST←{#.UT.expect←r1 dy.mov aa ⋄ r1 cd.mov aa}
 ∆18_TEST←{#.UT.expect←r1 dy.cry1 ab ⋄ r1 cd.cry1 ab}
 
 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
