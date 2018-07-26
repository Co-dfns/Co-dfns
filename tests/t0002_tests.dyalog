:Require file://t0002.dyalog
:Namespace t0002_tests
 t0002∆0_TEST←{#.UT.expect←0 ⋄ #.c0002←'t0002'#.codfns.Fix ⎕SRC #.t0002 ⋄ 0}
 t0002∆1_TEST←{#.UT.expect←1 1⍴'F' ⋄ #.c0002.⎕NL 3}
 t0002∆2_TEST←{#.UT.expect←{}⍬ ⋄ #.c0002.F⍬}
:EndNamespace
