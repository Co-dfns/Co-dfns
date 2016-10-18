:Namespace gradedown

S←':Namespace' 'Run←{⍒⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

'01'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(⍬)
'02'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(,1)
'03'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(⍳3)
'04'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(⌽⍳3)
'05'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(?25⍴20)
'06'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(?100⍴50)
'07'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(10⍴50)
'08'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ⍬)
'09'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ,1)
'10'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ⍳3)
'11'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ⌽⍳3)
'12'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?25⍴20)
'13'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?100⍴50)
'14'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F 10⍴50)
'15'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(?10 10⍴50)
'16'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(?10 10 15⍴50)
'17'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?10 10⍴50)
'18'('gradedown' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?10 10 15⍴50)

:EndNamespace
