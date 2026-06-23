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
		'\\' '\*/'⎕R'\\\\' '* /'⊢'"[',(⍕1+lineno),'] ',(line~CR LF),'"'
	}


	⍝ Variable generation utilities
	var_ckinds←{
		types←' afmdeva'
		isa←t[⍵]∊A E S
		isfn←(t[⍵]=O)∨(t[⍵]∊F T)∧k[⍵]<5
		isdop←(t[⍵]∊F T)∧k[⍵]≥11
		ismop←(~isdop)∧(t[⍵]∊F T)∧k[⍵]≥5
		types[4@{isdop}3@{ismop}2@{isfn}1@{isa}k[⍵]]
	}

	var_names←{
		ceqv←'_del_' '_delubar_'
		asym←'∆'     '⍙'
		islit←(t[⍵]=A)∧k[⍵]=1
		nam←⍵
		nam[i]←'l',∘⍕¨|n[⍵[i←⍸islit]]
		nam[i]←(var_ckinds ⍵[i]),¨⍕¨n[⍵[i←⍸(~islit)∧n[⍵]≥0]]
		nam[i]←sym[|n[⍵[i←⍸(~islit)∧n[⍵]<0]]]
		nam←(,¨asym)⎕R ceqv⊢(0⍴⊂''),nam
		'' 'cdf_'[lx[⍵]≥0],¨nam
	}

	var_scopes←{
		(0⍴⊂''),'loc->' 'lex->' 'dyn->' '' '' '' ''[|1+lx[⍵]]
	}

	var_nmvec←{
		0=≢⍵:'char **',⍺,' = NULL;'
		z←'char *',⍺,'[] = {'
		z,←⊃{⍺,', ',⍵}⌿'"'∘,¨sym[|n[⍵]],¨'"'
		z,'};'
	}

	decl_vars←{⍺←0
		0=≢⍵:0⍴⊂''
		z  ←'' 'extern '[lx[⍵]=¯6]
		z,¨←⊂'struct cell'
		z,¨←'' '_ptr'[lx[⍵]=¯5]
		z,¨←' ' ' *'[⍺]
		z,¨←'' '*'[lx[⍵]≠¯5]
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
		z←'&' ''[lx[⍵]∊¯2 ¯3]
		z,¨←(var_scopes,¨var_names)⍵
		z[⍸(n[,⍵]=0)∧(t[,⍵]=A)⍲k[,⍵]=1]←⊂,'z'
		z
	}

	var_values←{
		z←'' '*'[lx[⍵]∊¯2 ¯3]
		z,¨←(var_scopes,¨var_names)⍵
		z[⍸(n[,⍵]=0)∧(t[,⍵]=A)⍲k[,⍵]=1]←⊂,'(*z)'
		z
	}
	
	check_vars←{
		vs←⍵⌿⍨lx[⍵]≥¯3
		(highlight¨vs){'CHK(is_bound(',⍵,'), cleanup, ',⍺,');'}¨var_values vs
	}
	
	release_vars←{
		'free_cell'∘,¨'(',¨(var_values ⍵),¨⊂');'
	}

	⍝ All code has an initial prefix
	pref ←⊂'#include <stddef.h>'
	pref,←⊂'#include <stdint.h>'
	pref,←⊂'#include <stdio.h>'
	pref,←⊂'#include <stdlib.h>'
	pref,←⊂''
	pref,←⊂'#ifdef _WIN32'
	pref,←⊂' #define EXPORT __declspec(dllexport)'
	pref,←⊂' #define DECLSPEC __declspec(dllimport)'
	pref,←⊂'#elif defined(__GNUC__)'
	pref,←⊂' #define EXPORT __attribute__ ((visibility ("default")))'
	pref,←⊂' #define DECLSPEC extern __attribute__ ((visibility ("default")))'
	pref,←⊂'#else'
	pref,←⊂' #define EXPORT'
	pref,←⊂'#endif'
	pref,←⊂''
	pref,←⊂'enum elem_type { '
	pref,←⊂'	ELEM_INT, ELEM_FLOAT, ELEM_CMPX, ELEM_CHAR, ELEM_DEV, ELEM_IOTA, ELEM_CELL'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'enum cell_type { CELL_VOID, CELL_SCALAR, CELL_VECTOR, CELL_ARRAY, CELL_FUNC };'
	pref,←⊂''
	pref,←⊂'struct apl_cmpx {'
	pref,←⊂'	double real;'
	pref,←⊂'	double imag;'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'struct iota_range {'
	pref,←⊂'	double shift;'
	pref,←⊂'	double step;'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'struct cell_scalar {'
	pref,←⊂'	enum elem_type etyp;'
	pref,←⊂'	union {'
	pref,←⊂'		int64_t i;'
	pref,←⊂'		double f;'
	pref,←⊂'		struct apl_cmpx j;'
	pref,←⊂'		uint64_t c;'
	pref,←⊂'		struct cell *p;'
	pref,←⊂'	};'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'struct host_buffer {'
	pref,←⊂'	int refc;'
	pref,←⊂'	int64_t size;'
	pref,←⊂'	struct host_buffer *next;'
	pref,←⊂'	union {'
	pref,←⊂'		int64_t *i;'
	pref,←⊂'		double *f;'
	pref,←⊂'		struct apl_cmpx *j;'
	pref,←⊂'		uint64_t *c;'
	pref,←⊂'		struct cell **p;'
	pref,←⊂'	};'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'struct cell_vector {'
	pref,←⊂'	enum elem_type etyp;'
	pref,←⊂'	int64_t cnt, bnd;'
	pref,←⊂'	union {'
	pref,←⊂'		struct host_buffer *host;'
	pref,←⊂'		void *dev;'
	pref,←⊂'		struct iota_range iota;'
	pref,←⊂'	};'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'struct cell_array {'
	pref,←⊂'	struct cell *s;'
	pref,←⊂'	struct cell *e;'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'struct cell_func {'
	pref,←⊂'	int (**fn)(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***);'
	pref,←⊂'	struct cell *aa, *ww, *axis;'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'struct cell {'
	pref,←⊂'	int refc;'
	pref,←⊂'	enum cell_type ctyp;'
	pref,←⊂'	struct cell *next;'
	pref,←⊂'	union {'
	pref,←⊂'		struct cell_scalar s;'
	pref,←⊂'		struct cell_vector v;'
	pref,←⊂'		struct cell_array a;'
	pref,←⊂'		struct cell_func f;'
	pref,←⊂'	};'
	pref,←⊂'};'
	pref,←⊂''
	pref,←⊂'int set_dwafns(void *);'
	pref,←⊂'struct cell *get_cell(void);'
	pref,←⊂'void *free_cell(struct cell *);'
	pref,←⊂'struct cell *ref_cell(struct cell *);'
	pref,←⊂'void release_debug_info(void);'
	pref,←⊂'struct cell *get_debug_info(void);'
	pref,←⊂'int is_bound(struct cell *);'
	pref,←⊂'int64_t buffer_size(enum elem_type, int64_t);'
	pref,←⊂'void debug_trace(const char *, int, const char *, const char *);'
	pref,←⊂'void print_debug_info(int);'
	pref,←⊂'struct host_buffer *get_host_buffer(int64_t);'
	pref,←⊂'void squeeze(struct cell *);'
	pref,←⊂''
	pref,←⊂'int println_f(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***);'
	pref,←⊂'int ravel_f(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***);'
	pref,←⊂'int first_f(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***);'
	pref,←⊂'int pick_f(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***);'
	pref,←⊂'int rgt_f(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***);'
	pref,←⊂'DECLSPEC struct cell *rgt;'
	pref,←⊂''
	pref,←⊂'#define CHK(expr, fail, msg)					\'
	pref,←⊂'if (0 < (err = (expr))) {					\'
	pref,←⊂'	debug_trace(__FILE__, __LINE__, __func__, msg);	\'
	pref,←⊂'	goto fail;						\'
	pref,←⊂'}								\'
	pref,←⊂''
	pref,←⊂'#define CHKFN(expr, fail) CHK(expr, fail, "" #expr)'
	pref,←⊂'#define CHKIG(expr, fail) if (0 < (err = (expr))) goto fail;'
	pref,←⊂''
	pref,←⊂'#define TRC(expr, msg)						\'
	pref,←⊂'if (0 < (err = (expr))) {					\'
	pref,←⊂'	debug_trace(__FILE__, __LINE__, __func__, msg);	\'
	pref,←⊂'}								\'
	pref,←⊂''
	pref,←⊂'EXPORT int'
	pref,←⊂'DyalogGetInterpreterFunctions(void *p)'
	pref,←⊂'{'
	pref,←⊂'    return set_dwafns(p);'
	pref,←⊂'}'
	pref,←⊂''

	⍝ We declare all external variables in the prefix
	pref,←decl_vars⊢i←⍸msk∧msk⍀≠n⌿⍨msk←(t=V)∧lx=¯6
	pref,←(0≠≢i)⍴⊂''
	
	⍝ Define all literals as static values
	ftypes←'.i'      '.i'      '.i'      '.i'      '.f'     '.j'
	atypes←'INT'     'INT'     'INT'     'INT'     'FLOAT'  'CMPX' 
	ctypes←'int64_t' 'int64_t' 'int64_t' 'int64_t' 'double' 'struct apl_cmpx'
	drtypes←11       83        163       323       645      1289
	ftypes,←'.c'       '.c'       '.c'
	atypes,←'CHAR'     'CHAR'     'CHAR'
	ctypes,←'uint64_t' 'uint64_t' 'uint64_t'
	drtypes,←80        160        320
	pref,←⊃⍪⌿{
		rnk←≢shp←⍴dat←⍵⊃sym ⋄ dri←drtypes⍳⎕DR dat
		atp←dri⊃atypes ⋄ ctp←dri⊃ctypes ⋄ ftp←dri⊃ftypes
		fmt←{⎕PP←34 ⋄ 1289=⎕DR ⍵:'{',(csep 9 11○⍵),'}' ⋄ ⍕⍵}
		dat←'¯'⎕R'-'∘fmt¨⎕UCS⍣(0=10|⎕DR dat)⊃⍣(0=≢,dat)⊢dat
		nam←'l',⍕⍵
		rnk≡0:{
			z ←⊂'struct cell ',nam,'_val = {'
			z,←⊂'	2, CELL_SCALAR, NULL, '
			z,←⊂'	.s = {ELEM_',atp,', ',ftp,' = ',(⊃dat),'}'
			z,←⊂'};'
			z,←⊂'struct cell *',nam,' = &',nam,'_val;'
		z,⊂''}⍵
		z ←⊂ctp,' ',nam,'_dat[] = {',(csep dat),'};'
		z,←⊂'struct host_buffer ',nam,'_buf = {'
		z,←⊂'	2, ',(⍕(1+5=dri)×8×≢dat),', NULL, ',ftp,' = ',nam,'_dat'
		z,←⊂'};'
		rnk≡1:{
			z,←⊂'struct cell ',nam,'_val = {'
			z,←⊂'	2, CELL_VECTOR, NULL, '
			z,←⊂'	.v = {ELEM_',atp,', ',(⍕⊃shp),', ',(⍕⊃shp),', .host = &',nam,'_buf}'
			z,←⊂'};'
			z,←⊂'struct cell *',nam,' = &',nam,'_val;'
		z,⊂''}⍵
		⎕SIGNAL 16
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
		tgt←⊃var_values ⍵ ⋄ vs←var_values⊢ks←⍵⊃kk
		z ←check_vars⊢ks←⍵⊃kk
		z,←⊂'CHK(!(',tgt,' = get_cell()), cleanup, ',dbg,');'
		z,←⊂tgt,'->ctyp = CELL_VECTOR;'
		z,←⊂tgt,'->v.etyp = ELEM_CELL;'
		z,←⊂tgt,'->v.cnt = ',tgt,'->v.bnd = ',(⍕≢ks),';'
		z,←⊂'CHK(!(',tgt,'->v.host = get_host_buffer(buffer_size(ELEM_CELL, ',(⍕≢ks),'))), cleanup, ',dbg,');'
		z,←(⍳≢ks){tgt,'->v.host->p[',(⍕⍺),'] = ref_cell(',⍵,');'}¨vs
		z,←⊂'squeeze(',tgt,');'
		z,←(n[ks]>0)⌿{'free_cell(',⍵,');'}¨vs
		z,⊂''
	}¨i
	
	⍝ S0/7: Initial and internal strand assignment
	i←⍸t=S
	zz[i],←{
		0=≢i:0⍴⊂''
		dbg←highlight ⍵ ⋄ tgt←⊃var_values ⍵
		ks←⍵⊃kk ⋄ kv←var_values ks ⋄ kr←var_refs ks ⋄ kd←highlight¨ks
		z ←{'free_cell(',⍵,');'}¨kv
		z,←⊂''
		z,←⊂'if (',tgt,'->ctyp != CELL_SCALAR) {'
		z,←⊂'	CHK(!(tmp = get_cell()), cleanup, ',dbg,');'
		z,←⊂'	tmp->ctyp = CELL_SCALAR;'
		z,←⊂'	tmp->s.etyp = ELEM_INT;'
		z,←⊂'	tmp->s.i = 0;'
		z,←kd{'	CHK(pick_f(NULL, ',⍵,', tmp, ',tgt,', NULL), cleanup, ',⍺,'); tmp->s.i++;'}¨kr
		z,←⊂'	free_cell(tmp);'
		z,←⊂'} else {'
		z,←⊂'	CHK(first_f(NULL, &tmp, NULL, ',tgt,', NULL), cleanup, ',dbg,');'
		z,←'	'∘,¨kv,¨⊂' = ref_cell(tmp);'
		z,←⊂'	free_cell(tmp);'
		z,←⊂'}'
		z,←(k[⍵]≠0)⌿''('free_cell(',tgt,');')
		z,⊂''
	}¨i
	
	⍝ B: Non-option, non-null bindings
	i←⍸(t=B)∧~k∊0 7
	zz[i],←{
		0=≢i:0⍴⊂''
		tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵ ⋄ kv←⊃var_values⊢ki←⍵⊃kk
		z ←⊂'/* ',dbg,' */'
		z,←check_vars ki
		z,←⊂'ref_cell(',kv,');'
		z,←⊂'free_cell(',tgt,');'
		z,←⊂tgt,' = ',kv,';'
		z,⊂''
	}¨i
	
	⍝ E¯1: Non-returning end of line statement
	i←⍸(t=E)∧k=¯1
	zz[i],←{
		0=≢i:0⍴⊂''
		vv←⊃var_values⊢vi←⊃⍵⊃kk
		(n[vi]>0)⌿('free_cell(',vv,');')''
	}¨i

	⍝ E0: Returning end of line statement
	i←⍸(t=E)∧k=0
	zz[i],←{
		0=≢i:0⍴⊂''
		0≡≢⍵⊃kk:⊂'goto cleanup;'
		kv←⊃var_values⊢ki←⊃⍵⊃kk
		z ←check_vars ki
		z,←((t[ki]=A)∨(n[ki]≠0))⌿⊂'*z = ref_cell(',kv,');'
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
		z,←(n[⍵]<0)⍴⊂'tmp = ',tgt,';'
		z,←(lx[fi]=¯4)⍴⊂'CHK(',fn,'_f(NULL, ',tref,', NULL, ',y,', NULL), cleanup, ',dbg,');'
		z,←(lx[fi]≠¯4)⍴⊂'CHK((',fn,'->f.fn[0])(',fn,', ',tref,', NULL, ',y,', env), cleanup, ',dbg,');'
		z,←(n[⍵]<0)⍴⊂'free_cell(tmp);'
		z,←((lx[fi]=¯7)∧n[fi]>0)⍴⊂'free_cell(',fn,');'
		z,←(n[yi]>0)⍴⊂'free_cell(',y,');'
		z,⊂''
	}¨i
	
	⍝ E2: Dyadic expression application
	i←⍸(t=E)∧k=2
	zz[i],←{
		0=≢i:0⍴⊂''
		tref←⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵
		x fn y←var_values⊢xi fi yi←⍵⊃kk
		z ←check_vars xi fi yi
		z,←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←(lx[fi]=¯4)⍴⊂'CHK(',fn,'_f(NULL, ',tref,', ',x,', ',y,', NULL), cleanup, ',dbg,');'
		z,←(lx[fi]≠¯4)⍴⊂'CHK((',fn,'->f.fn[1])(',fn,', ',tref,', ',x,', ',y,', env), cleanup, ',dbg,');'
		z,←(n[⍵]<0)⌿⊂'free_cell(tmp);'
		z,←(n[xi]>0)⌿⊂'free_cell(',x,');'
		z,←((lx[fi]=¯7)∧n[fi]>0)⌿⊂'free_cell(',fn,');'
		z,←(n[yi]>0)⌿⊂'free_cell(',y,');'
		z,⊂''
	}¨i
	
	⍝ E3: Niladic application
	i←⍸(t=E)∧k=3
	zz[i],←{
		0=≢i:0⍴⊂''
		tref←⊃var_refs ⍵ ⋄ tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵
		fn←⊃var_values⊢fi←⊃⍵⊃kk
		z ←check_vars fi
		z,←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
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
		z,←⊂'tmp = ',bxv,';'
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
		z,←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←⊂'CHK(!(',tgt,' = get_cell()), cleanup, ',dbg,');'
		z,←⊂tgt,'->ctyp = CELL_FUNC;'
		z,←⊂tgt,'->f.fn = &',op,'->f.fn[',(⍕2×k[⍵]=2),'];'
		z,←⊂tgt,'->f.aa = ref_cell(',x,');'
		z,←(n[⍵]<0)⌿⊂'free_cell(tmp);'
		z,←(n[xi]>0)⌿⊂'free_cell(',x,');'
		z,←((lx[oi]=¯7)∧n[oi]>0)⌿⊂'free_cell(',op,');'
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
		z,←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
		z,←⊂'CHK(!(',tgt,' = get_cell()), cleanup, ',dbg,');'
		z,←⊂tgt,'->ctyp = CELL_FUNC;'
		z,←⊂tgt,'->f.fn = &',op,'->f.fn[',(⍕2×2⊥(k[⍵]∊7 8)(k[⍵]∊5 8)),'];'
		z,←⊂tgt,'->f.aa = ref_cell(',x,');'
		z,←⊂tgt,'->f.ww = ref_cell(',y,');'
		z,←(n[⍵]<0)⌿⊂'free_cell(tmp);'
		z,←(n[xi]>0)⌿⊂'free_cell(',x,');'
		z,←((lx[oi]=¯7)∧n[oi]>0)⌿⊂'free_cell(',op,');'
		z,←(n[yi]>0)⌿⊂'free_cell(',y,');'		
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
		z,←(n[⍵]<0)⌿⊂'tmp = ',tgt,';'
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
		z ←⊂'/* ',dbg,' */'
		z,←⊂'if (',tgt,'->ctyp != CELL_SCALAR)'
		z,←⊂'	CHK(4, cleanup, "Non-scalar test expression");'
		z,←⊂''
		z,←⊂'if (',tgt,'->s.etyp != ELEM_INT)'
		z,←⊂'	CHK(11, cleanup, "Non-integer test expression");'
		z,←⊂''
		z,←⊂'if (',tgt,'->s.i != 0 && ',tgt,'->s.i != 1)'
		z,←⊂'	CHK(11, cleanup, "Non-Boolean test expression");'
		z,←⊂''
		z,←⊂'if (',tgt,'->s.i) {'
		z,←(n[ti]>0)⌿'	free_cell(',tgt,');' ''
		z,← '	'∘,¨⊃⍪⌿(⍵=p)⌿zz
		z,←⊂'	err = -1;'
		z,←⊂'	goto cleanup;'
		z,←⊂'}'
		z,←⊂''
		z,←(n[ti]>0)⌿'free_cell(',tgt,');'
		z,←⊂'err = 0;'
		z,⊂''
	}¨i
	
	⍝ FN: Non-zero functions
	i←⍸(t=F)∧k≠0
	zz[i],←{
		0=≢i:0⍴⊂''
		id←⊃var_values ⍵
		hassvs←0≠≢svs←⊃sv[⍵]
		haslvs←0≠≢lvs←⊃lv[⍵]
		ism←k[⍵]∊2 3 5 6 8 9 11 12 14 15 17 18 20 21
		pref,←⊂'int ',id,'(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***);'
		z ←⊂'int'
		z,←⊂id,'(struct cell *s, struct cell **z, struct cell *alpha, struct cell *omega, struct cell ***fv)'
		z,←⊂'{'
		z,←'	'∘,¨decl_vars svs
		z,←⊂'	void *tmp;'
		z,←⊂'	int err;'
		z,←⊂''
		z,←⊂'	tmp = NULL;'
		z,←⊂''
		z,←(⊂'	struct {')⌿⍨haslvs
		z,←'		'∘,¨decl_vars lvs
		z,←(⊂'	} loc_frm, *loc;')⌿⍨haslvs
		z,←(⊂'')⌿⍨haslvs
		z,←(⊂'	loc = &loc_frm;')⌿⍨haslvs
		z,←(⊂'')⌿⍨haslvs
		z,←⊂'	struct cell **env[] = {'
		z,←⊂'		fv[0],'
		z,←(⊂'		(struct cell **)loc')⌿⍨haslvs
		z,←⊂'	};'
		z,←⊂''
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
		z,←(⊂'	free_cell(alpha);')⌿⍨ism
		z,←⊂''
		z,←⊂'	return err;'
		z,←⊂'}'
		z,⊂''
	}¨i
	pref,←(0≠≢i)⍴⊂''

	⍝ C: Closures for functions
	i←⍸t=C
	pref,←⊃,⌿{
		0=≢i:0⍴⊂''
		fids←var_values ⍵⊃kk ⋄ tgt←⊃var_values ⍵ ⋄ dbg←highlight ⍵
		z ←⊂'/* ',dbg,' */'
		z,←⊂'int (*',tgt,'_fn[])(struct cell *, struct cell **, struct cell *, struct cell *, struct cell ***) = {'
		z,←⊂'	',csep fids
		z,←⊂'};'
		z,←⊂'struct cell ',tgt,'_c = {'
		z,←⊂'	1, CELL_FUNC, NULL, .f = {'
		z,←⊂'		',tgt,'_fn, NULL, NULL, NULL'
		z,←⊂'	}'
		z,←⊂'};'
		z,←⊂'struct cell *',tgt,' = &',tgt,'_c;'
		z,⊂''	
	}¨i

	⍝ T0: Initialization functions for namespaces
	i←⍸(t=T)∧k=0
	zz[i],←{
		id←⊃var_names ⍵
		z ←⊂'struct ',id,'_loc {'
		z,←(⊂'	'),¨decl_vars ⊃lv[⍵]
		z,←⊂'	int flag;'
		z,←⊂'} ',id,';'
		z,←⊂''
		z,←⊂'EXPORT int'
		z,←⊂id,'_init(void)'
		z,←⊂'{'
		z,←⊂'	struct ',id,'_loc *loc;'
		z,←'	'∘,¨decl_vars ⍵⊃sv
		z,←⊂'	struct cell *tmp;'
		z,←⊂'	int err;'
		z,←⊂''
		z,←⊂'	if (',id,'.flag)'
		z,←⊂'		return 0;'
		z,←⊂''
		z,←⊂'	tmp = NULL;'
		z,←⊂'	err = 0;'
		z,←⊂'	',id,'.flag = 1;'
		z,←⊂'	loc = &',id,';'
		z,←⊂''
		z,←⊂'	struct cell **env[] = {(struct cell **)loc};'
		z,←⊂''
		z,←⊂'	release_debug_info();'
		z,←⊂''
		z,←'	'∘,¨init_vars ⍵⊃sv
		z,←'	'∘,¨init_vars ⍵⊃lv
		z,←⊂''
		z,←'	'∘,¨⊃⍪⌿(p=⍵)⌿zz
		z,←⊂''
		z,←⊂'cleanup:'
		z,←⊂'	if (err) {'
		z,←⊂'		free_cell(tmp);'
		z,←'		'∘,¨release_vars ⍵⊃lv
		z,←'		'∘,¨release_vars ⍵⊃sv
		z,←⊂'	}'
		z,←⊂''
		z,←⊂'	return err;'
		z,←⊂'}'
		z,⊂''
	}¨i

	⍝ Export functions
	i←⍸(t[p][p]=T)∧(k[p][p]=0)∧(t[p]=H)∧k=2
	exp←⊃⍪⌿{
		fn ns←var_names ⍵,p[p][⍵]
		fnv←⊃var_values ⍵
		z ←⊂'EXPORT int'
		z,←⊂fn,'(struct cell **z, struct cell *l, struct cell *r)'
		z,←⊂'{'
		z,←⊂'	struct cell *self;'
		z,←⊂'	struct ',ns,'_loc *loc;'
		z,←⊂'	int err;'
		z,←⊂''
		z,←⊂'	CHKFN(',ns,'_init(), fail);'
		z,←⊂''
		z,←⊂'	loc = &',ns,';'
		z,←⊂'	self = ',fnv,';'
		z,←⊂''
		z,←⊂'	struct cell **env[] = {(struct cell **)loc};'
		z,←⊂''
		z,←⊂'	if (l == NULL) {'
		z,←⊂'		CHKIG(self->f.fn[0](self, z, l, r, env), fail);'
		z,←⊂'	} else {'
		z,←⊂'		CHKIG(self->f.fn[1](self, z, l, r, env), fail);'
		z,←⊂'	}'
		z,←⊂''
		z,←⊂'fail:'
		z,←⊂'	return err;'
		z,←⊂'}'
		z,←⊂''
		z
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
	exp,←⊂'	int err;'
	exp,←⊂''
	exp,←⊃⍪⌿{⊂'	CHKFN(',(⊃var_names ⍵),'_init(), fail);'}¨⍸(t=T)∧k=0
	exp,←⊂''
	exp,←⊂'	return 0;'
	exp,←⊂''
	exp,←⊂'fail:'
	exp,←⊂'	print_debug_info(err);'
	exp,←⊂'	release_debug_info();'
	exp,←⊂'	return err;'
	exp,←⊂'}'
	exp,←⊂''
	
	⍝ Warn about nodes that appear which we haven't generated
	⍝ ⍞←(∨⌿msk)↑(⎕UCS 10)(⊣,⍨,)⍉⍪'Ungenerated nodes: ',⍕,∪(msk←zz∊⊂'')⌿N∆[t],∘⍕¨k

	⍝ Assemble all the data together into a single character vector
	data←∊(pref,(⊃⍪⌿zz[⍸p=⍳≢p]),exp),¨⊂⎕UCS 13 10

	⍝ Return data+headers
	data
}
