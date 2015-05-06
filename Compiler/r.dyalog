:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ nl←##.U.nl
  
  ⍝ Runtime Header
  rth ←'#include <math.h>',nl,'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
  rth,←'int isinit=0;',nl
  rth,←'#define PI 3.14159265358979323846',nl

  ⍝ Scalar Primitives
  sdb←0⍴⊂'' ⋄ sdc←0 2⍴⊂'' ⋄ scl←{(((≢⍵)↑,¨'⍺⍵')⎕R ⍵)⊃sdc⌷⍨(sdb⍳⍺⍺),¯1+≢⍵}
  
  ⍝      Prim       Monadic          Dyadic
  ⍝ ────────────────────────────────────────────────────────────────
  sdb,←⊂,'+' ⋄ sdc⍪←'⍵'              '⍺+⍵'
  sdb,←⊂,'-' ⋄ sdc⍪←'-1*⍵'           '⍺-⍵'
  sdb,←⊂,'×' ⋄ sdc⍪←'(⍵>0)-(⍵<0)'    '⍺*⍵'
  sdb,←⊂,'÷' ⋄ sdc⍪←'1.0/⍵'          '((double)⍺)/((double)⍵)'
  sdb,←⊂,'*' ⋄ sdc⍪←'exp((double)⍵)' 'pow((double)⍺,(double)⍵)'
  sdb,←⊂,'⍟' ⋄ sdc⍪←'log((double)⍵)' 'log((double)⍵)/log((double)⍺)'
  sdb,←⊂,'|' ⋄ sdc⍪←'fabs(⍵)'        'fmod((double)⍵,(double)⍺)'
  sdb,←⊂,'○' ⋄ sdc⍪←'PI*⍵'           'error(16)'
  sdb,←⊂,'≥' ⋄ sdc⍪←'error(16)'      '⍺>=⍵'

  ⍝ Mixed Functions
  fdb←0⍴⊂'' ⋄ fdc←0 2⍴⊂'' ⋄ fcl←{(⍎⊃fdc⌷⍨(fdb⍳⍺⍺),¯1+≢⍵)⍵}

  ⍝      Prim       Monadic          Dyadic
  ⍝ ─────────────────────────────────────────────────────────────────
  fdb,←⊂,'⌷' ⋄ fdc⍪←'MF.idx'         ''
  fdb,←⊂,'[' ⋄ fdc⍪←'MF.brki'        ''
  fdb,←⊂,'⍳' ⋄ fdc⍪←''               'MF.iotm'

  ⍝ Operators
  opb←0⍴⊂'' ⋄ opc←0 2⍴⊂'' ⋄ ocl←{⍵∘{(⍎⍵)⍺}¨opc⌷⍨opb⍳⍺⍺}
  
  ⍝      Prim       Monadic          Dyadic
  ⍝ ─────────────────────────────────────────────────────────────────
  opb,←⊂,'⍨' ⋄ opc⍪←'OP.comm'        'OP.comd'
  opb,←⊂,'¨' ⋄ opc⍪←'OP.eacm'        'OP.eacd'

:EndNamespace
