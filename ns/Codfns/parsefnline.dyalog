 ParseFnLine←{cod env←⍵
     1=⊃⍴⍺:(cod⍪⍺)env                     ⍝ Do nothing for empty lines
     cmt←⊃'comment'Prop 1↑⍺              ⍝ Preserve the comment for attachment
     cm←{(,':')≡⊃'name'Prop 1↑⍵}¨1 Kids ⍺ ⍝ Mask of : stimuli, to check for branch
     1<cnd←+/cm:⎕SIGNAL 2                 ⍝ Too many : tokens
     1=0⌷cm:⎕SIGNAL 2                     ⍝ Empty test clause
     splt←{1↓¨(1,cm)⊂[0]⍵}                ⍝ Fn to split on : token, drop excess
     1=cnd:⊃cod env ParseCond/splt ⍺      ⍝ Condition found, parse it
     err ast ne←env ParseExpr 1↓⍺         ⍝ Expr is the last non-error option
     0=err:(cod⍪ast)ne                    ⍝ Return if it worked
     ⎕SIGNAL err                          ⍝ Otherwise error the expr error
 }
