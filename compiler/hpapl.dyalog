:Namespace HPAPL
⎕IO ⎕ML ⎕WX←0 0 3

∇ R←AssignConst(NM VL)
 R←0 4⍴⍬
 R⍪←'alloc'NM'0,0,1,1'⍬
 R⍪←'assign'NM'0'(⍕VL)
∇

∇ R←BuildConst In;I;T;C;Z;X;Y
 R←0 4⍴⍬
 :For I :In ⍳⊃⍴In
     (C Z X Y)←In[I;]
     :Select C
     :Case '←'
         R⍪←AssignConst Z X
     :Else
         R⍪←C Z X Y
     :EndSelect
 :EndFor
∇

∇ R←Compile V
 R←Tokenizer V
 R←Parser R
 R←LiftConst R
 R←BuildConst R
 R←EmitUPC R
∇

∇ R←EmitUPC In;NL;X
 NL←⎕UCS 133
 R←⍬
 R,←'#include <stdio.h>',NL
 R,←'#include "hpapl.h"',NL
 R,←NL
 R,←'int main(int argc, char *argv[]) {',NL
 X←↑{⍺≡⍬:⍵ ⋄ ⍵≡⍬:⍺ ⋄ ⍺,',',⍵}/In[;1 2 3]
 X←'(',X,((⊃⍴In)3)⍴');',NL
 R,←,(↑In[;0]),X
 R,←'apl_print(res);',NL
 R,←'return 0;',NL
 R,←'}',NL
∇

∇ R←LiftConst In;I;Nms;D;T;V
 R←0 4⍴⍬ ⋄ Nms←⍬
 R⍪←'decl' 'res'⍬ ⍬
 R⍪←'←' 'res'(⊃In[0;2])⍬
∇

∇ R←Parser Tokens;Ttype;Tval;I
 R←0 3⍴⍬
 :For I :In ⍳⊃⍴Tokens
     Ttype Tval←Tokens[I;]
     :Select Ttype
     :Case 1
         R⍪←0 1 Tval
     :EndSelect
 :EndFor
∇

∇ R←ProcToken(Type Val)
 :Select Type
 :Case 1
     R←Type(⍎Val)
 :EndSelect
∇

∇ R←Tokenizer V;C;Line;Col;Type;Val;NL
 R←0 2⍴⍬ ⋄ NL←⎕UCS 10 13 133
 Type←0 ⋄ Val←⍬
 :For C :In V
     :Select C
     :CaseList ' ',NL
     :CaseList '0123456789'
         Type←1
         Val,←C
     :EndSelect
 :EndFor
 R⍪←ProcToken Type Val
∇

:EndNamespace 