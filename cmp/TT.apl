TT←{
	(p d t k n lx pos end)exp sym IN←⍵

	⍝ Convert primitive niladic references to E3(P2) forms
	i←⍸(t=P)∧(k=1)∧'⎕⍞'∊⍨⊃¨sym[|n]
	p,←i ⋄ t n lx pos end(⊣,I)←⊂i ⋄ k,←(≢i)⍴2 ⋄ t[i]←E ⋄ k[i]←3 ⋄ n[i]←0

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
	t[pi]←A ⋄ k[pi]←1 ⋄ lx[pi]←6
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

	⍝ Convert B strand targets to B0, S0, S7 and S1 nodes
	msk←~(≠p)∧(t[p]=B)∧(t=A)∧k=7
	i⌿⍨←~msk[p I@{msk[⍵]}⍣≡i←⍸((t=A)∧k=7)∨(t=V)∧k=1]
	t[i]←S ⋄ k[i,p[i←⍸(t=S)∧t[p]=B]]←0
	
	⍝ Merge B node bindings
	n lx{⍺[⍵]@(p[⍵])⊢⍺}←⊂⍸msk←(≠p)∧(t∊V P)∧t[p]=B
	p t k n lx r pos end⌿⍨←⊂~msk ⋄ p r(⊣-1+⍸⍨)←⊂⍸msk

	⍝ Mark mutated bindings 
	rn←r,⍪n ⋄ rni←rn[i←⍸msk←(t∊B E V S)∧(lx∊0 1)∧n<¯6;] ⋄ mu←(≢i)⍴0
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
	k[j]←-(k[r[j]]=0)∨0@{(⌽≠⌽p×p≠⍳≢p)[j]}(t[j]=B)∨(t[j]=E)∧k[j]=4
	t[j]←E

	⍝ Convert print bindings to E1(P2(⎕⍞), ∘∘∘)
	i←p[j←⍸(≠p)∧(t[p]=B)∧(t=A)∧k=0]
	t[i]←E ⋄ k[i]←1 ⋄ t[j]←P ⋄ k[j]←2 ⋄ lx[j]←3

	⍝ Lift guard tests
	p[i]←p[x←p[i←⍸(≠p)∧t[p]=G]] ⋄ ix←i,x ⋄ xi←x,i ⋄ p←(xi@ix⊢⍳≢p)[p]
	t[ix]←t[xi] ⋄ k[ix]←k[xi] ⋄ n[x]←n[i] ⋄ n[i]←x ⋄ lx[xi]←lx[ix]
	mu[ix]←mu[xi] ⋄ pos[xi]←pos[ix] ⋄ end[xi]←end[ix]
	
	⍝ Count children for E6, S7, and A7 nodes
	_←p[i]{n[⍺]←≢⍵}⌸i←⍸((t[p]=S)∧k[p]=0)∨((t[p]∊A S)∧k[p]=7)∨(t[p]=E)∧k[p]=6

	⍝ Lift strand binding nodes
	i←⍸~msk[p I@{msk[⍵]}⍣≡⍳≢p⊣msk←~(≠p)∧(t[p]=B)∧k[p]=0]
	p[i]←p I@{msk[⍵]}⍣≡p[i]⊣msk←~(t=B)∧k=0
	p t k n lx mu r pos end{⍺[⍵]@i⊢⍺}←⊂j←(⌽i)[⍋⌽p[i]] ⋄ p←(i@j⍳≢p)[p]

	⍝ Mark arity contexts
	ac←(≢p)⍴0 ⋄ ac[i]←2⌊k[p[i←⍸(t=P)∧(k=2)∧t[p]=E]]
	
	⍝ Lift and flatten expressions
	i←⍸(t∊A B C E G O P S Z)∨(t=V)∧t[p]≠C
	p[i]←p[x←p I@{(t[x]∊F G)⍱(t[x]=B)∧k[x←p[⍵]]=7}⍣≡i]
	p t k n lx mu r ac pos end{⍺[⍵]@i⊢⍺}←⊂j←(⌽i)[⍋⌽x] ⋄ p←(i@j⍳≢p)[p]
	
	⍝ Remove unnecessary B0 nodes
	p t k n lx mu r ac pos end⌿⍨←⊂~msk←(t=B)∧k=0 ⋄ p r(⊣-1+⍸⍨)←⊂j←⍸msk
	n[i]←j(⊢-1+⍸)n[i←⍸(n>0)∧~((t=E)∧k=6)∨((t∊S A)∧k=7)∨(t=S)∧k=0]

	⍝ Compute a function's local and free variables
	lv←(≢p)⍴⊂⍬ ⋄ fv←(≢p)⍴⊂⍬
	lv[r[i]],←i←i⌿⍨≠(r,⍪n)[i←⍸(t∊B S V)∧(lx=0)∧n<0;]
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
	syms ←0⍴⊂''       ⋄ nams ←0 3⍴⊂''
	syms,←⊂,'+'       ⋄ nams⍪←'add'        'conjugate'     'plus'
	syms,←⊂,'-'       ⋄ nams⍪←'sub'        'negate'        'minus'
	syms,←⊂,'×'       ⋄ nams⍪←'mul'        'sign'          'times'
	syms,←⊂,'÷'       ⋄ nams⍪←'div'        'recip'         'divide'
	syms,←⊂,'*'       ⋄ nams⍪←'exp'        'exponent'      'power'
	syms,←⊂,'⍟'       ⋄ nams⍪←'log'        'natlog'        'logarithm'
	syms,←⊂,'|'       ⋄ nams⍪←'res'        'absolute'      'residue'
	syms,←⊂,'⌊'       ⋄ nams⍪←'min'        'floor_array'   'minimum'
	syms,←⊂,'⌈'       ⋄ nams⍪←'max'        'ceil_array'    'maximum'
	syms,←⊂,'○'       ⋄ nams⍪←'cir'        'pitimes'       'trig'
	syms,←⊂,'!'       ⋄ nams⍪←'fac'        'factorial'     'binomial'
	syms,←⊂,'~'       ⋄ nams⍪←'not'        'notscl'        'without'
	syms,←⊂,'∧'       ⋄ nams⍪←'and'        'andmon'        'logand'
	syms,←⊂,'∨'       ⋄ nams⍪←'lor'        'lormon'        'logor'
	syms,←⊂,'⍲'       ⋄ nams⍪←'nan'        'nanmon'        'lognan'
	syms,←⊂,'⍱'       ⋄ nams⍪←'nor'        'normon'        'lognor'
	syms,←⊂,'<'       ⋄ nams⍪←'lth'        'lthmon'        'lessthan'
	syms,←⊂,'≤'       ⋄ nams⍪←'lte'        'ltemon'        'lesseql'
	syms,←⊂,'='       ⋄ nams⍪←'eql'        'eqlmon'        'equal'
	syms,←⊂,'≥'       ⋄ nams⍪←'gte'        'gtemon'        'greatereql'
	syms,←⊂,'>'       ⋄ nams⍪←'gth'        'gthmon'        'greaterthan'
	syms,←⊂,'≠'       ⋄ nams⍪←'neq'        'firstocc'      'noteq'
	syms,←⊂,'⌷'       ⋄ nams⍪←'sqd'        'materialize'   'sqd_idx'
	syms,←⊂,'['       ⋄ nams⍪←'brk'        'brkmon'        'brk'
	syms,←⊂,'⍴'       ⋄ nams⍪←'rho'        'shape'         'reshape'
	syms,←⊂,'≡'       ⋄ nams⍪←'eqv'        'depth'         'same'
	syms,←⊂,'≢'       ⋄ nams⍪←'nqv'        'tally'         'notsame'
	syms,←⊂,'⍳'       ⋄ nams⍪←'iot'        'index_gen'     'index_of'
	syms,←⊂,'⍸'       ⋄ nams⍪←'iou'        'where'         'interval_idx'
	syms,←⊂,'⊃'       ⋄ nams⍪←'dis'        'first'         'pick'
	syms,←⊂,'⊂'       ⋄ nams⍪←'par'        'enclose'       'part_enc'
	syms,←⊂,'⊆'       ⋄ nams⍪←'nst'        'nest'          'partition'
	syms,←⊂,','       ⋄ nams⍪←'cat'        'ravel'         'catenate'
	syms,←⊂,'⍪'       ⋄ nams⍪←'ctf'        'table'         'catenatefirst'
	syms,←⊂,'⌽'       ⋄ nams⍪←'rot'        'reverse_last'  'rotate_last'
	syms,←⊂,'⊖'       ⋄ nams⍪←'rtf'        'reverse_first' 'rotate_first'
	syms,←⊂,'⍉'       ⋄ nams⍪←'trn'        'transpose'     'transpose_target'
	syms,←⊂,'⍋'       ⋄ nams⍪←'gdu'        'gdu'           'gdu'
	syms,←⊂,'⍒'       ⋄ nams⍪←'gdd'        'gdd'           'gdd'
	syms,←⊂,'∊'       ⋄ nams⍪←'mem'        'enlist'        'member'
	syms,←⊂,'∪'       ⋄ nams⍪←'unq'        'unique'        'union'
	syms,←⊂,'∩'       ⋄ nams⍪←'int'        'intmon'        'int'
	syms,←⊂,'⍷'       ⋄ nams⍪←'fnd'        'fnd'           'fnd'
	syms,←⊂,'↑'       ⋄ nams⍪←'tke'        'mix'           'take'
	syms,←⊂,'↓'       ⋄ nams⍪←'drp'        'split'         'drop'
	syms,←⊂,'⊢'       ⋄ nams⍪←'rgt'        'rgt'           'rgt'
	syms,←⊂,'⊣'       ⋄ nams⍪←'lft'        'lftid'         'left'
	syms,←⊂,'⊤'       ⋄ nams⍪←'enc'        'encmon'        'enc'
	syms,←⊂,'⊥'       ⋄ nams⍪←'dec'        'decmon'        'dec'
	syms,←⊂,'?'       ⋄ nams⍪←'rol'        'roll'          'deal'
	syms,←⊂,'⌹'       ⋄ nams⍪←'mdv'        'matinv'        'matdiv'
	syms,←⊂,'⎕'       ⋄ nams⍪←'println'    'println'       'println'
	syms,←⊂,'⍞'       ⋄ nams⍪←'print'      'print'         'print'
	syms,←⊂,'⍕'       ⋄ nams⍪←'fmt'        'fmt'           'fmt'
	syms,←⊂,';'       ⋄ nams⍪←'spn'        'spn'           'spn'
	syms,←⊂,'←'       ⋄ nams⍪←'mst'        'mst'           'mst'
	syms,←⊂,'←←'      ⋄ nams⍪←'set'        'set'           'set'
	syms,←⊂,'/'       ⋄ nams⍪←'red'        'reduce_last'   'nwreduce_last'
	syms,←⊂,'⌿'       ⋄ nams⍪←'rdf'        'reduce_first'  'nwreduce_first'
	syms,←⊂,'\'       ⋄ nams⍪←'scn'        'scn'           'scndya'
	syms,←⊂,'⍀'       ⋄ nams⍪←'scf'        'scf'           'scfdya'
	syms,←⊂,'//'      ⋄ nams⍪←'rep'        'repmon'        'rep'
	syms,←⊂,'⌿⌿'      ⋄ nams⍪←'rpf'        'rpfmon'        'rep'
	syms,←⊂,'\\'      ⋄ nams⍪←'xpd'        'xpdmon'        'xpd'
	syms,←⊂,'⍀⍀'      ⋄ nams⍪←'xpf'        'xpfmon'        'xpf'
	syms,←⊂,'¨'       ⋄ nams⍪←'map'        'map'           'map'
	syms,←⊂,'⍨'       ⋄ nams⍪←'com'        'com'           'com'
	syms,←⊂,'.'       ⋄ nams⍪←'dot'        'dot'           'dot'
	syms,←⊂,'⍤'       ⋄ nams⍪←'rnk'        'rnk'           'rnk'
	syms,←⊂,'⍣'       ⋄ nams⍪←'pow'        'pow'           'pow'
	syms,←⊂,'∘'       ⋄ nams⍪←'jot'        'jot'           'jot'
	syms,←⊂,'∘.'      ⋄ nams⍪←'oup'        'oup'           'oup'
	syms,←⊂,'⌸'       ⋄ nams⍪←'key'        'key'           'key'
	syms,←⊂,'⌺'       ⋄ nams⍪←'stn'        'stn'           'stn'
	syms,←⊂,'@'       ⋄ nams⍪←'at'         'at'            'at'
	syms,←⊂,'⎕FFT'    ⋄ nams⍪←'q_fft'      'q_fft'         'q_fft'
	syms,←⊂,'⎕IFFT'   ⋄ nams⍪←'q_ift'      'q_ift'         'q_ift'
	syms,←⊂,'⎕CONV'   ⋄ nams⍪←'q_conv'     'q_conv'        'q_conv'
	syms,←⊂,'⎕NC'     ⋄ nams⍪←'q_nc'       'q_nc'          'q_nc'
	syms,←⊂,'⎕SIGNAL' ⋄ nams⍪←'q_signal'   'q_signal'      'q_signal'
	syms,←⊂,'⎕DR'     ⋄ nams⍪←'q_dr'       'q_dr'          'q_dr'
	syms,←⊂,'⎕TS'     ⋄ nams⍪←'q_ts'       'q_ts'          'q_ts'
	syms,←⊂,'⍺'       ⋄ nams⍪←'alpha'      'alpha'         'alpha'
	syms,←⊂,'⍵'       ⋄ nams⍪←'omega'      'omega'         'omega'
	syms,←⊂,'⍺⍺'      ⋄ nams⍪←'alphaalpha' 'alphaalpha'    'alphaalpha'
	syms,←⊂,'⍵⍵'      ⋄ nams⍪←'omegaomega' 'omegaomega'    'omegaomega'
	syms,←⊂,'∇'       ⋄ nams⍪←'self'       'self'          'self'
	syms,←⊂,'∇∇'      ⋄ nams⍪←'deldel'     'deldel'        'deldel'

	syms,←⊂,'⎕PRINT_MEMSTATS' ⋄ nams⍪←3⍴⊂'q_print_memstats'
	syms,←⊂,'%u'      ⋄ nams⍪←''           ''              ''
	syms←⎕C syms
	
	⍝ Convert all primitives to variables; P → V|E
	i←⍸t=P ⋄ si←syms⍳sym[ni←|n[i]]
	∨⌿msk←(≢syms)=si:6'UNKNOWN PRIMITIVE'SIGNAL SELECT msk⌿i
	t[i]←V ⋄ sym[ni]←nams[si;0]
	n[i]←-sym⍳sym∪←nams[si,¨(t[p[i]]=E)∧2⌊k[p[i]]]

	p t k n lx mu lv fv pos end sym IN
}
