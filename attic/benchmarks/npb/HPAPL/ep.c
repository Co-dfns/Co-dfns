/* Hand compiled version of an NPB EP Benchmark. */

:HPAPL EP
  ∇ R←S Rand I;NS;T
    T←(2*¯46)×NS←(2*46)|S×A*1+⍳N
    R←2 N⍴NS,T
  ∇
  
  ∇ R←D CompBlk I;M;T;Q;TF;XY;L
    T←(TF←1≥T)/T←+/D←(¯1+2×N 2⍴D)*2
    M←⌈/|XY←(TF⌿D)×[0]((¯2×⍟T)÷T)*÷2
    Q←+/(L∘.≤M)∧(1+L←⍳10)∘.>M
    R←Q,+⌿XY
  ∇
  
  CI←{1,(BS,1)⍴⍳BS}
  CO←{(⍳12),12 1⍴⍵÷BS}
  
  A←5*13 ⋄ Seed←271828183 ⋄ N←2*28
  BS←N÷⎕NODES ⋄ IC←BS×⍳⎕NODES
  S←⎕SA 2,2×N ⋄ QXY←⎕SA 12,⎕NODES ⋄ TQXY←⎕SA 12
  ST←⎕TS
  (((⎕NODES,1)⍴IC)⌷S)←
  (SO⌷S)↤(Seed∥Init) IC
  (RO⌷S)↤(SI⌷S∥Rand) IC 
  (CO⌷QXY)↤(CI⌷S∥CompBlk) IC
  TQXY←+/QXY
  ET←⎕TS
  ⎕←12 1⍴TQXY
  ⎕←'Time Taken: ',⍕ET-ST
:EndHPAPL
