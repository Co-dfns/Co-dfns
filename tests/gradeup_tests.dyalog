:Namespace gradeup

S←':Namespace' 'Run←{⍋⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

'01'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(⍬)
'02'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(,1)
'03'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(⍳3)
'04'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(⌽⍳3)
'05'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(?25⍴20)
'06'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(?100⍴50)

:EndNamespace

