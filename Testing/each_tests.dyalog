:Namespace minus

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'R1←{⍺-¨⍵}' 'R2←{⍺{⍺-⍵}¨⍵}' ':EndNamespace'

'1ii'('each' S 'R1' #.GEN∆T2 ⎕THIS) I I
'1ff'('each' S 'R1' #.GEN∆T2 ⎕THIS) F F
'1if'('each' S 'R1' #.GEN∆T2 ⎕THIS) I F
'1fi'('each' S 'R1' #.GEN∆T2 ⎕THIS) F I
'2ii'('each' S 'R2' #.GEN∆T2 ⎕THIS) I I
'2ff'('each' S 'R2' #.GEN∆T2 ⎕THIS) F F
'2if'('each' S 'R2' #.GEN∆T2 ⎕THIS) I F
'2fi'('each' S 'R2' #.GEN∆T2 ⎕THIS) F I

:EndNamespace

