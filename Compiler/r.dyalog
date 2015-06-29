:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ MF←##.MF ⋄ OP←##.OP ⋄ H←##.H
  
  ⍝ Scalar Primitives
  sdb←0 3⍴⊂'' ⋄ scl←{H.cln ((≢⍵)↑,¨'⍵⍺')⎕R(⍕¨⍵) ⊃⍺⌷⍨((⊂⍺⍺)⍳⍨0⌷⍉⍺),≢⍵}
  
  ⍝      Prim  Monadic            Dyadic
  ⍝ ────────────────────────────────────────────────────────────────
  sdb⍪←,¨'+'   '⍵'                '⍺+⍵'
  sdb⍪←,¨'-'   '-1*⍵'             '⍺-⍵'
  sdb⍪←,¨'×'   '(⍵>0)-(⍵<0)'      '⍺*⍵'
  sdb⍪←,¨'÷'   '1.0/⍵'            '((double)⍺)/((double)⍵)'
  sdb⍪←,¨'*'   'exp((double)⍵)'   'pow((double)⍺,(double)⍵)'
  sdb⍪←,¨'⍟'   'log((double)⍵)'   'log((double)⍵)/log((double)⍺)'
  sdb⍪←,¨'|'   'fabs(⍵)'          H.residue
  sdb⍪←,¨'○'   'PI*⍵'             'error(16)'
  sdb⍪←,¨'⌊'   'floor((double)⍵)' '⍺ < ⍵ ? ⍺ : ⍵'
  sdb⍪←,¨'⌈'   'ceil((double)⍵)'  '⍺ > ⍵ ? ⍺ : ⍵'
  sdb⍪←,¨'<'   'error(16)'        '⍺<⍵'
  sdb⍪←,¨'≤'   'error(16)'        '⍺<=⍵'
  sdb⍪←,¨'='   'error(16)'        '⍺==⍵'
  sdb⍪←,¨'≥'   'error(16)'        '⍺>=⍵'
  sdb⍪←,¨'>'   'error(16)'        '⍺>⍵'
  sdb⍪←,¨'≠'   'error(16)'        '⍺!=⍵'

  ⍝ Mixed Functions
  fdb←0 3⍴⊂'' ⋄ fcl←{H.cln ⍺(⍎⊃(⍵⍵⍪fnc ⍺⍺)⌷⍨((⊂⍺⍺)⍳⍨0⌷⍉⍵⍵),¯1+≢⍵)⍵}
  fnc←{⍵('''',⍵,'''H.calm')('''',⍵,'''H.cald')}

  ⍝      Prim  Monadic          Dyadic
  ⍝ ─────────────────────────────────────────────────────────────────
  fdb⍪←,¨'⌷'   ''               'MF.idx'
  fdb⍪←,¨'['   ''               'MF.bri'
  fdb⍪←,¨'⍳'   'MF.iom'         ''

  ⍝ Operators
  odb←0 3⍴⊂'' ⋄ ocl←{⍵∘{'(''',⍺,'''',⍵,')'}¨1↓⍺⌷⍨(⊂⍺⍺)⍳⍨0⌷⍉⍺}
  
  ⍝      Prim  Monadic          Dyadic
  ⍝ ─────────────────────────────────────────────────────────────────
  odb⍪←,¨'⍨'   'OP.comm'        'OP.comd'
  odb⍪←,¨'¨'   'OP.eacm'        'OP.eacd'

:EndNamespace
