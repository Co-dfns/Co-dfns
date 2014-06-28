 GenArrDec←{
     ⍺{                                   ⍝ Fn to declare new array
         0≠g←GetNamedGlobal ⍺ ⍵:g           ⍝ Do nothing if already declared
         r←ConstInt(Int16Type)0 0         ⍝ Rank ← 0
         sz←ConstInt(Int64Type)0 0        ⍝ Size ← 0
         t←ConstInt(Int8Type)2 0          ⍝ Type ← 2
         st←PointerType Int32Type 0         ⍝ Type of the shape field
         dt←PointerType Int8Type 0          ⍝ Type of the data field
         s←ConstPointerNull st              ⍝ Shape ← ⍬
         d←ConstPointerNull dt              ⍝ Data ← ⍬
         a←ConstStruct(r sz t s d)5 0     ⍝ Build empty structure
         g←AddGlobal ⍺ ArrayTypeV ⍵         ⍝ Add the Global
         g⊣SetInitializer g a               ⍝ Set the initial empty value
     }¨⍵
 }