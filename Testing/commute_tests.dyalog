:Namespace commute

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'Run←{⍺-⍨⍵}' 'Rm←{-⍨⍵}' ':EndNamespace'

'ii'('commute' S 'Run' #.util.GEN∆T2 ⎕THIS) I I
'ff'('commute' S 'Run' #.util.GEN∆T2 ⎕THIS) F F
'if'('commute' S 'Run' #.util.GEN∆T2 ⎕THIS) I F
'fi'('commute' S 'Run' #.util.GEN∆T2 ⎕THIS) F I
'i'('commute' S 'Rm' #.util.GEN∆T1 ⎕THIS) I
'f'('commute' S 'Rm' #.util.GEN∆T1 ⎕THIS) F

:EndNamespace

