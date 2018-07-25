:Require file://t0001.dyalog
:Namespace t0001_tests
 t0001∆0build_TEST←{#.UT.expect←0 ⋄ #.c0001←'t0001'#.codfns.Fix ⎕SRC #.t0001 ⋄ 0}
 t0001∆1names_TEST←{#.UT.expect←0 0⍴'' ⋄ #.c0001.⎕NL 3}
:EndNamespace
