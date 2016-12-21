:Namespace split

S←':Namespace' 'Run←{↓⍵}' ':EndNamespace'
I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

'01'('split' S 'Run' #.util.GEN∆T1 ⎕THIS) I32 7
'02'('split' S 'Run' #.util.GEN∆T1 ⎕THIS) I16 7
'03'('split' S 'Run' #.util.GEN∆T1 ⎕THIS) I8 7
'04'('split' S 'Run' #.util.GEN∆T1 ⎕THIS) 7.5


:EndNamespace

