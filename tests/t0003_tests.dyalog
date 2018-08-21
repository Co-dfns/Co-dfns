:Require file://t0003.dyalog
:Namespace t0003_tests
 ∆0_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0003' ⋄ #.c0003←'t0003'#.codfns.Fix ⎕SRC #.t0003 ⋄ 0}
 ∆1_TEST←{#.UT.expect←↑'left' 'left2' 'right' 'right2' ⋄ #.c0003.⎕NL 3}
 ∆2_TEST←{#.UT.expect←5 ⋄ 3 #.c0003.right  5}
 ∆3_TEST←{#.UT.expect←3 ⋄ 3 #.c0003.left   5}
 ∆4_TEST←{#.UT.expect←5 ⋄ 3 #.c0003.right2 5}
 ∆5_TEST←{#.UT.expect←3 ⋄ 3 #.c0003.left2  5}
 ∆6_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨n←'c0003' 't0003' ⋄ #.⎕NC¨n}
:EndNamespace
