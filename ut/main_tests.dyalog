⎕IO ⎕ML←0 1

WM1_TEST←{#.UT.expect←'tmp/test' ⋄ _←#.Codfns.FI
  'tmp/test'#.Codfns.WM #.Codfns.ModuleCreateWithName⊂'test'}
WM2_TEST←{#.UT.expect←'; ModuleID = ''test''',⎕UCS 10
  _←'tmp/test'#.Codfns.WM #.Codfns.ModuleCreateWithName⊂'test'
  #.utf8get'tmp/test.ll'}
CL1_TEST←{#.UT.expect←'ut/F.so' ⋄ #.Codfns.CL 'ut/F'}
CL2_TEST←{#.UT.expect←,⊂'ut/F.so' ⋄ ⎕SH'ls ',#.Codfns.CL'ut/F'}
Init1_TEST←{#.UT.expect←0 ⋄ 1⊃#.Codfns.Init #.Codfns.CL'ut/F'}
LK1_TEST←{#.UT.expect←,9 ⋄ x←(0 2⍴⍬)#.Codfns.LK ,'' ⋄ ⎕NC'x'}

