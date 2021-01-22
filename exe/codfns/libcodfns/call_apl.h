#include <stdint.h>
#include <wchar.h>

#include "dwa_defs.h"
#include "engine_flags.h"
//#include <call_apl_resource.h>

#define 	AP_END		0x80000000
#define 	AP_OUT		0x40000000
#define 	AP_IN		0x20000000

#define 	AP_NULLTERM	0x08000000
#define 	AP_UTF		0x04000000
#define 	AP_CALL_FREE	0x02000000
#define 	AP_JSON		0x01000000

#define 	AP_SIZED	0x00800000
#define 	AP_ALLOC	0x00400000

#if !defined(POCKET_H_INCLUDED)
typedef void *PP;
#endif

typedef unsigned char ubyte;
typedef unsigned char char8;
typedef uint16_t char16;
typedef uint32_t char32;


#define AP_FIELD_NAME(type)	f_##type
#define AP_ARRAY_NAME(type)	f_a_##type
#define ADD_FIELDS(type) type AP_FIELD_NAME(type); struct { type *p; size_t b; } AP_ARRAY_NAME(type)

#define ARRAY_PTR(v,t)	((v)->vals.AP_ARRAY_NAME(t).p)
#define ARRAY_BND(v,t)	((v)->vals.AP_ARRAY_NAME(t).b)
#define SCALAR_VAL(v,t)	((v)->vals.AP_FIELD_NAME(t))

typedef union
	{
	ADD_FIELDS(ubyte);
	ADD_FIELDS(int8_t);
	ADD_FIELDS(int16_t);
	ADD_FIELDS(int32_t);
	ADD_FIELDS(int64_t);

	ADD_FIELDS(uint8_t);
	ADD_FIELDS(uint16_t);
	ADD_FIELDS(uint32_t);
	ADD_FIELDS(uint64_t);

	ADD_FIELDS(float);
	ADD_FIELDS(double);

	ADD_FIELDS(char);
	ADD_FIELDS(char8);
	ADD_FIELDS(char16);
	ADD_FIELDS(char32);
	ADD_FIELDS(wchar_t);

	void *str;
	} APL_VALUES;



typedef struct APL_PARAM
	{
	unsigned flags;
	void(LIBCALL *mkpock)(PP *pp,struct APL_PARAM *param);
	void(LIBCALL *fmpock)(PP *pp,struct APL_PARAM *param);
	APL_VALUES vals;
	struct APL_PARAM *link;
	} APL_PARAM;


static APL_PARAM _APL_PARAM_END_={AP_END};
#define PARAM_END  (&_APL_PARAM_END_)

extern void  dwa_free(void*);
extern void *dwa_alloc(size_t len);
extern APL_PARAM *link_str(APL_PARAM *,...);

#include "copyfns.h"

#define SET_ARRAY(name,type,ptr,bnd)	ARRAY_PTR(&name,type)=ptr; ARRAY_BND(&name,type)=bnd

#define APL_DEFINE_PARAM(name,flags,fp,tp)   APL_PARAM name={flags,fp,tp} 

#define DEFINE_ARRAY_PARAM(name,flags,type,p,c) APL_DEFINE_PARAM(name,flags,pf_a_##type,pt_a_##type); SET_ARRAY(&name,type,p,count)
#define DEFINE_SCALAR_PARAM(name,flags,type,v) APL_DEFINE_PARAM(name,flags,pf_##type,pt_##type); name.vals.AP_FIELD_NAME(type)=v;

#define APL_NUMBER_ARRAY_PARAM(type,name,v,l,flags)  APL_DEFINE_PARAM(name,flags,  		\
					pf_a_##type,			\
					pt_a_##type			\
					); SET_ARRAY(name,type,v,l)

