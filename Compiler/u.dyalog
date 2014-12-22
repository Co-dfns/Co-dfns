:Namespace U
  (⎕IO ⎕ML ⎕WX)←0 1 3

⍝ Useful utilities
  atrep←{(((~(0⌷⍉⍺)∊⊂⍺⍺)⌿⍺))⍪⍺⍺ ⍵}
  ren←'name'atrep
  opt←{⍵⍵⍀(⍵⍵⌿⍺)⍺⍺(⍵⍵⌿⍵)}
  err←{⍺←⊢ ⋄ ⍺ ⎕SIGNAL ⍵}
  with←↓(⊂⊣),∘⍪⊢

    put←{tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}⍵
      size←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND tie 83 ⋄ 1:rslt←size⊣⎕NUNTIE tie}

    Bind←{0=≢⍵:⍵ ⋄ (i←A⍳⊂'name')≥⍴A←0⌷⍉⊃0 3⌷Ast←⍵:Ast⊣(⊃0 3⌷Ast)⍪←'name'⍺
      Ast⊣((0 3)(i 1)⊃Ast){⍺,⍵,⍨' ' ''⊃⍨0=⍴⍺}←⍺}

    Kids←{((⍺+⊃⍵)=0⌷⍉⍵)⊂[0]⍵
    }

    Prop←{(¯1⌽P∊⊂⍺)/P←(⊂''),,↑⍵[;3]
    }

    Eachk←{(1↑⍵)⍪⊃⍪/(⊂MtAST),(+\(⊃=⊢)0⌷⍉k)(⊂⍺⍺)⌸k←1↓⍵
    }


:EndNamespace 