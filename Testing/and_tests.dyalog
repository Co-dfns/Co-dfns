:Namespace and

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I1←I ?10⍴2 ⋄ I2←I ?10⍴2
S←':Namespace' 'Run←{⍺∧⍵}' ':EndNamespace'

'ii' ('and' S 'Run' #.util.GEN∆T2 ⎕THIS) I1 I2

:EndNamespace

