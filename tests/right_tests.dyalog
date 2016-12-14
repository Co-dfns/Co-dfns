:Namespace right

S←':Namespace' 'Run←{⍺⊢⍵}' ':EndNamespace'
I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

'01'('right' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(0)
'02'('right' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(⍬)
'03'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (I32 ⍳5)(⍬)
'04'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (I16 ⍳5)(⍬)
'05'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (I8 ⍳5)(⍬)
'06'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (I32 2 3 4⍴⍳5)(⍬)
'07'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (I16 2 3 4⍴⍳5)(⍬)
'08'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (I8 2 3 4⍴⍳5)(⍬)
'09'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (2 3 4⍴0 1 1)(⍬)
'10'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (4⍴0 1 1)(⍬)
'11'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (24⍴0 1 1)(⍬)
'12'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(I32 ⍳5)
'14'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(I16 ⍳5)
'15'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(I8 ⍳5)
'16'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(I32 2 3 4⍴⍳5)
'17'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(I16 2 3 4⍴⍳5)
'18'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(I8 2 3 4⍴⍳5)
'19'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(2 3 4⍴0 1 1)
'20'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(4⍴0 1 1)
'21'('right' S 'Run' #.util.GEN∆T2 ⎕THIS) (⍬)(24⍴0 1 1)

:EndNamespace

