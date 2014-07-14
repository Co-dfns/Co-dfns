ParseExpr←{
  0=⊃⍴⍵:2 MtAST ⍺                      ⍝ Empty expressions are errors
  2::2 MtAST ⍺                         ⍝ Allow instant exit while parsing
  6::6 MtAST ⍺
  11::11 MtAST ⍺
  at←1 2⍴'class' 'atomic'              ⍝ Literals become atomic expressions
  n←(d←⊃⍵)'Expression' ''at            ⍝ One node per group of literals
  p←2</0,m←(d=0⌷⍉⍵)∧(1⌷⍉⍵)∊⊂'Number'   ⍝ Mask and partition of literals
  (0⌷⍉m⌿e)+←1⊣e←⍵                      ⍝ Bump the depths of each literal
  e←⊃⍪/(⊂MtAST),(⊂n)⍪¨p⊂[0]e           ⍝ Add expr node to each literal group
  e←((~∨\p)⌿⍵)⍪e                       ⍝ Attach anything before first literal
  dwn←{a⊣(0⌷⍉a)+←1⊣a←⍵}                ⍝ Fn to push nodes down the tree
  at←1 2⍴'class' 'monadic'             ⍝ Attributes for monadic expr node
  em←d'Expression' ''at                ⍝ Monadic expression node
  at←1 2⍴'class' 'dyadic'              ⍝ Attributes for dyadic expr node
  ed←d'Expression' ''at                ⍝ Dyadic expression node
  at←1 2⍴'class' 'ambivalent'          ⍝ Attributes for operator-derived Fns
  feo←d'FuncExpr' ''at                 ⍝ Operator-derived Functions
  e ne _←⊃{ast env knd←⍵               ⍝ Process tokens from bottom up
    e fe rst←env ParseFuncExpr ⍺       ⍝ Try to parse as a FuncExpr node first
    (0⌷⍉fe)+←1                         ⍝ Bump up the FuncExpr depth to match
    k←(e=0)⊃⍺ fe                       ⍝ Kid is Fe if parsed, else existing kid
    tps←'Expression' 'FuncExpr'        ⍝ Types of nodes
    tps,←'Token' 'Variable'
    4=typ←tps⍳0 1⌷k:⍎'⎕SIGNAL e'       ⍝ Type of node we're dealing with
    nm←⊃'name'Prop 1↑k                 ⍝ Name of the kid, if any
    k←(typ=3)⊃k(n⍪dwn k)               ⍝ Wrap the variable if necessary
    c←knd typ                          ⍝ Our case
    c≡0 0:(k⍪ast)env 1                 ⍝ Nothing seen, Expression
    c≡0 1:⍎'⎕SIGNAL 2'                 ⍝ Nothing seen, FuncExpr
    c≡0 2:⍎'⎕SIGNAL 2'                 ⍝ Nothing seen, Assignment
    c≡0 3:(k⍪dwn ast)env 1             ⍝ Nothing seen, Variable
    c≡1 0:⍎'⎕SIGNAL 2'                 ⍝ Expression seen, Expression
    c≡1 1:(em⍪dwn k⍪ast)env 2          ⍝ Expression seen, FuncExpr
    c≡1 2:ast env 3                    ⍝ Expression seen, Assignment
    c≡1 3:⍎'⎕SIGNAL 2'                 ⍝ Expression seen, Variable
    op←'operator'≡⊃'class'Prop 1↑1↓ast ⍝ Is class of kid ≡ operator?
    mko←{dwn feo⍪(dwn k)⍪2↑1↓ast}      ⍝ Fn to make the FuncExpr node
    op∧c≡2 0:(em⍪(mko ⍬)⍪3↓ast)env 2   ⍝ FuncExpr seen, Operator, Expression
    c≡2 0:(ed⍪(dwn k)⍪1↓ast)env 2      ⍝ FuncExpr seen, Expression
    op∧c≡2 1:(em⍪(mko ⍬)⍪3↓ast)env 2   ⍝ FuncExpr seen, Operator, FuncExpr
    c≡2 1:(em⍪dwn k⍪ast)env 2          ⍝ FuncExpr seen, FuncExpr
    op∧c≡2 2:⍎'⎕SIGNAL 2'              ⍝ FuncExpr seen, Operator, Assignment
    c≡2 2:ast env 3                    ⍝ FuncExpr seen, Assignment
    op∧c≡2 3:(em⍪(mko ⍬)⍪3↓ast)env 2   ⍝ FuncExpr seen, Operator, Variable
    c≡2 3:(ed⍪(dwn k)⍪1↓ast)env 1      ⍝ FuncExpr seen, Variable
    c≡3 0:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, Expression
    c≡3 1:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, FuncExpr
    c≡3 2:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, Assignment
    c≡3 3:(nm Bind ast)((nm 1)⍪env)1   ⍝ Assignment seen, Variable
    ⎕SIGNAL 99                         ⍝ Unreachable
  }/(0 Kids e),⊂MtAST ⍺ 0
  (0⌷⍉e)-←1                            ⍝ Push the node up to right final depth
  0 e ne                               ⍝ Return the expression and new env
}

