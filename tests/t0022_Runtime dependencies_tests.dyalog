:Namespace t0022_tests

 ns←{':Namespace'('F←{',⍵,'}')':EndNamespace'}

 ⍝ ∆00_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍪⍵'}
 ⍝ ∆01_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⌿⍵'}
 ⍝ ∆02_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺(,⍤1)⍵'}
 ⍝ ∆03_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'+/⍵'}
 ⍝ ∆04_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'+⌿⍵'}
 ⍝ ∆05_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'+\⍵'}
 ⍝ ∆06_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'+⍀⍵'}
 ⍝ ∆07_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+.×⍵'}
 ⍝ ∆08_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺∘.=⍵'}
 ⍝ ∆09_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+[0]⍵'}
 ⍝ ∆10_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺-[0]⍵'}
 ⍝ ∆11_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺×[0]⍵'}
 ⍝ ∆12_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺÷[0]⍵'}
 ⍝ ∆13_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍟[0]⍵'}
 ⍝ ∆14_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺*[0]⍵'}
 ⍝ ∆15_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺|[0]⍵'}
 ⍝ ∆16_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺○[0]⍵'}
 ⍝ ∆17_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⌊[0]⍵'}
 ⍝ ∆18_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⌈[0]⍵'}
 ⍝ ∆19_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺![0]⍵'}
 ⍝ ∆20_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺<[0]⍵'}
 ⍝ ∆21_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺≤[0]⍵'}
 ⍝ ∆22_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺=[0]⍵'}
 ⍝ ∆23_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺≥[0]⍵'}
 ⍝ ∆24_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺>[0]⍵'}
 ⍝ ∆25_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺∧[0]⍵'}
 ⍝ ∆26_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺∨[0]⍵'}
 ⍝ ∆27_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍱[0]⍵'}
 ⍝ ∆28_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍲[0]⍵'}
 ⍝ ∆29_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'?⍵'}
 ⍝ ∆30_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'↓⍵'}
 ⍝ ∆31_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'↑⍵'}
 ⍝ ∆32_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⌷⍵'}
 ⍝ ∆33_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺[⍵]'}
 ⍝ ∆34_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍳⍵'}
 ⍝ ∆35_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍴⍵'}
 ⍝ ∆36_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns',⍵'}
 ⍝ ∆37_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍪⍵'}
 ⍝ ∆38_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⌽⍵'}
 ⍝ ∆39_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⊖⍵'}
 ⍝ ∆40_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍉⍵'}
 ⍝ ∆41_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'∊⍵'}
 ⍝ ∆42_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⊃⍵'}
 ⍝ ∆43_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'≡⍵'}
 ⍝ ∆44_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'≢⍵'}
 ⍝ ∆45_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⊢⍵'}
 ⍝ ∆46_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⊣⍵'}
 ⍝ ∆47_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⊤⍵'}
 ⍝ ∆48_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⊥⍵'}
 ⍝ ∆49_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+¨⍵'}
 ⍝ ∆50_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+⍨⍵'}
 ⍝ ∆51_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+⍤1⊢⍵'}
 ⍝ ∆52_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+⍣≡⍵'}
 ⍝ ∆53_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺+∘×⍵'}
 ⍝ ∆54_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺∪⍵'}
 ⍝ ∆55_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺∩⍵'}
 ⍝ ∆56_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'X←⍵'}
 ⍝ ∆57_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍋⍵'}
 ⍝ ∆58_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍒⍵'}
 ⍝ ∆59_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⍷⍵'}
 ⍝ ∆60_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺⌹⍵'}
 ⍝ ∆61_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⎕FFT ⍵'}
 ⍝ ∆62_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⎕IFFT ⍵'}
 ⍝ ∆63_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'∇⍵'}
 ⍝ ∆64_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍵[;]'}
 ⍝ ∆65_TEST←{#.UT.expect←0 ⋄ 0::1 ⋄ 0⊣'t0022'#.codfns.Fix ns'⍺≠[0]⍵'}


:EndNamespace
