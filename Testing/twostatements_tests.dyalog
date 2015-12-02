:Namespace twostatements

S←':Namespace' 'Run←{x←⍳⍵ ⋄ ⊢⍵}' ':EndNamespace'

'1' ('twostatements' S 'Run' #.GEN∆T2 ⎕THIS) 5 5

:EndNamespace