⎕IO ⎕ML←0 1

C←#.Codfns ⋄ LKCL←{⍺ C.LK C.CL ⍵}

WM1_TEST←{#.UT.expect←'tmp/test' ⋄ _←C.FI 
  'tmp/test'C.WM C.ModuleCreateWithName⊂'test'}
WM2_TEST←{#.UT.expect←'; ModuleID = ''test''',⎕UCS 10
  _←'tmp/test'C.WM C.ModuleCreateWithName⊂'test'
  #.utf8get'tmp/test.ll'}
CL1_TEST←{#.UT.expect←'ut/F.so' ⋄ C.CL 'ut/F'}
CL2_TEST←{#.UT.expect←,⊂'ut/F.so' ⋄ ⎕SH'ls ',C.CL'ut/F'}
Init1_TEST←{#.UT.expect←0 ⋄ 1⊃C.Init C.CL'ut/F'}
LK1_TEST←{#.UT.expect←,9 ⋄ x←(0 2⍴⍬)C.LK ,'' ⋄ ⎕NC'x'}
LK2_TEST←{#.UT.expect←⍉⍪'f' ⋄ ((⍉⍪'f' 2)LKCL 'ut/F').⎕NL 1 2 3 4 9}
LK3_TEST←{#.UT.expect←,3 ⋄ ((⍉⍪'f' 2)LKCL'ut/F').⎕NC 'f'}
LK4_TEST←{#.UT.expect←5 ⋄ ((⍉⍪'f' 2)LKCL'ut/F'⊣C.FI).f⍬}
LK5_TEST←{#.UT.expect←6 ⋄ ((⍉⍪'g' 2)LKCL'ut/G'⊣C.FI).g 5}
LK6_TEST←{#.UT.expect←6.5 ⋄ ((⍉⍪'g' 2)LKCL'ut/G'⊣C.FI).g 5.5}
LK7_TEST←{#.UT.expect←7 ⋄ 1((⍉⍪'h' 2)LKCL'ut/H'⊣C.FI).h 5}
LK8_TEST←{#.UT.expect←7.5 ⋄ 1.5((⍉⍪'h' 2)LKCL'ut/H'⊣C.FI).h 5}
LK9_TEST←{#.UT.expect←5 6 ⋄ ((2 2⍴'f' 2 'g' 2)LKCL'ut/FG'⊣C.FI).(f,g)5}
EM_TEST←{#.UT.expect←1 ⋄ 11::1 ⋄ #.Codfns.E 11 ⋄ 0}
ED_TEST←{#.UT.expect←1 ⋄ 11::1 ⋄ 'a'#.Codfns.E 11 ⋄ 0}
Eachk1_TEST←{#.UT.expect←X←1 4⍴0 'a' '' (0 2⍴⍬) ⋄ ⊢ C.Eachk X}

