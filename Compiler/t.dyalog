:Namespace T
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ r←A.r ⋄ s←A.s
  FunS←A.FunS ⋄ FexM←A.FexM ⋄ FunM←A.FunM ⋄ AtmM←A.AtmM ⋄ NumM←A.NumM ⋄ ExpS←A.ExpS
  ExpM←A.ExpM ⋄ pp←#.pp
  rn←⊢,∘↓(1+d)↑⍤¯1(+⍀d∘.=∘⍳1+(⌈/0,d))
  rd←⊢,(+/↑∘r∧.(=∨0=⊢)∘⍉∘↑∘r FunS)
  df←(~(+\1=d)∊((1=d)∧(FexM∨FunM)∧0∊⍨n)(/∘⊢)(+\1=d))(⌿∘⊢)⊢
  prf←((≢↑¯1↓(0≠⊢)(/∘⊢)⊢)⍤1↑∘r)⊢
  dua←(FunM∨↓∘prf∊r∘FunS)(⊣(⍀∘⊢)(⊣(⌿∘⊢)0∊⍨n)(0,1↓(¯1⌽⊣)∧⊢=¯1⌽⊢)⊣(⌿∘⊢)d)⊢
  du←(~dua∨(∨/(prf∧.(=∨0=⊢)∘⍉dua(⌿∘⊢)prf)∧↑∘r∧.≥∘⍉dua(⌿∘↑)r×0=prf))(⌿∘⊢)⊢
  enc←⊂⊣,∘⊃((⊣,'.',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
  blg←{⍺←⊢ ⋄ ⍺((prf(⌈/(⍳∘≢⊢)×⍤1(1↓⊣)∧.(=∨0=⊢)∘⍉⊢)⍺⍺(⌿∘↑)r)⌷⍤0 2 ⍺⍺(⌿∘⊢)⍵⍵)⍵}
  lfv←⍉∘⍪(1+⊣),(,¨'Var' 'f'),('fn'enc 4⊃⊢),4↓⊢
  lfn←('Fun'≡1⊃⊢)⌷(⊣-⍨∘⊃⊢)((⊂∘⍉∘⍪⊣,1↓⊢),∘⊂(⊣,(,¨'Fex' 'f'),3↓⊢)⍪lfv)⊢
  lfh←⍉∘⍪1'Fun'0,('fn'enc⊣),4↓∘,1↑⊢
  lf←(1↑⊢)⍪∘⊃(⍪/(1,1↓FunM)blg(↑r)(⊂lfh⍪∘⊃(⍪/(¯2+∘⊃⊢)lfn⍤¯1⊢))⌸1↓⊢)
  pck←{⍺(⍺⍺⌷⍤¯1⍵⍵,∘⍪⍺⍺(⍀∘⊢)⊣)⍵}
  lch←⊣((1+NumM),t,k,AtmM pck n,r,∘⍪s)(AtmM∨NumM)(⌿∘⊢)⊢
  lcr←d,(↑(↓(⊂'Var'),(⊂,'a'),∘⍪⊣)(¯1⌽AtmM)pck(↓t,k,∘⍪n)⊢),r,∘⍪s
  lc←((⊂'lc'),∘⍕¨∘⍳(+/AtmM))((1↑⊢)⍪lch⍪1↓((¯1⌽AtmM)∨∘~NumM)(⌿∘⊢)lcr)⊢
  da←((0∊⍨n)∧AtmM∨FexM∧(⊂∘,'f')∊⍨k)((~⊣)(⌿∘⊢)(d-¯1⌽⊣),1↓[1]⊢)⊢            
  fer←(d,(,¨'Var' 'a'),('fe'enc∘⊃ r),4↓⊢)⍤1
  fev←(⊂(d-(⊃d)-(⊃⊣)),1↓[1]⊢)⊣⍪(AtmM∨ExpM)⌷⍤¯1⊢,[0.5]fer
  fe←(⊃⍪/)(+\FunM)(⍪/(+\d=1+∘⊃⊢)(⍪/((⊂1↑⊢),∘⌽(1,1↓AtmM∨ExpM)blg⊢fev⌸1↓⊢))⌸⊢)⌸⊢
⍝ Flatten expressions (Need to handle condition nodes)
    feo←{
      feg←{⍝ Flatten expression statement
        ed←(Expression∧(⊂'dyadic')∊⍨class)⍵
        (3⌷⍉ed⌿w)⍪←'left'with name(v←¯2⌽ed)⌿w←⍵
        (3⌷⍉(1⌽fe)⌿w)⍪←'fn'with name(¯1⌽fe←FuncExpr w)⌿w←(~v∨1⌽v)⌿w
        (3⌷⍉¯1↓w)⍪←'right'with 1↓{(''≡⍵)⊃⍵ ⍺}\name w←(~fe∨v)⌿w
        3,⊖1↓[1]¯1↓w
      }
      fm←0≠fg←+\1⌽Function ⍵
      ((~fm)⌿⍵)⍪(fm⌿fg){(2↑⍵)⍪(+\(⊃e)=0⌷⍉e)feg⌸e←2↓⍵}⌸fm⌿⍵
    }

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