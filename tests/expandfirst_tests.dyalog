:Namespace expandfirst

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺⍀⍵}' ':EndNamespace'

'01'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(⍬)                   (⍬)
'02'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0)                 (5)
'03'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1)                 (5)
'04'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 1)               (5 5)
'05'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 0 1 1)           (5 5)
'06'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 0 1 0)           (5 5)
'07'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 0 1 1)           (5 5)
'08'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 2 1 2 1)         (⍳5)
'09'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 2 1 3 1 4 2)     (⍳7)
'10'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 4 2 1 ¯2 1 3 1)  (⍳7)
'11'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 1 1 ¯2 0 3 ¯1 2) (7)
'12'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 0 1 2 3)           (⍳3)
'13'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 1 1)             (⍳3)
'14'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 3 2 1)             (⍳3)
'15'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(I 1 4 2 1 ¯2 1 3 1)  (7 5⍴⍳35)
'16'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(1 1 1 ¯2 1 1 3 0 2)  (7 5⍴⍳35)
'17'('expandfirst' S 'Run' #.util.GEN∆T2 ⎕THIS)(0 1 0 1 1 1 0)       (5)

:EndNamespace
