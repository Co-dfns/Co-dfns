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
⍝[of]:⊤	Encode
encd←{	chk	←'if(lr>1)dwaerr(16);DO(i,lr)lc*=ls[i];',nl
	chk	,←pacc'update host(lv[:lc])'
	chk	,←'DO(i,lc){if(lv[i]<=0)dwaerr(16);}'
	siz	←'zr=1+rr;zs[0]=lc;DO(i,rr)zs[i+1]=rs[i];DO(i,rr)rc*=rs[i];'
	exe	←simd'collapse(2) present(zv[:rslt->c],rv[:rc],lv[:lc])'
	exe	,←'DO(i,rc){DO(j,lc){zv[(j*rc)+i]=(rv[i]>>(lc-(j+1)))%2;}}'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:⊥	Decode
decd←{	chk	←'if(lr>1||lv[0]<0)dwaerr(16);'
	siz	←'zr=rr==0?0:rr-1;DOI(i,zr){zs[i]=rs[i+1];zc*=rs[i+1];}',nl
	siz	,←'if(rr>0)rc=rs[0];'
	exen	←pacc'update host(lv,rv[:rgt->c])'
	exen	,←'DO(i,zc){zv[i]=0;DO(j,rc){zv[i]=rv[(j*zc)+i]+lv[0]*zv[i];}}',nl
	exen	,←pacc'update device(zv[:rslt->c])'
	exeb	←'I rcp=(rgt->c+7)/8;',nl
	exeb	,←pacc'update host(lv,rv[:rcp])'
	exeb	,←'DO(i,zc){zv[i]=0;DO(j,rc){I ri=(j*zc)+i;',nl
	exeb	,←'zv[i]=(1&(rv[ri/8]>>(ri%8)))+lv[0]*zv[i];}}',nl
	exeb	,←pacc'update device(zv[:rslt->c])'
	exe	←(3=⊃1⌷⍺)⊃exen exeb
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:∊	Enlist/Membership
memdfiiaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarri lft ⍵)
		z,('gucmpi'memdfnnlp'gucmpi')⍵}
memdfifaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrf lft ⍵)
		z,('gucmpf'memdfnnlp'gucmpi')⍵}
memdffiaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵)
		z,('gucmpi'memdfnnlp'gucmpf')⍵}
memdfffaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrf lft ⍵)
		z,('gucmpf'memdfnnlp'gucmpf')⍵}
memdfibaaa←{		'dwaerr(16);',nl}
memdffbaaa←{		'dwaerr(16);',nl}
memdfbbaaa←{		'dwaerr(16);',nl}
memdfbiaaa←{		'dwaerr(16);',nl}
memdfbfaaa←{		'dwaerr(16);',nl}
memdfiiaal←{		'dwaerr(16);',nl}
memdfifaal←{		'dwaerr(16);',nl}
memdffiaal←{		'dwaerr(16);',nl}
memdfffaal←{		'dwaerr(16);',nl}
memdfibaal←{		'dwaerr(16);',nl}
memdffbaal←{		'dwaerr(16);',nl}
memdfbbaal←{		'dwaerr(16);',nl}
memdfbiaal←{		'dwaerr(16);',nl}
memdfbfaal←{		'dwaerr(16);',nl}
memdfiiala←{		'dwaerr(16);',nl}
memdfifala←{		'dwaerr(16);',nl}
memdffiala←{		'dwaerr(16);',nl}
memdfffala←{		'dwaerr(16);',nl}
memdfibala←{		'dwaerr(16);',nl}
memdffbala←{		'dwaerr(16);',nl}
memdfbbala←{		'dwaerr(16);',nl}
memdfbiala←{		'dwaerr(16);',nl}
memdfbfala←{		'dwaerr(16);',nl}
memdfnnlp←{	z	←'B lx=0;B rx=0;',nl,'lr,ls,3'dectmpb'z'
	z	,←'I*li=malloc(lc*sizeof(I));if(!li)dwaerr(1);',nl
	z	,←'I*ri=malloc(rc*sizeof(I));if(!ri)dwaerr(1);',nl
	z	,←'DO(i,rc)ri[i]=i;DO(i,lc)li[i]=i;DO(i,zz)zv[i]=0;',nl
	z	,←acup'host(rv[:rc],lv[:lc])'
	z	,←'grdv=lv;grdc=1;qsort(li,lc,sizeof(I),',⍺⍺,');',nl
	z	,←'grdv=rv;grdc=1;qsort(ri,rc,sizeof(I),',⍵⍵,');',nl
	z	,←'while(rx<rc&&lx<lc){if(lv[li[lx]]<rv[ri[rx]])lx++;',nl
	z	,←' else if(lv[li[lx]]==rv[ri[rx]]){zv[li[lx]/8]|=1<<li[lx]%8;lx++;}',nl
	z	,←' else rx++;}',nl,acup'device(zv[:zz])'
		z,'free(li);free(ri);cpaa(',(rslt ⍵),',&za);}',nl}
