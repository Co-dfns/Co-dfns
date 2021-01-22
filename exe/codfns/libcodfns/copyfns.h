#define ARRAY_FNS(type) 	\
extern void LIBCALL pf_a_##type(PP *pp,APL_PARAM *param); \
extern void LIBCALL pt_a_##type(PP *pp,APL_PARAM *param); 

#define SCALAR_FNS(type) 	\
extern void LIBCALL pf_##type(PP *pp,APL_PARAM *param);  \
extern void LIBCALL pt_##type(PP *pp,APL_PARAM *param);	

#define CHAR_ARRAY_FNS(type)		\
extern void LIBCALL pf_a_##type(PP *pp,APL_PARAM *param); \
extern void LIBCALL pt_a_##type(PP *pp,APL_PARAM *param)

#define POCK_FNS(type) ARRAY_FNS(type); SCALAR_FNS(type)

POCK_FNS(int8_t);
POCK_FNS(int16_t);
POCK_FNS(int32_t);
POCK_FNS(int64_t);
POCK_FNS(double);

POCK_FNS(char);
POCK_FNS(char8);
POCK_FNS(char16);
POCK_FNS(char32);
POCK_FNS(wchar_t);

//CHAR_ARRAY_FNS(char8);
//CHAR_ARRAY_FNS(char16);
//CHAR_ARRAY_FNS(char32);
//CHAR_ARRAY_FNS(wchar_t);

extern void LIBCALL pf_str(PP *pp,APL_PARAM *param);
extern void LIBCALL pt_str(PP *pp,APL_PARAM *param);

extern void LIBCALL pf_z(PP *pp,APL_PARAM *param);
extern void LIBCALL pt_z(PP *pp,APL_PARAM *param);



