:Require file://t0025.dyalog
:Namespace t0025_tests

 tn←'t0025' ⋄ cn←'c0025'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←'Successful compile'
   0::'Failed compile'
   2::'Syntax error'
  16::'Unsupported feature'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0025←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←dy.f1⍬ ⋄ cd.f1⍬}
 ∆02_TEST←{#.UT.expect←dy.f2⍬ ⋄ cd.f2⍬}
 ∆03_TEST←{#.UT.expect←'LENGTH ERROR' ⋄ 5::'LENGTH ERROR' ⋄ cd.f3⍬}
 ∆04_TEST←{#.UT.expect←dy.f4⍬ ⋄ cd.f4⍬}
 ∆05_TEST←{#.UT.expect←dy.f5⍬ ⋄ cd.f5⍬}
 ∆06_TEST←{#.UT.expect←dy.f6⍬ ⋄ cd.f6⍬}
 ∆07_TEST←{#.UT.expect←dy.f7⍬ ⋄ cd.f7⍬}
 ∆08_TEST←{#.UT.expect←dy.f8⍬ ⋄ cd.f8⍬}
 ∆09_TEST←{#.UT.expect←dy.f9⍬ ⋄ cd.f9⍬}
 ∆10_TEST←{#.UT.expect←dy.f10⍬ ⋄ cd.f10⍬}
 ∆11_TEST←{#.UT.expect←dy.f11⍬ ⋄ cd.f11⍬}
 ∆12_TEST←{#.UT.expect←dy.f12⍬ ⋄ cd.f12⍬}
 ∆13_TEST←{#.UT.expect←dy.f13⍬ ⋄ cd.f13⍬}
 ∆14_TEST←{#.UT.expect←dy.f14⍬ ⋄ cd.f14⍬}
 ∆15_TEST←{#.UT.expect←dy.f15⍬ ⋄ cd.f15⍬}
 ∆16_TEST←{#.UT.expect←dy.f16⍬ ⋄ cd.f16⍬}
 ∆17_TEST←{#.UT.expect←dy.f17⍬ ⋄ cd.f17⍬}
 ∆18_TEST←{#.UT.expect←dy.f18⍬ ⋄ cd.f18⍬}
 ∆19_TEST←{#.UT.expect←dy.f19⍬ ⋄ cd.f19⍬}

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
