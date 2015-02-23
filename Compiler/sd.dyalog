:Namespace SD
  U←##.U ⋄ nl←U.nl ⋄ do←U.do ⋄ pdo←U.pdo ⋄ tl←U.tl ⋄ var←U.var ⋄ pp←#.pp
  A←##.A ⋄ k←A.k ⋄ n←A.n ⋄ v←A.v ⋄ e←A.e
  SR←##.SR ⋄ sdb←SR.sdb ⋄ sdn←SR.sdn ⋄ smt←SR.smt ⋄ sdt←SR.sdt
  ivh←{'LOCALP *pat=',⍵,';BOUND types=0;',nl}
  rt1←'if(pat->p->RANK!=(' ⋄ rt2←')->p->RANK){if(pat->p->RANK==0)pat='
  rt3←{';else if((',⍵,')->p->RANK!=0)error(4);}',nl}
  spt←{'if(pat->p->SHAPETC[i]!=(',⍵,')->p->SHAPETC[i])error(4);'}
  crv←{rt1,⍵,rt2,⍵,(rt3 ⍵),'else','pat->p->RANK'do spt ⍵}
  frv←{∪⊃,/((⌽¯1↓¯1⌽⊢)¨⍵)~∘∪¨(⍳≢⍺)↑¨⊂⍺}
  dov←{⍺←⊢ ⋄ ⍺ ⍺⍺ ((n⍵)frv v⍵)var¨((,1↑⍉)¨frv(↓1↓⍉)¨)e⍵}
  crk←{{(ivh⊃⍵),⊃,/crv¨1↓⍵}dov ⍵}
  grt←{⊃,/{(⍳≢⍵){'if((',⍵,')->p->ELTYPE==APLLONG)types|=1<<',(⍕⍺),';',nl}¨⍵}dov ⍵}
  gpp←{nl,⍨';',⍨⊃,/'POCKET',⊃{⍺,',',⍵}/'*p'∘,∘⍕¨⍳≢∪n ⍵}
  gsp←{'BOUND prk=pat->p->RANK;BOUND sp[15];',nl,'prk'pdo'sp[i]=pat->p->SHAPETC[i];'}
  git←{⍵⊃¨⊂'double ' 'aplint32 ' '?type? '} ⋄ gie←{⍵⊃¨⊂'APLDOUB' 'APLLONG' 'APLNA'}
  gar←{'p',(⍕⍺),'=getarray(',⍵,',prk,sp,NULL);',nl}
  ats←{'if(NULL==(',⍵,')->p||prk!=(',⍵,')->p->RANK||(',⍵,')->p->ELTYPE!=',⍺,')'}
  ack←{tp←⊃gie ⍺⌷⍺⍺ ⋄ (tp ats ⍵),(⍺ gar tp),'else p',(⍕⍺),'=(',⍵,')->p;',nl}
  ist←{⊃,/((⍳≢)⍺⍺¨⊢)(∪n⍵)var¨∪(,1↑⍉)¨e⍵}
  grs←{(⊃git ⍺),'*r',(⍕⍵),'=ARRAYSTART(p',(⍕⍵),');',nl}
  ars←{t←((≢dov⍵)+(≢⍵)-1+(⌽n⍵)⍳∪n⍵)⊃¨⊂⍺ ⋄ (t ack ist ⍵),⊃,/t grs¨⍳≢t}
  gdp←{'*d',(⍕⍺),'=ARRAYSTART((',⍵,')->p);',nl}
  gip←{⊃,/⍺{(git(≢⍵)↑⍺),¨(⍳≢⍵)gdp¨⍵}dov ⍵}
  cnt←{'BOUND cnt=1;',nl,'pat->p->RANK'do'cnt*=pat->p->SHAPETC[i];'}
  rkm←{⊃,/{(⍳≢⍵){'BOUND m',(⍕⍺),'=(',(⍕⍵),')->p->RANK==0?1:cnt;',nl}¨⍵}dov ⍵}
  lai←{⍺,'s',(⍕⍵),'=d',(⍕⍵),'[i%m',(⍕⍵),'];',nl}
  lpa←{⊃,/⍺{(git(≢⍵)↑⍺)lai¨⍳≢⍵}dov ⍵}
  sva←{⍺-1+((-⍺)↑⍺⍺)⍳⌽¯1↓¯1⌽⊃v ⍵}
  cal←{f←sdn⊃⍨sdb⍳¯1↑¯1⌽⊃v⍺⍺ ⋄ 1≡≢⍵:(SR.⍎f,'m')⊃⍵ ⋄ ⊃(SR.⍎f,'d')/⍵}
  sid←{⍵{(≢⍵)+⍳≢⍺}dov ⍵} ⋄ svn←{⌽((n⍵)frv v⍵),n⍵}
  typ←{i←sdb⍳1↑⍺ ⋄ 1≡≢a←1↓⍺:⍵,(i,(⊃a)⌷⍵)⌷smt ⋄ ⍵,(i,2⊥a⊃¨⊂⍵)⌷sdt}
  stp←{⊃typ/(⌽((¯1↑¯1⌽⊢)¨v ⍵),¨(sid ⍵)((svn ⍵)sva)¨↓⍵),⊂⍺{⌽((≢⍵)⍴2)⊤⍺}dov ⍵}
  stm←{⊂('s',⍕⍺),'=',(⍵ cal's',∘⍕¨⍺(⍺⍺ sva)⍵),';',nl}
  lpc←{⊃,/(git(-≢⍵)↑⍺),¨(sid ⍵)((svn ⍵)stm)⍤¯1⊢⍵}
  lps←{⊃,/((≢dov ⍵)+(≢n⍵)-1+(⌽n⍵)⍳∪n⍵){'r',(⍕⍵),'[i%cnt]=s',(⍕⍺),';',nl}¨⍳≢∪n⍵}
  bod←{(⍺ stp ⍵)(nl,⍨'}',⍨'{',nl,ars,gip,'cnt'pdo nl,lpa,lpc,lps)⍵}
  cas←{'case ',(⍕⍺),':',(⍺ bod ⍵),'break;',nl}
  dis←{'switch(types){',nl,(⊃,/(⍳⍺)cas¨⊂⍵),'}'}
  std←{(cnt ⍵),(rkm ⍵),((2*≢(n⍵)frv v ⍵)dis ⍵),nl}
  sto←{{'if((',⍵,')->p!=p',(⍕⍺),'){relp(',⍵,');(',⍵,')->p=p',(⍕⍺),';}',nl}ist ⍵}
:EndNamespace