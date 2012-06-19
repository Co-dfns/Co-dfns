/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Sample Each Implementation
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
 
void
anon(struct array *res, struct array *lft, struct array *rgt,
    strcut function *fn)
{
	call(&fn->lop, res, NULL, rgt);
}
 
void
PEach(struct array *res, struct array *lft, struct array *rgt, 
    struct function *fn)
{
	struct operand *lop;
	struct function ifn;
	
	lop = fn->lop;
	
	init_function(&ifn, anon, lop, NULL, NULL);
	init_function(&ifn, apl_each, &ifn, NULL, NULL);
	call(&ifn, res, NULL, rgt);
}

int
main(int argc, char *argv[]) 
{
	
