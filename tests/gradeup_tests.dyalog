:Namespace gradeup

S←':Namespace' 'Run←{⍋⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

'01'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(⍬)
'02'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(,1)
'03'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(⍳3)
'04'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(⌽⍳3)
'05'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(?25⍴20)
'06'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(?100⍴50)
'07'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(10⍴50)
'08'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ⍬)
'09'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ,1)
'10'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ⍳3)
'11'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ⌽⍳3)
'12'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?25⍴20)
'13'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?100⍴50)
'14'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F 10⍴50)
'15'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(?10 10⍴50)
'16'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(?10 10 15⍴50)
'17'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?10 10⍴50)
'18'('gradeup' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?10 10 15⍴50)

:EndNamespace
