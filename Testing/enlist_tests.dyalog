:Namespace enlist

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{∊⍵}' ':EndNamespace'

'1'('enlist' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍳5
'2'('enlist' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'3'('enlist' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'4'('enlist' S 'Run' #.util.GEN∆T1 ⎕THIS) ÷2 2⍴1+⍳5

:EndNamespace

