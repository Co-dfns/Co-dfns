:Namespace cuda_mystika_chron

⎕IO ⎕ML ⎕WX←0 1 3

M←⎕NS ''
M.rho←{⍺(⍴⍤1 ¯1)⍵}
M.top←{+⌿∧⍀0=3↓⍵}
M.pla1←{(3↑⍵)⍪(-⍺)↑3↓⍵}
M.pla2←{k←0⌊(top⍵)+⍺+3-≢⍵ ⋄ (0⌷⍵)⍪(k+1⌷⍵)⍪(2⌷⍵)⍪(-⍺)↑k⊖3↓⍵}
M.mov←{k←(3-≢⍵)⌈(¯3+≢⍵)⌊⍺-1⌷⍵ ⋄ (0⌷⍵)⍪⍺⍪(2⌷⍵)⍪(3-≢⍵)↑k⊖(2×3-≢⍵)↑3↓⍵}

⎕THIS ⎕SE.UCMD 'compile M Mcuda -af=cuda'
      
Mcuda.∆.Init
zp←Mcuda.∆.MKA ⍬

a1←256⍪?32⍪2⍪32 1024⍴256
a2←256⍪?32⍪2⍪32 64 1024⍴256
m1←256 0 0
r1←64 1024
r2←13128
pl1←64
pl2←12
rdx1←?64 1024⍴32
rdx2←0

a1p←Mcuda.∆.MKA a1
a2p←Mcuda.∆.MKA a2
m1p←Mcuda.∆.MKA m1
r1p←Mcuda.∆.MKA r1
r2p←Mcuda.∆.MKA r2
pl1p←Mcuda.∆.MKA pl1 
pl2p←Mcuda.∆.MKA pl2
rdx1p←Mcuda.∆.MKA rdx1
rdx2p←Mcuda.∆.MKA rdx2

⍴r1 Mcuda.rho m1
⍴pl1 Mcuda.pla1 a2
⍴pl2 Mcuda.pla2 a2
⍴rdx1 Mcuda.mov a2
⍴rdx2 Mcuda.mov a2

cuda_mystika_chron01←'{Mcuda.⍙.mov zp r1p m1p ⋄ Mcuda.∆.Sync}⍬' 'r1 M.rho m1'
cuda_mystika_chron02←'{Mcuda.⍙.mov zp r1p a1p ⋄ Mcuda.∆.Sync}⍬' 'r1 M.rho a1'
cuda_mystika_chron03←'{Mcuda.⍙.mov zp r2p a2p ⋄ Mcuda.∆.Sync}⍬' 'r2 M.rho a2'
cuda_mystika_chron04←'{Mcuda.⍙.pla1 zp pl1p a2p ⋄ Mcuda.∆.Sync}⍬' 'pl1 M.pla1 a2'
cuda_mystika_chron05←'{Mcuda.⍙.pla2 zp pl2p a2p ⋄ Mcuda.∆.Sync}⍬' 'pl2 M.pla2 a2'
cuda_mystika_chron06←'{Mcuda.⍙.mov zp rdx1p a2p ⋄ Mcuda.∆.Sync}⍬' 'rdx1 M.mov a2'
cuda_mystika_chron07←'{Mcuda.⍙.mov zp rdx2p a2p ⋄ Mcuda.∆.Sync}⍬' 'rdx2 M.mov a2'

:EndNamespace
