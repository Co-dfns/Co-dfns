 GC10_TEST←{⍝ F←{+⍵}
     t←⍉⍪0 'Namespace' ''(2 2⍴,¨'name' 'coord' '1 0 0 0 0 0')
     t⍪←1 'FuncExpr' ''(3 2⍴,¨'class' 'ambivalent' 'equiv' 'ambivalent' 'name' 'F')
     t⍪←2 'Function' ''(2 2⍴,¨'class' 'ambivalent' 'coord' '1 1 1 0 0 0')
     t⍪←3 'Expression' ''(2 2⍴,¨'class' 'monadic' 'name' 'res')
     t⍪←4 'FuncExpr' ''(2 2⍴,¨'class' 'monadic' 'equiv' '+')
     t⍪←5 'Variable' ''(2 2⍴,¨'class' 'function' 'name' 'codfns_add')
     t⍪←4 'Expression' ''(2 2⍴,¨'class' 'atomic')
     t⍪←5 'Variable' ''(1 2⍴,¨'name' '⍵')
     x←⍪⊂'#include "codfns.h"'
     x⍪←⍪'UDF(Init){' ' return 0;}'
     x⍪←⊂'UDF(F){'
     x⍪←⊂' struct codfns_array env0[0];'
     x⍪←⊂' struct codfns_array*env[]={env0};'
     x⍪←⊂' init_env(env0,0);'
     x⍪←⍪' codfns_addm(res,NULL,rgt,env,gpu);' ' return 0;}'
     _←X x ⋄ C.GC t}