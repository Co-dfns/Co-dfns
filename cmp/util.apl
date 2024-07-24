I←{(⊂⍵)⌷⍺}
U←{⍺←⊢ ⋄ ⍵⍵⍣¯1⊢⍺ ⍺⍺⍥⍵⍵ ⍵}

assert←{
	⍺←'assertion failure'
	0∊⍵:⍎'⍺ ⎕SIGNAL 8'
	1:shy←0
}

∇ Z←SELECT I
 Z←∊pos[I]+⍳¨end[I]-pos[I]
∇

∇ {Z}←{MSG}SIGNAL N;CR;LF;linestarts;lineof;mkdm;quotelines;en;msg;dmx
  CR LF←⎕UCS 13 10
  linestarts←⍸1⍪IN∊CR LF

  lineof←{∊b+⍳¨linestarts[l+1]-b←linestarts[l←linestarts⍸⍵]}

  mkdm←{⍺←2
  	line←linestarts⍸⍵
  	no←'[',(⍕1+line),'] '
  	beg←linestarts[line]
  	i←(~IN[i]∊CR LF)⌿i←beg+⍳linestarts[line+1]-beg
  	(⎕EM ⍺)(no,IN[i])(' ^'[i∊⍵],⍨' '⍴⍨≢no)
  }

  tabify←{1 8[⍺]⌿' '@(⍺⍨)⍵}

  quotelines←{
  	lines←∪linestarts⍸,⍵
  	nos←(1 0⍴⍨2×≢lines)⍀'[',(⍕⍪1+lines),⍤1⊢'] '
  	beg←linestarts[lines] ⋄ end←linestarts[lines+1]
  	m←∊∘⍵¨i←beg+⍳¨end-beg ⋄ t←(⎕UCS 9)=txt←IN∘I¨i
  	¯1↓∊nos,(~∘CR LF¨⍪,(t tabify¨txt),⍪t tabify¨' ▔'∘I¨m),CR
  }

  →HAS_MSG⌿⍨0≠⎕NC'MSG' ⋄ MSG←2 ''

 HAS_MSG:en msg←¯2↑2,⊆MSG

  ⎕THIS.EN←en ⋄ ⎕THIS.DM←en mkdm ⊃N
  dmx←('EN' en)('Category' 'Compiler')('Vendor' 'Co-dfns')
  dmx,←⊂'Message'((⊢↑⍨(2*20)⌊≢)msg,CR,quotelines N)
  ⎕SIGNAL ⊂dmx
  Z←0
∇

D2P←{0=≢⍵:⍬ ⋄ p⊣2{p[⍵]←⍺[⍺⍸⍵]}⌿⊢∘⊂⌸⍵⊣p←⍳≢⍵}
P2D←{z←⍪⍳≢⍵ ⋄ d←⍵≠,z ⋄ _←{p⊣d+←⍵≠p←⍺[z,←⍵]}⍣≡⍨⍵ ⋄ d(⍋(-1+d)↑⍤0 1⊢⌽z)}

opsys←{⍵⊃⍨'Win' 'Lin' 'Mac'⍳⊂3↑⊃'.'⎕WG'APLVersion'}
put←{
	s←(¯128+256|128+'UTF-8'⎕UCS ⍵)⎕NAPPEND(t←tie ⍺)83
	1:r←s⊣⎕NUNTIE t
}
tie←{
	0::⎕SIGNAL ⎕EN
	22::⍵ ⎕NCREATE 0
	0 ⎕NRESIZE ⍵ ⎕NTIE 0
}

dct←{⍺[(2×2≠/n,0)+(1↑⍨≢m)+m+n←⌽∨\⌽m←' '≠⍺⍺ ⍵]⍵⍵ ⍵}
dlk←{((x⌷⍴⍵)↑[x←2|1+⍵⍵]⍺),[⍵⍵]⍺⍺@(⊂0 0)⍣('┌'=⊃⍵)⊢⍵}
dwh←{
	z←⊃⍪/((≢¨⍺),¨⊂⌈/≢∘⍉¨⍺)↑¨⍺
	⍵('┬'dlk 1)' │├┌└─'(0⌷⍉)dct,z
}
dwv←{
	z←⊃{⍺,' ',⍵}/(1+⌈/≢¨⍺){⍺↑⍵⍪⍨'│'↑⍨≢⍉⍵}¨⍺
	⍵('├'dlk 0)' ─┬┌┐│'(0⌷⊢)dct(⊣⍪1↓⊢)z
}
lb3←{
	⍺←⍳≢⊃⍵
	z←(N∆{⍺[⍵]}@2⊢(2⊃⍵){⍺[|⍵]}@{0>⍵}@4↑⊃⍵)[⍺;]
	'(',¨')',¨⍨{⍺,';',⍵}⌿⍕¨z
}
pp3←{
	⍺←'○' ⋄ lbl←⍺⍴⍨≢⍵
	d←(⍳≢⍵)≠⍵ ⋄ _←{z⊣d+←⍵≠z←⍺[⍵]}⍣≡⍨⍵
	lyr←{
		i←⍸⍺=d
		k v←↓⍉⍵⍵[i],∘⊂⌸i
		(⍵∘{⍺[⍵]}¨v)⍺⍺¨@k⊢⍵
	}⍵
	(⍵=⍳≢⍵)⌿⊃⍺⍺ lyr⌿(1+⍳⌈/d),⊂⍉∘⍪∘⍕¨lbl
}

XML←{⍺←0
	ast←⍺{d i←P2D⊃⍵ ⋄ i∘{⍵[⍺]}¨(⊂d),1↓⍺↓⍵}⍣(0≠⍺)⊢⍵
	d t k n←4↑ast
	cls←N∆[t],¨('-..'[1+×k]),¨⍕¨|k
	fld←{((≢⍵)↑3↓f∆),⍪⍵}¨↓⍉↑3↓ast
	⎕XML⍉↑d cls(⊂'')fld
}
