 ParseNamedUnB←{vn env←⍺
     err ast←env 0 ParseLineVar ⍵         ⍝ Else try to parse as a variable line
     0=err:vn Bind ast                    ⍝ that worked, so bind it
     ferr ast rst←env ParseFuncExpr ⍵     ⍝ Try to parse as a FuncExpr
     0=ferr:vn Bind ast                   ⍝ It worked, bind it to vn
     ¯1=×err:⎕SIGNAL ferr                 ⍝ Signal FuncExpr error if suggested
     ⎕SIGNAL err                          ⍝ Otherwise signal Variable line error
 }