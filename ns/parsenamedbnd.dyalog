ParseNamedBnd←{vn tp env←⍺
  0=⊃env ParseExpr ⍵:⎕SIGNAL 2         ⍝ Should not be an Expression
  tp≠t←2:⎕SIGNAL 2                     ⍝ The types must match to continue
  err ast←env 1 ParseLineVar ⍵         ⍝ Try to parse as a variable line
  0=err:vn Bind ast                    ⍝ If it succeeds, Bind and return
  ferr ast rst←env ParseFuncExpr ⍵     ⍝ Try to parse as a FuncExpr
  (0=ferr)∧tp=t:vn Bind ast            ⍝ If it works, bind it and return
  t←(1=≢⍵)∧('Variable'≡⊃0 1⌷⍵)         ⍝ Do we have only a single var node?
  t∧←0=env VarType⊃'name'Prop 1↑⍵      ⍝ And is it unbound?
  t:⎕SIGNAL 6                          ⍝ Then signal a value error for unbound
  ¯1=×err:⎕SIGNAL ferr                 ⍝ Signal FuncExpr error if suggested
  ⎕SIGNAL err                          ⍝ Else signal variable line error
}

