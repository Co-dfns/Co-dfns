:Namespace t0022_tests

 ns←{':Namespace'('F←{',⍵,'}')':EndNamespace'}

 ∆00_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍪⍵'}
 ∆01_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⌿⍵'}
 ∆02_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺(,⍤1)⍵'}
 ∆03_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'+/⍵'}
 ∆04_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'+⌿⍵'}
 ∆05_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'+\⍵'}
 ∆06_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'+⍀⍵'}
 ∆07_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+.×⍵'}
 ∆08_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺∘.=⍵'}
 ∆09_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+[0]⍵'}
 ∆10_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺-[0]⍵'}
 ∆11_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺×[0]⍵'}
 ∆12_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺÷[0]⍵'}
 ∆13_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍟[0]⍵'}
 ∆14_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺*[0]⍵'}
 ∆15_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺|[0]⍵'}
 ∆16_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺○[0]⍵'}
 ∆17_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⌊[0]⍵'}
 ∆18_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⌈[0]⍵'}
 ∆19_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺![0]⍵'}
 ∆20_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺<[0]⍵'}
 ∆21_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺≤[0]⍵'}
 ∆22_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺=[0]⍵'}
 ∆23_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺≥[0]⍵'}
 ∆24_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺>[0]⍵'}
 ∆25_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺∧[0]⍵'}
 ∆26_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺∨[0]⍵'}
 ∆27_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍱[0]⍵'}
 ∆28_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍲[0]⍵'}


:EndNamespace
