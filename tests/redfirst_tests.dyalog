:Namespace redfirst

S1←':Namespace' 'Run←{+⌿⍵}' ':EndNamespace'
S2←':Namespace' 'Run←{×⌿⍵}' ':EndNamespace'
S3←':Namespace' 'Run←{{⍺+⍵}⌿⍵}' ':EndNamespace'
S4←':Namespace' 'Run←{X←0⌷⍵ ⋄ {⍺+⍵}⌿⍵}' ':EndNamespace'

'01'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'02'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'03'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'04'('redfirst' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'05'('redfirst' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'06'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'07'('redfirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'08'('redfirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'09'('redfirst' S3 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'10'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?15⍴2
'11'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?128⍴2
'12'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?100⍴2
'13'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?3 3⍴2
'14'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?10 10⍴2
'15'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?32 32⍴2
'16'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?128 128⍴2
'17'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?100 100⍴2
'18'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?500 500⍴2
'19'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?512 512⍴2
'20'('redfirst' S1 'Run' #.util.GEN∆T1 ⎕THIS) ?512⍴2
'21'('redfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) 1⍴1
'22'('redfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) 1 5⍴⍳5
'23'('redfirst' S4 'Run' #.util.GEN∆T1 ⎕THIS) 1 3 3⍴⍳9

:EndNamespace

