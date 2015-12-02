:Namespace power

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
IP←I 1+?15⍴10 ⋄ IN←I ¯5+?15⍴10
FP←100÷⍨?15⍴1000 ⋄ FN←100÷⍨¯500+?15⍴1000
S←':Namespace' 'Run←{⍺*⍵}' ':EndNamespace'

'ii'('power' S 'Run' #.util.GEN∆T2 ⎕THIS) IP IN
'ff'('power' S 'Run' #.util.GEN∆T2 ⎕THIS) FP FN
'if'('power' S 'Run' #.util.GEN∆T2 ⎕THIS) IP FN
'fi'('power' S 'Run' #.util.GEN∆T2 ⎕THIS) FP IN

:EndNamespace

