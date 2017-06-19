:Namespace laminate

S1←':Namespace' 'Run←{⍺,[0.5]⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{⍺,[0]⍵}' ':EndNamespace'
S3←':Namespace' 'Run←{⍺,[1]⍵}' ':EndNamespace'
S4←':Namespace' 'Run←{⍺,[2]⍵}' ':EndNamespace'
S5←':Namespace' 'Run←{⍺,[¯0.5]⍵}' ':EndNamespace'

'01'('laminate' S1 'Run' #.util.GEN∆T2 ⎕THIS)(⍳5)       (⍳5)
'02'('laminate' S1 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 2⍴⍳8) (2 2 2⍴⍳8)
'03'('laminate' S1 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳8)   (2 2⍴⍳8)
'04'('laminate' S2 'Run' #.util.GEN∆T2 ⎕THIS)(7)        (8 8 8⍴⍳8)
'05'('laminate' S3 'Run' #.util.GEN∆T2 ⎕THIS)(7)        (8 8 8⍴⍳8)
'06'('laminate' S4 'Run' #.util.GEN∆T2 ⎕THIS)(7)        (8 8 8⍴⍳8)
'07'('laminate' S2 'Run' #.util.GEN∆T2 ⎕THIS)(8 8 8⍴⍳8) (7)
'08'('laminate' S3 'Run' #.util.GEN∆T2 ⎕THIS)(8 8 8⍴⍳8) (7)
'09'('laminate' S4 'Run' #.util.GEN∆T2 ⎕THIS)(8 8 8⍴⍳8) (7)
'10'('laminate' S5 'Run' #.util.GEN∆T2 ⎕THIS)(⍳5)       (⍳5)
'11'('laminate' S5 'Run' #.util.GEN∆T2 ⎕THIS)(2 2 2⍴⍳8) (2 2 2⍴⍳8)
'12'('laminate' S5 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳8)   (2 2⍴⍳8)
'13'('laminate' S2 'Run' #.util.GEN∆T2 ⎕THIS)(⍳8)       (8 8⍴⍳8)
'14'('laminate' S3 'Run' #.util.GEN∆T2 ⎕THIS)(⍳8)       (8 8⍴⍳8)
'15'('laminate' S2 'Run' #.util.GEN∆T2 ⎕THIS)(8 8⍴⍳8) (⍳8)
'16'('laminate' S3 'Run' #.util.GEN∆T2 ⎕THIS)(8 8⍴⍳8) (⍳8)


:EndNamespace