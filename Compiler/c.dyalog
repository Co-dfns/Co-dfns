:Namespace C
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ P←##.P ⋄ G←##.G ⋄ T←##.T
  Fix←{(vf⍺)put⍨G.gc T.{fs av va ce fe da lc lf du df rd rn ⍵}⊃a n←P.Ps vi⍵}
  vf←{1≢≡⍵:err 11 ⋄ 1≢≢⍴⍵:err 11 ⋄ ~∧/∊' '=⊃0⍴⊂⍵:err 11 ⋄ ⍵}
  vi←{
    ~1≡≢⍴⍵:err 11
    2≠|≡⍵:err 11
    ~∧/1≥≢∘⍴¨⍵:err 11
    ~∧/∊' '=(⊃0⍴⊂)¨⍵:err 11 
    ⍵
  }
  wm←{⍺⊣⍵ put ⍺,'.c'}
  tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
  put←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}
  err←{⍺←⊢ ⋄ ⍺ ⎕SIGNAL ⍵}
  GPU←1 ⋄ CC←'nvcc' ⋄ SO←'.dll'
  CFLAGS←'-O3 -g -shared -Xcompiler -fPIC -Irt -Xlinker -L.'
  be←{⎕SH CC,' ',CFLAGS,' -o ',⍵,SO,' ',⍵,'.c -lcodfns'}
:EndNamespace
