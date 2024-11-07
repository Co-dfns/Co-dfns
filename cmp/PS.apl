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
	t pos end⌿⍨←⊂~(t=0)∧(⊢∧1⌽⊢)IN[pos]∊WS
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
	dm←dm⍀∊{¯1↓1@(⊃⍸⍵)~⍵⍪0}¨dm⊆msk
	dm∨←(msk←x∊'Jj')∧(¯1⌽dm)∧1⌽dm
	dm←dm⍀∊{¯1↓1@(⊃⍸⍵)~⍵⍪0}¨dm⊆msk
	(msk⌿dm)←∊∧⍀¨(msk←x∊alp,num)⊆dm
	dm[⍸dm∧(x='.')∧(¯1⌽dm)⍱1⌽dm]←0
	msk←∨⌿¨dm⊆dm∧(x='.')∧¯1⌽(~dm)∧x∊num
	∨⌿msk:'AMBIGUOUS PLACEMENT OF NUMERIC FORM'SIGNAL ∊msk⌿dm⊆pos
	msk←∨⌿¨'.'={1⊃(⍵⊆⍨~⍵∊'Ee'),2⍴⊂''}¨x⊆⍨rm←dm∧~x∊'Jj'
	∨⌿msk:'NON-INTEGER EXPONENT'SIGNAL ∊msk⌿rm⊆pos
	t[i←⍸2<⌿0⍪dm]←N ⋄ end[i]←end⌿⍨2>⌿dm⍪0

	⍝ Tokenize variables
	msk←(~dm)∧(t=0)∧x∊alp,num ⋄ t[i←⍸2<⌿0⍪msk]←V ⋄ end[i]←end⌿⍨2>⌿msk⍪0

	⍝ Tokenize dfns formals
	msk←3≤≢¨grp←(pos⊆⍨'⍺'=x),pos⊆⍨'⍵'=x
	∨⌿msk:'AMBIGUOUS FORMALS'SIGNAL ∊msk⌿grp
	msk←('⍺⍺'⍷x)∨'⍵⍵'⍷x ⋄ t[i←⍸msk]←P ⋄ end[i]+←1
	t[⍸(~msk∨¯1⌽msk)∧x∊'⍺⍵']←A

	⍝ Tokenize primitives and atoms
	t[⍸x∊syna]←A ⋄ t[⍸(~dm)∧x∊prms]←P
	msk←(x∊'⌶∇')∨msk∨¯1⌽msk←(~dm)∧⊃'⍠←' '∘←' '∘.'∨.⍷⊂x
	end[⍸m2←2<⌿0⍪msk]←end⌿⍨2>⌿msk⍪0 ⋄ t[⍸msk∧~m2]←0
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
	∨⌿msk←Z≠t⌿⍨1⌽tm:'∇ MUST BE FIRST ON A LINE'SIGNAL lineof msk⌿pos
	0≠⊃tm←¯1⌽≠⍀tm:'UNBALANCED TRAD-FNS'SIGNAL lineof pos[⊃⌽⍸2<⌿0⍪tm]
	msk←Z≠t⌿⍨⊃1 ¯1∨.⌽⊂(2>⌿tm)⍪0
	∨⌿msk:'TRAD-FNS END LINE MUST CONTAIN ∇ ALONE'SIGNAL lineof msk⌿pos
	
	⍝ Flatten trad-fns headers
	d[⍸msk←∊∨⍀¨(t=Z)⊂2<⌿tm⍪0]←0 ⋄ t[⍸msk∧x∊'{}']←P
	
	⍝ Parse trad-fns into T type
	t[⍸msk←2<⌿tm⍪0]←T ⋄ d+←tm∧~msk

	⍝ Identify colons belonging to Labels
	t[⍸tm∧(d=1)∧∊0,¨(<⍀∧∘~⊃)¨':'=1↓¨(t=Z)⊂x]←L

	⍝ Tokenize Keywords
	∨⌿msk←3∧⌿(':'=x)∧t=0:'TOO MANY COLONS'SIGNAL SELECT ⍸msk
	t[⍸(':'=x)∧t=0]←K
	ki←⍸(t=K)∧((1⌽t=K)∧~msk)∨(1⌽t=V)∧msk←(d=0)∨tm∧d=1
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
	n←IN∘I¨pos+⍳¨end-pos
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
	_←p[i]{end[⍺]←end[⊃⌽⍵] ⋄ gz¨⍵⊂⍨1,¯1↓t[⍵]=Z}⌸i←⍸(t[p]∊T F)∧~t=L
	'Non-Z/L dfns body node'assert t[⍸t[p]=F]∊Z L:

	⍝ Parse the first line of a trad-fn as an H node
	⍝ N M S A R L Z X Y←(9⍴2)⊤k ⋄ N M←0(2*16)⊤n
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
		ci←≢p ⋄ p,←⍺ ⋄ t k pos end⍪←0 ⋄ n,←0 ⋄ gz cq,ci
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
	i←⍸(t[p]=Z)∧p≠⍳≢p
	∨⌿msk←bp[j←i⌿⍨≠p[i]]:{'EMPTY ASSIGNMENT TARGET'SIGNAL SELECT msk⌿p[j]}⍬
	∨⌿msk←bp[j←i⌿⍨⌽≠⌽p[i]]:{'EMPTY ASSIGNMENT VALUE'SIGNAL SELECT msk⌿p[j]}⍬
	
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
	
	⍝ Link terminal assignments to canonical binding
	vb[msk⌿bt]←nz⌿⍨msk←((≠p)∨¯1⌽((t∊P C F)∧k∊2 3 5)∨(t=P)∧n=-sym⍳⊂,'.')[bt]

	⍝ Mark lexical scope of non-variable primitives and trad-fns locals
	lx←(≢p)⍴0 ⋄ lx[⍸t=P]←3 ⋄ lx[⍸(t=F)∨(t=P)∧n∊-1+⍳6]←4

	⍝ Link local variables to bindings
	i←⍸t∊T V ⋄ i←i[⍋n[i],r[i],pos[rz[i]],⍪end[rz[i]]-pos[i]]
	b←(0,i[⍸bm])[1+bm⍸⍥⍸~bm←vb[i]≠¯1] ⋄ i⌿⍨←~bm
	vb[i]+←(1+b)∧(n[i]=n[b])∧r[i]=r[b]

	⍝ Compute bindings and set of free variables
	fb←⍸(t=T)∨(t[p]=H)∨(t=V)∧t[0⌈vb]=Z
	fr←n[fb],⍪r[fb] ⋄ fb fr⌿⍨←⊂≠fr ⋄ fb,←¯1
	i←⍸(t=V)∧vb=¯1 ⋄ ir←n[i],⍪r[r][i] ⋄ fvr←r[i] ⋄ fvi←i ⋄ lx[i]←1

	⍝ Link free variables to bindings
	_←{vb[i]←j←fb[fr⍳ir] ⋄ i ir⌿⍨←⊂j=¯1 ⋄ fvr,←⊢/ir ⋄ fvi,←i ⋄ ir[;1]←r[⊢/ir]}⍣≡⊢/ir
	
	⍝ Link shadowed variables to bindings
	cg←⍸(t=V)∧(t[r]=T)∧t[0⌈vb]=T ⋄ ir←(I@{t[0⌈⍵]≠T}⍣≡⍨r)[i]
	_←{
		vb[i]⌈←x←fb[fr⍳n[i],⍪ir] ⋄ i ir⌿⍨←⊂x=¯1 ⋄ fvr,←ir ⋄ fvi,←i
		msk←vb[cg]∘.=ir ⋄ i←i[(≢i)|⍸,msk] ⋄ ir←r[cg]⌿⍨+/msk
	ir}⍣≡ir
	
	⍝ Link global free variables to F0(H) header
	rt←I⍣≡⍨r ⋄ j←i⌿⍨≠rt[i],⍪n[i] ⋄ ih←(≢p)+⍳≢ph←∪rt[j]
	p,←ph ⋄ rt,←r,←rt[ph] ⋄ t k n vb lx pos end,←(≢ih)⍴¨H 0 0 ¯1 0(pos[ph])(pos[ph]+1)
	jv←(≢p)+⍳≢j ⋄ p,←ih[ph⍳rt[j]] ⋄ r,←rt[j] ⋄ t k n rt vb lx pos end(⊣,I)←⊂j
	vb[i]←jv[(rt[jv],⍪n[jv])⍳rt[i],⍪n[i]]
	
	⍝ Link bindings to their 1st assignments
	fb←⍸(t=V)∧(t[p]≠H)∧t[r]=T
	fb←(≠n[fb],⍪r[fb])⌿fb←fb[⍋n[fb],r[fb],pos[rz[fb]],⍪end[rz[fb]]-pos[fb]]
	fz←(i,¯1)[fb⍳⍥(p∘I)⍨i←⍸(t=Z)∧vb≠¯1]
	fr←n[fb],⍪r[fb] ⋄ fh←n[i],⍪r[i←⍸t[p]=H]
	fx←n[fb],r[fb],pos[rz[fb]],⍪end[rz[fb]]-pos[fb]
	jx←r[cg],pos[rz[cg]],⍪end[rz[cg]]-pos[cg]
	_←{
		fvr fvz←(⊂~fr∊⍥↓fh)⌿¨fr fz
		rc←+/msk←vb[cg]∘.=fvr[;1] ⋄ jn←fvr[(⊃⌽⍴fvr)|⍸,msk;0]
		fx⍪←jn,rc⌿jx ⋄ fr⍪←jn,⍪rc⌿r[cg] ⋄ fz⍪←fvz[(≢fvz)|⍸,msk]
		fr fz fx⌿⍨←⊂(≠fx[x;])[⍋x←⍋fx]
	fx}⍣≡fx
	vb[i]←(fz,¯1)[fr⍳n[i],⍪r[i]]
	vb[i]←(fz,¯1)[(⊣/fr)⍳n[i←⍸(t[p]=H)∧vb=¯1]]

	⍝ Create closures for functions and trad-fn references
	i←cg,⍸(t∊F T)∧k≠0 ⋄ fvi fvr⌿⍨←⊂(k[fvr]≠0)∧≠n[fvi],⍪fvr ⋄ k[cg]←k[vb[cg]]
	np←(≢p)+⍳≢i ⋄ p r fvi I⍨←⊂np@i⊢⍳≢p
	p,←i ⋄ t k n vb r lx pos end(⊣,I)←⊂i ⋄ t[i]←C
	p,←fvr ⋄ t k n vb lx pos end(⊣,I)←⊂fvi ⋄ r,←r[fvr] ⋄ rz,←rz[fvr]
	msk←vb[cg]∘.=fvr ⋄ i←fvi[(≢fvi)|⍸,msk] ⋄ ir←cg⌿⍨+/msk
	p,←ir ⋄ t k n vb lx pos end(⊣,I)←⊂i ⋄ r,←r[ir] ⋄ rz,←rz[ir]

	⍝ Specialize functions to specific formal binding types
	rc←(≢p)⍴1 ⋄ isa isd←⊣@p⍨¨↓(⊂3 7)⌷(9⍴2)⊤k
	rc←1 1 2 4 8[k[i]]@(i←⍸(t=F)∨isa∧t=T)⊢rc
	rc←1 1 1 2 4[k[i]]@(i←⍸(t=T)∧~isa)⊢rc
	_←{r[⍵]⊣x×←rc[⍵]}⍣≡r⊣x←rc ⋄ j←(+⍀x)-x ⋄ ro←∊⍳¨x
	p t k n r vb lx rc isa isd pos end⌿⍨←⊂x
	p r{j[⍺]+⍵}←⊂⌊ro÷rc ⋄ vb[i]←j[vb[i]]+⌊ro[i]÷(x⌿x)[i]÷x[vb[i←⍸vb>0]]
	k[i]←0 1 2 4 8[k[i]](⊣+|)ro[i←⍸(t=F)∨(t=T)∧isa]
	k[i]←0 1 2 4 8[k[i]](⊣+isd[i]+2×|)ro[i←⍸(t=T)∧~isa] 

	⍝ Link monadic dfns ⍺ formals to ⍺← bindings
	msk←(n=¯2)∧k[r]∊2+2×⍳7 ⋄ j←(⍸msk)~i←msk[i]⌿i←vb⌿⍨(t=Z)∧vb≠¯1
	vb[j]←(i,¯1)[(r[i],⍪n[i])⍳r[j],⍪n[j]]

	⍝ Unbound variables are lx=¯1
	lx[⍸(t=V)∧(vb=¯1)∧t[p]≠H]←¯1

	⍝ Mark formals with their appropriate kinds and scopes
	k[⍸(t=P)∧n=¯2]←0
	k[i]←(0 0,14⍴1)[k[r[i←⍸(t=P)∧(n∊¯1 ¯2)∧vb=¯1]]]
	k[i]←(¯16↑12⍴2⌿1 2)[k[r[i←⍸(t=P)∧n=¯3]]]
	k[i]←(¯16↑4⌿1 2)[k[r[i←⍸(t=P)∧n=¯4]]]
	i←i[⍋p[i←⍸t[p]=H]] ⋄ jp←p[i[j←⍸≠p[i]]] ⋄ hk←(9⍴2)⊤k[jp] ⋄ hn←0(2*16)⊤n[jp]
	zc←hk[6;]⌈hn[0;]×hk[0;]
	iy←i[∊hk[8;]⌿(j+zc++⌿hk[4 5 7;])+⍳¨hk[8;]⌈hn[1;]×hk[1;]]
	ix←i[hk[7;]⌿j+zc]
	iz←i[∊hk[6;]⌿j+⍳¨zc]
	id←(hk[5;]⌿hk[4;])⌿1+im←hk[5;]⌿j+zc+hk[7;] ⋄ im←i[im] ⋄ id←i[id]
	k[iz,iy,ix]←1 ⋄ k[im]←(¯16↑12⍴2⌿1 2)[k[r[im]]] ⋄ k[id]←(¯16↑4⌿1 2)[k[r[id]]]
	lx[im,id,iz,ix,iy]←4

	⍝ Error if brackets are not addressing something
	∨⌿msk←(≠p)∧t=¯1:{
		EM←'BRACKET SYNTAX REQUIRES FUNCTION OR ARRAY TO ITS LEFT'
		EM SIGNAL SELECT ⍸msk
	}⍬

	⍝ Infer the type of groups and variables
	t[⍸(t=P)∧n=¯2]←V ⋄ v←⍸(t=V)∧(k=0)∧vb≥0
	zp←p[zi←{⍵[⍋p[⍵]]}⍸(t[p]=Z)∧(k[p]=0)∧t≠¯1] ⋄ za←zi⌿⍨≠zp ⋄ zc←zi⌿⍨⌽≠⌽zp ⋄ z←p[za]
	_←{
		zb←(⌽≠⌽p[zb])⌿zb←zi⌿⍨(zp∊z)∧(k[zi]≠1)∨(≠zp)∧k[zi]=1
		nk←k[za]×(k[za]≠0)∧za=zc
		nk+←3×(nk=0)∧k[za]∊3 4
		nk+←(|k[zc])×(nk=0)∧(k[zc]∊¯3 ¯4)∨(t[zb]=P)∧n[zb]=-sym⍳⊂,'.'
		nk+←2×(nk=0)∧(k[zc]∊2 3 5)∨4=|k[zb]
		nk+←(nk=0)∧((t[zc]=A)∨1=|k[zc])∧(t[zb]=V)⍲k[zb]=0
		k[z]←nk ⋄ k[v]←k[vb[v]]
		z za zc⌿⍨←⊂nk=0 ⋄ v⌿⍨←k[v]=0
	v z}⍣≡⍬
	k[⍸(t∊V Z)∧k=0]←1 ⋄ t[⍸(t=V)∧n=¯2]←P

	⍝ Enclose V+[X;...] in Z nodes for parsing
	i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸(t[p]=Z)∧p≠⍳≢p
	msk←km∧(t[i]∊A)∨((t[i]∊P V Z)∧k[i]=1)∨(t[i]=P)∧n[i]=-sym⍳⊂,'.'
	msk∧←(0,(2>⌿msk⍪0)⌿1⌽t[i]=¯1)[+⍀2<⌿0⍪msk]
	msk∨←(t[i]=¯1)∧(¯1⌽msk)∧1⌽msk
	msk∧←(0,gm⌿km⍲k[i]=4)[+⍀gm←2<⌿0⍪msk]
	j←i⌿⍨jm←(t[i]=¯1)∧msk∨¯1⌽msk ⋄ np←(≢p)+⍳≢j ⋄ p←(np@j⍳≢p)[p] ⋄ p,←j
	t k n lx pos end(⊣,I)←⊂j ⋄ t[j]←Z ⋄ k[j]←1
	p[msk⌿i]←j[msk⌿+⍀jm]

	⍝ Parse Namespace References as Nk(Nk(...), E)
	i←i[⍋p[i←⍸(t[p]=Z)∧p≠⍳≢p]]
	j←i⌿⍨msk←(t[i]=P)∧(n[i]=-sym⍳⊂,'.')∧¯1⌽(1=|k[i])∧p[i]=1⌽p[i]
	∨⌿m2←msk∧(¯1⌽msk)∨p[i]≠1⌽p[i]:'EMPTY NAMESPACE REFERENCE'SIGNAL SELECT m2⌿i
	p[m2⌿i]←i⌿⍨¯2⌽m2←msk∧2⌽msk
	p[i⌿⍨¯1⌽msk]←j
	p[m2⌿i]←i⌿⍨¯1⌽m2←(1⌽msk)∧~¯1⌽msk
	t[j]←N ⋄ k[j]←k[i⌿⍨¯1⌽msk]

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
	np←(≢p)+⍳≢ai←i⌿⍨am←2>⌿msk⍪0 ⋄ p←(np@ai⍳≢p)[p] ⋄ p,←ai
	t k n lx pos end(⊣,I)←⊂ai
	t k n lx pos(⊣@ai⍨)←A 7 0 0(pos[i⌿⍨km←2<⌿0⍪msk])
	p[msk⌿i]←ai[¯1++⍀km⌿⍨msk←msk∧~am]

	⍝ Rationalize F[X] syntax
	i←p[j←⍸(t[p]=¯1)∧k[p]=4]
	i≢∪i:{
		msg←'UNEXPECTED COMPOUND AXIS EXPRESSION'
		99 msg SIGNAL SELECT {⊃⍺⌿⍨1<≢⍵}⌸i
	}⍬
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
	am←km∧(t[i]=A)∨(t[i]≠O)∧k[i]=1 ⋄ fm←fm∧1⌽am∨fm←km∧(t[i]=O)∨(t[i]≠A)∧k[i]=2
	i km msk m2⌿⍨←⊂msk∨(~km)∨(¯2⌽m2)∨¯1⌽msk←m2∨fm∧~¯1⌽m2←am∧1⌽fm
	i km msk m2⌿⍨←⊂km∨1⌽km
	t,←E⍴⍨xc←+⌿msk ⋄ k,←msk⌿msk+m2 ⋄ n,←xc⍴0 ⋄ lx,←xc⍴0
	pos,←pos[msk⌿i] ⋄ end,←end[p[msk⌿i]]
	p,←msk⌿¯1⌽(i×~km)+km×x←¯1+(≢p)++⍀msk ⋄ p[km⌿i]←km⌿x

	⍝ Unparsed Z nodes become Z¯2 syntax error nodes
	k[⍸(t=Z)∧(k=2)∧(t[p]=E)∧k[p]=6]←¯2
	k[zs⌿⍨1<1⊃zs zc←↓⍉p[i],∘≢⌸i←⍸(t[p]=Z)∧p≠⍳≢p]←¯2
	k[p[⍸(t[p]=Z)∧(k[p]=1)∧(t=O)∨(t∊B C N P V Z)∧k≠1]]←¯2
	k[p[⍸(t[p]=Z)∧(k[p]=2)∧(t∊A E)∨(t∊B C N P V Z)∧k≠2]]←¯2
	k[p[⍸(t[p]=Z)∧(k[p]∊3 4)∧(t∊A E O)∨(t∊B C N P V Z)∧k≠k[p]]]←¯2
	i←p[⍸(t[p]=G)∧(≠p)∧(~t∊A E)∧k≠1] ⋄ t[i]←Z ⋄ k[i]←¯2
	_←{p[⍵]⊣msk∧←msk[⍵]}⍣≡p⊣msk←(t[p]=Z)⍲k[p]=¯2
	p t k n lx pos end⌿⍨←⊂msk ⋄ p(⊣-1+⍸⍨)←⍸~msk

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
	i←p[j←⍸(≠p)∧(t[p]=E)∧(k[p]=4)∧(t∊P V)∨(t=A)∧k∊0 7] ⋄ t[i]←B ⋄ k[i]←1 ⋄ lx[i]←lx[j]
	i←p[p][⍸bp∧k=3] ⋄ k[i]←4
	n[p[i]]←n[i←⍸msk←bp∧t[p]=B] ⋄ p t k n lx pos end⌿⍨←⊂~msk ⋄ p←i(⊢-1+⍸)p

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
	msk←(≠p)∧t[p]=B
	i←⍸(k[I@{t[⍵]≠F}⍣≡⍨p]=0)∧(t=C)∨(t=V)∧msk[p I@{~msk[⍵]}⍣≡⍳≢p]
	xn←sym[|n[i]] ⋄ xt←k[i]

	⍝ Sort AST by depth-first pre-order traversal
	d i←P2D p ⋄ p d t k n lx pos end I∘⊢←⊂i ⋄ p←i⍳p

	(p d t k n lx pos end)(xn xt)sym IN
}
