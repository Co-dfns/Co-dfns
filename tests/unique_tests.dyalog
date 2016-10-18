:Namespace unique

S←':Namespace' 'Run←{∪⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

'01'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(⍬)
'02'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(1)
'03'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(⍳5)
'04'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(10⍴5)
'05'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(25⍴⍳10)
'06'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(?50⍴10)
'07'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ⍬)
'08'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(F 1)
'09'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ⍳5)
'10'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(F 10⍴5)
'11'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(F 25⍴⍳10)
'12'('unique' S 'Run' #.util.GEN∆T1 ⎕THIS)(F ?50⍴10)


:EndNamespace

