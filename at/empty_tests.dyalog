blank_TEST←{#.UT.expect←0 ⋄ n←'test' #.Codfns.Fix ':Namespace' ':EndNamespace'
  ≢n.⎕NL 1 2 3 4 9}
f_TEST←{#.UT.expect←'; ModuleID = ''Unamed Namespace''',⎕UCS 10
  _←'tmp/test'#.Codfns.Fix':Namespace' ':EndNamespace' ⋄ #.utf8get'tmp/test.ll'}

