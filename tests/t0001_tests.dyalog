:Require file://t0001.dyalog
:Namespace t0001_tests
 ∆0_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0001' ⋄ #.c0001←'t0001'#.codfns.Fix ⎕SRC #.t0001 ⋄ 0}
 ∆1_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
 ∆2_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨n←'c0001' 't0001' ⋄ #.⎕NC¨n}
:EndNamespace
