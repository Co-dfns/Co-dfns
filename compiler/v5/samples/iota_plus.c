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

#include <stdlib.h>
 
#include "runtime.h" 

int
main(int argc, char *argv[]) 
{
	struct array a, b, out;
	
	init_array(&a, ELINT);
	init_array(&b, ELINT);
	init_array(&out, ELINT);
	init_data(&a, 10);
	init_data(&b, 10);
	init_data(&out, 10);
	
	apl_assign(&a, 0, 10);
	apl_assign(&out, 0, 10);
	apl_iota(&b, NULL, &a, NULL);
	apl_iota(&a, NULL, &out, NULL);
	apl_plus(&out, &a, &b, NULL);
	apl_print(&out);
	
	return 0;
}
