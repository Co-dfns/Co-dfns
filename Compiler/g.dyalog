:Namespace G
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ R←##.R ⋄ pp←#.pp ⋄ tl←##.U.tl ⋄ do←##.U.do
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ s←A.s ⋄ v←A.v ⋄ e←A.e
  FunM←A.FunM ⋄ ExpM←A.ExpM ⋄ AtmM←A.AtmM ⋄ FexS←A.FexS ⋄ FexM←A.FexM
  EnvM←A.EnvM ⋄ pp←#.pp
  var←##.U.var ⋄ nl←##.U.nl
  hdr←'#include <math.h>',nl,'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
  hdr,←'int isinit=0;',nl
  flp←'LOCALP*z,LOCALP*l,LOCALP*r'
  fpd←'(void)'('(',flp,')')('(',flp,',LOCALP*penv[])')
  ged←{'LOCALP ',⍺,'[',(⍕⊃v⍵),'];'}
  ger←{(⊃v⍵)do'regp(&',⍺,'[i]);'}
  gel←{'LOCALP*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
  ghi←{'{',nl,'LOCALP *env[]={tenv};',nl,'tenv'ger ⍵}
  ght←{'{',nl,gfi,('env0'ged ⍵),'LOCALP*env[]={env0,tenv};',nl,'env0'ger ⍵}
  ghn←{'{',nl,gfi,('env0'ged ⍵),(gel ⍵),'env0'ger ⍵}
  gfi←'int oi=isinit;if(!isinit){Init();isinit=1;}',nl
  gfh←{'void EXPORT ',(⊃n ⍵),((2⌊⊃s ⍵)⊃fpd,¨(ghi ⍵)(ght ⍵)(ghn ⍵))}
  gfr←{'z->p=zap(',((⊃⌽n 1↓⍵)vpp 0⌷⍉⊃⌽e 1↓⍵),');'}
  gff←{⍵{(gfr ⍺),'cutp(&env0[0]);',nl,⍵}⍣(1⌊⊃s⍵)⊢,(⍺⊃'}' 'isinit=oi;}'),nl}
  elt←{(⍵≡⌊⍵)⊃'APLDOUB' 'APLLONG'} ⋄ eld←{(⍵≡⌊⍵)⊃'double' 'aplint32'}
  vec←{(vsp≢⍵),'getarray(',(elt⊃⍵),',',(⍕1<≢⍵),',','sp,',((⊃⍵)var 0⌷⍉⍺),');}',nl}
  vsp←{'{BOUND ',(1<⍵)⊃'*sp=NULL;'('sp[1]={',(⍕⍵),'};')}
  vpp←{'(',(⍺ var ⍵),')->p'}
  dap←{⍺⍺,'*',⍺,'=ARRAYSTART(',((⊃n ⍵)vpp 0⌷⍉⊃e ⍵),');',nl}
  fil←{⊃,/⍵(⍺{⍺⍺,'[',(⍕⍵),']=',(((⍺<0)⊃'' '-'),⍕|⍺),';'})¨⍳≢⍵}
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
  Fund←{'void EXPORT ',(⊃n⍵),((⊃s⍵)⊃fpd),';',nl}
  Nms0←{hdr,('tenv'ged ⍵),nl}
  Scl0←{⍺ R.gs 1↓⍵}
  gex←{⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵} ⋄ gdf←{(~(FunM∨EnvM∨FexM) ⍵)⌿⍵}
  gfd←{{⍎'Fex',(⍕⊃k⍵),' ⍵'}⍤1⊢FexS ⍵}
  gcf←{(gfh⍵),(⊃,/⍺∘gex¨((1,1↓(⊃d)=d)⊂[0]⊢)gdf 1↓⍵),((⊃k⍵)gff⍵),nl}
  gds←{⊃,/{⊂(⍎(⊃t⍵),⍕⊃k⍵)⍵}⍤1⊢(1↑⍵)⍪(('d'∊⍨k⍵)∧FunM ⍵)⌿⍵}
  gc←gds,gfd{⊃,/⍺∘gcf¨1↓⍵}((0 1∊⍨k)∧1,1↓FunM)⊂[0]⊢
:EndNamespace
