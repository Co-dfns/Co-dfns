:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3
  
  ⍝ Scalar Primitives
  sdb←0 3⍴⊂'' ⋄ scl←{((≢⍵)↑,¨'⍺⍵')⎕R ⍵ ⊃⍺⌷⍨(⍺⍺⍳⍨0⌷⍉⍺),¯1+≢⍵}
  
  ⍝      Prim  Monadic          Dyadic
  ⍝ ────────────────────────────────────────────────────────────────
  sdb⍪←,¨'+'   '⍵'              '⍺+⍵'
  sdb⍪←,¨'-'   '-1*⍵'           '⍺-⍵'
  sdb⍪←,¨'×'   '(⍵>0)-(⍵<0)'    '⍺*⍵'
  sdb⍪←,¨'÷'   '1.0/⍵'          '((double)⍺)/((double)⍵)'
  sdb⍪←,¨'*'   'exp((double)⍵)' 'pow((double)⍺,(double)⍵)'
  sdb⍪←,¨'⍟'   'log((double)⍵)' 'log((double)⍵)/log((double)⍺)'
  sdb⍪←,¨'|'   'fabs(⍵)'        'fmod((double)⍵,(double)⍺)'
  sdb⍪←,¨'○'   'PI*⍵'           'error(16)'
  sdb⍪←,¨'≥'   'error(16)'      '⍺>=⍵'

  ⍝ Mixed Functions
  fdb←0 3⍴⊂'' ⋄ fcl←{⍺(⍎⊃⍵⍵⌷⍨(⍺⍺⍳⍨0⌷⍉⍵⍵),¯1+≢⍵)⍵}

  ⍝      Prim  Monadic          Dyadic
  ⍝ ─────────────────────────────────────────────────────────────────
  fdb⍪←,¨'⌷'   ''               'MF.idx'
  fdb⍪←,¨'['   ''               'MF.brki'
  fdb⍪←,¨'⍳'   'MF.iotm'        ''

  ⍝ Operators
  opb←0 3⍴⊂'' ⋄ ocl←{⍵∘{(⍎⍵)⍺}¨1↓⍺⌷⍨⍺⍺⍳⍨0⌷⍉⍺}
  
  ⍝      Prim  Monadic          Dyadic
  ⍝ ─────────────────────────────────────────────────────────────────
  opb⍪←,¨'⍨'   'OP.comm'        'OP.comd'
  opb⍪←,¨'¨'   'OP.eacm'        'OP.eacd'

:EndNamespace
