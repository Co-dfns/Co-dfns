:Require file://t0024.dyalog
:Namespace t0024_tests

 tn←'t0024' ⋄ cn←'c0023'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←'Successful compile'
   0::'Failed compile'
   2::'Syntax error'
  16::'Unsupported feature'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0023←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←2 ⋄ cd.f1 ⍬}
 ∆02_TEST←{#.UT.expect←3 ⋄ cd.f2 ⍬}

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
