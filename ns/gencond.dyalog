 GenCond←{mod fr bldr env0←⍺⍺ ⋄ nm vl←⍵ ⋄ node←⍺
     te←⊃k←1 Kids ⍺                       ⍝ Children and test expression
     te nm vl←⍵(⍺⍺ LookupExpr)1↑1↓te      ⍝ Find ValueRef of test expression
     gp←BuildStructGEP bldr te 4 ''       ⍝ Get data values pointer
     tp←BuildLoad bldr gp'tp'            ⍝ Load data values
     ap←ArrayType Int64Type 1             ⍝ Type of an Array
     ap←PointerType ap 0                  ⍝ Pointer type to an array
     tp←BuildBitCast bldr tp ap''        ⍝ Cast data values to array pointer
     gp←BuildGEP bldr tp(GEPI 0 0)2 ''  ⍝ Value pointer
     tv←BuildLoad bldr gp'tv'            ⍝ Load value
     zr←ConstInt Int64Type 0 1            ⍝ We're testing against zero
     t←BuildICmp bldr 32 tv zr'T'        ⍝ We test at the end of block
     cb←AppendBasicBlock fr'consequent'  ⍝ Consequent basic block
     _←PositionBuilderAtEnd bldr cb       ⍝ Point builder to consequent
     _←⍵(⍺⍺ GenFnBlock)1↓k                ⍝ Generate the consequent block
     ob←GetPreviousBasicBlock cb          ⍝ Original basic block
     ab←AppendBasicBlock fr'alternate'   ⍝ Alternate basic block
     _←PositionBuilderAtEnd bldr ob       ⍝ We need to add a conditional break
     _←BuildCondBr bldr t ab cb           ⍝ To the old block pointing to cb and ab
     _←PositionBuilderAtEnd bldr ab       ⍝ And then return pointing at the ab
     nm vl                                ⍝ Return our possibly new environment
 }