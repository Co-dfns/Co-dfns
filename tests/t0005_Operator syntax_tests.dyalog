:Require file://t0005.dyalog
:Namespace t0005_tests
 tn←'t0005' ⋄ cn←'c0005'
 bindings←'dmop' 'dop' 'mdop' 'mmop' 'ndop' 'nmop' 'umop'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn
 ∆00_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0005←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑bindings ⋄ cd.⎕NL 3}
 ∆02_TEST←{#.UT.expect←dy.mmop ⍳5 ⋄ cd.mmop ⍳5}
 ∆03_TEST←{#.UT.expect←2 dy.dmop ⍳10 ⋄ 2 cd.dmop ⍳10}
 ∆04_TEST←{#.UT.expect←dy.dop⍨⍳5 ⋄ cd.dop⍨⍳5}
 ∆05_TEST←{#.UT.expect←dy.mdop 5 ⋄ cd.mdop 5}
 ∆06_TEST←{#.UT.expect←dy.umop ⍳5 ⋄ cd.umop ⍳5}
 ∆07_TEST←{#.UT.expect←dy.nmop ⍳5 ⋄ cd.nmop ⍳5}
 ∆08_TEST←{#.UT.expect←(⍳5)dy.ndop ⍳5 ⋄ (⍳5)cd.ndop ⍳5}
 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}
:EndNamespace
