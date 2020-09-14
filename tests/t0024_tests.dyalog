:Require file://t0024.dyalog
:Namespace t0024_tests

 tn←'t0024' ⋄ cn←'c0023'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←'Unsupported feature'
   0::'Failed compile'
   2::'Syntax error'
  16::'Unsupported feature'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0023←tn #.codfns.Fix ⎕SRC dy}

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
