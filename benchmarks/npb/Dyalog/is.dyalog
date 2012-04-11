:Namespace IS
    ⎕IO ⎕ML ⎕WX ⎕RL←1 0 3 62669991



    ∇ ISTest class;N;Bmax;Seed;Imax;Keys;i;Rank;Ts;Te
  ⍝ Parameter values as specified in figure 2.9 in the
  ⍝ benchmark documenation.
      N←class[1]
      Bmax←class[2]
      Seed←class[3]
      Imax←class[4]
     
  ⍝ Generate the keys:
      Seed Keys←Seed #.UTIL.RandI Imax
     
      Ts←24 60 60 1000⊥3↓⎕TS
  ⍝ Modify the sequence of keys as specified
      :For i :In Imax
          Keys[i]←i
          Keys[i+Imax]←Bmax-i
      :EndFor
     
  ⍝ Compute the rank of each key
      Rank←⍋Keys
     
  ⍝ Perform the partial verification test
  ⍝ ??????????????
      Te←24 60 60 1000⊥3↓⎕TS
      ⎕←'Time taken: ',(⍕(Te-Ts)÷1000),' seconds.'
     
     
     
     
    ∇


    ∇ IS class;N;Bmax;Seed;Imax;Keys;i;Rank;Ts;Te;FullVerify;Sorted
  ⍝ Parameter values as specified in figure 2.9 in the
  ⍝ benchmark documenation.
      N←class[1]
      Bmax←class[2]
      Seed←class[3]
      Imax←class[4]
     
  ⍝ Generate the keys:
      Seed Keys←Seed #.UTIL.RandI N
     
      Ts←24 60 60 1000⊥3↓⎕TS
  ⍝ Modify the sequence of keys as specified
      :For i :In ⍳Imax
          Keys[i]←i
          Keys[i+Imax]←Bmax-i
      :EndFor
     
  ⍝ Compute the rank of each key
      Rank←⍋Keys
     
     
  ⍝ Perform the partial verification test
  ⍝ ??????????????
      Te←24 60 60 1000⊥3↓⎕TS
      ⎕←'Time taken: ',(⍕(Te-Ts)÷1000),' seconds.'
  ⍝ Full verification
      Sorted←⍋Rank
      FullVerify←1
      :For i :In 1↓⍳N
          :If Sorted[i-1]>Sorted[i]
              FullVerify←0
          :EndIf
      :EndFor
      :If FullVerify
          ⎕←'Full Verification Status: Failed'
      :Else
          ⎕←'Full Verification Status: Passed'
      :EndIf
     
    ∇

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