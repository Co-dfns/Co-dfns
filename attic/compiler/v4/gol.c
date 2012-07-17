/**
 * ∇R←S LIFE G;L;I;O
 *  L←{1 1↓¯1 ¯1↓1 ⍵∨.∧3 4=⊃+⌿,¯1 0 1∘.⊖¯1 0 1⌽¨⊂⍵}
 *  I←{⍵+[0](⍴G)|¯1+⍳2+S⌊(⍴G)-⍵}
 *  O←{⍵+[0]⍳S⌊(⍴G)-⍵}
 *  (L↦O R←(⍴G)⍴∅)↤I G
 *  L∥F∥G ⍳⌈(⍴G)÷S
 * ∇
 */

defun(LIFE_L) {
	1 1↓¯1 ¯1↓1 ⍵∨.∧3 4=⊃+⌿,¯1 0 1∘.⊖¯1 0 1⌽¨⊂⍵
}

defun(LIFE_I) {
	⍵+[0](⍴G)|¯1+⍳2+S⌊(⍴G)-⍵
}

defun(LIFE_O) {
	alloc	(RES,1,rank(G));
	shp	(RES,G);
	alloc	(T2,rank(RES),size(RES));
	sub	(T2,RES,LFT);
	floor	(T2,fv(0),T2);
	alloc	(RES,1+size(T2),size(T2)*prod(RES));
	idx	(RES,T2);
	RES←LFT+[0]RES
	frea	(T2);
}

defmain(R, S, G) {
	declf	(L);
	mfn	(L,LIFE_L,0);
	declf	(I);
	mfn	(I,LIFE_I,1);
	sfv	(I,0,S);
	declf	(O);
	mfn	(O,LIFE_O,1);
	sfv	(O,0,S);
	alloc	(R,0,0);
	set	(R,EMPTYSA);
	alloc	(T1,1,rank(G));
	shp	(T1,G);
	alloc	(R,size(T1),prod(T1));
	rshp	(R,T1,R);
	olnk	(L,0,O,R);
	ilnk	(L,0,I,G);
	alloc	(T2,1,rank(G));
	shp	(T2,G);
	alloc	(T1,rank(T2),size(T2));
	div	(T1,T2, S);
	ceil	(T1,T1);
	alloc	(T2,1+size(T1),size(T1)*prod(T1));
	idx	(T2,T1);
	par	(L,T2);
	frea	(T1);
	frea	(T2); 
}
