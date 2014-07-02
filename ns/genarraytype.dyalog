GenArrayType←{
     D←PointerType(Int8Type)0           ⍝ Data is void *
     S←PointerType(Int32Type)0          ⍝ Shape is uint32_t *
     lt←(Int16Type)(Int64Type)(Int8Type)  ⍝ Rank, Size, and Type
     lt,←S D                              ⍝ with Shape and Data
     ctx←GetGlobalContext                 ⍝ Context for the type
     tp←StructCreateNamed ctx'Array'     ⍝ Initial named structure
     tp⊣StructSetBody tp lt 5 0           ⍝ Set the structure body
 }
