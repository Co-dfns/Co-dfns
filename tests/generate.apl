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
prm←,¨'+-×÷|⌊⌈*⍟○!~?∊⍴,⍪⌽⊖⍉↑↓⊂⊆⊃∪⊣⊢⌷≠⍳⍸⍋⍒≢≡⍕⌹'

dst←0.05 2.16 0.09 0.08 1.1 0.15 0.05 0.05 0.05 0.05 0.05 4.8 0.09 
dst⍪←1.04 0.7 5.38 1.81 2.51 0.05 1.18 0.36 1.03 35.13 0.11 8.58 
dst⍪←0.63 0.07 3.97 0.13 1.91 3.35 10.61 0.95 0.05 10.2 0.09 1.34 0.05

typ←(≢prm)/⍪Nt Any Num Nz Pos Bool Nat Shp Nscl Dom
msk←(⍴typ)⍴1

typ[Any;prm⍳,¨'÷⍟!~?⍳⍸⍋⍒⌹']←Nz Nz Pos Bool Nat Shp Nat Nscl Nscl Dom

msk[Num;prm⍳,¨'⍕']←0
typ[Num;prm⍳,¨'÷⍟!~?⍴≠⍳⍸⍋⍒≡≢⌹']←Nz Nz Pos Bool Nat Any Any Shp Nat Nscl Nscl Any Any Dom

msk[Nz;prm⍳,¨'⌊⌈⍟~?⍴⊃≠⍳⍸⍋⍒≢⍕⌹']←0
typ[Nz;prm⍳,¨'*!']←Num Pos

msk[Pos;prm⍳,¨'-⌈⍟≡⍕⌹']←0
typ[Pos;prm⍳,¨'|*~?⍴≠⍳⍸⍋⍒≢']←Num Num Bool Nat Any Any Shp Nat Nscl Nscl Any

msk[Bool;prm⍳,¨'-÷*⍟○?⍴⍳⍸⍋⍒≡≢⍕⌹']←0
typ[Bool;prm⍳,¨'×≠']←Pos Any

msk[Nat;prm⍳,¨'-÷*⍟○?≡⍕⌹']←0
typ[Nat;prm⍳,¨'×⌊⌈~⍴≠⍳⍋⍒≢']←Pos Pos Pos Bool Any Any Shp Any Any Any

msk[Shp;prm⍳,¨'-÷*⍟○~?⍪↑↓⊂⊆≡⍕⌹']←0
typ[Shp;prm⍳,¨'∊⍴⍋⍒≢']←Nat Any Any Any Any

msk[Nscl;prm⍳,¨'÷⍟!~?↓⊂⊆⊃⍳⍸≢≡⌹']←0

msk[Dom;prm⍳,¨'÷⍟!~?↓⊂⊆⍳⍸⍋⍒⍕']←0

DST∆E1←100000÷⍨⌊0.5+1000×+⍀0,,msk×((+/dst×[1]~msk)÷+/msk)∘.+dst

⍝ Lt: Literal Values Distribution
⍝     ¯c64   ¯f64   ¯i64   ¯i32   ¯i16   ¯i8   0  b1     i8    i16   i32   i64   f64   c64   ch32
av←⎕AV~⎕UCS 13 10 8
tp ←    ¯7     ¯6     ¯5     ¯4     ¯3    ¯2   0   1      2      3     4     5     6     7      8
rg ←⍉⍪(-2*63)(-2*63)(-2*63)(-2*31)(-2*15)(-2*7)0   0      1      1     1     1     0     0      0
rg⍪←     0      0      0      0      0     0   1   2     (2*7) (2*15)(2*31)(2*63)(2*63)(2*63)(≢av)
dst← 0.001  0.005  0.010  0.020  0.050 0.154 0.250 0.220 0.154 0.050 0.020 0.010 0.005 0.001 0.050

msk←Fn(≢tp)⍴1
msk[Any;]←	1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
msk[Num;]←	1 1 1 1 1 1 1 1 1 1 1 1 1 1 0
msk[Nz;]←	1 1 1 1 1 1 0 0 1 1 1 1 1 1 0
msk[Pos;]←	0 0 0 0 0 0 1 1 1 1 1 1 1 1 0
msk[Bool;]←	0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
msk[Nat;]←	0 0 0 0 0 0 1 1 1 1 1 1 0 0 0
msk[Shp;]←	0 0 0 0 0 0 0 0 1 1 1 1 0 0 0
msk[Nscl;]←	1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
msk[Dom;]←	0 1 0 0 0 0 0 0 0 0 0 0 1 0 0

LT∆SPD←+⍀0 0.12 0.40 0.25 0.10 0.07 0.05 0.01
LT∆DST←100000÷⍨⌊0.5+100000×+⍀0,,msk×((+/dst×[1]~msk)÷+/msk)∘.+dst

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
	p t k n⍪←(2×≢i)⍴¨(2⌿i)(Tk Nil)(∊Fn,⍪(,typ)[x])(∊0,⍨⍪sym⍳sym∪←prm[x|⍨≢prm])	
	
	⍝ Lt: Literal values
	x←LT∆DST⍸k[i]+?0⍴⍨≢i←⍸(t=Lt)∧n=0
	sp←LT∆SPD⍸?0⍴⍨≢i ⋄ sp[j]←6+⌊2048×(?0⍴⍨≢j)×?0⍴⍨≢j←⍸sp=6 ⋄ sp[⍸(k[i]=Nscl)∧sp=1]+←1
	ec←sp×1+7=|tp[c←(≢tp)|x] ⋄ vl←(ec⌿rg[0;c])+(ec⌿(-⌿⊖rg)[c])×?ec⌿0
	nv←(≢i)⍴⊂⍬ ⋄ ei←⍸ec ⋄ cc←ec⌿c
	nv[ei[j]]⍪←⌊vl[j←⍸5≥|tp[cc]]
	nv[ei[j]]⍪←vl[j←⍸6=|tp[cc]]
	nv[ei[j]]⍪←+⌿1 0j1×[0](2,(≢j)÷2)⍴vl[j←⍸7=|tp[cc]]
	nv[ei[j]]⍪←av[⌊vl[j←⍸tp[cc]=8]]
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
