:Namespace find

S←':Namespace' 'Run←{⍺⍷⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

'001'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍬)
'002'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(5)
'003'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(⍳5)
'004'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(2 2⍴⍳4)
'005'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)(3 3 3⍴⍳9)
'006'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(1)(⍬)
'007'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(2)(5)
'008'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(3)(⍳5)
'009'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(4)(2 2⍴⍳4)
'010'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(5)(3 3 3⍴⍳9)
'011'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳3)(⍬)
'012'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳3)(0)
'013'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳3)(⍳5)
'014'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳3)(2 2⍴⍳4)
'015'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍳4)(3 3 4⍴1,⍳4)
'016'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳4)(⍬)
'017'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳4)(0)
'018'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳4)(⍳5)
'019'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴⍳4)(2 2⍴⍳4)
'020'('find' S 'Run' #.util.GEN∆T2 ⎕THIS)(2 2⍴3 1 2 3)(3 3 4⍴1,⍳4)

:EndNamespace

