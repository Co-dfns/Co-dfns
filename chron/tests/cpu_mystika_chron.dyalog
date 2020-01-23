:Namespace cpu_mystika_chron

⎕IO ⎕ML ⎕WX←0 1 3

M←⎕NS ''
M.rho←{⍺(⍴⍤1 ¯1)⍵}
M.top←{+⌿∧⍀0=3↓⍵}
M.pla1←{(3↑⍵)⍪(-⍺)↑3↓⍵}
M.pla2←{k←0⌊(top⍵)+⍺+3-≢⍵ ⋄ (0⌷⍵)⍪(k+1⌷⍵)⍪(2⌷⍵)⍪(-⍺)↑k⊖3↓⍵}
M.mov←{k←(3-≢⍵)⌈(¯3+≢⍵)⌊⍺-1⌷⍵ ⋄ (0⌷⍵)⍪⍺⍪(2⌷⍵)⍪(3-≢⍵)↑k⊖(2×3-≢⍵)↑3↓⍵}

⎕THIS ⎕SE.UCMD 'compile M Mcpu -af=cpu'
      
Mcpu.∆.Init
zp←Mcpu.∆.MKA ⍬

a1←256⍪?32⍪2⍪32 1024⍴256
a2←256⍪?32⍪2⍪32 64 1024⍴256
m1←256 0 0
r1←64 1024
r2←13128
pl1←64
pl2←12
rdx1←?64 1024⍴32
rdx2←0

a1p←Mcpu.∆.MKA a1
a2p←Mcpu.∆.MKA a2
m1p←Mcpu.∆.MKA m1
r1p←Mcpu.∆.MKA r1
r2p←Mcpu.∆.MKA r2
pl1p←Mcpu.∆.MKA pl1 
pl2p←Mcpu.∆.MKA pl2
rdx1p←Mcpu.∆.MKA rdx1
rdx2p←Mcpu.∆.MKA rdx2

⍴r1 Mcpu.rho m1
⍴pl1 Mcpu.pla1 a2
⍴pl2 Mcpu.pla2 a2
⍴rdx1 Mcpu.mov a2
⍴rdx2 Mcpu.mov a2

cpu_mystika_chron01←'{Mcpu.⍙.mov zp r1p m1p ⋄ Mcpu.∆.Sync}⍬' 'r1 M.rho m1'
cpu_mystika_chron02←'{Mcpu.⍙.mov zp r1p a1p ⋄ Mcpu.∆.Sync}⍬' 'r1 M.rho a1'
cpu_mystika_chron03←'{Mcpu.⍙.mov zp r2p a2p ⋄ Mcpu.∆.Sync}⍬' 'r2 M.rho a2'
cpu_mystika_chron04←'{Mcpu.⍙.pla1 zp pl1p a2p ⋄ Mcpu.∆.Sync}⍬' 'pl1 M.pla1 a2'
cpu_mystika_chron05←'{Mcpu.⍙.pla2 zp pl2p a2p ⋄ Mcpu.∆.Sync}⍬' 'pl2 M.pla2 a2'
cpu_mystika_chron06←'{Mcpu.⍙.mov zp rdx1p a2p ⋄ Mcpu.∆.Sync}⍬' 'rdx1 M.mov a2'
cpu_mystika_chron07←'{Mcpu.⍙.mov zp rdx2p a2p ⋄ Mcpu.∆.Sync}⍬' 'rdx2 M.mov a2'

:EndNamespace
