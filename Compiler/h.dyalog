:Namespace H
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ s←A.s ⋄ v←A.v ⋄ e←A.e

  ⍝ Utilities
  var←{(,'⍺')≡⍺:'l' ⋄ (,'⍵')≡⍺:'r' ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
  nl←⎕UCS 13 10
  for←{'for(i=0;i<',(⍕⍵),';i++){'}
  do←{'{BOUND i;',(for ⍺),⍵,'}}',nl}
  pdo←{'{BOUND i;',nl,'#pragma parallel',nl,(for ⍺),⍵,'}}',nl}
  tl←{('di'⍳⍵)⊃¨⊂('APLDOUB' 'double')('APLLONG' 'aplint32')}
  enc←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))

  ⍝ Runtime Header
  rth ←'#include <math.h>',nl,'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
  rth,←'int isinit=0;',nl
  rth,←'#define PI 3.14159265358979323846',nl

  ⍝ Environments
  dnv←{'LOCALP ',⍺,'[',(⍕⊃v⍵),'];'}
  reg←{(⊃v⍵)do'regp(&',⍺,'[i]);'}
  cutp←'cutp(&env0[0]);'

  ⍝ Functions
  frt←'void static '
  flp←'(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[])'
  foi←'int oi=isinit;if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}',nl
  fnv←{'LOCALP*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}

  coms←{⊃{⍺,',',⍵}/⍵}
  elt←{(⍵≡⌊⍵)⊃'APLDOUB' 'APLLONG'}
  eld←{(⍵≡⌊⍵)⊃'double' 'aplint32'}
  vec←{(vsp≢⍵),'getarray(',(coms (elt⊃⍵)(⍕1<≢⍵)'sp'((⊃⍵)var 0⌷⍉⍺)),');}',nl}
  vsp←{'{BOUND ',(1<⍵)⊃'*sp=NULL;'('sp[1]={',(⍕⍵),'};')}
  dap←{⍺⍺,'*',⍺,'=ARRAYSTART((',((⊃n ⍵)var 0⌷⍉⊃e ⍵),')->p);',nl}
  fil←{⊃,/⍵(⍺{⍺⍺,'[',(⍕⍵),']=',(((⍺<0)⊃'' '-'),⍕|⍺),';'})¨⍳≢⍵}
  dff←{⍺⍺,'(',(coms ⍵),'); /* Fallback */',nl}
  grh←{'{',(⊃,/⍺⍺{'LOCALP*',⍺,'=',⍵,';'}¨⍺ var¨↓⍉⍵),nl}
  ⍝ ghm←'rslt' 'rgt'grh ⋄ ghd←'rslt' 'lft' 'rgt'grh
  ⍝ gec←{((0⌷⍉⍵⍵)⍳⊂⍺)⊃(⍺⍺⌷⍉⍵⍵),⊂⍺ dff ⍵}

:EndNamespace
