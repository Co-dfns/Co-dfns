:Namespace t0022_tests

 ns←{':Namespace'('F←{',⍵,'}')':EndNamespace'}

 ∆00_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'⍺⍪⍵'}
 ∆01_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'⍺⌿⍵'}
 ∆02_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'⍺(,⍤1)⍵'}
 ∆03_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'+/⍵'}
 ∆04_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'+⌿⍵'}
 ∆05_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'+\⍵'}
 ∆06_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'+⍀⍵'}
 ∆07_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'⍺+.×⍵'}
 ∆08_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'⍺∘.=⍵'}

:EndNamespace
