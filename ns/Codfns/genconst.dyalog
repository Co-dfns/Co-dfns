 GenConst←{mod←⍺
     vs←⊃'name'Prop 1↑⍵                   ⍝ Get the name of a literal
     mnlerr←'BAD LITERAL NAME'            ⍝ Error message
     ∨/' '=vs:mnlerr ⎕SIGNAL 99           ⍝ Sanity check for a single name
     v←((2≤⍴v)⊃⍬(⍴v))⍴v←'value'Prop 1↓⍵   ⍝ Expression values with correct shape
     arrayp←{⍺←⍺⍺                         ⍝ Fn to generate LLVM Array Pointer
         a←ConstArray ⍺⍺ ⍵(⊃⍴⍵)            ⍝ Data values
         at←ArrayType ⍺⍺(⊃⍴⍵)              ⍝ Type of the array
         g←AddGlobal mod at ⍵⍵              ⍝ Add global to the module
         _←SetInitializer g a               ⍝ Initialize it
         b←CreateBuilder                    ⍝ Need a builder
         t←PointerType ⍺ 0                  ⍝ Data pointer type
         p←BuildBitCast b g t''            ⍝ Cast array to field type
         p⊣DisposeBuilder b                 ⍝ Cleanup and return pointer
     }
     cintstr←ConstIntOfString             ⍝ Shorten the name
     mki←{ConstInt(Int64Type)(⍎⍵)1}      ⍝ Fn to make integers from v
     mkd←{ConstReal DoubleType(⍎⍵)}       ⍝ Fn to make doubles from v
     d←{⍵:mkd¨,v ⋄ mki¨,v}isf←'.'∊⊃,/v    ⍝ Construct data values from v
     d←⍺{t←Int8Type                       ⍝ Convert data values
         ⍵:t(DoubleType arrayp'elems')d    ⍝ to a data array pointer
         t(Int64Type arrayp'elems')d       ⍝ Either floats or ints
     }isf
     s←{                                  ⍝ The shape is either
         0=⍴⍵:⍬                             ⍝ An empty shape
         {ConstInt(Int32Type)⍵ 0}¨⍵       ⍝ Or has LLVM Integers
     }⍴v                                  ⍝ Based on the shape of v
     s←(Int32Type arrayp'shape')s        ⍝ Shape array pointer
     r←ConstInt(Int16Type)(⊃⍴⍴v)0      ⍝ Rank is constant; from v not d
     sz←ConstInt(Int64Type)(⊃⍴,v)0     ⍝ Size of d is length of v
     t←ConstInt(Int8Type)(2+isf)0       ⍝ Type is 2 → Int; 3 → Float
     a←ConstStruct(r sz t s d)5 0       ⍝ Build array value
     g←AddGlobal ⍺ ArrayTypeV vs          ⍝ Create global place holder
     g⊣SetInitializer g a                 ⍝ Initialize global with array value
 }