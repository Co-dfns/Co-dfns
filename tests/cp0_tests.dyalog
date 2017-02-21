:Namespace cp0

S1←':Namespace' 'Run←{X←5 ⋄ FN←{X×⍺+⍵} ⋄ FN/5 FN 3 FN 7}' ':EndNamespace'
S2←':Namespace' 'Run←{X←5 ⋄ FN←{X×⍵} ⋄ FN FN 7}' ':EndNamespace'
S3←':Namespace' 'Run←{X←5 ⋄ FN←{X×X} ⋄ FN FN 7}' ':EndNamespace'

'01'('cp0' S1 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('cp0' S2 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'03'('cp0' S3 'Run' #.util.GEN∆T1 ⎕THIS) ⍬

:EndNamespace
