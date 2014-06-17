 Fix←{
     _←FFI∆INIT                           ⍝ Initialize FFI; Fix ← Yes
     ~1≡≢⍴⍵:⎕SIGNAL 11                    ⍝ Input is vector?
     ~∧/1≥≢∘⍴¨⍵:⎕SIGNAL 11                ⍝ Elements are vectors?
     ~∧/∊' '=(⊃0⍴⊂)¨⍵:⎕SIGNAL 11          ⍝ Elements are characters?
     ⍺←⊢ ⋄ obj←⍺⊣''                       ⍝ Identify Obj property
     IsFnb obj:⎕SIGNAL 11                 ⍝ Handle Fnb, Fnf, Fne stimuli
     mod nms←Compile ⍵                    ⍝ Get LLVM Module
     ns←nms ModToNS mod                   ⍝ Namespace to return
     ''≡obj:ns                            ⍝ No optional object file output
     ns⊣obj ModToObj mod                  ⍝ Export Mod to object file
 }
