⍝[of]:Primitive Operators
ocl	←{⍵∘(⍵⍵{'(',(opl ⍺),(opt ⍺⍺),⍵,' ⍵⍵)'})¨1↓⍺⌷⍨(0⌷⍉⍺)⍳⊂⍺⍺}
opl	←{⊃,/{'(,''',⍵,''')'}¨⍵}
opt	←{'(',(⍕⍴⍵),'⍴',(⍕,⍵),')'}
odb	←0 5⍴⊂''

⍝[c]		Prim	Monadic	Dyadic	Monadic Bool	Dyadic Bool
odb	⍪←,¨	'⍨'	'comm'	'comd'	''	''
odb	⍪←,¨	'¨'	'eacm'	'eacd'	''	''
odb	⍪←,¨	'/'	'redm'	'redd'	''	''
odb	⍪←,¨	'⌿'	'rd1m'	'rd1d'	''	''
odb	⍪←,¨	'\'	'scnm'	'err16'	''	''
odb	⍪←,¨	'⍀'	'sc1m'	'err16'	''	''
odb	⍪←,¨	'.'	'err99'	'inpd'	''	''
odb	⍪←	'∘.'	'err99'	'oupd'	''	''

err99	←{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 99}
err16	←{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 16}

⍝[of]:Commute
comd	←{('df'gcl ⍵⍵)((1↑n),(⌽1↓n),⊂⊃⍺⍺)((1↑e),(⌽1↓e),⊂¯1 0)((1↑⍺),(⌽1↓⍺),0)⊣n e←↓⍉⍵}
comm	←{('df'gcl ⍵⍵)((1↑n),(2⍴1↑1↓n),⊂⊃⍺⍺)((1↑e),(3⍴1↑1↓e))((1↑⍺),3⍴1↑1↓⍺)⊣n e←↓⍉⍵}
⍝[cf]
⍝[of]:Each
mapmoinaaa	←{(3⊃⍺)(((0⌷⍺),(2 0⊃⍵)⊃('' '')('I' 1)('D' 2)('U8' 3))sclmfnaaa'I' 1)⍵}
mapmofnaaa	←{(3⊃⍺)(((0⌷⍺),(2 0⊃⍵)⊃('' '')('I' 1)('D' 2)('U8' 3))sclmfnaaa'D' 2)⍵}
mapmobnaaa	←{(3⊃⍺)(((0⌷⍺),(2 0⊃⍵)⊃('' '')('I' 1)('D' 2)('U8' 3))sclmfbaaa'U8' 3)⍵}
eacm	←{(⊃⍺⍺)(4⍴⊂¯1 0)(1⊃⍺⍺)('mo'gcl ⍵⍵)((0⌷⍉⍵),,¨'%u' '¨')((1⌷⍉⍵),2⍴⊂¯1 0)(⍺,4 0)}
eacd←{	chk	←'if(lr==rr){DO(i,lr){if(rs[i]!=ls[i])dwaerr(5);}}',nl
	chk	,←'else if(lr!=0&&rr!=0){dwaerr(4);}'
	siz	←'if(rr==0){zr=lr;DO(i,lr){zc*=ls[i];lc*=ls[i];zs[i]=ls[i];}}',nl
	siz	,←'else{zr=rr;DO(i,rr){zc*=rs[i];rc*=rs[i];zs[i]=rs[i];}DO(i,lr)lc*=ls[i];}'
	exe	←pacc'update host(lv[:lft->c],rv[:rgt->c])'
	exe	,←'DO(i,zc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i]' 'rv[i]' 'lv[i]'),'}',nl
	exe	,←pacc'update device(zv[:rslt->c])'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce
redm←{	idf←(,¨'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'),⊂'⎕XOR'
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 0 ''
	hid	←idf∊⍨0⌷⍺⍺
	gpf	←(,¨'+×∧∨'),⊂'⎕XOR'
	gpv	←⍕¨0 1 1 0 0 ''
	gid	←gpf∊⍨0⌷⍺⍺
	chk	←hid⊃('if(rr>0&&rs[rr-1]==0)dwaerr(11);')''
	siz	←'if(rr==0){zr=0;}',nl
	siz	,←'else{zr=rr-1;DO(i,zr){zc*=rs[i];zs[i]=rs[i];};rc=rs[zr];}'
	exe	←'I zn=',((3=⊃0⌷⍺)⊃'zc' '((zc+7)/8)'),';'
	exe	,←'I rn=',((3=⊃1⌷⍺)⊃'rc' '((rc+7)/8)'),';',nl
	exe	,←'if(rc==0){'
	exe1a	←'dwaerr(11);',nl
	exe1b	←nl,simd'present(zv[:zc])'
	exe1b	,←'DO(i,zc){zv[i]=',(idv⊃⍨idf⍳0⌷⍺⍺),';}',nl
	exe1c	←nl,simd'present(zv[:zn])'
	exe1c	,←'DO(i,zn){zv[i]=',('0' '-1' ''⊃⍨(,¨'01')⍳idv⌷⍨idf⍳0⌷⍺⍺),';}',nl
	exe	,←(2⊥hid(3=⊃0⌷⍺))⊃exe1a exe1a exe1b exe1c
	exe	,←'}else if(rc==1){'
	exe	,←nl,simd'present(zv[:zn],rv[:zn])'
	exe	,←'DO(i,zn){zv[i]=rv[i];}',nl
	exe	,←'}else if(zc==1){'
	exe3a	←nl,pacc gid⊃'update host(rv[:rc])' 'update host(rv[rc-1:1])'
	exe3a	,←(⊃git⊃⍺),'val=rv[rc-1];B n=rc-1;',nl
	exe3a	,←pacc gid⊃'enter data copyin(val)' 'kernels loop present(rv[:rc])'
	exe3a	,←'DO(i,n){',nl
	exe3a	,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[rc-(2+i)]'
	exe3a	,←gid⊃(nl,pacc'update device(val)')''
	exe3a	,←'}',nl,gid⊃(pacc'exit data delete(val)')''
	exe3a	,←'zv[0]=val;',nl,pacc'update device(zv[:1])'
	exe3b	←nl,pacc gid⊃'update host(rv[:rn])' 'update host(rv[rn-1:1])'
	exe3b	,←(⊃git⊃⍺),'val=1&(rv[rn-1]>>((rc-1)%8));B n=rc-1;',nl
	exe3b	,←pacc gid⊃'enter data copyin(val)' 'kernels loop present(rv[:rn])'
	exe3b	,←'DO(i,n){I ri=rc-(2+i);I cr=1&(rv[ri/8]>>(ri%8));',nl
	exe3b	,←gid⊃(pacc'data copyin(cr)')''
	exe3b	,←((2⍴⊃⍺),1,2↓⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'cr'
	exe3b	,←gid⊃(nl,pacc'update device(val)')''
	exe3b	,←'}',nl,gid⊃(pacc'exit data delete(val)')''
	exe3b	,←'zv[0]=',('val;' 'val<<7;'⊃⍨3=⊃0⌷⍺),nl
	exe3b	,←pacc'update device(zv[:1])'
	exe	,←(2⊥(3=2↑⍺))⊃exe3a exe3b exe3a exe3b
	exe	,←'}else if(0==zc*rc){',nl
	exe	,←'}else{'
	exe4lp  ←'kernels loop gang worker(32) present(zv[:zn],rv[:rn])'
	exe4a	←nl,pacc gid⊃'update host(rv[:rc])' exe4lp
	exe4a	,←'DO(i,zc){',(⊃git⊃⍺),'val=rv[(i*rc)+rc-1];L n=rc-1;',nl
	exe4a	,←pacc gid⊃'enter data copyin(val)' 'loop vector(32)'
	exe4a	,←'DO(j,n){',nl
	exe4a	,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[(i*rc)+(rc-(2+j))]'
	exe4a	,←gid⊃(nl,pacc'update device(val)')''
	exe4a	,←'}',nl,gid⊃(pacc'exit data delete(val)')''
	exe4a	,←'zv[i]=val;}',nl, gid⊃(pacc'update device(zv[:zc])')''
	exe4b	←nl,(simd'present(zv[:zn])'),'DO(i,zn){zv[i]=0;};B n=rc-1;',nl
	exe4b	,←pacc gid⊃'update host(rv[:rn])' exe4lp
	exe4b	,←'DO(i,zc){I si=(i*rc)+rc-1;',nl
	exe4b	,←(⊃git⊃⍺),'val=1&(rv[si/8]>>(si%8));',nl
	exe4b	,←pacc gid⊃'enter data copyin(val)' 'loop vector(32)'
	exe4b	,←'DO(j,n){I ri=(i*rc)+(rc-(2+j));I cr=1&(rv[ri/8]>>(ri%8));',nl
	exe4b	,←((2⍴⊃⍺),1,2↓⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'cr'
	exe4b	,←gid⊃(nl,pacc'update device(val)')''
	exe4b	,←'}',nl,gid⊃(pacc'exit data delete(val)')''
	exe4b	,←(3=⊃0⌷⍺)⊃'zv[i]=val;' 'zv[i/8]|=val<<(i%8);'
	exe4b	,←'}',nl,gid⊃(pacc'update device(zv[:zn])')''
	exe	,←(2⊥(3=2↑⍺))⊃exe4a exe4b exe4a exe4b
	exe	,←'}'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce N-wise
redd←{	idf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
	hid	←idf∊⍨⊃⊃⍺⍺ ⋄ a←0 1 1⊃¨⊂⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(5);',nl
	chk	,←'if(rr==0)dwaerr(4);',nl,hid⊃('if(lv[0]==0)dwaerr(11);',nl)''
	chk	,←'if((rs[rr-1]+1)<lv[0])dwaerr(5);rc=(1+rs[rr-1])-lv[0];'
	siz	←'zr=rr;I n=zr-1;DOI(i,n){zc*=rs[i];zs[i]=rs[i];};zs[zr-1]=rc;lc=rs[rr-1];'
	exe	←pacc'update host(rv[:rgt->c],lv[:lft->c])'
	exe	,←'DO(i,zc){DO(j,rc){zv[(i*rc)+j]='
	exe	,←hid⊃'rv[(i*lc)+j+lv[0]-1];'(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺)
	val	←'zv[(i*rc)+j]' 'zv[(i*rc)+j]'('rv[(i*lc)+j+(lv[0]-(k+',(hid⌷'21'),'))]')
	exe	,←nl,' L n=lv[0]',(hid⊃'-1' ''),';DO(k,n){'
	exe	,←hid⊃(nl,pacc'update device(zv[(i*rc)+j:1])')''
	exe	,←(a((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
	exe	,←pacc'update device(zv[:rslt->c])'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce First Axis
rdfidf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
rdfidv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
rdfmochk	←{⍵∊rdfidf:'' ⋄ 'if(rr>0&&!rs[0])dwaerr(11);',nl}
rdfmohid←{	lp	←'else if(!jc){',nl
	lp	,←(simd''),'DO(i,zc)zv[i]=',(rdfidv⊃⍨rdfidf⍳⍵),';}',nl
	⍵∊rdfidf:	lp
		''}
rdfmoinaaa←{	fv fe fy db	←⍺
	v e y	←⍵
	fy	←¯1+⊃(4 5⊥1 4)⌷⍉fy
		(1'I',fy⊃(1'I')(2'D')(1'I'))(fv rdfmolpx db)v,⍪e}
rdfmofnaaa←{	fv fe fy db	←⍺
	v e y	←⍵
	fy	←⊃(4 5⊥2 4)⌷⍉fy
		2'D'2'D'(fv rdfmolpx db)v,⍪e}
rdfmolpx←{	rd rt d t	←⍺
	rslt rgt	←var/2↑⍵
	z	←'{',('r'(rt decarr)rgt),rdfmochk⊃⍺⍺
	z	,←'I jc=1;if(rr)jc=rs[0];',('rr?rr-1:0,rs+1,',⍕d)(t dectmp)'z'
	z	,←(acdt'present(rv[:rc],zv[:zc])'),'{',nl
	z	,←'if(jc==1){',nl,(simd''),'DO(i,zc)zv[i]=rv[i];}',nl
	z	,←(rdfmohid⊃⍺⍺),'else if(zc==1){',t,' t;',nl
	z	,←(simd''),'DO(i,1){t=rv[jc-1];}',nl,(simd''),'DO(j,jc-1){',nl
	z	,←('df'gcl ⍵⍵)(,¨'t' 't' 'rv[jc-(j+2)]' ⍺⍺)(4⍴⊂¯1 ¯1)(d d rd 0)
	z	,←'}',nl,(simd''),'DO(i,1){zv[0]=t;}}',nl,'else {',nl
	z	,←(simd''),'DO(i,zc){',t,' t=rv[(jc-1)*zc+i];',nl
	z	,←' DO(j,jc-1){',nl
	z	,←('df'gcl ⍵⍵)(,¨'t' 't' 'rv[zc*(jc-(j+2))+i]' ⍺⍺)(4⍴⊂¯1 ¯1)(d d rd 0)
	z	,←'}',nl,' zv[i]=t;}}',nl
		z,'}',nl,'cpaa(',rslt,',&za);}',nl}
rdfmobnaaa←{	fv fe fy db	←⍺
	v e y	←⍵
	1 2∨.=⊃y:	((¯1+⊃y)⊃(1'I')(2'D'))(fv rdfmolpxb db)v,⍪e
		'dwaerr(16);',nl}
rdfmolpxb←{	d t	←⍺
	rslt rgt	←var/2↑⍵
	z	←'{',('r'decarrb rgt),rdfmochk⊃⍺⍺
	z	,←'I jc=1;if(rr)jc=rs[0];',('rr?rr-1:0,rs+1,',⍕d)(t dectmp)'z'
	z	,←(acdt'present(rv[:rz],zv[:zc])'),'{',nl
	z	,←'if(jc==1){',nl,simd''
	z	,←' DO(i,zc)zv[i]=1&(rv[i/8]>>(i%8));}',nl
	z	,←rdfmohid⊃⍺⍺
	red	←'reduction(',(('+×⌈⌊∨∧'⍳⊃⍺⍺)⊃'+' '*' 'max' 'min' '||' '&&' ''),':t)'
	cal	←('df'gcl ⍵⍵)(,¨'t' 't' '(1&(rv[x/8]>>(x%8)))' ⍺⍺)(4⍴⊂¯1 ¯1)(d d 1 0)
	z	,←'else if(zc==1){',t,' t;',nl,simd''
	z	,←' DO(i,1){t=1&rv[0];}',nl,simd''
	z	,←' DO(i,jc-1){B x=i+1;',nl,cal,'}',nl,simd''
	z	,←' DOI(i,1){zv[0]=t;}',nl
	z	,←'}else{',nl,simd''
	z	,←' DO(i,zc){',t,' t=1&(rv[i/8]>>(i%8));',nl
	z	,←'  DO(j,jc-1){B x=(j+1)*zc+i;',nl,cal,'}',nl
	z	,←'  zv[i]=t;}',nl
		z,'}}',nl,'cpaa(',rslt,',&za);}',nl}
rd1m←{	fn fy	←⍺⍺
	y	←⍺
	v e	←↓⍉⍵
	fv	←,¨'_' fn '%u' '⌿'
	fe	←4⍴⊂¯1 0
		fn fe fy('mo'gcl ⍵⍵)(v,,¨'%u' '⌿')(e,2⍴⊂¯1 0)(y,4 0)}
⍝[cf]
⍝[of]:Reduce N-wise First Axis
rd1d←{	idf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
	hid	←idf∊⍨⊃⊃⍺⍺
	a	←0 1 1⊃¨⊂⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(5);',nl
	chk	,←'if(rr==0)dwaerr(4);',nl,hid⊃('if(lv[0]==0)dwaerr(11);',nl)''
	chk	,←'if((rs[0]+1)<lv[0])dwaerr(5);rc=(1+rs[0])-lv[0];'
	siz	←'zr=rr;I n=zr-1;DOI(i,n){zc*=rs[i+1];zs[i+1]=rs[i+1];};zs[0]=rc;'
	exe	←pacc'update host(rv[:rgt->c],lv[:lft->c])'
	exe	,←'DO(i,zc){DO(j,rc){zv[(j*zc)+i]='
	exe	,←hid⊃'rv[((j+lv[0]-1)*zc)+i];'(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺)
	val	←'zv[(j*zc)+i]' 'zv[(j*zc)+i]'('rv[((j+(lv[0]-(k+',(hid⌷'21'),')))*zc)+i]')
	exe	,←nl,' L n=lv[0]',(hid⊃'-1' ''),';DO(k,n){'
	exe	,←hid⊃(nl,pacc'update device(zv[(j*zc)+i:1])')''
	exe	,←(a((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
	exe	,←pacc'update device(zv[:rslt->c])'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Scan
⍝[c]Vector GPU Scan
scngv←{
	z	←'{',⍺,' b[513];I bc;B p,t,fp,ft,fpt;',nl
	z	,←'if(rc<=131072){bc=(rc+255)/256;p=256;t=1;fp=rc-256*(bc-1);ft=fpt=256;}',nl
	z	,←'else{bc=512;p=(rc+bc-1)/bc;t=(p+255)/256;',nl
	z	,←' fp=rc-p*(bc-1);ft=p-256*(t-1);fpt=fp-256*(t-1);}',nl
	z	,←(ackn'present(rv[:rc],zv[:rc]) create(b[:bc+1])'),'{',⍺,' ta[256];',nl
	z	,←(aclp''),'DOI(i,bc-1){',⍺,' t=',⍵,';B p128=(p+127)/128;',nl
	z	,←(pacc'loop vector'),' DO(j,p){I x=i*p+j;if(x<rc){',nl
	z	,←'  ',(⍺⍺,¨'t' 't' 'rv[x]'),'}}',nl,' b[i+1]=t;}',nl
	z	,←'DO(i,1){b[0]=',⍵,';}',nl,'DO(i,bc){',(⍺⍺'b[i+1]' 'b[i+1]' 'b[i]'),'}',nl
	z	,←(aclp'private(ta)'),'DOI(i,bc){',⍺,' s=b[i];B pid=i*p;',nl
	z	,←(pacc'cache(ta[:256])'),' DOI(j,t-1){B tid=pid+j*256;',nl
	z	,←(aclp''),'  DOI(k,256){ta[k]=rv[tid+k];}',nl,'  ',(⍺⍺'ta[0]' 'ta[0]' 's'),nl
	z	,←(aclp''),'  DOI(k,128){I x=k*2;',(⍺⍺'ta[x+1]' 'ta[x+1]' 'ta[x]'),'}',nl
	lp←{	b	←(aclp'collapse(2)'),'  DOI(g,',⍺,'){DOI(k,',⍵,'){I x=2*g*',⍵,'+',⍵,';'
			b,(⍺⍺'ta[x+k]' 'ta[x+k]' 'ta[x-1]'),'}}',nl}
	z	,←⍺⍺{⊃,/(⌽⍵)⍺⍺ lp¨⍵}⍕¨2*1+⍳6
	z	,←(aclp''),'  DOI(k,128){',(⍺⍺'ta[k+128]' 'ta[k+128]' 'ta[127]'),'}',nl
	z	,←(aclp''),'  DOI(k,256){zv[tid+k]=ta[k];}',nl,'  s=ta[255];}',nl
	z	,←' B sz=ft;if(i==bc-1)sz=fpt;B tid=pid+(t-1)*256;',nl
	z	,←(aclp''),' DOI(k,256){ta[k]=',⍵,';if(k<sz)ta[k]=rv[tid+k];}',nl
	z	,←' ',(⍺⍺'ta[0]' 'ta[0]' 's'),nl
	z	,←' for(I d=1;d<256;d*=2){',nl
	z	,←(aclp'collapse(2)'),'  for(I g=d;g<256;g+=d*2){',nl
	z	,←'   for(I k=0;k<d;k++){',(⍺⍺'ta[g+k]' 'ta[g+k]' 'ta[g-1]'),'}}}',nl
	z	,←(aclp''),' DOI(k,sz){zv[tid+k]=ta[k];}}',nl
		z,'}}',nl}

scnm←{	siz	←'zr=rr;if(rr)rc=rs[rr-1];DO(i,zr)zs[i]=rs[i];',nl
	siz	,←'I n;if(zr)n=zr-1;else n=0;DO(i,n)zc*=rs[i];'
	fil	←(gid←(ass←'+×⌈⌊∨∧')⍳⊃⊃⍺⍺)⊃,¨'0' '1' '-DBL_MAX' 'DBL_MAX' '0' '1' '-1'
	gpu	←(⊃git⊃⍺)(((⊃⍺),⍺)∘((⊃⍺⍺)scmx⍵⍵)scngv)fil
	exenn	←(('pg'≡2↑COMPILER)∧gid<≢ass)⊃''('if(rr==1&&rc!=0){',gpu,'}else ')
	exenn	,←'if(rc!=0){',nl,acup'host(zv[:rslt->c],rv[:rgt->c])'
	exenn	,←' DO(i,zc){B n=rc-1;B irc=i*rc;zv[irc]=rv[irc];',nl
	exenn	,←'  DO(j,n){B k=irc+j+1;zv[irc+j+1]=rv[k];',nl
	exenn	,←'   for(;k>irc;k--){',nl
	exenn	,←((⊂⊃⍺⍺)∊0⌷⍉sdb)⊃(acup'device(zv[irc+j+1:1])')''
	exenn	,←'    ',(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'zv[irc+j+1]' 'zv[irc+j+1]' 'rv[k-1]'),'}',nl
	exenn	,←'}}',nl,(acup'device(zv[:rslt->c],rv[:rgt->c])'),'}',nl
	exebb	←'if(rc!=0){B z8=(rslt->c+7)/8;B r8=(rgt->c+7)/8;',nl
	exebb	,←acup'host(zv[:z8],rv[:r8])'
	exebb	,←' DO(i,z8){zv[i]=0;}',nl
	exebb	,←' DO(i,zc){B irc=i*rc;B n=rc-1;',nl
	exebb	,←'  zv[irc/8]|=(1&(rv[irc/8]>>(irc%8)))<<(irc%8);',nl
	exebb	,←'  DO(j,n){B k=irc+j+1;U8 tmp=1&(rv[k/8]>>(k%8));',nl
	exebb	,←'   for(;k>irc;k--){U8 tmp2=1&(rv[(k-1)/8]>>((k-1)%8));',nl
	exebb	,←'    ',(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'tmp' 'tmp' 'tmp2'),'}',nl
	exebb	,←'   zv[(irc+j+1)/8]|=tmp<<((irc+j+1)%8);}}',nl
	exebb	,←(acup'device(zv[:z8],rv[:r8])'),'}',nl
	exenb	←'if(rc!=0){B r8=(rgt->c+7)/8;',nl
	exenb	,←acup'host(zv[:rslt->c],rv[:r8])'
	exenb	,←' DO(i,zc){B irc=i*rc;B n=rc-1;zv[irc]=1&(rv[irc/8]>>(irc%8));',nl
	exenb	,←'  DO(j,n){B k=irc+j+1;',(⊃git ⍺),'tmp=1&(rv[k/8]>>(k%8));',nl
	exenb	,←'   for(;k>irc;k--){U8 tmp2=1&(rv[(k-1)/8]>>((k-1)%8));',nl
	exenb	,←'    ',(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'tmp' 'tmp' 'tmp2'),'}',nl
	exenb	,←'   zv[irc+j+1]=tmp;}}',nl
	exenb	,←(acup'device(zv[:rslt->c],rv[:r8])'),'}',nl
		'' siz ((2⊥3=2↑⍺)⊃exenn exenb ('dwaerr(16);',nl) exebb) mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Scan First Axis
sc1m←{	siz	←'zr=rr;rc=rr==0?1:rs[0];DO(i,zr)zs[i]=rs[i];',nl
	siz	,←'I n=zr==0?0:zr-1;DOI(i,n)zc*=rs[i+1];'
	exe	←pacc'update host(zv[:rslt->c],rv[:rgt->c])'
	exe	,←'if(rc!=0){DO(i,zc){zv[i]=rv[i];}',nl
	val	←'zv[((j+1)*zc)+i]' 'zv[(j*zc)+i]' 'rv[((j+1)*zc)+i]'
	exe	,←' DO(i,zc){L n=rc-1;DO(j,n){'
	exe	,←((⊂⊃⍺⍺)∊0⌷⍉sdb)⊃(nl,pacc'update device(zv[(j*zc)+i:1])')''
	exe	,←(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
	exe	,←pacc'update device(zv[:rslt->c],rv[:rgt->c])'
		'' siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Outer Product
oupd←{	siz	←'zr=lr+rr;DO(i,lr)zs[i]=ls[i];DO(i,rr)zs[i+lr]=rs[i];'
	siz	,←'DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
	siz	,←nl,(3=⊃⍺)⊃'B zz=rc*lc;' 'B zz=(rc*lc+7)/8;'
	siz	,←nl,(3=1⊃⍺)⊃'B rz=rc;' 'B rz=(rc+7)/8;'
	siz	,←nl,(3=2⊃⍺)⊃'B lz=lc;' 'B lz=(lc+7)/8;'
	scl	←(⊂⊃⍺⍺)∊0⌷⍉sdb
	cpu	←pacc'update host(lv[:lz],rv[:rz])'
	gpu	←simd'present(rv[:rz],lv[:lz],zv[:zz])'
	exe	←(3=⊃⍺)⊃''(gpu,nl,'DO(i,zz){zv[i]=0;}',nl)
	exe	,←scl⊃cpu gpu
	exe	,←'DO(i,lc){DO(j,rc){',nl
	exennn	←⍺((⊃⍺⍺)scmx ⍵⍵)'zv[(i*rc)+j]' 'rv[j]' 'lv[i]'
	exennb	←'U8 tmp=1&(lv[i/8]>>(i%8));',⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i*rc+j]' 'rv[j]' 'tmp'
	exenbn	←'U8 tmp=1&(rv[j/8]>>(j%8));',⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i*rc+j]' 'tmp' 'lv[i]'
	exenbb	←'U8 t1=1&(rv[j/8]>>(j%8));U8 t2=1&(lv[i/8]>>(i%8));',nl
	exenbb	,←⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i*rc+j]' 't1' 't2'
	exebnn	←'U8 tmp=0;',⍺((⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j]' 'lv[i]'
	exebnn	,←'B x=i*rc+j;zv[x/8]|=tmp<<(x%8);',nl
	exebnb	←'U8 tmp=0;U8 lt=1&(lv[i/8]>>(i%8));',nl
	exebnb	,←⍺((⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j]' 'lt'
	exebnb	,←'B x=i*rc+j;zv[x/8]|=tmp<<(x%8);',nl
	exebbn	←'U8 tmp=0;U8 rt=1&(rv[j/8]>>(j%8));',nl
	exebbn	,←⍺((⊃⍺⍺)scmx ⍵⍵)'tmp' 'rt' 'lv[i]'
	exebbn	,←'B x=i*rc+j;zv[x/8]|=tmp<<(x%8);',nl
	exebbb	←'U8 tmp=0;U8 rt=1&(rv[j/8]>>(j%8));U8 lt=1&(lv[i/8]>>(i%8));',nl
	exebbb	,←⍺((⊃⍺⍺)scmx ⍵⍵)'tmp' 'rt' 'lt'
	exebbb	,←'B x=i*rc+j;zv[x/8]|=tmp<<(x%8);',nl
	exe	,←(2⊥3=3↑⍺)⊃exennn exennb exenbn exenbb exebnn exebnb exebbn exebbb
	exe	,←'}}',nl
	exe	,←scl⊃(pacc'update device(zv[:zz])')''
		'' siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Inner Product
inpd←{	hid	←(idf←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖')∊⍨⊃0⊃⍺⍺ ⋄ isa←'+×⌈⌊∧∨'∊⍨⊃0⊃⍺⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 '-7'
	typ	←2⌷(4 5⊥2↑1↓⍺)⌷⍉2⊃⍺⍺
	chk	←'if(rr!=0&&lr!=0){',nl
	chk	,←'if(ls[lr-1]!=rs[0])dwaerr(5);',nl
	chk	,←(hid⊃('if(rs[0]==0)dwaerr(11);',nl)''),'}'
	siz	←'zr=0;if(lr>0){zr=lr-1;DO(i,zr)zs[i]=ls[i];}',nl
	siz	,←'if(rr>0){I n=rr-1;DOI(i,n){zs[i+zr]=rs[i+1];}zr+=rr-1;}'
	exe	←'I n=lr==0?0:lr-1;DOI(i,n)zc*=ls[i];n=rr==0?0:rr-1;DO(i,n)rc*=rs[i+1];',nl
	exe	,←'if(lr!=0)lc=ls[lr-1];else if(rr!=0)lc=rs[0];',nl
	exe	,←'B lz,rz;lz=lr==0?1:zc*lc;rz=rr==0?1:rc*lc;B m=zc*rc;',nl
	exe	,←'if(!lc){',nl
	exe	,←hid⊃''(simd'present(zv[:m])')
	exe	,←nl,⍨hid⊃'dwaerr(11);'('DO(i,m){zv[i]=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';}')
	exe	,←'}else if(',(⍕isa),'&&lr==0){',nl
	exe	,←' if(rc==1){',nl
	exe	,←'  ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←'  DO(i,lc){',(⊃git typ),'tmp;',nl
	exe	,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[i]' 'lv[0]'),nl
	exe	,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
	exe	,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
	exe	,←' }else{',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←(pacc'loop independent'),'  DO(i,rc){',nl
	exe	,←'   ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'loop'),'   DO(j,lc){',(⊃git typ),'tmp;',nl
	exe	,←'    ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j*rc+i]' 'lv[0]'),nl
	exe	,←'    ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
	exe	,←'   zv[i]=res;}}',nl
	exe	,←'}}else if(',(⍕isa),'&&rr==0){',nl
	exe	,←' if(zc==1){',nl
	exe	,←'  ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←'  DO(i,lc){',(⊃git typ),'tmp;',nl
	exe	,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[0]' 'lv[i]'),nl
	exe	,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
	exe	,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
	exe	,←' }else{',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←(pacc'loop independent'),'  DO(i,zc){',nl
	exe	,←'   ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'loop'),'   DO(j,lc){',(⊃git typ),'tmp;',nl
	exe	,←'    ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[0]' 'lv[i*lc+j]'),nl
	exe	,←'    ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
	exe	,←'   zv[i]=res;}}',nl
	exe	,←'}}else if(',(⍕isa),'&&rc==1&&zc==1){',nl
	exe	,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←' DO(i,lc){',(⊃git typ),'tmp;',nl
	exe	,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[i]' 'lv[i]'),nl
	exe	,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
	exe	,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
	exe	,←'}else if(',(⍕isa),'&&zc==1){',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←(pacc'loop independent'),'DO(i,rc){',nl
	exe	,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'loop'),' DO(j,lc){',(⊃git typ),'tmp;',nl
	exe	,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j*rc+i]' 'lv[j]'),nl
	exe	,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
	exe	,←' zv[i]=res;}}',nl
	exe	,←'}else if(',(⍕isa),'&&rc==1){',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←(pacc'loop independent'),'DO(i,zc){',nl
	exe	,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'loop'),' DO(j,lc){',(⊃git typ),'tmp;',nl
	exe	,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j]' 'lv[i*lc+j]'),nl
	exe	,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
	exe	,←' zv[i]=res;}}',nl
	exe	,←'}else{',((typ=3)⊃'B m8=m;' 'B m8=(m+7)/8;'),nl
	exe	,←(pacc'kernels present(zv[:m8],lv[:lz],rv[:rz])'),'{',nl
	exe	,←((typ=3)⊃'' 'DO(i,m8){zv[i]=0;}'),nl
	exe	,←(pacc'loop independent'),'DO(i,zc){',nl
	exe	,←(pacc'loop independent'),' DO(j,rc){',(⊃git typ),'res;B n=lc-1;',nl
	exe	,←'  ',(⍺((1⊃⍺⍺)scmx ⍵⍵)'res' 'rv[((lc-1)*rc)+j]' 'lv[(i*lc)+lc-1]'),nl
	exe	,←(pacc'loop'),'  DO(k,n){',nl
	exe	,←'   ',(⊃git typ),'tmp;L ri=((lc-(k+2))*rc)+j,li=(i*lc)+lc-(k+2);',nl
	exe	,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[ri]' 'lv[li]'),nl
	exe	,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'res' 'tmp'),'}',nl
	bzv	←'B x=i*rc+j;zv[x/8]|=res<<(x%8)'
	exe	,←'  ',((typ=3)⊃'zv[(i*rc)+j]=res' bzv),';}}',nl,'}}',nl
		chk siz exe mxfn 1 ⍺ ⍵}

⍝   Mixed Verb Dispatch/Calling
fcl←{cln ⍺(⍎⊃(((0⌷⍉⍵⍵)⍳⊂⍺⍺),¯1+≢⍵)⌷⍵⍵⍪fnc ⍺⍺)⍵}
fnc←{⍵('''',⍵,'''calm')('''',⍵,'''cald')'' ''}
⍝[cf]
⍝[of]:Old Mixed Verb Helpers
calm←{	z r     ←var/⍵
        arr     ←⍺⍺,((1⌷⍺)⊃'iifb'),'n(',z,',NULL,',r,',env);',nl
        scl     ←'{A sz,sr;sz.v=NULL;ai(&sz,0,NULL,',(⍕⊃⍺),');',nl
        scl     ,←(1⊃git ⍺⊃¨⊂0 1 2 1),'clmtmp=',r,';sr.v=&clmtmp;',nl
        scl     ,←'sr.r=0;sr.f=0;sr.c=1;sr.z=sizeof(',(1⊃git ⍺⊃¨⊂0 1 2 1),');',nl
        scl     ,←(acdt'copyin(sr.v[:sr.z])'),'{',nl
        scl     ,←⍺⍺,((1⌷⍺)⊃'iifi'),'n(&sz,NULL,&sr,env);',nl,'}',nl
        scl     ,←nl,(⊃git ⍺),'*RSTCT szv=sz.v;',nl,pacc'update host(szv[:1])'
        scl     ,←z,'=*szv;frea(&sz);}',nl
                (∧/¯1=,↑1⌷⍉⍵)⊃arr scl}
cald←{        z r l   ←var/⍵
        arr     ←⍺⍺,((¯2↑⍺)⊃¨⊂'iifb'),'(',z,',',l,',',r,',env);',nl
        scl     ←'{A sz,sr,sl;sz.v=NULL;ai(&sz,0,NULL,',(⍕⊃⍺),');',nl
        scl     ,←'sr.r=0;sr.f=0;sr.c=1;sr.v=&',r,';sr.z=sizeof(',(1⊃git ⍺),');',nl
        scl     ,←'sl.r=0;sl.f=0;sl.c=1;sl.v=&',l,';sl.z=sizeof(',(2⊃git ⍺),');',nl
        scl     ,←⍺⍺,((¯2↑⍺)⊃¨⊂'iifb'),'(&sz,&sl,&sr,env);',nl
        scl     ,←(⊃git⍺),'*szv=sz.v;',nl,pacc'update host(szv[:1])'
        scl     ,←z,'=*szv;frea(&sz);}',nl
                (∧/¯1=,↑1⌷⍉⍵)⊃arr scl}
mxfn←{chk siz exe←⍺ ⋄ al tp el←⍵
  vr←(∧/¯1=↑1⌷⍉el)+0≠(⊃0⍴⊃)¨0⌷⍉el
  tpl tpv tps←(tp(/⍨)vr=⊢)¨⍳3
  nml nmv nms←(('zrl'↑⍨≢el)/⍨vr=⊢)¨⍳3
  elv ell els←1 0 2(⊢(/⍨)vr=⊣)¨(⊂(≢el)↑'rslt' 'rgt' 'lft'),2⍴⊂0⌷⍉el
  z←'{B zc=1,rc=1,lc=1;',nl
  z,←(⊃,/(⊂''),elv{'A *',⍺,'=',⍵,';'}¨var/(1=vr)⌿el),nl
  z,←⊃,/(⊂''),nml{'I ',⍺,'r=',(⍕≢⍴⍵),';B ',⍺,'s[]={',(⍕≢⍵),'};'}¨ell
  z,←⊃,/(⊂''),(git tpl),¨nml{⍺,'v[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl}¨ell
  z,←(0=≢nml)⊃(pacc')',⍨¯1↓⊃,/(⊂'enter data copyin('),nml,¨⊂'v,')''
  z,←(⊃,/(⊂''),(git tps),¨nms{'*s',⍺,'=&',⍵,';'}¨els),nl↑⍨≢els
  z,←(⊃,/(⊂''),{'I ',⍵,'r=0;B*',⍵,'s=NULL;'}¨nms),nl↑⍨≢nms
  z,←(⊃,/(⊂''),(git tps){⍺,⍵,'v[]={*s',⍵,'};'}¨nms),nl↑⍨≢nms
  iso←(⊂⊃1⌷⍉el)∨.≡n2f 1↓1⌷⍉el
  z,←iso⊃''('A*orz=rslt;A tz;tz.v=NULL;rslt=&tz;',nl)
  z,←(0≡≢elv)⊃'' 'A tp;tp.v=NULL;A*rslt=&tp;'
  tpv nmv elv,←(0≡≢elv)⊃(3⍴⊂⍬)((⊃tps)'z' 'rslt')
  z,←((1↓tpv)((1↓nmv)decl)1↓elv),'I zr;B zs[15];',nl
  z,←chk,(nl ''⊃⍨''≡chk),siz,nl
  alloc←'ai(rslt,zr,zs,',(⍕⊃0⌷tp),');',nl
  alloc,←(1↑tpv)((1↑nmv)declv)1↑elv
  z,←(al⊃'' alloc),exe,((0≡≢elv)⊃'' '*sz=zv[0];'),nl
  z,←(0=≢nml)⊃(pacc')',⍨¯1↓⊃,/(⊂'exit data delete('),nml,¨⊂'v,')''
  z,←iso⊃''('cpaa(orz,rslt);',nl)
  z,←'}',nl
    z}
decl←{        z       ←(⊃,/(⊂''),⍺⍺{'I ',⍺,'r=',⍵,'->r;'}¨⍵),nl
        z       ,←(⊃,/(⊂''),⍺⍺{'B*RSTCT ',⍺,'s=',⍵,'->s;'}¨⍵),nl
        z       ,←⍺(⍺⍺ declv) ⍵
                z}
declv   ←{(⊃,/(⊂''),(git ⍺),¨⍺⍺{'*RSTCT ',⍺,'v=(',⍵,')->v;'}¨⍵),nl}
⍝[cf]
⍝[of]:Helpers
decarr←{	r s v c z	←⍺∘,¨'rsvcz'
	x	←'I ',r,'=(',⍵,')->r;B*',s,'=(',⍵,')->s;'
	x	,←'B ',z,'=(',⍵,')->z;B ',c,'=(',⍵,')->c;'
		x,⍺⍺,'*RSTCT ',v,'=(',⍵,')->v;',nl}
decarri	←'I'decarr
decarrf	←'D'decarr
decarrb	←'U8'decarr
declit←{	r s v c z	←⍺∘,¨'rsvcz'
	d	←(8×⌈8÷⍨≢,⍵)↑,⍵
	a	←'I ',r,'=',(⍕(1≠≢,⍵)×≢⍴⍵),';B ',z,'=',(⍕≢d),'*sizeof(',⍺⍺,');',nl
	a	,←'B ',s,'[15]={',(⊃{⍺,',',⍵}/⍕¨15↑⍴⍵),'};B ',c,'=',(⍕≢,⍵),';',nl
	a	,←⍺⍺,' ',v,'[]={',(cln ⊃{⍺,',',⍵}/⍕¨(8×⌈8÷⍨≢,⍵)↑,⍵),'};',nl
		a,pacc'enter data copyin(',v,'[:',c,'])'}
decliti	←'I'declit
declitf	←'D'declit
declitb←{	r s v c z	←⍺∘,¨'rsvcz'
	d	←2⊥⍉((8,⍨8÷⍨≢)⍴⊢)(64×⌈64÷⍨≢,⍵)↑,⍵
	a	←'I ',r,'=',(⍕(1≠≢,⍵)×≢⍴⍵),';B ',z,'=',(⍕≢d),';',nl
	a	,←'B ',s,'[15]={',(⊃{⍺,',',⍵}/⍕¨15↑⍴⍵),'};B ',c,'=',(⍕≢,⍵),';',nl
	d	←2⊥⍉((8,⍨8÷⍨≢)⍴⊢)(64×⌈64÷⍨≢,⍵)↑,⍵
	a	,←'U8 ',v,'[]={',(⊃{⍺,',',⍵}/⍕¨d),'};',nl
		a,pacc'enter data copyin(',v,'[:',z,'])'}
freelit	←{pacc'exit data delete(',⍵,'v[:',⍵,⍺,'])'}
dectmp	←{'A ',a,';',a,'.v=NULL;ai(&',a,',',⍺,');',nl,⍵(⍺⍺ decarr)'&',a←⍵,'a'}
dectmpi	←'I'dectmp
dectmpf	←'D'dectmp
dectmpb	←'U8'dectmp
⍝[cf]
⍝[of]:Generators

⍝[of]:Horrible Hacks
⍝[c]Sobel Pi Hack
sopid←{	siz	←'zr=(lr-1)+rr;zs[0]=ls[0];DO(i,zr-1)zs[i+1]=rs[i];'
	exe	←'zc=zs[0];rc=rs[0];lc=ls[rr-1];',nl
	exe	,←'B szz=rslt->c,szr=rgt->c,szl=lft->c;',nl
	exe	,←simd'independent collapse(3) present(zv[:szz],rv[:szr],lv[:szl])'
	exe	,←'DO(i,zc){DO(j,rc){DO(k,lc){I li=(i*lc)+k;',nl
	exe	,←'zv[(i*rc*lc)+(j*lc)+k]=lv[li]*rv[(j*lc)+k];',nl
	exe	,←'}}}'
		'' siz exe mxfn 1 ⍺ ⍵}

⍝[c]Lamination (Hack)
catdo←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ catdr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ catdl ⍵ ⋄ ⍺ catdv ⍵}

catdv←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'A*',⍺,'=',⍵,';'}¨var/⍵),nl
	 z,←'B s[]={rgt->s[0],2};'
	 z,←'A*orz;A tp;tp.v=NULL;int tpused=0;',nl
	 z,←'if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
	 z,←'ai(rslt,2,s,',(⍕⊃0⌷⍺),');',nl
	 z,←(⊃,/(git ⍺){⍺,'*RSTCT ',⍵,';'}¨'zrl'),nl
	 z,←⊃,/'zrl'{⍺,'=',⍵,'->v;',nl}¨'rslt' 'rgt' 'lft'
	 z,←(simd'present(z,l,r)'),'DO(i,s[0]){z[i*2]=l[i];z[i*2+1]=r[i];}'
	 z,←'if(tpused){cpaa(orz,rslt);}',nl
	 z,'}',nl}
⍝[cf]
⍝[cf]

:EndNamespace
