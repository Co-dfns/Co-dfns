:Namespace random_tests

MK∆T←{nv←⊃(⍎'##.tfns∆dya.',⍺⍺)/⍵⍵ ⋄ cv←⊃(⍎'##.tfns∆cdf.',⍺⍺)/⍵⍵
 res←|1-(0.5⌈(⌈/r)÷2)÷(+/÷≢)cv ⋄ _←{0.05≤⍵:⎕←⍵ ⋄ ⍬}res
 ##.UT.expect←(⍴nv)(1) ⋄ (⍴cv)(0.05>res)}

random∆01_TEST←'random∆Run'   MK∆T 4096 32
random∆01_TEST←'random∆Run'        MK∆T 4096	32
random∆02_TEST←'random∆Run'#.util.MK∆T2 0	14
random∆03_TEST←'random∆Run'        MK∆T 512	0
random∆04_TEST←'random∆Run'#.util.MK∆T2 0	0
random∆05_TEST←'random∆Run'        MK∆T 12345	67890
random∆06_TEST←'random∆Run'#.util.MK∆T2 19	1
random∆07_TEST←'random∆Run'        MK∆T 512	(0 0 0 0)
random∆08_TEST←'random∆Run'#.util.MK∆T2 20	(1 1 1 1)

:EndNamespace
