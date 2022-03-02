:Namespace t0028

id←{⍵}
add←{⍺+⍵}
and←{⍺∧⍵}
ncl←{⊂⍵}
ncla←{⊂[⍺]⍵}
strand←{⍵ 1 ⍵ (1 (⍵ 2) 3) ⍵ (⍵ ⍵) 5 6}
strand2←{⍵}
strand3←{⍵ ⍵}
mix←{↑⍵}
drp←{⍺↓⍵}
rnk←{⊂⍤¯1⊢⍵}
red1←{⊢/⍵}
red2←{⊣/⍵}
red3←{+/⍵}
cat←{⍺,⍵}
nst←{⊆⍵}
reshape←{⍺⍴⍵}
get←{X←2⍴⊂⍺ ⋄ X,X[0]←⊂⍵}

:EndNamespace