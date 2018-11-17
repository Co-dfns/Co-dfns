:Namespace t0022_tests

 ns←{':Namespace'('F←{⍺',⍵,'⍵}')':EndNamespace'}

 ∆00_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'⍪'}
 ∆01_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'c0022'#.codfns.Fix ns'⌿'}

:EndNamespace
