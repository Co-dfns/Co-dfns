:Namespace enlist

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{,⍵}' ':EndNamespace'

'1'('enlist' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍳5
'2'('enlist' S 'Run' #.GEN∆T1 ⎕THIS) #.I 0
'3'('enlist' S 'Run' #.GEN∆T1 ⎕THIS) #.I ⍬
'4'('enlist' S 'Run' #.GEN∆T1 ⎕THIS) ÷2 2⍴1+⍳5

:EndNamespace

