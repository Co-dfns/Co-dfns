:Namespace G
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ R←##.R ⋄ SD←##.SD ⋄ OP←##.OP
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ s←A.s ⋄ v←A.v ⋄ e←A.e
  FunM←A.FunM ⋄ ExpM←A.ExpM ⋄ AtmM←A.AtmM ⋄ FexS←A.FexS ⋄ FexM←A.FexM
  EnvM←A.EnvM
  tl←##.U.tl ⋄ do←##.U.do ⋄ var←##.U.var ⋄ nl←##.U.nl ⋄ pp←#.pp
  comd←OP.comd ⋄ comm←OP.comm ⋄ eacd←OP.eacd ⋄ eacm←OP.eacm
  opn opd opm←(,¨'⍨¨')('comd' 'eacd')('comm' 'eacm')
  idx←##.MF.idx ⋄ brki←##.MF.brki ⋄ iotm←##.MF.iotm
  fdb←3 3⍴,¨ '⌷' idx  ''   '[' brki ''   '⍳' ''   iotm
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
  dff←{⍺⍺,'(',(⊃{⍺,',',⍵}/⍵),'); /* Fallback */',nl}
  grh←{'{',(⊃,/⍺⍺{'LOCALP*',⍺,'=',⍵,';'}¨⍺ var¨↓⍉⍵),nl}
  grhm←'rslt' 'rgt'grh ⋄ grhd←'rslt' 'lft' 'rgt'grh
  gec←{((0⌷⍉⍵⍵)⍳⊂⍺)⊃(⍺⍺⌷⍉⍵⍵),⊂⍺ dff ⍵}
  Expm←{f r←⊃v⍵   ⋄ vs←(⊃n⍵)r   ⋄ (vs grhm(⊃e⍵)[;0 2  ]),(f(2 gec ⍺)vs),'}',nl}
  Expd←{l f r←⊃v⍵ ⋄ vs←(⊃n⍵)l r ⋄ (vs grhd(⊃e⍵)[;0 1 3]),(f(1 gec ⍺)vs),'}',nl}
  Expi←{a i←⊃v⍵   ⋄ vs←(⊃n⍵)a i ⋄ (vs grhd(⊃e⍵)),((,'[')(1 gec ⍺)vs),'}',nl}
  Fexi←{(⊃n⍵)(##.MF.cat)('Fexim();',nl)}
  Fexf←{(⊃n⍵)(f,'(rslt,lft,rgt);',nl)(f,'(rslt,NULL,rgt);',nl)⊣f←⊃⊃v⍵}
  Fexm←{f o←⊃v⍵ ⋄ i←opn⍳⊂o ⋄ (⊃n⍵)((⍎i⊃opd)f)((⍎i⊃opm)f)}
  Fexd←{(⊃n⍵)(##.OP.ptd)('Fexdm();',nl)}
  Fex0←{3⍴⊂''}
  Fund←{frt,(⊃n⍵),((⊃s⍵)⊃(⊂'(void)'),fpd),';',nl}
  Fun0←{frt,(⊃n⍵),'(void){',nl,'LOCALP *env[]={tenv};',nl,'tenv'ger ⍵}
  Fun1←{frt,(⊃n⍵),(¯1+2⌊⊃s ⍵)⊃fpd,¨(ght ⍵)(ghn ⍵)}
  Nms0←{hdr,('tenv'ged ⍵),nl}
  Nuf0←{'}',nl,nl}
  Nuf1←{'z->p=zap(',((⊃n⍵)vpp⊃e⍵),');cutp(&env0[0]);',nl,'isinit=oi;}',nl,nl}
  Scl0←{'{',(⍺ SD.(crk,grt,gpp,gsp,std,sto) 1↓⍵),'}',nl}
  gc←{⊃,/((dis⍤1 FexS ⍵)⍪fdb)∘dis¨((1≥d)⊂[0]⊢)(~FexM ⍵)⌿⍵}
:EndNamespace
