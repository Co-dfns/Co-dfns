/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Core forms and runtime environment
 * 
 * Copyright (c) 2012 Aaron Hsu <arcfide@sacrideo.us>
 * 
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

#include "runtime.h"

/******************
 * Error reporting
 ******************/
 
void
runtime_error(int code)
{
	switch(code) {
	case ALLOC_MALLOCFAIL: 
		fprintf(stderr, "%s\n", ALLOC_MALLOCFAIL_MSG); break;
	}
	
	exit(code);
}

/*********************************************
 * Array Allocation: alloc tgt,rank,size
 *   tgt   Target variable for the allocation
 *   rank  Rank of the array
 *   size  Elements in the array
 *********************************************/

void 
allocp(struct array **tgt, unsigned short rank, size_t size)
{
	struct array *arr;
	size_t        total;
	
	total = sizeof(struct array) 
	    + (rank * sizeof(unsigned int))
	    + (size * sizeof(union scalar));
	
	arr = realloc(*tgt, total);
	
	if (NULL == arr) runtime_error(ALLOC_MALLOCFAIL);
	
	arr->rank  = rank;
	arr->shape = (unsigned int *) arr->data + size;
	
	*tgt = arr;
}

/***************************************
 * Indexed assignment: iset idx,tgt,src
 *   idx   Index array variable
 *   tgt   Target array variable
 *   src   Source array variable
 ***************************************/
 
/***********************************************
 * Indexed Single Assignment: saset idx,tgt,src
 *   idx   Index array variable
 *   tgt   Target array variable
 *   src   Source array variable
 ***********************************************/

