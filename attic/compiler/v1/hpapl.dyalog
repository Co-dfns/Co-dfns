:Namespace HPAPL
⎕IO ⎕ML ⎕WX←0 0 3

∇ R←Compile V
      ⍝R←Tokenizer V
      ⍝R←Parser R
 R←V
 R←FlattenFunctions R
 R←EmitUPC R
∇

∇ CompileFile FN;T;R;O;H
 T←FN ⎕NTIE 0 0
 R←⎕NREAD T,80,2↑⎕NSIZE T
 R←'UTF-8'⎕UCS ⎕UCS R
 ⎕NUNTIE T
 R←Compile R
 O←(((1⌈+/H)≠+\H←'.'=FN)/FN),'.upc'
 :Trap 22
     T←O ⎕NCREATE 0
 :Else
     O ⎕NERASE O ⎕NTIE 0 1
     T←O ⎕NCREATE 0
 :EndTrap
 (⎕UCS'UTF-8'⎕UCS R)⎕NAPPEND T
 ⎕NUNTIE T
∇

∇ R←EmitUPC In;NL;X;Commafy
 NL←⎕UCS 133
 R←⍬
 R,←'#include <stdio.h>',NL
 R,←'#include "hpapl.h"',NL
 R,←NL
 Commafy←{⍺≡⍬:⍵ ⋄ ⍵≡⍬:⍺ ⋄ ⍺,',',⍵}
 :For X :In ⊂[1]In
     R,←⊃0⌷X
     R,←'('
     R,←(⊃Commafy/⊃1⌷X)
     R,←');',NL
 :EndFor
∇

∇ R←FlattenFunctions In;L;Intl;Prims;PrimFns;Return;Last
 R←1 2⍴'init'(⊂⍬)
 Intl←'alloc' 'setarr'
 Prims←1⍴'!'
 PrimFns←1 2⍴'bangm' 'bangd'
 Last←0
 :For L :In ⊂[1]In
     :Select 2↑L
     :Case 0 'Function'
         :If Last=1
             R⍪←'endfun'(⊂⍬)
             Last←0
         :EndIf
         R⍪←'begfun'((2⌷L),¯1↓⊃3⌷L)
         R⍪←↑(⊂⊂'decl'),∘⊂¨⊃¯1↑⊃3⌷L
     :Case 0 'Program'
         :If Last=1
             R⍪←'endfun'(⊂⍬)
             Last←0
         :EndIf
         R⍪←'begprog'(⊂⍬)
         Return←((⊃3⌷L),⊂⍬)[0]
         R⍪←↑(⊂⊂'decl'),∘⊂¨3⌷L
     :Case 1 'Statement'
         Last←1
         :Select 2⌷L
         :CaseList Prims
             R⍪←PrimFns[Prims⍳2⌷L;¯2+⍴⊃3⌷L],3⌷L
         :CaseList ⍳⍴Intl
             R⍪←Intl[2⌷L],3⌷L
         :Else
             R⍪←2↓L
         :EndSelect
     :Else
         'Invalid program'⎕SIGNAL 2
     :EndSelect
 :EndFor
 R⍪←'endprog'Return
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