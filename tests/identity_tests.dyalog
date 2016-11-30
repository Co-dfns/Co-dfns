:Namespace identity

S←':Namespace' 'Run←{⊢⍵}' ':EndNamespace'
I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

⍝[c]'01'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
⍝[c]'02'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) I32 ⍳5
⍝[c]'04'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴⍳5
⍝[c]'05'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴0 1 1

:EndNamespace

