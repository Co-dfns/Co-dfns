ErrorMessage←{
     len←strlen ⍵                         ⍝ Length of C string
     res←cstring len ⍵ len                ⍝ Convert using memcpy
     res⊣DisposeMessage ⍵                 ⍝ Cleanup and return
}

