:Require file://t0020.dyalog
:Namespace t0020_tests

 tn←'t0020' ⋄ cn←'c0020'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0020←tn #.codfns.Fix ⎕SRC dy}

 ⍝ ∆01_TEST←{#.UT.expect←⍳5 ⋄ _←cd.∆.Init
 ⍝  ptr←cd.∆.MKA ⍳5 ⋄ z←cd.∆.EXA ptr ⋄ z⊣_←cd.∆.FREA ptr}

 ⍝ ∆02_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣cd.∆.Sync}

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
