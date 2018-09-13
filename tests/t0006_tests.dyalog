:Require file://t0006.dyalog
:Namespace t0006_tests
 tn←'t0006' ⋄ cn←'c0006'
 bindings←'f1' 'f2' 'f3' 'f4' 'f5' 'f6' 'f7'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn
 ∆00_TEST←{#.UT.expect←0 ⋄ _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0006←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←↑bindings ⋄ cd.⎕NL 3}
 ∆02_TEST←{#.UT.expect←dy.f1 ⍳5 ⋄ cd.f1 ⍳5}
 ∆03_TEST←{#.UT.expect←dy.f2 ⍳5 ⋄ cd.f2 ⍳5}
 ∆04_TEST←{#.UT.expect←dy.f3 5 ⋄ cd.f3 5}
 ∆05_TEST←{#.UT.expect←dy.f4 0 ⋄ cd.f4 0}
 ⍝ ∆06_TEST←{#.UT.expect←dy.f5 0 ⋄ cd.f5 0}
 ⍝ ∆07_TEST←{#.UT.expect←dy.f6 0 ⋄ cd.f6 0}
 ⍝ ∆08_TEST←{#.UT.expect←3 dy.f7 1 2 3 1 2 3 ⋄ 3 cd.f7 1 2 3 1 2 3}
 ⍝ ∆09_TEST←{#.UT.expect←... f8 ...}
 ⍝ ∆10_TEST←{#.UT.expect←... f9 ...}
 ⍝ ∆11_TEST←{#.UT.expect←dy.f10 ⍬ ⋄ cd.f10 ⍬}
 ∆12_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}
:EndNamespace
