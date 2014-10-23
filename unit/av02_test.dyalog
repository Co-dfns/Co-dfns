 AV02_TEST←{⍝ X←5 → LC0 ← 5 ⋄ X←LC0
     t←⍉⍪0 'Namespace' ''(2 2⍴'name' '' 'coord' '1 0 0')
     t⍪←1 'Expression' ''(2 2⍴'name' 'LC0' 'class' 'atomic')
     t⍪←2 'Number' ''(2 2⍴'value' '5' 'class' 'int')
     t⍪←1 'Expression' ''(2 2⍴,¨'class' 'atomic' 'name' 'X')
     t⍪←2 'Variable' ''(2 2⍴'name' 'LC0' 'class' 'array')
     x←4↑t ⋄ at←4 2⍴,¨'name' 'LC0' 'class' 'array' 'env' '0' 'slot' '0'
     x⍪←2 'Variable' ''at
     _←X x ⋄ C.AV t}