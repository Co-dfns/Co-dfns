C←#.Codfns ⋄ d←{'./tmp/',⍵} ⋄ #.UT.sac←1
in←{(⊂':Namespace'),(,⍵),⊂':EndNamespace'}
b_TEST←{#.UT.expect←0 ⋄ n←(d'b')C.Fix in⍬ ⋄ ≢n.⎕NL 1 2 3 4 9}
f_TEST←{#.UT.expect←(d'f.')∘,¨'ll' 'so' ⋄ _←⎕sh 'rm -f ',d'f.{ll,so}'
  _←(d'f')C.Fix in⍬ ⋄ ⎕sh'ls ',d'f.{ll,so}'}
c_TEST←{#.UT.expect←5 ⋄ ((d'c')C.Fix':Namespace' 'f←{5}' ':EndNamespace').f⍬}
w_TEST←{#.UT.expect←6 ⋄ ((d'w')C.Fix in⊂'g←{5+⍵}').g 1}

