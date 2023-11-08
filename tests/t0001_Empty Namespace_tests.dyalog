:Namespace t0001_tests

 lc←':namespace' ':endnamespace' ⋄ uc←':NAMESPACE' ':ENDNAMESPACE'
 nc←':Namespace' ':EndNamespace' ⋄ mc←':NaMeSpAcE' ':eNdNaMeSpAcE'
 
 ext←#.codfns.opsys '.dll' '.so' '.dylib'

 ∆0_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ 0⊣#.c0001←'t0001'#.codfns.Fix nc}
 ∆1_TEST←{#.UT.expect←0 ⋄ _←'init'⎕NA'I t0001',ext,'|cdf_ptr0_init' ⋄ (⎕EX'init')⊢init}
 ∆2_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆3_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ 0⊣#.c0001←'t0001'#.codfns.Fix lc}
 ∆4_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆5_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ 0⊣#.c0001←'t0001'#.codfns.Fix uc}
 ∆6_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆7_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ 0⊣#.c0001←'t0001'#.codfns.Fix mc}
 ∆8_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨n←'c0001' 't0001' ⋄ #.⎕NC¨n}

:EndNamespace
