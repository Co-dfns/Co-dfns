:Namespace util

display←{	⎕IO ⎕ML	←0 1	⍝ Boxed display of array.
	⍺	←1	
	chars	←⍺⊃'..''''|-' '┌┐└┘│─'	⍝ ⍺: 0-clunky, 1-smooth.
	tl tr bl br vt hz	←chars	⍝ Top left, top right,	...

	box←{	⍝ Box with type and axes.
		vrt hrz	←(¯1+⍴⍵)⍴¨vt hz	⍝ Vert. and horiz. lines.
		top	←(hz,'⊖→')[¯1↑⍺],hrz	⍝ Upper border	with axis.
		bot	←(⊃⍺),hrz	⍝ Lower border	with type.
		rgt	←tr,vt,vrt,br	⍝ Right side with corners.
		lax	←(vt,'⌽↓')[¯1↓1↓⍺],¨⊂vrt	⍝ Left	side(s)	with axes,
		lft	←⍉tl,(↑lax),bl	⍝ ... and corners.
		lft,(top⍪⍵⍪bot),rgt		⍝ Fully boxed array.
	}

	deco	←{⍺←type open ⍵ ⋄ ⍺,axes ⍵}	⍝ Type	and axes vector.
	axes	←{(-2⌈⍴⍴⍵)↑1+×⍴⍵}	⍝ Array axis types.
	open	←{16::(1⌈⍴⍵)⍴⊂'[ref]' ⋄ (1⌈⍴⍵)⍴⍵}	⍝ Expose null axes.
	trim	←{(~1 1⍷∧⌿⍵=' ')/⍵}	⍝ Remove extra	blank cols.
	type	←{{(1=⍴⍵)⊃'+'⍵}∪,char¨⍵}	⍝ Simple array	type.
	char	←{⍬≡⍴⍵:hz ⋄ (⊃⍵∊'¯',⎕D)⊃'#~'}∘⍕	⍝ Simple scalar type.
	line	←{(6≠10|⎕DR' '⍵)⊃' -'}	⍝ underline for atom.

	{	⍝ Recursively box arrays:
		0=≡⍵:	' '⍪(open ⎕FMT ⍵)⍪line ⍵	⍝ Simple scalar.
		1 ⍬≡(≡⍵)(⍴⍵):	'∇' 0 0 box ⎕FMT ⍵	⍝ Object rep: ⎕OR.
		1=≡⍵:	(deco ⍵)box open ⎕FMT open ⍵	⍝ Simple array.
			('∊'deco ⍵)box trim ⎕FMT ∇¨open ⍵	⍝ Nested array.
	}⍵
}

pp←{⍵⊣⎕←display ⍵⊣⍞←⍴⍵⊣⍞←'Shape: '}

utf8get←{	⍝ Char vector from UTF-8 file ⍵.
	0::	⎕SIGNAL ⎕EN	⍝ signal error to caller.
	tie	←⍵ ⎕NTIE 0	⍝ file handle.
	ints	←⎕NREAD tie 83,⎕NSIZE tie	⍝ all UTF-8 file bytes.
		('UTF-8'⎕UCS 256|ints)⊣⎕NUNTIE tie	⍝ ⎕AV chars.
}

MK∆T1←{	id cmp ns fn←⍺⍺ ⋄ r←⍵⍵
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:0⊣#.UT.expect←0
	#.codfns.COMPILER←cmp ⋄ CS←id #.codfns.Fix	ns ⋄ NS←⎕FIX ns
	#.UT.expect←(⍎'NS.',fn)r ⋄ (⍎'CS.',fn)r
}

MK∆T2←{	id cmp ns fn←⍺⍺ ⋄ l r←⍵⍵
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:0⊣#.UT.expect←0
	#.codfns.COMPILER←cmp ⋄ CS←id #.codfns.Fix	ns ⋄ NS←⎕FIX ns
	#.UT.expect←l(⍎'NS.',fn)r ⋄ l(⍎'CS.',fn)r
}

MK∆T3←{	id cmp ns fn tl←⍺⍺	⋄ l r←⍵⍵
	~(⊂cmp)∊#.codfns.TEST∆COMPILERS:0⊣#.UT.expect←0
	#.codfns.COMPILER←cmp ⋄ CS←id #.codfns.Fix	ns ⋄ NS←⎕FIX ns
	nv←l(⍎'NS.',fn)r ⋄ cv←l(⍎'CS.',fn)r
	#.UT.expect←(≢nv)⍴1 ⋄ ,tl>|nv-cv
}

∇Z←ID(NCF GEN∆T1 THIS)IN;NS;FN;CMP;TC;TMP
 NS TC FN←NCF
 :For CMP :In 'gcc' 'icc' 'vsc' 'pgcc'
     TMP←(NS,ID)CMP TC FN MK∆T1	IN
     ⍎'THIS.',NS,'∆',ID,'∆',CMP,'_TEST←TMP'
 :EndFor
 Z←0 0⍴⍬
∇

∇Z←ID(NCF GEN∆T2 THIS)IN;NS;FN;CMP;TC;TMP
 NS TC FN←NCF
 :For CMP :In 'gcc' 'icc' 'vsc' 'pgcc'
     TMP←(NS,ID)CMP TC FN MK∆T2	IN
     ⍎'THIS.',NS,'∆',ID,'∆',CMP,'_TEST←TMP'
 :EndFor
 Z←0 0⍴⍬
∇

∇Z←ID(NCFT GEN∆T3 THIS)IN;NS;FN;CMP;TC;TMP;TL
 NS TC FN TL←NCFT
 :For CMP :In 'gcc' 'icc' 'vsc' 'pgcc'
     TMP←(NS,ID)CMP TC FN TL MK∆T3	IN
     ⍎'THIS.',NS,'∆',ID,'∆',CMP,'_TEST←TMP'
 :EndFor
 Z←0 0⍴⍬
∇

∇TEST
#.UT.print_passed←0
#.UT.print_summary←1
#.UT.run'./Testing'
∇

test←{#.UT.run'./Testing/',⍵,'_tests.dyalog'}

:EndNamespace
