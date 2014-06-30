WM1_TEST←{#.UT.expect←'tmp/test' ⋄ _←#.Codfns.FI
  'tmp/test'#.Codfns.WM #.Codfns.ModuleCreateWithName⊂'test'}
WM2_TEST←{#.UT.expect←'; ModuleID = ''test''',⎕UCS 10
  _←'tmp/test'#.Codfns.WM #.Codfns.ModuleCreateWithName⊂'test'
  #.utf8get'tmp/test.ll'}
CL1_TEST←{#.UT.expect←'ut/F.so' ⋄ #.Codfns.CL 'ut/F'}
