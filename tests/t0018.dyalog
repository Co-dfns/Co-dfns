:Namespace t0018

 f1←{X←5 ⋄ 1:X ⋄ ⍵}
 f2←{X←5 ⋄ 1:{X}⍵ ⋄ ⍵}
 f3←{f←{g ⍵} ⋄ V←5 ⋄ g←{V} ⋄ f ⍵}
 f4←{f←{⍵:g ⍵ ⋄ ⍵} ⋄ V←5 ⋄ g←{V} ⋄ f ⍵}
 f5←{f←{g ⍵} ⋄ V←5 ⋄ g←{V} ⋄ f∘⊢ ⍵}
 m17∆small←{V←7
  {V←13 ⋄ f1←{V≡13:f2 ⍵ ⋄ 0} ⋄ f2←{V≡13:1 ⋄ 0} ⋄ ⍵:⊢f1∘⊢⍵ ⋄ f1∘⊢⍵}⍵}

:EndNamespace
