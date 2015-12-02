:Namespace residue

I1←¯5000+?10⍴10000
I2←¯5000+?10⍴10000
F1←100÷⍨¯5000+?10⍴10000
F2←100÷⍨¯5000+?10⍴10000

S←':Namespace' 'Run←{⍺|⍵}' ':EndNamespace'

'ii'('residue' S 'Run' #.util.GEN∆T2 ⎕THIS) I1 I2
'ff'('residue' S 'Run' #.util.GEN∆T2 ⎕THIS) F1 F2
'if'('residue' S 'Run' #.util.GEN∆T2 ⎕THIS) I1 F2
'fi'('residue' S 'Run' #.util.GEN∆T3 ⎕THIS) F1 I2

:EndNamespace

