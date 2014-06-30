Fix←{n LK Init CL (VF ⍺)WM GL CP LF AV FE LC DU KL⊃a n←PS TK VI ⍵⊣FI}
Init←{⍵}
VI←{~1≡≢⍴⍵:E 11 ⋄ ~∧/1≥≢∘⍴¨⍵:E 11 ⋄ ~∧/∊' '=(⊃0⍴⊂)¨⍵:E 11 ⋄ ⍵}
VF←{~(∧/∊' '=⊃0⍴⊂⍵)∧(1≡≢⍴⍵)∧(1≡≡⍵):E 11 ⋄ ⍵}
clang←'clang -O3 -Wall -pedantic -g -std=c11 -shared -fPIC -L. -o '
CL←{⍵,'.so'⊣⎕SH clang,'"',⍵,'.so" "',⍵,'.ll" -lcodfns -lm'}
LK←{⎕NS⍬}
WM←{1=⊃r e←PrintModuleToFile ⍵ (⍺,'.ll') 1:(ErrorMessage⊃err)E 99 ⋄ ⍺}

