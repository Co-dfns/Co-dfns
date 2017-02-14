:Namespace compose

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
B←?100⍴2
Sm←':Namespace' 'Rm←{×∘-⍵}' ':EndNamespace'
Sd←':Namespace' 'Rd←{⍺×∘-⍵}' ':EndNamespace'
Sl←':Namespace' 'Rl←{5∘×⍵}' ':EndNamespace'
Sr←':Namespace' 'Rr←{(-∘5)⍵}' ':EndNamespace'

'01'('compose' Sm 'Rm' #.util.GEN∆T1 ⎕THIS) I
'02'('compose' Sd 'Rd' #.util.GEN∆T2 ⎕THIS) I I
'03'('compose' Sl 'Rl' #.util.GEN∆T1 ⎕THIS) I
'04'('compose' Sr 'Rr' #.util.GEN∆T1 ⎕THIS) I

:EndNamespace

