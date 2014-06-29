 GenExpr←{mod fr bldr env0←⍺⍺ ⋄ nm vl←⍵ ⋄ node←⍺
     gnf←{GetNamedFunction mod ⍵}            ⍝ Convenience function
     call←{                                  ⍝ Op to build call
         0=⍺:'NULL FN'⎕SIGNAL 99
         BuildCall bldr ⍺ ⍵(≢⍵)''
     }
     cpf←gnf'array_cp'                       ⍝ Foreign copy function
     cpy←{0=⍺:0 ⋄ cpf call ⍺ ⍵}              ⍝ Copy wrapper
     gret←{GetParam ⍵ 0}                     ⍝ Fn to get result array
     gloc←{                                  ⍝ Fn to get local variable
         idx←GEPI,⍺
         BuildGEP bldr(⊃env0)idx 1 ⍵
     }
     nms←Split⊃'name'Prop 1↑⍺                ⍝ Assignment variables
     sl←Split⊃'slots'Prop 1↑⍺                ⍝ Slots for variable assignments
     sl←{∧/' '=⍵:0 ⋄ ⍎⍵}¨sl                  ⍝ Convert to right type
     tgt←sl{0=≢⍵:gret fr ⋄ ⍺ gloc¨⍵}nms      ⍝ Target Value Refs for assignment
     tgh←⊃tgt ⋄ tgr←1↓tgt                    ⍝ Split into head and rest targets
     nm vl←⍺(⍺⍺{rec←∇                        ⍝ Process the Expr
         cls←⊃'class'Prop 1↑⍺                ⍝ Node class
         'atomic'≡cls:⍺(⍺⍺{                  ⍝ Atomic: Var Reference
             av nm vl←⍵(⍺⍺ LookupExpr)1↑1↓⍺  ⍝ Lookup expression variable
             nm vl⊣tgh cpy av                ⍝ Copy into the first target
         })⍵
         lft nm vl f r←⍺(⍺⍺{                 ⍝ Left argument handled based on arity
             gnap←GenNullArrayPtr            ⍝ Convenience
             dlft←⍺⍺{⍵(⍺⍺ LookupExpr)1↑2↓⍺}  ⍝ Grab left argument in dyadic case
             'monadic'≡cls:(gnap ⍬),⍵,0 1    ⍝ No new bindings, Fn Rgt ←→ 1st, 2nd
             'dyadic'≡cls:(⍺ dlft ⍵),1 2     ⍝ New bindings, Fn Rgt ←→ 2nd, 3rd
             'BAD CLASS'⎕SIGNAL 99           ⍝ Error trap just in case
         })⍵
         rgt nm vl←(k←1 Kids ⍺)(⍺⍺{          ⍝ Process the right argument
             'atomic'≡⊃'class'Prop r⊃⍺:⍺(⍺⍺{ ⍝ Handling for an atomic
                 ⍵(⍺⍺ LookupExpr)1↑1↓r⊃⍺     ⍝ Lookup the single variable
             })⍵
             tgh,(r⊃⍺)rec ⍵                  ⍝ Recur on other types of nodes
         })nm vl
         fn env←⍺⍺ GenFnEx f⊃k               ⍝ Get the function reference
         nm vl⊣fn call tgh,lft,rgt,env       ⍝ Build the call
     })⍵
     nb←(nms,nm)(((≢nms)↑tgt),vl)            ⍝ New bindings
     0=≢nms:nb⊣bldr(mod MkRet)env0           ⍝ Unnamed is a return
     nb⊣tgr cpy¨tgh                          ⍝ Copy rest of names; return bindings
 }
