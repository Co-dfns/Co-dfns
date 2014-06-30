ModToNS←{
     ⎕NS ⍬                                 ⍝ Create an Empty Namespace
     jc←1 ⍵ 0 1                           ⍝ Params: JIT Ov, Mod, OptLevel, Err Ov
     jc←CreateJITCompilerForModule jc     ⍝ Make JIT compiler
     0≠⊃jc:(ErrorMessage⊃⌽jc)⎕SIGNAL 99  ⍝ Error handling, C style
     ee←1⊃jc                              ⍝ Extract exec engine on success
     syserr←{'FFI ERROR'⎕SIGNAL 99}
     fn←{                                 ⍝ Op to build ns functions
         0≠⊃zp←ffi_make_array 1,4⍴0:syserr ⍬ ⍝ Temporary result array
         lp←(≢⍴⍺)(≢,⍺)(⍴⍺)(,⍺)              ⍝ Fields of left argument
         0≠⊃lp←ffi_make_array 1,lp:syserr ⍬  ⍝ Array to match left argument
         rp←(≢⍴⍵)(≢,⍵)(⍴⍵)(,⍵)              ⍝ Fields of right argument
         0≠⊃rp←ffi_make_array 1,rp:syserr ⍬  ⍝ Array to match right argument
         args←1⊃¨zp lp rp                   ⍝ Pass only the res, left and right args
         z←RunFunction ⍺⍺ ⍵⍵ 3 args         ⍝ Eval function in module
         z←GenericValueToInt z 1            ⍝ Get something we can use
         0≠z:⎕SIGNAL z                      ⍝ Signal an error if there is one
         res←ConvertArray⊃args             ⍝ Convert result array
         _←array_free¨args                  ⍝ Free up the arrays
         _←free¨args                        ⍝ Free up the array headers
         res⊣DisposeGenericValue z          ⍝ Clean return value and return
     }
     fp←{                                 ⍝ Fn to get function pointer
         c fpv←FindFunction ee ⍵ 1          ⍝ Get function from LLVM Module
         0=c:fpv                            ⍝ Function pointer on success
         'FUNCTION NOT FOUND'⎕SIGNAL 99     ⍝ System error on failure
     }
     addf←{                               ⍝ Fn to insert func into namespace
         ∧/' '=⍵:0                          ⍝ No name is no-op
         f←ee fn(fp ⍵)                     ⍝ Get function
         0⊣⍎'Ns.',⍵,'←f ⋄ 0'                ⍝ Store function using do oper trick
     }
     ns⊣addf¨(2=1⌷⍉⍺)/0⌷⍉⍺                ⍝ Add all functions
}

