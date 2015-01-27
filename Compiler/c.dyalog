:Namespace C
  (⎕IO ⎕ML ⎕WX)←0 1 3
  Fix←{(vf ⍺)wm G.gc T.(av ce fe da lc lf du df rd rn)⊃a n←P.Ps vi ⍵}
  vf←{1≢≡⍵:err 11 ⋄ 1≢≢⍴⍵:err 11 ⋄ ~∧/∊' '=⊃0⍴⊂⍵:err 11 ⋄ ⍵}
  vi←{~1≡≢⍴⍵:err 11 ⋄ 2≠|≡⍵:err 11 ⋄ ~∧/1≥≢∘⍴¨⍵:err 11 ⋄ ~∧/∊' '=(⊃0⍴⊂)¨⍵:err 11 ⋄ ⍵}
  wm←{⍺⊣(⊃,/,⍵,⎕UCS 10)put ⍺,'.c'}
  tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
  put←{size←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:rslt←size⊣⎕NUNTIE t}
  err←{⍺←⊢ ⋄ ⍺ ⎕SIGNAL ⍵}
  GPU←1
  CFLAGS←'-O3 -g -shared -Xcompiler -fPIC -Irt -Xlinker -L.'
  CC←'nvcc'
  SO←'.dll'
  be←{⎕SH CC,' ',CFLAGS,' -o ',⍵,SO,' ',⍵,'.c -lcodfns'}
:EndNamespace
