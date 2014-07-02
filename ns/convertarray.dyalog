ConvertArray←{
     s←ffi_get_size ⍵                     ⍝ Get the number of data elements
     t←ffi_get_type ⍵                     ⍝ Type of data
     d←{
         t=2:ffi_get_data_int s ⍵           ⍝ Integer type
         ffi_get_data_float s ⍵             ⍝ Float type
     }⍵
     r←ffi_get_rank ⍵                     ⍝ Get the number of shape elements
     p←ffi_get_shape r ⍵                  ⍝ Get the shapes
     p⍴d                                  ⍝ Reshape based on shape
}

