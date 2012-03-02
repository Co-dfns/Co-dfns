:Namespace Tests

 ⎕IO  ←0 ⍝ *** DO NOT change these system variables here, only after the variables definition 

⍝ === VARIABLES ===

L←⎕av[3+⎕io]
Valid←,⊂6 4⍴0 'Function' 'fact' ('res' 'n' ⍬) 1 'Statement' '!' ('res' 'n') 0 'Program' ⍬ (⊂'res') 1 'Statement' 0 ('res' '0' '1') 1 'Statement' 1 ('res' '0' '5') 1 'Statement' 'fact' (2⍴⊂'res')

ValidEmitUPC←,⊂10 2⍴'init' (⊂⍬) 'begfun' ('fact' 'res' 'n') 'bangm' ('res' 'n') 'endfun' (⊂⍬) 'begprog' (⊂⍬) 'decl' (⊂'res') 'alloc' ('res' '0' '1') 'setarr' ('res' '0' '5') 'fact' (2⍴⊂'res') 'endprog' (⊂'res')

ValidExp←,⊂'#include <stdio.h>',⎕av[3],'#include "hpapl.h"',⎕av[3 3],'init();',⎕av[3],'begfun(fact,res,n);',⎕av[3],'bangm(res,n);',⎕av[3],'endfun();',⎕av[3],'begprog();',⎕av[3],'decl(res);',⎕av[3],'alloc(res,0,1);',⎕av[3],'setarr(res,0,5);',⎕av[3],'fact(res,res);',⎕av[3],'endprog(res);',⎕av[3]

ValidSkip←,0

X←6 4⍴0 'Function' 'fact' ('res' 'n' ⍬) 1 'Statement' '!' ('res' 'n') 0 'Program' ⍬ (⊂'res') 1 'Statement' 0 ('res' '0' '1') 1 'Statement' 1 ('res' '0' '5') 1 'Statement' 'fact' (2⍴⊂'res')

_←⍬
_,←'#include <stdio.h>'
_,←L,'#include "hpapl.h"'
_,←L,''
_,←L,'init();'
_,←L,'begfun(fact,res,n);'
_,←L,'bangm(res,n);'
_,←L,'endfun();'
_,←L,'begprog();'
_,←L,'decl(res);'
_,←L,'alloc(res,0,1);'
_,←L,'setarr(res,0,5);'
_,←L,'fact(res,res);'
_,←L,'endprog(res);'
_,←L,''
Y←_

⎕ex¨ 'L' '_'

⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX←0 0 3

∇ R←Run;Test;Exp;Skip;Count;Act
 ⎕←'Running Valid Tests...'
 Count←0
 :For Test Exp Skip :InEach Valid ValidExp ValidSkip
     :If ~Skip
         :If ~Exp≡Act←#.HPAPL.Compile Test
             ⎕←'Failed test ',⍕Count
             R←2 1⍴Exp Act
             :Return
         :EndIf
     :EndIf
     Count+←1
 :EndFor
 ⎕←'Tests passed successfully.'
∇

:EndNamespace 