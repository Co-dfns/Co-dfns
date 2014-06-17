 ParseLineVar←{env cls←⍺
     '←'≡⊃'name'Prop 1↑⍵:2 MtAST          ⍝ No variable named, syntax error
     3>⊃⍴⍵:¯1 MtAST                       ⍝ Valid cases have at least three nodes
     tk←'Variable' 'Token'                ⍝ First two tokens should be Var and Tok
     ~tk∧.≡(0 1)1⌷⍵:¯1 MtAST              ⍝ If not, bad things
     (,'←')≢⊃'name'Prop 1↑1↓⍵:¯1 MtAST    ⍝ 2nd node is assignment?
     vn←⊃'name'Prop 1↑⍵                   ⍝ Name of the variable
     tp←env VarType vn                    ⍝ Type of the variable: Vfo or Vu?
     t←(0=tp)∧(cls=0)                     ⍝ Class zero with Vu?
     t:0,⊂vn env ParseNamedUnB 2↓⍵        ⍝ Then parse as unbound
     t←(2 3 4∨.=tp)∨(0=tp)∧(cls=1)        ⍝ Vfo or unbound with previous Vfo seen?
     t:0,⊂vn 2 env ParseNamedBnd 2↓⍵      ⍝ Then parse as bound to Fn
    ⍝ XXX: Right now we assume that we have only types of 2, or Fns.
    ⍝ In the future, change this to adjust for other nameclasses.
     ¯1 MtAST                             ⍝ Not a Vfo or Vu; something is wrong
 }
