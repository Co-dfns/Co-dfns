 GenGlobal←{
     0=≢⍵:⍬                               ⍝ Don't do anything if nothing to do
     litp←{                               ⍝ Fn predicate to test if literal
         cls←⊃'class'Prop 1↑⍵               ⍝ Class of Expression
         ct←⊃1 1⌷⍵                          ⍝ Node type of the first child
         ('atomic'≡cls)∧'Number'≡ct         ⍝ Class is atomic; Child type is Number
     }
     litp ⍵:⍬⊣⍺ GenConst ⍵                ⍝ Generate the constants directly
     ∧/' '=nm←⊃'name'Prop 1↑⍵:,⊂⍵         ⍝ No need to declare unnamed expressions
     ,⊂⍵⊣⍺ GenArrDec Split⊃'name'Prop 1↑⍵ ⍝ Declare the array and enqueue
 }