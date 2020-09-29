:Require file://t0026.dyalog
:Namespace t0026_tests

 tn←'t0026' ⋄ cn←'c0026'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0026←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←'SYNTAX ERROR' ⋄ 2::'SYNTAX ERROR'
  code←':Namespace' 'f←{(⍳5)+[]⍳5}' ':EndNamespace'
  'Successful compile'⊣'t0026_a'#.codfns.Fix code}

 ∆02_TEST←{#.UT.expect←'NONCE' ⋄ 16::'NONCE' ⋄ 0 cd.f1 ⍳5}
 ⍝ ∆02_TEST←{#.UT.expect←0 dy.f1 ⍳5 ⋄ 0 cd.f1 ⍳5}

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
