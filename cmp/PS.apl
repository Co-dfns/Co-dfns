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

	⍝ Flatten parser representation
	t←⊃0⍴⊂pos ⋄ t pos msk(∊,∘⍪⍨)←Z (⊃¨pos) 0 ⋄ end←1+pos

	⍝ Tokenize strings
	end[i←⍸sm←2<⌿0⍪msk]←end⌿⍨em←2>⌿msk⍪0
	t[err←i⌿⍨em⌿1⌽t=Z]←-≢EM∆ ⋄ EM∆⍪←⊂'UNBALANCED STRING'
	t[i←i~err]←C ⋄ end[i]+←1
	t pos end⌿⍨←⊂(t=0)⍲(t≠Z)∧¯1⌽msk

	⍝ ⋄ should be Z nodes/groups
	t[⍸'⋄'=IN[pos]]←Z

	⍝ Remove insignificant whitespace
	t pos end⌿⍨←⊂(t=0)⍲(⊢∧1⌽⊢)IN[pos]∊WS
	t pos end⌿⍨←⊂(t≠0)∨(~IN[pos]∊WS)∨⊃¯1 1∧.⌽⊂IN[pos]∊alp,num,'¯⍺⍵⎕.:'

	⍝ Verify all open characters are valid
	t[⍸~IN[pos]∊alp,num,syna,synb,prms,WS]←-≢EM∆ ⋄ EM∆⍪←⊂'INVALID CHARACTER IN SOURCE'

	⍝ This simplifies the following expressions
	x←' '@{t≠0}IN[pos]

	⍝ Tokenize numbers
	dm∨←('.'=x)∧(¯1⌽dm)∨1⌽dm←x∊num ⋄ ei em←⊂0⍴0
	ei⍪←i←⍸msk∧~≠(+⍀2<⌿0⍪dm)×msk←('.'=x)∧dm ⋄ em⍪←(≢i)⍴-≢EM∆ ⋄ EM∆⍪←⊂'MULTIPLE . IN FLOAT'
	dm∨←('¯'=x)∧1⌽dm
	ei⍪←i←⍸('¯'=x)∧¯1⌽dm ⋄ em⍪←(≢i)⍴-≢EM∆ ⋄ EM∆⍪←⊂'¯ CANNOT APPEAR BETWEEN DIGITS'
	ei⍪←i←⍸msk∧~≠(+⍀2<⌿0⍪dm)×msk←dm∧'¯'=x ⋄ em⍪←(≢i)⍴-≢EM∆ ⋄ EM∆⍪←⊂'MULTIPLE ¯ IN FLOAT'
	t[⍸dm<'¯'=x]←-≢EM∆ ⋄ EM∆⍪←⊂'ORPHANED ¯'
	dm∨←(msk←x∊'Ee')∧(¯1⌽dm)∧1⌽dm
	dm⍀←∊{¯1↓1@(⊃⍸⍵)~⍵⍪0}¨dm⊆msk
	dm∨←(msk←x∊'Jj')∧(¯1⌽dm)∧1⌽dm
	dm⍀←∊{¯1↓1@(⊃⍸⍵)~⍵⍪0}¨dm⊆msk
	(msk⌿dm)←∊∧⍀¨(msk←x∊alp,num)⊆dm
	dm[⍸dm∧(x='.')∧(¯1⌽dm)⍱1⌽dm]←0
	ei⍪←i←⍸dm∧(x='.')∧¯1⌽(~dm)∧x∊num ⋄ em⍪←(≢i)⍴-≢EM∆
	EM∆⍪←⊂'AMBIGUOUS PLACEMENT OF NUMERIC FORM'
	ei⍪←i←⍸('.'=x)∧(0⍪hm⌿¯1⌽dm∧x∊'Ee')[msk∧+⍀hm←2<⌿0⍪msk←dm∧~x∊'EeJj'] ⋄ em⍪←(≢i)⍴-≢EM∆
	EM∆⍪←⊂'NON-INTEGER EXPONENT'
	t[i←⍸(t=0)∧2<⌿0⍪dm]←N ⋄ t[j]←em[j←i[i⍸ei]] ⋄ end[i]←end⌿⍨2>⌿dm⍪0

	⍝ Tokenize variables
	msk←dm<(t=0)∧x∊alp,num ⋄ t[i←⍸2<⌿0⍪msk]←V ⋄ end[i]←end⌿⍨2>⌿msk⍪0

	⍝ Tokenize dfns formals
	end[⍸mf←2<⌿0⍪msk]←end⌿⍨2>⌿0⍪⍨msk←'⍺'=x ⋄ end[⍸mf∨←2<⌿0⍪msk]←end⌿⍨2>⌿0⍪⍨msk←'⍵'=x
	t[⍸mf∧1=end-pos]←A ⋄ t[⍸mf∧2=end-pos]←P
	t[⍸mf∧3≤end-pos]←-≢EM∆ ⋄ EM∆⍪←⊂'AMBIGUOUS FORMAL'

	⍝ Tokenize primitives and atoms
	t[⍸x∊syna]←A ⋄ t[⍸dm<x∊prms]←P
	end[i]←end[1+i←⍸dm<⊃'⍠←' '∘←' '∘.' '##'∨.⍷⊂x] ⋄ t[i+1]←0
	end[⍸m2←2<⌿0⍪msk]←end⌿⍨2>⌿0⍪⍨msk←'⌶'=x ⋄ t[⍸m2<msk]←0
	end[⍸m2←2<⌿0⍪msk]←end⌿⍨2>⌿0⍪⍨msk←'∇'=x ⋄ t[⍸m2<msk]←0
	t[⍸m2∧3≤end-pos]←-≢EM∆ ⋄ EM∆⍪←⊂'AMBIGUOUS ∇ CLUSTER'

	⍝ Mark depths of dfns regions and give F type, with } as a child
	d←+⍀bi←(bo←'{'=bi)-bc←'}'=bi←x⌿⍨bm←x∊'{}' ⋄ err←0⍴⍨≢d
	(bo⌿err)←(bo⌿bo∧d=⌽⌊⍀⌽d)[⌽⍒+⍀bo⌿2<⌿0⍪bo]
	(bc⌿err)←(bc⌿bc∧(⊢=⌊⍀)d-bi)[⌽⍒+⍀bc⌿2<⌿0⍪bc]
	t[err⌿⍸bm]←-≢EM∆ ⋄ EM∆⍪←⊂'UNBALANCED BRACE' ⋄ bo bi(bm⍀×)←⊂~err
	t[⍸bo]←F ⋄ d←¯1⌽+⍀bi

	⍝ Check for out of context dfns formals
	t[⍸(d=0)∧(t∊A P)∧(x∊'⍺⍵')∨(x='∇')∧2=end-pos]←-≢EM∆
	EM∆⍪←⊂'DFN FORMAL REFERENCED OUTSIDE DFNS'

	⍝ Mark trad-fns regions as tm
	tm←(d=0)∧x='∇'
	t[⍸tm>←tm∧¯1⌽t≠Z]←-≢EM∆ ⋄ EM∆⍪←⊂'∇ MUST BE FIRST ON A LINE'
	t[⍸tm>←tm⍀(sm∧1⌽sm)∨(em∧¯1⌽em)∨((≢em)↑⊃em)∨(-≢sm)↑⊃⌽sm←~em←tm⌿1⌽t=Z]←-≢EM∆
	EM∆⍪←⊂'UNBALANCED TRAD-FNS'
	tm←¯1⌽≠⍀tm

	⍝ Flatten trad-fns headers
	d[⍸msk←∊∨⍀¨(t=Z)⊂2<⌿tm⍪0]←0 ⋄ t[⍸msk∧x∊'{}']←P
	
	⍝ Parse trad-fns into T type
	t[⍸msk←2<⌿tm⍪0]←T ⋄ d+←msk<tm

	⍝ Identify colons belonging to Labels
	t[⍸tm∧(d=1)∧(¯1⌽t≠Z)∧≠(+⍀2<⌿0⍪t=Z)×':'=x]←L

	⍝ Tokenize Keywords
	t[i←⍸2<⌿0⍪msk←(t=0)∧':'=x]←K ⋄ end[i]←end[⍸2>⌿0⍪⍨msk]
	t[⍸(t=K)∧3≤end-pos]←-≢EM∆ ⋄ EM∆⍪←⊂'TOO MANY COLONS'
	end[i]←end[1+i←⍸(t=K)∧(1⌽t=V)∧(d=0)∨tm∧d=1] ⋄ t[i+1]←0

	⍝ Tokenize system variables
	si←⍸('⎕'=x)∧1⌽t=V ⋄ t[si]←S ⋄ end[si]←end[si+1] ⋄ t[si+1]←0

	⍝ Delete all characters we no longer need from the tree
	d tm t pos end(⌿⍨)←⊂(t≠0)∨x∊'()[]{};'

	⍝ Tokenize labels
	t[⍸(t=L)∧¯1⌽(t=V)⍲¯1⌽t=Z]←-≢EM∆ ⋄ EM∆⍪←⊂'LABEL MUST CONSIST OF A SINGLE NAME'
	t[⍸1⌽msk←t=L]←L ⋄ d tm t pos end⌿⍨←⊂~msk

	⍝ With tokens created, reify n field before tree-building
	n←(w⌿1+⍳≢pos)⊆IN[(⍳≢x)+x←w⌿pos-+⍀0,¯1↓w←end-pos]
	n←{¯1↓⍎¨⍵,⊂''''''}@{t=C}(⊂'')@{t∊Z F}⎕C@{t∊K S}(⊂⍬)@{n∊⊂,'⍬'}n
	msk vals←⎕VFI ⍕n[i←⍸t=N]
	t[⍸(t=N)⍀~msk]←-≢EM∆ ⋄ EM∆⍪←⊂'CANNOT REPRESENT NUMBER'
	n[msk⌿i]←msk⌿vals
	
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
	KW,←⊂'INCLUDE'
	KW,←':' ''
	KW,¨⍨←':' ⋄ KW←⎕C KW
	t[⍸km⍀~KW∊⍨kws←n⌿⍨km←t=K]←-≢EM∆ ⋄ EM∆⍪←⊂'UNRECOGNIZED KEYWORD'

	⍝ Check that all namespaces/sections are top level
	nssec←⎕C':NAMESPACE' ':ENDNAMESPACE' ':CLASS' ':ENDCLASS' ':SECTION' ':ENDSECTION'
	t[⍸km⍀(kws∊nssec)∧km⌿tm]←-≢EM∆ ⋄ EM∆⍪←⊂'INVALID NAMESPACE/SECTION CONTEXT'

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
	t[⍸(t=S)∧~n∊SYSV,SYSF,SYSM,SYSD,⎕C¨ENVN]←-≢EM∆ ⋄ EM∆⍪←⊂'INVALID SYSTEM NAME'

	⍝ Introduce k field and mark errors as type X
	k←(t⌊0)+2×t=F ⋄ t[⍸t<0]←X

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
	sym←1500⌶∪('')(,'⍵')(,'⍺')'⍺⍺' '⍵⍵'(,'∇')'∇∇'⍬(,';'),n
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
	_←p[i]{end[⍺]←end[⊃⌽⍵] ⋄ gz¨⍵⊂⍨1,¯1↓t[⍵]=Z}⌸i←⍸(t≠L)∧t[p]∊T F
	'Non-Z/L function body node'assert t[⍸t[p]∊T F]∊Z L:

	⍝ Mark lines with tokenization errors
	t[p⌿⍨t=X]←X

	⍝ Parse the first line of a trad-fn as an H node
	⍝ N M S A R L Z X Y←(9⍴2)⊤k ⋄ N M←0(2*16)⊤n
	t[i←⍸(≠p)∧t[p]=T]←H ⋄ p[j]←i[p[i]⍳p[p][j←⍸p∊p[⍸(t[p][p]=T)∧(≠p)∧n=-sym⍳⊂,';']]]
	t[err←p[⍸(n=-sym⍳⊂,'←')∧(≠p)∧t[p]=H]]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'EMPTY RETURN HEADER'
	t[err←p[⍸(n=-sym⍳⊂,';')∧(≠p)∧t[p]=H]]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'MISSING SIGNATURE'
	msysv←'⎕IO' '⎕ML' '⎕CT' '⎕PP' '⎕PW' '⎕RTL' '⎕FR' '⎕PATH' '⎕RL' '⎕DIV' '⎕TRAP' '⎕USING' '⎕WX'
	err←p[⍸(t[p]=H)∧~(t=V)∨(n∊-sym⍳,¨'←(){};')∨(t=S)∧n∊-sym⍳⎕C¨msysv]
	t[err]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'INVALID TRAD-FNS HEADER TOKEN'
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
	fm←msk⍀≠ip←p⌿⍨msk←p≠⍳≢p ⋄ lm←msk⍀⌽≠⌽ip
	t[err←⍸nss>←nss>fm]←X ⋄ k[err]←-≢EM∆
	EM∆⍪←⊂':NAMESPACE KEYWORD MAY ONLY APPEAR AT BEGINNING OF A LINE'
	t[err←⍸nss>←nss∧lm⍱1⌽(t=V)∧lm]←X ⋄ k[err]←-≢EM∆
	EM∆⍪←⊂'NAMESPACE DECLARATION MAY HAVE ONLY A NAME OR BE EMPTY'
	t[err←⍸nse>←nse>fm∧lm]←X ⋄ k[err]←-≢EM∆
	EM∆⍪←⊂':ENDNAMESPACE KEYWORD MUST APPEAR ALONE ON A LINE'
	t[nsi←⍸1⌽nss]←M ⋄ t[nei←⍸1⌽nse]←-M
	x←⍸p=⍳≢p ⋄ d←+⍀xni←(xns←t[x]=M)-xne←t[x]=-M
	t[err←x[⍸xns>←xns∧d=⌽⌊⍀⌽d]]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂':NAMESPACE NOT CLOSED'
	t[err←x[⍸xne>←xne∧(⊢=⌊⍀)d-xni]]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'EXCESSIVE :ENDNAMESPACE'
	p[x]←x[D2P ¯1⌽+⍀xns-xne] ⋄ n[i]←n[2+i←⍸(t=M)∧2⌽t=V] ⋄ end[xns⌿x]←end[1+xne⌿x]
	msk←~nss∨((¯1⌽nss)∧t=V)∨nse∨1⌽nse
	t k n pos end⌿⍨←⊂msk ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p

	⍝ Parse guards to (G (Z ...) (Z ...))
	i←i[⍋p[i←⍸(t[p][p]=F)∧p∊p⌿⍨t=K]] ⋄ fm←≠p[i] ⋄ km←t[i]=K
	i fm km⌿⍨←⊂1+1⌽fm ⋄ i[⍸1⌽fm]←(≢p)+⍳fc←+⌿fm
	t[p[j←fm⌿i]]←G ⋄ p⍪←p[j] ⋄ t k n pos end⍪←⊂fc⍴0 ⋄ _←gz¨i⊂⍨fm∨¯1⌽km
	t[err←p[i]⌿⍨fm∧msk←t[p[i]]=G]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'EMPTY GUARD TEST EXPRESSION'
	t[err←p[lm⌿i]⌿⍨2<+⍀⍣¯1⊢(lm←1⌽fm)⌿+⍀msk]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'TOO MANY GUARDS'

	⍝ Delete keywords we can't handle
	t k n pos end⌿⍨←⊂msk←t≠K ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p

	⍝ Parse brackets and parentheses into ¯1 and Z nodes
	i←i[⍋p[i←⍸(t[p]=Z)∧p≠⍳≢p]] ⋄ fm←≠p[i]
	pd←+⍀dx←(po←x∊'[(')-pc←'])'∊⍨x←IN[pos[i]]
	t[err←i⌿⍨po∧pd=pd[j⍳⌽⌊⍀⌽j←⍋j[⍋(+⍀fm)[j←⍋pd]]]]←X ⋄ k[err]←-≢EM∆ ⋄ t[p[err]]←X
	EM∆⍪←⊂'UNBALANCED OPEN PARENS/BRACKETS'
	t[err←i⌿⍨pc∧pd=pd[j⍳⌊⍀j←⍋j[⍒(+⍀fm)[j←⍋pd←pd-dx]]]]←X ⋄ k[err]←-≢EM∆ ⋄ t[p[err]]←X
	EM∆⍪←⊂'UNBALANCED CLOSE PARENS/BRACKETS'
	i fm x pd pc⌿⍨←⊂t[p[i]]≠X ⋄ pcp←pc⌿pp←D2P pd-(fm⌿pd)[¯1++⍀fm]
	t[err←i[pp][msk⌿pcp]⍪i⌿⍨pc⍀msk←x[pcp]≠'[('I')'=pc⌿x]←X ⋄ k[err]←-≢EM∆ ⋄ t[p[err]]←X
	EM∆⍪←⊂'OVERLAPPING PAREN/BRACKET'
	i x pc pp⌿⍨←⊂msk←t[p[i]]≠X ⋄ pp(⊣-1+⍸⍨)←⍸~msk
	p[msk⌿i]←i[pp]⌿⍨msk←pp≠⍳≢pp ⋄ t[j←i[pc⌿pp]]←¯1 Z[')'=pc⌿x] ⋄ end[j]←end[pc⌿i]
	t k n pos end⌿⍨←⊂msk←~(t=0)∧IN[pos]∊')' ⋄ p←(⍸~msk)(⊢-1+⍸)msk⌿p

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
	t[⍸(t=A)∧n∊-sym⍳,¨'#' '##']←P
	t k(⊣@(⍸t∊N C))⍨←A 1

	⍝ Mark binding primitives
	bp←(t=P)∧n∊-sym⍳,¨'←' '⍠←' '∘←' ⋄ msk←(t[p]=Z)∧p≠⍳≢p
	t[err←⍸bp>←bp∧msk⍀≠msk⌿p]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'EMPTY ASSIGNMENT TARGET'
	t[err←⍸bp>←bp∧msk⍀⌽≠⌽msk⌿p]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'EMPTY ASSIGNMENT VALUE'

	⍝ Wrap binding values in Z nodes
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i←⍸(t[p]=Z)∧p≠⍳≢p]] ⋄ km←((-≢x)↑(≢pi)⍴1)[x]
	nz←(≢p)+⍳≢bi←bp[i]⌿i
	p,←(np≥≢p)⌿¯1⌽np←(bp[i]∨~km)⌿nz@{bp[i]}i
	t k n pos end,←(≢nz)⍴¨Z 0 0(1+pos[bi])(end[p[bi]])
	p[km⌿i]←np[¯1+km⌿+⍀¯1⌽bp[i]∨~km]

	⍝ Add H node to each F and T0 node
	i←⍸(t=F)∨(t∊T)∧k=0 ⋄ p⍪←i ⋄ t n k⍪←(≢i)⍴¨H 0 0 ⋄ pos⍪←pos[i] ⋄ end⍪←pos[i]+1

	⍝ Enclosing frames and lines for all nodes
	msk←~t[p]∊F G T ⋄ rz←p I@{msk[⍵]}⍣≡⍳≢p
	r←I@{t[0⌈⍵]=G}⍨rf←I@{rz∊p[i]⊢∘⊃⌸i←⍸t[p]=G}⍨p[rz]

	⍝ We use vb to link variables to their binding
	vb←¯1⍴⍨≢p

	⍝ Mark lexical scope of non-variable primitives and trad-fns locals
	lx←(≢p)⍴¯1 ⋄ lx[⍸t=P]←¯4 ⋄ lx[⍸(t=F)∨(t=P)∧n∊-1+⍳6]←¯5

	⍝ Add localized dfns/ns bindings to the H-set
	i←⍸(t[p]=Z)∧((t=F)∨(t=T)∧k=0)[r]∧p≠⍳≢p
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i]] ⋄ km←((-≢x)↑(≢pi)⍴1)[x]
	bm←{bm⊣bm[p]∧←⍵}⍣≡bm←(t∊A V Z)∨dm←(t=P)∧n=-sym⍳⊂,'.'
	zv∧←(0⍪(2>⌿zv⍪0)⌿1⌽n[i]∊-sym⍳,¨'←' '⍠←' '∘←')[+⍀2<⌿0⍪zv←km∧bm[i]]
	zv×←(0⍪i⌿⍨¯2⌽2>⌿zv⍪0)[+⍀2<⌿0⍪zv]
	zv←(zm⌿zv)@(i⌿⍨zm←zv≠0)⊢(≢p)⍴0 ⋄ _←p[i]{zv[⍵]⌈←zv[⍺]}⍣≡i←⍸bm
	zv×←{⍵∧⍵[p]}⍣≡~⊃¯1 0 1∨.⌽⊂dm
	zv[i]←i←⍸t=T ⋄ lx[i]←i←⍸(t=T)∧k=0
	i←⍸(t∊T V)∧zv≠0
	ui←(≠x←n[i],⍪r[i])⌿i←i[⍋n[i],r[i],rz[i],⍪end[rz[i]]-pos[i]]
	vb[i]←(≢p)+x⍳⍨ux←n[ui],⍪r[ui]
	vb[p⍳zv[msk⌿i]]←(≢p)+ux⍳x⌿⍨msk←zv[i]∊p[⍸(t=F)∧(≠p)∧⌽≠⌽p]
	p⍪←j[p[j←⍸t=H]⍳r[ui]] ⋄ t⍪←V⍴⍨≢ui ⋄ k n r rf rz lx vb zv pos end(⊣⍪I)←⊂ui

	⍝ Tag all variables as either lexical or dynamic
	lx[i]←¯3+F=t[r[i←⍸(t[p]≠H)∧(t=V)∧vb=¯1]]

	⍝ Type known namespace-assigned variables
	gm←(t=P)∧n∊-sym⍳,¨'←' '∘←' ⋄ dm←(t=P)∧n=-sym⍳⊂,'.'
	i←i[⍋p[i←⍸(gm∨⌽≠⌽p)<p∊p[⍸gm]]]
	j←⍸(t[p]=Z)∧~dm∨t∊A ⋄ j←p[j⌿⍨(≠p[j])∧(t[j]=P)∧n[j]=-sym⍳⊂'⎕ns']
	msk←(t[i]∊V Z)∨(t[i]=P)∧k[i]=1	
	msk←(dm[i]∧1⌽msk)∨(msk∨t[i]=¯1)∧(p[i]≠1⌽p[i])∨1⌽dm[i]∨t[i]=¯1
	k[i⌿⍨(t[i]=V)∧((p[i]∊p[j])∨p[i]=1⌽p[i])∧∊(∧⌿∧⊢)¨msk⊆⍨1+p[i]]←1

	⍝ Resolve names
	vb[i]←p I⍣≡i←⍸(t=P)∧n=-sym⍳⊂,'#'
	bi←i←⍸(t[p]=H)∨t=L ⋄ bnr←n[i],⍪rf[i]
	_←{i←⍵ ⋄ ⍞←≢⍵ ⋄ bnr∘←1500⌶bnr
		⍝ Identify dotted-scope variables that are resolved
		sm←(t[j]=V)∨(t[j]=P)∧n[j←0⌈i-2]∊-sym⍳,¨'#' '##' '⎕this'
		rm←(¯1≠dv←vb[0⌈i-2])∧sm←sm∧(t[j]=P)∧n[j←0⌈i-1]=-sym⍳⊂,'.'

		⍝ Ensure that every dotted namespace references a T0
		j←∪dv⌿⍨rm∧(k[0⌈dv]=1)∧lx[0⌈dv]<0 ⋄ lx,←lx[j]←(≢p)+⍳≢j
		p,←r[j] ⋄ t k vb⍪←(≢j)⍴¨T 0 j ⋄ n r rf rz pos end(⊣⍪I)←⊂j
		p⍪←r⍪←rf⍪←rz⍪←lx[j] ⋄ t k n lx vb⍪←(≢j)⍴¨H 0 0 ¯1 ¯1
		pos end(⊣⍪I)←⊂j
		
		⍝ Scope variables
		lx[rm⌿i]←lx[rm⌿dv] ⋄ uv i←⌿∘i¨(sm>rm)(sm≤rm)
		lr←(lx[i]×msk)+r[i]×~msk←lx[i]≥0 ⋄ lrf←(lx[i]×msk)+rf[i]×~msk
		t[¯1+msk⌿i]←N
				
		⍝ Resolve ## and ⎕THIS
		vb[msk⌿i]←vb I@{vb[⍵]≠¯1}r I@{n[⍵]=-sym⍳⊂'##'}r I@{(t[⍵]=T)⍲k[⍵]=0}⍣≡lr⌿⍨msk←t[i]=P
		i lr lrf⌿⍨←⊂t[i]≠P
		⍞←' ##:',⍕+⌿msk
		
		⍝ Resolve locals
		fm←(t[lr]=T)∧k[lr]=0 ⋄ b←(bi⍪0)[j←bnr⍳n[i],⍪lrf]
		lm←(t[b]=L)∨(rz[b]<rz[i])∨(rz[b]=rz[i])∧pos[b]≥pos[i]
		j[⍸msk]←bnr⍳n[x←msk⌿i],⍪lr⌿⍨msk←(j=≢bnr)∨fm⍱lm ⋄ b←(bi⍪0)[j]
		msk←(j≠≢bnr)∧fm∨(t[b]=L)∨(rz[b]<rz[i])∨(rz[b]=rz[i])∧pos[b]≥pos[i]
		vb[msk⌿i]←msk⌿b ⋄ lx[i⌿⍨msk∧lx[i]<0]←¯1 ⋄ i lr⌿⍨←⊂~msk
		⍞←' L:',⍕+⌿msk
		
		xstart←≢i
		⍝ Resolve frees lexically
		bix←bi,¯1
		i lr←{i lr←⍵
			vb[i]←bix[j←bnr⍳n[i],⍪lr←r I@{(t[⍵]=T)⍲k[⍵]=0}lr]
		(j=≢bnr)∘⌿¨i lr}⍣≡i lr
		xend←≢i
		⍞←' X:',⍕xstart-xend
		
		⍝ Construct call graph
		x←(≠vb[x],⍪r[x])⌿x←⍸(t=V)∧(vb≠¯1)∧(vb∊vb[⍸(t∊T F)∧k≠0])∧(k[r]≠0)∧lx<0
		cgc←r[x] ⋄ cgo←x[vb[x←⍸t∊T F]⍳vb[x]]
		_←{0=≢cgc,←r[cgo,←cgc⌿⍨(vb[cgc]=¯1)∧(~cgc∊cgo)∧k[r[cgc]]≠0]}⍣⊣0
		cgc[j]←x[vb[x]⍳vb[cgc][j←⍸vb[cgc]≠¯1]]
		cgo cgc⌿⍨←⊂cgo≠cgc
		cgs←(≢cgu←∪cgo,cgc)⍴⊂⍬ ⋄ cgs[cgu⍳cgo],←cgu⍳cgc

		⍝ Resolve frees dynamically
		j jr←i(r I@{t[⍵]≠T}⍣≡r[i]) ⋄ jr←x[vb[x←⍸t=T]⍳vb[jr]]
		j jr⌿⍨←⊂(k[jr]≠0)∧(lx[j]<0)∧(jr∊cgo)∧n[j]∊n[bi] ⋄ dj dr←j jr
		j jr⌿⍨←⊂≠n[j],⍪jr ⋄ dr←j[(n[j],⍪jr)⍳n[dj],⍪dr]
		j←jr{⊂⍵}⌸j ⋄ vr←cgs[cgu⍳∪jr] ⋄ j vr⌿⍨←⊂0≠≢¨vr
		_←{
			vr,¨←fr←vr{(∪∊cgs[⍵])~∊⍺}¨⍵
			vr fr j⌿⍨←⊂0≠≢¨j∘←fr{0=≢⍺:⍬
				⍵⌿⍨¯1=vb[⍵]←bix[⌊/(≢¨⍵ ⍺)⍴bnr⍳↑,n[⍵]∘.,cgu[⍺]]
			}¨j
		fr}⍣{0=≢⍺}vr
		vb[dj]←vb[dr]
		⍞←' D:',⍕vb[i]+.≠¯1
		
		⍞←' N:',⍕vb[i]+.=¯1
		⍝ Resolve namespace-frees
		i lr⌿⍨←⊂vb[i]=¯1 ⋄ j←(≢p)+⍳≢ui←i⌿⍨msk←lr⌿⍨←≠x←n[i],⍪lr
		vb[i]←ij←j[x⍳⍨msk⌿x] ⋄ k⍪←(≢j)⍴¯1 ⋄ k[ij]⌈←k[i] ⋄ lx⍪←¯1⌊lx[ui]
		p⍪←x[p[x←⍸(t[p]=T)∧(k[p]=0)∧t=H]⍳lr]
		r rf rz⍪←⊂lr ⋄ vb⍪←(≢ui)⍴¯1 ⋄ t n pos end(⊣⍪I)←⊂ui
		bnr⍪←n[j],⍪lr ⋄ bi⍪←j
		
		⍝ Propagate kind to declaration
		k[vb[j]]←k[j←⍵⌿⍨(k[⍵]≠0)∧(t[vb[⍵]⌈0]=V)∧(k[vb[⍵]⌈0]=0)∧vb[⍵]≠¯1]
		
		⍞←' U:',⍕≢uv ⋄ ⎕←''
	uv}⍣≡⍸((t[p]≠H)∧(t=V)∧vb=¯1)∨(t=P)∧n∊-sym⍳'##' '⎕this'

	⍝ Parse Namespace References as Nk(Nk(...), E)
	i←i[⍋p[i←⍸(t[p]=Z)∧p≠⍳≢p]] ⋄ j←i⌿⍨msk←t[i]=N
	p[m2⌿i]←i⌿⍨¯2⌽m2←msk∧2⌽msk ⋄ p[i⌿⍨¯1⌽msk]←j ⋄ p[m2⌿i]←i⌿⍨¯1⌽m2←(1⌽msk)>¯1⌽msk
	k[j]←k[i⌿⍨¯1⌽msk]

	⍝ Enclose definitions in closures
	i←⍸(t=F)∨(t=T)∧k≠0 ⋄ np←((≢p)+⍳≢i)@i⊢⍳≢p
	p[j]←np[p[j←⍸p≠⍳≢p]] ⋄ r←np[r]
	p⍪←i ⋄ t k n r vb lx pos end(⊣⍪I)←⊂i ⋄ t[i]←C

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
	lx[im,id,iz,ix,iy]←¯5

	⍝ Mark brackets not addressing something as errors
	t[err←⍸(≠p)∧t=¯1]←X ⋄ k[err]←-≢EM∆
	EM∆⍪←⊂'BRACKET SYNTAX REQUIRES FUNCTION OR ARRAY TO ITS LEFT'

	⍝ Infer the type of groups and variables
	t[⍸(t=P)∧n=¯2]←V ⋄ v←⍸(t=V)∧(k=0)∧vb≥0
	zp←p[zi←{⍵[⍋p[⍵]]}⍸(t[p]∊N Z)∧(k[p]=0)∧t≠¯1]
	za←zi⌿⍨≠zp ⋄ zb←zi⌿⍨1⌽msk←⌽≠⌽zp ⋄ zc←msk⌿zi ⋄ z←p[za]
	zd[i]←vb I@{vb[⍵]≠¯1}⍣≡vb[i←⍸(t=Z)∧vb≠¯1]⊣zd←(≢p)⍴¯1
	zl←lx[vb[z]⌈0]=¯1 ⋄ zo←(≢p)⍴0
	zo[zc]←vb[zc]∊∊p[i]{0=≢⍵:⊂⍬
		⊂⍵[((2≤4|k[⍺])+((4≤8|k[⍺])>k[⍺]≥256)+⌊n[⍺]÷2*16)+⍳1+16≤32|k[⍺]]
	}⌸i←⍸(t[p]=H)∧8≤32|k[p]
	dot←-sym⍳⊂,'.'
	_←{
		nk←k[zc]×(za=zc)∨t[z]=N
		nk+←(k[zc])×(nk=0)∧za=vb[zc]
		nk+←3×(nk=0)∧(k[za]∊3 4)∧n[za]≠-sym⍳⊂,'∘.'
		nk+←(|k[zc])×(nk=0)∧k[zc]∊¯3 ¯4
		nk+←2×(nk=0)∧(k[zc]∊2 3 5)∨(4=|k[zb])∧n[zb]≠dot
		nk+←2×{zp zi←zp zi⌿⍨¨⊂zp∊z
			msk←(k[zi]=4)∧(n[zi]≠dot)∧⌽∘≠∘⌽U((~k[zi]∊0 1)⌿⊢)zp
			msk<←≠⍀(⊢∨0⍪¯1↓⊢)U((msk∨≠zp)⌿⊢)msk
			m2←(≢p)⍴0 ⋄ tm←(⍳≢p)∊ti←zi⌿⍨msk∨zi∊zc
			vi←ti⌿⍨(t[ti]=V)∧vb[ti]≠¯1 ⋄ vp←p[vi]
			vd←vb I@{vb[⍵]≠¯1}⍣≡vb[vi]
			_←{dz⊣m2[dz←dz⍪vp⌿⍨m2[vp]<vd∊zd[dz←tm[⍵]⌿p[⍵]]]←1}⍣{0=≢⍺}msk⌿zp
		m2[z]<z∊msk⌿zp}⍣(nk∧.=0)⊢0
		opm←zo[zc]∧(nk=1)∨(nk=2)∧(k[zc]=2)∧4≠|k[zb]
		k[z]←nk ⋄ zo[z]∨←zo[zc]∧(nk=1)∨(nk=2)∧(k[zc]=2)∧4≠|k[zb]
		i←z⌿⍨(vb[z]≠¯1)∧(zl≥zo[z])∧(k[zd[z]⌈0]=0)∧(nk≠4)∧(nk>1)∨(nk=1)∧(≠p)[0⌈vb[z]]
		k[zd[i]]←k[i] ⋄ k[v]←k[vb[v]]
		zo[zd[i]]←zo[i] ⋄ zo[v]∨←zo[vb[v]]
		z za zb zc zl⌿⍨←⊂nk=0 ⋄ v⌿⍨←k[v]=0
	v z}⍣≡⍬
	k[⍸(t∊N V Z)∧k=0]←1 ⋄ t[⍸(t=V)∧n=¯2]←P

	⍝ Enclose V+[X;...] in Z nodes for parsing
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i←⍸(t[p]=Z)∧p≠⍳≢p]] ⋄ km←((-≢x)↑(≢pi)⍴1)[x]
	msk←km∧(t[i]∊A)∨((t[i]∊N P V Z)∧k[i]=1)∨(t[i]=P)∧n[i]=-sym⍳⊂,'.'
	msk∧←(0,(2>⌿msk⍪0)⌿1⌽t[i]=¯1)[+⍀2<⌿0⍪msk]
	msk∨←(t[i]=¯1)∧(¯1⌽msk)∧1⌽msk
	msk∧←(0,gm⌿km⍲k[i]=4)[+⍀gm←2<⌿0⍪msk]
	j←i⌿⍨jm←(t[i]=¯1)∧msk∨¯1⌽msk
	np←(≢p)+⍳≢j ⋄ p←(x←np@j⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x
	p,←j ⋄ t k n lx vb pos end(⊣,I)←⊂j ⋄ t[j]←Z ⋄ k[j]←1
	p[msk⌿i]←j[msk⌿+⍀jm]

	⍝ Catch missing namespace references → Nk(Nk(...), E)
	i←i[⍋p[i←⍸(t[p]=Z)∧p≠⍳≢p]]
	j←i⌿⍨msk←(t[i]=P)∧(n[i]=dot)∧(¯1⌽k[i]=1)∧(⊢=¯1⌽⊢)p[i]
	p[m2⌿i]←i⌿⍨¯2⌽m2←msk∧2⌽msk ⋄ p[i⌿⍨¯1⌽msk]←j ⋄ p[m2⌿i]←i⌿⍨¯1⌽m2←(1⌽msk)>¯1⌽msk
	t[j]←N ⋄ k[j]←k[i⌿⍨¯1⌽msk]

	⍝ Wrap obvious and non-array bindings as B2+(V, Z)
	i←i[⍋p[i←⍸(t[p]=Z)∧p≠⍳≢p]]
	j←⍸(n[i]∊-sym⍳,¨'←' '∘←')∧(⊃¯1 1∧.⌽⊂k[i]≥2)∨((≠p)∧t=V)[¯1⌽i]
	p[(jt←i[j-1]),jv←i[j+1]]←,⍨ij←i[j] ⋄ t[ij]←B ⋄ k[ij]←k[jv] ⋄ lx[ij]←lx[jt]
	pos[ij]←pos[jt] ⋄ end[ij]←end[jv]

	⍝ Mark F[X] forms with k=4
	i←i[⍋p[i←⍸(p≠⍳≢p)∧(t[p]=Z)∧k[p]∊1 2 5]]
	t[err←i⌿⍨msk←(t[i]=¯1)∧≠p[i]]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'NOTHING TO INDEX'
	k[i⌿⍨msk<(t[i]=¯1)∧¯1⌽(k[i]∊2 3 5)∨¯1⌽k[i]=4]←4

	⍝ Parse strands/plural value sequences to A7 nodes
	i←|i⊣km←0<i←∊p[i](⊂-⍤⊣,⊢)⌸i←⍸(t[p]=Z)∨(t[p]=¯1)∧k[p]=4
	msk∧←⊃1 ¯1∨.⌽⊂msk←km∧(t[i]=A)∨(t[i]∊C N P V Z)∧k[i]=1
	np←(≢p)+⍳≢ai←i⌿⍨am←2>⌿msk⍪0 ⋄ p←(x←np@ai⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x ⋄ p,←ai
	t k n lx vb pos end(⊣,I)←⊂ai
	t k n lx vb pos(⊣@ai⍨)←A 7 0 ¯1 ¯1(pos[i⌿⍨km←2<⌿0⍪msk])
	p[msk⌿i]←ai[¯1++⍀km⌿⍨msk←msk∧~am]

	⍝ Rationalize F[X] syntax
	i←p[j←⍸(t[p]=¯1)∧k[p]=4]
	t[err←i⌿⍨~≠i]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'UNEXPECTED COMPOUND AXIS EXPRESSION'
	p[j]←p[i] ⋄ t[j←i~err]←P ⋄ lx[j]←¯4 ⋄ end[i]←1+pos[i]

	⍝ Wrap V[X;...] expressions as A¯1 nodes
	i←⍸t=¯1 ⋄ p←(x←p[i]@i⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x ⋄ t[p[i]]←A ⋄ k[p[i]]←¯1
	p t k n lx vb pos end⌿⍨←⊂t≠¯1 ⋄ p vb(⊣-1+⍸⍨)←⊂i

	⍝ Parse ⌶* nodes to V nodes
	i km←⍪⌿p[i]{(⍺⍪⍵)(0,1∨⍵)}⌸i←⍸p∊p[j←⍸pm←(t=P)∧n∊ns←-sym⍳,¨'⌶' '⌶⌶' '⌶⌶⌶' '⌶⌶⌶⌶']
	t[err←i⌿⍨msk←(i∊j)∧¯1⌽km∧(t[i]=A)⍲k[i]=1]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'INVALID ⌶ SYNTAX'
	vi←i⌿⍨1⌽msk←msk<i∊j ⋄ pi←msk⌿i
	t[vi]←V ⋄ k[vi]←2 3 4 1[ns⍳n[pi]] ⋄ lx[vi]←¯6 ⋄ end[vi]←end[pi]
	p t k n lx vb pos end⌿⍨←⊂~pm ⋄ p vb(⊣-1+⍸⍨)←⊂⍸pm

	⍝ Parse function expressions
	i←(ih⍪i)[x←⍋(ih←∪pi)⍪pi←p[i←⍸(t[p]=Z)∧(p≠⍳≢p)∧k[p]∊1 2 3]]
	km←((-≢x)↑(≢pi)⍴1)[x]
	dm←(¯1⌽km∧(k[i]=4)∧t[i]∊C N P V Z)∧km∧~k[i]∊0 3 4
	jm←km∧(t[i]=P)∧(n[i]∊-sym⍳⊂,'∘.')∧1⌽km∧k[i]∊1 2 5
	k[i⌿⍨(k[i]=5)∧dm∨¯1⌽jm∨(~km)∨(~dm)∧k[i]∊¯1 0 1 6 7]←2 ⋄ k[i⌿⍨k[i]=5]←3
	mm←km∧(~jm)∧(k[i]=3)∧(t[i]∊C N P V Z)∧(¯2⌽~dm)∧¯1⌽km∧~k[i]∊0 4
	msk←jm∨dm∨mm ⋄ np←(≢p)+⍳xc←≢oi←msk⌿i ⋄ p←(x←np@oi⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x
	p,←oi ⋄ t k n lx vb pos end(⊣,I)←⊂oi
	jl←¯1⌽jm ⋄ ml←(1⌽jl∧1⌽mm)∨(~jl)∧1⌽mm ⋄ dl←(1⌽jl∧2⌽dm)∨(km∧(~jl)∧2⌽dm)∨¯1⌽(~km)∧2⌽dm
	p[g⌿i]←oi[(g←(~msk)∧(1⌽dm)∨om←jl∨ml∨dl)⌿(+⍀msk)-jl]
	p[g⌿oi]←(g←msk⌿om)⌿1⌽oi ⋄ t[oi]←O ⋄ n[oi]←0 ⋄ vb[oi]←¯1
	pos[oi]←pos[g⌿i][msk⌿¯1++⍀g←jm∨(~msk)∧ml∨dl] ⋄ end[jm⌿i]←end[jl⌿i]
	ol←(k[om⌿i]≠4)×1+(k[i⌿⍨1⌽om]=4)∨k[om⌿i]∊2 3 ⋄ or←(msk⌿dm)⍀1+k[dm⌿i]=2
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

	⍝ Unparsed Z nodes become syntax error nodes
	t[err←⍸(t=Z)∧(k=2)∧(t[p]=E)∧k[p]=6]←X ⋄ k[err]←-≢EM∆
	t[err←zs⌿⍨1<1⊃zs zc←↓⍉p[i]⍪∘≢⌸i←⍸(t[p]=Z)∧p≠⍳≢p]←X ⋄ k[err]←-≢EM∆
	t[err←p[⍸(t[p]=Z)∧(k[p]=1)∧(t=O)∨(t∊B C N P V Z)∧k≠1]]←X ⋄ k[err]←-≢EM∆
	t[err←p[⍸(t[p]=Z)∧(k[p]=2)∧(t∊A E)∨(t∊B C N P V Z)∧k≠2]]←X ⋄ k[err]←-≢EM∆
	t[err←p[⍸(t[p]=Z)∧(k[p]∊3 4)∧(t∊A E O)∨(t∊B C N P V Z)∧k≠k[p]]]←X ⋄ k[err]←-≢EM∆
	t[err←p[⍸(t[p]=G)∧(≠p)∧(t∊A E)⍱k=1]]←X ⋄ k[err]←-≢EM∆
	EM∆⍪←⊂'SYNTAX ERROR'

	⍝ Eliminate Z nodes from the tree
	msk←(t≠Z)∧m2←t[p]=Z
	zi←{p I@{m2[⍵]}⍵⊣vb I@(≥∘0)⍨←ki@⍵⍳≢p}⍣≡p[ki←⍸msk]
	p←(x←zi@ki⍳≢p)[p] ⋄ vb I@(≥∘0)⍨←x
	t k n lx vb pos end(⊣@zi⍨)←t k n lx vb pos end I¨⊂ki
	p t k n lx vb pos end⌿⍨←⊂msk←msk⍱t=Z ⋄ p vb(⊣-1+⍸⍨)←⊂⍸~msk

	⍝ Merge simple arrays into single A1 nodes
	msk←((t=A)∧0=≡¨sym[|0⌊n])∧(t[p]=A)∧k[p]=7
	pm←(t=A)∧k=7 ⋄ pm[p]∧←msk ⋄ msk∧←pm[p]
	k[p[i←⍸msk]]←1 ⋄ n[∪pi]←-sym⍳sym∪←(pi←p[i]){⊂⍵}⌸sym[|n[i]]
	vb I@(≥∘0)⍨←pi@i⍳≢p ⋄ p t k n lx vb pos end⌿⍨←⊂~msk ⋄ p vb(⊣-1+⍸⍨)←⊂⍸msk
	
	⍝ All A1 nodes should be lexical scope 7
	lx[⍸(t=A)∧k=1]←¯7

	⍝ Convert assignment expressions to E4 nodes, bindings to B nodes
	bp←(t=P)∧n∊-sym⍳,¨'←' '⍠←' '∘←'
	bem←bp∧((k=2)∧(t[p]=E)⍲k[p]=2)∨(k=3)∧(t[p][p]=E)⍲k[p][p]=2
	t[err←p[⍸bem∧k=2]⍪p[p][⍸bem∧k=3]]←X ⋄ k[err]←-≢EM∆ ⋄ EM∆⍪←⊂'MISSING ASSIGNMENT TARGET'
	i←p[⍸bem<bp∧(k=2)] ⋄ k[i]←4
	i←p[j←⍸(≠p)∧(em←(t[p]=E)∧k[p]=4)∧am←(t∊P V)∨(t=A)∧k∊0 7]
	i⍪←p[p][j⍪←⍸(⌽≠⌽p)∧am∧em[p]∧t[p]=N]
	t[i]←B ⋄ k[i]←1 ⋄ lx[i]←lx[j]
	i←p[p][⍸bem<bp∧(k=3)] ⋄ k[i]←4
	n[p[i]]←n[i←⍸msk←bp∧t[p]=B]
	p t k n lx vb pos end⌿⍨←⊂~msk ⋄ p vb(⊣-1+⍸⍨)←⊂i
	
	⍝ Check that we have well-formed E4 nodes
	t[err←⍸p[(~t∊A P V)∧msk←((t=E)⍲k=2)∧(≠p)∧(t[p]=E)∧k[p]=4]]←X ⋄ k[err]←-≢EM∆
	EM∆⍪←⊂'INVALID ASSIGNMENT TARGET'
	t[err←⍸p[p][(t≠V)∧msk←((t=A)⍲k=¯1)∧(⌽≠⌽p)∧p∊⍸msk]]←X ⋄ k[err]←-≢EM∆
	EM∆⍪←⊂'INVALID SELECTIVE ASSIGNMENT TARGET'
	t[err←⍸p[p][p][(t≠V)∧(≠p)∧p∊⍸msk]]←X ⋄ k[err]←-≢EM∆
	EM∆⍪←⊂'INVALID INDEXED SELECTIVE ASSIGNMENT TARGET'

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
	p,←2⌿ip ⋄ t,←nc⍴P E ⋄ k,←nc⍴2 6 ⋄ n,←nc⍴-sym⍳,¨'[' '' ⋄ lx,←nc⍴¯4 0 ⋄ vb,←nc⍴¯1
	pos,←2⌿pos[ip] ⋄ end,←∊(1+pos[ip]),⍪end[ip] ⋄ pos[ip]←pos[i⌿⍨~msk]

	⍝ Check for nested ⍠← forms
	t[err←⍸(t=B)∧(n∊-sym⍳⊂'⍠←')∧t[p]≠F]←X ⋄ k[err]←-≢EM∆ ⋄ t[i←p[err]]←X ⋄ k[i]←0
	EM∆⍪←⊂'⍠← MUST BE THE LEFTMOST FORM IN AN UNGUARDED EXPRESSION'

	⍝ Compute exports
	i←⍸(p=⍳≢p)[p][p]∧(k[p][p]=0)∧(t[p][p]=T)∧t[p]=H
	xn←sym[|n[i]] ⋄ xt←k[i]

	⍝ Normaliz error kinds into EM∆ indices
	k[i]←|k[i←⍸t=X]

	⍝ Sort AST by depth-first pre-order traversal
	d i←P2D p ⋄ p d t k n lx vb pos end I∘⊢←⊂i ⋄ p←i⍳p ⋄ vb←i⍳@{⍵≥0}vb

	(p d t k n lx vb pos end)(xn xt)sym IN
}
