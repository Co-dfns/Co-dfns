:Namespace G
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ SD←##.SD ⋄ OP←##.OP ⋄ R←##.R
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ s←A.s ⋄ v←A.v ⋄ e←A.e
  tl←##.U.tl ⋄ do←##.U.do ⋄ var←##.U.var ⋄ nl←##.U.nl ⋄ pp←#.pp
  frt←'void EXPORT ' ⋄ flp←'LOCALP*z,LOCALP*l,LOCALP*r'
  fpd←('(',flp,')')('(',flp,',LOCALP*penv[])')
  gfi←'int oi=isinit;if(!isinit){Init();isinit=1;}',nl
  cutp←'cutp(&env0[0]);'
  coms←{⊃{⍺,',',⍵}/⍵}
  ged←{'LOCALP ',⍺,'[',(⍕⊃v⍵),'];'} ⋄ ger←{(⊃v⍵)do'regp(&',⍺,'[i]);'}
  gel←{'LOCALP*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
  ght←{'{',nl,gfi,('env0'ged ⍵),'LOCALP*env[]={env0,tenv};',nl,'env0'ger ⍵}
  ghn←{'{',nl,gfi,('env0'ged ⍵),(gel ⍵),'env0'ger ⍵}
  elt←{(⍵≡⌊⍵)⊃'APLDOUB' 'APLLONG'} ⋄ eld←{(⍵≡⌊⍵)⊃'double' 'aplint32'}
  vec←{(vsp≢⍵),'getarray(',(coms (elt⊃⍵)(⍕1<≢⍵)'sp'((⊃⍵)var 0⌷⍉⍺)),');}',nl}
  vsp←{'{BOUND ',(1<⍵)⊃'*sp=NULL;'('sp[1]={',(⍕⍵),'};')}
  vpp←{'(',(⍺ var ⍵),')->p'}
  dap←{⍺⍺,'*',⍺,'=ARRAYSTART(',((⊃n ⍵)vpp 0⌷⍉⊃e ⍵),');',nl}
  fil←{⊃,/⍵(⍺{⍺⍺,'[',(⍕⍵),']=',(((⍺<0)⊃'' '-'),⍕|⍺),';'})¨⍳≢⍵}
  dff←{⍺⍺,'(',(coms ⍵),'); /* Fallback */',nl}
  grh←{'{',(⊃,/⍺⍺{'LOCALP*',⍺,'=',⍵,';'}¨⍺ var¨↓⍉⍵),nl}
  ghm←'rslt' 'rgt'grh ⋄ ghd←'rslt' 'lft' 'rgt'grh
  gec←{((0⌷⍉⍵⍵)⍳⊂⍺)⊃(⍺⍺⌷⍉⍵⍵),⊂⍺ dff ⍵}
  dis←{⍺←⊢ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}
  Ac←{((⊃e⍵)vec⊃v⍵),'{',('v'((eld⊃⊃v⍵)dap)⍵),('v'fil⊃v⍵),'}',nl}
  A0←{((⊃n ⍵)vpp 0⌷⍉⊃e ⍵),'=ref(',((⊃⊃v ⍵)vpp 1⌷⍉⊃e ⍵),');',nl}
  Em←{(vs ghm(⊃e⍵)[;0 2  ]),(f(2 gec ⍺)vs),'}',nl⊣vs←(⊃n⍵)r⊣f r←⊃v⍵}
  Ed←{(vs ghd(⊃e⍵)[;0 1 3]),(f(1 gec ⍺)vs),'}',nl⊣vs←(⊃n⍵)l r⊣l f r←⊃v⍵}
  Ei←{a i  ←⊃v⍵ ⋄ vs←(⊃n⍵)a i ⋄ (vs ghd(⊃e⍵)),((,'[')(1 gec ⍺)vs),'}',nl}
  Oi←{(⊃n⍵)(##.MF.cat)('Fexim();',nl)}
  Of←{(⊃n⍵)(f,'(rslt,lft,rgt);',nl)(f,'(rslt,NULL,rgt);',nl)⊣f←⊃⊃v⍵}
  Om←{(⊃n⍵)((⍎i⊃opd)f)((⍎i⊃opm)f)⊣i←opn⍳⊂o⊣f o←⊃v⍵}
  Od←{(⊃n⍵)(##.OP.ptd)('Fexdm();',nl)}
  O0←{3⍴⊂''}
  Fd←{frt,(⊃n⍵),((⊃s⍵)⊃(⊂'(void)'),fpd),';',nl}
  F0←{frt,(⊃n⍵),'(void){',nl,'LOCALP *env[]={tenv};',nl,'tenv'ger ⍵}
  F1←{frt,(⊃n⍵),(¯1+2⌊⊃s ⍵)⊃fpd,¨(ght ⍵)(ghn ⍵)}
  M0←{R.rth,('tenv'ged ⍵),nl}
  Z0←{'}',nl,nl}
  Z1←{'z->p=zap(',((⊃n⍵)vpp⊃e⍵),');',cutp,nl,'isinit=oi;}',nl,nl}
  S0←{'{',(⍺ SD.(crk,grt,gpp,gsp,std,sto) 1↓⍵),'}',nl}
  gc←{⊃,/((dis⍤1 A.Os ⍵)⍪fdb)∘(⊂dis)⍤1⊢(~A.Om ⍵)⌿⍵}
:EndNamespace
