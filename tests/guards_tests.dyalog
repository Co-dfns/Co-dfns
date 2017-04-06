:Namespace guards

S1←':Namespace' 'Run←{⍵: 0 ⋄ 1}' ':EndNamespace'
S2←':Namespace' 'Run←{~⍵: 0 ⋄ 1}' ':EndNamespace'
S3←':Namespace' 'Run←{~⍵∨⍵: 0 ⋄ 1}' ':EndNamespace'

'01'('guards' S1 'Run' #.util.GEN∆T1 ⎕THIS) 0 
'02'('guards' S1 'Run' #.util.GEN∆T1 ⎕THIS) 1
'03'('guards' S2 'Run' #.util.GEN∆T1 ⎕THIS) 0 
'04'('guards' S2 'Run' #.util.GEN∆T1 ⎕THIS) 1
'05'('guards' S2 'Run' #.util.GEN∆T1 ⎕THIS) 0 
'06'('guards' S2 'Run' #.util.GEN∆T1 ⎕THIS) 1


:EndNamespace
