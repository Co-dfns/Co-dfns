:Namespace util

⍝ Boxed display of array.
display←{⎕IO ⎕ML←0 1

	⍝ box with type and axes
	box←{
		vrt hrz←(¯1+⍴⍵)⍴¨'│─'	⍝ vert. and horiz. lines
		top←'─⊖→'[¯1↑⍺],hrz	⍝ upper border with axis
		bot←(⊃⍺),hrz	⍝ lower border with type
		rgt←'┐│',vrt,'┘'	⍝ right side with corners
		lax←'│⌽↓'[¯1↓1↓⍺],¨⊂vrt	⍝ left side(s) with axes,
		lft←⍉'┌',(↑lax),'└'	⍝ ... and corners
		lft,(top⍪⍵⍪bot),rgt	⍝ fully boxed array
	}

	deco←{⍺←type open ⍵ ⋄ ⍺,axes ⍵}	⍝ type and axes vector
	axes←{(-2⌈⍴⍴⍵)↑1+×⍴⍵}	⍝ array axis types
	open←{16::(1⌈⍴⍵)⍴⊂'[ref]' ⋄ (1⌈⍴⍵)⍴⍵}	⍝ exposure of null axes
	trim←{(~1 1⍷∧⌿⍵=' ')/⍵}	⍝ removal of extra blank cols
	type←{{(1=⍴⍵)⊃'+'⍵}∪,char¨⍵}	⍝ simple array type
	char←{⍬≡⍴⍵:'─' ⋄ (⊃⍵∊'¯',⎕D)⊃'#~'}∘⍕	⍝ simple scalar type
	line←{(6≠10|⎕DR' '⍵)⊃' -'}	⍝ underline for atom

	⍝ recursive boxing of arrays:
	{
		0=≡⍵:' '⍪(open ⎕FMT ⍵)⍪line ⍵	⍝ simple scalar
		1 ⍬≡(≡⍵)(⍴⍵):'∇' 0 0 box ⎕FMT ⍵	⍝ object rep: ⎕OR
		1=≡⍵:(deco ⍵)box open ⎕FMT open ⍵	⍝ simple array
		('∊'deco ⍵)box trim ⎕FMT ∇¨open ⍵	⍝ nested array
	}⍵
}

pp←{⍵⊣⎕←display ⍵⊣⍞←⍴⍵⊣⍞←'Shape: '}
px←{⍺←'' ⋄ ⎕←⍺ ⋄ ⎕←##.codfns.Xml ⍵ ⋄ ⍵}

⍝ Char vector from UTF-8 file ⍵.
utf8get←{
	0::⎕SIGNAL ⎕EN	⍝ signal error to caller.
	tie←⍵ ⎕NTIE 0	⍝ file handle.
	ints←⎕NREAD tie 83,⎕NSIZE tie	⍝ all UTF-8 file bytes.
	('UTF-8'⎕UCS 256|ints)⊣⎕NUNTIE tie	⍝ ⎕AV chars.
}

split←{lf cr←⎕UCS 10 13 ⋄ {⍵~cr lf}¨(1,¯1↓⍵=lf)⊂⍵}

∇TEST
##.UT.print_passed←1
##.UT.print_summary←1
##.UT.run './tests'
∇

test←{##.UT.run './tests/',⍵,'_tests.dyalog'}

MK∆T1←{id ns fn←⍺⍺ ⋄ r←⍵⍵ ⋄ CS←id ##.codfns.Fix ns ⋄ NS←⎕FIX ns
	##.UT.expect←(⍎'NS.',fn)r ⋄ (⍎'CS.',fn)r}
MK∆T2←{id ns fn←⍺⍺ ⋄ l r←⍵⍵ ⋄ CS←id ##.codfns.Fix ns ⋄ NS←⎕FIX ns
	##.UT.expect←l(⍎'NS.',fn)r ⋄ l(⍎'CS.',fn)r}
MK∆T3←{id ns fn tl←⍺⍺ ⋄ l r←⍵⍵ ⋄ CS←id ##.codfns.Fix ns ⋄ NS←⎕FIX ns
	nv←l(⍎'NS.',fn)r ⋄ cv←l(⍎'CS.',fn)r
	##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

∇	Z←ID(NCF GEN∆T1 THIS)IN;NS;FN;TC;TMP
	NS TC FN←NCF ⋄ TMP←(NS,ID) TC FN MK∆T1 IN
	⍎'THIS.',NS,'∆',ID,'_TEST←TMP'
	Z←0 0⍴⍬
∇

∇	Z←ID(NCF GEN∆T2 THIS)IN;NS;FN;TC;TMP
	NS TC FN←NCF ⋄ TMP←(NS,ID) TC FN MK∆T2 IN
	⍎'THIS.',NS,'∆',ID,'_TEST←TMP'
	Z←0 0⍴⍬
∇

∇Z←ID(NCFT GEN∆T3 THIS)IN;NS;FN;TC;TMP;TL
	NS TC FN TL←NCFT ⋄ TMP←(NS,ID) TC FN TL MK∆T3 IN
	⍎'THIS.',NS,'∆',ID,'_TEST←TMP'
	Z←0 0⍴⍬
∇

:EndNamespace
