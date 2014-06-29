 GenFuncType←{
     typ←PointerType ArrayTypeV 0         ⍝ All arguments are array pointers
     ret←Int32Type ⋄ arg←((3+⍵)⍴typ)      ⍝ Return type and arg type vector
     FunctionType ret arg(≢arg)0        ⍝ Return the function type
 }
