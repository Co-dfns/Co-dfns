:Namespace twostatements

S←':Namespace' 'Run←{x←⍳⍵ ⋄ ⊢⍵}' ':EndNamespace'

'1' ('twostatements' S 'Run' #.util.GEN∆T2 ⎕THIS) 5 5

:EndNamespace