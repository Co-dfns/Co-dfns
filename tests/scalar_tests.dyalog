:Namespace scalar

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}0,¯50+?9⍴100
I2←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}0,¯50+?9⍴100
F←0,¯5+100÷⍨?9⍴1000
F2←0,¯5+100÷⍨?9⍴1000
B←?10⍴2
INT←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}0,?9⍴100
FNT←0,100÷⍨?9⍴1000
IPS←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}2+?10⍴100
FPS←100÷⍨1+?10⍴1000
INZ←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}{10↑(0≠⍵)/⍵}¯50+?100⍴100
FNZ←{10↑(0≠⍵)/⍵}¯5+100÷⍨?100⍴100
BNZ←10⍴1

∇Z←N SCL∆TST∆DYADIC(FN IL IR FL FR BL BR);S
S←':Namespace' ('Run←{⍺',FN,'⍵}') ':EndNamespace'
(∘.,⍨'ifb')(N S 'Run' #.util.GEN∆T2 ⎕THIS)¨IL FL BL∘.{⍺⍵}IR FR BR
Z←0 0⍴⍬
∇

∇Z←N SCL∆TST∆RELATIVE(FN IL IR FL FR BL BR);S
S←':Namespace' ('Run←{⍺',FN,'⍵}') ':EndNamespace'
(∘.,⍨'ifb')(N S 'Run' 1e¯7 #.util.GEN∆T3 ⎕THIS)¨IL FL BL∘.{⍺⍵}IR FR BR
Z←0 0⍴⍬
∇

∇Z←N SCL∆TST∆MONADIC(FN I F B);S
S←':Namespace' ('Run←{',FN,'⍵}')':EndNamespace'
'ifb'(N S 'Run' #.util.GEN∆T1 ⎕THIS)¨I F B
Z←0 0⍴⍬
∇

'plus'	SCL∆TST∆DYADIC	'+'	I	I	F	F	B	B
'minus'	SCL∆TST∆DYADIC	'-'	I	I	F	F	B	B
'times'	SCL∆TST∆DYADIC	'×'	I	I	F	F	B	B
'divide'	SCL∆TST∆DYADIC	'÷'	I	INZ	F	FNZ	B	BNZ
'power'	SCL∆TST∆DYADIC	'*'	INZ	I	FNZ	I	BNZ	B
'powerzro'	SCL∆TST∆DYADIC	'*'	I	INT	F	INT	B	B
'powerneg'	SCL∆TST∆DYADIC	'*'	IPS	I	FPS	F	BNZ	B
'log'	SCL∆TST∆DYADIC	'⍟'	IPS	IPS	FPS	FPS	IPS	IPS
'residue'	SCL∆TST∆DYADIC	'|'	I	I	F	F	B	B
'minimum'	SCL∆TST∆DYADIC	'⌊'	I	I	F	F	B	B
'maximum'	SCL∆TST∆DYADIC	'⌈'	I	I	F	F	B	B
'lessthan'	SCL∆TST∆DYADIC	'<'	I	I	F	F	B	B
'lesseq'	SCL∆TST∆DYADIC	'≤'	I	I	F	F	B	B
'equal'	SCL∆TST∆DYADIC	'='	I	I	F	F	B	B
'greatereq'	SCL∆TST∆DYADIC	'≥'	I	I	F	F	B	B
'greater'	SCL∆TST∆DYADIC	'>'	I	I	F	F	B	B
'notequal'	SCL∆TST∆DYADIC	'≠'	I	I	F	F	B	B
'andi'	SCL∆TST∆DYADIC	'∧'	I	I	I2	I2	B	B
'andf'	SCL∆TST∆RELATIVE	'∧'	F	F	F2	F2	B	B
'ori'	SCL∆TST∆DYADIC	'∨'	I	I	I2	I2	B	B
'orf'	SCL∆TST∆RELATIVE	'∨'	F	F	F2	F2	B	B
'notand'	SCL∆TST∆DYADIC	'⍲'	B	B	B	B	B	B
'notor'	SCL∆TST∆DYADIC	'⍱'	B	B	B	B	B	B

'conjugate'	SCL∆TST∆MONADIC	'+'	I	F	B
'negate'	SCL∆TST∆MONADIC	'-'	I	F	B
'direction'	SCL∆TST∆MONADIC	'×'	I	F	B
'reciprocal'	SCL∆TST∆MONADIC	'÷'	INZ	FNZ	BNZ
'exponential'	SCL∆TST∆MONADIC	'*'	I	F	B
'natlog'	SCL∆TST∆MONADIC	'⍟'	IPS	FPS	IPS
'magnitude'	SCL∆TST∆MONADIC	'|'	I	F	B
'pitimes'	SCL∆TST∆MONADIC	'○'	I	F	B
'floor'	SCL∆TST∆MONADIC	'⌊'	I	F	B
'ceiling'	SCL∆TST∆MONADIC	'⌈'	I	F	B
'not'	SCL∆TST∆MONADIC	'~'	B	B	B
'materialize'	SCL∆TST∆MONADIC	'⌷'	I	F	B
'factorial'   SCL∆TST∆MONADIC '!' IPS F B

BS←':Namespace' 'r←0.02	⋄ v←0.03' 
BS,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
BS,←⊂'L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT'
BS,←⊂'(÷(○2)*0.5)×(*(L×L)÷¯2)×÷1+0.2316419×L' 
BS,←'}' ':EndNamespace'

D←{⍉1+?⍵ 3⍴1000}2*20 ⋄ L←,¯1↑D ⋄ R←2↑D

''('scalar' BS 'Run' 1e¯10 #.util.GEN∆T3 ⎕THIS) L R

:EndNamespace
