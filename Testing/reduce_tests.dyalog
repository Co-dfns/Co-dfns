:Namespace reduce

S1←':Namespace' 'Run←{+/⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{×/⍵}'  ':EndNamespace'
S3←':Namespace' 'Run←{{⍺+⍵}/⍵}' ':EndNamespace'
S4←':Namespace' 'Run←{≠/⍵}' ':EndNamespace'
S5←':Namespace' 'Run←{{⍺≠⍵}/⍵}' ':EndNamespace'
S6←':Namespace' 'Run←{∧/⍵}' ':EndNamespace'

'01'('reduce' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'02'('reduce' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'03'('reduce' S1 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'04'('reduce' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'05'('reduce' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'06'('reduce' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'07'('reduce' S3 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'08'('reduce' S3 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'09'('reduce' S3 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'10'('reduce' S4 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'11'('reduce' S5 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'12'('reduce' S4 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'13'('reduce' S4 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'14'('reduce' S4 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'15'('reduce' S1 'Run' #.util.GEN∆T1 ⎕THIS) 10⍴0 1
'16'('reduce' S4 'Run' #.util.GEN∆T1 ⎕THIS) 10 5 0⍴0 1
'17'('reduce' S4 'Run' #.util.GEN∆T1 ⎕THIS) 10 0 5⍴0 1
'18'('reduce' S6 'Run' #.util.GEN∆T1 ⎕THIS) 10 5 0⍴0 1
'19'('reduce' S6 'Run' #.util.GEN∆T1 ⎕THIS) 10 0 5⍴0 1
'20'('reduce' S5 'Run' #.util.GEN∆T1 ⎕THIS) 10⍴0 1
'21'('reduce' S1 'Run' #.util.GEN∆T1 ⎕THIS) 10 15⍴0 1
'22'('reduce' S5 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5

:EndNamespace

