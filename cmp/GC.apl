GC←{
	p t k n lx mu lv fv sv pos end sym IN←⍵

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
		'\\'⎕R'\\\\'⊢'"[',(⍕1+lineno),'] ',(line~CR LF),'"'
	}


	⍝ Variable generation utilities
	var_ckinds←{
		types←'' 'array' 'func' 'moper' 'doper' 'env' 'void' 'array'
		isa←t[⍵]∊A E S
		isfn←(t[⍵]=O)∨(t[⍵]=F)∧k[⍵]<5
		isdop←(t[⍵]=F)∧k[⍵]≥11
		ismop←(~isdop)∧(t[⍵]=F)∧k[⍵]≥5
		types[4@{isdop}3@{ismop}2@{isfn}1@{isa}k[⍵]]
	}

	var_names←{
		ceqv←'_del_' '_delubar_'
		asym←'∆'     '⍙'
		islit←(t[⍵]=A)∧k[⍵]=1
		nam←⍵
		nam[i]←'l',∘⍕¨|n[⍵[i←⍸islit]]
		nam[i]←(⊃¨var_ckinds ⍵[i]),¨⍕¨n[⍵[i←⍸(~islit)∧n[⍵]≥0]]
		nam[i]←sym[|n[⍵[i←⍸(~islit)∧n[⍵]<0]]]
		'cdf_'∘,¨(,¨asym)⎕R ceqv⊢(0⍴⊂''),nam
	}

	var_scopes←{
		(0⍴⊂''),'loc->' 'lex->' 'dyn->' 'cdf_prim.' '' '' ''[lx[⍵]]
	}

	var_nmvec←{
		0=≢⍵:'char **',⍺,' = NULL;'
		z←'char *',⍺,'[] = {'
		z,←⊃{⍺,', ',⍵}⌿'"'∘,¨sym[|n[⍵]],¨'"'
		z,'};'
	}

	decl_vars←{⍺←0
		0=≢⍵:0⍴⊂''
		⍝ ∨⌿(k[⍵]=6)∧lx[⍵]>3:'CANNOT DECLARE AMBIGUOUS GLOBAL'SIGNAL 99
		z  ←'' 'extern '[lx[⍵]=5]
		z,¨←'' 'struct cell_'[lx[⍵]≠4]
		z,¨←var_ckinds ⍵
		z,¨←'' '_ptr'[lx[⍵]=4]
		z,¨←' ' ' *'[⍺]
		z,¨←'' '*'[lx[⍵]≠4]
		z,¨←var_names ⍵
		z,¨';'
	}

	init_vars←{
		0=≢⍵:0⍴⊂''
		z←(≢⍵)⍴⊂''
		(var_values ⍵),¨⊂' = NULL;'
		⊃⍪⌿z
	}

	var_refs←{
		z←'&' ''[lx[⍵]=1]
		z,¨←(var_scopes,¨var_names)⍵
		z[⍸(n[,⍵]=0)∧(t[,⍵]=A)⍲k[,⍵]=1]←⊂,'z'
		'(',¨z,¨')'
	}

	var_values←{
		z←'' '*'[lx[⍵]=1]
		z,¨←(var_scopes,¨var_names)⍵
		z[⍸(n[,⍵]=0)∧(t[,⍵]=A)⍲k[,⍵]=1]←⊂,'(*z)'
		'(',¨z,¨')'
	}
	
	check_vars←{
		(highlight¨⍵){'CHK(var_ref(',⍵,'), cleanup, ',⍺,');'}¨var_values ⍵
	}
	
	release_vars←{
		'release_'∘,¨(var_ckinds ⍵),¨'(',¨(var_values ⍵),¨⊂');'
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
	pref,←decl_vars ⍸msk∧msk⍀≠n⌿⍨msk←(t=V)∧lx=5
	pref,←⊂''
	
	⍝ Define all literals as static values
	atypes←'BOOL' 'SINT'    'SINT'    'INT'     'DBL'    'CMPX' 
	ctypes←'char' 'int16_t' 'int16_t' 'int32_t' 'double' 'struct apl_cmpx'
	drtypes←11     83        163       323       645      1289
	atypes,←'CHAR8'   'CHAR16'   'CHAR32'
	ctypes,←'uint8_t' 'uint16_t' 'uint32_t'
	drtypes,←80        160        320
	pref,←⊃⍪⌿{
		rnk←≢shp←⍴dat←⍵⊃sym ⋄ dri←drtypes⍳⎕DR dat
		atp←dri⊃atypes ⋄ ctp←dri⊃ctypes
		fmt←{⎕PP←34 ⋄ 1289=⎕DR ⍵:'{',(csep 9 11○⍵),'}' ⋄ ⍕⍵}
		dat←'¯'⎕R'-'∘fmt¨⎕UCS⍣(0=10|⎕DR dat)⊃⍣(0=≢,dat)⊢dat
		nam←'cdf_l',⍕⍵
		z ←⊂'static ',ctp,' ',nam,'_dat[] = {',(csep dat),'};'
		z,←⊂'static struct cell_array ',nam,'_val = {'
		z,←⊂'	CELL_ARRAY, 1, STG_HOST, ARR_',atp,','
		z,←⊂'	',nam,'_dat, NULL, ',(⍕rnk),','
		z,←⊂'	{',(csep shp,0),'}'
		z,←⊂'};'
		z,←⊂'static struct cell_array *',nam,' = &',nam,'_val;'
		z,⊂''
	}¨∪|n⌿⍨(t=A)∧k=1

	⍝ We have a vector output for each node in the AST
	zz←(≢p)⍴⊂'' ⋄ kk←(≢p)⍴⊂⍬ ⋄ _←{kk[⍺]←⊂⍵~⍺}⌸p
	
	⍝ Z¯N: Error nodes
	i←⍸(t=Z)∧k<0
	zz[i],←{
		line←highlight ⍵
		('CHK(',(⍕|k[⍵]),', cleanup, ',line,');') ''
	}¨i
	
	⍝ A7/E6: Stranded Arrays and Indexing
	i←⍸((t=A)∧k=7)∨(t=E)∧k=6
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight ⍵
		tgt←⊃var_values ⍵ ⋄ tref←⊃var_refs ⍵ ⋄ vs←var_values⊢ks←⍵⊃kk
		z ←check_vars⊢ks←⍵⊃kk
		z,←⊂'CHK(mk_nested_array(',tref,', ',(⍕≢ks),'), cleanup, ',dbg,');'
		z,←⊂''
		z,←⊂'{'
		z,←⊂'	struct cell_array **dat = ',tgt,'->values;'
		z,←⊂''
		z,←'	'∘,¨(⍳≢ks){'dat[',(⍕⍺),'] = retain_cell(',⍵,');'}¨vs
		z,←⊂'}'
		z,←(n[ks]>0)⌿{'release_array(',⍵,'); ',⍵,' = NULL;'}¨vs
		z,⊂''
	}¨i
	
	⍝ S0/7: Initial and internal strand assignment
	i←⍸t=S
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight ⍵ ⋄ tgt←⊃var_values ⍵ ⋄ lbl1 lbl2←'l',¨(⍕⍵)∘,¨⍕¨1 2
		kc←⍕≢ks←⍵⊃kk ⋄ kv←var_values ks ⋄ kr←var_refs ks ⋄ kd←highlight¨ks
		z ←{'release_array(',⍵,');'}¨kv
		z,←⊂''
		z,←⊂'if (',tgt,'->rank) {'
		z,←⊂'	struct cell_func *pick;'
		z,←⊂'	struct cell_array *idx;'
		z,←⊂'	int32_t *idxv;'
		z,←⊂''
		z,←⊂'	CHKFN(mk_array_int32(&idx, 0), cleanup);'
		z,←⊂'	idxv = idx->values;'
		z,←⊂'	pick = cdf_prim.cdf_pick;'
		z,←⊂''
		z,←kd{'	CHK(pick->fptr_dya(',⍵,', idx, ',tgt,', pick), ',lbl1,', ',⍺,'); (*idxv)++;'}¨kr
		z,←⊂''
		z,←⊂lbl1,':'
		z,←⊂'	release_array(idx);'
		z,←⊂''
		z,←⊂'	if (err)'
		z,←⊂'		goto cleanup;'
		z,←⊂'} else {'
		z,←⊂'	struct cell_func *first;'
		z,←⊂'	struct cell_array *val;'
		z,←⊂''
		z,←⊂'	first = cdf_prim.cdf_first;'
		z,←⊂'	CHK(first->fptr_mon(&val, ',tgt,', first), ',lbl2,', ',dbg,');'
		z,←'	'∘,¨kv,¨⊂' = retain_cell(val);'
		z,←⊂''
		z,←⊂lbl2,':'
		z,←⊂'	release_array(val);'
		z,←⊂''
		z,←⊂'	if (err)'
		z,←⊂'		goto cleanup;'
		z,←⊂'}'
		z,←(k[⍵]≠0)⌿''('release_array(',tgt,'); ',tgt,' = NULL;')
		z,⊂''
	}¨i
	
	⍝ B: Non-option, non-null bindings
	i←⍸(t=B)∧~k∊0 7
	zz[i],←{
		0=≢i:0⍴⊂''
		tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵ ⋄ kv←⊃var_values ⍵⊃kk
		z ←check_vars ⍵⊃kk
		z ←⊂'retain_cell(',kv,'); release_cell(',tgt,');'
		z,←⊂tgt,' = ',kv,';'
		z,⊂''
	}¨i
	
	⍝ C: Closures for functions
	i←⍸t=C
	zz[i],←{
		0=≢i:0⍴⊂''
		ks←⍵⊃kk
		ctyp←k[⍵]⊃'func' 'func' 'func' 'moper' 'doper'
		vc←(≢ks)-fc←0 1 2 4 8[k[⍵]]
		fs vs←{(fc↑⍵)(fc↓⍵)}ks
		fids←var_refs fs ⋄ vids←{var_refs ⍵}vs[⍋n[vs]]
		tgt←⊃var_values ⍵ ⋄ tref←⊃var_refs ⍵ ⋄ dbg←highlight ⍵
		z ←⊂'CHK(mk_',ctyp,'(',tref,', ',(csep fids),', ',(⍕vc),'), cleanup, ',dbg,');'
		z,←⊂''
		z,←(⍳vc){tgt,'->fv[',(⍕⍺),'] = ',⍵,';'}¨vids
		z,⊂''
	}¨i

	⍝ E¯1: Non-returning end of line statement
	i←⍸(t=E)∧k=¯1
	zz[i],←{
		0=≢i:0⍴⊂''
		vv←⊃var_values⊢vi←⊃⍵⊃kk
		(n[vi]>0)⌿('release_cell(',vv,'); ',vv,' = NULL;')''
	}¨i

	⍝ E0: Returning end of line statement
	i←⍸(t=E)∧k=0
	zz[i],←{
		0=≢i:0⍴⊂''
		0≡≢⍵⊃kk:⊂'goto cleanup;'
		kv←⊃var_values⊢ki←⊃⍵⊃kk
		z ←check_vars ki
		z ←((t[ki]=A)∨(n[ki]≠0))⌿⊂'*z = retain_cell(',kv,');'
		z,←⊂'goto cleanup;'
		z,⊂''
	}¨i
	
	⍝ E1: Monadic expression application
	i←⍸(t=E)∧k=1
	zz[i],←{
		0=≢i:0⍴⊂''
		tref←⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵
		fn y←var_values⊢fi yi←⍵⊃kk
		z ←check_vars fi yi
		z ←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←⊂'CHK((',fn,'->fptr_mon)(',tref,', ',y,', ',fn,'), cleanup, ',dbg,');'
		z,←(n[⍵]<0)⌿⊂'release_array(tmp); tmp = NULL;'
		z,←(n[fi]>0)⌿⊂'release_func(',fn,'); ',fn,' = NULL;'
		z,←(n[yi]>0)⌿⊂'release_array(',y,'); ',y,' = NULL;'
		z,⊂''
	}¨i
	
	⍝ E2: Dyadic expression application
	i←⍸(t=E)∧k=2
	zz[i],←{
		0=≢i:0⍴⊂''
		tref←⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵
		x fn y←var_values⊢xi fi yi←⍵⊃kk
		z ←check_vars xi fi yi
		z ←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←⊂'CHK((',fn,'->fptr_dya)(',tref,', ',x,', ',y,', ',fn,'), cleanup, ',dbg,');'
		z,←(n[⍵]<0)⌿⊂'release_array(tmp); tmp = NULL;'
		z,←(n[xi]>0)⌿⊂'release_array(',x,'); ',x,' = NULL;'
		z,←(n[fi]>0)⌿⊂'release_func(',fn,'); ',fn,' = NULL;'
		z,←(n[yi]>0)⌿⊂'release_array(',y,'); ',y,' = NULL;'
		z,⊂''
	}¨i
	
	⍝ E3: Niladic application
	i←⍸(t=E)∧k=3
	zz[i],←{
		0=≢i:0⍴⊂''
		tref←⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵
		fn←⊃var_values⊢fi←⊃⍵⊃kk
		z ←check_vars fi
		z ←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←⊂'CHK((',fn,'->fptr_mon)(',tref,', NULL, ',fn,'), cleanup, ',dbg,');'
		z,←(n[⍵]<0)⌿⊂'release_array(tmp); tmp = NULL;'
		z,←(n[fi]>0)⌿⊂'release_func(',fn,'); ',fn,' = NULL;'
		z,⊂''
	}¨i
	
	⍝ E4: Assignment
	i←⍸(t=E)∧k=4
	zz[i],←{
		0=≢i:0⍴⊂''
		tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵
		bxr←⊃var_refs ⊃⍵⊃kk ⋄ bxv x fn y←var_values⊢bi xi fi yi←⍵⊃kk
		z ←check_vars xi fi yi
		z ←⊂'tmp = ',bxv,';'
		z,←⊂tgt,' = retain_cell(',y,');'
		z,←⊂'CHK((',fn,'->fptr_dya)(',bxr,', ',x,', ',tgt,', ',fn,'), cleanup, ',dbg,');'
		z,←⊂'release_array(tmp); tmp = NULL;'
		z,←(n[xi]>0)⌿⊂'release_array(',x,'); ',x,' = NULL;'
		z,←(n[fi]>0)⌿⊂'release_func(',fn,'); ',fn,' = NULL;'
		z,←(n[yi]>0)⌿⊂'release_array(',y,'); ',y,' = NULL;'
		z,⊂''
	}¨i
	
	⍝ Om: Monadic operators
	i←⍸(t=O)∧k∊1 2
	zz[i],←{
		0=≢i:0⍴⊂''
		lt←⊃ltyp←'array' 'func'⊃⍨k[⍵]=2
		tref←'(struct cell_derf **)',⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵
		dbg←highlight ⍵
		x op←var_values⊢xi oi←⍵⊃kk
		z ←check_vars xi oi
		z ←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←⊂'CHK(mk_derf(',tref,', ',op,'->fptr_',lt,'m, ',op,'->fptr_',lt,'d, 2), cleanup, ',dbg,');'
		z,←⊂tgt,'->fv[0] = retain_cell(',op,');'
		z,←⊂tgt,'->fv[1] = retain_cell(',x,');'
		z,←(n[⍵]<0)⌿⊂'release_func(tmp); tmp = NULL;'
		z,←(n[xi]>0)⌿⊂'release_',ltyp,'(',x,'); ',x,' = NULL;'
		z,←(n[oi]>0)⌿⊂'release_moper(',op,'); ',op,' = NULL;'
		z,⊂''
	}¨i
	
	⍝ Od: Dyadic operators
	i←⍸(t=O)∧k∊4 5 7 8
	zz[i],←{
		0=≢i:0⍴⊂''
		ltyp←'array' 'func'⊃⍨k[⍵]∊5 8
		rtyp←'array' 'func'⊃⍨k[⍵]∊7 8
		tref←'(struct cell_derf **)',⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵
		dbg←highlight ⍵
		x op y←var_values⊢xi oi yi←⍵⊃kk
		fns←csep op∘,¨'->fptr_'∘,¨(⊃rtyp),¨(⊃ltyp),¨'md'
		z ←check_vars xi oi yi
		z ←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←⊂'CHK(mk_derf(',tref,', ',fns,', 3), cleanup, ',dbg,');'
		z,←⊂tgt,'->fv[0] = retain_cell(',op,');'
		z,←⊂tgt,'->fv[1] = retain_cell(',x,');'
		z,←⊂tgt,'->fv[2] = retain_cell(',y,');'
		z,←(n[⍵]<0)⌿⊂'release_func(tmp); tmp = NULL;'
		z,←(n[xi]>0)⌿⊂'release_',ltyp,'(',x,'); ',x,' = NULL;'
		z,←(n[oi]>0)⌿⊂'release_doper(',op,'); ',op,' = NULL;'
		z,←(n[yi]>0)⌿⊂'release_',rtyp,'(',y,'); ',y,' = NULL;'
		z,⊂''
	}¨i
	
	⍝ Ox: Axis Operator and Variant Operator
	i←⍸(t=O)∧k=¯1
	zz[i],←{
		0=≢i:0⍴⊂''
		tref←'(struct cell_derf **)',⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵
		dbg←highlight ⍵
		aa ax←var_values⊢ai xi←⍵⊃kk
		z ←check_vars ai xi
		z ←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←⊂'CHK(mk_derf(',tref,', ',aa,'->fptr_mon, ',aa,'->fptr_dya, 2), cleanup, ',dbg,');'
		z,←⊂tgt,'->fv = ',aa,'->fv;'
		z,←⊂tgt,'->opts = &',tgt,'->fv_[1];'
		z,←⊂tgt,'->fv_[0] = retain_cell(',aa,');'
		z,←⊂tgt,'->opts[0] = retain_cell(',ax,');'
		z,←(n[⍵]<0)⌿⊂'release_func(tmp); tmp = NULL;'
		z,←(n[ai]>0)⌿⊂'release_func(',aa,'); ',aa,' = NULL;'
		z,←(n[xi]>0)⌿⊂'release_array(',ax,'); ',ax,' = NULL;'
		z,⊂''
	}¨i

	⍝ B7: Option bindings
	i←⍸(t=B)∧k=7
	zz[i],←{
		0=≢i:0⍴⊂''
		tref←⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵
		opt←⊃var_names ⍵ ⋄ src←⊃var_values⊢si←⊃⍵⊃kk
		z ←⊂'if (opts && opts->',opt,') {'
		z,←⊂'	retain_cell(opts->',opt,');'
		z,←⊂'	release_array(',tgt,');'
		z,←⊂'	',tgt,' = opts->',opt,';'
		z,←⊂'} else {'
		z,← '	'∘,¨⊃⍪⌿(⍵=p)⌿zz
		z,←⊂'	retain_cell(',src,');'
		z,←⊂'	release_array(',tgt,');'
		z,←⊂'	',tgt,' = ',src,';'
		z,←(n[si]>0)⌿⊂'	release_array(',src,'); ',src,' = NULL;'
		z,←⊂'}'
		z,⊂''
	}¨i

	⍝ G0: Value guards
	i←⍸t=G
	zz[i],←{
		0=≢i:0⍴⊂''
		tgt←⊃var_values⊢ti←⊃⍵⊃kk ⋄ dbg←highlight ti
		z ←⊂'TRC(guard_check(',tgt,'), ',dbg,');'
		z,←(n[ti]>0)⌿⊂'release_array(',tgt,'); ',tgt,' = NULL;'
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
		hassvs←0≠≢svs←⊃sv[⍵]
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
		z,←(⊂'	struct cell_',atyp,' *cdf_alpha;')⌿⍨ism
		z,←(⊂'	struct cell_',ddtyp,' *cdf_deldel;')⌿⍨isop
		z,←(⊂'	struct cell_',aatyp,' *cdf_alphaalpha;')⌿⍨isop
		z,←(⊂'	struct cell_',wwtyp,' *cdf_omegaomega;')⌿⍨isdop
		z,←'	'∘,¨decl_vars svs
		z,←⊂'	void *tmp;'
		z,←⊂'	int err;'
		z,←⊂''
		z,←⊂'	tmp = NULL;'
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
		z,←'		'∘,¨1 decl_vars fvs
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
		z,←'	'∘,¨init_vars svs
		z,←'	'∘,¨init_vars lvs
		z,←⊂'	err = 0;'
		z,←⊂''
		z,←(⊂'	'),¨⊃⍪⌿(p=⍵)⌿zz
		z,←⊂'	err = -1;'
		z,←⊂''
		z,←⊂'cleanup:'
		z,←'	'∘,¨release_vars lvs
		z,←'	'∘,¨release_vars svs
		z,←(⊂'	release_',atyp,'(cdf_alpha);')⌿⍨ism
		z,←⊂''
		z,←⊂'	if (err)'
		z,←⊂'		return err;'
		z,←⊂''
		⍝ z,←⊂'	TRC(chk_array_valid(*z), '
		⍝ z,←⊂'	    ',(highlight ⍵),');'
		z,←⊂'	return err;'
		z,←⊂'}'
		z,⊂''
	}¨i
	pref,←⊂''

	⍝ T0: Initialization functions for namespaces
	i←⍸(t=T)∧k=0
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
		z,←'	'∘,¨decl_vars ⍵⊃sv
		z,←⊂'	void *tmp;'
		z,←⊂'	int err;'
		z,←⊂''
		z,←⊂'	if (',id,'_flag)'
		z,←⊂'		return 0;'
		z,←⊂''
		z,←⊂'	tmp = NULL;'
		z,←⊂'	err = 0;'
		z,←⊂'	',id,'_flag = 1;'
		z,←⊂'	loc = &',id,';'
		z,←⊂'	loc->__count = ',(⍕≢⊃lv[⍵]),';'
		z,←⊂'	loc->__names = ',id,'_names;'
		z,←⊂''
		z,←⊂'	release_debug_info();'
		z,←⊂''
		z,←'	'∘,¨init_vars ⍵⊃sv
		z,←'	'∘,¨init_vars ⍵⊃lv
		z,←⊂''
		z,←⊂'	CHKFN(cdf_prim_init(), cleanup);'
		z,←⊂''
		z,←'	'∘,¨⊃⍪⌿(p=⍵)⌿zz
		z,←⊂''
		z,←⊂'cleanup:'
		z,←⊂'	if (err) {'
		z,←'		'∘,¨release_vars ⍵⊃lv
		z,←'		'∘,¨release_vars ⍵⊃sv
		z,←⊂'	}'
		z,←⊂''
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
		z,←⊂'	char **__names;'
		z,←(⊂'	'),¨decl_vars ⊃lv[⍵]
		z,←⊂'};'
		z,←⊂''
		z
	}¨i
	pref,←⊂''

	⍝ Export functions
	i←⍸(t[p][p]=T)∧(k[p][p]=0)∧(t[p]=H)∧k=2
	exp←⊃⍪⌿{
		fn ns←var_names ⍵,p[p][⍵]
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
		z,←⊂'		CHKIG(self->fptr_mon(z, r, self), fail);'
		z,←⊂'	} else {'
		z,←⊂'		CHKIG(self->fptr_dya(z, l, r, self), fail);'
		z,←⊂'	}'
		z,←⊂''
		z,←⊂'fail:'
		z,←⊂'	return err;'
		z,←⊂'}'
		z,←⊂''
		z,←⊂'EXPORT int'
		z,←⊂fn,'_dwa(void *z, void *l, void *r)'
		z,←⊂'{'
		z,←⊂'	return call_dwa(',fn,', z, l, r, "',fn,'");'
		z,←⊂'}'
		z,⊂''
	}¨i
	
	exp,←⊂'int'
	exp,←⊂'main(int argc, char *argv[])'
	exp,←⊂'{'
	exp,←⊂'	struct cell_array *dbg;'
	exp,←⊂'	int err;'
	exp,←⊂''
	exp,←⊃⍪⌿{⊂'	CHKFN(',(⊃var_names ⍵),'_init(), fail);'}¨⍸(t=F)∧k=0
	exp,←⊂''
	exp,←⊂'	print_cell_stats();'
	exp,←⊂'	print_ibeam_stats();'
	exp,←⊂''
	exp,←⊂'	return 0;'
	exp,←⊂''
	exp,←⊂'fail:'
	exp,←⊂'	dbg = get_debug_info();'
	exp,←⊂'	printf("\n%s\n", (char *)dbg->values);'
	exp,←⊂'	printf("ERROR %d\n", err);'
	exp,←⊂'	release_debug_info();'
	exp,←⊂'	return err;'
	exp,←⊂'}'
	exp,←⊂''
	
	⍝ Warn about nodes that appear which we haven't generated
	⍝ ⍞←(∨⌿msk)↑(⎕UCS 10)(⊣,⍨,)⍉⍪'Ungenerated nodes: ',⍕,∪(msk←zz∊⊂'')⌿N∆[t],∘⍕¨k

	⍝ Assemble all the data together into a single character vector
	data←∊(pref,(⊃⍪⌿zz[⍸p=⍳≢p]),exp),¨⊂⎕UCS 13 10

	⍝ Return data+headers
	data header
}
