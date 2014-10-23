 GC01_TEST←{⍝ Empty Namespace
     t←⍉⍪0 'Namespace' ''(2 2⍴,¨'name' '' 'coord' '1')
     x←⍪'#include "codfns.h"' 'UDF(Init){' ' return 0;}'
     _←X x ⋄ C.GC t}