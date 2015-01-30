:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ nl←##.G.nl
  gd←{(⍺⍺),'(',(⊃{⍺,',',⍵}/⍺),');',nl}
:EndNamespace 

