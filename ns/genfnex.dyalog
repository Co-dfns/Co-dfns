GenFnEx←{mod fr bldr env0←⍺ ⋄ node←⍵
     gnf←{GetNamedFunction mod ⍵}           ⍝ Convenience function
     garg←{0=⍵:⍬ ⋄ GetParam ⍺ ⍵}            ⍝ Fn to get a function parameter
     fn←gnf⊃'name'Prop⊃k←1 Kids ⍵           ⍝ Grab function (pre-declared)
     0=fn:'MISSING FN'⎕SIGNAL 99            ⍝ Sanity check
     fd←-(CountParams fn)-3                 ⍝ Callee depth
     cd←(CountParams fr)-3                  ⍝ Caller depth
     env←fd↑(⊃env0),fr garg¨3+⍳cd           ⍝ Environments needed for fn
     1=≢k:fn env                            ⍝ Single variable reference
     each←gnf'codfns_each'                  ⍝ Otherwise, we heave ¨
     atp←PointerType ArrayTypeV 0           ⍝ Type of each env value
     rt←Int32Type                           ⍝ Op function has unique signature
     args←(3⍴atp),(PointerType atp 0)       ⍝ It has res, lft, rgt, and env[]
     ft←FunctionType rt args(≢args)0        ⍝ Function type for op function
     nf←AddFunction mod'opf'ft              ⍝ Op function to pass to each
     nfb←CreateBuilder                      ⍝ We need to use a new builder here
     bb←AppendBasicBlock nf''               ⍝ Simple basic block is all we need
     _←PositionBuilderAtEnd nfb bb          ⍝ Position our new builder
     enva←GetParam nf 3                     ⍝ The Array **
     args←{
         0=≢env:⍬                           ⍝ Catch the empty case
         {
             idx←GEPI,⍵                     ⍝ i←⍵
             ptr←BuildGEP nfb enva idx 1 '' ⍝ &env[i]
             BuildLoad nfb ptr''            ⍝ env[i]
         }¨⍳≢env
     }⍬
     carg←({GetParam nf ⍵}¨⍳3),args         ⍝ All the args
     res←BuildCall nfb fn carg(≢carg)''     ⍝ Call inside of opf to fn
     _←BuildRet nfb res                     ⍝ Return result of fn from opf
     _←DisposeBuilder nfb                   ⍝ nf definition complete, clean up
     fsz←ConstInt Int32Type(≢env)0          ⍝ Value Ref for ≢env
     ena←BuildArrayAlloca bldr atp fsz''    ⍝ Stack frame to hold frame pointers
     _←{
         idx←GEPI,⍵
         ptr←BuildGEP bldr ena idx 1 ''     ⍝ Pointer to cell in env[]
         BuildStore bldr(env[⍵])ptr         ⍝ Store env[⍵] into frame
     }¨⍳≢env
     each(nf ena)
 }
