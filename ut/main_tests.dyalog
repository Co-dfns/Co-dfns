⎕IO ⎕ML←0 1

C←#.Codfns

WM1_TEST←{#.UT.expect←'tmp/test' ⋄ _←C.FI 
  'tmp/test'C.WM C.ModuleCreateWithName⊂'test'}
WM2_TEST←{#.UT.expect←'; ModuleID = ''test''',⎕UCS 10
  _←'tmp/test'C.WM C.ModuleCreateWithName⊂'test'
  #.utf8get'tmp/test.ll'}
CL1_TEST←{#.UT.expect←'ut/F.so' ⋄ C.CL 'ut/F'}
CL2_TEST←{#.UT.expect←,⊂'ut/F.so' ⋄ ⎕SH'ls ',C.CL'ut/F'}
Init1_TEST←{#.UT.expect←0 ⋄ 1⊃C.Init C.CL'ut/F'}
LK1_TEST←{#.UT.expect←,9 ⋄ x←(0 2⍴⍬)C.LK ,'' ⋄ ⎕NC'x'}
LK2_TEST←{#.UT.expect←⍉⍪'f' ⋄ n←(⍉⍪'f' 2)C.LK C.CL 'ut/F' ⋄ n.⎕NL 1 2 3 4 9}
LK3_TEST←{#.UT.expect←,3 ⋄ n←(⍉⍪'f' 2)C.LK C.CL'ut/F' ⋄ n.⎕NC 'f'}
LK4_TEST←{#.UT.expect←5 ⋄ _←C.FI ⋄ n←(⍉⍪'f' 2)C.LK C.CL'ut/F' ⋄ n.f⍬}
LK5_TEST←{#.UT.expect←6 ⋄ _←C.FI ⋄ n←(⍉⍪'g' 2)C.LK C.CL'ut/G' ⋄ n.g 5}
LK6_TEST←{#.UT.expect←6.5 ⋄ _←C.FI ⋄ n←(⍉⍪'g' 2)C.LK C.CL'ut/G' ⋄ n.g 5.5}
LK7_TEST←{#.UT.expect←7 ⋄ _←C.FI ⋄ n←(⍉⍪'h' 2)C.LK C.CL'ut/H' ⋄ 1 n.h 5}
LK8_TEST←{#.UT.expect←7.5 ⋄ _←C.FI ⋄ n←(⍉⍪'h' 2)C.LK C.CL'ut/H' ⋄ 1.5 n.h 5}
LK9_TEST←{#.UT.expect←5 6 ⋄ _←C.FI ⋄ n←(2 2⍴'f' 2 'g' 2)C.LK C.CL'ut/FG'
  (n.f⍬)(n.g 5)}

