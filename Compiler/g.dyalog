:Namespace G
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ H←##.H ⋄ MF←##.MF ⋄ OP←##.OP ⋄ R←##.R
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ r←A.r ⋄ s←A.s ⋄ v←A.v ⋄ y←A.y ⋄ e←A.e
  nl←H.nl

  ⍝ Generator
  dis←{⍺←⊢ ⋄ 0=⊃t⍵:3⍴⍬ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}
  gc←(⊃,/)⊢((R.fdb⍪⍨∘(dis⍤1)(⌿⍨))(⊂dis)⍤2 1(⌿⍨∘~))A.(Om∧'mdi'∊⍨k)

  ⍝ Expressons
  Em←{r u f←⊃v⍵ ⋄ (2↑⊃y⍵)(f R.fcl ⍺)(⊃n⍵)r,⍪2↑↓⍉⊃e⍵}
  Ed←{r l f←⊃v⍵ ⋄ (¯1↓⊃y⍵)(f R.fcl ⍺)((⊃n⍵)r l),⍪¯1↓↓⍉⊃e⍵}
  Es←{r l f←⊃v⍵ ⋄ (⊃H.git 1↑⊃y⍵),(⊃n⍵),'=',(R.sdb(f R.scl)(1+'%u'≢l)↑r l),';',nl}

  ⍝ Operators ← (Name)(Monadic)(Dyadic)
  Oi←{(⊃n⍵)('Fexim()i',nl)('MF.cat')}
  Om←{(n⍵),R.odb(o R.ocl)f⊣f u o←⊃v⍵}
  Od←{(⊃n⍵)('Fexdm();',nl)('OP.ptd')}
  O0←{'' '' ''}
  Of←{H.fre,(⊃n⍵),H.elp,'{',nl,H.foi,H.tps,(⊃,/(⍳6)H.cas¨⊂⊃⊃v⍵),'}}',nl,nl}

  ⍝ Functions
  Fd←{H.frt,(⊃n⍵),H.flp,';',nl}
  F0←{H.frt,(⊃n⍵),H.flp,'{',nl,'LOCALP *env[]={tenv};',nl,'tenv'H.reg ⍵}
  F1←{H.frt,(⊃n⍵),H.{flp,'{',nl,('env0'dnv ⍵),(fnv ⍵),'env0'reg ⍵}⍵}
  Z0←{'}',nl,nl}
  Z1←{'z->p=zap((',((⊃n⍵)H.var⊃e⍵),')->p);',H.cutp,nl,'}',nl,nl}

  ⍝ Namespaces
  M0←{H.rth,('tenv'H.dnv ⍵),nl,'LOCALP *env[]={',((0≡⊃⍵)⊃'tenv' 'NULL'),'};',nl}

  ⍝ Scalars
  S0←{(H.('{',rk0,srk,('prk'do'cnt*=sp[i];'),spp,sfv,slp)⍵)}
  Y0←{⊃,/((⍳≢⊃v⍵)((⊣H.sts¨∘⊃y),'}',nl,⊣H.ste¨(⊃v)H.var¨∘⊃e)⍵),'}',nl}

:EndNamespace
