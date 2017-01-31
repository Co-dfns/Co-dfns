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
