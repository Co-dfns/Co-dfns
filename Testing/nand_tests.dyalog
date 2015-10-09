:Namespace nand

I1←#.I ?10⍴2
I2←#.I ?10⍴2
S←':Namespace' 'Run←{⍺⍲⍵}' ':EndNamespace'

'ii'('nand' S 'Run' #.GEN∆T2 ⎕THIS) I1 I2

:EndNamespace

