 ParseFunc←{
     'Function'≢⊃0 1⌷⍵:2 MtAST ⍵          ⍝ Must have a Function node first
     fn←(fm←1=+\(fd←⊃⍵)=d←0⌷⍉⍵)⌿⍵         ⍝ Get the Function node, mask, depths
     en←⍺⍪⍨1,⍨⍪,¨'⍺⍵'                     ⍝ Extend current environment with ⍺ & ⍵
     sd←MtAST en                          ⍝ Seed value
     cn←1 Kids fn                         ⍝ Lines of Function node
     2::2 MtAST ⍵                       ⍝ Handle parse errors
     11::11 MtAST ⍵                       ⍝ by passing them up
     tr en←⊃ParseFnLine/⌽(⊂sd),cn         ⍝ Parse down each line
     0((1↑fn)⍪tr)((~fm)⌿⍵)                ⍝ Newly parsed function, rest of tokens
 }