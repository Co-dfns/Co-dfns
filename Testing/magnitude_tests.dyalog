:Namespace magnitude

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000

S←':Namespace' 'Run←{|⍵}' ':EndNamespace'

'i'('magnitude' S 'Run' #.util.GEN∆T1 ⎕THIS) I
'f'('magnitude' S 'Run' #.util.GEN∆T1 ⎕THIS) F

:EndNamespace

