:Namespace R
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ pp←#.pp ⋄ var←##.G.var ⋄ nl←##.G.nl
  scld←##.SD.scld ⋄ sclm←##.SM.sclm ⋄ do←##.G.do ⋄ tl←##.G.tl
  idx←##.MF.idx ⋄ brki←##.MF.brki ⋄ iotm←##.MF.iotm
  dff←{⍺⍺,'(',(⊃{⍺,',',⍵}/⍵),'); /* Fallback */',nl}
  subm←'di'sclm'dst[i]=-1*src[i]' ⋄ addm←'di'sclm'dst[i]=src[i]'
  mulm←'ii'sclm'if(src[i]==0)dst[i]=0;else if(src[i]<0)dst[i]=-1;else if(src[i]>0)dst[i]=1;'
  divm←'dd'sclm'if(src[i]!=0)dst[i]=1.0/src[i];else error(11);'
  powm←'dd'sclm'dst[i]=exp((double)src[i]);'
  logm←'dd'sclm'dst[i]=log((double)src[i]);'
  pitm←'dd'sclm'dst[i]=3.14159265358979323846*src[i];'
  modm←'di'sclm'dst[i]=_Generic((src[i]),double:fabs,aplint32:labs)(src[i]);'
  subd←'dddi'scld'z[i]=l[i%sl]-r[i%sr];' ⋄ addd←'dddi'scld'z[i]=l[i%sl]-r[i%sr];'
  divb←'if(r[i%sr]==0)error(11);z[i]=(1.0*l[i%sl])/(1.0*r[i%sr]);'
  divd←'dddd'scld divb ⋄ muld←'dddi'scld'z[i]=l[i%sl]*r[i%sr];'
  powd←'dddi'scld'z[i]=pow((double)l[i%sl],(double)r[i%sr]);'
  logd←'dddd'scld'z[i]=log((double)r[i%sr])/log((double)l[i%sl]);'
  modd←'dddi'scld'z[i]=fmod((double)r[i%sr],(double)l[i%sl]);'
  gted←'iiii'scld'z[i]=(l[i%sl]>=r[i%sr]);'
  fdb←3 3⍴,¨ '⌷' idx  ''   '-' subd subm '+' addd addm
  fdb⍪←3 3⍴,¨'÷' divd divm '×' muld mulm '*' powd powm
  fdb⍪←3 3⍴,¨'⍟' logd logm '○' ''   pitm '|' modd modm
  fdb⍪←3 3⍴,¨'≥' gted ''   '[' brki ''   '⍳' ''   iotm
  grh←{'{',(⊃,/⍺⍺{'LOCALP*',⍺,'=',⍵,';'}¨⍺ var¨↓⍉⍵),'relp(rslt);',nl}
  grhm←'rslt' 'rgt'grh ⋄ grhd←'rslt' 'lft' 'rgt'grh
  lkf←{'(',(((0⌷⍉⍵)⍳⊂⍺⍺)⊃(⍺⌷⍉⍵),⊂'dff'),')'}
  gd←{d←⍵⍵⍪fdb ⋄ (⍺ grhd ⍵),(((0⌷⍉d)⍳⊂⍺⍺)⊃(1⌷⍉d),⊂⍺⍺ dff ⍺),'}',nl}
  gm←{d←⍵⍵⍪fdb ⋄ (⍺ grhm ⍵),(((0⌷⍉d)⍳⊂⍺⍺)⊃(2⌷⍉d),⊂⍺⍺ dff ⍺),'}',nl}
  gf←{⍵,'(rslt,lft,rgt);',nl}
  gomd←{⍎(((0⌷⍉odb)⍳⊂⍺)⊃1⌷⍉odb),' ⍵'} ⋄ gomm←{⍎(((0⌷⍉odb)⍳⊂⍺)⊃2⌷⍉odb),' ⍵'}
  odb←2 3⍴,¨'⍨' 'comd' 'comm' '¨' 'eacd' 'eacm'
  comda←'LOCALP*or,*ol;or=rgt;ol=lft;lft=or;rgt=ol;',nl
  comd←{comda,(((0⌷⍉fdb)⍳⊂⍵)⊃1⌷⍉fdb)}
  comm←{'LOCALP*lft=rgt;',(((0⌷⍉fdb)⍳⊂⍵)⊃1⌷⍉fdb)}
  eacd←{'eacd();',nl} ⋄ eacm←{'eacm();',nl}
:EndNamespace
