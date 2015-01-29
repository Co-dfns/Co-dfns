:Namespace T
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ r←A.r ⋄ s←A.s
  v←A.v
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
  lfh←(1<(+/⊣))⊃(⊂0↑⊢),∘⊂∘⍉∘⍪1'Fun'0,('fn'enc⊣),4↓∘,1↑⊢
  lf←(1↑⊢)⍪∘⊃(⍪/(1,1↓FunM)blg(↑r)(⊂lfh⍪∘⊃(⍪/((¯2+1=(+/⊣))+∘⊃⊢)lfn⍤¯1⊢))⌸1↓⊢)
  pck←{⍺(⍺⍺⌷⍤¯1⍵⍵,∘⍪⍺⍺(⍀∘⊢)⊣)⍵}
  lch←⊣((1+NumM),t,(⊂,'c'),AtmM pck n,r,∘⍪s)(NumM∨AtmM∧1⌽NumM)(⌿∘⊢)⊢
  lcr←d,(↑(↓(⊂'Var'),(⊂,'a'),∘⍪⊣)(NumM∧¯1⌽AtmM)pck(↓t,k,∘⍪n)⊢),r,∘⍪s
  lc←((⊂'lc'),∘⍕¨∘⍳(+/AtmM∧1⌽NumM))((1↑⊢)⍪lch⍪1↓((¯1⌽AtmM)∨∘~NumM)(⌿∘⊢)lcr)⊢
  da←((0∊⍨n)∧AtmM∨FexM∧(⊂∘,'f')∊⍨k)((~⊣)(⌿∘⊢)(d-¯1⌽⊣),1↓[1]⊢)⊢
  fen←(0≡∘⊃n)⌷n,'fe'enc∘⊃r
  fer←(d,(⊂'Var'),(⊂∘,'af'⊃⍨'Fex'≡∘⊃ t),fen,4↓⊢)⍤1
  fev←(((3↑⊢),fen,4↓⊢)⊣)⍪(AtmM∨ExpM∨FexM)⌷⍤¯1⊢,[0.5]fer
  fee←⍪/(⌽(1,1↓AtmM∨ExpM∨FexM)blg⊢((⊂(d-(⊃d)-2⌊∘⊃d),1↓[1]⊢)fev)⌸1↓⊢)
  fe←(⊃⍪/)(+\FunM)(⍪/(⊂1↑⊢),(1↓(+\d=1+∘⊃⊢))fee⌸1↓⊢)⌸⊢
  ce←(+\'Atm' 'Fun' 'Fex' 'Exp'∊⍨t)(,(1↑⊢),∘⊂∘n 1↓⊢)⌸⊢
  avb←{⍺⌷⍨⍤2 0⊢⍺⍺⍳⍺⍺∩⍨(↓(⌽1+∘⍳0⍳⍨⊢)((≢⊢)↑↑)⍤0 1⊢)⊃r ⍵}
  avh←{⊂⍵,(n⍵)((⍺⍺(⍵⍵ avb)⍵){(⍴⍺⍺)⊤(,⍺⍺)⍳(⊂⍺),⌽(¯1⌈1-≢⍵)↓¯1⌽⍵})¨v⍵}
  av←(⊃⍪/)(+\FunM){⍺((⍺(n(ExpM∨AtmM)(⌿∘⊢)⊢)⌸⍵)avh(r(1↑⍵)⍪FunS ⍵))⌸⍵}⊢
:EndNamespace