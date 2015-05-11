:Namespace H
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ SD←##.SD ⋄ OP←##.OP ⋄ R←##.R
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ s←A.s ⋄ v←A.v ⋄ e←A.e
  tl←##.U.tl ⋄ do←##.U.do ⋄ var←##.U.var ⋄ nl←##.U.nl ⋄ pp←#.pp

  ⍝ Runtime Header
  rth ←'#include <math.h>',nl,'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
  rth,←'int isinit=0;',nl
  rth,←'#define PI 3.14159265358979323846',nl

  ⍝ Environments
  dnv←{'LOCALP ',⍺,'[',(⍕⊃v⍵),'];'}
  reg←{(⊃v⍵)do'regp(&',⍺,'[i]);'}

  ⍝ Functions
  frt←'void static '
  flp←'(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[])'
  foi←'int oi=isinit;if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}',nl
  fnv←{'LOCALP*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}


  cutp←'cutp(&env0[0]);'
  coms←{⊃{⍺,',',⍵}/⍵}
  elt←{(⍵≡⌊⍵)⊃'APLDOUB' 'APLLONG'}
  eld←{(⍵≡⌊⍵)⊃'double' 'aplint32'}
  vec←{(vsp≢⍵),'getarray(',(coms (elt⊃⍵)(⍕1<≢⍵)'sp'((⊃⍵)var 0⌷⍉⍺)),');}',nl}
  vsp←{'{BOUND ',(1<⍵)⊃'*sp=NULL;'('sp[1]={',(⍕⍵),'};')}
  vpp←{'(',(⍺ var ⍵),')->p'}
  dap←{⍺⍺,'*',⍺,'=ARRAYSTART(',((⊃n ⍵)vpp 0⌷⍉⊃e ⍵),');',nl}
  fil←{⊃,/⍵(⍺{⍺⍺,'[',(⍕⍵),']=',(((⍺<0)⊃'' '-'),⍕|⍺),';'})¨⍳≢⍵}
  dff←{⍺⍺,'(',(coms ⍵),'); /* Fallback */',nl}
  grh←{'{',(⊃,/⍺⍺{'LOCALP*',⍺,'=',⍵,';'}¨⍺ var¨↓⍉⍵),nl}
  ⍝ ghm←'rslt' 'rgt'grh ⋄ ghd←'rslt' 'lft' 'rgt'grh
  ⍝ gec←{((0⌷⍉⍵⍵)⍳⊂⍺)⊃(⍺⍺⌷⍉⍵⍵),⊂⍺ dff ⍵}

:EndNamespace
