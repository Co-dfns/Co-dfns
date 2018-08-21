:Require file://t0004.dyalog
:Namespace t0004_tests
 tn←'t0004' ⋄ cn←'c0004'
 bindings←'dyadic' 'lists' 'literal' 'litvar' 'monadic' 'multi' 'parens'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn
 ∆00_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0004←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑bindings ⋄ cd.⎕NL 3}
 ∆02_TEST←{#.UT.expect←dy.monadic ⍳5 ⋄ cd.monadic ⍳5}
 ∆03_TEST←{#.UT.expect←dy.dyadic⍨⍳5 ⋄ cd.dyadic⍨⍳5}
 ∆04_TEST←{#.UT.expect←dy.literal⍬ ⋄ cd.literal⍬}
 ∆05_TEST←{#.UT.expect←dy.litvar ⍳5 ⋄ cd.litvar ⍳5}
 ∆06_TEST←{#.UT.expect←dy.multi⍨⍳5 ⋄ cd.multi⍨⍳5}
 ∆07_TEST←{#.UT.expect←dy.parens 1+⍳5 ⋄ cd.parens 1+⍳5}
 ∆08_TEST←{#.UT.expect←dy.lists ⍳5 ⋄ cd.lists ⍳5}
 ∆09_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}
:EndNamespace
