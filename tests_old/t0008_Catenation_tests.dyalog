:Require file://t0008.dyalog
:Namespace t0008_tests
 tn←'t0008' ⋄ cn←'c0008'

 bindings←⍉⍪'cat'

 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0008←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←bindings ⋄ cd.⎕NL 3}
 ∆02_TEST←{#.UT.expect←⍬ dy.cat ⍬ ⋄ ⍬ cd.cat ⍬}
 ∆03_TEST←{#.UT.expect←5 dy.cat 5 ⋄ 5 cd.cat 5}
 ∆04_TEST←{#.UT.expect←⍬ dy.cat 5 ⋄ ⍬ cd.cat 5}
 ∆05_TEST←{#.UT.expect←⍬ dy.cat ⍳5 ⋄ ⍬ cd.cat ⍳5}
 ∆06_TEST←{#.UT.expect←(⍳7)dy.cat ⍳5 ⋄ (⍳7)cd.cat ⍳5}
 ∆07_TEST←{#.UT.expect←5 dy.cat ⍳5 ⋄ 5 cd.cat ⍳5}
 ∆08_TEST←{#.UT.expect←(2 2⍴5) dy.cat (2 2⍴5) ⋄ (2 2⍴5) cd.cat (2 2⍴5)}
 ∆09_TEST←{#.UT.expect←(2 2 3⍴5) dy.cat (2 2⍴5) ⋄ (2 2 3⍴5) cd.cat (2 2⍴5)}
 ∆10_TEST←{#.UT.expect←(2 2⍴5) dy.cat (2 2 3⍴5) ⋄ (2 2⍴5) cd.cat (2 2 3⍴5)}
 ∆11_TEST←{#.UT.expect←(2 2⍴5) dy.cat (2 2 3⍴5) ⋄ (2 2⍴5) cd.cat (2 2 3⍴5)}
 ∆12_TEST←{#.UT.expect←5 dy.cat (2 2⍴5) ⋄ 5 cd.cat (2 2⍴5)}
 ∆13_TEST←{#.UT.expect←(,5 5) dy.cat (2 2⍴5) ⋄ (,5 5)cd.cat (2 2⍴5)}
 ∆14_TEST←{#.UT.expect←(,5) dy.cat (,5) ⋄ (,5) cd.cat (,5)}
 ∆15_TEST←{#.UT.expect←(,1 0) dy.cat (2 2⍴1 0 0) ⋄ (,1 0) cd.cat (2 2⍴1 0 0)}
 ∆16_TEST←{#.UT.expect←(,5 4) dy.cat (2 2⍴1 0 0) ⋄ (,5 4) cd.cat (2 2⍴1 0 0)}
 ∆17_TEST←{#.UT.expect←(2 2⍴1 0 0)dy.cat (,5 4) ⋄ (2 2⍴1 0 0)cd.cat (,5 4)}
 ∆18_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
