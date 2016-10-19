:Namespace pick

S←':Namespace' 'Run←{⍺⊃⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

'01'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬⍬
'02'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬0
'03'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬(1 2)
'04'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬(2 2⍴1 2 3 4)
'05'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬(2 3 4⍴99)
'06'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) 0(⍳5)
'07'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) 3(2 4 6 8)
'08'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬(F ⍬)
'09'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬(F 0)
'10'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬(F 1 2)
'11'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬(F 2 2⍴1 2 3 4)
'12'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬(F 2 3 4⍴99)
'13'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) 0(F ⍳5)
'14'('pick' S 'Run' #.util.GEN∆T2 ⎕THIS) 3(F 2 4 6 8)

:EndNamespace
