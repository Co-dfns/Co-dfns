EM_TEST←{#.UT.expect←1 ⋄ 11::1 ⋄ #.Codfns.E 11 ⋄ 0}
ED_TEST←{#.UT.expect←1 ⋄ 11::1 ⋄ 'a'#.Codfns.E 11 ⋄ 0}
Eachk1_TEST←{#.UT.expect←X←1 4⍴0 'a' '' (0 2⍴⍬) ⋄ ⊢ #.Codfns.Eachk X}
