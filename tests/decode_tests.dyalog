:Namespace decode

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺⊥⍵}' ':EndNamespace'

'01'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬           ⍬
'02'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (0 0⍴0)     ⍬
'03'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) ⍬           (0 0⍴1)
'04'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5 5⍴0)     (5 0⍴1)
'05'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5 0⍴0)     (0 5⍴1)
'06'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (0 5⍴0)     (5 5⍴1)
'07'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (8⍴2)       ((8⍴2)⊤⍳30)
'08'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5 4 3)     (5 4 3⊤5 6⍳30)
'09'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (3 3⍴5 4 3) ((3 3⍴5 4 3)⊤5 6⍳30)
'10'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (8⍴2)       (1 3⍴⍳10)
'11'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) 2           ((8⍴2)⊤⍳30)
'12'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5 1⍴2)     ((8⍴2)⊤⍳30)
'13'('decode' S 'Run' #.util.GEN∆T2 ⎕THIS) (5 0 4)     (0⍪⍨0⍪⍨⍉⍪⍳5)

:EndNamespace
