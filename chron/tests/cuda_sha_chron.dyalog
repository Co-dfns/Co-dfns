:Namespace cuda_sha_chron

⎕IO ⎕ML ⎕WX←0 1 3

M←⎕NS ''
M.ch0←{((0⌷⍵)∧1⌷⍵)≠(2⌷⍵)>0⌷⍵}
M.maj←{≠⌿⍵∧1⊖⍵}
M.Sig←{(¯20⌽⍵)≠(¯13⌽⍵)≠(¯22⌽⍵)}

⎕THIS ⎕SE.UCMD 'compile M Mcuda -af=cuda'
      
Mcuda.∆.Init  ⍝file not found.
zp←Mcuda.∆.MKA ⍬

x3←?4 128 32⍴2
x3p←Mcuda.∆.MKA x3

⍴Mcuda.ch0 x3
⍴Mcuda.maj x3
⍴Mcuda.Sig x3

cuda_sha_chron1←'M.ch0 x3' 'M.maj x3' 'M.Sig x3'
cuda_sha_chron2←'{Mcuda.⍙.ch0 zp 0 x3p ⋄ Mcuda.∆.Sync}⍬' 'M.ch0 x3'
cuda_sha_chron3←'{Mcuda.⍙.maj zp 0 x3p ⋄ Mcuda.∆.Sync}⍬' 'M.maj x3'
cuda_sha_chron4←'{Mcuda.⍙.Sig zp 0 x3p ⋄ Mcuda.∆.Sync}⍬' 'M.Sig x3'

:EndNamespace
