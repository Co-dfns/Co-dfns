:Namespace test

⎕IO ⎕CT ⎕PP←0 0 34

B←{⍺←⊢ ⋄ (⍺ ⍺⍺ ⍵)⍵⍵ ⍵}

CRLF←CR LF←⎕UCS 13 10

gen←{⍺←⊢ ⋄ (⍺⊣CR)srcify step⍣≡ ⍵}

cases←{(⍳⍺)(⍺⍴⍵)(⍺⍴0)(⍺⍴0)(,⊂'')}

Nil Ns E1 E2 Tk Lt←⍳≢t∆←'Nil' 'Ns' 'E1' 'E2' 'Tk' 'Lt'
Nt Any Num Nz Pos Bool Nat Shp Nscl Dom Fn←⍳11

⍝ Nil [Any - Dom] → Lt | E1 : Array values Distribution
NIL∆DST←+⍀0 0.58 0.42

⍝ E1 distributions
PRM∆E1←,¨'+-×÷|⌊⌈*⍟○!~?∊⍴,⍪⌽⊖⍉↑↓⊂⊆⊃∪⊣⊢⌷≠⍳⍸⍋⍒≢≡⍕⌹'

DST∆E1←0.05 2.16 0.09 0.08 1.1 0.15 0.05 0.05 0.05 0.05 0.05 4.8 0.09 
DST∆E1⍪←1.04 0.7 5.38 1.81 2.51 0.05 1.18 0.36 1.03 35.13 0.11 8.58 
DST∆E1⍪←0.63 0.07 3.97 0.13 1.91 3.35 10.61 0.95 0.05 10.2 0.09 1.34 0.05

TYP∆E1←(≢PRM∆E1)/⍪Nt Any Num Nz Pos Bool Nat Shp Nscl Dom
MSK∆E1←(⍴TYP∆E1)⍴1

TYP∆E1[Any;PRM∆E1⍳,¨'÷⍟!~?⍳⍸⍋⍒⌹']←Nz Nz Pos Bool Nat Shp Nat Nscl Nscl Dom

MSK∆E1[Num;PRM∆E1⍳,¨'⍕']←0
TYP∆E1[Num;PRM∆E1⍳,¨'÷⍟!~?⍴≠⍳⍸⍋⍒≡≢⌹']←Nz Nz Pos Bool Nat Any Any Shp Nat Nscl Nscl Any Any Dom

MSK∆E1[Nz;PRM∆E1⍳,¨'⌊⌈⍟~?⍴⊃≠⍳⍸⍋⍒≢⍕⌹']←0
TYP∆E1[Nz;PRM∆E1⍳,¨'*!']←Num Pos

MSK∆E1[Pos;PRM∆E1⍳,¨'-⌈⍟≡⍕⌹']←0
TYP∆E1[Pos;PRM∆E1⍳,¨'|*~?⍴≠⍳⍸⍋⍒≢']←Num Num Bool Nat Any Any Shp Nat Nscl Nscl Any

MSK∆E1[Bool;PRM∆E1⍳,¨'-÷*⍟○?⍴⍳⍸⍋⍒≡≢⍕⌹']←0
TYP∆E1[Bool;PRM∆E1⍳,¨'×≠']←Pos Any

MSK∆E1[Nat;PRM∆E1⍳,¨'-÷*⍟○?≡⍕⌹']←0
TYP∆E1[Nat;PRM∆E1⍳,¨'×⌊⌈~⍴≠⍳⍋⍒≢']←Pos Pos Pos Bool Any Any Shp Any Any Any

MSK∆E1[Shp;PRM∆E1⍳,¨'-÷*⍟○~?⍪↑↓⊂⊆≡⍕⌹']←0
TYP∆E1[Shp;PRM∆E1⍳,¨'∊⍴⍋⍒≢']←Nat Any Any Any Any

MSK∆E1[Nscl;PRM∆E1⍳,¨'÷⍟!~?↓⊂⊆⊃⍳⍸≢≡⌹']←0

MSK∆E1[Dom;PRM∆E1⍳,¨'÷⍟!~?↓⊂⊆⍳⍸⍋⍒⍕']←0

DST∆E1←100000÷⍨⌊0.5+1000×+⍀0,,MSK∆E1×((+/DST∆E1×[1]~MSK∆E1)÷+/MSK∆E1)∘.+DST∆E1

⍝ Lt: Literal Values Distribution
⍝     ¯c64   ¯f64   ¯i64   ¯i32   ¯i16   ¯i8   0  b1     i8    i16   i32   i64   f64   c64   ch32
AV∆LT←⎕AV~⎕UCS 13 10 8
TYP∆LT←    ¯7     ¯6     ¯5     ¯4     ¯3    ¯2   0   1      2      3     4     5     6     7      8
RNG∆LT←⍉⍪(-2*63)(-2*63)(-2*63)(-2*31)(-2*15)(-2*7)0   0      1      1     1     1     0     0      0
RNG∆LT⍪←     0      0      0      0      0     0   1   2     (2*7) (2*15)(2*31)(2*63)(2*63)(2*63)(≢AV∆LT)
DST∆LT← 0.001  0.005  0.010  0.020  0.050 0.154 0.250 0.220 0.154 0.050 0.020 0.010 0.005 0.001 0.050

MSK∆LT←Fn(≢TYP∆LT)⍴1
MSK∆LT[Any;]←	1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
MSK∆LT[Num;]←	1 1 1 1 1 1 1 1 1 1 1 1 1 1 0
MSK∆LT[Nz;]←	1 1 1 1 1 1 0 0 1 1 1 1 1 1 0
MSK∆LT[Pos;]←	0 0 0 0 0 0 1 1 1 1 1 1 1 1 0
MSK∆LT[Bool;]←	0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
MSK∆LT[Nat;]←	0 0 0 0 0 0 1 1 1 1 1 1 0 0 0
MSK∆LT[Shp;]←	0 0 0 0 0 0 0 0 1 1 0 0 0 0 0
MSK∆LT[Nscl;]←	1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
MSK∆LT[Dom;]←	0 1 0 0 0 0 0 0 0 0 0 0 1 0 0

