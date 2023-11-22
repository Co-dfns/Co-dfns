GC←{
	p t k n lx mu lv fv pos end sym IN←⍵

	⍝ Make sure signal retains the stack
	SIGNAL←{⍎'⍺ ⎕SIGNAL ⍵'}
	
	⍝ Text utilities
	csep←{⎕PP←34 ⋄ ¯2↓⊃,⌿(⍕¨⍵),¨⊂', '}
	
	⍝ Tracing information
	linestarts←⍸1⍪IN∊CR LF←⎕UCS 13 10
	highlight←{
		s←pos[⍵] ⋄ e←end[⍵] ⋄ lineno←linestarts⍸s
		line←IN[b+⍳te←linestarts[lineno+1]-b←linestarts[lineno]]
		ls le←s e-b ⋄ line←∊'╠'⊂⍤,@ls⊢'╣'⊂⍤,⍨@(¯1+le⌊te)⊢line
		'\\'⎕R'\\\\'⊢'L"[',(⍕1+lineno),'] ',(line~CR LF),'"'
	}


	⍝ Variable generation utilities
	var_ckinds←{
		types←'' 'array' 'func' 'moper' 'doper' 'env' 'void' 'array'
		types[1@(⍸t[⍵]=E)⊢k[⍵]]
	}

	var_names←{
		ceqv←'_del_' '_delubar_'
		asym←'∆'     '⍙'
		'cdf_'∘,¨(,¨asym)⎕R ceqv⊢sym[|n[⍵]]
	}

	var_scopes←{
		(0⍴⊂''),'loc->' 'lex->' 'dyn->' 'cdf_prim.' '' ''[lx[⍵]]
	}

	var_nmvec←{
		0=≢⍵:'wchar_t **',⍺,' = NULL;'
		z←'wchar_t *',⍺,'[] = {'
		z,←⊃{⍺,', ',⍵}⌿'L"'∘,¨sym[|n[⍵]],¨'"'
		z,'};'
	}

	decl_vars←{
		0=≢⍵:0⍴⊂''
		0∊k[⍵]:'CANNOT DECLARE STACK VARIABLE'SIGNAL 99
		∨⌿(k[⍵]=6)∧lx[⍵]>3:'CANNOT DECLARE AMBIGUOUS GLOBAL'SIGNAL 99
		z  ←'' 'extern '[lx[⍵]=5]
		z,¨←'' 'struct cell_'[lx[⍵]≠4]
		z,¨←var_ckinds ⍵
		z,¨←'' '_ptr'[lx[⍵]=4]
		z,¨←' ' '_box '[mu[⍵]]
		z,¨←'' '*'[lx[⍵]≠4]
		z,¨←var_names ⍵
		z,¨';'
	}

	init_vars←{
		0=≢⍵:0⍴⊂''
		0∊k[⍵]:'CANNOT INITIALIZE STACK VARIABLE'SIGNAL 99
		z←(≢⍵)⍴⊂''
		i←⍸~mu[⍵] ⋄ z[i],←⊂¨(var_refs ⍵[i]),¨⊂' = NULL;'
		i←⍸mu[⍵]
		z[i],←(var_ckinds ⍵[i]){
			msg←'L"Init mutable variable: ',⍵,'"'
			⊂'CHK(mk_',⍺,'_box(&',⍵,', NULL), cleanup, ',msg,');'
		}¨var_refs ⍵[i]
		⊃⍪⌿z
	}

	var_refs←{
		0∊k[⍵]:'CANNOT REFERENCE STACK VARIABLE'SIGNAL 99
		(var_scopes,¨var_names) ⍵
	}

	var_values←{
		z←(var_scopes,¨var_names)⍵
		z,¨←'' '->value'[mu[⍵]]
		z[⍸0=k[,⍵]]←⊂'*--stkhd'
		z
	}

	⍝ All code has an initial prefix
	pref ←⊂'#include "codfns.h"'
	pref,←⊂'#include "',⍺,'.h"'
	pref,←⊂''
	pref,←⊂'EXPORT int'
	pref,←⊂'DyalogGetInterpreterFunctions(void *p)'
	pref,←⊂'{'
	pref,←⊂'    return set_dwafns(p);'
	pref,←⊂'}'
	pref,←⊂''

	⍝ We declare all external variables in the prefix
	pref,←decl_vars ⍸(t=V)∧lx=5
	pref,←⊂''

	⍝ We have a vector output for each node in the AST
	zz←(≢p)⍴⊂''
	
	⍝ Z¯N: Error nodes
	i←⍸(t=Z)∧k<0
	zz[i],←{
		line←highlight ⍵
		('CHK(',(⍕|k[⍵]),', cleanup, ',line,');') ''
	}¨i
	
	⍝ A1: Simple arrays
	i←⍸(t=A)∧k=1
	atypes←'BOOL' 'SINT'    'SINT'    'INT'     'DBL'    'CMPX' 
	ctypes←'char' 'int16_t' 'int16_t' 'int32_t' 'double' 'struct apl_cmpx'
	drtypes←11     83        163       323       645      1289
	atypes,←'CHAR8'   'CHAR16'   'CHAR32'
	ctypes,←'uint8_t' 'uint16_t' 'uint32_t'
	drtypes,←80        160        320
	zz[i],←{
		rnk←≢shp←⍴dat←(|n[⍵])⊃sym ⋄ dri←drtypes⍳⎕DR dat
		atp←dri⊃atypes ⋄ ctp←dri⊃ctypes
		fmt←{⎕PP←34 ⋄ 1289=⎕DR ⍵:'{',(csep 9 11○⍵),'}' ⋄ ⍕⍵}
		dat←'¯'⎕R'-'∘fmt¨⎕UCS⍣(0=10|⎕DR dat)⊃⍣(0=≢,dat)⊢dat
		dbg←highlight ⍵
		z ←⊂'{'
		z,←⊂'	static ',ctp,' dat[] = {',(csep dat),'};'
		z,←⊂'	static unsigned vrefc = 1;'
		z,←⊂'	static struct cell_array val = {'
		z,←⊂'		CELL_ARRAY, 1, STG_HOST, ARR_',atp,','
		z,←⊂'		dat, &vrefc, ',(⍕rnk),','
		z,←⊂'		',(csep shp,0)
		z,←⊂'	};'
		z,←⊂''
		z,←⊂'	vrefc++;'
		z,←⊂'	*stkhd++ = retain_cell(&val);'
		z,←⊂'}'
		z,⊂''
	}¨i
	
	⍝ A7/E6: Stranded Arrays and Indexing
	i←⍸((t=A)∧k=7)∨(t=E)∧k=6
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight ⍵
		z ←⊂'CHK(mk_nested_array(&stkhd, ',(⍕n[⍵]),'), cleanup,'
		z,←⊂'    ',dbg,');'
		z
	}¨i
	
	⍝ V: Variable reference
	i←⍸t=V
	zz[i],←{
		0=≢i:0⍴⊂''
		tgt←var_values ⍵
		dbg←highlight ⍵
		⊂'CHK(var_ref(&stkhd, ',tgt,'), cleanup, ',dbg,');'
	}¨i

	⍝ B: Non-option bindings
	i←⍸(t=B)∧k≠7
	zz[i],←{
		0=≢i:0⍴⊂''
		tgt←var_values ⍵
		dbg←highlight ⍵
		⊂'bind_value(&stkhd, &',tgt,');'
	}¨i
	
	⍝ C: Closures for functions
	i←⍸t[p]=C
	zz[∪p[i]],←p[i]{
		0=≢i:⊂0⍴⊂''
		ctyp←k[⍺]⊃'func' 'func' 'func' 'moper' 'doper'
		vc←(≢⍵)-fc←0 1 2 4 8[k[⍺]]
		fs vs←{(fc↑⍵)(fc↓⍵)}⍵
		fids←var_refs fs
		vids←var_refs vs[⍋n[vs]]
		dbg←highlight ⍺
		call←'mk_closure_',ctyp,'(&stkhd, ',(csep fids),', ',(⍕vc),', fvs)'
		z ←⊂'{'
		z,←⊂'	void *fvs[] = {',(csep vids,0),'};'
		z,←⊂''
		z,←⊂'	CHK(',call,', cleanup, '
		z,←⊂'	    ',dbg,');'
		z,←⊂'}'
		⊂z,⊂''
	}⌸i

	⍝ E¯1: Non-returning end of line statement
	i←⍸(t=E)∧k=¯1
	zz[i],←{
		0=≢i:0⍴⊂''
		z ←⊂'release_cell(*--stkhd);'
		z,⊂''
	}¨i

	⍝ E0: Returning end of line statement
	i←⍸(t=E)∧k=0
	zz[i],←{
		0=≢i:0⍴⊂''
		z ←⊂'*z = *--stkhd;'
		z,←⊂'goto cleanup;'
		z,⊂''
	}¨i
	
	⍝ E1: Monadic expression application
	i←⍸(t=E)∧k=1
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight ⍵
		⊂'CHK(apply_monadic(&stkhd), cleanup, ',dbg,');'
	}¨i
	
	⍝ E2: Dyadic expression application
	i←⍸(t=E)∧k=2
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight ⍵
		⊂'CHK(apply_dyadic(&stkhd), cleanup, ',dbg,');'
	}¨i
	
	⍝ E4: Assignment
	i←⍸(t=E)∧k=4
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight ⍵
		tgt←var_refs ⍵
		⊂'CHK(apply_assign(&stkhd, ',tgt,'), cleanup, ',dbg,');'
	}¨i
	
	⍝ Om: Monadic operators
	i←⍸(t=O)∧k∊1 2
	zz[i],←{
		0=≢i:0⍴⊂''
		ltyp←'array' 'func'⊃⍨k[⍵]=2
		dbg←highlight ⍵
		⊂'CHK(apply_mop_',(⊃ltyp),'(&stkhd), cleanup, ',dbg,');'
	}¨i
	
	⍝ Od: Dyadic operators
	i←⍸(t=O)∧k∊4 5 7 8
	zz[i],←{
		0=≢i:0⍴⊂''
		ltyp←'array' 'func'⊃⍨k[⍵]∊5 8
		rtyp←'array' 'func'⊃⍨k[⍵]∊7 8
		fns←csep 'op->fptr_'∘,¨(⊃rtyp),¨(⊃ltyp),¨'md'
		dbg←highlight ⍵
		⊂'CHK(apply_dop_',(⊃rtyp),(⊃ltyp),'(&stkhd), cleanup, ',dbg,');'
	}¨i
	
	⍝ Ox: Axis Operator and Variant Operator
	i←⍸(t=O)∧k=¯1
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight ⍵
		⊂'CHK(apply_variant(&stkhd), cleanup, ',dbg,');'
	}¨i

	⍝ B7: Option bindings
	i←⍸(t=B)∧k=7
	zz[i],←{
		0=≢i:0⍴⊂''
		tgt←var_values ⍵
		opt←var_names ⍵
		dbg←highlight ⍵
		z ←⊂'if (opts && opts->',opt,') {'
		z,←⊂'	*stkhd++ = retain_cell(opts->',opt,');'
		z,←⊂'} else {'
		z,← '	'∘,¨⊃⍪⌿(⍵=p)⌿zz
		z,←⊂'}'
		z,←⊂''
		z,←⊂'bind_value(&stkhd, &',tgt,'); /* ',dbg,' */'
		z,⊂''
	}¨i

	⍝ G0: Value guards
	i←⍸t=G
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight n[⍵]
		z ←⊂'TRC(guard_check(&stkhd), ',dbg,');'
		z,←⊂''
		z,←⊂'if (err > 0)'
		z,←⊂'	goto cleanup;'
		z,←⊂''
		z,←⊂'if (!err) {'
		z,← '	'∘,¨⊃⍪⌿(⍵=p)⌿zz
		z,←⊂'	err = -1;'
		z,←⊂'	goto cleanup;'
		z,←⊂'}'
		z,←⊂''
		z,←⊂'err = 0;'
		z,⊂''
	}¨i
	
	⍝ FN: Non-zero functions
	i←⍸(t=F)∧k≠0
	zz[i],←{
		0=≢i:0⍴⊂''
		id←⊃var_values ⍵
		atyp←'array' 'func'⊃⍨k[⍵]∊3 6 9 12 15 18 21
		ddtyp←'' 'moper' 'doper'⊃⍨0 5 11⍸k[⍵]
		aatyp←'array' 'func'⊃⍨k[⍵]∊8 9 10 14 15 16 20 21 22
		wwtyp←'array' 'func'⊃⍨k[⍵]∊17 18 19 20 21 22
		haslvs←0≠≢lvs←⊃lv[⍵]
		hasfvs←0≠≢fvs←{⍵[⍋n[⍵]]}⊃fv[⍵]
		hasopts←0≠≢opts←lvs⌿⍨k[lvs]=7
		ism←k[⍵]∊2 3 5 6 8 9 11 12 14 15 17 18 20 21
		isop←k[⍵]≥5
		isdop←k[⍵]≥11
		self←'cdf_self' 'cdf_deldel'⊃⍨isop
		pref,←⊂'int ',id,'(struct cell_array **,'
		pref,←(⊂'    struct cell_array *,')⌿⍨~ism
		pref,←⊂'    struct cell_array *,'
		pref,←⊂'    struct cell_func *);'
		z ←⊂'int'
		z,←⊂id,'(struct cell_array **z,'
		z,←(⊂'    struct cell_array *cdf_alpha,')⌿⍨~ism
		z,←⊂'    struct cell_array *cdf_omega,'
		z,←⊂'    struct cell_func *cdf_self)'
		z,←⊂'{'
		z,←⊂'	void *stk[256];'
		z,←⊂'	void **stkhd;'
		z,←⊂'	int err;'
		z,←(⊂'	struct cell_',atyp,' *cdf_alpha;')⌿⍨ism
		z,←(⊂'	struct cell_',ddtyp,' *cdf_deldel;')⌿⍨isop
		z,←(⊂'	struct cell_',aatyp,' *cdf_alphaalpha;')⌿⍨isop
		z,←(⊂'	struct cell_',wwtyp,' *cdf_omegaomega;')⌿⍨isdop
		z,←⊂''
		z,←(⊂'	cdf_alpha = NULL;')⌿⍨ism
		z,←(⊂'	cdf_deldel = cdf_self->fv[0];')⌿⍨isop
		z,←(⊂'	cdf_alphaalpha = cdf_self->fv[1];')⌿⍨isop
		z,←(⊂'	cdf_omegaomega = cdf_self->fv[2];')⌿⍨isdop
		z,←(⊂'')⌿⍨ism∨isop
		z,←(⊂'	struct {')⌿⍨haslvs
		z,←'		'∘,¨decl_vars lvs
		z,←(⊂'	} loc_frm, *loc;')⌿⍨haslvs
		z,←(⊂'')⌿⍨haslvs
		z,←(⊂'	loc = &loc_frm;')⌿⍨haslvs
		z,←(⊂'')⌿⍨haslvs
		z,←(⊂'	struct lex_vars {')⌿⍨hasfvs
		z,←'		'∘,¨decl_vars fvs
		z,←(⊂'	} *lex;')⌿⍨hasfvs
		z,←(⊂'')⌿⍨hasfvs
		z,←(⊂'	lex = (struct lex_vars *)',self,'->fv;')⌿⍨hasfvs
		z,←(⊂'')⌿⍨hasfvs
		z,←(⊂'	struct opt_vars {')⌿⍨hasopts
		z,←'		'∘,¨decl_vars opts
		z,←(⊂'	} *opts;')⌿⍨hasopts
		z,←(⊂'')⌿⍨hasopts
		z,←(⊂'	opts = (struct opt_vars *)cdf_self->opts;')⌿⍨hasopts
		z,←(⊂'')⌿⍨hasopts
		z,←(⊂'	'),¨init_vars lvs
		z,←⊂'	err = 0;'
		z,←⊂'	stkhd = &stk[0];'
		z,←⊂''
		z,←(⊂'	'),¨⊃⍪⌿(p=⍵)⌿zz
		z,←⊂'	err = -1;'
		z,←⊂''
		z,←⊂'cleanup:'
		z,←⊂'	if (!err && stk != stkhd)'
		z,←⊂'		CHK(99, cleanup, L"Stack not empty");'
		z,←⊂''
		z,←⊂'	release_env(stk, stkhd);'
		z,←(⊂'	release_env((void **)loc, (void **)(loc + 1));')⌿⍨haslvs
		z,←(⊂'	release_',atyp,'(cdf_alpha);')⌿⍨ism
		z,←⊂''
		z,←⊂'	if (err)'
		z,←⊂'		return err;'
		z,←⊂''
		z,←⊂'	TRC(chk_array_valid(*z), '
		z,←⊂'	    ',(highlight ⍵),');'
		z,←⊂'	return err;'
		z,←⊂'}'
		z,⊂''
	}¨i
	pref,←⊂''

	⍝ F0: Initialization functions for namespaces
	i←⍸(t=F)∧k=0
	zz[i],←{
		id←⊃var_names ⍵
		z ←⊂'int ',id,'_flag = 0;'
		z,←⊂''
		z,←⊂(id,'_names')var_nmvec ⊃lv[⍵]
		z,←⊂''
		z,←⊂'EXPORT int'
		z,←⊂id,'_init(void)'
		z,←⊂'{'
		z,←⊂'	struct ',id,'_loc *loc;'
		z,←⊂'	void *stk[256];'
		z,←⊂'	void **stkhd;'
		z,←⊂'	int err;'
		z,←⊂''
		z,←⊂'	if (',id,'_flag)'
		z,←⊂'		return 0;'
		z,←⊂''
		z,←⊂'	err = 0;'
		z,←⊂'	',id,'_flag = 1;'
		z,←⊂'	stkhd = &stk[0];'
		z,←⊂'	loc = &',id,';'
		z,←⊂'	loc->__count = ',(⍕≢⊃lv[⍵]),';'
		z,←⊂'	loc->__names = ',id,'_names;'
		z,←⊂''
		z,←⊂'	release_debug_info();'
		z,←⊂''
		z,←⊂'	CHKFN(cdf_prim_init(), cleanup);'
		z,←⊂''
		z,←(⊂'	'),¨init_vars ⊃lv[⍵]
		z,←⊂''
		z,←(⊂'	'),¨⊃⍪⌿(p=⍵)⌿zz
		z,←⊂''
		z,←⊂'cleanup:'
		z,←⊂'	release_env(stk, stkhd);'
		z,←⊂'	return err;'
		z,←⊂'}'
		z,⊂''
	}¨i

	⍝ Export headers
	header←{∊(⊃⍪⌿⍵),¨⊂⎕UCS 13 10}{
		0=≢i:0⍴⊂''
		id←⊃var_names ⍵
		pref,←⊂'EXPORT struct ',id,'_loc ',id,';'
		z ←⊂'struct ',id,'_loc {'
		z,←⊂'	unsigned int __count;'
		z,←⊂'	wchar_t **__names;'
		z,←(⊂'	'),¨decl_vars ⊃lv[⍵]
		z,←⊂'};'
		z,←⊂''
		z
	}¨i
	pref,←⊂''
	
	⍝ Export functions
	i←⍸(t=B)∧(k=2)∧k[p]=0
	exp←⊃⍪⌿{
		fn ns←var_names ⍵,p[⍵]
		fnv←⊃var_values ⍵
		z ←⊂'EXPORT int'
		z,←⊂fn,'(struct cell_array **z, struct cell_array *l, struct cell_array *r)'
		z,←⊂'{'
		z,←⊂'	struct cell_func *self;'
		z,←⊂'	struct ',ns,'_loc *loc;'
		z,←⊂'	int err;'
		z,←⊂''
		z,←⊂'	CHKFN(',ns,'_init(), fail);'
		z,←⊂''
		z,←⊂'	loc = &',ns,';'
		z,←⊂'	self = ',fnv,';'
		z,←⊂''
		z,←⊂'	if (l == NULL) {'
		z,←⊂'		CHKFN(self->fptr_mon(z, r, self), fail);'
		z,←⊂'	} else {'
		z,←⊂'		CHKFN(self->fptr_dya(z, l, r, self), fail);'
		z,←⊂'	}'
		z,←⊂''
		z,←⊂'fail:'
		z,←⊂'	return err;'
		z,←⊂'}'
		z,←⊂''
		z,←⊂'EXPORT int'
		z,←⊂fn,'_dwa(void *z, void *l, void *r)'
		z,←⊂'{'
		z,←⊂'	return call_dwa(',fn,', z, l, r, L"',fn,'");'
		z,←⊂'}'
		z,⊂''
	}¨i

	⍝ Warn about nodes that appear which we haven't generated
	⍞←(∨⌿msk)↑(⎕UCS 10)(⊣,⍨,)⍉⍪'Ungenerated nodes: ',⍕,∪(msk←zz∊⊂'')⌿N∆[t],∘⍕¨k

	⍝ Assemble all the data together into a single character vector
	data←∊(pref,(⊃⍪⌿zz[⍸p=⍳≢p]),exp),¨⊂⎕UCS 13 10
	
	⍝ Return data+headers
	data header
}
