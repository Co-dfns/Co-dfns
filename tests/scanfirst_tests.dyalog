:Namespace scanfirst

S1←':Namespace' 'Run←{+⍀⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{×⍀⍵}' ':EndNamespace'
S3←':Namespace' 'Run←{{⍺+⍵}⍀⍵}' ':EndNamespace'
S4←':Namespace' 'Run←{<⍀⍵}' ':EndNamespace'

'01'('scanfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'02'('scanfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'03'('scanfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'04'('scanfirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'05'('scanfirst' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'06'('scanfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'07'('scanfirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'08'('scanfirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'09'('scanfirst' S2 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'10'('scanfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) (2*18)⍴2 0 0 0 0
'11'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) (10 2)⍴1
'12'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) (10 2)⍴5
'13'('scanfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) (10 2)⍴1
'14'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) (10 2)⍴1 0
'15'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) (10 2)⍴5 0
'16'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'17'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'18'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'19'('scanfirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) 0 3⍴⍳9
'20'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) 0 3⍴⍳9
'21'('scanfirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) 1 3⍴⍳9
'22'('scanfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) 1 3⍴⍳9

:EndNamespace
