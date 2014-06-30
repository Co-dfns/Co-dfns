Fix←{n LK⊃Init CL (VF ⍺)WM GL CP LF AV FE LC DU KL⊃a n←PS TK VI ⍵⊣FI}
Init←{⍵(I 0 0 0)⊣'I'⎕NA'I4 ',⍵,'|Init P P P'}
VI←{~1≡≢⍴⍵:E 11 ⋄ ~∧/1≥≢∘⍴¨⍵:E 11 ⋄ ~∧/∊' '=(⊃0⍴⊂)¨⍵:E 11 ⋄ ⍵}
VF←{~(∧/∊' '=⊃0⍴⊂⍵)∧(1≡≢⍴⍵)∧(1≡≡⍵):E 11 ⋄ ⍵}
clang←'clang -O3 -Wall -pedantic -g -std=c11 -shared -fPIC -L. -o '
CL←{⍵,'.so'⊣⎕SH clang,'"',⍵,'.so" "',⍵,'.ll" -lcodfns -lm'}
LK←{n←⎕NS⍬ ⋄ 0=≢⍺:n ⋄ _←⍵∘{_←n.⍎⍵,'←''',⍵,'''#.Codfns.NA''',⍺,'''' ⋄ 0}¨⊣/⍺ ⋄ n}
WM←{1=⊃r e←PrintModuleToFile ⍵ (⍺,'.ll') 1:(ErrorMessage⊃err)E 99 ⋄ ⍺}
NA←{_←'f'⎕NA'I4 ',⍵⍵,'|',⍺⍺,' P P P' ⋄ 0≠⊃e o←EA⍬:E e ⋄ 0≠⊃e w←AP ⍵:E e 
  0≠e←f o 0 w:E e ⋄ z←#.Codfns.ConvertArray o ⋄ _←#.Codfns.array_free o
  _←#.Codfns.free o ⋄ z}
EA←{#.Codfns.ffi_make_array_double 1 0 0 ⍬ ⍬}
AP←{d←#.Codfns.ffi_make_array_double ⋄ i←#.Codfns.ffi_make_array_int
  1 3∨.=10|⎕DR ⍵:i 1(≢⍴⍵)(≢,⍵)(⍴⍵)(,⍵) ⋄ 5∨.=10|⎕DR ⍵:d 1(≢⍴⍵)(≢,⍵)(⍴⍵)(,⍵)
  E 99}

