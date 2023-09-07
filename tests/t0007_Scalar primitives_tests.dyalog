:Require file://t0007.dyalog
:Namespace t0007_tests
 tn←'t0007' ⋄ cn←'c0007'

 _← 'add' 'sub' 'mul' 'div' 'pow' 'log' 'res' 'min' 'max' 'leq' 'let' 'eql'
 _,←'geq' 'get' 'neq' 'and' 'lor' 'nor' 'nan' 'cir' 'bin' 'con' 'neg' 'dir'
 _,←'rec' 'exp' 'nlg' 'mag' 'pit' 'flr' 'cel' 'not' 'mat' 'fac'
 bindings←{⍵[⍋⍵;]}↑_

 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆000_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0007←tn #.codfns.Fix ⎕SRC dy}
 ∆001_TEST←{#.UT.expect←bindings ⋄ cd.⎕NL 3}

 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}0,¯50+?9⍴100
 I2←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}0,¯50+?9⍴100
 F←0,¯5+100÷⍨?9⍴1000
 F2←0,¯5+100÷⍨?9⍴1000
 F1LT←?10⍴0
 AFN←(?10⍴0)-?10⍴2
 B←?10⍴2
 INT←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}0,?9⍴100
 FNT←0,100÷⍨?9⍴1000
 IPS←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}2+?10⍴100
 FPS←100÷⍨100+?10⍴1000
 INZ←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}{10↑(0≠⍵)/⍵}¯50+?100⍴100
 ING←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}{10↑(1<|⍵)/⍵}¯50+?100⍴100
 FNZ←{10↑(0≠⍵)/⍵}¯5+100÷⍨?100⍴100
 BNZ←10⍴1

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ in←⍵⍵ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ Z←,tl>|nv-cv
  Z⊣{⎕←↑(↑in)(-⌿↑in)(↑nv cv)}⍣(~∧⌿Z)⊢Z}

 i←1 ⋄ idx←{∊'ZI3'⎕FMT i⊣i+←1}

 ∇Z←N SCL∆TST∆DYADIC(FN IL IR FL FR BL BR);S
 S←('IL' 'FL' 'BL')∘.{⍺,' ',⍵}('IR' 'FR' 'BR')
 ⍎¨(∘.,⍨'ifb'){'∆',(idx⍬),'∆',N,'∆',⍺,'_TEST←''',FN,'''MK∆T2 ',⍵}¨S
 Z←0 0⍴⍬
 ∇

 ∇Z←N SCL∆TST∆RELATIVE(FN IL IR FL FR BL BR);L;R
 S←('IL' 'FL' 'BL')∘.{⍺,' ',⍵}('IR' 'FR' 'BR')
 ⍎¨(∘.,⍨'ifb'){'∆',(idx⍬),'∆',N,'∆',⍺,'_TEST←''',FN,''' 1e¯7 MK∆T3 ',⍵}¨S
 Z←0 0⍴⍬
 ∇

 ∇Z←N SCL∆TST∆MONADIC(FN I F B)
 ⍎¨'ifb'{'∆',(idx⍬),'∆',N,'∆',⍺,'_TEST←''',FN,'''MK∆T1 ',⍵}¨'IFB'
 Z←0 0⍴⍬
 ∇

 'conjugate'   SCL∆TST∆MONADIC 'con' I   F   B
 'negate'      SCL∆TST∆MONADIC 'neg' I   F   B
 'direction'   SCL∆TST∆MONADIC 'dir' I   F   B
 'reciprocal'  SCL∆TST∆MONADIC 'rec' INZ FNZ BNZ
 'exponential' SCL∆TST∆MONADIC 'exp' I   F   B
 'natlog'      SCL∆TST∆MONADIC 'nlg' IPS FPS IPS
 'magnitude'   SCL∆TST∆MONADIC 'mag' I   F   B
 'pitimes'     SCL∆TST∆MONADIC 'pit' I   F   B
 'floor'       SCL∆TST∆MONADIC 'flr' I   F   B
 'ceiling'     SCL∆TST∆MONADIC 'cel' I   F   B
 'not'         SCL∆TST∆MONADIC 'not' B   B   B
 'materialize' SCL∆TST∆MONADIC 'mat' I   F   B
 'factorial'   SCL∆TST∆MONADIC 'fac' IPS FPS B

 'plus'      SCL∆TST∆DYADIC   'add'  I   I    F          F    B   B
 'minus'     SCL∆TST∆DYADIC   'sub'  I   I    F          F    B   B
 'times'     SCL∆TST∆DYADIC   'mul'  I   I    F          F    B   B
 'divide'    SCL∆TST∆DYADIC   'div'  I   INZ  F          FNZ  B   BNZ
 'power'     SCL∆TST∆DYADIC   'pow'  INZ I    FNZ        I    BNZ B
 'log'       SCL∆TST∆DYADIC   'log'  IPS IPS  FPS        FPS  IPS IPS
 'powerzro'  SCL∆TST∆DYADIC   'pow'  I   INT  F          INT  B   B
 'powerneg'  SCL∆TST∆DYADIC   'pow'  IPS I    FPS        F    BNZ B
 'residuei'  SCL∆TST∆DYADIC   'res'  I   I    I2         I2   B   B
 'residuef'  SCL∆TST∆RELATIVE 'res'  F   F    F2         F2   B   B
 'minimum'   SCL∆TST∆DYADIC   'min'  I   I    F          F    B   B
 'maximum'   SCL∆TST∆DYADIC   'max'  I   I    F          F    B   B
 'lessthan'  SCL∆TST∆DYADIC   'let'  I   I    F          F    B   B
 'lesseq'    SCL∆TST∆DYADIC   'leq'  I   I    F          F    B   B
 'equal'     SCL∆TST∆DYADIC   'eql'  I   I    F          F    B   B
 'greatereq' SCL∆TST∆DYADIC   'geq'  I   I    F          F    B   B
 'greater'   SCL∆TST∆DYADIC   'get'  I   I    F          F    B   B
 'notequal'  SCL∆TST∆DYADIC   'neq'  I   I    F          F    B   B
 'ori'       SCL∆TST∆DYADIC   'lor'  I   I    I2         I2   B   B
 'orf'       SCL∆TST∆RELATIVE 'lor'  F   F    F2         F2   B   B
 'andi'      SCL∆TST∆DYADIC   'and'  I   I    I2         I2   B   B
 'andf'      SCL∆TST∆RELATIVE 'and'  F   F    F2         F2   B   B
 'notand'    SCL∆TST∆DYADIC   'nan'  B   B    B          B    B   B
 'notor'     SCL∆TST∆DYADIC   'nor'  B   B    B          B    B   B
 'circular0' SCL∆TST∆DYADIC   'cir'  0   F1LT (0⍴⍨≢F1LT) F1LT 0   B
 'circular1' SCL∆TST∆DYADIC   'cir'  1   I    (1⍴⍨≢F)    F    1   B
 'circular2' SCL∆TST∆DYADIC   'cir'  2   I    (2⍴⍨≢F)    F    2   B
 'circular3' SCL∆TST∆DYADIC   'cir'  3   I    (3⍴⍨≢F)    F    3   B
 'circular4' SCL∆TST∆DYADIC   'cir'  4   I    (4⍴⍨≢F)    F    4   B
 'circular5' SCL∆TST∆DYADIC   'cir'  5   I    (5⍴⍨≢F)    F    5   B
 'circular6' SCL∆TST∆DYADIC   'cir'  6   I    (6⍴⍨≢F)    F    6   B
 'circular7' SCL∆TST∆DYADIC   'cir'  7   I    (7⍴⍨≢F)    F    7   B
 'circneg1'  SCL∆TST∆DYADIC   'cir' ¯1   AFN  (¯1⍴⍨≢AFN) AFN ¯1   B
 'circneg2'  SCL∆TST∆DYADIC   'cir' ¯2   AFN  (¯2⍴⍨≢AFN) AFN ¯2   B
 'circneg3'  SCL∆TST∆DYADIC   'cir' ¯3   I    (¯3⍴⍨≢F)   F   ¯3   B
 'circneg4'  SCL∆TST∆DYADIC   'cir' ¯4   ING  (¯4⍴⍨≢F)   FNZ ¯4   BNZ
 'circneg5'  SCL∆TST∆RELATIVE 'cir' ¯5   I    (¯5⍴⍨≢F)   F   ¯5   B
 'circneg6'  SCL∆TST∆DYADIC   'cir' ¯6   IPS  (¯6⍴⍨≢F)   FPS ¯6   BNZ
 'circneg7'  SCL∆TST∆DYADIC   'cir' ¯7   AFN  (¯7⍴⍨≢F)   AFN ¯7   AFN
 ⍝'binompos'  SCL∆TST∆RELATIVE 'bin'  IPS IPS  FPS        FPS  B    B
 ⍝'binomial'  SCL∆TST∆DYADIC   'bin' I    I    F            F     B    B

 ∆999_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
