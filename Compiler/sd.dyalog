:Namespace SD
  U←##.U ⋄ nl←U.nl ⋄ do←U.do ⋄ pdo←U.pdo ⋄ tl←U.tl ⋄ var←U.var ⋄ pp←#.pp
  A←##.A ⋄ k←A.k ⋄ n←A.n ⋄ v←A.v ⋄ e←A.e
  SR←##.SR ⋄ sdb←SR.sdb ⋄ sdn←SR.sdn
  ivh←{'{LOCALP *pat=',⍵,';BOUND types=0;',nl}
  rt1←'if(pat->p->RANK!=(' ⋄ rt2←')->p->RANK){if(pat->p->RANK==0)pat='
  spt←{'if(pat->p->SHAPETC[i]!=(',⍵,')->p->SHAPETC[i])error(4);'}
  crv←{rt1,⍵,rt2,⍵,';else error(4);}',nl,'else','pat->p->RANK'do spt ⍵}
  frv←{∪⊃,/((⌽¯1↓¯1⌽⊢)¨⍵)~∘∪¨(⍳≢⍺)↑¨⊂⍺}
  dov←{⍺←⊢ ⋄ ⍺ ⍺⍺ ((n⍵)frv v⍵)var¨((,1↑⍉)¨frv(↓1↓⍉)¨)e⍵}
  crk←{{(ivh⊃⍵),⊃,/crv¨1↓⍵}dov ⍵}
  rif←{'if((',⍵,')->p->ELTYPE==APLLONG)types|=1<<',(⍕⍺),';',nl}
  grt←{⊃,/{(⍳≢⍵)rif¨⍵}dov ⍵}
  ars←{⊃,/{'/* Allocate result for ',⍵,' */',nl}¨∪n ⍵}
  gdp←{'*d',(⍕⍺),'=ARRAYSTART((',⍵,')->p);',nl}
  git←{⍵⊃¨⊂'double ' 'aplint32 ' '?type? '}
  gip←{⊃,/⍺{(git(≢⍵)↑⍺),¨(⍳≢⍵)gdp¨⍵}dov ⍵}
  cnt←{'BOUND cnt=1;',nl,'pat->p->RANK'do'cnt*=pat->p->SHAPETC[i];'}
  rkm←{⊃,/{(⍳≢⍵){'BOUND m',(⍕⍺),'=(',(⍕⍵),')->p->RANK==0?1:cnt;',nl}¨⍵}dov ⍵}
  lai←{⍺,'s',(⍕⍵),'=d',(⍕⍵),'[i%m',(⍕⍵),'];',nl}
  lpa←{⊃,/⍺{(git(≢⍵)↑⍺)lai¨⍳≢⍵}dov ⍵}
  sva←{⍺-1+((-⍺)↑⍺⍺)⍳⌽¯1↓¯1⌽⊃v ⍵}
  cal←{f←sdn⊃⍨sdb⍳¯1↑¯1⌽⊃v⍺⍺ ⋄ 1≡≢⍵:(SR.⍎f,'m')⊃⍵ ⋄ ⊃(SR.⍎f,'d')/⍵}
  stp←{(⍺{⌽((≢⍵)⍴2)⊤⍺}dov ⍵),24⍴2}
  stm←{⊂('s',⍕⍺),'=',(⍵ cal's',∘⍕¨⍺(⍺⍺ sva)⍵),';',nl}
  lpc←{⊃,/(git(-≢⍵)↑⍺),¨(⍵{(≢⍵)+⍳≢⍺}dov ⍵)((⌽((n⍵)frv v⍵),n⍵)stm)⍤¯1⊢⍵}
  lps←{⊃,/((¯1+≢dov ⍵)+(≢n⍵)-(⌽n⍵)⍳∪n⍵){'r',(⍕⍵),'[i%cnt]=s',(⍕⍺),';',nl}¨⍳≢∪n⍵}
  bod←{(⍺ stp ⍵)(nl,⍨'}',⍨'{',nl,ars,gip,'cnt'pdo nl,lpa,lpc,lps)⍵}
  cas←{'case ',(⍕⍺),':',(⍺ bod ⍵),'break;',nl}
  dis←{'switch(types){',nl,(⊃,/(⍳⍺)cas¨⊂⍵),'}'}
  std←{(cnt ⍵),(rkm ⍵),((2*≢(n⍵)frv v ⍵)dis ⍵),'}',nl}
:EndNamespace