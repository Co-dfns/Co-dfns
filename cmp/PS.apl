PS←{⍺←⊢
	IN←⍵ ⋄ ENVN ENVT←⍺⊣⍬ ⍬

	err←'EXPECTED SCALAR OR VECTOR INPUT'
	1<≢⍴IN:err ⎕SIGNAL 11

	err←'EXPECTED SIMPLE OR VECTOR OF VECTOR INPUT'
	2<|≡IN:err ⎕SIGNAL 11

	⍝ Basic character classes and names
	CR LF←⎕UCS 13 10 ⋄ WS←⎕UCS 9 32
	alp←'ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz'
	alp,←'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïðñòóôõöøùúûüþ'
	alp,←'∆⍙ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ'
	num←⎕D ⋄ syna←'⍬⎕⍞#' ⋄ synb←'¯[]{}()'':⍺⍵⋄;←'
	prmfs←'+-×÷|⌈⌊*⍟○!?~∧∨⍲⍱<≤=>≥≠≡≢⍴,⍪⌽⊖⍉↑↓⊂⊆⊃∊⍷∩∪⍳⍸⌷⍋⍒⍎⍕⊥⊤⊣⊢⌹∇→⌺','⍠←' '∘←'
	prmmo←'¨⍨&⌶⌸' ⋄ prmdo←'∘.⍣⍠⍤⍥@⟜⊸' ⋄ prmfo←'/⌿\⍀←'
	prms←prmfs,prmmo,prmdo,prmfo  

	⍝ Guarantee everything is LF-terminated
	IN←LF@{⍵=CR}(~CR LF⍷IN)⌿IN←∊(⊆IN),¨LF

	err←'PARSER EXPECTS CHARACTER ARRAY'
	0≠10|⎕DR IN:err ⎕SIGNAL 11

	⍝ Group input into lines as a nested vector
	pos←(IN≠LF)⊆⍳≢IN

	⍝ Mask potential strings
	msk←(''''''∘⍷¨x)∨≠⍀¨''''=x←IN∘I¨pos

	⍝ Remove comments
	pos msk⌿¨⍨←⊂∧⍀¨msk∨'⍝'≠IN∘I¨pos

	⍝ Check for unbalanced strings
	lin←⍸⊃∘⌽¨msk
	0≠≢lin:('UNBALANCED STRING','S'⌿⍨2≤≢lin)SIGNAL ∊(msk⌿¨pos)[lin]

	⍝ Flatten parser representation
	t←⊃0⍴⊂pos ⋄ t pos msk(∊,∘⍪⍨)←Z (⊃¨pos) 0

	⍝ Tokenize strings
	end←1+pos ⋄ t[i←⍸2<⌿0⍪msk]←C ⋄ end[i]←1+end[⍸2>⌿msk⍪0]
	t pos end⌿⍨←⊂(t=0)⍲¯1⌽msk

	⍝ ⋄ should be Z nodes/groups
	t[⍸'⋄'=IN[pos]]←Z

	⍝ Remove insignificant whitespace
	t pos end⌿⍨←⊂(t=0)⍲(⊢∧1⌽⊢)IN[pos]∊WS
	t pos end⌿⍨←⊂(t≠0)∨(~IN[pos]∊WS)∨⊃¯1 1∧.⌽⊂IN[pos]∊alp,num,'¯⍺⍵⎕.:'

	⍝ Verify all open characters are valid
	msk←~IN[pos]∊alp,num,syna,synb,prms,WS
	∨⌿msk:'INVALID CHARACTER(S) IN SOURCE'SIGNAL msk⌿pos

	⍝ This simplifies the following expressions
	x←' '@{t≠0}IN[pos]

	⍝ Tokenize numbers
	dm∨←('.'=x)∧(¯1⌽dm)∨1⌽dm←x∊num
	∨⌿msk←1<+⌿¨dm⊆'.'=x:'MULTIPLE . IN FLOAT'SIGNAL ∊msk/dm⊆pos
	dm∨←('¯'=x)∧1⌽dm
	∨⌿msk←('¯'=x)∧¯1⌽dm:'¯ CANNOT APPEAR BETWEEN DIGITS'SIGNAL msk⌿pos
	∨⌿msk←1<+⌿¨dm⊆'¯'=x:'MULTIPLE ¯ IN NUMBER'SIGNAL ∊msk⌿dm⊆pos
	∨⌿msk←('¯'=x)∧~dm:'ORPHANED ¯'SIGNAL msk⌿pos
	dm∨←(msk←x∊'Ee')∧(¯1⌽dm)∧1⌽dm
	dm⍀←∊{¯1↓1@(⊃⍸⍵)~⍵⍪0}¨dm⊆msk
	dm∨←(msk←x∊'Jj')∧(¯1⌽dm)∧1⌽dm
	dm⍀←∊{¯1↓1@(⊃⍸⍵)~⍵⍪0}¨dm⊆msk
	(msk⌿dm)←∊∧⍀¨(msk←x∊alp,num)⊆dm
	dm[⍸dm∧(x='.')∧(¯1⌽dm)⍱1⌽dm]←0
	msk←∨⌿¨dm⊆dm∧(x='.')∧¯1⌽(~dm)∧x∊num
	∨⌿msk:'AMBIGUOUS PLACEMENT OF NUMERIC FORM'SIGNAL ∊msk⌿dm⊆pos
	msk←∨⌿¨'.'={1⊃(⍵⊆⍨~⍵∊'Ee'),2⍴⊂''}¨x⊆⍨rm←dm∧~x∊'Jj'
	∨⌿msk:'NON-INTEGER EXPONENT'SIGNAL ∊msk⌿rm⊆pos
	t[i←⍸2<⌿0⍪dm]←N ⋄ end[i]←end⌿⍨2>⌿dm⍪0

	⍝ Tokenize variables
	msk←dm<(t=0)∧x∊alp,num ⋄ t[i←⍸2<⌿0⍪msk]←V ⋄ end[i]←end⌿⍨2>⌿msk⍪0

	⍝ Tokenize dfns formals
	msk←3≤≢¨grp←(pos⊆⍨'⍺'=x),pos⊆⍨'⍵'=x
	∨⌿msk:'AMBIGUOUS FORMALS'SIGNAL ∊msk⌿grp
	msk←('⍺⍺'⍷x)∨'⍵⍵'⍷x ⋄ t[i←⍸msk]←P ⋄ end[i]+←1
	t[⍸msk<(¯1⌽msk)<x∊'⍺⍵']←A

	⍝ Tokenize primitives and atoms
	t[⍸x∊syna]←A ⋄ t[⍸dm<x∊prms]←P
	msk←(x∊'⌶∇')∨msk∨¯1⌽msk←dm<⊃'⍠←' '∘←' '∘.'∨.⍷⊂x
	end[⍸m2←2<⌿0⍪msk]←end⌿⍨2>⌿msk⍪0 ⋄ t[⍸m2<msk]←0
	∨⌿msk←2<end[i]-pos[i←⍸msk∧x='∇']:{
		'AMBIGUOUS ∇ CLUSTER'SIGNAL SELECT msk⌿i
	}⍬

	⍝ Mark depths of dfns regions and give F type, with } as a child
	t[⍸'{'=x]←F ⋄ d←+⍀1 ¯1 0['{}'⍳x]
	0<⊃⌽d:'MISSING CLOSING BRACE'SIGNAL pos[⊃⌽⍸(d=⊃⌽d)∧2<⌿0⍪d]
	∨⌿0>d:'TOO MANY CLOSING BRACES'SIGNAL pos[⊃⍸0>d]
	d←¯1⌽d

	⍝ Check for out of context dfns formals
	msk←(d=0)∧(t∊A P)∧x∊'⍺⍵'
	∨⌿msk:'DFN FORMAL REFERENCED OUTSIDE DFNS'SIGNAL msk⌿pos

	⍝ Mark trad-fns regions as tm
	tm←(d=0)∧'∇'=x
	∨⌿msk←tm∧¯1⌽Z≠t:'∇ MUST BE FIRST ON A LINE'SIGNAL lineof msk⌿pos
	0≠⊃tm←¯1⌽≠⍀tm:'UNBALANCED TRAD-FNS'SIGNAL lineof pos[⊃⌽⍸2<⌿0⍪tm]
	msk←(1⌽Z≠t)∧(2>⌿tm)⍪0
	∨⌿msk:'TRAD-FNS END LINE MUST CONTAIN ∇ ALONE'SIGNAL lineof msk⌿pos
	
	⍝ Flatten trad-fns headers
	d[⍸msk←∊∨⍀¨(t=Z)⊂2<⌿tm⍪0]←0 ⋄ t[⍸msk∧x∊'{}']←P
	
	⍝ Parse trad-fns into T type
	t[⍸msk←2<⌿tm⍪0]←T ⋄ d+←msk<tm

	⍝ Identify colons belonging to Labels
	t[⍸tm∧(d=1)∧∊0,¨(<⍀∧∘~⊃)¨':'=1↓¨(t=Z)⊂x]←L

	⍝ Tokenize Keywords
	∨⌿msk←3∧⌿(':'=x)∧t=0:'TOO MANY COLONS'SIGNAL SELECT ⍸msk
	t[⍸(':'=x)∧t=0]←K
	ki←⍸(t=K)∧(msk<1⌽t=K)∨(1⌽t=V)∧msk←(d=0)∨tm∧d=1
	end[ki]←end[1+ki] ⋄ t[ki+1]←0

	⍝ Tokenize system variables
	si←⍸('⎕'=x)∧1⌽t=V ⋄ t[si]←S ⋄ end[si]←end[si+1] ⋄ t[si+1]←0

	⍝ Delete all characters we no longer need from the tree
	d tm t pos end(⌿⍨)←⊂(t≠0)∨x∊'()[]{};'

	⍝ Tokenize labels
	ERR←'LABEL MUST CONSIST OF A SINGLE NAME'
	∨⌿msk←(Z≠t[li-1])∨V≠t[li←⍸1⌽lm←t=L]:ERR SIGNAL pos[(msk⌿li)∘.+¯1 0 1]
	t[li]←L ⋄ d tm t pos end(⌿⍨)←⊂~lm

	⍝ With tokens created, reify n field before tree-building
	n←(w⌿1+⍳≢pos)⊆IN[(⍳≢x)+x←w⌿pos-+⍀0,¯1↓w←end-pos]
	n←{¯1↓⍎¨⍵,⊂''''''}@{t=C}(⊂'')@{t∊Z F}⎕C@{t∊K S}(⊂⍬)@{n∊⊂,'⍬'}n
	msk vals←⎕VFI ⍕n[i←⍸t=N]
	~∧⌿msk:'CANNOT REPRESENT NUMBER'SIGNAL SELECT ⍸(t=N)⍀~msk
	n[i]←vals
	
	⍝ Split inheritance reference if necessary
	msk←(t=K)∧¯1⌽(t=V)∧¯1⌽(t=K)∧n∊⊂':class'
	tm d t n pos end msk⌿⍨←⊂1+msk ⋄ i←⍸2<⌿0⍪msk
	t[i+1]←V ⋄ n[i]←1↑¨n[i] ⋄ n[i+1]←1↓¨n[i+1] ⋄ end[i]←pos[i+1]←pos[i]+1	
	
	⍝ Check that all keywords are valid
	KW←'NAMESPACE' 'ENDNAMESPACE' 'END' 'IF' 'ELSEIF' 'ANDIF' 'ORIF' 'ENDIF'
	KW,←'WHILE' 'ENDWHILE' 'UNTIL' 'REPEAT' 'ENDREPEAT' 'LEAVE' 'FOR' 'ENDFOR'
	KW,←'IN' 'INEACH' 'SELECT' 'ENDSELECT' 'CASE' 'CASELIST' 'ELSE' 'WITH'
	KW,←'ENDWITH' 'HOLD' 'ENDHOLD' 'TRAP' 'ENDTRAP' 'GOTO' 'RETURN' 'CONTINUE'
	KW,←'SECTION' 'ENDSECTION' 'DISPOSABLE' 'ENDDISPOSABLE' 'CLASS' 'ENDCLASS'
	KW,←'IMPLEMENTS' 'BASE' 'ACCESS' 'PROPERTY' 'ENDPROPERTY' 'FIELD' 'USING'
	KW,←':' ''
	KW,¨⍨←':' ⋄ KW←⎕C KW
	msk←~KW∊⍨kws←n⌿⍨km←t=K
	∨⌿msk:2'UNRECOGNIZED KEYWORD(S)'SIGNAL SELECT ⍸km⍀msk

	⍝ Check that all namespaces/sections are top level
	nssec←⎕C':NAMESPACE' ':ENDNAMESPACE' ':CLASS' ':ENDCLASS' ':SECTION' ':ENDSECTION'
	msk←(kws∊nssec)∧km⌿tm
	∨⌿msk:2'INVALID NAMESPACE/SECTION CONTEXT'SIGNAL SELECT ⍸km⍀msk

	⍝ Verify system variables used
	SYSV←,¨'Á' 'A' 'AI' 'AN' 'AV' 'ATX' 'AVU' 'BASE' 'CT' 'D' 'DCT' 'DIV' 'DM'
	SYSV,←,¨'DMX' 'EXCEPTION' 'FAVAIL' 'FNAMES' 'FNUMS' 'FR' 'IO' 'LC' 'LX'
	SYSV,←,¨'ML' 'NNAMES' 'NNUMS' 'NSI' 'NULL' 'PATH' 'PP' 'PW' 'RL' 'RSI'
	SYSV,←,¨'RTL' 'SD' 'SE' 'SI' 'SM' 'STACK' 'TC' 'THIS' 'TID' 'TNAME' 'TNUMS'
	SYSV,←,¨'TPOOL' 'TRACE' 'TRAP' 'TS' 'USING' 'WA' 'WSID' 'WX' 'XSI'
	SYSF←,¨'ARBIN' 'ARBOUT' 'AT' 'C' 'CLASS' 'CLEAR' 'CMD' 'CONV' 'CR' 'CS' 'CSV'
	SYSF,←,¨'CY' 'DF' 'DL' 'DQ' 'DR' 'DT' 'ED' 'EM' 'EN' 'EX' 'EXPORT'
	SYSF,←,¨'FAPPEND' 'FCHK' 'FCOPY' 'FCREATE' 'FDROP' 'FERASE' 'FFT' 'IFFT'
	SYSF,←,¨'FHIST' 'FHOLD' 'FIX' 'FLIB' 'FMT' 'FPROPS' 'FRDAC' 'FRDCI' 'FREAD'
	SYSF,←,¨'FRENAME' 'FREPLACE' 'FRESIZE' 'FSIZE' 'FSTAC' 'FSTIE' 'FTIE'
	SYSF,←,¨'FUNTIE' 'FX' 'INSTANCES' 'JSON' 'KL' 'LOAD' 'LOCK' 'MAP' 'MKDIR'
	SYSF,←,¨'MONITOR' 'NA' 'NAPPEND' 'NC' 'NCOPY' 'NCREATE' 'NDELETE' 'NERASE'
	SYSF,←,¨'NEW' 'NEXISTS' 'NGET' 'NINFO' 'NL' 'NLOCK' 'NMOVE' 'NPARTS'
	SYSF,←,¨'NPUT' 'NQ' 'NR' 'NREAD' 'NRENAME' 'NREPLACE' 'NRESIZE' 'NS'
	SYSF,←,¨'NSIZE' 'NTIE' 'NUNTIE' 'NXLATE' 'OFF' 'OR' 'PFKEY' 'PROFILE'
	SYSF,←,¨'REFS' 'SAVE' 'SH' 'SHADOW' 'SIGNAL' 'SIZE' 'SR' 'SRC' 'STATE'
	SYSF,←,¨'STOP' 'SVC' 'SVO' 'SVQ' 'SVR' 'SVS' 'TCNUMS' 'TGET' 'TKILL' 'TPUT'
	SYSF,←,¨'TREQ' 'TSYNC' 'UCS' 'VR' 'VFI' 'WC' 'WG' 'WN' 'WS' 'XML' 'XT'
	SYSF,←⊂,'PRINT_MEMSTATS'
	SYSM←,¨,⊂'VEACH'
	SYSD←,¨'OPT' 'R' 'S' 'AMBIV'
	SYSV SYSF SYSM SYSD←⎕C '⎕',¨¨SYSV SYSF SYSM SYSD
	msk←(t=S)∧~n∊SYSV,SYSF,SYSM,SYSD,⎕C¨ENVN
	∨⌿msk:'INVALID SYSTEM NAME'SIGNAL SELECT ⍸msk

	⍝ Introduce k field
	k←2×t∊F

	⍝ Kinds of atoms, characters, numbers, primitives, and system variables
	k[⍸(t∊A C N)∨(t=S)∧n∊SYSV]←1
	k[⍸((t=P)∧n∊,¨prmfs)∨(t=S)∧n∊SYSF]←2
	k[⍸(n∊,¨prmmo,⊂'∘.')∨(t=S)∧n∊SYSM]←3
	k[⍸(n∊,¨prmdo)∨(t=S)∧n∊SYSD]←4
	k[⍸n∊,¨prmfo]←5
	k[⍸n∊⊂'⌶⌶']←¯3
	k[⍸n∊⊂'⌶⌶⌶']←¯4
	k[⍸n∊⊂'⌶⌶⌶⌶']←¯1

	⍝ Convert n field to symbols and add a symbol table
	sym←∪('')(,'⍵')(,'⍺')'⍺⍺' '⍵⍵'(,'∇')'∇∇'⍬(,';'),n
	n←-sym⍳n

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
	_←p[i]{end[⍺]←end[⊃⌽⍵] ⋄ gz¨⍵⊂⍨1,¯1↓t[⍵]=Z}⌸i←⍸(t=L)<t[p]∊T F
	'Non-Z/L function body node'assert t[⍸t[p]∊T F]∊Z L:

	⍝ Parse the first line of a trad-fn as an H node
	⍝ N M S A R L Z X Y←(9⍴2)⊤k ⋄ N M←0(2*16)⊤n
	t[j←⍸(≠p)∧t[p]=T]←H ⋄ p[i]←j[p[j]⍳p[p][i←⍸p∊p[⍸(t[p][p]=T)∧(≠p)∧n=-sym⍳⊂,';']]]
	∨⌿msk←(n=-sym⍳⊂,'←')∧(≠p)∧t[p]=H:'EMPTY RETURN HEADER'SIGNAL SELECT ⍸msk
	∨⌿msk←(n=-sym⍳⊂,';')∧(≠p)∧t[p]=H:'MISSING SIGNATURE'SIGNAL SELECT ⍸msk
	msysv←'⎕IO' '⎕ML' '⎕CT' '⎕PP' '⎕PW' '⎕RTL' '⎕FR' '⎕PATH' '⎕RL' '⎕DIV' '⎕TRAP' '⎕USING'
	msk←(t[p]=H)∧~(t=V)∨(n∊-sym⍳,¨'←(){};')∨(t=S)∧n∊-sym⍳⎕C¨msysv
	∨⌿msk:'INVALID TRAD-FNS HEADER TOKEN'SIGNAL SELECT ⍸msk
	_←p[i]{
		0=≢i:0
		nt←'←(){};V'['←(){};'⍳⊃¨sym[|n[⍵]]] ⋄ k[⍵⌿⍨nt≠'V']←¯99
		k[⍺]←0 ⋄ n[⍺]←0
		∨⌿msk←2=⌿0⍪⍨2|';V'⍳nt↓⍨x←nt⍳';':'BAD LOCAL DECLARATION'SIGNAL SELECT msk⌿x↓⍵
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
	∨⌿msk←nss∧¯1⌽Z≠t:ERR SIGNAL SELECT ⍸msk
	ERR←'NAMESPACE DECLARATION MAY HAVE ONLY A NAME OR BE EMPTY'
	∨⌿msk←nss∧(1⌽Z≠t)∧(1⌽V≠t)∨2⌽Z≠t:ERR SIGNAL SELECT ⍸msk
	ERR←':ENDNAMESPACE KEYWORD MUST APPEAR ALONE ON A LINE'
	∨⌿msk←nse∧⊃¯1 1∨.⌽⊂Z≠t:ERR SIGNAL SELECT ⍸msk
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
		t[⍺]←G ⋄ p[ti←gz⊃tx cq←2↑(⊂⍬)⍪⍨⍵⊂⍨1,¯1↓m]←⍺ ⋄ k[ti]←0
		ci←≢p ⋄ p⍪←⍺ ⋄ t⍪←0 ⋄ k⍪←0 ⋄ pos⍪←0 ⋄ end⍪←0 ⋄ n⍪←0 ⋄ gz cq,ci
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

	⍝ Convert M nodes to T0 nodes
	t←T@{t=M}t

	⍝ Parse niladic tokens to A0 nodes
	t[i←⍸n∊-sym⍳,¨'⎕⍞']←A ⋄ k[i]←0

	⍝ Unify A1, N, and C tokens to A1 nodes
	t k(⊣@(⍸t∊N C))⍨←A 1

	⍝ Mark binding primitives
	bp←(t=P)∧n∊-sym⍳,¨'←' '⍠←' '∘←'

	⍝ Check for empty bindings
	i←⍸(t[p]=Z)∧p≠⍳≢p
	∨⌿msk←bp[j←i⌿⍨≠p[i]]:'EMPTY ASSIGNMENT TARGET'SIGNAL SELECT msk⌿p[j]
	∨⌿msk←bp[j←i⌿⍨⌽≠⌽p[i]]:'EMPTY ASSIGNMENT VALUE'SIGNAL SELECT msk⌿p[j]

	⍝ Wrap binding values in Z nodes
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i←⍸(t[p]=Z)∧p≠⍳≢p]] ⋄ km←((-≢x)↑(≢pi)⍴1)[x]
	nz←(≢p)+⍳≢bi←bp[i]⌿i
	p,←(np≥≢p)⌿¯1⌽np←(bp[i]∨~km)⌿nz@{bp[i]}i
	t k n pos end,←(≢nz)⍴¨Z 0 0(1+pos[bi])(end[p[bi]])
	p[km⌿i]←np[¯1+km⌿+⍀¯1⌽bp[i]∨~km]

	⍝ Enclose definitions in closures; add H node to each F and T0 node
	i←⍸(t=F)∨(t=T)∧k≠0 ⋄ p[j]←(((≢p)+⍳≢i)@i⊢⍳≢p)[p[j←⍸p≠⍳≢p]]
	p⍪←i ⋄ t k n pos end(⊣⍪I)←⊂i ⋄ t[i]←C
	i←⍸(t=F)∨(t∊T)∧k=0 ⋄ p⍪←i ⋄ t n k⍪←(≢i)⍴¨H 0 0 ⋄ pos⍪←pos[i] ⋄ end⍪←pos[i]+1
	
	⍝ Enclosing frames and lines for all nodes
	msk←~t[p]∊F G T ⋄ rz←p I@{msk[⍵]}⍣≡⍳≢p
	r←I@{t[0⌈⍵]=G}⍨rf←I@{rz∊p[i]⊢∘⊃⌸i←⍸t[p]=G}⍨p[rz]
	
	⍝ We use vb to link variables to their binding
	vb←¯1⍴⍨≢p

	⍝ Mark lexical scope of non-variable primitives and trad-fns locals
	lx←(≢p)⍴¯1 ⋄ lx[⍸t=P]←¯3 ⋄ lx[⍸(t=F)∨(t=P)∧n∊-1+⍳6]←¯4

	⍝ Add localized dfns/ns bindings to the H-set
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i←⍸(t[p]=Z)∧(t[r]=F)∧p≠⍳≢p]] ⋄ km←((-≢x)↑(≢pi)⍴1)[x]
	bm←{bm⊣bm[p]∧←⍵}⍣≡bm←t∊A V Z
	zv∧←(0⍪(1⌽n[i]∊-sym⍳,¨'←' '⍠←' '∘←')⌿⍨2>⌿zv⍪0)[+⍀2<⌿0⍪zv←km∧bm[i]]
	zv×←(0⍪i⌿⍨¯2⌽2>⌿zv⍪0)[+⍀2<⌿0⍪zv]
	zv←(zm⌿zv)@(i⌿⍨zm←zv≠0)⊢(≢p)⍴0 ⋄ _←p[i]{zv[⍵]⌈←zv[⍺]}⍣≡i←⍸bm
	zv[i]←i←⍸t=T ⋄ lx[i]←i←⍸(t=T)∧k=0
	i←⍸(t∊F T V)∧zv≠0 ⋄ i←(≠n[i],⍪rf[i])⌿i←i[⍋n[i],r[i],rz[i],⍪end[rz[i]]-pos[i]]
	p⍪←j[p[j←⍸t=H]⍳r[i]] ⋄ t⍪←V⍴⍨≢i ⋄ k n r rf rz lx vb pos end(⊣⍪I)←⊂i

	⍝ Resolve names
	bi←⍸t=T ⋄ bnr←n[bi],⍪bi ⋄ bi⍪←i←⍸t[p]=H ⋄ bnr⍪←n[i],⍪rf[i]
	_←{i←⍵
		⍝ Scope variables
		dv←vb I@{vb[⍵]≠¯1}⍣≡i-2
		srm←((t[dv]=T)∨t[p[dv]]=H)∧sem←(t[i-2]=V)∧(t[i-1]=P)∧n[i-1]=-sym⍳⊂,'.'
		uv ni i←⌿∘i¨(sem>srm) srm (sem≤srm) ⋄ lx[ni]←lx[srm⌿dv]
		lr←(r[i]×~msk)+lx[i]×msk←lx[i]≥0 ⋄ lrf←(rf[i]×~msk)+lx[i]×msk

		⍝ Resolve locals and free variables
		fm←((t[lr]=T)∧k[lr]=0)∨(t[x]=C)∧vb[x←p[i]]=¯1
		b←(bi⍪0)[j←bnr⍳n[i],⍪lrf] ⋄ lm←(rz[b]<rz[i])∨(rz[b]=rz[i])∧pos[b]≥pos[i]
		j[⍸msk]←bnr⍳n[x←msk⌿i],⍪lr⌿⍨msk←(j=≢bnr)∨fm⍱lm ⋄ b←(bi⍪0)[j]
		msk←(j≠≢bnr)∧fm∨(rz[b]<rz[i])∨(rz[b]=rz[i])∧pos[b]≥pos[i]
		vb[msk⌿i]←msk⌿b ⋄ i lr⌿⍨←⊂~msk ⋄ lx[i]←¯2@{¯1=⍵}lx[i]
		j←⍸(t[p]=C)∧(vb[p]=¯1)∧t=V
		vb[i]←(j,¯1)[x←(n[j],⍪p[j])⍳n[i],⍪p[lr]] ⋄ i⌿⍨←x=≢j

		⍝ Bind unresolved variables to new bindings
		j←(≢p)+⍳≢ui←i⌿⍨msk←≠n[i],⍪lr ⋄ vb[i]←j[(n[ui],⍪lr←msk⌿lr)⍳n[i],⍪lr]
		
		⍝ Add namespace bindings to H-set; free variables to C-set
		i ir←j lr⌿⍨¨⊂msk←(t[lr]=T)∧k[lr]=0
		np←x[p[x←⍸(t[p]=T)∧(k[p]=0)∧t=H]⍳ir]
		p r rf rz lx vb⍪←⊂(≢ui)⍴¯1 ⋄ t k n pos end(⊣⍪I)←⊂ui
		p[i]←np ⋄ bnr⍪←n[i],⍪r[i]←rz[i]←ir ⋄ bi⍪←i ⋄ j ui⌿⍨←⊂~msk
		p[j]←x←p[r[ui]] ⋄ r rf rz(I⊣@j⊣)←⊂x
		
		⍝ Propagate Free Variables to Dynamic Closures
		nj np←j i I¨↓⍉↑⍸pj∘.=vb[i←⍸(t=C)∧vb∊pj←p[j]] ⋄ j⍪←(≢p)+⍳≢nj
		p⍪←np ⋄ r rf rz(⊣⍪I)←⊂np ⋄ t k n lx vb pos end(⊣⍪I)←⊂nj
		
		⍝ Propagate Definition Closures to new Dynamic Call Sites
		i x⌿⍨←⊂(t[x]=T)∧k[x←vb I@{vb[⍵]≠¯1}⍣≡i←⍸(t=V)∧~t[p]∊C H]≠0
		pi vi←i vs I¨↓⍉↑⍸px∘.=p[vs←⍸(t=V)∧p∊px←p[x]]
		p⍪←i ⋄ t k n r rf rz lx vb pos end(⊣⍪I)←⊂i ⋄ j⍪←(≢p)+⍳≢pi
		p⍪←pi ⋄ r rf rz(⊣⍪I)←⊂pi ⋄ t k n pos end(⊣⍪I)←⊂vi ⋄ lx vb⍪←(≢pi)⍴¨¯1 ¯1
		t[i]←C ⋄ k[i]←k[x] ⋄ vb[i]←px
	j⍪uv}⍣≡⍸(t[p]≠H)∧(t=V)∧vb=¯1
		
	⍝ XXX Handle specific known structural forms for assignment/binding
	⍝ j←(jh⍪j)[x←⍋(jh←∪pi)⍪pi←p[j←⍸(t[p]=Z)∧p≠⍳≢p]] ⋄ km←((-≢x)↑(≢pi)⍴1)[x]
	⍝ tm←(1⌽tm)∨tm←((1⌽tm)∧t[j]=¯1)∨tm←(1⌽tm)∨tm←¯1⌽(t[j]=P)∧n[j]=-sym⍳⊂,'.'
	⍝ tm∨←(t[j]∊V Z)∧jt∨(¯1⌽~km)∨1⌽(t[j]=¯1)∧jt←j∊bt
	⍝ m2←(~km)∨(0⍪msk⌿¯1⌽~km)[+⍀msk←2<⌿0⍪m2←km∧(t[j]=P)∨(t[j]=A)∧k[j]=1]
	⍝ tm∧←(0⍪msk⌿¯1⌽m2)[+⍀msk←2<⌿0⍪tm]
	⍝ vb[bi←msk⌿bt]←nz⌿⍨msk←bt∊tm⌿j ⋄ i~←bi
	⍝ bm←bm∨(km∧(t[j]=¯1)∨(t[j]∊F P)∧k[j]∊3 5)∧1⌽bm←km∧n[j]=-sym⍳⊂,'←'
	⍝ bm←(km∧t[j]∊V Z)∧(2⌽bm)∧(1⌽km∧(k[j]=2)∧t[j]∊F P)∨tm∧1⌽km∧(t[j]=¯1)∨(k[j]=5)∧t[j]∊F P
	⍝ x←j⌿⍨bm∨(p[j]∊j⌿⍨msk←bm∨j∊bi)∧m2←km∧(t[j]=V)∧(1⌽~km)∨1⌽km∧(t[j]=¯1)∧1⌽~km
	⍝ k[x]←1 ⋄ vb[x]←x ⋄ i~←x
	⍝ k[x←j⌿⍨tm∧(~msk)∧(0⍪(msk←2>⌿tm⍪0)⌿msk)[+⍀2<⌿0⍪tm]]←1 ⋄ k[j⌿⍨m2∧p[j]∊x]←1

	⍝ Specialize functions to specific formal binding types
	rc←(≢p)⍴1 ⋄ isa isd←⊣@p⍨¨↓(⊂3 7)⌷(9⍴2)⊤k
	rc←1 1 2 4 8[k[i]]@(i←⍸(t=F)∨isa∧t=T)⊢rc
	rc←1 1 1 2 4[k[i]]@(i←⍸(t=T)∧~isa)⊢rc
	_←{r[⍵]⊣x×←rc[⍵]}⍣≡r⊣x←rc ⋄ j←(+⍀x)-x ⋄ ro←∊⍳¨x
	p t k n r vb lx rc isa isd pos end⌿⍨←⊂x
	p r{j[⍺]+⍵}←⊂⌊ro÷rc ⋄ vb[i]←j[vb[i]]+⌊ro[i]÷(x⌿x)[i]÷x[vb[i←⍸vb>0]]
	k[i]←0 1 2 4 8[k[i]](⊣+|)ro[i←⍸(t=F)∨(t=T)∧isa]
	k[i]←0 1 2 4 8[k[i]](⊣+isd[i]+2×|)ro[i←⍸(t=T)∧~isa]
	
	⍝ Link Z nodes of V←Z forms to V target
	i←{⍵[⍋p[⍵]]}⍸p∊p⌿⍨msk←n∊-sym⍳,¨'←' '∘←'
	vb[i⌿⍨¯2⌽vm]←i⌿⍨vm←(1⌽msk[i])∧(t[i]=V)∨n[i]=¯2

	⍝ Link monadic dfns ⍺ formals to ⍺← bindings
	msk←(n=¯2)∧k[r]∊2×1+⍳7 ⋄ j←(⍸msk)~i←msk[i]⌿i←vb⌿⍨(t=Z)∧vb≠¯1
	vb[j]←(i,¯1)[(r[i],⍪n[i])⍳r[j],⍪n[j]]

	⍝ Mark formals with their appropriate kinds and scopes
	k[⍸(t=P)∧n=¯2]←0
	k[i]←(0 0,14⍴1)[k[r[i←⍸0@(vb⌿⍨(t=Z)∧vb≠¯1)⊢(t=P)∧(n∊¯1 ¯2)∧vb=¯1]]]
	k[i]←(¯16↑12⍴2⌿1 2)[k[r[i←⍸(t=P)∧n=¯3]]]
	k[i]←(¯16↑4⌿1 2)[k[r[i←⍸(t=P)∧n=¯4]]]
	i←i[⍋p[i←⍸t[p]=H]] ⋄ jp←p[i[j←⍸≠p[i]]] ⋄ hk←(9⍴2)⊤k[jp] ⋄ hn←0(2*16)⊤n[jp]
	zc←hk[6;]⌈hn[0;]×hk[0;]
	iy←i[∊hk[8;]⌿(j+zc++⌿hk[4 5 7;])+⍳¨hk[8;]⌈hn[1;]×hk[1;]]
	ix←i[hk[7;]⌿j+zc]
	iz←i[∊hk[6;]⌿j+⍳¨zc]
	id←(hk[5;]⌿hk[4;])⌿1+im←hk[5;]⌿j+zc+hk[7;] ⋄ im←i[im] ⋄ id←i[id]
	k[iz,iy,ix]←1 ⋄ k[im]←(¯16↑12⍴2⌿1 2)[k[r[im]]] ⋄ k[id]←(¯16↑4⌿1 2)[k[r[id]]]
	lx[im,id,iz,ix,iy]←¯4

	⍝ Error if brackets are not addressing something
	∨⌿msk←(≠p)∧t=¯1:{
		EM←'BRACKET SYNTAX REQUIRES FUNCTION OR ARRAY TO ITS LEFT'
		EM SIGNAL SELECT ⍸msk
	}⍬

	⍝ Infer the type of groups and variables
	t[⍸(t=P)∧n=¯2]←V ⋄ v←⍸(t=V)∧(k=0)∧vb≥0
	zp←p[zi←{⍵[⍋p[⍵]]}⍸(t[p]∊N Z)∧(k[p]=0)∧t≠¯1]
	za←zi⌿⍨≠zp ⋄ zb←zi⌿⍨1⌽msk←⌽≠⌽zp ⋄ zc←msk⌿zi ⋄ z←p[za]
	zd[i]←vb I@{vb[⍵]≠¯1}⍣≡vb[i←⍸(t=Z)∧vb≠¯1]⊣zd←(≢p)⍴¯1
	_←{
		nk←k[zc]×(za=zc)∨t[z]=N
		nk+←(k[zc])×(nk=0)∧za=vb[zc]
		nk+←3×(nk=0)∧(k[za]∊3 4)∧n[za]≠-sym⍳⊂,'∘.'
		nk+←(|k[zc])×(nk=0)∧k[zc]∊¯3 ¯4
		nk+←2×(nk=0)∧(k[zc]∊2 3 5)∨4=|k[zb]
		nk+←2×{zp zi←zp zi⌿⍨¨⊂zp∊z
			msk←(k[zi]=4)∧⌽∘≠∘⌽U((~k[zi]∊0 1)⌿⊢)zp
			msk<←≠⍀(⊢∨0⍪¯1↓⊢)U((msk∨≠zp)⌿⊢)msk
			m2←(≢p)⍴0 ⋄ tm←(⍳≢p)∊ti←zi⌿⍨msk∨zi∊zc
			vi←ti⌿⍨(t[ti]=V)∧vb[ti]≠¯1 ⋄ vp←p[vi]
			vd←vb I@{vb[⍵]≠¯1}⍣≡vb[vi]
			_←{dz⊣m2[dz←dz⍪vp⌿⍨vd∊zd[dz←tm[⍵]⌿p[⍵]]]←1}⍣{0=≢⍺}msk⌿zp
		m2[z]<z∊msk⌿zp}⍣(nk∧.=0)⊢0
		k[z]←nk ⋄ k[zd[i]]←k[i←z⌿⍨(vb[z]≠¯1)∧nk≠0] ⋄ k[v]←k[vb[v]]
		z za zb zc⌿⍨←⊂nk=0 ⋄ v⌿⍨←k[v]=0
	v z}⍣≡⍬
	k[⍸(t∊V Z)∧k=0]←1 ⋄ t[⍸(t=V)∧n=¯2]←P

	⍝ Enclose V+[X;...] in Z nodes for parsing
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i←⍸(t[p]=Z)∧p≠⍳≢p]] ⋄ km←((-≢x)↑(≢pi)⍴1)[x]
	msk←km∧(t[i]∊A)∨((t[i]∊P V Z)∧k[i]=1)∨(t[i]=P)∧n[i]=-sym⍳⊂,'.'
	msk∧←(0,(2>⌿msk⍪0)⌿1⌽t[i]=¯1)[+⍀2<⌿0⍪msk]
	msk∨←(t[i]=¯1)∧(¯1⌽msk)∧1⌽msk
	msk∧←(0,gm⌿km⍲k[i]=4)[+⍀gm←2<⌿0⍪msk]
	j←i⌿⍨jm←(t[i]=¯1)∧msk∨¯1⌽msk
	np←(≢p)+⍳≢j ⋄ p←(x←np@j⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x
	p,←j ⋄ t k n lx vb pos end(⊣,I)←⊂j ⋄ t[j]←Z ⋄ k[j]←1
	p[msk⌿i]←j[msk⌿+⍀jm]

	⍝ Parse Namespace References as Nk(Nk(...), E)
	⍝ i←i[⍋p[i←⍸(t[p]=Z)∧p≠⍳≢p]]
	⍝ j←i⌿⍨msk←(t[i]=P)∧(n[i]=-sym⍳⊂,'.')∧(1⌽msk)∨¯1⌽msk←(1=|k[i])∧p[i]=1⌽p[i]
	⍝ ∨⌿m2←msk∧(¯1⌽msk)∨p[i]≠1⌽p[i]:'EMPTY NAMESPACE REFERENCE'SIGNAL SELECT m2⌿i
	⍝ p[m2⌿i]←i⌿⍨¯2⌽m2←msk∧2⌽msk
	⍝ p[i⌿⍨¯1⌽msk]←j
	⍝ p[m2⌿i]←i⌿⍨¯1⌽m2←(1⌽msk)∧~¯1⌽msk
	⍝ t[j]←N ⋄ k[j]←k[i⌿⍨¯1⌽msk]

	⍝ Wrap non-array bindings as B2+(V, Z)
	i←i[⍋p[i←⍸(t[p]=Z)∧p≠⍳≢p]] ⋄ j←⍸(n[i]∊-sym⍳,¨'←' '∘←')∧⊃¯1 1∧.⌽⊂k[i]≥2
	p[(jt←i[j-1]),jv←i[j+1]]←,⍨ij←i[j] ⋄ t[ij]←B ⋄ k[ij]←k[jv] ⋄ lx[ij]←lx[jt]
	pos[ij]←pos[jt] ⋄ end[ij]←end[jv]
	
	⍝ Mark F[X] forms with k=4
	_←p[i]{
		⊃m←t[⍵]=¯1:'SYNTAX ERROR:NOTHING TO INDEX' SIGNAL SELECT ⍵
		k[⍵⌿⍨m∧¯1⌽(k[⍵]∊2 3 5)∨¯1⌽k[⍵]=4]←4
	0}⌸i←⍸(t[p]=Z)∧(p≠⍳≢p)∧k[p]∊1 2
	
	⍝ Parse plural value sequences to A7 nodes
	i←|i⊣km←0<i←∊p[i](⊂-⍤⊣,⊢)⌸i←⍸(t[p]=Z)∨(t[p]=¯1)∧k[p]=4
	msk∧←⊃1 ¯1∨.⌽⊂msk←km∧(t[i]=A)∨(t[i]∊N P V Z)∧k[i]=1
	np←(≢p)+⍳≢ai←i⌿⍨am←2>⌿msk⍪0 ⋄ p←(x←np@ai⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x ⋄ p,←ai
	t k n lx vb pos end(⊣,I)←⊂ai
	t k n lx vb pos(⊣@ai⍨)←A 7 0 ¯1 ¯1(pos[i⌿⍨km←2<⌿0⍪msk])
	p[msk⌿i]←ai[¯1++⍀km⌿⍨msk←msk∧~am]

	⍝ Rationalize F[X] syntax
	i←p[j←⍸(t[p]=¯1)∧k[p]=4]
	i≢∪i:{
		msg←'UNEXPECTED COMPOUND AXIS EXPRESSION'
		99 msg SIGNAL SELECT {⊃⍺⌿⍨1<≢⍵}⌸i
	}⍬
	p[j]←p[i] ⋄ t[i]←P ⋄ lx[i]←¯3 ⋄ end[i]←1+pos[i]

	⍝ Wrap V[X;...] expressions as A¯1 nodes
	i←⍸t=¯1 ⋄ p←(x←p[i]@i⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x ⋄ t[p[i]]←A ⋄ k[p[i]]←¯1
	p t k n lx vb pos end⌿⍨←⊂t≠¯1 ⋄ p vb(⊣-1+⍸⍨)←⊂i

	⍝ Parse ⌶* nodes to V nodes
	i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸p∊p[j←⍸pm←(t=P)∧n∊ns←-sym⍳,¨'⌶' '⌶⌶' '⌶⌶⌶' '⌶⌶⌶⌶']
	∨⌿msk←(i∊j)∧¯1⌽km∧(t[i]=A)⍲k[i]=1:{
		msg←'INVALID ⌶ SYNTAX'
		msg SIGNAL SELECT i⌿⍨msk∨¯1⌽msk
	}⍬
	vi←i⌿⍨1⌽msk←i∊j ⋄ pi←msk⌿i
	t[vi]←V ⋄ k[vi]←2 3 4 1[ns⍳n[pi]] ⋄ lx[vi]←¯5 ⋄ end[vi]←end[pi]
	p t k n lx vb pos end⌿⍨←⊂~pm ⋄ p vb(⊣-1+⍸⍨)←⊂⍸pm

	⍝ Group function and value expressions
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i←⍸(t[p]=Z)∧(p≠⍳≢p)∧k[p]∊1 2]]
	km←((-≢x)↑(≢pi)⍴1)[x]
	
	⍝ Mask dyadic operator right operands
	dm←(¯1⌽(k[i]=4)∧t[i]∊C N P V Z)∧km∧~k[i]∊0 3 4
	
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
	mm←(~jm)∧(k[i]=3)∧(t[i]∊C N P V Z)∧(¯2⌽dm⍲km)∧¯1⌽km∧~k[i]∊0 4

	⍝ Parse function expressions
	msk←jm∨dm∨mm ⋄ np←(≢p)+⍳xc←≢oi←msk⌿i ⋄ p←(x←np@oi⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x
	p,←oi ⋄ t k n lx vb pos end(⊣,I)←⊂oi
	jl←¯1⌽jm ⋄ ml←(jm∧2⌽mm)∨(~jl)∧1⌽mm ⋄ dl←(jm∧3⌽dm)∨(~jl)∧2⌽dm
	p[g⌿i]←oi[(g←(~msk)∧(1⌽dm)∨om←jl∨ml∨dl)⌿(xc-⌽+⍀⌽msk)-jl]
	p[g⌿oi]←(g←msk⌿om)⌿1⌽oi ⋄ t[oi]←O ⋄ n[oi]←0 ⋄ vb[oi]←¯1
	pos[oi]←pos[g⌿i][msk⌿¯1++⍀g←jm∨(~msk)∧ml∨dl] ⋄ end[jm⌿i]←end[jl⌿i]
	ol←1+(k[i⌿⍨1⌽om]=4)∨k[i⌿⍨om]∊2 3 ⋄ or←(msk⌿dm)⍀1+k[dm⌿i]=2
	k[oi]←3 3⊥↑or ol

	⍝ Parse value expressions
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i←⍸(t[p]=Z)∧(k[p]=1)∧p≠⍳≢p]]
	km∧←(¯1⌽km)∨1⌽km←((-≢x)↑(≢pi)⍴1)[x]
	am←km∧(t[i]=A)∨(t[i]≠O)∧k[i]=1 ⋄ fm←fm∧1⌽am∨fm←km∧(t[i]=O)∨(t[i]≠A)∧k[i]=2
	i km msk m2⌿⍨←⊂msk∨(~km)∨(¯2⌽m2)∨¯1⌽msk←m2∨fm∧~¯1⌽m2←am∧1⌽fm
	i km msk m2⌿⍨←⊂km∨1⌽km
	t,←E⍴⍨xc←+⌿msk ⋄ k,←msk⌿msk+m2 ⋄ n,←xc⍴0 ⋄ lx,←xc⍴¯1 ⋄ vb,←xc⍴¯1
	pos,←pos[msk⌿i] ⋄ end,←end[p[msk⌿i]]
	p,←msk⌿¯1⌽(i×~km)+km×x←¯1+(≢p)++⍀msk ⋄ p[km⌿i]←km⌿x

	⍝ Include parentheses in source range
	ip←p[i←⍸(t[p]=Z)∧n[p]∊-sym⍳⊂,'('] ⋄ pos[i]←pos[ip] ⋄ end[i]←end[ip]

	⍝ Unparsed Z nodes become Z¯2 syntax error nodes
	k[⍸(t=Z)∧(k=2)∧(t[p]=E)∧k[p]=6]←¯2
	k[zs⌿⍨1<1⊃zs zc←↓⍉p[i],∘≢⌸i←⍸(t[p]=Z)∧p≠⍳≢p]←¯2
	k[p[⍸(t[p]=Z)∧(k[p]=1)∧(t=O)∨(t∊B C N P V Z)∧k≠1]]←¯2
	k[p[⍸(t[p]=Z)∧(k[p]=2)∧(t∊A E)∨(t∊B C N P V Z)∧k≠2]]←¯2
	k[p[⍸(t[p]=Z)∧(k[p]∊3 4)∧(t∊A E O)∨(t∊B C N P V Z)∧k≠k[p]]]←¯2
	i←p[⍸(t[p]=G)∧(≠p)∧(~t∊A E)∧k≠1] ⋄ t[i]←Z ⋄ k[i]←¯2
	
	⍝ Eliminate non-error Z nodes from the tree
	msk←((t≠Z)∨(t=Z)∧k=¯2)∧m2←(t[p]=Z)∧k[p]≠¯2
	zi←{p I@{m2[⍵]}⍵⊣vb I@(≥∘0)⍨←ki@⍵⍳≢p}⍣≡p[ki←⍸msk]
	p←(x←zi@ki⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x
	t k n lx vb pos end(⊣@zi⍨)←t k n lx vb pos end I¨⊂ki
	p t k n lx vb pos end⌿⍨←⊂msk←msk⍱(t=Z)∧k≠¯2 ⋄ p vb(⊣-1+⍸⍨)←⊂⍸~msk

	⍝ Merge simple arrays into single A1 nodes
	msk←((t=A)∧0=≡¨sym[|0⌊n])∧(t[p]=A)∧k[p]=7
	pm←(t=A)∧k=7 ⋄ pm[p]∧←msk ⋄ msk∧←pm[p]
	k[p[i←⍸msk]]←1 ⋄ n[∪pi]←-sym⍳sym∪←(pi←p[i]){⊂⍵}⌸sym[|n[i]]
	vb I@(≥∘0)⍨←pi@i⍳≢p ⋄ p t k n lx vb pos end⌿⍨←⊂~msk ⋄ p vb(⊣-1+⍸⍨)←⊂⍸msk
	
	⍝ All A1 nodes should be lexical scope 6
	lx[⍸(t=A)∧k=1]←¯6

	⍝ Check for bindings/assignments without targets
	bp←(t=P)∧n∊-sym⍳,¨'←' '⍠←' '∘←'
	msk←bp∧((k=2)∧(t[p]=E)⍲k[p]=2)∨(k=3)∧(t[p][p]=E)⍲k[p][p]=2
	msk∧←nzm←{⍵∧⍵[p]}⍣≡(t=Z)⍲k=¯2
	∨⌿msk:'MISSING ASSIGNMENT TARGET'SIGNAL SELECT p[⍸msk∧k=2],p[p][⍸msk∧k=3]
	
	⍝ Convert assignment expressions to E4 nodes, bindings to B nodes
	i←p[⍸nzm∧bp∧k=2] ⋄ k[i]←4
	i←p[j←⍸(≠p)∧(em←(t[p]=E)∧k[p]=4)∧am←(t∊P V)∨(t=A)∧k∊0 7]
	i⍪←p[p][j⍪←⍸(⌽≠⌽p)∧am∧em[p]∧t[p]=N]
	t[i]←B ⋄ k[i]←1 ⋄ lx[i]←lx[j]
	i←p[p][⍸bp∧k=3] ⋄ k[i]←4
	n[p[i]]←n[i←⍸msk←bp∧t[p]=B]
	p t k n lx vb pos end⌿⍨←⊂~msk ⋄ p vb(⊣-1+⍸⍨)←⊂i
	
	⍝ Check that we have well-formed E4 nodes
	i←⍸(≠p)∧(t[p]=E)∧k[p]=4 ⋄ msk←(t[i]∊A P V)⍱m2←(t[i]=E)∧k[i]=2
	∨⌿msk:'INVALID ASSIGNMENT TARGET'SIGNAL SELECT msk⌿i
	i←⍸(⌽≠⌽p)∧p∊m2⌿i ⋄ msk←(t[i]=V)⍱m2←(t[i]=A)∧k[i]=¯1
	∨⌿msk:'INVALID SELECTIVE ASSIGNMENT TARGET'SIGNAL SELECT msk⌿i
	i←⍸(≠p)∧p∊m2⌿i ⋄ msk←t[i]≠V
	∨⌿msk:'INVALID INDEXED SELECTIVE ASSIGNMENT TARGET'SIGNAL SELECT msk⌿i

	⍝ Convert E4 nodes to have their assigned target as the first child
	i←j←⍸(em←(≠p)∧(t[p]=E)∧k[p]=4)∧(t∊P V)∨(t=A)∧k∊0 7
	i⍪←p[j⍪←⍸em[p]∧((t[p]=A)∧(k[p]=¯1)∧≠p)∨(t[p]=E)∧(⌽≠⌽p)∧t=V]
	i⍪←p[p][j⍪←⍸em[p][p]∧(t[p][p]=E)∧(⌽≠⌽p)[p]∧(t[p]=A)∧≠p]
	p t k n lx vb pos end⌿⍨←⊂x←2@i⊢(≢p)⍴1
	p i j{⍵[⍺]}←⊂ni←(+⍀x)-1 ⋄ vb←(¯1,ni)[vb+1]
	t k n lx vb pos end(I⊣@(i-1)⊣)←⊂j

	⍝ Rationalize V[X;...] → E2(V, P2([), E6)
	i←i[⍋p[i←⍸(t[p]=A)∧k[p]=¯1]] ⋄ msk←~2≠⌿¯1,ip←p[i] ⋄ ip←∪ip ⋄ nc←2×≢ip
	t[ip]←E ⋄ k[ip]←2 ⋄ n[ip]←0 ⋄ p[msk⌿i]←msk⌿(≢p)+1+2×¯1++⍀~msk
	p,←2⌿ip ⋄ t,←nc⍴P E ⋄ k,←nc⍴2 6 ⋄ n,←nc⍴-sym⍳,¨'[' '' ⋄ lx,←nc⍴¯3 0 ⋄ vb,←nc⍴¯1
	pos,←2⌿pos[ip] ⋄ end,←∊(1+pos[ip]),⍪end[ip] ⋄ pos[ip]←pos[i⌿⍨~msk]
	
	⍝ Check for nested ⍠← forms
	∨⌿msk←(t=B)∧(n∊-sym⍳⊂'⍠←')∧t[p]≠F:{
		ERR←'⍠← MUST BE THE LEFTMOST FORM IN AN UNGUARDED EXPRESSION'
		ERR SIGNAL SELECT ⍸msk
	}⍬
	
	⍝ Compute exports
	i←⍸(p=⍳≢p)[p][p]∧(k[p][p]=0)∧(t[p][p]=T)∧t[p]=H
	xn←sym[|n[i]] ⋄ xt←k[i]

	⍝ Sort AST by depth-first pre-order traversal
	d i←P2D p ⋄ p d t k n lx vb pos end I∘⊢←⊂i ⋄ p←i⍳p ⋄ vb←i⍳@{⍵≥0}vb

	(p d t k n lx vb pos end)(xn xt)sym IN
}
