C←#.Codfns
blank_TEST←{#.UT.expect←0 ⋄ n←'tmp/test'C.Fix':Namespace' ':EndNamespace'
  ≢n.⎕NL 1 2 3 4 9}
f_TEST←{#.UT.expect←'tmp/test.'∘,¨'ll' 'so' ⋄ _←⎕sh 'rm -f tmp/test.{ll,so}'
  _←'tmp/test'C.Fix':Namespace' ':EndNamespace' ⋄ ⎕sh'ls tmp/test.{ll,so}'}
c_TEST←{#.UT.expect←5
  ('./tmp/test'#.Codfns.Fix':Namespace' 'f←{5}' ':EndNamespace').f⍬}

