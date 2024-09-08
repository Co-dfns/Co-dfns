PS←{
	(d t k n pos end)sym IN←⍵ ⋄ WS←⎕UCS 9 32

	⍝ Compute parent vector from d
	p←D2P d

	⍝ Compute the nameclass of dfns and set ∇∇ kind
	k[∪p⌿⍨(t=P)∧n=¯3]←3 ⋄ k[∪p⌿⍨(t=P)∧n=¯4]←4
	k[i]←k[p[i←⍸(t=P)∧n=¯6]]

	⍝ We will often wrap a set of nodes as children under a Z node
	gz←{
		z←⍵↑⍨-0≠≢⍵ ⋄ ks←¯1↓⍵
		t[z]←Z ⋄ p[ks]←⊃z ⋄ pos[z]←pos[⊃⍵] ⋄ end[z]←end[⊃⌽z,ks]
		z
	}

	⍝ Nest top-level root lines as Z nodes
	_←(gz 1⌽⊢)¨(t[i]=Z)⊂i←⍸d=0
	'Non-Z top-level node'assert t[⍸p=⍳≢p]=Z:

	⍝ Wrap all function expression bodies as Z nodes
	_←p[i]{end[⍺]←end[⊃⌽⍵] ⋄ gz¨⍵⊂⍨1,¯1↓t[⍵]=Z}⌸i←⍸(t[p]∊T F)∧~t=L
	'Non-Z/L dfns body node'assert t[⍸t[p]=F]∊Z L:

	⍝ Parse the first line of a trad-fn as an H node
	⍝ N M S A R L Z X Y←(9⍴2)⊤k ⋄ N M←16 16⊤n
	t[⍸(≠p)∧t[p]=T]←H
	∨⌿msk←(n=-sym⍳⊂,'←')∧(≠p)∧t[p]=H:'EMPTY RETURN HEADER'SIGNAL SELECT ⍸msk
	∨⌿msk←(n=-sym⍳⊂,';')∧(≠p)∧t[p]=H:'MISSING SIGNATURE'SIGNAL SELECT ⍸msk
	msysv←'⎕IO' '⎕ML' '⎕CT' '⎕PP' '⎕PW' '⎕RTL' '⎕FR' '⎕PATH' '⎕RL' '⎕DIV' '⎕TRAP' '⎕USING'
	msk←(t[p]=H)∧~(t=V)∨(n∊-sym⍳,¨'←(){};')∨(t=S)∧n∊-sym⍳⎕C¨msysv
	∨⌿msk:'INVALID TRAD-FNS HEADER TOKEN'SIGNAL SELECT ⍸msk
	_←p[i]{
		0=≢i:0
		nt←'←(){};V'['←(){};'⍳⊃¨sym[|n[⍵]]] ⋄ k[⍵⌿⍨nt≠'V']←¯99
		k[⍺]←0 ⋄ n[⍺]←0
		~∧⌿msk←(nt↓⍨x←nt⍳';')∊'V;':'BAD LOCAL DECLARATION'SIGNAL SELECT msk⌿x↓⍵
		⊃⌽+⍀('('=nt)-')'=nt←x↑nt:'UNBALANCED HEADER'SIGNAL SELECT (≢nt)↑⍵
		ti←p[⍺] ⋄ ki←ti,⍺,(≢nt)↑⍵ ⋄ zt st←¯2↑(⊂''),'←'(≠⊆⊢)nt
		0=≢st:'EMPTY SIGNATURE'SIGNAL SELECT (≢nt)↑⍵
		k[⍺]+←4×hsz←'←'∊nt ⋄ k[⍺]+←64×shy←'{'=⊃zt ⋄ k[⍺]+←256×stz←'('∊zt
		~∧⌿'V'=x↓(-x←shy+stz)↓zt:'BAD RETURN SPEC'SIGNAL SELECT (≢zt)↑⍵
		n[⍺]+←stz×(2*16)×zc←+⌿'V'=zt
		k[⍺]+←128×str←')'=⊃⌽st ⋄ k[⍺]+←32×amb←'{'=⊃st
		k[⍺]+←hsr←1<≢st ⋄ n[⍺]+←str×rc←hsr⌈str×+⌿∧⍀'V'=1↓⌽st
		st←(amb↑1↑1↓st),(3×amb)↓(-rc+2×str)↓st
		6=cs←(,'V')'VV' '(VV)' 'V(VV)' '(VVV)' 'V(VVV)'⍳⊂st:{
			'BAD TRAD-FNS HEADER'SIGNAL SELECT (≢nt)↑⍵
		}⍵
		k[⍺]+←cs⊃0 2 8 10 24 26
		fi←zc++⌿1 1 2 2 2 2×(hk←⌽(9⍴2)⊤k[⍺])[1 2 3 5 6 8]
		k[⍵[fi+1+(⌈⌿1 2×hk[3 4])+str+⍳rc]]←1
		k[⍵[hk[1]↑fi-1+amb+2×hk[3]]]←1
		k[⍵[shy+stz+⍳zc]]←1
		n[p[⍺]]←n[fi⊃⍵] ⋄ k[fi⊃⍵]←¯99 ⋄ k[p[⍺]]←1++⌿hk[0 3 4]
	0}⌸i←⍸t[p]=H
	n t k pos end⌿⍨←⊂msk←(t∊0 P V)⍲k=¯99 ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p

	⍝ Drop/eliminate any Z nodes that are empty or blank
	_←p[i]{msk[⍺,⍵]←~∧⌿IN[pos[⍵]]∊WS}⌸i←⍸(t[p]=Z)∧p≠⍳≢p⊣msk←t≠Z
	n t k pos end(⌿⍨)←⊂msk ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p

	⍝ Parse :Namespace syntax into M nodes
	nss←(t=K)∧n∊-sym⍳⎕C⊂':NAMESPACE' ⋄ nse←(t=K)∧n∊-sym⍳⎕C⊂':ENDNAMESPACE'
	ERR←':NAMESPACE KEYWORD MAY ONLY APPEAR AT BEGINNING OF A LINE'
	∨⌿msk←Z≠t⌿⍨1⌽nss:ERR SIGNAL SELECT ⍸msk
	ERR←'NAMESPACE DECLARATION MAY HAVE ONLY A NAME OR BE EMPTY'
	msk←(Z≠t⌿⍨¯1⌽nss)∧(V≠t⌿⍨¯1⌽nss)∨Z≠t⌿⍨¯2⌽nss
	∨⌿msk:ERR SIGNAL SELECT ⍸msk
	ERR←':ENDNAMESPACE KEYWORD MUST APPEAR ALONE ON A LINE'
	∨⌿msk←Z≠t⌿⍨⊃1 ¯1∨.⌽⊂nse:ERR SIGNAL SELECT ⍸msk
	t[nsi←⍸1⌽nss]←M ⋄ t[nei←⍸1⌽nse]←-M
	n[i]←n[2+i←⍸(t=M)∧V=2⌽t] ⋄ end[nsi]←end[nei]
	x←⍸p=⍳≢p ⋄ d←+⍀(t[x]=M)+-t[x]=-M
	0<⊃⌽d:':NAMESPACE NOT CLOSED'SIGNAL lineof pos[x[⊃⌽⍸(d=⊃⌽d)∧2<⌿0⍪d]]
	∨⌿0>d:'EXCESSIVE :ENDNAMESPACE'SIGNAL lineof pos[x[⊃⍸d<0]]
	p[x]←x[D2P ¯1⌽d]
	msk←~nss∨((¯1⌽nss)∧t=V)∨nse∨1⌽nse
	t k n pos end⌿⍨←⊂msk ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p

	⍝ Parse guards to (G (Z ...) (Z ...))
	_←p[i]{
		0=+⌿m←K=t[⍵]:⍬
		⊃m:'EMPTY GUARD TEST EXPRESSION'SIGNAL pos[⊃⍵]
		1<+⌿m:'TOO MANY GUARDS'SIGNAL pos[m⌿⍵]
		t[⍺]←G ⋄ p[ti←gz⊃tx cq←2↑(⊂⍬)⍪⍨⍵⊂⍨1,¯1↓m]←⍺ ⋄ k[ti]←1
		ci←≢p ⋄ p,←⍺ ⋄ t k pos end⍪←0 ⋄ n,←0 ⋄ k[gz cq,ci]←1
	0}⌸i←⍸t[p[p]]=F
	
	⍝ Delete keywords we can't handle
	t k n pos end⌿⍨←⊂msk←t≠K ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p

	⍝ Parse brackets and parentheses into ¯1 and Z nodes
	_←p[i]{
		x←IN[pos[⍵]]
		pd←+⍀(x∊'[(')+-pc←x∊'])'
		0<⊃⌽pd:'MISMATCHED PARENS/BRACKETS'SIGNAL pos[⍵⌿⍨⌽∧⍀⌽pd=⊃⌽pd]
		∨⌿0>pd:'MISMATCHED PARENS/BRACKETS'SIGNAL pos[⍵⌿⍨∨⍀pd<0]
		pcp←pc⌿pp←D2P ¯1⌽pd
		msk←x[pcp]≠'[('[pt←')'=pc⌿x]
		∨⌿msk:'OVERLAPPING PAREN/BRACKET'SIGNAL pos[⍵[(⍸,pp⌿⍨)pc⍀msk]]
		p[⍵]←(⍺,⍵)[1+¯1@{⍵=⍳≢⍵}pp]
		t[⍵[pcp]]←¯1 Z[pt] ⋄ end[⍵[pcp]]←end[pc⌿⍵]
	0}⌸i←⍸(t[p]=Z)∧p≠⍳≢p
	t k n pos end⌿⍨←⊂msk←~IN[pos]∊')' ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p

	⍝ Convert ; groups within brackets into Z nodes
	_←p[i]{
		k[z←⊃⍪⌿gz¨g←⍵⊂⍨¯1⌽IN[pos[⍵]]∊';]']←1
		t[z]←Z P[m←1=≢¨g] ⋄ n[m⌿z]←-sym⍳⊂,';'
	0}⌸i←⍸t[p]=¯1

	⍝ Convert formal nodes ⍺/⍵ and system variables to P nodes
	t[⍸(t=S)∨(t=A)∧n∊¯1 ¯2]←P

	⍝ Convert M nodes to F0 nodes
	t←F@{t=M}t

	⍝ Parse niladic tokens to A0 nodes
	t[i←⍸n∊-sym⍳,¨'⎕⍞']←A ⋄ k[i]←0

	⍝ Unify A1, N, and C tokens to A1 nodes
	t k(⊣@(⍸t∊N C))⍨←A 1

	⍝ Mark binding primitives
	bp←n∊-sym⍳,¨'←' '⍠←' '∘←'

	⍝ Check for empty bindings
	i←p[i]{⊃⌽⍵}⌸i←⍸(t[p]=Z)∧p≠⍳≢p
	∨⌿msk←bp[i]:{
		'EMPTY ASSIGNMENT VALUE'SIGNAL SELECT msk⌿p[i]
	}⍬
	
	⍝ We use vb to link variables to their binding
	vb←¯1⍴⍨≢p ⋄ vb[i]←i←⍸(t=T)∨t[p]=H
	
	⍝ Wrap binding values in Z nodes and link
	nz←(≢p)+⍳≢bi←bp[i]⌿⊃i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸(t[p]=Z)∧p≠⍳≢p
	p,←(np≥≢p)⌿¯1⌽np←(bp[i]∨~km)⌿nz@{bp[i]}i
	t k n pos end,←(≢nz)⍴¨Z 0 0(1+pos[bi])(end[p[bi]])
	p[km⌿i]←np[¯1+km⌿+⍀¯1⌽bp[i]∨~km]
	vb,←bt←i⌿⍨1⌽bp[i]

	⍝ Enclosing frames and lines for all nodes
	rz←p I@{(t[⍵]∊G H Z)⍲(t[p[⍵]]∊F G T)∨p[⍵]=⍵}⍣≡⍳≢p
	r←I@{t[0⌈⍵]=G}⍨I@{rz∊p[i]⊢∘⊃⌸i←⍸t[p]=G}⍨¯1@{~t[⍵]∊F G T}p[rz]
		
	⍝ Link dfns bound names to canonical binding
	bm←(t[r]∊F G)∧(t=V)∨(t=A)∧k∊0
	bm←{bm⊣p[i]{bm[⍺]←(V ¯1≡t[⍵])∨∧⌿bm[⍵]}⌸i←⍸(~bm[p])∧t[p]=Z}⍣≡bm
	bm[⍸(≠p)∧(t=P)∧(n=¯2)∧(t[p[p]]=F)∧1⌽n=-sym⍳⊂,'←']←1
	vb[msk⌿⍸bm]←i⌿⍨msk←¯1≠i←(nz,¯1)[bt⍳⍸msk⍪0][bm⌿+⍀0⍪msk←2>⌿bm]
	
	⍝ Mark lexical scope of non-variable primitives and trad-fns locals
	lx←(≢p)⍴0 ⋄ lx[⍸t=P]←3 ⋄ lx[⍸(t=F)∨(t=P)∧n∊-1+⍳6]←4

	⍝ Link local variables to bindings
	i←⍸t∊T V ⋄ i←i[⍋n[i],r[i],pos[rz[i]],⍪end[rz[i]]-pos[i]]
	b←(0,i)[1+b⍸⍥⍸~b←vb[i]≠¯1] ⋄ i⌿⍨←~b ⋄ vb[i]+←(1+b)∧(n[i]=n[b])∧r[i]=r[b]

	⍝ Link free variables to bindings
	fb←⍸(t=T)∨(t[p]=H)∨(t=V)∧t[0⌈vb]=Z
	fr←n[fb],⍪r[fb] ⋄ fb fr⌿⍨←⊂≠fr ⋄ fb,←¯1
	i←⍸(t=V)∧vb=¯1 ⋄ ir←n[i],⍪r[r][i] ⋄ fvr←r[i] ⋄ fvi←i ⋄ lx[i]←1
	_←{vb[i]←j←fb[fr⍳ir] ⋄ i ir⌿⍨←⊂j=¯1 ⋄ fvr,←⊢/ir ⋄ fvi,←i ⋄ ir[;1]←r[⊢/ir]}⍣≡⊢/ir
	
	⍝ Link shadowed variables to bindings
	j←⍸(t=V)∧(t[r]=T)∧t[0⌈vb]=T ⋄ ir←(I@{t[0⌈⍵]≠T}⍣≡⍨r)[i]
	_←{
		vb[i]⌈←x←fb[fr⍳n[i],⍪ir] ⋄ i ir⌿⍨←⊂x=¯1 ⋄ fvr,←ir ⋄ fvi,←i
		msk←vb[j]∘.=ir ⋄ i←msk⌿⍥,(⍴msk)⍴i ⋄ ir←r[j]⌿⍨+/msk
	}⍣≡ir

	⍝ Create closures for functions and trad-fn references
	i←j,⍸(t∊F T)∧k≠0 ⋄ fvi fvr⌿⍨←⊂≠n[fvi],⍪fvr ⋄ k[j]←k[vb[j]]
	np←(≢p)+⍳≢i ⋄ p r fvi I⍨←⊂np@i⊢⍳≢p
	p,←i ⋄ t k n vb r lx pos end(⊣,I)←⊂i ⋄ t[i]←C
	p,←fvr ⋄ t k n vb lx pos end(⊣,I)←fvi ⋄ r,←r[fvr] ⋄ rz,←rz[fvr]
	msk←vb[j]∘.=fvr ⋄ i←msk⌿⍥,(⍴msk)⍴fvi ⋄ ir←j⌿⍨+/msk
	p,←ir ⋄ t k n vb lx pos end(⊣,I)←i ⋄ r,←r[ir] ⋄ rz,←rz[ir]
	
	⍝ Link bindings to their 1st assignments
	fr←⍸t=T ⋄ fh←(≢fr)⍴⍬ ⋄ fb←(≢fr)⍴⍬
	_←r[i]{fh[fr⍳⍺]←⍵}⌸i←⍸t[p]=H
	_←r[i]{fb[fr⍳⍺]←(≠n[x])⌿x←⍵[⍋n[⍵],pos[rz[⍵]],end[rz[⍵]]-pos[⍵]]}⌸i←⍸(t=Z)∧vb≠¯1
	i←⍸(t=V)∧(t[r]=T)∧t[0⌈vb]=T ⋄ ir←fr⍳r[i] ⋄ ib←fr⍳vb[i]
	_←{
		fb[ir]{
			z←fh[ib]{(~n[vb[⍵]]∊n[⍺])⌿⍵}fb[ib]
			x←n[vb[⍺]],r[⍺],pos[rz[⍺]],⍪end[rz[⍺]]-pos[⍺]
			y←n[vb[z]],(≢z)⌿r[⍵],pos[rz[⍵]],⍪end[rz[⍵]]-pos[⍵]
			(≠n[vb[z]])⌿z←(⍺,z)[⍋x,y]
		}←i
	fb}⍣≡fb
	vb[i]←fb[r[i]]{(⍺,¯1)[n[vb[⍺]]⍳⍵]}¨n[i←⍸t[p]=H]
	
	⍝ Specialize functions to specific formal binding types
	_←{r[⍵]⊣x×←rc[⍵]}⍣≡r⊣x←rc←1 1 2 4 8[k[i]]@(i←⍸t∊F T)⊢(≢p)⍴1
	j←(+⍀x)-x ⋄ ro←∊⍳¨x ⋄ p t k n r vb rc lx pos end⌿⍨←⊂x
	p r{j[⍺]+⍵}←⊂⌊ro÷rc ⋄ vb[i]←j[vb[i]]+⌊ro[i]÷(x⌿x)[i]÷x[vb[i←⍸vb>0]]
	k[i]←0 1 2 4 8[k[i]](⊣+|)ro[i←⍸t∊F T]

	⍝ Link monadic dfns ⍺ formals to ⍺← bindings
	msk←(n=¯2)∧k[r]∊2+2×⍳7 ⋄ j←(⍸msk)~i←msk[i]⌿i←vb⌿⍨(t=Z)∧vb≠¯1
	vb[j]←(i,¯1)[(r[i],⍪n[i])⍳r[j],⍪n[j]]
	
	⍝ Unbound variables are lx=¯1
	lx[⍸(t=V)∧vb=¯1]←¯1

	⍝ Mark formals with their appropriate kinds
	k[⍸(t=P)∧n=¯2]←0
	k[i]←(0 0,14⍴1)[k[r[i←⍸(t=P)∧(n∊¯1 ¯2)∧vb=¯1]]]
	k[i]←(¯16↑12⍴2⌿1 2)[k[r[i←⍸(t=P)∧n=¯3]]]
	k[i]←(¯16↑4⌿1 2)[k[r[i←⍸(t=P)∧n=¯4]]]
	i←i[⍋p[i←⍸t[p]=H]] ⋄ j←i⌿⍨≠p[i] ⋄ hk←(9⍴2)⊤k[p[j]] ⋄ hn←16 16⊤n[p[j]]
	zc←hk[6;]⌈hn[0;]×hk[0;]
	ix←∊hk[8;]⌿(j+zc++⌿hk[4 5 7;])+⍳¨hk[8;]⌈hn[1;]×hk[1;]
	iy←hk[7;]⌿j+zc
	iz←∊hk[6;]⌿j+⍳¨zc
	im←hk[5;]⌿j+zc+hk[7;]
	id←(hk[5;]⌿hk[4;])⌿im+1
	k[ix,iy,iz]←1 ⋄ k[im]←(¯16↑12⍴2⌿1 2)[k[r[im]]] ⋄ k[id]←(¯16↑4⌿1 2)[k[r[id]]]
	
	⍝ Error if brackets are not addressing something
	∨⌿msk←(≠p)∧t=¯1:{
		EM←'BRACKET SYNTAX REQUIRES FUNCTION OR ARRAY TO ITS LEFT'
		EM SIGNAL SELECT ⍸msk
	}⍬

	⍝ Infer the type of groups and variables
	v←⍸(t=V)∧(k=0)∧vb≥0
	zp←p[zi←{⍵[⍋p[⍵]]}⍸(t[p]=Z)∧(k[p]=0)∧t≠¯1] ⋄ za←zi⌿⍨≠zp ⋄ zc←zi⌿⍨⌽≠⌽zp ⋄ z←p[za]
	_←{
		zb←(⌽≠⌽p[zb])⌿zb←zi⌿⍨(zp∊z)∧(k[zi]≠1)∨(≠zp)∧k[zi]=1
		nk←k[za]×(k[za]≠0)∧za=zc
		nk+←3×(nk=0)∧k[za]=4
		nk+←(|k[zc])×(nk=0)∧k[zc]∊¯3 ¯4
		nk+←2×(nk=0)∧(k[zc]∊2 3 5)∨4=|k[zb]
		nk+←(nk=0)∧((t[zc]=A)∨1=|k[zc])∧(t[zb]=V)⍲k[zb]=0
		k[z]←nk ⋄ k[vb[msk⌿z]]←nk⌿⍨msk←vb[z]≥0 ⋄ k[v]←k[vb[v]]
		z za zc⌿⍨←⊂nk=0 ⋄ v⌿⍨←k[v]=0
		v z
	}⍣≡⍬
	k[⍸(t∊V Z)∧k=0]←1
	
	⍝ Wrap non-array bindings as B2+(V, Z)
	i←⍸(t[vb⌈0]=Z)∧(k[vb⌈0]≠1)∧n∊-sym⍳,¨'←' '⍠←' '∘←'
	p[vb[vb[i]]]←i ⋄ p[vb[i]]←i ⋄ t[i]←B ⋄ k[i]←k[vb[i]]
	pos[i]←pos[vb[vb[i]]] ⋄ end[i]←end[vb[i]]
	
	⍝ Enclose V+[X;...] in Z nodes for parsing
	i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸(t[p]=Z)∧p≠⍳≢p
	msk←km∧(t[i]=A)∨(t[i]∊P V Z)∧k[i]=1
	msk∧←(0,gm⌿km⍲k[i]=4)[+⍀gm←2<⌿0⍪msk]
	msk∧←(0,(2>⌿msk⍪0)⌿1⌽km∧t[i]=¯1)[+⍀2<⌿0⍪msk]
	j←i⌿⍨jm←2>⌿0⍪msk ⋄ np←(≢p)+⍳≢j ⋄ p←(np@j⍳≢p)[p] ⋄ p,←j
	t k n lx pos end(⊣,I)←⊂j ⋄ t[j]←Z ⋄ k[j]←1
	p[msk⌿i]←j[msk⌿¯1++⍀2<⌿0⍪msk]
	
	⍝ Parse plural value sequences to A7 nodes
	i←|i⊣km←0<i←∊p[i](⊂-⍤⊣,⊢)⌸i←⍸t[p]=Z
	msk∧←⊃1 ¯1∨.⌽⊂msk←km∧(t[i]=A)∨(t[i]∊P V Z)∧k[i]=1
	np←(≢p)+⍳≢ai←i⌿⍨am←2>⌿msk⍪0 ⋄ p←(np@ai⍳≢p)[p] ⋄ p,←ai
	t k n lx pos end(⊣,I)←⊂ai
	t k n lx pos(⊣@ai⍨)←A 7 0 0(pos[i⌿⍨km←2<⌿0⍪msk])
	p[msk⌿i]←ai[¯1++⍀km⌿⍨msk←msk∧~am]

	⍝ Rationalize F[X] syntax
	_←p[i]{
		⊃m←t[⍵]=¯1:'SYNTAX ERROR:NOTHING TO INDEX' SIGNAL SELECT ⍵
		k[⍵⌿⍨m∧¯1⌽(k[⍵]∊2 3 5)∨¯1⌽k[⍵]=4]←4
	0}⌸i←⍸(t[p]=Z)∧(p≠⍳≢p)∧k[p]∊1 2
	i←⍸(t=¯1)∧k=4 ⋄ j←⍸(t[p]=¯1)∧k[p]=4
	(≢i)≠≢j:{
		msg←'AXIS REQUIRES SINGLE AXIS EXPRESSION'
		msg SIGNAL ∊pos[⍵]+⍳¨end[⍵]-pos[⍵]
	}⊃⍪⌿{⊂⍺⌿⍨1<≢⍵}⌸p[j]
	∨⌿msk←t[j]≠Z:{
		msg←'AXIS REQUIRES NON-EMPTY AXIS EXPRESSION'
		msg SIGNAL ∊pos[⍵]+⍳¨end[⍵]-pos[⍵]
	}msk⌿p[j]
	p[j]←p[i] ⋄ t[i]←P ⋄ lx[i]←3 ⋄ end[i]←1+pos[i]

	⍝ Wrap V[X;...] expressions as A¯1 nodes
	i←⍸t=¯1 ⋄ p←(p[i]@i⍳≢p)[p] ⋄ t[p[i]]←A ⋄ k[p[i]]←¯1
	p t k n lx pos end⌿⍨←⊂t≠¯1 ⋄ p(⊣-1+⍸⍨)←i

	⍝ Parse ⌶* nodes to V nodes
	i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸p∊p[j←⍸pm←(t=P)∧n∊ns←-sym⍳,¨'⌶' '⌶⌶' '⌶⌶⌶' '⌶⌶⌶⌶']
	∨⌿msk←(i∊j)∧¯1⌽km∧(t[i]=A)⍲k[i]=1:{
		msg←'INVALID ⌶ SYNTAX'
		msg SIGNAL SELECT i⌿⍨msk∨¯1⌽msk
	}⍬
	vi←i⌿⍨1⌽msk←i∊j ⋄ pi←msk⌿i
	t[vi]←V ⋄ k[vi]←2 3 4 1[ns⍳n[pi]] ⋄ lx[vi]←5 ⋄ end[vi]←end[pi]
	p t k n lx pos end⌿⍨←⊂~pm ⋄ p(⊣-1+⍸⍨)←⍸pm

	⍝ Group function and value expressions
	i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸(t[p]=Z)∧(p≠⍳≢p)∧k[p]∊1 2

	⍝ Mask and verify dyadic operator right operands
	∨⌿msk←(dm←¯1⌽(k[i]=4)∧t[i]∊C P V Z)∧(~km)∨k[i]∊0 3 4:{
		'MISSING RIGHT OPERAND'SIGNAL SELECT msk⌿i
	}⍬

	⍝ Refine schizophrenic types
	k[i⌿⍨(k[i]=5)∧dm∨¯1⌽(~km)∨(~dm)∧k[i]∊¯1 0 1 6 7]←2 ⋄ k[i⌿⍨k[i]=5]←3

	⍝ Mask and verify monadic and dyadic operator left operands
	jm←(t[i]=P)∧n[i]∊-sym⍳⊂,'∘.'
	∨⌿msk←jm∧1⌽(~km)∨k[i]∊3 4:{
		'MISSING OPERAND TO ∘.'SIGNAL SELECT msk⌿i
	}⍬
	∨⌿msk←jm∧1⌽k[i]≠2:{
		'∘. REQUIRES FUNCTION OPERAND'SIGNAL SELECT msk⌿i
	}⍬
	∨⌿msk←(dm∧¯2⌽~km)∨(¯1⌽~km)∧mm←(~jm)∧(k[i]=3)∧t[i]∊C P V Z:{
		'MISSING LEFT OPERAND'SIGNAL SELECT msk⌿i
	}⍬

	⍝ Parse function expressions
	msk←jm∨dm∨mm ⋄ np←(≢p)+⍳xc←≢oi←msk⌿i ⋄ p←(np@oi⍳≢p)[p]
	p,←oi ⋄ t k n lx pos end(⊣,I)←⊂oi
	jl←¯1⌽jm ⋄ ml←(jm∧2⌽mm)∨(~jl)∧1⌽mm ⋄ dl←(jm∧3⌽dm)∨(~jl)∧2⌽dm
	p[g⌿i]←oi[(g←(~msk)∧(1⌽dm)∨om←jl∨ml∨dl)⌿(xc-⌽+⍀⌽msk)-jl]
	p[g⌿oi]←(g←msk⌿om)⌿1⌽oi ⋄ t[oi]←O ⋄ n[oi]←0
	pos[oi]←pos[g⌿i][msk⌿¯1++⍀g←jm∨(~msk)∧ml∨dl] ⋄ end[jm⌿i]←end[jl⌿i]
	ol←1+(k[i⌿⍨1⌽om]=4)∨k[i⌿⍨om]∊2 3 ⋄ or←(msk⌿dm)⍀1+k[dm⌿i]=2
	k[oi]←3 3⊥↑or ol

	⍝ Parse value expressions
	i km←⍪⌿p[i]{(⍺⍪⍵)(0,(2≤≢⍵)∧1∨⍵)}⌸i←⍸(t[p]=Z)∧(k[p]=1)∧p≠⍳≢p
	msk←m2∨fm∧~¯1⌽m2←km∧(1⌽km)∧~fm←(t[i]=O)∨(t[i]≠A)∧k[i]=2
	t,←E⍴⍨xc←+⌿msk ⋄ k,←msk⌿msk+m2 ⋄ n,←xc⍴0 ⋄ lx,←xc⍴0
	pos,←pos[msk⌿i] ⋄ end,←end[p[msk⌿i]]
	p,←msk⌿¯1⌽(i×~km)+km×x←¯1+(≢p)++⍀msk ⋄ p[km⌿i]←km⌿x

	⍝ Unparsed Z nodes become Z¯2 syntax error nodes
	k[⍸(t=Z)∧(k=2)∧(t[p]=E)∧k[p]=6]←¯2
	k[zs⌿⍨1<1⊃zs zc←↓⍉p[i],∘≢⌸i←⍸(t[p]=Z)∧p≠⍳≢p]←¯2
	_←{p[⍵]⊣msk∧←msk[⍵]}⍣≡p⊣msk←(t[p]=Z)⍲k[p]=¯2
	p t k n lx pos end⌿⍨←⊂msk ⋄ p(⊣-1+⍸⍨)←⍸~msk

	⍝ Check for invalid types
	∨⌿msk←(≠p)∧(t[p]=G)∧k>1:{
		msg←'GUARD TESTS MUST BE ARRAY VALUES'
		msg SIGNAL SELECT ⍸msk
	}⍬

	⍝ Include parentheses in source range
	ip←p[i←⍸(t[p]=Z)∧n[p]∊-sym⍳⊂,'('] ⋄ pos[i]←pos[ip] ⋄ end[i]←end[ip]

	⍝ Eliminate non-error Z nodes from the tree
	zi←p I@{t[p[⍵]]=Z}⍣≡ki←⍸msk←(t[p]=Z)∧t≠Z
	p←(zi@ki⍳≢p)[p] ⋄ t k n lx pos end(⊣@zi⍨)←t k n lx pos end I¨⊂ki
	p t k n lx pos end⌿⍨←⊂msk←msk⍱(t=Z)∧k≠¯2 ⋄ p(⊣-1+⍸⍨)←⍸~msk
	
	⍝ Merge simple arrays into single A1 nodes
	msk←((t=A)∧0=≡¨sym[|0⌊n])∧(t[p]=A)∧k[p]=7
	pm←(t=A)∧k=7 ⋄ pm[p]∧←msk ⋄ msk∧←pm[p]
	k[p[i←⍸msk]]←1 ⋄ _←p[i]{0=≢⍵:0 ⋄ n[⍺]←-sym⍳sym∪←⊂⍵}⌸sym[|n[i]]
	p t k n lx pos end⌿⍨←⊂~msk ⋄ p←(⍸msk)(⊢-1+⍸)p
	
	⍝ All A1 nodes should be lexical scope 6
	lx[⍸(t=A)∧k=1]←6

	⍝ Check for bindings/assignments without targets
	bp←(t=P)∧n∊-sym⍳,¨'←' '⍠←' '∘←'
	∨⌿msk←bp∧((k=2)∧(t[p]=E)⍲k[p]=2)∨(k=3)∧(t[p][p]=E)⍲k[p][p]=2:{
		ERR←'MISSING ASSIGNMENT TARGET'
		ERR SIGNAL SELECT p[⍸msk∧k=2],p[p][⍸msk∧k=3]
	}⍬
	
	⍝ Convert assignment expressions to E4 nodes, bindings to B nodes
	i←p[⍸bp∧k=2] ⋄ k[i]←4
	i←p[⍸(≠p)∧(t[p]=E)∧(t[p]=4)∧(t=V)∨(t=A)∧k∊0 7] ⋄ t[i]←B ⋄ k[i]←1
	i←p[p][⍸bp∧k=3] ⋄ k[i]←4
		
	⍝ Rationalize V[X;...] → E2(V, P2([), E6)
	i←i[⍋p[i←⍸(t[p]=A)∧k[p]=¯1]] ⋄ msk←~2≠⌿¯1,ip←p[i] ⋄ ip←∪ip ⋄ nc←2×≢ip
	t[ip]←E ⋄ k[ip]←2 ⋄ n[ip]←0 ⋄ p[msk⌿i]←msk⌿(≢p)+1+2×¯1++⍀~msk
	p,←2⌿ip ⋄ t,←nc⍴P E ⋄ k,←nc⍴2 6 ⋄ n,←nc⍴-sym⍳,¨'[' '' ⋄ lx,←nc⍴3 0
	pos,←2⌿pos[ip] ⋄ end,←∊(1+pos[ip]),⍪end[ip] ⋄ pos[ip]←pos[i⌿⍨~msk]
	
	⍝ Check for nested ⍠← forms
	∨⌿msk←(t=B)∧(n∊-sym⍳⊂'⍠←')∧t[p]≠F:{
		ERR←'⍠← MUST BE THE LEFTMOST FORM IN AN UNGUARDED EXPRESSION'
		ERR SIGNAL SELECT ⍸msk
	}⍬
	
	⍝ Compute exports
	msk←∘∘∘
	xt←k[xn] ⋄ xn←sym[|n[xn]]

	⍝ Sort AST by depth-first pre-order traversal
	d i←P2D p ⋄ p d t k n lx pos end I∘⊢←⊂i ⋄ p←i⍳p

	(p d t k n lx pos end)(xn xt)sym IN
}
