:Namespace UTIL
⍝ === VARIABLES ===

Seed←314159265


⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX ⎕RL ⎕PP←0 0 3 2147334206 20

 RandI←{
     ⍺←⊢ ⋄ V←2*23 ⋄ R←⍬
     Next←{⊢R,←V⊥(V|⍺+.×SV),⍺[0]×1⌷SV←V V⊤⍵}
     Seed←(⌽V V⊤5*13)(Next⍣⍵)⊃⍺ Seed
     R×2*¯46
 }

:EndNamespace 