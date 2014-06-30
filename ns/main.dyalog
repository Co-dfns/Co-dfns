Fix←{n LK⊃Init CL (VF ⍺)WM GL CP LF AV FE LC DU KL⊃a n←PS TK VI ⍵⊣FI}
Init←{⍵(I 0 0 0)⊣'I'⎕NA'I4 ',⍵,'|Init P P P'}
VI←{~1≡≢⍴⍵:E 11 ⋄ ~∧/1≥≢∘⍴¨⍵:E 11 ⋄ ~∧/∊' '=(⊃0⍴⊂)¨⍵:E 11 ⋄ ⍵}
VF←{~(∧/∊' '=⊃0⍴⊂⍵)∧(1≡≢⍴⍵)∧(1≡≡⍵):E 11 ⋄ ⍵}
clang←'clang -O3 -Wall -pedantic -g -std=c11 -shared -fPIC -L. -o '
CL←{⍵,'.so'⊣⎕SH clang,'"',⍵,'.so" "',⍵,'.ll" -lcodfns -lm'}
LK←{n←⎕NS⍬ ⋄ 0=≢⍺:n ⋄ _←⍵∘{_←n.⍎⍵,'←''',⍵,''' #.Codfns.NA ''',⍺,'''' ⋄ 0}¨⊣/⍺ ⋄ n}
WM←{1=⊃r e←PrintModuleToFile ⍵ (⍺,'.ll') 1:(ErrorMessage⊃err)E 99 ⋄ ⍺}
NA←{_←'f'⎕NA'I4 ',⍵⍵,'|',⍺⍺,' P P P' ⋄ fmad←#.CoDfns.ffi_make_array_double
  fmai←#.CoDfns.ffi_make_array_into ⋄ o←fmad 1 0 0 ⍬ ⍬ ⋄ 0≠e←f o 0 0:E e
  z⊣#.Codfns.free o⊣#.Codfns.array_free o⊣z←#.Codfns.ConvertArray o}

