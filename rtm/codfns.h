#pragma once

#include <stddef.h>

#ifdef _WIN32
	#define EXPORT __declspec(dllexport)
	#ifdef EXPORTING
		#define DECLSPEC EXPORT
	#else
		#define DECLSPEC __declspec(dllimport)
	#endif
#elif defined(__GNUC__)
	#define DECLSPEC __attribute__ ((visibility ("default")))
#else
	#define DECLSPEC
#endif

struct dwa_dmx {
	unsigned	int flags;
	unsigned	int en;
	unsigned	int enx;
	const	wchar_t *vendor;
	const	wchar_t *message;
	const	wchar_t *category;
};

struct dwa_wsfns {
	long	long size;
	void	*getarray;
	void	(*_0[16])(void);
	void	(*error)(struct dwa_dmx *);
};

struct dwa_fns {
	long	long size;
	struct	dwa_wsfns *ws;
};

DECLSPEC int 
set_dwafns(void *);

DECLSPEC void
dwa_error(unsigned int, wchar_t *);

enum cell_type {
	CELL_ARRAY, CELL_MCELL, CELL_CLOSURE
};

DECLSPEC void
release_cell(void *);

DECLSPEC void
retain_cell(void *);

struct array;

enum array_type {
	ARR_BOOL, ARR_SINT, ARR_INT, ARR_DBL, ARR_CHAR, ARR_CMP, 
	ARR_MIXED, ARR_NESTED
};

enum array_storage {
	STG_HOST, STG_DEVICE
};

DECLSPEC int 
mk_array(struct array **, enum array_type, enum array_storage, 
    unsigned int, unsigned long long *);

DECLSPEC void
release_array(struct array *);

struct mcell;

DECLSPEC int
mk_mcell(struct mcell **, void *);

DECLSPEC void
release_mcell(struct mcell *);

struct closure;

DECLSPEC int
mk_closure(struct closure **, 
    int (*)(void **, void *, void *, void **),
    unsigned int);

DECLSPEC void
release_closure(struct closure *);

DECLSPEC int
apply_oper(struct closure **, struct closure *, void *, void *);
