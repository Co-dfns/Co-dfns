:Namespace each

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
F←100÷⍨?100⍴10000
S1	←':Namespace' 'Run←{⍺-¨⍵}'	':EndNamespace'
S2	←':Namespace' 'Run←{⍺{⍺-⍵}¨⍵}'	':EndNamespace'
S3	←':Namespace' 'Run←{{÷⍵}¨⍵}'	':EndNamespace'
S4	←':Namespace' 'Run←{÷¨⍵}'	':EndNamespace'

'ii'	('eachdp'	S1 'Run' #.util.GEN∆T2 ⎕THIS) I	I
'iis'	('eachdp'	S1 'Run' #.util.GEN∆T2 ⎕THIS) 4	5
'ff'	('eachdp'	S1 'Run' #.util.GEN∆T2 ⎕THIS) F	F
'if'	('eachdp'	S1 'Run' #.util.GEN∆T2 ⎕THIS) I	F
'fi'	('eachdp'	S1 'Run' #.util.GEN∆T2 ⎕THIS) F	I
'ffs'	('eachdu'	S2 'Run' #.util.GEN∆T2 ⎕THIS) 5.5	3.1
'ii'	('eachdu'	S2 'Run' #.util.GEN∆T2 ⎕THIS) I	I
'ff'	('eachdu'	S2 'Run' #.util.GEN∆T2 ⎕THIS) F	F
'if'	('eachdu'	S2 'Run' #.util.GEN∆T2 ⎕THIS) I	F
'fi'	('eachdu'	S2 'Run' #.util.GEN∆T2 ⎕THIS) F	I
'i'	('eachmu'	S3 'Run' #.util.GEN∆T2 ⎕THIS) I	I
'f'	('eachmu'	S3 'Run' #.util.GEN∆T2 ⎕THIS) F	F
'i'	('eachmp'	S4 'Run' #.util.GEN∆T2 ⎕THIS) I	I
'f'	('eachmp'	S4 'Run' #.util.GEN∆T2 ⎕THIS) F	F


:EndNamespace

