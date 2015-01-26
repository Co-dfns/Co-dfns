:Namespace T
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ r←A.r ⋄ s←A.s
  FunS←A.FunS ⋄ FexM←A.FexM ⋄ FunM←A.FunM ⋄ AtmM←A.AtmM ⋄ NumM←A.NumM ⋄ ExpS←A.ExpS
  ExpM←A.ExpM ⋄ pp←#.pp
  rn←⊢,∘↓(1+d)↑⍤¯1(+⍀d∘.=∘⍳1+(⌈/0,d))
  rd←⊢,(+/↑∘r∧.(=∨0=⊢)∘⍉∘↑∘r FunS)
  df←(~(+\1=d)∊((1=d)∧(FexM∨FunM)∧0∊⍨n)(/∘⊢)(+\1=d))(⌿∘⊢)⊢
  prf←((≢↑¯1↓(0≠⊢)(/∘⊢)⊢)⍤1↑∘r)⊢
  dua←(FunM∨↓∘prf∊r∘FunS)(⊣(⍀∘⊢)(⊣(⌿∘⊢)0∊⍨n)(0,1↓(¯1⌽⊣)∧⊢=¯1⌽⊢)⊣(⌿∘⊢)d)⊢
  du←(~dua∨(∨/(prf∧.(=∨0=⊢)∘⍉dua(⌿∘⊢)prf)∧↑∘r∧.≥∘⍉dua(⌿∘⊢)↑∘r×0=prf))(⌿∘⊢)⊢
  enc←⊂⊣,∘⊃((⊣,'.',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
  blg←{⍺←⊢ ⋄ ⍺((prf(⌈/(⍳∘≢⊢)×⍤1(1↓⊣)∧.(=∨0=⊢)∘⍉⊢)⍺⍺(⌿∘↑)r)⌷⍤0 2 ⍺⍺(⌿∘⊢)⍵⍵)⍵}
  lfv←⍉∘⍪(1+⊣),(,¨'Var' 'f'),('fn'enc 4⊃⊢),4↓⊢
  lfn←('Fun'≡1⊃⊢)⌷(⊣-⍨∘⊃⊢)((⊂∘⍉∘⍪⊣,1↓⊢),∘⊂(⊣,(,¨'Fex' 'f'),3↓⊢)⍪lfv)⊢
  lfh←⍉∘⍪1'Fun'0,('fn'enc⊣),4↓∘,1↑⊢
  lf←(1↑⊢)⍪∘⊃(⍪/(1,1↓FunM)blg(↑r)(⊂lfh⍪∘⊃(⍪/(¯2+∘⊃⊢)lfn⍤¯1⊢))⌸1↓⊢)
  pck←{⍺(⍺⍺⌷⍤¯1⍵⍵,∘⍪⍺⍺(⍀∘⊢)⊣)⍵}
  lch←⊣((1+NumM),t,k,AtmM pck n,r,∘⍪s)(NumM∨AtmM∧1⌽NumM)(⌿∘⊢)⊢
  lcr←d,(↑(↓(⊂'Var'),(⊂,'a'),∘⍪⊣)(NumM∧¯1⌽AtmM)pck(↓t,k,∘⍪n)⊢),r,∘⍪s
  lc←((⊂'lc'),∘⍕¨∘⍳(+/AtmM∧1⌽NumM))((1↑⊢)⍪lch⍪1↓((¯1⌽AtmM)∨∘~NumM)(⌿∘⊢)lcr)⊢
  da←((0∊⍨n)∧AtmM∨FexM∧(⊂∘,'f')∊⍨k)((~⊣)(⌿∘⊢)(d-¯1⌽⊣),1↓[1]⊢)⊢            
  fer←(d,(,¨'Var' 'a'),('fe'enc∘⊃ r),4↓⊢)⍤1
  fev←(((3↑⊢),('fe'enc∘⊃r),4↓⊢)⊣)⍪(AtmM∨ExpM)⌷⍤¯1⊢,[0.5]fer
  fee←⍪/(⌽(1,1↓AtmM∨ExpM)blg⊢((⊂(d-(⊃d)-2⌊∘⊃d),1↓[1]⊢)fev)⌸1↓⊢)
  fe←(⊃⍪/)(+\FunM)(⍪/(⊂1↑⊢),(1↓(+\d=1+∘⊃⊢))fee⌸1↓⊢)⌸⊢
⍝ Anchor variables to environments
    av←{
      sh←{⍝ Handle scope
        b←↑(sk⍳sk∩⍨↓(⌽1+⍳r⍳0)↑⍤0 1⊢r←(0≠⍺)⊃ref ⍵)⌷¨⊂sb
        nm←(name e),(left e),⍪right(e←(1+0≠⍺)↓⍵)
        at←'env' 'slot' 'left_env' 'left_slot' 'right_env' 'right_slot'
        (3⌷⍉e)⍪←⊂⍤2⊢at,((≢nm),6 1)⍴⍉(⍴b)⊤(,b)⍳,nm
        ((1+0≠⍺)↑⍵)⍪e
      }
      sb←(k←+\1⌽Function ⍵){name(Expression ⍵)⌿⍵}⌸⍵
      sk←(1,1↓Function ⍵)/ref ⍵
      k sh⌸⍵
    }

⍝ Convert Primitives (Rewrite!)
    cp←{ast←⍵
      pm←(1⌷⍉⍵)∊⊂'Primitive'               ⍝ Mask of Primitive nodes
      pn←'name'Prop pm⌿⍵                   ⍝ Primitive names
      cn←(APLPrims⍳pn)⌷¨⊂APLRunts⍪APLRtOps ⍝ Converted names
      hd←⍉⍪'class' 'function'              ⍝ Class is function
      at←(⊂⊂'name')(hd⍪,)¨cn               ⍝ Name of the function
      vn←(⊂'Variable'),(⊂''),⍪at           ⍝ Build the basic node structure
      ast⊣(pm⌿ast)←(pm/0⌷⍉⍵),vn            ⍝ Replace Primitive nodes
    }

:EndNamespace