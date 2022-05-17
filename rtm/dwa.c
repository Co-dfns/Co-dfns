#include <stddef.h>

#include "codfns.h"

#define DWADATA(pp) ((void *)&(pp)->shape[(pp)->rank])

enum dwa_type { 
	APLNC=0, APLU8, APLTI, APLSI, APLI, APLD, 
	APLP,    APLU,  APLV,  APLW,  APLZ, APLR, APLF, APLQ
};

struct pocket {
	long	long length;
	long	long refcount;
	unsigned	int type	: 4;
	unsigned	int rank	: 4;
	unsigned	int eltype	: 4;
	unsigned	int _0		: 13;
	unsigned	int _1		: 16;
	unsigned	int _2		: 16;
	long	long shape[1];
};

struct localp {
	struct	pocket *pocket;
	void	*item;
};

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
	struct	pocket *
	    (*getarr)(enum dwa_type, unsigned, long long *, struct localp *);
	void	(*_0[16])(void);
	void	(*error)(struct dwa_dmx *);
};

struct dwa_fns {
	long	long size;
	struct	dwa_wsfns *ws;
};

struct dwa_dmx dmx;	
struct dwa_fns *dwa = NULL;

DECLSPEC int 
set_dwafns(void *fns)
{
	if (fns)
		dwa = fns;
	else 
		return 0;

	if (dwa->size < (long long)sizeof(struct dwa_fns))
		return 16;
	
	return 0;
}

DECLSPEC void
dwa_error(unsigned int n, wchar_t *msg)
{
	dmx.flags	= 3;
	dmx.en		= n;
	dmx.enx		= n;
	dmx.vendor	= L"Co-dfns";
	dmx.message	= msg;
	dmx.category	= NULL;

	dwa->ws->error(&dmx);
}

struct pocket *
getarray(enum dwa_type type, unsigned a, long long *b, struct localp *c)
{
	return (dwa->ws->getarr)(type, a, b, c);
}

DECLSPEC struct pocket *
array2dwa(struct localp *lp, struct array *arr)
{
	lp->pocket = NULL;

	return NULL;
}
