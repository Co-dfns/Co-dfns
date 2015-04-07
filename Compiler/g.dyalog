:Namespace G
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ R←##.R ⋄ SD←##.SD
  pp←#.pp ⋄ tl←##.U.tl ⋄ do←##.U.do
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ s←A.s ⋄ v←A.v ⋄ e←A.e
  FunM←A.FunM ⋄ ExpM←A.ExpM ⋄ AtmM←A.AtmM ⋄ FexS←A.FexS ⋄ FexM←A.FexM
  EnvM←A.EnvM ⋄ pp←#.pp
  var←##.U.var ⋄ nl←##.U.nl
  hdr←'#include <math.h>',nl,'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
  hdr,←'int isinit=0;',nl
  flp←'LOCALP*z,LOCALP*l,LOCALP*r'
  fpd←('(',flp,')')('(',flp,',LOCALP*penv[])')
  frt←'void EXPORT '
  gfi←'int oi=isinit;if(!isinit){Init();isinit=1;}',nl
  ged←{'LOCALP ',⍺,'[',(⍕⊃v⍵),'];'}
  ger←{(⊃v⍵)do'regp(&',⍺,'[i]);'}
  gel←{'LOCALP*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
  ght←{'{',nl,gfi,('env0'ged ⍵),'LOCALP*env[]={env0,tenv};',nl,'env0'ger ⍵}
  ghn←{'{',nl,gfi,('env0'ged ⍵),(gel ⍵),'env0'ger ⍵}
  elt←{(⍵≡⌊⍵)⊃'APLDOUB' 'APLLONG'} ⋄ eld←{(⍵≡⌊⍵)⊃'double' 'aplint32'}
  vec←{(vsp≢⍵),'getarray(',(elt⊃⍵),',',(⍕1<≢⍵),',','sp,',((⊃⍵)var 0⌷⍉⍺),');}',nl}
  vsp←{'{BOUND ',(1<⍵)⊃'*sp=NULL;'('sp[1]={',(⍕⍵),'};')}
  vpp←{'(',(⍺ var ⍵),')->p'}
  dap←{⍺⍺,'*',⍺,'=ARRAYSTART(',((⊃n ⍵)vpp 0⌷⍉⊃e ⍵),');',nl}
  fil←{⊃,/⍵(⍺{⍺⍺,'[',(⍕⍵),']=',(((⍺<0)⊃'' '-'),⍕|⍺),';'})¨⍳≢⍵}
  dis←{⍺←⊢ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}
  Atmc←{((⊃e⍵)vec⊃v⍵),'{',('v'((eld⊃⊃v⍵)dap)⍵),('v'fil⊃v⍵),'}',nl}
  Atm0←{((⊃n ⍵)vpp 0⌷⍉⊃e ⍵),'=ref(',((⊃⊃v ⍵)vpp 1⌷⍉⊃e ⍵),');',nl}
  Expm←{f r←⊃v⍵ ⋄ ((⊃n⍵)r)(f R.gm ⍺)(⊃e⍵)[;0 2]}
  Expd←{l f r←⊃v⍵ ⋄ ((⊃n⍵)l r)(f R.gd ⍺)(⊃e⍵)[;0 1 3]}
  Expi←{a i←⊃v⍵ ⋄ ((⊃n⍵) a i)((,'[')R.gd ⍺)⊃e ⍵}
  Fexi←{(⊃n⍵)(##.MF.cat)('Fexim();',nl)}
  Fexf←{(⊃n⍵)('lft'R.gf⊃⊃v⍵)('NULL'R.gf⊃⊃v⍵)}
  Fexm←{f o←⊃v⍵ ⋄ (⊃n⍵)(o R.gomd f)(o R.gomm f)}
  Fexd←{(⊃n⍵)(##.OP.ptd)('Fexdm();',nl)}
  Fex0←{3⍴⊂''}
  Fund←{frt,(⊃n⍵),((⊃s⍵)⊃(⊂'(void)'),fpd),';',nl}
  Fun0←{frt,(⊃n⍵),'(void){',nl,'LOCALP *env[]={tenv};',nl,'tenv'ger ⍵}
  Fun1←{frt,(⊃n⍵),(¯1+2⌊⊃s ⍵)⊃fpd,¨(ght ⍵)(ghn ⍵)}
  Nms0←{hdr,('tenv'ged ⍵),nl}
  Nuf0←{'}',nl,nl}
  Nuf1←{'z->p=zap(',((⊃n⍵)vpp⊃e⍵),');cutp(&env0[0]);',nl,'isinit=oi;}',nl,nl}
  Scl0←{'{',(⍺ SD.(crk,grt,gpp,gsp,std,sto) 1↓⍵),'}',nl}
  gc←{⊃,/(dis⍤1 FexS ⍵)∘dis¨((1≥d)⊂[0]⊢)(~FexM ⍵)⌿⍵}
:EndNamespace
