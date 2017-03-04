:Namespace expand

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺\⍵}' ':EndNamespace'

'01'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)                   (⍬)
'02'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0)                 (5)
'03'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1)                 (5)
'04'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 1)               (5 5)
'05'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 0 1 1)           (5 5)
'06'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 0 1 0)           (5 5)
'07'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 0 1 1)           (5 5)
'08'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 2 1 2 1)         (⍳5)
'09'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 2 1 3 1 4 2)     (⍳7)
'10'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 4 2 1 ¯2 1 3 1)  (⍳7)
'11'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 1 1 ¯2 0 3 ¯1 2) (7)
'12'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 1 2 3)           (⍳3)
'13'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 1 1)             (⍳3)
'14'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 3 2 1)             (⍳3)
'15'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 4 2 1 ¯2 1 3 1)  (5 7⍴⍳35)
'16'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(1 1 1 ¯2 1 1 3 0 2)  (5 7⍴⍳35)
'17'('expand' S 'Run' #.util.GEN∆T2 ⎕THIS)(0 1 0 1 1 1 0)       (5)

:EndNamespace
