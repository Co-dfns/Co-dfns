:Namespace G
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ pp←#.pp
  n←A.n ⋄ s←A.s
  FunM←A.FunM
  nl←⎕UCS 13
  hdr←'#include "dwa.h"',nl
  flp←'LOCALP *z, LOCALP *l, LOCALP *r'
  ged←{'LOCALP ',⍺,'[',(⍕≢n 1↓⍵),'];',nl}
  gel←{'LOCALP *env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
  ghi←{flp,'){',nl,'LOCALP *env[]={tenv};',nl}
  ght←{flp,'){',nl,'LOCALP *penv[]={tenv};',nl,('env0'ged ⍵),gel ⍵}
  ghn←{flp,',LOCALP *penv[]){',nl,('env0'ged ⍵),gel ⍵}
  gfh←{'void ',(⊃n ⍵),'(',(2⌊⊃s ⍵)⊃(ghi ⍵)(ght ⍵)(ghn ⍵)}
  gcf←{⍵,(gfh ⍺),'}',nl}
  gtf←⍉∘⍪0 'Fun' 0 'Init',4↓∘,1↑⊢
  gct←⊂(gtf⍪1↓⊢)gcf hdr,'tenv'ged⊢
  gc←⊃∘(gcf/∘⌽(gct⊃),1↓⊢)(1,1↓FunM)⊂[0]⊢
  
  

    gco←{com←{⊃,/(⊂''),1↓,',',⍪⍵} ⋄ z←,⊂'#include "codfns.h"'
      di←¯1 ⋄ md←{'D',⍕di⊣(⊃di)+←1} ⋄ si←¯1 ⋄ ms←{'S',⍕si⊣(⊃si)+←1}
      li←¯1 ⋄ ml←{'L',⍕li⊣(⊃li)+←1}
      ce←(tm/1⌽(1⌷⍉⍵)∊⊂'Number')/t←(tm←1=0⌷⍉⍵)⊂[0]⍵
      ntyp←{('int' 'float'⍳⊂⊃'class'Prop 1↓⍵)⊃'type_i' 'type_d' 'type_na'}
      nenm←{'apl_',ntyp ⍵} ⋄ gshp←{'uint64_t ',⍺,'[]={',((1=z)⊃(⍕z←gsz ⍵)''),'};'}
      cnv←{w←⍵ ⋄ (('¯'=w)/w)←'-' ⋄ w}
      gdat←{(ntyp ⍵),' ',⍺,'[]={',(com cnv¨'value'Prop 1↓⍵),'};'}
      gnm←{⊃'name'Prop 1↑⍵} ⋄ gsz←{+/(1⌷⍉⍵)∊⊂'Number'}
      lit←{'struct codfns_array ',(⊃⍺),'={',(com(⊂⍕1≠gsz ⍵),(⍕¨2⍴gsz ⍵),(nenm ⍵)'0',1↓⍺),',NULL};'}
      ptr←{'struct codfns_array *',(gnm ⍵),'=&',⍺,';'}
      arr←{s←ms ⍬ ⋄ d←md ⍬ ⋄ l←ml ⍬ ⋄ (s gshp ⍵)(d gdat ⍵)(l s d lit ⍵)(l ptr ⍵)}
      z,←⊃,/(⊂0⍴⊂''),arr¨ce ⋄ ve←(tm/1⌽(1⌷⍉⍵)∊⊂'Variable')/t
      frm←{⊂'struct codfns_array env0[',(⍕⍵),'];'}
      gvd←{(⍳≢⍺){'struct codfns_array *',⍵,'=&env0[',(⍕⍺),'];'}¨⍺}
      gfh←{⊂'UDF(',⍵,'){'} ⋄ z,←(≢ve)frm⍨⍣(0≠≢ve)⊢⍬
      z,←(gnm¨ve)gvd⍣(0≠≢ve)⊢⍬ ⋄ z,←gfh'Init'
      z,←{' array_cp(',(gnm ⍵),',',(gnm 1↓⍵),');'}¨ve ⋄ z,←⊂' return 0;}'
      gt←{⊂' if(*(type_i*)',(gnm 2↓⍵),'->elements){'}
      gif←{(gt ⍵),(' ',¨ges 3↓⍵),⊂'  return 0;}'}
      gv←{⊂' array_cp(',(com cv¨⍵),');'} ⋄ cv←{'lft' 'rgt'⍵⊃⍨(,¨'⍺⍵')⍳⊂⍵}
      gd←{z l f r←⍵ ⋄ ⊂' ',f,'d(',(com cv¨z l r'env,gpu'),');'}
      gm←{z f r←⍵ ⋄ ⊂' ',f,'m(',(com cv¨z'NULL'r'env,gpu'),');'}
      gom←{z f o r←⍵ ⋄ ⊂' ',o,'m(',(com cv¨z'NULL'r f'env,gpu'),');'}
      god←{z l f o r←⍵ ⋄ ⊂' ',o,'d(',(com cv¨z'NULL'r f'env,gpu'),');'}
      ge←{'Condition'≡⊃0 1⌷⍵:gif ⍵ ⋄ ns←'name'Prop ⍵ ⋄ cl←⊃'class'Prop 1↑⍵
        2=≢ns:gv ns ⋄ 3=≢ns:gm ns ⋄ (4=≢ns)∧'monadic'≡cl:gom ns
        (4=≢ns)∧'dyadic'≡cl:gd ns ⋄ 5=≢ns:god ns ⋄ ⊂''}
      ges←{⍵{⊃,/ge¨((⊃⍺)=0⌷⍉⍺)⊂[0]⍺}⍣(0≠≢⍵)⊢⊂' array_free(res);'}
      ga←{(gfh n,⍵),(⊂' return ',(n←gnm ⍺),'(res,lft,rgt);}')}
      enm←{∪('name'Prop((1⌷⍉⍵)∊⊂'Expression')⌿⍵)~⊂'res'}
      ged←{⊂'struct codfns_array*env[]={env0',(com(⊂''),{'onv[',(⍕⍵),']'}¨⍳⍵),'};'}
      env←{' ',¨(frm≢⍺),(ged⍎'0',⊃'depth'Prop 1↑1↓⍵),⊂'init_env(env0,',(⍕≢⍺),');'}
      mvd←{' ',¨⍵ gvd⍣(0≠≢⍵)⊢⍬}
      gf←{(gfh gnm ⍵),(n env ⍵),(mvd⊢n←enm ⍵),(ges 2↓⍵),⊂' return 0;}'}
      z,←⊃,/(⊂0⍴⊂''),gf¨fn←(tm/1⌽(1⌷⍉⍵)∊⊂'Function')/t
      ⍪z}
:EndNamespace 