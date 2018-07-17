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
##.UT.run './'
∇

test←{##.UT.(print_passed print_summary)←1
 ##.UT.run './t',(1 0⍕(4⍴10)⊤⍵),'_tests.dyalog'}

MK∆T1←{##.UT.expect←(⍎'##.t',⍺⍺)⍵⍵ ⋄ (⍎'##.c',⍺⍺)⍵⍵}
MK∆T2←{##.UT.expect←⊃(⍎'##.t',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'##.c',⍺⍺)/⍵⍵}
MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'##.t',fn)/⍵⍵ ⋄ cv←⊃(⍎'##.c',fn)/⍵⍵
 ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

:EndNamespace
