 GenPrimEquiv←{
     ft←GenFuncType 0                 ⍝ Primitive function type
     fr←AddFunction ⍺⍺(⊃⍵)ft          ⍝ Declare equivalent
     bl←CreateBuilder                 ⍝ New builder
     bb←AppendBasicBlock fr''         ⍝ Single basic block
     _←PositionBuilderAtEnd bl bb     ⍝ Sync the builder and basic block
     pr←GetNamedFunction ⍺⍺ ⍺         ⍝ Get the name of the primitive
     0=pr:'MISSING PRIM FN'⎕SIGNAL 99 ⍝ Sanity Check
     ar←{GetParam fr ⍵}¨⍳3            ⍝ Get the arguments
     rs←BuildCall bl pr ar 3 ''       ⍝ Make the call to the primitive
     _←BuildRet bl rs                 ⍝ Return the error code of primitive
     1=≢⍵:fr                          ⍝ If there is only one name then done
     fr⊣⍺⍺{AddAlias ⍺ ft fr ⍵}¨1↓⍵    ⍝ Otherwise alias the other names
 }