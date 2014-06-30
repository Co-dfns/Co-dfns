Fix←{n MN (VF ⍺)WM GL CP LF AV FE LC DU KL⊃a n←PS TK VI ⍵⊣FI}
VI←{~1≡≢⍴⍵:E 11 ⋄ ~∧/1≥≢∘⍴¨⍵:E 11 ⋄ ~∧/∊' '=(⊃0⍴⊂)¨⍵:E 11 ⋄ ⍵}
VF←{~(∧/∊' '=⊃0⍴⊂⍵)∧(1≡≢⍴⍵)∧(1≡≡⍵):E 11 ⋄ ⍵}
MN←{⎕NS⍬}
WM←{1=⊃r e←PrintModuleToFile ⍵ (⍺,'.ll') 1:(ErrorMessage⊃err)E 99 ⋄ ⍺}

