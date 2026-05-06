TT←{
	(p d t k n lx vb pos end)exp sym IN←⍵

	⍝ Report parse errors
	∨⌿msk←(t=X)∧k≠0: SIGNAL SELECT ⍸msk
	
	⍝ Kill the dynamic closures
	t n lx{⍺[⍵]@(p[⍵])⊢⍺}←⊂i←⍸(≠p)∧((t=C)∧vb≥0)[p]
	p t k n lx pos end⌿⍨←⊂msk←{⍵∧⍵[p]}⍣≡~p∊p[i]
	p(⊣-1+⍸⍨)←⍸~msk

	⍝ Kill the contents of X nodes
	p t k n lx pos end⌿⍨←⊂msk←{⍵∧⍵[p]}⍣≡t[p]=X
	p(⊣-1+⍸⍨)←⍸~msk
	
	⍝ Convert E4(APV, APV, O, ...) mod. assignments to E4(APV, APV, C, ...)
	j←p[i←⍸(≠p)∧((t=E)∧k=4)[p][p]∧((t=O)∧(p=¯1⌽p)∧(~⌽≠⌽p)∧¯1⌽t∊A P V)[p]]
	t k n lx pos end(I⊣@j⊣)←⊂i ⋄ msk←p∊j ⋄ p←(j@i⊢⍳≢p)[p]
	p t k n lx pos end⌿⍨←⊂~msk ⋄ p(⊣-1+⍸⍨)←⍸msk
	
	⍝ Convert primitive niladic references to E3(P2) forms
	i←⍸(t=P)∧(k=1)∧'⎕⍞'∊⍨⊃¨sym[|n]
	p,←i ⋄ t n lx pos end(⊣,I)←⊂i ⋄ k,←(≢i)⍴2 ⋄ t[i]←E ⋄ k[i]←3 ⋄ n[i]←0

	⍝ Compute reference scope
	r←I@{msk[⍵]}⍣≡⍨p⊣msk←~t∊F T

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
	t[pi]←A ⋄ k[pi]←1 ⋄ lx[pi]←¯7
	p t k n lx r pos end⌿⍨←⊂~msk←mi∨mj∨mx ⋄ p r(⊣-1+⍸⍨)←⊂⍸msk

	⍝ Convert O*(F, [, A) to Ox(F, A)
	i←⍸msk←(t[p]=O)∧n=-sym⍳⊂,'[' ⋄ k[p[i]]←¯1
	p t k n lx r pos end⌿⍨←⊂~msk ⋄ p r(⊣-1+⍸⍨)←⊂i
	
	⍝ Report empty axis operand
	i←⍸(t=P)∧(n=-sym⍳⊂,';')∧(t[p]=O)∧k[p]=¯1
	0≠≢i:'EMPTY AXIS OPERATOR' SIGNAL SELECT i

	⍝ Mark ⍠← bindings as kind 7
	k[⍸(t=B)∧n=-sym⍳⊂'⍠←']←7

	⍝ Convert B strand targets to B0, S0, and S7 nodes
	msk←~(≠p)∧(t[p]=B)∧(t=A)∧k=7 ⋄ i⌿⍨←~msk[p I@{msk[⍵]}⍣≡i←⍸(t=A)∧k=7]
	t[i]←S ⋄ k[i,ip←p[i←⍸(t=S)∧t[p]=B]]←0 ⋄ n[ip]←0
	
	⍝ Merge B node bindings
	n lx{⍺[⍵]@(p[⍵])⊢⍺}←⊂⍸msk←(≠p)∧(t∊V P)∧t[p]=B
	p t k n lx r pos end⌿⍨←⊂~msk ⋄ p r(⊣-1+⍸⍨)←⊂⍸msk

	⍝ Mark mutated bindings
	i←⍸msk←(t∊B V S)∧(lx∊¯1 ¯2 ¯3)∧n<¯6 ⋄ j←⍸msk∧(t[p]=C)∨(t[p]=E)∧(k[p]=4)∧≠p
	mu←(≢i)⍴0 ⋄ rn←r,⍪n ⋄ rni←rn[i;]
	_←{mu[⍸rni∊⍥↓rn[⍵;]]←1 ⋄ i⌿⍨rni∊⍥↓r[r[z]],⍪n[z←⍵⌿⍨lx[⍵]∊¯2 ¯3]}⍣≡j
	ci←p[fi←⍸t=F]
	mu←msk⍀1@{(↓rni)∊⊃⍪⌿{n[⍵],¨⍨fi⌿⍨ci=p[⍵]}¨i⌿⍨⍵∧t[p[i]]=C}⍣≡mu

	⍝ Delete ⍺← forms for dyadic specializations
	msk←p(⊢∧I⍨)⍣≡~(t=B)∧(n=¯2)∧k[r]∊3+2×⍳7
	p t k n lx mu r pos end⌿⍨←⊂msk ⋄ p r(⊣-1+⍸⍨)←⊂⍸~msk

	⍝ Mark functions with their internal ⍺ type
	⍝    0 1 2 3 4 5 6  7  8  9 10 11 12 13 14 15
	k[i]←0 1 2 4 5 7 8 10 11 13 14 16 17 19 20 22[k[i←⍸t=F]]
	∨⌿msk←2<k[i←i⌿⍨≠r[i←⍸(t=B)∧n=¯2]]:{
		ERR←'⍺ MAY ONLY BE BOUND TO ARRAYS OR FUNCTIONS'
		16 ERR SIGNAL SELECT msk⌿i
	}⍵
	k[r[i]]+←2=k[i]
	
	⍝ Lift dfns to the top-level
	p,←n[i]←(≢p)+⍳≢i←⍸(t=F)∧p≠⍳≢p ⋄ t k n lx mu pos end r(⊣,I)←⊂i
	p r I⍨←⊂n[i]@i⊢⍳≢p ⋄ t[i]←V ⋄ k[i]←3+5 11⍸k[i]

	⍝ Wrap expressions as binding or return statements
	i←(⍸(t[p]∊F T)>t∊F G H T),¯1~⍨p[i]{⊃⌽2↑⍵,¯1}⌸i←⍸t[p]=G
	p t k n lx mu r pos end⌿⍨←⊂m←2@i⊢1⍴⍨≢p
	p r i I⍨←⊂j←(+⍀m)-1 ⋄ n←j I@(0≤⊢)n ⋄ p[i]←j←i-1
	k[j]←-(k[r[j]]=0)∨0@{⌽≠⌽(p×p≠⍳≢p)[j]}(t[j]=B)∨(t[j]=E)∧k[j]=4
	t[j]←E

	⍝ Convert print bindings to E1(P2(⎕⍞), ∘∘∘)
	i←p[j←⍸(≠p)∧(t[p]=B)∧(t=A)∧k=0]
	t[i]←E ⋄ k[i]←1 ⋄ n[i]←0 ⋄ t[j]←P ⋄ k[j]←2 ⋄ lx[j]←¯4

	⍝ Disambiguate schizophrenic functions
	i←⍸(t=P)∧(k=2)∧n∊ns←-sym⍳,¨'/⌿\⍀←'
	sym∪←∪'//' '⌿⌿' '\\' '⍀⍀' '←←'[ns⍳∪n[i]]
	n[i]←(-sym⍳'//' '⌿⌿' '\\' '⍀⍀' '←←')[ns⍳n[i]]

	⍝ Symbol mapping between primitives and runtime names
	syms ←0⍴⊂''	  ⋄ nams ←0 4⍴⊂''
	syms,←⊂,'+'	  ⋄ nams⍪←'add'	       'conjugate'     'plus'			'idxerr'
	syms,←⊂,'-'	  ⋄ nams⍪←'sub'	       'negate'	       'minus'			'idxerr'
	syms,←⊂,'×'	  ⋄ nams⍪←'mul'	       'sign'	       'times'			'idxerr'
	syms,←⊂,'÷'	  ⋄ nams⍪←'div'	       'recip'	       'divide'			'idxerr'
	syms,←⊂,'*'	  ⋄ nams⍪←'exp'	       'exponent'      'power'			'idxerr'
	syms,←⊂,'⍟'	  ⋄ nams⍪←'log'	       'natlog'	       'logarithm'		'idxerr'
	syms,←⊂,'|'	  ⋄ nams⍪←'res'	       'absolute'      'residue'		'idxerr'
	syms,←⊂,'⌊'	  ⋄ nams⍪←'min'	       'floor_array'   'minimum'		'idxerr'
	syms,←⊂,'⌈'	  ⋄ nams⍪←'max'	       'ceil_array'    'maximum'		'idxerr'
	syms,←⊂,'○'	  ⋄ nams⍪←'cir'	       'pitimes'       'trig'			'idxerr'
	syms,←⊂,'!'	  ⋄ nams⍪←'fac'	       'factorial'     'binomial'		'idxerr'
	syms,←⊂,'~'	  ⋄ nams⍪←'not'	       'notscl'	       'without'		'idxerr'
	syms,←⊂,'∧'	  ⋄ nams⍪←'and'	       'andmon'	       'logand'			'idxerr'
	syms,←⊂,'∨'	  ⋄ nams⍪←'lor'	       'lormon'	       'logor'			'idxerr'
	syms,←⊂,'⍲'	  ⋄ nams⍪←'nan'	       'nanmon'	       'lognan'			'idxerr'
	syms,←⊂,'⍱'	  ⋄ nams⍪←'nor'	       'normon'	       'lognor'			'idxerr'
	syms,←⊂,'<'	  ⋄ nams⍪←'lth'	       'lthmon'	       'lessthan'		'idxerr'
	syms,←⊂,'≤'	  ⋄ nams⍪←'lte'	       'sortup'	       'lesseql'		'idxerr'
	syms,←⊂,'='	  ⋄ nams⍪←'eql'	       'eqlmon'	       'equal'			'idxerr'
	syms,←⊂,'≥'	  ⋄ nams⍪←'gte'	       'sortdown'      'greatereql'		'idxerr'
	syms,←⊂,'>'	  ⋄ nams⍪←'gth'	       'gthmon'	       'greaterthan'		'idxerr'
	syms,←⊂,'≠'	  ⋄ nams⍪←'neq'	       'firstocc'      'noteq'			'idxerr'
	syms,←⊂,'⌷'	  ⋄ nams⍪←'sqd'	       'materialize'   'sqd_idx'		'idxerr'
	syms,←⊂,'['	  ⋄ nams⍪←'brk'	       'brkmon'	       'brk'			'brkidx'
	syms,←⊂,'⍴'	  ⋄ nams⍪←'rho'	       'shape'	       'reshape'		'idxerr'
	syms,←⊂,'≡'	  ⋄ nams⍪←'eqv'	       'depth'	       'same'			'idxerr'
	syms,←⊂,'≢'	  ⋄ nams⍪←'nqv'	       'tally'	       'notsame'		'idxerr'
	syms,←⊂,'⍳'	  ⋄ nams⍪←'iot'	       'index_gen'     'index_of'		'idxerr'
	syms,←⊂,'⍸'	  ⋄ nams⍪←'iou'	       'where'	       'interval_idx'		'idxerr'
	syms,←⊂,'⊃'	  ⋄ nams⍪←'dis'	       'first'	       'pick'			'idxerr'
	syms,←⊂,'⊂'	  ⋄ nams⍪←'par'	       'enclose'       'part_enc'		'idxerr'
	syms,←⊂,'⊆'	  ⋄ nams⍪←'nst'	       'nest'	       'partition'		'idxerr'
	syms,←⊂,','	  ⋄ nams⍪←'cat'	       'ravel'	       'catenate'		'idxerr'
	syms,←⊂,'⍪'	  ⋄ nams⍪←'ctf'	       'table'	       'catenatefirst'		'idxerr'
	syms,←⊂,'⌽'	  ⋄ nams⍪←'rot'	       'reverse_last'  'rotate_last'		'idxerr'
	syms,←⊂,'⊖'	  ⋄ nams⍪←'rtf'	       'reverse_first' 'rotate_first'		'idxerr'
	syms,←⊂,'⍉'	  ⋄ nams⍪←'trn'	       'transpose'     'transpose_target'	'idxerr'
	syms,←⊂,'⍋'	  ⋄ nams⍪←'gdu'	       'gdu'	       'gdu'			'idxerr'
	syms,←⊂,'⍒'	  ⋄ nams⍪←'gdd'	       'gdd'	       'gdd'			'idxerr'
	syms,←⊂,'∊'	  ⋄ nams⍪←'mem'	       'enlist'	       'member'			'idxerr'
	syms,←⊂,'∪'	  ⋄ nams⍪←'unq'	       'unique'	       'union'			'idxerr'
	syms,←⊂,'∩'	  ⋄ nams⍪←'int'	       'intmon'	       'int'			'idxerr'
	syms,←⊂,'⍷'	  ⋄ nams⍪←'fnd'	       'fnd'	       'fnd'			'idxerr'
	syms,←⊂,'↑'	  ⋄ nams⍪←'tke'	       'mix'	       'take'			'idxerr'
	syms,←⊂,'↓'	  ⋄ nams⍪←'drp'	       'split'	       'drop'			'idxerr'
	syms,←⊂,'⊢'	  ⋄ nams⍪←'rgt'	       'rgt'	       'rgt'			'idxerr'
	syms,←⊂,'⊣'	  ⋄ nams⍪←'lft'	       'lftid'	       'left'			'idxerr'
	syms,←⊂,'⊤'	  ⋄ nams⍪←'enc'	       'encmon'	       'enc'			'idxerr'
	syms,←⊂,'⊥'	  ⋄ nams⍪←'dec'	       'decmon'	       'dec'			'idxerr'
	syms,←⊂,'?'	  ⋄ nams⍪←'rol'	       'roll'	       'deal'			'idxerr'
	syms,←⊂,'⌹'	  ⋄ nams⍪←'mdv'	       'matinv'	       'matdiv'			'idxerr'
	syms,←⊂,'⎕'	  ⋄ nams⍪←'println'    'println'       'println'		'idxerr'
	syms,←⊂,'⍞'	  ⋄ nams⍪←'print'      'print'	       'print'			'idxerr'
	syms,←⊂,'⍕'	  ⋄ nams⍪←'fmt'	       'fmt'	       'fmt'			'idxerr'
	syms,←⊂,';'	  ⋄ nams⍪←'spn'	       'spn'	       'spn'			'idxerr'
	syms,←⊂,'←'	  ⋄ nams⍪←'mst'	       'mst'	       'mst'			'idxerr'
	syms,←⊂,'←←'	  ⋄ nams⍪←'set'	       'set'	       'set'			'idxerr'
	syms,←⊂,'/'	  ⋄ nams⍪←'red'	       'reduce_last'   'nwreduce_last'		'idxerr'
	syms,←⊂,'⌿'	  ⋄ nams⍪←'rdf'	       'reduce_first'  'nwreduce_first'		'idxerr'
	syms,←⊂,'\'	  ⋄ nams⍪←'scn'	       'scn'	       'scndya'			'idxerr'
	syms,←⊂,'⍀'	  ⋄ nams⍪←'scf'	       'scf'	       'scfdya'			'idxerr'
	syms,←⊂,'//'	  ⋄ nams⍪←'rep'	       'repmon'	       'rep'			'idxerr'
	syms,←⊂,'⌿⌿'	  ⋄ nams⍪←'rpf'	       'rpfmon'	       'rpf'			'idxerr'
	syms,←⊂,'\\'	  ⋄ nams⍪←'xpd'	       'xpdmon'	       'xpd'			'idxerr'
	syms,←⊂,'⍀⍀'	  ⋄ nams⍪←'xpf'	       'xpfmon'	       'xpf'			'idxerr'
	syms,←⊂,'¨'	  ⋄ nams⍪←'map'	       'map'	       'map'			'idxerr'
	syms,←⊂,'⍨'	  ⋄ nams⍪←'com'	       'com'	       'com'			'idxerr'
	syms,←⊂,'.'	  ⋄ nams⍪←'dot'	       'dot'	       'dot'			'idxerr'
	syms,←⊂,'⍤'	  ⋄ nams⍪←'rnk'	       'rnk'	       'rnk'			'idxerr'
	syms,←⊂,'⍣'	  ⋄ nams⍪←'pow'	       'pow'	       'pow'			'idxerr'
	syms,←⊂,'∘'	  ⋄ nams⍪←'jot'	       'jot'	       'jot'			'idxerr'
	syms,←⊂,'∘.'	  ⋄ nams⍪←'oup'	       'oup'	       'oup'			'idxerr'
	syms,←⊂,'⌸'	  ⋄ nams⍪←'key'	       'key'	       'key'			'idxerr'
	syms,←⊂,'⌺'	  ⋄ nams⍪←'stn'	       'stn'	       'stn'			'idxerr'
	syms,←⊂,'@'	  ⋄ nams⍪←'at'	       'at'	       'at'			'idxerr'
	syms,←⊂,'⎕FFT'	  ⋄ nams⍪←'q_fft'      'q_fft'	       'q_fft'			'idxerr'
	syms,←⊂,'⎕IFFT'	  ⋄ nams⍪←'q_ift'      'q_ift'	       'q_ift'			'idxerr'
	syms,←⊂,'⎕CONV'	  ⋄ nams⍪←'q_conv'     'q_conv'	       'q_conv'			'idxerr'
	syms,←⊂,'⎕NC'	  ⋄ nams⍪←'q_nc'       'q_nc'	       'q_nc'			'idxerr'
	syms,←⊂,'⎕SIGNAL' ⋄ nams⍪←'q_signal'   'q_signal'      'q_signal'		'idxerr'
	syms,←⊂,'⎕DR'	  ⋄ nams⍪←'q_dr'       'q_dr'	       'q_dr'			'idxerr'
	syms,←⊂,'⎕TS'	  ⋄ nams⍪←'q_ts'       'q_ts'	       'q_ts'			'idxerr'
	syms,←⊂,'⟜'	  ⋄ nams⍪←'starling'   'starling'      'starling'		'idxerr'
	syms,←⊂,'⊸'	  ⋄ nams⍪←'dove'       'dove'	       'dove'			'idxerr'
	syms,←⊂,'⍺'	  ⋄ nams⍪←'alpha'      'alpha'	       'alpha'			'idxerr'
	syms,←⊂,'⍵'	  ⋄ nams⍪←'omega'      'omega'	       'omega'			'idxerr'
	syms,←⊂,'⍺⍺'	  ⋄ nams⍪←'alphaalpha' 'alphaalpha'    'alphaalpha'		'idxerr'
	syms,←⊂,'⍵⍵'	  ⋄ nams⍪←'omegaomega' 'omegaomega'    'omegaomega'		'idxerr'
	syms,←⊂,'∇'	  ⋄ nams⍪←'self'       'self'	       'self'			'idxerr'
	syms,←⊂,'∇∇'	  ⋄ nams⍪←'deldel'     'deldel'	       'deldel'			'idxerr'

	syms,←⊂,'⎕PRINT_MEMSTATS' ⋄ nams⍪←(3⍴⊂'q_print_memstats'),⊂'idxerr'
	syms,←⊂,'%u'      ⋄ nams⍪←''           ''              ''			''
	syms←⎕C syms

	⍝ Convert all primitives to variables; P → V
	i←⍸t=P ⋄ si←syms⍳sym[ni←|n[i]]
	∨⌿msk←(≢syms)=si:6'UNKNOWN PRIMITIVE'SIGNAL SELECT msk⌿i
	t[i]←V ⋄ sym[ni]←nams[si;0]
	n[i]←-sym⍳sym∪←nams[si,¨(t[p[i]]=E)∧(2⌊k[p[i]])⌈3×(((t=E)∧k=4)[p]∧~⌽≠⌽p)[p][i]]

	⍝ Allocate named targets in the n field for bound application nodes
	msk←((t[p]=B)∧~k[p]∊0 7)∧(t∊C E O)∨((t=A)∧k=7)∨(t=B)∧~k∊0 7
	msk[p⌿⍨(t[p]=B)∧(t=V)∨(t=A)∧k=1]←0 ⋄ i←⍸msk
	n mu lx{⍺[⍵]@i⊢⍺}←⊂p[i] ⋄ i←⍸msk←(~msk)∧(⍳≢p)∊p[i] ⋄ p←(p[i]@i⍳≢p)[p]
	p t k n lx mu r pos end⌿⍨←⊂~msk ⋄ p r(⊣-1+⍸⍨)←⊂i ⋄ n[j]←i(⊢-1+⍸)n[j←⍸n>0]
	
	⍝ Allocate frame variables for unbound application results
	msk←((t=B)∧k=0)∨((t[p]=B)⍲k[p]=0)∧(k≠0)∧(t∊C E O)∨(t∊A S)∧k=7
	pi←p[i←⍸msk∧n≥0] ⋄ d←⊃P2D p ⋄ msk←(t=E)∧k∊0 ¯1 ⋄ lx[i]←¯7
	cg←(pi∘.=i)∨(∘.=⍨pi)∨(∘.<⍨i)∧(∘.>⍨d[i])∧∘.=⍨p I@{~msk[⍵]}⍣≡i
	cg∨←i∘.=(t[ppi]=B)∧(k[ppi]=0)∧ppi←p[pi]
	cg∧←∘.=⍨t[i]∊C O ⋄ cg∨←⍉cg ⋄ cg∧←~∘.=⍨⍳≢i
	wgt←?0⍴⍨≢i
	_←{
		mis←wgt{wgt←⍺ ⋄ mis←⍵
			wgt×←~mis∨←f←wgt>cg⌈.×wgt ⋄ 0=+⌿f:mis ⋄ wgt×←~cg∨.∧f
			wgt ∇ mis}0⍴⍨≢i
		0=+⌿mis:⍵ ⋄ wgt×←~mis ⋄ ⊢n[mis⌿i]←1+⍵
	}⍣≡0

	⍝ Link miscellaneous nodes
	n[i←⍸(t[p]=E)∧(k[p]=0)∧(t=E)∨((t=A)∧k=7)∨(t=B)∧k≠7]←0 ⋄ lx[i]←¯7
	n[i]←n[p[i←⍸(t[p]=B)∧(k[p]=0)∧(t≠V)∧(t=A)⍲k=1]] ⋄ lx[i]←lx[p[i]]
	n[p[i]]←n[i←⍸(t[p]=E)∧k[p]=¯1] ⋄ lx[p[i]]←lx[i]
	
	⍝ Add V nodes for each application node in preparation for lifting
	msk←((t[p]=B)⍲k[p]=0)∧(t∊B C O S)∨((t=E)∧k>0)∨(t=A)∧k=7 ⋄ i←(+⍀1+msk)-1
	p t k n lx mu r pos end⌿⍨←⊂1+msk ⋄ p r{⍵[⍺]}←⊂i ⋄ n[j]←i[n[j←⍸n>0]]
	j←¯1+msk⌿i ⋄ k[j⌿⍨(t[j]∊A E S)∨(t[j]=B)∧k[j]=0]←1 ⋄ k[j⌿⍨t[j]=O]←2 ⋄ t[j]←V
	
	⍝ Lift and flatten expressions
	i←⍸(t∊B C E G O S Z)∨(t=A)∧k≠1
	msk←~(t∊F G T)∨((t=B)∧k=7)∨gm←(t[p]=G)∧~(t=V)∨((t=A)∧k=1)∨(t=E)∧k=0
	p[i]←p[x←p[p] I@{gm[p[⍵]]}p I@{msk[p[⍵]]}⍣≡p I@{gm[⍵]}i]
	p t k n lx mu r pos end{⍺[⍵]@i⊢⍺}←⊂j←(⌽i)[⍋⌽x] ⋄ p←(i@j⍳≢p)[p]
	i←⍸(t=S)∨(t=B)∧k=0
	p t k n lx mu r pos end{⍺[⍵]@i⊢⍺}←⊂j←(⌽i)[⍋⌽+⍀¯1⌽t[i]=B] ⋄ p←(i@j⍳≢p)[p]

	⍝ Remove dead code paths: Empty B0; post-Z¯2 nodes
	_←p[i]{msk[⍵]←∨⍀¯1⌽msk[⍵]}⌸i←⍸(p≠⍳≢p)∧t[p]∊F G⊣msk←t=X
	k[p⌿⍨(t[p]=B)∧k[p]=0]←1 ⋄ msk∨←(t=B)∧k=0
	msk←{1@(n⌿⍨⍵∧(t=V)∧(lx=¯5)∧n∊⍸t=F)⊢⍵∨⍵[p]}⍣≡msk
	p t k n lx mu r pos end⌿⍨←⊂~msk
	p r(⊣-1+⍸⍨)←⊂i←⍸msk ⋄ n[j]←i(⊢-1+⍸)n[j←⍸n>0]

	⍝ Compute a function's local, free, and stack variables
	lv←(≢p)⍴⊂⍬ ⋄ fv←(≢p)⍴⊂⍬ ⋄ sv←(≢p)⍴⊂⍬
	lv[r[i]],←i←i⌿⍨≠(r,⍪n)[i←⍸(t∊B S V)∧(lx=¯1)∧n<0;]
	typ←1@(⍸(t∊A E S)∨(t=B)∧k=0)⊢2@(⍸t=O)⊢k[i]@(i←⍸t∊B C V)⊢(≢p)⍴0
	sv[r[i]],←i←i⌿⍨≠(r,n,⍪typ)[i←⍸(lx=¯7)∧n>0;]
	fv[p[i]],←i←⍸(t=V)∧(t[p]=C)∧n<0
	fv[n[i]]←fv[p[i←⍸(t=V)∧(t[p]=C)∧n≥0]]

	p t k n lx mu lv fv sv pos end sym IN
}
	