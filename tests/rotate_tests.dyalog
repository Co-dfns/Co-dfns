:Namespace rotate

S←':Namespace' 'Run←{⍺⌽⍵}' ':EndNamespace'
R←':Namespace' 'Run←{7⌽⍵}' ':EndNamespace'
T←':Namespace' 'Run←{¯1⌽⍵}' ':EndNamespace'
U←':Namespace' 'Run←{X←0⌷⍺ ⋄ Y←0⌷⍵ ⋄ X⌽Y}' ':EndNamespace'

'01'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         ⍬
'02'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         0
'03'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (⍳5)
'04'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (2 3 4⍴⍳5)
'05'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (17⍴0 1 1 0 0 1 1 1 1 0 0)
'06'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (0 1 1 0 0 1 1)
'07'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
'08'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) 1          (0 1 1 0 0 1 1)
'09'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) 7          (17⍴0 1 1 0 0 1 1 1 1 0 0)
'10'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) 7          (17⍴⍳17)
'11'('rotate' R 'Run' #.util.GEN∆T1 ⎕THIS)            (17⍴⍳17)
'12'('rotate' T 'Run' #.util.GEN∆T1 ⎕THIS)            (2 3 4⍴⍳5)
'13'('rotate' T 'Run' #.util.GEN∆T1 ⎕THIS)            (⍳5)
'14'('rotate' T 'Run' #.util.GEN∆T1 ⎕THIS)            0
'15'('rotate' T 'Run' #.util.GEN∆T1 ⎕THIS)            (17⍴0 1 1 0 0 1 1 1 1 0 0)
'16'('rotate' T 'Run' #.util.GEN∆T1 ⎕THIS)            (0 1 1 0 0 1 1)
'17'('rotate' T 'Run' #.util.GEN∆T1 ⎕THIS)            (2 3 4⍴0 1 1 0 0 1 1 1 1 0 0)
'18'('rotate' R 'Run' #.util.GEN∆T1 ⎕THIS)            (17⍴0 1 1 0 0 1 1 1 1 0 0)
'19'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (32 32⍴0 1 1 0 0 1 1 1 1 0 0)
'20'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (64 20⍴0 1 1 0 0 1 1 1 1 0 0)
'21'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (?15 15⍴2)
'22'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (?80 80⍴2)
'23'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (?800 800⍴2)
'24'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (?90 90⍴2)
'25'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (?8100⍴2)
'26'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) ¯1         (?8133⍴2)
'27'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍳5)       (5 7⍴⍳35)
'28'('rotate' S 'Run' #.util.GEN∆T2 ⎕THIS) (2 3⍴⍳6)   (2 3 5⍴⍳30)
'29'('rotate' U 'Run' #.util.GEN∆T2 ⎕THIS) (1 2 3⍴⍳6) (1 2 3 5⍴⍳30)
'30'('rotate' U 'Run' #.util.GEN∆T2 ⎕THIS) (1 6⍴⍳6)   (1 6 5⍴⍳30)

:EndNamespace

