:Namespace power

S01←':Namespace' 'Run←{(×⍣⍺)⍵}' ':EndNamespace'
S02←':Namespace' 'Run←{×⍣⍺⊢⍵}' ':EndNamespace'
S03←':Namespace' 'Run←{⍺×⍣5⊢⍵}' ':EndNamespace'
S04←':Namespace' 'Run←{⍺(×⍣5)⍵}' ':EndNamespace'
S05←':Namespace' 'Run←{({×⍵}⍣⍺)⍵}' ':EndNamespace'
S06←':Namespace' 'Run←{{×⍵}⍣⍺⊢⍵}' ':EndNamespace'
S07←':Namespace' 'Run←{⍺{⍺×⍵}⍣5⊢⍵}' ':EndNamespace'
S08←':Namespace' 'Run←{⍺({⍺×⍵}⍣5)⍵}' ':EndNamespace'
S09←':Namespace' 'Run←{○⍣{∨/,100<⍺}⍵}' ':EndNamespace'
S10←':Namespace' 'Run←{○⍣{∨/,100<⍵}⍵}' ':EndNamespace'
S11←':Namespace' 'Run←{⍺×⍣{∨/,100<⍵}⍵}' ':EndNamespace'
S12←':Namespace' 'Run←{⍺×⍣{∨/,100<⍺}⍵}' ':EndNamespace'
S13←':Namespace' 'Run←{{○⍵}⍣{∨/,100<⍵}⍵}' ':EndNamespace'
S14←':Namespace' 'Run←{{○⍵}⍣{∨/,100<⍺}⍵}' ':EndNamespace'
S15←':Namespace' 'Run←{⍺{⍺×⍵}⍣{∨/,100<⍵}⍵}' ':EndNamespace'
S16←':Namespace' 'Run←{⍺{⍺×⍵}⍣{∨/,100<⍺}⍵}' ':EndNamespace'

'01'('power' S01 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'02'('power' S02 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'03'('power' S03 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'04'('power' S04 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'05'('power' S05 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'06'('power' S06 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'07'('power' S07 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'08'('power' S08 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'09'('power' S09 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'10'('power' S10 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'11'('power' S11 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'12'('power' S12 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'13'('power' S13 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'14'('power' S14 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'15'('power' S15 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'16'('power' S16 'Run' #.util.GEN∆T2 ⎕THIS) 3 7
'17'('power' S01 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'18'('power' S02 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'19'('power' S03 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'20'('power' S04 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'21'('power' S05 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'22'('power' S06 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'23'('power' S07 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'24'('power' S08 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'25'('power' S09 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'26'('power' S10 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'27'('power' S11 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'28'('power' S12 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'29'('power' S13 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'30'('power' S14 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'31'('power' S15 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)
'32'('power' S16 'Run' #.util.GEN∆T2 ⎕THIS) 3 (3 3⍴⍳9)

:EndNamespace