#define APL_STRUCT_PARAM(name,first,...) APL_DEFINE_PARAM(name,AP_IN,pf_str,pt_str); name.vals.str=link_str(first,__VA_ARGS__);
#define APL_STRUCT_RESULT(name,first,...) APL_DEFINE_PARAM(name,AP_OUT,pf_str,pt_str); name.vals.str=link_str(first,__VA_ARGS__);
#define APL_STRUCT_INOUT(name,first,...) APL_DEFINE_PARAM(name,AP_IN|AP_OUT,pf_str,pt_str); name.vals.str=link_str(first,__VA_ARGS__);

#define APL_CHARACTER_ARRAY_PARAM(type,name,v,l,flags)    APL_DEFINE_PARAM(name,flags,  			\
					pf_a_##type,				\
					pt_a_##type				\
					); SET_ARRAY(name,type,v,l)

#define APL_DOUBLE_PARAM(name,v)  DEFINE_SCALAR_PARAM(name,AP_IN		,double,v)
#define APL_DOUBLE_RESULT(name)		APL_PARAM name={AP_OUT,0,pt_double}

#define APL_INT8_PARAM(		name,v)  DEFINE_SCALAR_PARAM(name,AP_IN		,int8_t,v)
#define APL_INT8_INOUT(		name,v)  DEFINE_SCALAR_PARAM(name,AP_IN|AP_OUT	,int8_t,v)
#define APL_INT8_RESULT(	name)   DEFINE_SCALAR_PARAM(name,AP_OUT	,int8_t,0)
#define APL_INT16_PARAM(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN		,int16_t,v)
#define APL_INT16_INOUT(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN|AP_OUT	,int16_t,v)
#define APL_INT16_RESULT(	name)   DEFINE_SCALAR_PARAM(name,AP_OUT	,int16_t,0)
#define APL_INT32_PARAM(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN		,int32_t,v)
#define APL_INT32_INOUT(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN|AP_OUT	,int32_t,v)
#define APL_INT32_RESULT(	name)   DEFINE_SCALAR_PARAM(name,AP_OUT	,int32_t,0)

#define APL_CHAR8_PARAM(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN		,char8,v)
#define APL_CHAR8_INOUT(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN|AP_OUT	,char8,v)
#define APL_CHAR8_RESULT(	name)   DEFINE_SCALAR_PARAM(name,AP_OUT	,char8,0)
#define APL_CHAR16_PARAM(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN		,char16,v)
#define APL_CHAR16_INOUT(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN|AP_OUT	,char16,v)
#define APL_CHAR16_RESULT(	name)   DEFINE_SCALAR_PARAM(name,AP_OUT	,char16,0)
#define APL_CHAR_PARAM(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN		,char,v)
#define APL_CHAR_INOUT(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN|AP_OUT	,char,v)
#define APL_CHAR_RESULT(	name)   DEFINE_SCALAR_PARAM(name,AP_OUT	,char,0)
#define APL_WCHAR_PARAM(	name,v)  DEFINE_SCALAR_PARAM(name,AP_IN		,wchar_t,v)
#define APL_WCHAR_RESULT(	name)   DEFINE_SCALAR_PARAM(name,AP_OUT	,wchar_t,0)

#define APL_CUSTOM_PARAM(name,val,f,mk,fm)	name={f,mk,fm}; name.vals.vp=val 

#define APL_ZFORMAT_PARAM(name,val)		APL_DEFINE_PARAM(name,AP_IN,pf_z,pt_z); SET_ARRAY(name,ubyte,val,0)
#define APL_ZFORMAT_RESULT(name,val,l,f)	APL_DEFINE_PARAM(name,f|AP_OUT,pf_z,pt_z); SET_ARRAY(name,ubyte,val,l)
#define APL_ZFORMAT_INOUT(name,val,l,f)		APL_DEFINE_PARAM(name,f|AP_OUT|AP_IN,pf_z,pt_z); SET_ARRAY(name,ubyte,val,l)

