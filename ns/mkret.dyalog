MkRet←{
     cln←GetNamedFunction ⍺⍺'clean_env' ⍝ Runtime function to clean environment
     0=cln:'MISSING FN'⎕SIGNAL 99       ⍝ Safeguard
     _←BuildCall ⍺ cln ⍵ 2 ''           ⍝ Clean the local environment
     zero←ConstInt Int32Type 0 0        ⍝ Zero integer
     BuildRet ⍺ zero                    ⍝ Return a success status
 }
