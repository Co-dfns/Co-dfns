:Require file://t0005.dyalog
:Namespace t0005_tests
 tn←'t0005' ⋄ cn←'c0005'
 bindings←,⊂'f1'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn
 ∆00_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0005←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑bindings ⋄ cd.⎕NL 3}
 ∆02_TEST←{#.UT.expect←dy.f1 ⍳5 ⋄ cd.f1 ⍳5}
 ∆07_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}
:EndNamespace
