:Namespace t0031

 Op1←{⍺⍺ ⍵}
 Op2←{⍺ ⍺⍺ ⍵}
 Op3←{⍵⍵ ⍵}
 Op4←{⍺ ⍵⍵ ⍵}
 Fn1←{+ Op1 ⍵}
 Add1←{1 + ⍵}
 Add←{⍺ + ⍵}
 Fn2←{Add1 Op1 ⍵}
 Fn3←{⍺ + Op2 ⍵}
 Fn4←{⍺ Add Op2 ⍵}
 Fn5←{{⍵+⍵}Op3+ ⍵}
 Fn6←{{⍵+⍵}Op3 Add1 ⍵}
 Fn7←{⍺{⍵+⍵}Op4 + ⍵}
 Fn8←{⍺{⍵+⍵}Op4 Add ⍵}

:EndNamespace