:Namespace encode

S←':Namespace' 'Run←{⍺⊤⍵}' ':EndNamespace'

'01'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬           ⍬
'02'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬           (⍳5)
'03'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍳5)        ⍬
'04'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5 2⍴⍳5)    (3 0⍴⍬)
'05'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (0 2⍴⍬)     (3 5⍴⍬)
'06'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) 0           (3 5⍴⍳15)
'07'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (,0)        (3 5⍴⍳15)
'08'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) 5           (⍳30)
'09'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (,5)        (⍳30)
'10'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5⍴0)       (⍳30)
'11'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5⍴5)       (⍳30)
'12'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5⍴2)       (⍳30)
'13'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (2 3 4)     (⍳30)
'14'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (0 3 4)     (⍳100)
'15'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (3 0 4)     (⍳100)
'16'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (3 4 0)     (⍳100)
'17'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (3 3⍴2)     (⍳10)
'18'('encode' S 'Run' #.util.GEN∆T2 ⎕THIS) (3 3⍴2 3 4) (⍳30)

:EndNamespace
