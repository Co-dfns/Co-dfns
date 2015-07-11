:Namespace IOT
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ H←##.H ⋄ nl←H.nl ⋄ do←H.do

  ⍝ Index Generator
  mon←{z←'{',(⊃,/'rslt' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨H.var/⍵),nl
    z,←'int rk=rgt->p->RANK;',nl
    z,←'if(!(rk==0||(rk==1&&1==rgt->p->SHAPETC[0])))error(16);',nl
    z,←'aplint32*v=ARRAYSTART(rgt->p);aplint32 c=v[0];',nl
    z,←'BOUND s[]={c};relp(rslt);getarray(APLLONG,1,s,rslt);',nl
    z,←'v=ARRAYSTART(rslt->p);',nl,('c'do'v[i]=i;'),'}',nl
    z}

:EndNamespace
