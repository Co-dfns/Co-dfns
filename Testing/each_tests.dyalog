:Namespace each

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S←':Namespace' 'R1←{⍺-¨⍵}' 'R2←{⍺{⍺-⍵}¨⍵}' 'R3←{{÷⍵}¨⍵}' ':EndNamespace'

'1ii'('each' S 'R1' #.GEN∆T2 ⎕THIS) I I
'1ff'('each' S 'R1' #.GEN∆T2 ⎕THIS) F F
'1if'('each' S 'R1' #.GEN∆T2 ⎕THIS) I F
'1fi'('each' S 'R1' #.GEN∆T2 ⎕THIS) F I
'2ffs'('each' S 'R2' #.GEN∆T2 ⎕THIS) 5.5 3.1
'2ii'('each' S 'R2' #.GEN∆T2 ⎕THIS) I I
'2ff'('each' S 'R2' #.GEN∆T2 ⎕THIS) F F
'2if'('each' S 'R2' #.GEN∆T2 ⎕THIS) I F
'2fi'('each' S 'R2' #.GEN∆T2 ⎕THIS) F I
'3i'('each' S 'R3' #.GEN∆T2 ⎕THIS) I I

:EndNamespace

