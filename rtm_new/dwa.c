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
	struct pocket *(*ga)(enum dwa_type, unsigned, long long *, struct localp *);

	ga = dwa->ws->getarray;

	return ga(type, a, b, c);
}
