:Namespace cpu_sha_chron

⎕IO ⎕ML ⎕WX←0 1 3

M←⎕NS ''
M.ch0←{((0⌷⍵)∧1⌷⍵)≠(2⌷⍵)>0⌷⍵}
M.maj←{≠⌿⍵∧1⊖⍵}
M.Sig←{(¯20⌽⍵)≠(¯13⌽⍵)≠(¯22⌽⍵)}

⎕THIS ⎕SE.UCMD 'compile M Mcpu -af=cpu'
      
Mcpu.∆.Init  ⍝file not found.
zp←Mcpu.∆.MKA ⍬

x3←?4 128 32⍴2
x3p←Mcpu.∆.MKA x3

⍴Mcpu.ch0 x3
⍴Mcpu.maj x3
⍴Mcpu.Sig x3

cpu_sha_chron1←'M.ch0 x3' 'M.maj x3' 'M.Sig x3'
cpu_sha_chron2←'{Mcpu.⍙.ch0 zp 0 x3p ⋄ Mcpu.∆.Sync}⍬' 'M.ch0 x3'
cpu_sha_chron3←'{Mcpu.⍙.maj zp 0 x3p ⋄ Mcpu.∆.Sync}⍬' 'M.maj x3'
cpu_sha_chron4←'{Mcpu.⍙.Sig zp 0 x3p ⋄ Mcpu.∆.Sync}⍬' 'M.Sig x3'

:EndNamespace
