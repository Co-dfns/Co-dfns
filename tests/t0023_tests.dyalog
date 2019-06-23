:Require file://t0023.dyalog
:Namespace t0023_tests

 tn←'t0023' ⋄ cn←'c0023'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 aa←256⍪0⍪0⍪?2 4 8⍴256
 ba←256⍪0⍪0⍪?2 4 8⍴256
 ab←256⍪0⍪0⍪?32 512 1024⍴256
 bb←256⍪0⍪0⍪?32 512 1024⍴256
 c←2
 m←3↑256+2*16


 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0023←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←dy.rav aa ⋄ cd.rav aa}

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
