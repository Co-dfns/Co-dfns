TT←{
	(p d t k n lx pos end)exp sym IN←⍵

	⍝ Compute reference scope
	r←I@{t[⍵]≠F}⍣≡⍨p

	⍝ Convert ⎕NC calls to static A1 nodes
	pi←p[i←⍸mi←(t[p]=E)∧(t=P)∧n=-sym⍳⊂'⎕nc'] ⋄ j←⍸mj←(p∊pi)∧~mi ⋄ x←⍸mx←p∊j
	
	∨⌿msk←k[pi]≠1:'MUST APPLY ⎕NC MONADICALLY'SIGNAL SELECT msk⌿pi	
	∨⌿msk←(t[j]≠A)∨~k[j]∊1 7:{
		ERR←'ONLY LITERAL ARGUMENTS TO ⎕NC ARE SUPPORTED'
		16 ERR SIGNAL SELECT msk⌿j
	}⍬
	∨⌿msk←(t[x]≠A)∨k[x]≠1:{
		ERR←'ONLY SIMPLE/NESTED CHAR VECTORS TO ⎕NC ARE SUPPORTED'
		16 ERR SIGNAL SELECT msk⌿x
	}⍬
	
	ncvar←'⍺' '⍺⍺' '⍵⍵'
	ncmap←(0 0 0)(0 0 0)(0 0 0)(2 0 0),,⍉⊃∘.,⌿(0 2)(2 3)(0 2 3)
	vx←x,j1←j⌿⍨k[j]=1 ⋄ vp←p[p[x]],p[j1]
	_←vp{n[⍺]←-sym⍳sym∪←⊂(k[r[⍺]]⊃ncmap)[ncvar⍳sym[|n[⍵]]]}⌸⍣(0≠≢vx)⊢vx
	t[pi]←A ⋄ k[pi]←1
	p t k n lx r pos end⌿⍨←⊂~msk←mi∨mj∨mx ⋄ p r(⊣-1+⍸⍨)←⊂⍸msk

	⍝ Convert O*(F, [, A) to Ox(F, A)
	i←⍸msk←(t[p]=O)∧n=-sym⍳⊂,'[' ⋄ k[p[i]]←¯1
	p t k n lx r pos end⌿⍨←⊂~msk ⋄ p r(⊣-1+⍸⍨)←⊂i
	⍝ axfns←,¨'⌷↓,'
	⍝ 0≠≢i←⍸(≠p)∧(t[p]=O)∧(k[p]=¯1)∧~n∊-sym⍳axfns:{
	⍝ 	ERR←2 'FUNCTION DOES NOT SUPPORT AXIS OPERATOR' 
	⍝	ERR SIGNAL SELECT i
	⍝ }⍬
	
	⍝ Mark ⍠← bindings as kind 7
	k[⍸(t=B)∧n=-sym⍳⊂'⍠←']←7
	
	⍝ Merge B node bindings
	n lx{⍺[⍵]@(p[⍵])⊢⍺}←⊂⍸msk←(≠p)∧(t∊V P)∧t[p]=B
	p t k n lx r pos end⌿⍨←⊂~msk ⋄ p r(⊣-1+⍸⍨)←⊂⍸msk
	
	⍝ Mark mutated bindings 
	rn←r,⍪n ⋄ rni←rn[i←⍸msk←(t∊B E V)∧(lx∊0 1)∧n<¯6;] ⋄ mu←(≢i)⍴0
	j←⍸msk∧(t[p]=C)∨(t=E)∧k=4
	_←{mu[⍸rni∊⍥↓rn[⍵;]]←1 ⋄ i⌿⍨rni∊⍥↓r[r[z]],⍪n[z←⍵⌿⍨lx[⍵]=1]}⍣≡j
	ci←p[fi←⍸(t=F)∧k≠0]
	mu←msk⍀1@{(↓rni)∊⊃⍪⌿{n[⍵],¨⍨fi⌿⍨ci=p[⍵]}¨i⌿⍨⍵∧t[p[i]]=C}⍣≡mu

	⍝ Delete ⍺← forms for dyadic specializations
	msk←p(⊢∧I⍨)⍣≡~(t=B)∧(n=¯2)∧k[r]∊3+2×⍳7
	p t k n lx mu r pos end⌿⍨←⊂msk ⋄ p r(⊣-1+⍸⍨)←⊂⍸~msk

	⍝ Lift dfns to the top-level
	p,←n[i]←(≢p)+⍳≢i←⍸(t=F)∧p≠⍳≢p ⋄ t k n lx mu pos end r(⊣,I)←⊂i
	p r I⍨←⊂n[i]@i⊢⍳≢p ⋄ t[i]←V

	⍝ Wrap expressions as binding or return statements
	i←(⍸(~t∊F G)∧t[p]=F),¯1~⍨p[i]{⊃⌽2↑⍵,¯1}⌸i←⍸t[p]=G
	p t k n lx mu r pos end⌿⍨←⊂m←2@i⊢1⍴⍨≢p
	p r i I⍨←⊂j←(+⍀m)-1 ⋄ n←j I@(0≤⊢)n ⋄ p[i]←j←i-1
	k[j]←-(k[r[j]]=0)∨0@({⊃⌽⍵}⌸p[j])⊢(t[j]=B)∨(t[j]=E)∧k[j]=4
	t[j]←E
	
	⍝ Convert print bindings to E1(P2(⎕⍞), ∘∘∘)
	i←p[j←⍸(≠p)∧(t[p]=B)∧(t=A)∧k=0]
	t[i]←E ⋄ k[i]←1 ⋄ t[j]←P ⋄ k[j]←2 ⋄ lx[j]←3

	⍝ Lift guard tests
	p[i]←p[x←p[i←⍸(≠p)∧t[p]=G]] ⋄ ix←i,x ⋄ xi←x,i ⋄ p←(xi@ix⊢⍳≢p)[p]
	t[ix]←t[xi] ⋄ k[ix]←k[xi] ⋄ n[x]←n[i] ⋄ n[i]←x ⋄ lx[xi]←lx[ix]
	mu[ix]←mu[xi] ⋄ pos[xi]←pos[ix] ⋄ end[xi]←end[ix]
	
	⍝ Count children for E6, and A7 nodes
	_←p[i]{n[⍺]←≢⍵}⌸i←⍸((t[p]=A)∧k[p]=7)∨(t[p]=E)∧k[p]=6
	
	⍝ Lift and flatten expressions
	i←⍸(t∊A B C E G O P Z)∨(t=V)∧t[p]≠C
	p[i]←p[x←p I@{(t[x]∊F G)⍱(t[x]=B)∧k[x←p[⍵]]=7}⍣≡i]
	p t k n lx mu r pos end{⍺[⍵]@i⊢⍺}←⊂j←(⌽i)[⍋⌽x] ⋄ p←(i@j⊢⍳≢p)[p]

	⍝ Compute a function's local and free variables
	lv←(≢p)⍴⊂⍬ ⋄ fv←(≢p)⍴⊂⍬
	lv[r[i]],←i←i⌿⍨≠(r,⍪n)[i←⍸(t∊B V)∧(lx=0)∧n<0;]
	fv[p[i]],←i←⍸(t=V)∧(t[p]=C)∧n<0
	fv[n[i]]←fv[p[i←⍸(t=V)∧(t[p]=C)∧n≥0]]

	⍝ Mark functions with their internal ⍺ type
	⍝    0 1 2 3 4 5 6  7  8  9 10 11 12 13 14 15
	k[i]←0 1 2 4 5 7 8 10 11 13 14 16 17 19 20 22[k[i←⍸t=F]]
	k[r[i]]+←2≤k[i←i⌿⍨≠r[i←⍸(≠p)∧(t=P)∧(n=¯2)∧t[p]=B]]
	
	⍝ Disambiguate schizophrenic functions
	i←⍸(t=P)∧(k=2)∧n∊ns←-sym⍳,¨'/⌿\⍀←'
	sym∪←∪'//' '⌿⌿' '\\' '⍀⍀' '←←'[ns⍳∪n[i]]
	n[i]←(-sym⍳'//' '⌿⌿' '\\' '⍀⍀' '←←')[ns⍳n[i]]

	⍝ Namify pointer variables
	i←⍸(n≥0)∧(t∊B F O P V Z)∨(t=E)∧k≠6
	sym∪←∪x←('ptr',⍕)¨n[i] ⋄ n[i]←-sym⍳x

	⍝ Symbol mapping between primitives and runtime names
	syms ←,¨'+'   '-'   '×'   '÷'   '*'   '⍟'   '|'   '○'   '⌊'  
	nams ←  'add' 'sub' 'mul' 'div' 'exp' 'log' 'res' 'cir' 'min'
	syms,←,¨'⌈'   '!'   '<'   '≤'   '='   '≥'   '>'   '≠'   '~'
	nams,←  'max' 'fac' 'lth' 'lte' 'eql' 'gte' 'gth' 'neq' 'not'
	syms,←,¨'∧'   '∨'   '⍲'   '⍱'   '⌷'   '['   '⍳'   '⍴'   ','  
	nams,←  'and' 'lor' 'nan' 'nor' 'sqd' 'brk' 'iot' 'rho' 'cat' 
	syms,←,¨'⍪'   '⌽'   '⍉'   '⊖'   '∊'   '⊃'   '≡'   '≢'   '⊢'
	nams,←  'ctf' 'rot' 'trn' 'rtf' 'mem' 'dis' 'eqv' 'nqv' 'rgt'
	syms,←,¨'⊣'   '⊤'   '⊥'   '/'   '⌿'   '\'   '⍀'   '?'   '↑'   
	nams,←  'lft' 'enc' 'dec' 'red' 'rdf' 'scn' 'scf' 'rol' 'tke' 
	syms,←,¨'↓'   '¨'   '⍨'   '.'   '⍤'   '⍣'   '∘'   '∪'   '∩'
	nams,←  'drp' 'map' 'com' 'dot' 'rnk' 'pow' 'jot' 'unq' 'int'
	syms,←,¨'←'   '⍋'   '⍒'   '∘.'  '⍷'   '⊂'   '⌹'   '⊆'   '∇'
	nams,←  'mst' 'gdu' 'gdd' 'oup' 'fnd' 'par' 'mdv' 'nst' 'self'
	syms,←,¨'//'  '⌿⌿'  '\\'  '⍀⍀'  '←←'  '⌸'   '⍸'   '⌺'   '@'
	nams,←  'rep' 'rpf' 'xpd' 'xpf' 'set' 'key' 'iou' 'stn' 'at'
	syms,←,¨'⎕'         '⍞'
	nams,←  'println'   'print'
	syms,←,¨';'   '⎕FFT'  '⎕IFFT' '⎕CONV'  '⎕NC'  '⎕SIGNAL'  '⎕DR'
	nams,←  'spn' 'q_fft' 'q_ift' 'q_conv' 'q_nc' 'q_signal' 'q_dr'
	syms,←,¨'⍺'     '⍵'     '⍺⍺'         '⍵⍵'         '∇∇'     '%u'
	nams,←  'alpha' 'omega' 'alphaalpha' 'omegaomega' 'deldel' ''
	syms←⎕C syms

	⍝ Convert all primitives to variables; P → V
	i←⍸t=P ⋄ t[i]←V ⋄ si←syms⍳sym[ni←|n[i]]
	∨⌿msk←(≢syms)=si:6'UNKNOWN PRIMITIVE'SIGNAL SELECT msk⌿i
	sym[ni]←nams[si]

	p t k n lx mu lv fv pos end sym IN
}
