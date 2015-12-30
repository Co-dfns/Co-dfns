:Namespace bitvector

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺∧0≠⍵}' ':EndNamespace'

B1←?15⍴3
B2←?15⍴3

Fn←{	A	←⍵ #.codfns.MKA 15⍴1
	B	←⍵ #.codfns.MKA B1
	_	←⍺⍺ A A B 0
	_	←⍵ #.codfns.FREA B
	B	←⍵ #.codfns.MKA B2
	_	←⍺⍺ A A B 0
		⍵ #.codfns.EXA A 3}

bitvector∆01∆gcc_TEST←{
	id cmp ns fn	←'bitvector01' 'gcc' S 'Run'
	#.UT.expect	←0
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:	0
	#.UT.expect	←⊃{⍵∧0≠⍺}/B1 B2 1
	#.codfns.COMPILER	←cmp
	CS	←id #.codfns.Fix	ns
	so	←#.codfns.BSO id
	_	←'Rib'⎕NA so,'|fn_1_1ib P P P P'
		Rib Fn id
}

bitvector∆01∆icc_TEST←{
	id cmp ns fn	←'bitvector01' 'icc' S 'Run'
	#.UT.expect	←0
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:	0
	#.UT.expect	←⊃{⍵∧0≠⍺}/B1 B2 1
	#.codfns.COMPILER	←cmp
	CS	←id #.codfns.Fix	ns
	so	←#.codfns.BSO id
	_	←'Rib'⎕NA so,'|fn_1_1ib P P P P'
		Rib Fn id
}

bitvector∆01∆pgcc_TEST←{
	id cmp ns fn	←'bitvector01' 'pgcc' S 'Run'
	#.UT.expect	←0
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:	0
	#.UT.expect	←⊃{⍵∧0≠⍺}/B1 B2 1
	#.codfns.COMPILER	←cmp
	CS	←id #.codfns.Fix	ns
	so	←#.codfns.BSO id
	_	←'Rib'⎕NA so,'|fn_1_1ib P P P P'
		Rib Fn id
}

:EndNamespace

