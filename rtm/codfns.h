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

enum cell_type {
	CELL_ARRAY, CELL_MCELL, CELL_CLOSURE
};

enum array_type {
	ARR_BOOL, ARR_SINT, ARR_INT, ARR_DBL, ARR_CHAR, ARR_CMP, 
	ARR_MIXED, ARR_NESTED
};

enum array_storage {
	STG_HOST, STG_DEVICE
};

struct pocket;
struct mcell;

struct localp {
	struct	pocket *pocket;
	void	*item;
};

struct array {
	enum	cell_type ctyp;
	unsigned	int refc;
	void	*values;
	enum	array_storage storage;
	enum	array_type type;
	unsigned	int rank;
	unsigned	long long shape[];
};

struct closure {
	enum	cell_type ctyp;
	unsigned	int refc;
	unsigned	int fs;
	int	(*fn)(struct array **, struct array *, struct array *, void **);
	void	*fv[];
};

DECLSPEC int
cdf_init(void);

DECLSPEC int 
set_dwafns(void *);

DECLSPEC void
set_dmx_message(wchar_t *);

DECLSPEC void
dwa_error(unsigned int);

DECLSPEC int
dwa2array(struct array **, struct pocket *);

DECLSPEC int
array2dwa(struct pocket **, struct array *, struct localp *);

DECLSPEC void
release_cell(void *);

DECLSPEC void *
retain_cell(void *);

DECLSPEC int 
mk_array(struct array **, enum array_type, enum array_storage, 
    unsigned int, unsigned long long *, void *);

DECLSPEC void
release_array(struct array *);

DECLSPEC int
mk_mcell(struct mcell **, void *);

DECLSPEC void
release_mcell(struct mcell *);

DECLSPEC int
mk_closure(struct closure **, 
    int (*)(struct array **, struct array *, struct array *, void **),
    unsigned int);

DECLSPEC void
release_closure(struct closure *);

DECLSPEC int
apply_oper(struct closure **, struct closure *, void *, void *);

DECLSPEC extern struct closure *rgt;
