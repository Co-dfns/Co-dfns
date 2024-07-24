:Namespace t0012

 X←1

 R1←{⍵: 0 ⋄ 1} ⋄ R2←{~⍵: 0 ⋄ 1} ⋄ R3←{~⍵∨⍵: 0 ⋄ 1}
 R4←{X: 0 ⋄ 1} ⋄ R5←{X←~⍵ ⋄ X:0 ⋄ 1}
 R6←{X←5 ⋄ Y←⍵:Y+X⊣X←3 ⋄ Y+X}

:EndNamespace