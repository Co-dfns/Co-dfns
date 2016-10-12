:Namespace indexof

S←':Namespace' 'Run←{⍺⍳⍵}' ':EndNamespace'

'01'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍬)
'02'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(1)
'03'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍳5)
'04'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳5)(⍬)
'05'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳5)(0)
'06'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳5)(1)
'07'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳5)(2)
'08'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳5)(⍳5)
'09'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳5)(⌽⍳5)
'10'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⌽⍳5)(⍳5)
'11'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⌽⍳5)(⌽⍳5)
'12'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⌽⍳5)(5 5⍴⍳5)
'13'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⌽⍳5)(5 5 5⍴⍳5)
'14'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳2)(2)
'15'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳2)(⍳5)
'16'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳2)(⌽⍳5)
'17'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⌽⍳2)(⍳5)
'18'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⌽⍳2)(⌽⍳5)
'19'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⌽⍳2)(5 5⍴⍳5)
'20'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(⌽⍳2)(5 5 5⍴⍳5)
'21'('indexof' S 'Run' #.util.GEN∆T2 ⎕THIS)(?1024⍴2*19)(?1024⍴2*19)


:EndNamespace

