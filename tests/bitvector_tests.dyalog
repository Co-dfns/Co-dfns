:Namespace bitvector

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺∧0≠⍵}' ':EndNamespace'

B1←?15⍴3
B2←?15⍴3

Fn←{	A	←⍵ #.codfns.MKA 15⍴1
	B	←⍵ #.codfns.MKA B1
	_	←⍺⍺ A A B
	_	←⍵ #.codfns.FREA B
	B	←⍵ #.codfns.MKA B2
	_	←⍺⍺ A A B
	Z	←⍵ #.codfns.EXA A 3
		(⎕DR Z) Z}

bitvector∆01∆gcc_TEST←{
	id cmp ns fn	←'bitvector01' 'gcc' S 'Run'
	#.UT.expect	←0
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:	0
	EX	←⊃{⍵∧0≠⍺}/B1 B2 1
	#.UT.expect	←(⎕DR EX) EX
	#.codfns.COMPILER	←cmp
	CS	←id #.codfns.Fix	ns
	so	←#.codfns.BSO id
	_	←'Runib'⎕NA so,'|Runib P P P'
		Runib Fn id
}

bitvector∆01∆icc_TEST←{
	id cmp ns fn	←'bitvector01' 'icc' S 'Run'
	#.UT.expect	←0
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:	0
	EX	←⊃{⍵∧0≠⍺}/B1 B2 1
	#.UT.expect	←(⎕DR EX) EX
	#.codfns.COMPILER	←cmp
	CS	←id #.codfns.Fix	ns
	so	←#.codfns.BSO id
	_	←'Runib'⎕NA so,'|Runib P P P'
		Runib Fn id
}

bitvector∆01∆pgcc_TEST←{
	id cmp ns fn	←'bitvector01' 'pgcc' S 'Run'
	#.UT.expect	←0
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:	0
	EX	←⊃{⍵∧0≠⍺}/B1 B2 1
	#.UT.expect	←(⎕DR EX) EX
	#.codfns.COMPILER	←cmp
	CS	←id #.codfns.Fix	ns
	so	←#.codfns.BSO id
	_	←'Runib'⎕NA so,'|Runib P P P'
		Runib Fn id
}

:EndNamespace

