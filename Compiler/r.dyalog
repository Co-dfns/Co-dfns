:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 
  var←##.G.var ⋄ nl←##.G.nl
  prs←'relp(rslt);',nl
  gb←{'LOCALP*',⍺,'=',⍵,';'}
  grh←{'{',(⊃,/'rslt' 'lft' 'rgt'gb¨⍺(⊂(⊃⊣)var⊢)⍤0 1⍉⍵),prs}
  gd←{(⍺ grh ⍵),(⍺⍺),'(',(⊃{⍺,',',⍵}/⍺),');',nl,'}',nl}
:EndNamespace 

