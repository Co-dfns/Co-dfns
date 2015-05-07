:Namespace G
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ MF←##.MF ⋄ OP←##.OP ⋄ R←##.R

  ⍝ Generator
  gc←{⊃,/((dis⍤1 A.Os ⍵)⍪R.fdb)∘(⊂dis)⍤1⊢(~A.Om ⍵)⌿⍵}
  dis←{⍺←⊢ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}

  ⍝ Expressons
  Em←{(vs ghm(⊃e⍵)[;0 2  ]),(f(2 gec ⍺)vs),'}',nl⊣vs←(⊃n⍵)r⊣f r←⊃v⍵}
  Ed←{(vs ghd(⊃e⍵)[;0 1 3]),(f(1 gec ⍺)vs),'}',nl⊣vs←(⊃n⍵)l r⊣l f r←⊃v⍵}
  Ei←{a i  ←⊃v⍵ ⋄ vs←(⊃n⍵)a i ⋄ (vs ghd(⊃e⍵)),((,'[')(1 gec ⍺)vs),'}',nl}
  Es←{...}

  ⍝ Operators ← (Name)(Monadic)(Dyadic)
  Oi←{(⊃n⍵)('Fexim()i',nl          )(MF.cat                )}
  Of←{(⊃n⍵)(f,'(rslt,NULL,rgt);',nl)(f,'(rslt,lft,rgt);',nl)⊣f←⊃⊃v⍵}
  Om←{(⊃n⍵)((⍎i⊃opm)f              )((⍎i⊃opd)f             )⊣i←opn⍳⊂o⊣f o←⊃v⍵}
  Od←{(⊃n⍵)('Fexdm();',nl          )(##.OP.ptd             )}
  O0←{('' )(''                     )(''                    )}

  ⍝ Functions
  Fd←{frt,(⊃n⍵),((⊃s⍵)⊃(⊂'(void)'),fpd),';',nl}
  F0←{frt,(⊃n⍵),'(void){',nl,'LOCALP *env[]={tenv};',nl,'tenv'ger ⍵}
  F1←{frt,(⊃n⍵),(¯1+2⌊⊃s ⍵)⊃fpd,¨(ght ⍵)(ghn ⍵)}
  Z0←{'}',nl,nl}
  Z1←{'z->p=zap(',((⊃n⍵)vpp⊃e⍵),');',cutp,nl,'isinit=oi;}',nl,nl}

  ⍝ Namespaces
  M0←{R.rth,('tenv'ged ⍵),nl}

  ⍝ Scalars
  S0←{'{',(⍺ SD.(crk,grt,gpp,gsp,std,sto) 1↓⍵),'}',nl}
  Y0←{...}

:EndNamespace
