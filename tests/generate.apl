:Namespace test

⎕IO ⎕CT ⎕PP←0 0 34

CRLF←CR LF←⎕UCS 13 10

gen←{⍺←⊢ ⋄ (⍺⊣CR)srcify step⍣≡ ⍵}

cases←{(⍳⍺)(⍺⍴⍵)(⍺⍴0)(⍺⍴0)(,⊂'')}

Nt Ns Ex Tk Lt←⍳5

step←{p t k n sym←⍵
	⍝ Nt: Namespace Test
	ic←≢i←⍸t=Nt ⋄ t[i]←Ns ⋄ p⍪←i ⋄ t k n⍪←ic⍴¨Ex 0 0
	quad gets←sym⍳sym∪←,¨'⎕←'
	p⍪←3⌿ic+⍳ic ⋄ t k n⍪←(3×ic)⍴¨(Tk Tk Lt)0(quad gets 0)
	
	⍝ Lt: Literal values
	i←⍸(t=Lt)∧k=0
	dt←0.25 0.20 0.17 0.12 0.10 0.10 0.01 0.05
	dl←0.12 0.40 0.25 0.10 0.07 0.05 0.01
	av←⎕AV~⎕UCS 13 10 8
	lt←(+⍀0⍪dt)⍸?0⍴⍨≢i ⋄ ll←(+⍀0⍪dl)⍸?0⍴⍨≢i ⋄ ll[j]←6+⌊2048×(?0⍴⍨≢j)×?0⍴⍨≢j←⍸ll=6
	rgw←2*1 8 16 32 62 ⋄ rgs←0⍪2*7 15 31 61
	n[i[j]]←(⍸⍣¯1⊢+⍀0⍪¯1↓ll[j])⊂(?ll[j]⌿rgw[lt[j]])-ll[j]⌿rgs[lt[j←⍸lt<5]]
	n[i[j]]←(⍸⍣¯1⊢+⍀0⍪¯1↓ll[j])⊂((?c⍴0)×?c⍴0)×(?c⍴2*32)-2*31⊣c←+⌿ll[j←⍸lt=5]
	n[i[j]]←(⍸⍣¯1⊢+⍀0⍪¯1↓ll[j])⊂+⌿1 0j1×[0]((?c⍴0)×?c⍴0)×(?c⍴2*32)-2*31⊣c←2⍪+⌿ll[j←⍸lt=6]
	n[i[j]]←(⍸⍣¯1⊢+⍀0⍪¯1↓ll[j])⊂av[?ll[j←⍸lt=7]⌿≢av]
	n[i]←sym⍳sym∪←n[i]
	k[i]←1 ⋄ k[i[j]]←2
	
	p t k n sym
}

srcify←{p t k n sym←⍵ ⋄ nl←⍺
	p t k n⌿⍨←⊂msk←1+t∊Ns Ex ⋄ p←(i←+⍀0⍪¯1↓msk)[p] ⋄ t[1+i⌿⍨msk=2]×←¯1
	p[i]←i←⍸(t=-Ns)∧p[p]=p
	src←(≢p)⍴⊂''
	((t=Ns)⌿src)←⊂':Namespace',nl ⋄ ((t=-Ns)⌿src)←⊂':EndNamespace',nl
	src[i]←sym[n[i←⍸t=Tk]]
	src[i]←⍕¨'⍬'@{0=≢¨⍵}sym[n[i←⍸(t=Lt)∧k=1]]
	src[i]←''''⍪¨(''''⎕R''''''⊢sym[n[i←⍸(t=Lt)∧k=2]])⍪¨''''
	(((t=Ex)∧(≠p)∧t[p]=Ex)⌿src)←'(' ⋄ (((t=-Ex)∧(~⌽≠⌽p)∧t[p]=Ex)⌿src)←')'
	(((t=-Ex)∧t[p]≠Ex)⌿src)←⊂nl
	
	∊src[1⊃P2D p]
}

P2D←{p←⍵
	_←{x(m⌿ph)⊣d[x←x⌿⍨m←h≠ph←p[h]]+←1⊣x h←⍵}⍣{0=≢⊃⍺}2⍴⊂⍳≢p⊣d←(≢p)⍴0
	z←⊃⊃{s←⍋h←⍺⍪p[1⊃⍵] ⋄ ((⍺⍪⊃⍵)[s])(h[s])}⌿(⊂⍬ ⍬)⍪⍨{⊂1↓⍵-md}⌸(⍳md←1+⌈⌿d)⍪d
d z}

:EndNamespace
