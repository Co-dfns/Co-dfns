 DF01_TEST←{⍝ {}
     t←⍉⍪0 'Namespace' ''(1 2⍴,¨'name' '')
     t⍪←1 'FuncExpr' ''(2 2⍴,¨'class' 'ambivalent' 'equiv' 'ambivalent')
     t⍪←2 'Function' ''(1 2⍴,¨'class' 'ambivalent')
     x←1↑t ⋄ _←X x ⋄ C.DF t}