 FE06_TEST←{⍝ F←{5} → LC0←5 ⋄ F←{res←LC0}
     t←⍉⍪0 'Namespace' ''(2 2⍴,¨'name' 'coord' '1 0 0 0 0')
     t⍪←1 'Expression' ''(2 2⍴,¨'name' 'LC0' 'class' 'atomic')
     t⍪←2 'Number' ''(2 2⍴,¨'value' '5' 'class' 'int')
     t⍪←1 'FuncExpr' ''(3 2⍴,¨'class' 'ambivalent' 'equiv' 'ambivalent' 'name' 'F')
     t⍪←2 'Function' ''(2 2⍴,¨'class' 'ambivalent' 'coord' '1 2 2 0 0')
     t⍪←3 'Expression' ''(1 2⍴,¨'class' 'atomic')
     t⍪←4 'Variable' ''(1 2⍴,¨'name' 'LC0')
     x←t ⋄ (⊃5 3⌷x)⍪←'name' 'res' ⋄ (⊃1 3⌷x)←⊖⊃1 3⌷x ⋄ _←X x ⋄ C.FE t}