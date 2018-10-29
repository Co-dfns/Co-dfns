:Namespace t0018

 f1←{X←5 ⋄ 1:X ⋄ ⍵}
 m17∆small←{V←7
  {V←13 ⋄ f1←{V≡13:f2 ⍵ ⋄ 0} ⋄ f2←{V≡13:1 ⋄ 0} ⋄ ⍵:⊢f1∘⊢⍵ ⋄ f1∘⊢⍵}⍵}

:EndNamespace
