 NA←{⍺←⊢ ⋄ fmt←⍺⍺{'I4 ',⍵⍵,'|',(⍺⍺,⍵),' P P P P I'}⍵⍵ ⋄ f←{0=⎕NC'⍺':fm ⍵ ⋄ fd ⍵}
     _←'fm'⎕NA fmt'm' ⋄ _←'fd'⎕NA fmt'd' ⋄ 0≠⊃e o←EA ⍬:E e ⋄ 0≠⊃e w←AP ⍵:E e
     0≠⊃e a←AP ⍺⊣⍬:E e ⋄ 0≠e←⍺ f o a w 0 WithGPU:E e ⋄ t z←ConvertArray o
     _←array_free¨o a w ⋄ _←free¨o a w ⋄ t{0≠⍺:⍵}z}