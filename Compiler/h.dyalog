:Namespace H
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ r←A.r ⋄ s←A.s ⋄ v←A.v ⋄ y←A.y ⋄ e←A.e

  ⍝ Utilities
  var←{(,'⍺')≡⍺:,'l' ⋄ (,'⍵')≡⍺:,'r' ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
  nl←⎕UCS 13 10
  for←{'for(i=0;i<',(⍕⍵),';i++){'}
  do←{'{BOUND i;',(for ⍺),⍵,'}}',nl}
  pdo←{'{BOUND i;',nl,'#pragma parallel',nl,(for ⍺),⍵,'}}',nl}
  tl←{('di'⍳⍵)⊃¨⊂('APLDOUB' 'double')('APLLONG' 'aplint32')}
  enc←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
  fvs←,⍤0(⌿⍨)0≠(≢∘⍴¨⊣)
  cln←'¯'⎕R'-'

  ⍝ Runtime Header
  rth ←'#include <math.h>',nl,'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
  rth,←'int isinit=0;',nl
  rth,←'#define PI 3.14159265358979323846',nl

  ⍝ Environments
  dnv←{'LOCALP ',⍺,'[',(⍕⊃v⍵),'];'}
  reg←{(⊃v⍵)do'regp(&',⍺,'[i]);'}
  cutp←'cutp(&env0[0]);'

  ⍝ Functions
  frt←'void static '
  flp←'(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[])'
  elp←'(LOCALP*z,LOCALP*l,LOCALP*r)'
  foi←'if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}',nl
  fnv←{'LOCALP*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
  tps←'int tp=0;tp+=3*(r->p->ELTYPE==APLLONG?0:1);',nl
  tps,←'tp+=(l==NULL)?2:(l->p->ELTYPE==APLLONG?0:1);',nl
  tps,←'switch(tp){',nl
  tpi←'ii' 'if' 'in' 'fi' 'ff' 'fn'
  cas←{'case ',(⍕⍺),':',⍵,(⍺⊃tpi),'(z,l,r,env);break;',nl}
  calm←{z r←var/⍵ ⋄ ⍺⍺,((1⌷⍺)⊃'' 'i' 'f'),'n(',z,',NULL,',r,',env);',nl}

  ⍝ Scalar Groups
  rk0←'BOUND prk=0;BOUND sp[15];BOUND cnt=1,i=0;',nl
  rk1←'if(prk!=(' ⋄ rk2←')->p->RANK){if(prk==0){',nl
  rsp←{'prk=(',⍵,')->p->RANK;',nl,'prk'do'sp[i]=(',⍵,')->p->SHAPETC[i];'}
  rk3←'}else if((' ⋄ rk4←')->p->RANK!=0)error(4);',nl
  spt←{'if(sp[i]!=(',⍵,')->p->SHAPETC[i])error(4);'}
  rkv←{rk1,⍵,rk2,(rsp ⍵),rk3,⍵,rk4,'}else{',nl,('prk'do spt ⍵),'}',nl}
  rk5←'if(prk!=1){if(prk==0){prk=1;sp[0]='
  rka←{rk5,l,';}else error(4);}else if(sp[0]!=',(l←⍕≢⍵),')error(4);',nl}
  crk←{⍵((⊃,/)((rkv¨var/)⊣(⌿⍨)(~⊢)),(rka¨0⌷∘⍉(⌿⍨)))0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵}
  srk←{crk(⊃v⍵)(,⍤0(⌿⍨)0≠(≢∘⍴¨⊣))(⊃e⍵)}
  ste←{'if((',⍵,')->p!=p',(⍕⍺),'){relp(',⍵,');(',⍵,')->p=p',(⍕⍺),';}',nl}
  sts←{'r',(⍕⍺),'[i]=s',(⍕⍵),';',nl}
  rkp←{'BOUND m',(⍕⍺),'=(',(⍕⍵),')->p->RANK==0?1:cnt;',nl}
  git←{(¯1+⍵)⊃¨⊂'aplint32 ' 'double ' '?type? '}
  gie←{(¯1+⍵)⊃¨⊂'APLLONG' 'APLDOUB' 'APLNA'}
  gdp←{'*d',(⍕⍺),'=ARRAYSTART((',⍵,')->p);',nl}
  gda←{'d',(⍕⍺),'[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl,'BOUND m',(⍕⍺),'=cnt;',nl}
  sfa←{(git m/⍺),¨{((+/~m)+⍳≢⍵)gda¨⍵}⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
  sfp←{(git m⌿⍺),¨{(⍳≢⍵)(gdp,rkp)¨⍵}var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
  sfv←(1⌷∘⍉(⊃v)fvs(⊃y))((⊃,/)sfp,sfa)(⊃v)fvs(⊃e)
  gar←{'p',(⍕⍺),'=getarray(',⍵,',prk,sp,NULL);',nl}
  ats←{⊃,/'if(NULL==('⍵')->p||prk!=('⍵')->p->RANK',nl,'||('⍵')->p->ELTYPE!='⍺')'}
  ack←{tp←⊃gie ⍺⌷⍺⍺ ⋄ (tp ats ⍵),nl,(⍺ gar tp),'else p',(⍕⍺),'=(',⍵,')->p;',nl}
  gpp←{nl,⍨';',⍨⊃,/'POCKET',⊃{⍺,',',⍵}/'*p'∘,∘⍕¨⍳≢⍵}
  grs←{(⊃git ⍺),'*r',(⍕⍵),'=ARRAYSTART(p',(⍕⍵),');',nl}
  spp←(⊃s){(gpp⍵),(⊃,/(⍳≢⍵)(⍺ ack)¨⍵),(⊃,/⍺ grs¨⍳≢⍵)}(⊃n)var¨(⊃r)
  sip←{⍺,'f',⍵,'=d',⍵,'[i%m',⍵,'];',nl}∘⍕
  slp←{(for'cnt'),nl,⊃,/(git 1⌷⍉(⊃v⍵)fvs(⊃y⍵))sip¨⍳≢(⊃v⍵)fvs(⊃e⍵)}

:EndNamespace

