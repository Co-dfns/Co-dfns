/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * A Simple Sum of Two Iotas
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

#include <stdio.h>
#include <stdlib.h>
 
#include "runtime.h" 

void
sum_reduce(struct array *res, struct array *lft, struct array *rgt,
    struct function *fn)
{
	size_t size;
	struct array a;
	struct function red, plus;
	struct operand oplus;
	
	oplus.type  = OPFUN;
	oplus.value = (union operand_value) &plus;
	
	size = product(rgt);
	
	init_function(&plus, apl_plus, NULL, NULL, NULL);
	init_function(&red, apl_reduce, &oplus, NULL, NULL);

	init_array(&a, ELINT);
	init_data(&a, size);
	
	apl_iota(&a, NULL, rgt, NULL);
	call(&red, res, NULL, &a);
	
	free_elems(size, ELINT);
}

int
main(int argc, char *argv[]) 
{
	struct array a, b, c;
	struct function fn, feach;
	struct operand ofn;
	
	init_array(&a, ELINT);
	init_array(&b, ELINT);
	init_array(&c, ELINT);
	init_data(&a, 20);
	init_data(&b, 20);
	init_data(&c, 1);
	
	ofn.type = OPFUN;
	ofn.value = (union operand_value) &fn;
	
	init_function(&fn, sum_reduce, NULL, NULL, NULL);
	init_function(&feach, apl_each, &ofn, NULL, NULL);
	
	apl_assign(&c, 0, (union value) 20);
	apl_iota(&b, NULL, &c, NULL);
	
	call(&feach, &a, NULL, &b);
	
	apl_print(&a);
	
	free_elems(41, ELINT);
}
