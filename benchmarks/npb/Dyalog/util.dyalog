:Namespace UTIL
    ⎕IO ⎕ML ⎕WX ⎕RL ⎕PP←0 0 3 2147334206 20

 RandI←{
     V←2*24 ⋄ R←⍺
     Mul←{(2*46)|V⊥(V|A+.×B),[¯0.5](0⌷A←⌽V V⊤⍺)×1⌷B←V V⊤⍵}
     R←1↓R⊣({⍵ Mul ⍵⊣R,←⍵ Mul R}⍣(⌈2⍟⍵))5*13
     R←⍵↑R⊣R,←(5*13)Mul⊢/R
     (⊢/R),⊂R×2*¯46
 }

:EndNamespace 
