:Namespace t0021

 f1←{X←2 ⋄ Y←3
  G←{⍺+X+⍵} ⋄ F←{Y+Y G ⍵}
  H←5∘G∘(6∘+)∘F
  H H ⍵
 }

:EndNamespace
