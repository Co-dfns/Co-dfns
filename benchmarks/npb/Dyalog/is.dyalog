:Namespace IS

    ClassA←(2*23)(2*19)314159265 10

    ∇ Run class;N;Bmax;startSeed;Imax;keys;Seed;Ts;i;R;Te;partialKeyIndex;partialKeyRank;j
      ⍝ Parameter values used by various classes,
      ⍝ See Figure 2.9 of NPB IS benchmark document.
      N Bmax startSeed Imax←class
      :If class≡ClassA
          partialKeyIndex←211237 662041 5336171 3642833 4250760  ⍝ Values to be used for partial
          partialKeyRank←104 17523 123928 8288932 8388264        ⍝ verification as specified in Table 2.8
      :EndIf
      Seed keys←startSeed #.UTIL.RandI N                         ⍝ Generate N keys
      Ts←24 60 60 1000⊥3↓⎕TS                                     ⍝ Begin timing
      :For i :In ⍳Imax
          keys[i Imax+i]←i Bmax-i                                ⍝ Modify sequence of keys
          R←⍋keys                                                ⍝ Compute the ranks of keys
          :For j :In ⍳5                                          ⍝ Partial verification test
              :If j<3
                  :If R[partialKeyIndex[j]]≠partialKeyRank[j]+i
                      ⎕←'Iteration',i,': Partial verification failed.'
                  :EndIf
              :Else
                  :If R[partialKeyIndex[j]]≠partialKeyRank[j]-i
                      ⎕←'Iteration',i,': Partial verification failed.'
                  :EndIf
              :EndIf
          :EndFor
      :EndFor
      Te←24 60 60 1000⊥3↓⎕TS                                     ⍝ End timing
      ⎕←'Time taken: ',(⍕(Te-Ts)÷1000),' seconds.'
      :If ∧/2≤/keys[R]                                           ⍝ Full verification test
          ⎕←'Full verification suceeded.'
      :Else
          ⎕←'Full verification failed.'
      :EndIf
    ∇

:EndNamespace 

