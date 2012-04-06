:Namespace CG
⍝ === VARIABLES ===

ClassA←14000 15 11 20

ClassSample←1400 15 7 10


⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX ⎕RL←1 0 3 2090219546

∇ ZRN←X CgSparse A;R;Rho;P;I;Q;Alpha;RhoZ;Beta;Z
 Z←0 ⋄ R←X ⋄ Rho←R+.×R ⋄ P←R
 :For I :In ⍳25
     Q←A SMVP P
     Alpha←Rho÷P+.×Q
     Z←Z+Alpha×P
     RhoZ←Rho
     R←R-Alpha×Q
     Rho←R+.×R
     Beta←Rho÷RhoZ
     P←R+Beta×P
 :EndFor
 R←X-A SMVP Z
 ZRN←Z((R+.×R)*0.5)
∇

∇ A←MakeSA6(N NZ L);W;R;Xi;Xv;I;IV;RN;CI;DV;Ts;Te;S;Av;Ai;At;F
     ⍝ Generate a test matrix of order N as the weighted sum of N outer products of
     ⍝ random sparse vectors.
 ⎕IO←0
 Ts←24 60 60 1000⊥3↓⎕TS
 R←0.1*÷N-1                    ⍝ Geometric ratio for W
 Ai Av←⍬ ⍬                     ⍝ Initialize empty sparse matrix A
 :For I :In ⍳N
     Xi←(I≠Xi)/Xi←NZ?N         ⍝ NZ nonzeros maybe with no X_i
     Xv←(2*¯30)×?(⍴Xi)⍴2*30    ⍝ Random values (0..1)
     Xi,←I ⋄ Xv,←0.5           ⍝ X_i is 0.5
     Av,←(R*I)×,Xv∘.×Xv        ⍝ Catenate weighted outer product
     At←((⍴Xi)*2)⍴Xi           ⍝ Nonzero row/column pattern
     Ai,←At+N×,⍉(2⍴⍴Xi)⍴At     ⍝ Catenate respective ravel indices
 :EndFor
 S←⍋Ai ⋄ Ai←Ai[S] ⋄ Av←Av[S]
 S←(1⌽Ai)≠Ai
 IV←S/Ai
 DV←S/+\Av
 DV←(⊃DV),1↓DV-¯1⌽DV
 CI←N|IV                              ⍝ Extract the Column indices
 RN←N⍴0 ⋄ RN[(IV-CI)÷N]+←1            ⍝ Build the NZ row vector
 DV[((RN/⍳⍴RN)=CI)/⍳⍴DV]+←0.1         ⍝ Diagonal gets additional 0.1
 CI←N|CI-L                            ⍝ Shift the diagonal
 A←RN CI DV                           ⍝ A with goodies
 Te←24 60 60 1000⊥3↓⎕TS
 ⎕←'Made array in ',(⍕(Te-Ts)÷1000),' seconds.'
∇

∇ R←M SMVP V;S;NZ;CI;DV;B;⎕IO
 ⎕IO←0
     ⍝ Sparse Matrix, Dense vector product, inspired by
     ⍝  Hendriks, Ferdinand and Wai-Mee Ching.
     ⍝  "Sparse Matrix Technology Tools in APL."
     ⍝  1990 ACM.
     ⍝ NZ CI DV←M                ⍝ Explode the matrix
     ⍝ R←DV×V[CI]
     ⍝ R←0,+\R            ⍝ Do the product
     ⍝ R←R[(0≠NZ)×+\NZ]          ⍝ Get desired sums
     ⍝ S←(0≠R)/⍳⍴R               ⍝ Select the nonzero results
     ⍝ R[S]←R[⊃S],1↓R[S]-¯1⌽R[S] ⍝ Subtract excess
 ⎕IO←0
 NZ CI DV←M
 B←(+/NZ)⍴0
 B[¯1++\NZ]←1
 R←(×NZ)\-2-/0,B/+\DV×V[CI]
∇

∇ (Cg Solve)(N NI NZ L);A;X;I;Z;R;Rn;Zeta;Ts;Te;⎕IO
 ⎕IO←0
 A←MakeSA6 N NZ L
 X←N⍴1
 ⎕←'Iteration        ∥R∥                 Zeta'
 ⎕←'─────────────────────────────────────────────────────'
 Ts←24 60 60 1000⊥3↓⎕TS
 :For I :In 1+⍳NI
     Z Rn←X Cg A
     Zeta←L+÷X+.×Z
     ⎕←9 0 20 ¯7 24 13⍕I Rn Zeta
     X←Z÷(Z+.×Z)*0.5
 :EndFor
 Te←24 60 60 1000⊥3↓⎕TS
 ⎕←''
 ⎕←'Time taken: ',(⍕(Te-Ts)÷1000),' seconds.'
∇

:EndNamespace 