#define APL_INT8_ARRAY_PARAM(	name,v,l) 	APL_NUMBER_ARRAY_PARAM(int8_t,name,v,l,AP_IN)
#define APL_INT8_ARRAY_RESULT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(int8_t,name,v,l,f|AP_OUT)
#define APL_INT8_ARRAY_INOUT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(int8_t,name,v,l,f|AP_IN|AP_OUT)
#define APL_INT16_ARRAY_PARAM(	name,v,l) 	APL_NUMBER_ARRAY_PARAM(int16_t,name,v,l,AP_IN)
#define APL_INT16_ARRAY_RESULT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(int16_t,name,v,l,f|AP_OUT)
#define APL_INT16_ARRAY_INOUT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(int16_t,name,v,l,f|AP_IN|AP_OUT)
#define APL_INT32_ARRAY_PARAM(	name,v,l) 	APL_NUMBER_ARRAY_PARAM(int32_t,name,v,l,AP_IN)
#define APL_INT32_ARRAY_RESULT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(int32_t,name,v,l,f|AP_OUT)
#define APL_INT32_ARRAY_INOUT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(int32_t,name,v,l,f|AP_IN|AP_OUT)
#define APL_INT64_ARRAY_PARAM(	name,v,l) 	APL_NUMBER_ARRAY_PARAM(int64_t,name,v,l,AP_IN)
#define APL_INT64_ARRAY_RESULT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(int64_t,name,v,l,f|AP_OUT)
#define APL_INT64_ARRAY_INOUT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(int64_t,name,v,l,f|AP_IN|AP_OUT)
#define APL_DOUBLE_ARRAY_PARAM(	name,v,l) 	APL_NUMBER_ARRAY_PARAM(double,name,v,l,AP_IN)
#define APL_DOUBLE_ARRAY_RESULT(name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(double,name,v,l,f|AP_OUT)
#define APL_DOUBLE_ARRAY_INOUT(	name,v,l,f) 	APL_NUMBER_ARRAY_PARAM(double,name,v,l,f|AP_IN|AP_OUT)

#define APL_CHAR8_ARRAY_PARAM(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char8,name,v,0,f|AP_IN)
#define APL_CHAR8_ARRAY_RESULT(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char8,name,v,l,f|AP_OUT)
#define APL_CHAR8_ARRAY_INOUT(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char8,name,v,l,f|AP_IN|AP_OUT)
#define APL_CHAR16_ARRAY_PARAM(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char16,name,v,0,f|AP_IN)
#define APL_CHAR16_ARRAY_RESULT(name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char16,name,v,l,f|AP_OUT)
#define APL_CHAR16_ARRAY_INOUT(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char16,name,v,l,f|AP_IN|AP_OUT)
#define APL_CHAR32_ARRAY_PARAM(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char32,name,v,0,f|AP_IN)
#define APL_CHAR32_ARRAY_RESULT(name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char32,name,v,l,f|AP_OUT)
#define APL_CHAR32_ARRAY_INOUT(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char32,name,v,l,f|AP_IN|AP_OUT)
#define APL_CHAR_ARRAY_PARAM(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char,name,v,0,f|AP_IN)
#define APL_CHAR_ARRAY_RESULT(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char,name,v,l,f|AP_OUT)
#define APL_CHAR_ARRAY_INOUT(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(char,name,v,l,f|AP_IN|AP_OUT)
#define APL_WCHAR_ARRAY_PARAM(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(wchar_t,name,v,l,f|AP_IN)
#define APL_WCHAR_ARRAY_RESULT(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(wchar_t,name,v,l,f|AP_OUT)
#define APL_WCHAR_ARRAY_INOUT(	name,v,l,f) 	APL_CHARACTER_ARRAY_PARAM(wchar_t,name,v,l,f|AP_IN|AP_OUT)


extern int call_apl(const wchar_t *name,APL_PARAM *first,...);
extern int load_apl(unsigned int flags, int argc, wchar_t **argv);