memd←{		('df'gcl fdb)((0⌷⍉⍵),⊂,'∊')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:⍒	Grade Down
gddmfinaaa←{	z	←'{',('r'decarri rgt ⍵),'if(rr<1)dwaerr(4);',nl
	z	,←('1,rs,1'dectmpi'z'),acup'host(rv[:rc])'
	z	,←'grdc=1;DOI(i,rr-1){grdc*=rs[i+1];}',nl
	z	,←'grdv=rv;DO(i,zc){zv[i]=i;}',nl
	z	,←'qsort(zv,zc,sizeof(I),gdcmpi);',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
gddmffnaaa←{	z	←'{',('r'decarrf rgt ⍵),'if(rr<1)dwaerr(4);',nl
	z	,←('1,rs,1'dectmpi'z'),acup'host(rv[:rc])'
	z	,←'grdc=1;DOI(i,rr-1){grdc*=rs[i+1];}',nl
	z	,←'grdv=rv;DO(i,zc){zv[i]=i;}',nl
	z	,←'qsort(zv,zc,sizeof(I),gdcmpf);',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
gddmfbnaaa←{		'dwaerr(16);',nl}
⍝[cf]
⍝[of]:⍋	Grade Up
gdumfinaaa←{	z	←'{',('r'decarri rgt ⍵),'if(rr<1)dwaerr(4);',nl
	z	,←('1,rs,1'dectmpi'z'),acup'host(rv[:rc])'
	z	,←'grdc=1;DOI(i,rr-1){grdc*=rs[i+1];}',nl
	z	,←'grdv=rv;DO(i,zc){zv[i]=i;}',nl
	z	,←'qsort(zv,zc,sizeof(I),gucmpi);',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
gdumffnaaa←{	z	←'{',('r'decarrf rgt ⍵),'if(rr<1)dwaerr(4);',nl
	z	,←('1,rs,1'dectmpi'z'),acup'host(rv[:rc])'
	z	,←'grdc=1;DOI(i,rr-1){grdc*=rs[i+1];}',nl
	z	,←'grdv=rv;DO(i,zc){zv[i]=i;}',nl
	z	,←'qsort(zv,zc,sizeof(I),gucmpf);',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
gdumfbnaaa←{		'dwaerr(16);',nl}
⍝[cf]
⍝[of]:/	Replicate/Filter
fltd←{	chk	←'if(lr>1)dwaerr(4);',nl
	chk	,←'if(lr!=0&&ls[0]!=1&&rr!=0&&rs[rr-1]!=1&&ls[0]!=rs[rr-1])dwaerr(5);'
	siz	←'zr=rr==0?1:rr;I n=zr-1;DOI(i,n)zs[i]=rs[i];',nl
	siz	,←'if(lr==1)lc=ls[0];if(rr!=0)rc=rs[rr-1];zs[zr-1]=0;B last=0;',nl
	szn	←siz,pacc 'update host(lv[:lc],rv[:rgt->c])'
	szn	,←'if(lc>=rc){DO(i,lc)last+=abs(lv[i]);}else{last+=rc*abs(lv[0]);}',nl
	szn	,←'zs[zr-1]=last;DO(i,n)zc*=zs[i];'
	szb	←siz,pacc 'update host(lv[:lft->z],rv[:rgt->c])'
	szb	,←'if(lc>=rc){B n=(lc+7)/8;',nl
	szb	,←' DO(i,n){DO(j,8){if(lc>i*8+j)last+=1&(lv[i]>>j);}}',nl
	szb	,←'}else{last+=rc*(lv[0]>>7);}',nl
	szb	,←'zs[zr-1]=last;DO(i,n)zc*=zs[i];'
	exe	←'B a=0;if(rc==lc){',nl,'DO(i,lc){',nl
	exe	,←' if(lv[i]==0)continue;',nl
	exe	,←' else if(lv[i]>0){',nl
	exe	,←'  DO(j,zc){DO(k,lv[i]){zv[(j*zs[zr-1])+a+k]=rv[(j*rc)+i];}}',nl
	exe	,←'  a+=lv[i];',nl
	exe	,←' }else{',nl
	exe	,←'  DO(j,zc){L n=abs(lv[i]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}',nl
	exe	,←'  a+=abs(lv[i]);}}}',nl
	exe	,←'else if(rc>lc){',nl
	exe	,←' if(lv[0]>0){'
	exe	,←'DO(i,zc){DO(j,rc){DO(k,lv[0]){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}}',nl
	exe	,←' else if(lv[0]<0){L n=zc*zs[zr-1];DO(i,n)zv[i]=0;}}',nl
	exe	,←'else{DO(i,lc){',nl
	exe	,←' if(lv[i]==0)continue;',nl
	exe	,←' else if(lv[i]>0){',nl
	exe	,←'  DO(j,zc){DO(k,lv[i]){zv[(j*zs[zr-1])+a+k]=rv[j*rc];}}',nl
	exe	,←'  a+=lv[i];',nl
	exe	,←' }else{',nl
	exe	,←'  DO(j,zc){L n=abs(lv[i]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}',nl
	exe	,←'  a+=abs(lv[i]);}}}',nl
	exe	,←pacc 'update device(zv[:rslt->c])'
	exb	←'B a=0;if(rr==1&&rc==lc){B n=(lc+7)/8;',nl
	exb	,←' DO(i,n){DO(j,8){if(1&(lv[i]>>j))zv[a++]=rv[i*8+j];}}',nl
	exb	,←'}else if(rc==lc){B n=(lc+7)/8;',nl,'DO(i,n){DO(m,8){',nl
	exb	,←' if(1&(lv[i]>>m)){',nl
	exb	,←'  DO(j,zc){zv[(j*zs[zr-1])+a]=rv[(j*rc)+i*8+m];}',nl
	exb	,←'  a++;}}}',nl
	exb	,←'}else if(rc>lc){if(lv[0]>>7){',nl
	exb	,←'  DO(i,zc){DO(j,rc){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}',nl
	exb	,←'}else{B n=(lc+7)/8;DO(i,n){DO(m,8){',nl
	exb	,←' if(1&(lv[i]>>m)){',nl
	exb	,←'  DO(j,zc){zv[(j*zs[zr-1])+a]=rv[j*rc];}',nl
	exb	,←'  a++;}}}}',nl
	exb	,←pacc 'update device(zv[:rslt->c])'
		((3≡2⊃⍺)⊃(chk szn exe)(chk szb exb)) mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:⊖	Reverse/Rotate First
rtfmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
rtfmfbnsss	←rtfmffnsss←rtfmfinsss
rtfmfinaaa	←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'I'rtfmne⊃vs ⋄ ⊃'1I'rtfmnn/vs}
rtfmffnaaa	←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'D'rtfmne⊃vs ⋄ ⊃'2D'rtfmnn/vs}
rtfmne←{	z	←'{B cr=1,cc=1;',('r'(⍺ decarr)⍵)
	z	,←'if(rr){cr=rs[0];DOI(i,rr-1)cc*=rs[i+1];};B n=cr/2;',nl
	z	,←simd'collapse(2) independent present(rv[:rc])'
	z	,←'DO(i,n){DO(j,cc){B zvi=i*cc+j,rvi=(cr-(i+1))*cc+j;',nl
		z,⍺,' t=rv[zvi];rv[zvi]=rv[rvi];rv[rvi]=t;}}}',nl}
rtfmnn←{	tp td	←⍺⍺
	z	←'{B cr=1,cc=1;',('r'(td decarr)⍵),('rr,rs,',tp)(td dectmp)'z'
	z	,←'if(rr){cr=rs[0];DOI(i,rr-1)cc*=rs[i+1];};B n=cr/2;',nl
	z	,←simd'independent collapse(2) present(zv[:zc],rv[:rc])'
	z	,←'DO(i,cr){DO(j,cc){zv[i*cc+j]=rv[(cr-(i+1))*cc+j];}}',nl
		z,'cpaa(',⍺,',&za);}',nl}
rtfmfbnaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'{B cr=1,cc=1;',('r'decarrb rgt),'rr,rs,3'dectmpb'z'
	z	,←'if(rr){cr=rs[0];DOI(i,rr-1)cc*=rs[i+1];};',nl
	z	,←'B zBc=(zc+63)/64;B*RSTCT zBv=(B*)zv;B*RSTCT rBv=(B*)rv;',nl
	z	,←simd'independent present(rBv[:zBc],zBv[:zBc])'
	z	,←'DO(i64,zBc){zBv[i64]=0;',nl
	z	,←' for(I bi=0;bi<64;){B ci=i64*64+bi;B j=ci%cc;if(ci>=zc)break;',nl
	z	,←'  B ti=(cr-(ci/cc+1))*cc+j;B t,ti64=ti/64;B sz=64-bi;B tim=ti%64;',nl
	z	,←'  if(sz>(t=64-tim))sz=t;if(sz>(t=cc-j))sz=t;',nl
	z	,←'  B msk=UINT64_MAX>>(64-sz);msk<<=tim;',nl
	z	,←'  if(bi>tim)zBv[i64]|=(rBv[ti64]&msk)<<(bi-tim);',nl
	z	,←'  else zBv[i64]|=(rBv[ti64]&msk)>>(tim-bi);',nl
	z	,←'  bi+=sz;}}',nl
		z,'cpaa(',rslt,',&za);}',nl}
rtfdfiiaaa	←{v e y←⍵ ⋄ '1I'rtfdfxiaaa var/3↑v,⍪e}
rtfdffiaaa	←{v e y←⍵ ⋄ '2D'rtfdfxiaaa var/3↑v,⍪e}
rtfdfiiaal	←{v e y←⍵ ⋄ '1I'rtfdfxiaal(var/2↑v,⍪e),2⌷v}
rtfdffiaal	←{v e y←⍵ ⋄ '2D'rtfdfxiaal(var/2↑v,⍪e),2⌷v}
rtfdfxiaaa←{	d t	←⍺
	a r l	←⍵
	z	←'{',('r'(t decarr)r),'l'decarri l
	z	,←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(11);',nl,('rr,rs,',d)(t dectmp)'z'
		z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,t rtfdfxilp a}
rtfdfxiaal←{	d t	←⍺
	a r l	←⍵
	lr	←≢⍴l
	derr	←(lr≠0)∧(lr≠1)∨(⊃⍴l)≠1
	derr:	⎕SIGNAL 11
	z	←'{',('r'(t decarr)r),('rr,rs,',d)(t dectmp)'z'
		z,'I lv0=',(cln⍕l),';',nl,t rtfdfxilp a}
rtfdfshft←{	z	←'B ic=1;if(rr)ic=rs[0];I n=0;if(rr)n=rr-1;',nl
	z	,←'B jc=1;DOI(i,n)jc*=rs[i+1];B s=abs(lv0);if(ic)s%=ic;else s=0;',nl
		z,'if(lv0<0)s=(ic-s)*jc;else s*=jc;B zc_s=zc-s;',nl}
rtfdfxilp←{	z	←(rtfdfshft⍬),⍺,'*RSTCT rv2=rv+s;',⍺,'*RSTCT zv2=zv+zc_s;',nl
	z	,←(acdt'present(zv[:zc],rv[:zc],zv2[:s],rv2[:zc_s])'),'{',nl
	z	,←(simd'async(1) vector(256)'),'DO(i,zc_s){zv[i]=rv2[i];}',nl
	z	,←(simd'async(2) vector(256)'),'DO(i,s){zv2[i]=rv[i];}',nl
	z	,←pacc'wait'
		z,'}',nl,'cpaa(',⍵,',&za);}',nl}
rtfdfbiaaa←{	v e y	←⍵
	a r l	←var/3↑v,⍪e
	z	←'{',('l'decarri l),'r'decarrb r
	z	,←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(11);',nl,'rr,rs,3'dectmpb'z'
		z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,rtfdfbilp a}
rtfdfbiaal←{	v e y	←⍵
	a r	←var/2↑v,⍪e
	l	←2⊃v
	lr	←≢⍴l
	derr	←(lr≠0)∧(lr≠1)∨(⊃⍴l)≠1
	derr:	⎕SIGNAL 11
		'{',('r'decarrb r),('rr,rs,3'dectmpb'z'),'I lv0=',(cln⍕l),';',nl,rtfdfbilp a}
rtfdfbilp←{	z	←(rtfdfshft⍬),'B ec=(zc+63)/64;',nl
	z	,←'B*RSTCT zvB=(B*)zv;B*RSTCT rvB=(B*)rv;',nl
	z	,←(acdt'present(zvB[:ec],rvB[:ec])'),'{',nl
	z	,←'if(zc){if(zc<=64){',nl,simd''
	z	,←' DOI(i,1){B t=rvB[0]&((1<<zc)-1);zvB[0]=(t<<(zc-s))|(t>>s);}',nl
	z	,←'}else{I ar=s%64;I al=64-ar;B ac=(zc_s+(ar-zc%64))/64;B ao=s/64;',nl
	z	,←' I bl=zc_s%64;I br=64-bl;B bc=(s+bl)/64;B bo=zc_s/64;',nl
	z	,←' if(ar&&bl){B m=UINT64_MAX>>br;',nl
	z	,←'  if(bl>al){',nl,simd''
	z	,←'   DO(i,ec){if(i<bo){zvB[i]=(rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al);}',nl
	z	,←'    else if(i==bo){B t=m&((rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al));',nl
	z	,←'     zvB[i]=t|(rvB[0]<<bl);}',nl
	z	,←'    else{zvB[i]=(rvB[i-(bo+1)]>>br)|(rvB[i-bo]<<bl);}}',nl
	z	,←'  }else{',nl,simd''
	z	,←'   DO(i,ec){if(i<bo){zvB[i]=(rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al);}',nl
	z	,←'    else if(i==bo){zvB[i]=(m&(rvB[i+ao]>>ar))|(rvB[0]<<bl);}',nl
	z	,←'    else{zvB[i]=(rvB[i-(bo+1)]>>br)|(rvB[i-bo]<<bl);}}}',nl	
	z	,←' }else if(ar){',nl,simd''
	z	,←'  DO(i,ec){if(i<bo){zvB[i]=(rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al);}',nl
	z	,←'   else{zvB[i]=rvB[i-bo];}}',nl
	z	,←' }else if(bl){B m=UINT64_MAX>>br;',nl,simd''
	z	,←'  DO(i,ec){if(i<bo){zvB[i]=rvB[i+ao];}',nl
	z	,←'   else if(i==bo){zvB[i]=(rvB[i+ao]&m)|(rvB[0]<<bl);}',nl
	z	,←'   else{zvB[i]=(rvB[i-(bo+1)]>>br)|(rvB[i-bo]<<bl);}}',nl
	z	,←' }else{',nl,simd''
	z	,←'  DO(i,ec){if(i<bo){zvB[i]=rvB[i+ao];}else{zvB[i]=rvB[i-bo];}}}}',nl
		z,'}}',nl,'cpaa(',⍵,',&za);}',nl}
rtfdfbbaaa	←{'dwaerr(16);',nl}
rtfdfbbaal	←{'dwaerr(16);',nl}
rtfdfibaaa	←{'dwaerr(16);',nl}
rtfdfibaal	←{'dwaerr(16);',nl}
rtfdffbaaa	←{'dwaerr(16);',nl}
rtfdffbaal	←{'dwaerr(16);',nl}
rtfd	←{('df'gcl fdb)((0⌷⍉⍵),⊂,'⊖')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:⍉	Transpose
trnmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
trnmfbnsss	←trnmffnsss←trnmfinsss
trnmfinaaa	←{'I1'trnmfn ⍵}
trnmffnaaa	←{'D2'trnmfn ⍵}
trnmfh←{	z	←'{I rk=(',⍵,')->r;B sp[15];DO(i,rk)sp[i]=(',⍵,')->s[rk-(1+i)];',nl
	z	,←'if(rk<=1){',nl
	z	,←(≡/2↑⍺⍺)⊃('memcpy(',⍺,',',⍵,',sizeof(A));(',⍵,')->f=0;',nl)''
		z,'}else if(rk==2){',nl}
trnmfn←{	v e y	←⍵
	tp tc	←⍺
	rslt rgt	←var/2↑v,⍪e
	z	←rslt(e trnmfh)rgt
	a	←'A ta;ta.v=NULL;ai(&ta,rk,sp,',tc,');',tp,'*RSTCT zv=ta.v;',nl
	z	,←a⊣a,←tp,'*RSTCT rv=(',rgt,')->v;B cnt=(',rgt,')->c;',nl
	z	,←simd'independent present(zv[:cnt],rv[:cnt])'
	z	,←'DO(i,sp[0]){DO(j,sp[1]){zv[(i*sp[1])+j]=rv[(j*sp[0])+i];}}',nl
	z	,←'cpaa(',rslt,',&ta);',nl
	z	,←'}else{',nl
	z	,←a,'B*rs=(',rgt,')->s;',nl
	z	,←simd'independent present(zv[:cnt],rv[:cnt]) copyin(rs[:rk])'
	z	,←'DO(i,cnt){B ri=0,zi=i;',nl
	z	,←' DO(j,rk){B k=zi%rs[j];ri*=rs[j];ri+=k;zi-=k;zi/=rs[j];}',nl
	z	,←' zv[i]=rv[ri];}',nl
	z	,←'cpaa(',rslt,',&ta);',nl
		z,'}}',nl}
trnmfbnaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←rslt(e trnmfh)rgt
	a	←' A ta;ta.v=NULL;ai(&ta,rk,sp,3);U8*RSTCT zv=ta.v;',nl
	z	,←a⊣a,←' U8*RSTCT rv=(',rgt,')->v;B cnt=((',rgt,')->c+7)/8;',nl
	z	,←simd'independent present(zv[:cnt],rv[:cnt])'
	z	,←' DO(i,cnt){zv[i]=0;',nl
	z	,←'  DOI(j,8){B zi=i*8+j;B zr=zi/sp[1],zc=zi%sp[1];',nl
	z	,←'   B ri=zc*sp[0]+zr;zv[i]|=(1&(rv[ri/8]>>(ri%8)))<<j;}}',nl
	z	,←' cpaa(',rslt,',&ta);',nl
	z	,←'}else{B*rs=(',rgt,')->s;',nl,a
	z	,←simd'independent present(zv[:cnt],rv[:cnt]) copyin(rs[:rk])'
	z	,←' DO(i,cnt){zv[i]=0;DO(j,8){B i8=i*8+j;B ri=0,zi=i8;',nl
	z	,←'   DO(j,rk){B k=zi%rs[j];ri*=rs[j];ri+=k;zi-=k;zi/=rs[j];}',nl
	z	,←'   zv[i]|=(1&(rv[ri/8]>>(ri%8)))<<j;}}',nl
	z	,←' cpaa(',rslt,',&ta);',nl
		z,'}}',nl}
⍝[cf]
⍝[of]:?	Roll/Deal
rolmfinaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'{B c=(',rgt,')->c;',nl
	z	,←'I*RSTCT rv=(',rgt,')->v;',nl,acup'host(rv[:c])'
	z	,←'DO(i,c){if(rv[i]<0)dwaerr(11);}',nl
	z	,←'A t;t.v=NULL;',nl
	z	,←'ai(&t,(',rgt,')->r,(',rgt,')->s,2);D*RSTCT zv=t.v;',nl
	z	,←'DO(i,c){if(rv[i])zv[i]=arc4random_uniform(rv[i]);',nl
	z	,←'  else zv[i]=(D)arc4random_uniform(UINT_MAX)/UINT_MAX;}',nl
		z,(acup'device(zv[:c])'),'cpaa(',rslt,',&t);}',nl}
rolmfbnaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'{B c=((',rgt,')->c+7)/8;',nl
	z	,←'U8*RSTCT rv=(',rgt,')->v;',nl,acup'host(rv[:c])'
	z	,←'A t;t.v=NULL;',nl
	z	,←'ai(&t,(',rgt,')->r,(',rgt,')->s,2);D*RSTCT zv=t.v;',nl
	z	,←'DO(i,c){DO(j,8){B x=i*8+j;U8 t=1&(rv[i]>>j);',nl
	z	,←' if(t)zv[x]=0;',nl
	z	,←' else zv[x]=(D)arc4random_uniform(UINT_MAX)/UINT_MAX;}}',nl
		z,'B zc=t.c;',nl,(acup'device(zv[:zc])'),'cpaa(',rslt,',&t);}',nl}
roldfiiaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarri lft ⍵),roldfnnlp ⍵}
roldfifaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrf lft ⍵),roldfnnlp ⍵}
roldfibaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrb lft ⍵),roldfnblp ⍵}
roldffiaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵),roldfnnlp ⍵}
roldfffaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrf lft ⍵),roldfnnlp ⍵}
roldffbaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrb lft ⍵),roldfnblp ⍵}
roldfbbaaa←{	z	←'{',('r'decarrb rgt ⍵),('l'decarrb lft ⍵),roldfbblp ⍵}
roldfbiaaa←{	z	←'{',('r'decarrb rgt ⍵),('l'decarri lft ⍵),roldfbnlp ⍵}
roldfbfaaa←{	z	←'{',('r'decarrb rgt ⍵),('l'decarrf lft ⍵),roldfbnlp ⍵}
roldfiiaal←{	z	←'{',('r'decarri rgt ⍵),('l'decliti lft ⍵),roldfnnlp ⍵}
roldfifaal←{	z	←'{',('r'decarri rgt ⍵),('l'declitf lft ⍵),roldfnnlp ⍵}
roldfibaal←{	z	←'{',('r'decarri rgt ⍵),('l'declitb lft ⍵),roldfnblp ⍵}
roldffiaal←{	z	←'{',('r'decarrf rgt ⍵),('l'decliti lft ⍵),roldfnnlp ⍵}
roldfffaal←{	z	←'{',('r'decarrf rgt ⍵),('l'declitf lft ⍵),roldfnnlp ⍵}
roldffbaal←{	z	←'{',('r'decarrf rgt ⍵),('l'declitb lft ⍵),roldfnblp ⍵}
roldfbbaal←{	z	←'{',('r'decarrb rgt ⍵),('l'declitb lft ⍵),roldfbblp ⍵}
roldfbiaal←{	z	←'{',('r'decarrb rgt ⍵),('l'decliti lft ⍵),roldfbnlp ⍵}
roldfbfaal←{	z	←'{',('r'decarrb rgt ⍵),('l'declitf lft ⍵),roldfbnlp ⍵}
roldfiiala←{	z	←'{',('r'decliti rgt ⍵),('l'decarri lft ⍵),roldfnnlp ⍵}
roldfifala←{	z	←'{',('r'decliti rgt ⍵),('l'decarrf lft ⍵),roldfnnlp ⍵}
roldfibala←{	z	←'{',('r'decliti rgt ⍵),('l'decarrb lft ⍵),roldfnblp ⍵}
roldffiala←{	z	←'{',('r'declitf rgt ⍵),('l'decarri lft ⍵),roldfnnlp ⍵}
roldfffala←{	z	←'{',('r'declitf rgt ⍵),('l'decarrf lft ⍵),roldfnnlp ⍵}
roldffbala←{	z	←'{',('r'declitf rgt ⍵),('l'decarrb lft ⍵),roldfnblp ⍵}
roldfbbala←{	z	←'{',('r'declitb rgt ⍵),('l'decarrb lft ⍵),roldfbblp ⍵}
roldfbiala←{	z	←'{',('r'declitb rgt ⍵),('l'decarri lft ⍵),roldfbnlp ⍵}
roldfbfala←{	z	←'{',('r'declitb rgt ⍵),('l'decarrf lft ⍵),roldfbnlp ⍵}
roldfnnlp←{	z	←'if(rc!=1||lc!=1)dwaerr(5);',nl,acup'host(rv[:rc],lv[:lc])'
	z	,←'if(*lv>*rv||*lv!=floor(*lv)||*rv!=floor(*rv)||*lv<0||*rv<0)dwaerr(11);',nl
	z	,←'B s=*lv;B t=*rv;','1,&s,1'dectmpi'z'
	z	,←'if(s){I*d=malloc(t*sizeof(I));if(!d)dwaerr(1);',nl
	z	,←'DO(i,t){B j=arc4random_uniform(i+1);if(i!=j)d[i]=d[j];d[j]=i;}',nl
	z	,←'DO(i,s){zv[i]=d[i];};free(d);}',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
roldfbnlp←{	z	←'if(rc!=1||lc!=1)dwaerr(5);',nl,acup'host(rv[:rc],lv[:lc])'
	z	,←'B s=*lv;s=1&s;if(s>*rv||*rv!=floor(*rv)||*rv<0)dwaerr(11);',nl
	z	,←'B t=*rv;','1,&s,1'dectmpi'z'
	z	,←'if(s){zv[0]=arc4random_uniform(t);}',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
roldfnblp←{	z	←'if(rc!=1||lc!=1)dwaerr(5);',nl,acup'host(rv[:rc],lv[:lc])'
	z	,←'B t=*rv;t=1&t;if(*lv>t||*lv!=floor(*lv)||*lv<0)dwaerr(11);',nl
	z	,←'B s=*lv;','1,&s,1'dectmpi'z'
	z	,←'if(s){zv[0]=0;}',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
roldfbblp←{	z	←'if(rc!=1||lc!=1)dwaerr(5);',nl,acup'host(rv[:rc],lv[:lc])'
	z	,←'B s=1&*lv;B t=1&*rv;if(s>t)dwaerr(11);',nl
	z	,←'1,&s,1'dectmpi'z'
	z	,←'if(s){zv[0]=0;}',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
rold←{		('df'gcl fdb)((0⌷⍉⍵),⊂,'?')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:∪	Unique/Union
unqmfinaaa←{	z	←'{',('r'decarri rgt ⍵),'if(rr>1)dwaerr(4);',nl
		z,('1,&uc,1'dectmpi'z')('gucmpi'unqmfnlp)⍵}
unqmffnaaa←{	z	←'{',('r'decarrf rgt ⍵),'if(rr>1)dwaerr(4);',nl
		z,('1,&uc,2'dectmpf'z')('gucmpf'unqmfnlp)⍵}
unqmfbnaaa←{	z	←'{',('r'decarrb rgt ⍵),'if(rr>1)dwaerr(4);',nl
	z	,←'B rc8=(rc+7)/8;B uc=2;','1,&uc,3'dectmpb'z'
	z	,←acup'host(rv[:rz])'
	z	,←'if(!rc){zs[0]=0;}',nl
	z	,←'else if(rc==1){zv[0]=rv[0];zs[0]=1;}',nl
	z	,←'else{',nl
	z	,←'DO(i,rc8){U8 m=(i==rc8-1&&rc%8)?~(255<<(rc%8)):255;U8 v=m&rv[i];',nl
	z	,←' if((i==rc8-1)&&!v){zv[0]=0;zs[0]=1;break;}',nl
	z	,←' if((i==rc8-1)&&(v==m)){zv[0]=1;zs[0]=1;break;}',nl
	z	,←' if((rv[i]%2)&&(v<m)){zv[0]=1;zs[0]=2;break;}',nl
	z	,←' if((!(rv[i]%2))&&v){zv[0]=2;zs[0]=2;break;}}',nl
	z	,←'}',nl,acup'device(zv[:1])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
unqmfnlp←{	z	←'if(rc){I*v=malloc(rc*sizeof(I));if(!v)dwaerr(1);',nl
	z	,←'U8*f=malloc(rc*sizeof(U8));if(!f)dwaerr(1);',nl
	z	,←(acup'host(rv[:rc])'),'B uc=1;grdv=rv;grdc=1;',nl
	z	,←'DO(i,rc){v[i]=i;f[i]=0;};qsort(v,rc,sizeof(I),',⍺⍺,');',nl
	z	,←'f[v[0]]=1;DO(i,rc-1){if(rv[v[i]]!=rv[v[i+1]]){f[v[i+1]]=1;uc++;}}',nl
	z	,←⍺,'uc=0;DO(i,rc){if(f[i])zv[uc++]=rv[i];}',nl
	z	,←(acup'device(zv[:zc])'),'free(v);free(f);',nl
	z	,←'cpaa(',(rslt ⍵),',&za);',nl
		z,'}else{',('1,&rc,1'dectmpi'z'),'cpaa(',(rslt ⍵),',&za);}}',nl}
unqdfiiaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarri lft ⍵)
		z,('1,&uc,1'dectmpi'z')('gucmpi'unqdfnnlp'gucmpi')⍵}
unqdfifaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrf lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpf'unqdfnnlp'gucmpi')⍵}
unqdffiaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpi'unqdfnnlp'gucmpf')⍵}
unqdfffaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrf lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpf'unqdfnnlp'gucmpf')⍵}
unqdfibaaa←{		'dwaerr(16);',nl}
unqdffbaaa←{		'dwaerr(16);',nl}
unqdfbbaaa←{		'dwaerr(16);',nl}
unqdfbiaaa←{		'dwaerr(16);',nl}
unqdfbfaaa←{		'dwaerr(16);',nl}
unqdfiiaal←{		'dwaerr(16);',nl}
unqdfifaal←{		'dwaerr(16);',nl}
unqdffiaal←{		'dwaerr(16);',nl}
unqdfffaal←{		'dwaerr(16);',nl}
unqdfibaal←{		'dwaerr(16);',nl}
unqdffbaal←{		'dwaerr(16);',nl}
unqdfbbaal←{		'dwaerr(16);',nl}
unqdfbiaal←{		'dwaerr(16);',nl}
unqdfbfaal←{		'dwaerr(16);',nl}
unqdfiiala←{		'dwaerr(16);',nl}
unqdfifala←{		'dwaerr(16);',nl}
unqdffiala←{		'dwaerr(16);',nl}
unqdfffala←{		'dwaerr(16);',nl}
unqdfibala←{		'dwaerr(16);',nl}
unqdffbala←{		'dwaerr(16);',nl}
unqdfbbala←{		'dwaerr(16);',nl}
unqdfbiala←{		'dwaerr(16);',nl}
unqdfbfala←{		'dwaerr(16);',nl}
unqdfnnlp←{	z	←'if(rr>1||lr>1)dwaerr(4);B uc=lc;B lx=0;B rx=0;',nl
	z	,←'I*li=malloc(lc*sizeof(I));if(!li)dwaerr(1);',nl
	z	,←'I*ri=malloc(rc*sizeof(I));if(!ri)dwaerr(1);',nl
	z	,←'U8*f=malloc(rc*sizeof(U8));if(!f)dwaerr(1);',nl
	z	,←'DO(i,rc){ri[i]=i;f[i]=0;};DO(i,lc){li[i]=i;};',nl
	z	,←acup'host(rv[:rc],lv[:lc])'
	z	,←'grdv=lv;grdc=1;qsort(li,lc,sizeof(I),',⍺⍺,');',nl
	z	,←'grdv=rv;grdc=1;qsort(ri,rc,sizeof(I),',⍵⍵,');',nl
	z	,←'while(rx<rc){if(lx>=lc){uc++;f[ri[rx++]]=1;}',nl
	z	,←' else if(lv[li[lx]]<rv[ri[rx]])lx++;',nl
	z	,←' else if(lv[li[lx]]==rv[ri[rx]])rx++;',nl
	z	,←' else{uc++;f[ri[rx++]]=1;}}',nl
	z	,←⍺,'DO(i,lc){zv[i]=lv[i];}',nl
	z	,←'uc=lc;DO(i,rc){if(f[i])zv[uc++]=rv[i];}',nl,acup'device(zv[:zc])'
		z,'free(li);free(ri);free(f);cpaa(',(rslt ⍵),',&za);}',nl}
unqd←{		('df'gcl fdb)((0⌷⍉⍵),⊂,'∪')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[cf]
⍝[cf]
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
