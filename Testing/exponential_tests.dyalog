:Namespace exponential

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯500+?100⍴1000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{*⍵}' ':EndNamespace'

'i'('exponential' S 'Run' #.GEN∆T1 ⎕THIS) I
'f'('exponential' S 'Run' #.GEN∆T1 ⎕THIS) F

:EndNamespace

