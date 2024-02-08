TK←{⍺←⊢
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
	prmfs←'+-×÷|⌈⌊*⍟○!?~∧∨⍲⍱<≤=>≥≠≡≢⍴,⍪⌽⊖⍉↑↓⊂⊆⊃∊⍷∩∪⍳⍸⌷⍋⍒⍎⍕⊥⊤⊣⊢⌹∇→⌺'
	prmmo←'¨⍨&⌶⌸' ⋄ prmdo←'∘.⍣⍠⍤⍥@' ⋄ prmfo←'/⌿\⍀'
	prms←prmfs,prmmo,prmdo,prmfo

	⍝ Guarantee everything is LF-terminated
	IN←LF@{⍵=CR}(~CR LF⍷IN)⌿IN←∊(⊆IN),¨⎕UCS 10

	err←'PARSER EXPECTS CHARACTER ARRAY'
	0≠10|⎕DR IN:err ⎕SIGNAL 11

	⍝ Group input into lines as a nested vector
	pos←(⍳≢IN)⊆⍨~IN∊CR LF

	⍝ Mask potential strings
	msk←(''''''∘⍷¨x)∨≠⍀¨''''=x←IN∘I¨pos

	⍝ Remove comments
	pos msk⌿¨⍨←⊂∧⍀¨(~msk)⍲'⍝'=IN∘I¨pos

	⍝ Check for unbalanced strings
	lin←⍸⊃∘⌽¨msk
	0≠≢lin:('UNBALANCED STRING','S'⌿⍨2≤≢lin)SIGNAL ∊(msk⌿¨pos)[lin]

	⍝ Flatten parser representation
	t←⊃0⍴⊂pos ⋄ t pos msk(∊,∘⍪⍨)←Z (⊃¨pos) 0

	⍝ Tokenize strings
	end←1+pos ⋄ t[i←⍸2<⌿0⍪msk]←C ⋄ end[i]←1+end[⍸2>⌿msk⍪0]
	t pos end⌿⍨←⊂(t≠0)∨~¯1⌽msk

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
	∨⌿msk←1<+⌿¨dm⊆'¯'=x:'MULTIPLE ¯ IN NUMBER'SIGNAL ∊msk⌿dm⊆pos
	∨⌿msk←('¯'=x)∧~dm:'ORPHANED ¯'SIGNAL msk⌿pos
	dm∨←(msk←x∊'Ee')∧(¯1⌽dm)∧1⌽dm
	dm←dm⍀∊{¯1↓1@(⊃⍸⍵)~⍵⍪0}¨dm⊆msk
	dm∨←(msk←x∊'Jj')∧(¯1⌽dm)∧1⌽dm
	dm←dm⍀∊{¯1↓1@(⊃⍸⍵)~⍵⍪0}¨dm⊆msk
	(msk⌿dm)←∊∧⍀¨(msk←x∊alp,num)⊆dm
	dm[⍸dm∧(x='.')∧~(¯1⌽dm)∨1⌽dm]←0
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
	t[⍸x∊syna]←A ⋄ t[⍸(~dm)∧x∊prms,'←']←P
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
	
	(d t k n pos end)sym IN
}