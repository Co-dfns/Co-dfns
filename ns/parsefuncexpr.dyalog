ParseFuncExpr←{
  at←{2 2⍴'class'⍵'equiv'⍺}         ⍝ Fn to build fn attributes
  fn←(¯1+⊃⍵)∘{⍺'FuncExpr' ''⍵}        ⍝ Fn to build FuncExpr node
  pcls←{(~∨\' '=C)/C←⊃'class'Prop 1↑⍵} ⍝ Fn to get class of Primitive node
  nm←⊃'name'Prop 1↑⍵                   ⍝ Name of first node
  isp←'Primitive'≡⊃0 1⌷⍵               ⍝ Is the node a primitive?
  isp:0((fn nm at pcls ⍵)⍪1↑⍵)(1↓⍵)    ⍝ Yes? Use that node.
  isfn←'Variable'≡⊃0 1⌷⍵               ⍝ Do we have a variable
  isfn∧←2=⍺ VarType nm                 ⍝ that refers to a function?
  fnat←''at'ambivalent'              ⍝ Fn attributes for a variable
  isfn:0((fn fnat)⍪1↑⍵)(1↓⍵)           ⍝ If function variable, return
  err ast rst←⍺ ParseFunc ⍵            ⍝ Try to parse as a function
  0=err:0(ast⍪⍨fn at⍨'ambivalent')rst  ⍝ Use ambivalent class if it works
  2 MtAST ⍵                            ⍝ Otherwise, return error
}
 
