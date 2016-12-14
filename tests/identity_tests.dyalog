:Namespace identity

S←':Namespace' 'Run←{⊢⍵}' ':EndNamespace'
I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

'01'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'02'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 0
'03'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) I32 ⍳5
'04'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) I16 ⍳5
'05'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) I8 ⍳5
'06'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) I32 2 3 4⍴⍳5
'07'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) I16 2 3 4⍴⍳5
'08'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) I8 2 3 4⍴⍳5
'09'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 2 3 4⍴0 1 1
'10'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 4⍴0 1 1
'11'('identity' S 'Run' #.util.GEN∆T1 ⎕THIS) 24⍴0 1 1

:EndNamespace

