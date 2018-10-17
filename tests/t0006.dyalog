:Namespace t0006

f1←{X←5+⍵ ⋄ X}
f2←{X←5+⍵ ⋄ Y←X+X ⋄ X←6+⍵ ⋄ Y+X}
f3←{X←⍵ ⋄ f←2∘×⍣X ⋄ X←4+⍳⍵ ⋄ f X}
f4←{X←5+⍵ ⋄ f←{⍺+X+⍵} ⋄ g←X∘f ⋄ X←4 ⋄ g 3+⍵}
f5←{X←5+⍵ ⋄ f←{Y←X+X ⋄ X←3 ⋄ Y×X} ⋄ f ⍵}
f6←{X←5+⍵ ⋄ o←{⍺×Y×⍵} ⋄ f←X∘{Y←3 ⋄ X o ⍵} ⋄ f ⍵+7⊣X←Y←1}
⍝ f7←{go←{⍵+⍺} ⋄ fo←{⍺=⍵} ⋄ ao←{⍺ go ⍺ fo ⍵} ⋄ ⍺ ao ⍵}
⍝ f8←{X←5+⍵ ⋄ g←{X+⍵} ⋄ f←{g ⍵} ⋄ f ⍵}
⍝ f9←{X←5+⍵ ⋄ f←{g←{X+⍵} ⋄ g ⍵} ⋄ f ⍵}
⍝ f10←{f←{f⍣⍵⊢0} ⋄ f 1}
⍝ f11←{X←5+⍵ ⋄ f←{⍺+X+⍵} ⋄ g←X∘f ⋄ h←g∘g ⋄ X←4 ⋄ g 3+⍵}

:EndNamespace
