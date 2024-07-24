:Require file://t0025.dyalog
:Namespace t0025_tests

 tn←'t0025' ⋄ cn←'c0025'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0025←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←dy.f01⍬ ⋄ cd.f01⍬}
 ∆02_TEST←{#.UT.expect←dy.f02⍬ ⋄ cd.f02⍬}
 ∆03_TEST←{#.UT.expect←dy.f03⍬ ⋄ cd.f03⍬}
 ∆04_TEST←{#.UT.expect←dy.f04⍬ ⋄ cd.f04⍬}
 ∆05_TEST←{#.UT.expect←dy.f05⍬ ⋄ cd.f05⍬}
 ∆06_TEST←{#.UT.expect←dy.f06⍬ ⋄ cd.f06⍬}
 ∆07_TEST←{#.UT.expect←dy.f07⍬ ⋄ cd.f07⍬}
 ∆08_TEST←{#.UT.expect←dy.f08⍬ ⋄ cd.f08⍬}
 ∆09_TEST←{#.UT.expect←dy.f09⍬ ⋄ cd.f09⍬}
 ∆10_TEST←{#.UT.expect←'LENGTH ERROR' ⋄ 5::'LENGTH ERROR' ⋄ cd.f10⍬}
 ∆11_TEST←{#.UT.expect←dy.f11⍬ ⋄ cd.f11⍬}
 ∆12_TEST←{#.UT.expect←dy.f12⍬ ⋄ cd.f12⍬}
 ∆13_TEST←{#.UT.expect←dy.f13⍬ ⋄ cd.f13⍬}
 ∆14_TEST←{#.UT.expect←'RANK ERROR' ⋄ 4::'RANK ERROR' ⋄ cd.f14⍬}
 ∆15_TEST←{#.UT.expect←dy.f15⍬ ⋄ cd.f15⍬}
 ∆16_TEST←{#.UT.expect←dy.f16⍬ ⋄ cd.f16⍬}
 ∆17_TEST←{#.UT.expect←dy.f17⍬ ⋄ cd.f17⍬}
 ∆18_TEST←{#.UT.expect←dy.f18⍬ ⋄ cd.f18⍬}
 ∆19_TEST←{#.UT.expect←dy.f19⍬ ⋄ cd.f19⍬}
 ∆20_TEST←{#.UT.expect←dy.f20⍬ ⋄ cd.f20⍬}
 ∆21_TEST←{#.UT.expect←dy.f21⍬ ⋄ cd.f21⍬}
 ∆22_TEST←{#.UT.expect←dy.f22⍬ ⋄ cd.f22⍬}
 ∆23_TEST←{#.UT.expect←dy.f23⍬ ⋄ cd.f23⍬}
 ∆24_TEST←{#.UT.expect←dy.f24⍬ ⋄ cd.f24⍬}
 ∆25_TEST←{#.UT.expect←dy.f25⍬ ⋄ cd.f25⍬}
 ∆26_TEST←{#.UT.expect←dy.f26⍬ ⋄ cd.f26⍬}
 ∆27_TEST←{#.UT.expect←dy.f27⍬ ⋄ cd.f27⍬}
 ∆28_TEST←{#.UT.expect←dy.f28⍬ ⋄ cd.f28⍬}
 ∆29_TEST←{#.UT.expect←dy.f29⍬ ⋄ cd.f29⍬}
 ∆30_TEST←{#.UT.expect←dy.f30⍬ ⋄ cd.f30⍬}
 ∆31_TEST←{#.UT.expect←dy.f31⍬ ⋄ cd.f31⍬}
 ⍝ ∆32_TEST←{#.UT.expect←dy.f32⍬ ⋄ cd.f32⍬}
 ∆33_TEST←{#.UT.expect←dy.f33⍬ ⋄ cd.f33⍬}

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
