#include "codfns.h"

#include <arrayfire.h>
#include <stddef.h>

#if AF_API_VERSION < 36
#error "Your ArrayFire version is too old."
#endif

#define DWADATA(pp) ((void *)&(pp)->shape[(pp)->rank])

enum dwatype { 
	APLNC=0, APLU8, APLTI, APLSI, APLI, APLD, 
	APLP,    APLU,  APLV,  APLW,  APLZ, APLR, APLF, APLQ
};

struct dwapocket {
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

struct dwalocalp {
	struct	dwapocket *pocket;
	void	*item;
};

struct dwadmx {
	unsigned	int flags;
	unsigned	int en;
	unsigned	int enx;
	const	wchar_t *vendor;
	const	wchar_t *message;
	const	wchar_t *category;
};

struct dwadmx dmx;

struct dwawsfns {
	long	long size;
	struct	dwapocket *(*getarray)(enum dwatype, unsigned int, long long *,
	    struct dwalocalp *);
	void	(*_0[16])(void);
	void	(*error)(struct dwadmx *);
};

struct dwafns {
	long	long size;
	struct	dwawsfns *ws;
};
	
struct dwafns *dwa = NULL;

DECLSPEC int 
set_dwa(struct dwafns *fns)
{
	if (fns)
		dwa = fns;
	else 
		return 0;

	if (dwa->size < (long long)sizeof(struct dwafns))
		return 16;
	
	return 0;
}

DECLSPEC void
dwaerror(unsigned int n, wchar_t *msg)
{
	dmx.flags	= 3;
	dmx.en		= n;
	dmx.enx		= n;
	dmx.vendor	= L"Co-dfns";
	dmx.message	= msg;
	dmx.category	= NULL;

	dwa->ws->error(&dmx);
}

