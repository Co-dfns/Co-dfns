:Namespace SM
  nl←##.G.nl ⋄ do←##.G.do ⋄ tl←##.G.tl
  sma←'BOUND c=1;getarray(rgt->p->ELTYPE==APLLONG?'
  smb←',rgt->p->RANK,rgt->p->SHAPETC,rslt);',nl
  smb,←'rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'          
  smb,←'if(rgt->p->ELTYPE=APLLONG){aplint32*src=ARRAYSTART(rgt->p);',nl
  smc←'*dst=ARRAYSTART(rslt->p);',nl
  smd←'}else if(rgt->p->ELTYPE=APLDOUB){double*src=ARRAYSTART(rgt->p);',nl
  sclm←{(de dt)(ie it)←tl ⍺ ⋄ sma,ie,':',de,smb,it,smc,('c'do⍵),smd,dt,smc,('c'do⍵),'}',nl}
:EndNamespace
