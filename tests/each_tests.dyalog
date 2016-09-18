:Namespace each

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
B←?10⍴2
S1	←':Namespace' 'Run←{⍺-¨⍵}'	':EndNamespace'
S2	←':Namespace' 'Run←{⍺{⍺-⍵}¨⍵}'	':EndNamespace'
S3	←':Namespace' 'Run←{{÷⍵}¨⍵}'	':EndNamespace'
S4	←':Namespace' 'Run←{÷¨⍵}'	':EndNamespace'
S5	←':Namespace' 'Run←{×¨⍵}'	':EndNamespace'
S6	←':Namespace' 'Run←{{×⍵}¨⍵}'	':EndNamespace'

'dpii'	('each'	S1 'Run' #.util.GEN∆T2 ⎕THIS) I	I
'dpiis'	('each'	S1 'Run' #.util.GEN∆T2 ⎕THIS) 4	5
'dpff'	('each'	S1 'Run' #.util.GEN∆T2 ⎕THIS) F	F
'dpif'	('each'	S1 'Run' #.util.GEN∆T2 ⎕THIS) I	F
'dpfi'	('each'	S1 'Run' #.util.GEN∆T2 ⎕THIS) F	I
'duffs'	('each'	S2 'Run' #.util.GEN∆T2 ⎕THIS) 5.5	3.1
'duii'	('each'	S2 'Run' #.util.GEN∆T2 ⎕THIS) I	I
'duff'	('each'	S2 'Run' #.util.GEN∆T2 ⎕THIS) F	F
'duif'	('each'	S2 'Run' #.util.GEN∆T2 ⎕THIS) I	F
'dufi'	('each'	S2 'Run' #.util.GEN∆T2 ⎕THIS) F	I
'mui'	('each'	S3 'Run' #.util.GEN∆T2 ⎕THIS) I	I
'muf'	('each'	S3 'Run' #.util.GEN∆T2 ⎕THIS) F	F
'mub'	('each'	S6 'Run' #.util.GEN∆T2 ⎕THIS) B	B
'mpi'	('each'	S4 'Run' #.util.GEN∆T2 ⎕THIS) I	I
'mpf'	('each'	S4 'Run' #.util.GEN∆T2 ⎕THIS) F	F
'mpb'	('each'	S5 'Run' #.util.GEN∆T2 ⎕THIS) B	B


:EndNamespace

