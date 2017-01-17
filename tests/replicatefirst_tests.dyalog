:Namespace replicatefirst

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺⌿⍵}' ':EndNamespace'

'01'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)                (⍬)
'02'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0)              (5)
'03'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1)              (5)
'04'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 1)            (5 5)
'05'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 0)            (5 5)
'06'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 0)            (5 5)
'07'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 1)            (5 5)
'08'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 1 0 1 0)      (⍳5)
'09'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 1 0 2 0 3 1)  (⍳7)
'10'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 1 0 ¯2 0 3 1) (⍳7)
'11'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 1 0 ¯2 0 3 1) (7)
'12'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0)              (⍳3)
'13'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1)              (⍳3)
'14'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 3)              (⍳3)
'15'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 1 0 ¯2 0 3 1) (7 5⍴⍳35)
'16'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(0 1 0 1 1 1 0)    (7 5⍴⍳35)
'17'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(0 1 0 1 1 1 0)    (5)
'18'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(32⍴0 1 0 1 1 1 0) (⍳32)
'19'('replicatefirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(14⍴0 1 0 1 1 1 0) (⍳14)


:EndNamespace
