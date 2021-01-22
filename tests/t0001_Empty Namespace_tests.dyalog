:Namespace t0001_tests

 lc←':namespace' ':endnamespace' ⋄ uc←':NAMESPACE' ':ENDNAMESPACE'
 nc←':Namespace' ':EndNamespace' ⋄ mc←':NaMeSpAcE' ':eNdNaMeSpAcE'

 ∆0_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ 0⊣#.c0001←'t0001'#.codfns.Fix nc}
 ∆1_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆2_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ 0⊣#.c0001←'t0001'#.codfns.Fix lc}
 ∆3_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆4_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ 0⊣#.c0001←'t0001'#.codfns.Fix uc}
 ∆5_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆6_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ 0⊣#.c0001←'t0001'#.codfns.Fix mc}
 ∆7_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆8_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001'
  0⊣#.c0001←#.codfns.Compile'.\t0001.dyalog'}
 ∆9_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨n←'c0001' 't0001' ⋄ #.⎕NC¨n}

:EndNamespace
