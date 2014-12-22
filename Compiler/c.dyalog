:Namespace C
  (⎕IO ⎕ML ⎕WX)←0 1 3
  Fix←{(vf ⍺)wm G.gc T.(av fe lf lc du df dl rd rn)⊃a n←P.Ns vi ⍵}                    ⍝ Main entry point to replace ⎕FIX
  vf←{1≢≡⍵:err 11 ⋄ 1≢≢⍴⍵:err 11 ⋄ ~∧/∊' '=⊃0⍴⊂⍵:err 11 ⋄ ⍵}                          ⍝ Verify filename syntax
  vi←{~1≡≢⍴⍵:err 11 ⋄ 2≠|≡⍵:err 11 ⋄ ~∧/1≥≢∘⍴¨⍵:err 11 ⋄ ~∧/∊' '=(⊃0⍴⊂)¨⍵:err 11 ⋄ ⍵} ⍝ Verify namespace script input
  wm←{⍺⊣(⊃,/,⍵,⎕UCS 10)put ⍺,'.c'}                                                    ⍝ Write module to file   
  GPU←1                                                                               ⍝ Run with GPU?
  CFLAGS←'-O3 -g -shared -Xcompiler -fPIC -Irt -Xlinker -L.'                          ⍝ Back-end compiler flags
  CC←'nvcc'                                                                           ⍝ Back-end compiler
  SO←'.dll'                                                                           ⍝ Shared object extension
  be←{⎕SH CC,' ',CFLAGS,' -o ',⍵,SO,' ',⍵,'.c -lcodfns'}                              ⍝ Back-end function
:EndNamespace 