SPD∆LT←+⍀0 0.12 0.40 0.25 0.10 0.07 0.05 0.01
DST∆LT←100000÷⍨⌊0.5+100000×+⍀0,,MSK∆LT×((+/DST∆LT×[1]~MSK∆LT)÷+/MSK∆LT)∘.+DST∆LT

step←{p t k n sym←⍵
	⍝ Nil Nt → Ns(⎕←Any) : Namespace Test
	quad gets←sym⍳sym∪←,¨'⎕←'
	i←⍸(t=Nil)∧k=Nt ⋄ t[i]←Ns
	p t k n⍪←(≢i)⍴¨i E2 Any 0
	p t k n⍪←(3×≢i)⍴¨(3⌿(≢i)+⍳≢i)(Tk Tk Nil)(Any Fn Any)(quad gets 0)
	
	⍝ Nil [Any - Dom] → Lt | E1 : Array values
	i←⍸(t=Nil)∧(Any≤k)∧k≤Dom ⋄ t[i]←Lt E1[NIL∆DST⍸?0⍴⍨≢i]

	⍝ E1: Monadic Expressions
	x←DST∆E1⍸k[i]+?0⍴⍨≢i←⍸(t=E1)∧~(⍳≢p)∊p
	p t k n⍪←(2×≢i)⍴¨(2⌿i)(Tk Nil)(∊Fn,⍪(,TYP∆E1)[x])(∊0,⍨⍪sym⍳sym∪←PRM∆E1[x|⍨≢PRM∆E1])	
	
	⍝ Lt: Literal values
	x←DST∆LT⍸k[i]+?0⍴⍨≢i←⍸(t=Lt)∧n=0
	sp←SPD∆LT⍸?0⍴⍨≢i ⋄ sp[j]←6+⌊2048×(?0⍴⍨≢j)×?0⍴⍨≢j←⍸sp=6 ⋄ sp[⍸(k[i]=Nscl)∧sp=1]+←1
	ec←sp×1+7=|TYP∆LT[c←(≢TYP∆LT)|x] ⋄ vl←(ec⌿RNG∆LT[0;c])+(ec⌿(-⌿⊖RNG∆LT)[c])×?ec⌿0
	nv←(≢i)⍴⊂⍬ ⋄ ei←⍸ec ⋄ cc←ec⌿c
	nv[ei[j]]⍪←⌊vl[j←⍸5≥|TYP∆LT[cc]]
	nv[ei[j]]⍪←vl[j←⍸6=|TYP∆LT[cc]]
	nv[ei[j]]⍪←+⌿1 0j1×[0](2,(≢j)÷2)⍴vl[j←⍸7=|TYP∆LT[cc]]
	nv[ei[j]]⍪←AV∆LT[⌊vl[j←⍸TYP∆LT[cc]=8]]
	n[i]←sym⍳sym∪←nv
	
	p t k n sym
}

srcify←{p t k n sym←⍵ ⋄ nl←⍺
	p t k n⌿⍨←⊂msk←1+t∊Ns E1 E2 ⋄ p←(i←+⍀0⍪¯1↓msk)[p] ⋄ t[1+i⌿⍨msk=2]×←¯1
	p[i]←i←⍸(t=-Ns)∧p[p]=p
	src←(≢p)⍴⊂''
	((t=Ns)⌿src)←⊂':Namespace',nl ⋄ ((t=-Ns)⌿src)←⊂':EndNamespace',nl
	src[i]←sym[n[i←⍸t=Tk]]
	src[i]←⍕¨'⍬'@{0=≢¨⍵}sym[n[i←⍸(t=Lt)∧0=stp←((⊃0⍴⊢)¨sym)[n]]]
	src[i]←''''⍪¨(''''⎕R''''''⊢sym[n[i←⍸(t=Lt)∧' '=stp]])⍪¨''''
	em←(t=E1)∨em2←t=E2 ⋄ em∆←t∊-E1 E2
	((em∧(≠p)∧em2[p])⌿src)←'(' ⋄ ((em∆∧(~⌽≠⌽p)∧em2[p])⌿src)←')'
	((em∆∧(~em)[p])⌿src)←⊂nl
	
	∊¨((d[i]=0)∧t[i]=Ns)⊂src[1⊃d i←P2D p]
}

tag←'-------'
tagout←{
	⍺∘{⎕←tag ⋄ _←⎕FIX ⍺~⍤∊⍨B⊆⍵}¨⍵
}

annotate←{
	log←⌽¯2↓⎕SE.Log ⋄ tags←log∊⊂tag ⋄ log tags↑⍨←⊂(+⍀tags)⍳≢⍵
	⍵,∘∊¨⌽(~tags)⊆'⍝ '∘,¨log,¨⊂⍺
}

P2D←{p←⍵
	_←{x(m⌿ph)⊣d[x←x⌿⍨m←h≠ph←p[h]]+←1⊣x h←⍵}⍣{0=≢⊃⍺}2⍴⊂⍳≢p⊣d←(≢p)⍴0
	z←⊃⊃{s←⍋h←⍺⍪p[1⊃⍵] ⋄ ((⍺⍪⊃⍵)[s])(h[s])}⌿(⊂⍬ ⍬)⍪⍨{⊂1↓⍵-md}⌸(⍳md←1+⌈⌿d)⍪d
d z}

:EndNamespace
