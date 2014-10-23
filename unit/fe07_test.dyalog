 FE07_TEST←{⍝ F←{1:1 ⋄ 0}
     t←⍉⍪0 'Namespace' ''(2 2⍴,¨'name' '' 'coord' '1 0 0 0 0 0')
     t⍪←1 'Expression' ''(2 2⍴,¨'name' 'LC0' 'class' 'atomic')
     t⍪←2 'Number' ''(2 2⍴,¨'value' '1' 'class' 'int')
     t⍪←1 'Expression' ''(2 2⍴,¨'name' 'LC1' 'class' 'atomic')
     t⍪←2 'Number' ''(2 2⍴,¨'value' '1' 'class' 'int')
     t⍪←1 'Expression' ''(2 2⍴,¨'name' 'LC2' 'class' 'atomic')
     t⍪←2 'Number' ''(2 2⍴,¨'value' '0' 'class' 'int')
     t⍪←1 'FuncExpr' ''(3 2⍴,¨'class' 'ambivalent' 'equiv' 'ambivalent' 'name' 'F')
     t⍪←2 'Function' ''(2 2⍴,¨'class' 'ambivalent' 'coord' '1 4 4 0 0 0')
     t⍪←3 'Condition' ''(0 2⍴⊂'')
     t⍪←4 'Expression' ''(1 2⍴,¨'class' 'atomic')
     t⍪←5 'Variable' ''(2 2⍴,¨'name' 'LC0' 'class' 'array')
     t⍪←4 'Expression' ''(1 2⍴,¨'class' 'atomic')
     t⍪←5 'Variable' ''(2 2⍴,¨'name' 'LC1' 'class' 'array')
     t⍪←3 'Expression' ''(1 2⍴,¨'class' 'atomic')
     t⍪←4 'Variable' ''(2 2⍴,¨'name' 'LC2' 'class' 'array')
     x←t ⋄ ((12 14)3⌷x)⍪←2⍴⊂'name' 'res' ⋄ ((1 3 5)3⌷x)←⊖¨(1 3 5)3⌷x
     _←X x ⋄ C.FE t}