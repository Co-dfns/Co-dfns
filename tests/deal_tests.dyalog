:Namespace deal

S←':Namespace' 'Run←{⍺?⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

'01'('deal' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(0)
'02'('deal' S 'Run' #.util.GEN∆T2 ⎕THIS)(0)(5)

:EndNamespace

