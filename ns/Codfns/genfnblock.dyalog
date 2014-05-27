 GenFnBlock←{mod fr bldr env0←⍺⍺ ⋄ nm vl←⍺ ⋄ k←⍵
     line←{n←⊃0 1⌷⍺                      ⍝ Op to handle node in function body
         n≡'Expression':⍺(⍺⍺ GenExpr)⍵   ⍝ Use GenExpr on Expressions
         n≡'Condition':⍺(⍺⍺ GenCond)⍵    ⍝ Use GenCond on Conditions
         emsg←'UNKNOWN FUNCTION CHILD'   ⍝ Only deal with Exprs or Conditions
         emsg ⎕SIGNAL 99                 ⍝ And signal an error otherwise
     }
     _ v←⊃⍺⍺ line/(⌽⍵),⊂⍺                ⍝ Reduce top to bottom over children
     mt←GetNamedFunction mod'array_free' ⍝ Runtime function to empty array
     0=mt:'MISSING RUNTIME FN'⎕SIGNAL 99
     res←GetParam fr 0                   ⍝ ValueRef of result parameter
     mtret←{                             ⍝ Fn for empty return
         _←BuildCall bldr mt res 1 ''    ⍝ Empty the result parameter
         bldr(⍵ MkRet)env0               ⍝ And make return
     }
     0=≢⍵:mtret mod                      ⍝ Empty return on empty body
     'Condition'≡⊃0 1⌷l←⊃⌽⍵:mtret mod    ⍝ Extra return if condition
     cp←GetNamedFunction mod'array_cp'   ⍝ Runtime array copy function
     0=cp:'MISSING RUNTIME FN'⎕SIGNAL 99
     ∨/' '≠⊃'name'Prop 1↑l:{             ⍝ Is last node named?
         args←res,⊃⌽v                    ⍝ Then we return the binding
         _←BuildCall bldr cp args 2 ''   ⍝ Copied into result array
         bldr(mod MkRet)env0             ⍝ And return
     }⍵
     1:shy←v
 }