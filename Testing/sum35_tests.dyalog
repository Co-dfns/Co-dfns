:Namespace sum35

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}16
S←':Namespace' 'Run←{a←⍳⍵ ⋄ +/((0=3|a)∨0=5|a)/a}' ':EndNamespace'

'ii'('sum35' S 'Run' #.util.GEN∆T1 ⎕THIS) I

:EndNamespace

