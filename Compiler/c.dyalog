:Namespace C
  (⎕IO ⎕ML ⎕WX)←0 1 3
  Fix←{(vf ⍺)wm G.gc T.(av ce fe da lc lf du df rd rn)⊃a n←P.Ps vi ⍵}
  vf←{1≢≡⍵:err 11 ⋄ 1≢≢⍴⍵:err 11 ⋄ ~∧/∊' '=⊃0⍴⊂⍵:err 11 ⋄ ⍵}
  vi←{~1≡≢⍴⍵:err 11 ⋄ 2≠|≡⍵:err 11 ⋄ ~∧/1≥≢∘⍴¨⍵:err 11 ⋄ ~∧/∊' '=(⊃0⍴⊂)¨⍵:err 11 ⋄ ⍵}
  wm←{⍺⊣(⊃,/,⍵,⎕UCS 10)put ⍺,'.c'}
  GPU←1
  CFLAGS←'-O3 -g -shared -Xcompiler -fPIC -Irt -Xlinker -L.'
  CC←'nvcc'
  SO←'.dll'
  be←{⎕SH CC,' ',CFLAGS,' -o ',⍵,SO,' ',⍵,'.c -lcodfns'}
:EndNamespace
