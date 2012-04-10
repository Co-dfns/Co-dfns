:Namespace IS
⎕IO ⎕ML ⎕WX ⎕RL←0 0 3 62669991

∇ K←KeyGen(B N);R1;R2;R3;R4;I
 #.UTIL.S←314159265
 K←N⍴0 ⋄ I←0
 :While I<N
     R1←#.UTIL.Rand
     R2←#.UTIL.Rand
     R3←#.UTIL.Rand
     R4←#.UTIL.Rand
     K[I]←⌊B×(+/R1 R2 R3 R4)÷4
     I+←1
 :EndWhile
∇

:EndNamespace 