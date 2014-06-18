 GenInit←{
     ft←GenFuncType 0                     ⍝ Zero depth function
     fr←AddFunction ⍺'Init'ft             ⍝ Named Init
     bldr←CreateBuilder                   ⍝ Setup builder
     bb←AppendBasicBlock fr''             ⍝ Initial basic block
     _←PositionBuilderAtEnd bldr bb       ⍝ Link builder and basic block
     gex←{GetNamedGlobal ⍺ ⍵}             ⍝ Convenience Fn for GetNamedGlobal
     gfn←{GetNamedFunction ⍺ ⍵}           ⍝ Convenience Fn for GetNamedFunction
     call←{                               ⍝ Op to build call
         0=⍺⍺:'NULL FN'⎕SIGNAL 99         ⍝ Sanity Check
         BuildCall bldr ⍺⍺ ⍵(≢⍵)''        ⍝ Anonymous LLVM Fn Call
     }
     cpf←⍺ gfn'array_cp'                  ⍝ Runtime copy function
     cpy←{cpf call ⍺ ⍵}                   ⍝ Convenience Fn for Copying arrays
     mcall←{                              ⍝ Fn to generate multiple assignment
         v←⍺⍺ call(⊃⍺),⍵                  ⍝ Call on the first argument
         1=≢⍺:v                           ⍝ If single target, done.
         v,(1↓⍺)cpy¨⊃⍺                    ⍝ Otherwise, copy results to other args
     }
     gtg←{                                ⍝ Fn to ensure valid target name
         nm←⊃'name'Prop 1↑⍵               ⍝ Name attr of node
         ∧/' '=nm:(⍺ GenArrDec⊂'ign'),1   ⍝ If unnamed, generate temp name
         (⍺ gex¨Split nm)(0)              ⍝ Otherwise, lookup references
     }
     array_free←⍺ gfn'array_free'         ⍝ Runtime cleaner function reference
     free←{array_free call ⍵}             ⍝ Function to cleanup ararys
     clean←{(⊃⍺){⍵⊣free ⍺}⍣(⊃⌽⍺)⊢⍵}       ⍝ Fn to optionally cleanup temp array
     expr←{                               ⍝ Handle each global expr in turn
         n←⊃'class'Prop 1↑⍵               ⍝ Switch on node class
         'atomic'≡n:⍺{                    ⍝ Atomic case: variable reference
             ∧/' '=tgt←⊃'name'Prop 1↑⍵:0  ⍝ Ignore unnamed global references
             tgt←⍺ gex¨Split tgt          ⍝ Vector of target ValueRefs
             src←⍺ gex⊃'name'Prop 1↑1↓⍵   ⍝ Source ValueRef
             tgt cpy¨src                  ⍝ Copy source to each target
         }⍵
         'monadic'≡n:⍺{                   ⍝ Monadic: FVar Var, Depth always 0
             tgt ist←t←⍺ gtg ⍵            ⍝ Variables to be assigned
             lft←GenNullArrayPtr ⍬        ⍝ Left argument is null
             fn←⍺ gfn⊃'name'Prop 1↑2↓⍵    ⍝ Function is first child
             rgt←⍺ gex⊃'name'Prop 1↑4↓⍵   ⍝ Right argument is second child
             t clean tgt(fn mcall)lft rgt ⍝ Make the call
         }⍵
         'dyadic'≡n:⍺{                    ⍝ Dyadic: Var FVar Var
             tgt ist←t←a gtg ⍵            ⍝ Variables to be assigned
             lft←⍺ gex⊃'name'Prop 1↑2↓⍵   ⍝ Left argument is first child
             fn←⍺ gfn⊃'name'Prop 1↑4↓⍵    ⍝ Function is second child
             rgt←⍺ gex⊃'name'Prop 1↑6↓⍵   ⍝ Right argument is third child
             t clean tgt(fn mcall)lft rgt ⍝ Make the call
         }⍵
         'UNREACHABLE'⎕SIGNAL 99
     }
     finish←{
         zero←ConstInt Int32Type 0 0      ⍝ Zero Return
         _←BuildRet bldr zero             ⍝ No need to do regular return
         fr⊣DisposeBuilder bldr           ⍝ Cleanup and return function reference
     }
     0=≢⍵:finish ⍬                        ⍝ Nothing to do
     _←⍺ expr¨⍵                           ⍝ Handle each expr
     finish ⍬                             ⍝ Cleanup
 }