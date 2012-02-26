:Namespace HPAPL
⍝ === VARIABLES ===

Tests←,⊂,'5'


⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX←0 0 3

∇ R←Compile V
 R←Tokenizer V
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