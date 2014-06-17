 ParseTopLine←{cod env←⍵ ⋄ line←⍺
     1=≢⍺:(cod⍪⍺)env                    ⍝ Empty lines, do nothing
     cmt←⊃'comment'Prop 1↑⍺             ⍝ We need the comment for later
     eerr ast ne←env ParseExpr 1↓⍺      ⍝ Try to parse as expression first
     0=eerr:(cod⍪ast Comment cmt)ne     ⍝ If it works, extend and replace
     err ast←env 0 ParseLineVar 1↓⍺     ⍝ Try to parse as variable prefixed line
     0=⊃err:(cod⍪ast Comment cmt)env    ⍝ It worked, good
     ferr ast rst←env ParseFuncExpr 1↓⍺ ⍝ Try to parse as a function expression
     0=⊃ferr:(cod⍪ast Comment cmt)env   ⍝ It worked, extend and replace
     ¯1=×err:⎕SIGNAL eerr               ⍝ Signal expr error if it seems good
     ⎕SIGNAL err                        ⍝ Otherwise signal err from ParseLineVar
 }
