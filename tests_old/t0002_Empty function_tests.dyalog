:Require file://t0002.dyalog
:Namespace t0002_tests
 ∆0_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX'c0002' ⋄ #.c0002←'t0002'#.codfns.Fix ⎕SRC #.t0002 ⋄ 0}
 ∆1_TEST←{#.UT.expect←1 1⍴'F' ⋄ #.c0002.⎕NL 3}
 ∆2_TEST←{#.UT.expect←0 ⋄ ⍎'#.c0002.F⍬ ⋄ 0'}
 ∆3_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨n←'c0002' 't0002' ⋄ #.⎕NC¨n}
:EndNamespace
