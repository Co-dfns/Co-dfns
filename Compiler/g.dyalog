:Namespace G
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ H←##.H ⋄ MF←##.MF ⋄ OP←##.OP ⋄ R←##.R
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ r←A.r ⋄ s←A.s ⋄ v←A.v ⋄ y←A.y ⋄ e←A.e
  nl←H.nl

  ⍝ Generator
  dis←{⍺←⊢ ⋄ 0=⊃t⍵:3⍴⍬ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}
  gc←(⊃,/)⊢((R.fdb⍪⍨∘(dis⍤1)(⌿⍨))(⊂dis)⍤2 1(⌿⍨∘~))A.(Om∧'mdi'∊⍨k)

  ⍝ Expressons
  Em←{  f r←⊃v⍵ ⋄ (⊃y⍵)(f R.fcl ⍺)(⊃n⍵)   r}
  Ed←{l f r←⊃v⍵ ⋄ (⊃y⍵)(f R.fcl ⍺)(⊃n⍵) l r}
  Ei←{a   i←⊃v⍵ ⋄ vs←(⊃n⍵)a i ⋄ (vs ghd(⊃e⍵)),((,'[')(1 gec ⍺)vs),'}',nl}
  Es←{}

  ⍝ Operators ← (Name)(Monadic)(Dyadic)
  Oi←{(⊃n⍵)('Fexim()i',nl)(MF.cat)}
  Om←{(n⍵),R.odb(o R.ocl)f⊣f o←⊃v⍵}
  Od←{(⊃n⍵)('Fexdm();',nl)(OP.ptd)}
  O0←{'' '' ''}
  Of←{H.frt,(⊃n⍵),H.elp,'{',nl,H.foi,H.tps,(⊃,/(⍳6)H.cas¨⊃v⍵),'}}',nl,nl}

  ⍝ Functions
  Fd←{H.frt,(⊃n⍵),H.flp,';',nl}
  F0←{H.frt,(⊃n⍵),H.flp,'{',nl,'LOCALP *env[]={tenv};',nl,'tenv'H.reg ⍵}
  F1←{H.frt,(⊃n⍵),H.{flp,'{',nl,('env0'dnv ⍵),(fnv ⍵),'env0'reg ⍵}⍵}
  Z0←{'}',nl,nl}
  Z1←{'z->p=zap((',((⊃n⍵)H.var⊃e⍵),')->p);',H.cutp,nl,'}',nl,nl}

  ⍝ Namespaces
  M0←{H.rth,('tenv'H.dnv ⍵),nl}

  ⍝ Scalars : Missing gpp/bod for S0
  S0←{(H.('{',rk0,srk,('prk'do'cnt+=sp[i];'),sfv,spp,slp)⍵)}
  Y0←{⊃,/((⍳≢⊃v⍵)((⊣H.sts¨∘⊃y),'}',nl,⊣H.ste¨(⊃v)H.var¨∘⊃e)⍵),'}',nl}

:EndNamespace
