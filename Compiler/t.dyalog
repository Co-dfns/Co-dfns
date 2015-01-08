:Namespace T
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ r←A.r ⋄ s←A.s
  FunS←A.FunS
  rn←⊢,∘↓(1+d)↑⍤¯1(+⍀d∘.=∘⍳1+(⌈/0,d)) ⍝ Function node references 
  rd←⊢,(+/↑∘r∧.(=∨0=⊢)∘⍉∘↑∘r FunS)    ⍝ Function depths
  df←{(~g∊(tl∧(FuncExpr ⍵)∧(name ⍵)∊⊂'')/g←+\tl←1=0⌷⍉⍵)⌿⍵}                       ⍝ Drop unnamed top-level functions
    du←{                                                                         ⍝ Drop syntactically unreachable code
      rf←(fn←Function ⍵)⌿r←↑ref ⍵ ⋄ rd←{1↓(0≠⍵)/⍵}⍤1⊢r
      adj←((name ⍵)∊⊂''){0,1↓(¯1⌽⍺)∧⍵=¯1⌽⍵}opt(fn∨(↓rd)∊↓rf)⊢0⌷⍉⍵
      in←rd∧.(=∨0=⊢)⍉drop⌿rd ⋄ below←r∧.≥⍉drop⌿r×0=rd
      (~adj∨∨/in∧below)⌿⍵
    }
    lc←{                                                                         ⍝ Lift constants to top-level
      le←l∨e←(Expression ⍵)∧1⌽l←Number ⍵
      h←(1+Number h),1↓[1]h←le⌿w←⍵
      (3⌷⍉(Expression h)⌿h)ren←v←(⊂'lc'),¨⍳+/e
      (3⌷⌽fl⌿w)←v{3 2⍴'class' 'array' 'name'⍺'ref'⍵}¨ref(fl←¯1⌽e)⌿⍵
      (1⌷⍉fl⌿w)←⊂'Variable'
      (1↑w)⍪h⍪1↓w←(fl∨~l)⌿w
    }
    lf←{                                                                         ⍝ Lift functions to top-level
      fnh←{                                                                      ⍝   Function handler
        h←⍉⍪1 'FuncExpr' ''(3 2⍴'name'('fn',⍕rm⊥⍺)'class' 'ambivalent' 'ref'())
        h⍪(2 'Function' ''(⍉⍪'ref'⍺))⍪((-¯3+⊃)0⌷⍉⍵),1↓[1]⍵
      }
      ngh←{                                                                      ⍝ Node group handler
        rf←↑ref(fn←Function ⍵)⌿g←⍵
        (3⌷⍉fn⌿g)ren←(⊂'fn'),¨rm⊥⍉rf
        (1⌷⍉fn⌿g)←⊂'Variable'
        ⍺ fnh⍣ft⊢g
      }
      rm←1+⌈⌿r←↑ref ⍵
      sc←1↓{1↓(0≠⍵)/⍵}⍤1⊢r ⋄ rf←(1,1↓Function ⍵)⌿r
      c←(⌈/(⍳1↓⍴rf)×⍤1⊢sc∧.(=∨0=⊢)⍉rf)⌷⍤0 2⊢rf
      (1↓⍵)⍪c ngh⌸1↓⍵
    }

⍝ Flatten expressions (Need to handle condition nodes)
    fe←{
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