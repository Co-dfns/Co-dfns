:Namespace SHP
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ nl←##.H.nl ⋄ do←##.H.do

  ⍝ Shape
  mon←{z←'{',(⊃,/'rslt' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨##.H.var/2↑⍵)
    z,←'BOUND rk=rgt->p->RANK;BOUND sp[15];',nl
    z,←'rk'do'sp[i]=rgt->p->SHAPETC[i];'
    z,←'relp(rslt);getarray(APLLONG,1,&rk,rslt);',nl
    z,←'aplint32 *b=ARRAYSTART(rslt->p);',nl,'rk'do'b[i]=sp[i];'
    z,←'}',nl
    z}

:EndNamespace
