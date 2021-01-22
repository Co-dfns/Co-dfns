#define NO_LOCALP_MACROS
#define WANT_REFCOUNTS 1
#define AP_BUILD 1

#define BOUND_RES_WS		2
#define BOUND_RES_SCRIPT	14
#define BOUND_RES_SCRIPT_FILE	15

#if !defined(xxBIT)
	#if defined(_M_X64) || defined(__64BIT__)
		#define xxBIT 64
	#else
		#define xxBIT 32
	#endif
#endif


#if !defined(LIBCALL)
#if defined(_MSC_VER)
#define LIBCALL __cdecl
#else
#define LIBCALL 
#endif
#endif


#if !defined(EXPORT)
#if defined(_MSC_VER)
	#if xxBIT==32
		//#define EXPORT __stdcall
		#define EXPORT __declspec(dllexport) 
	#else
		#define EXPORT __declspec(dllexport) 
	#endif
#elif defined(__GNUC__) || defined(__xlC__)
	#define EXPORT __attribute__ ((visibility ("default")))
#else
	#define EXPORT
#endif
#endif


