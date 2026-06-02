:Require file://t0043.dyalog
:Namespace t0043_tests

 tn←'t0043' ⋄ cn←'c0043'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0043←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←(⍎'dy.',fn)⍵⍵ ⋄ cv←(⍎'cd.',fn)⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}

 X←⍉⍪¯35.5 ¯41.5 ¯29.5 7.5 34.5 ¯11.5 31.5 ¯0.5 32.5 12.5
 I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?100⍴10000
 F←100÷⍨?100⍴10000
 B←?100⍴2

∆redfirst∆01_TEST←'redfirst∆R1'  MK∆T1 (⍬⍴1)
∆redfirst∆02_TEST←'redfirst∆R1'  MK∆T1 (5⍴⍳5)
∆redfirst∆03_TEST←'redfirst∆R1'  MK∆T1 (3 3⍴⍳9)
∆redfirst∆04_TEST←'redfirst∆R2'  MK∆T1 (⍬⍴3)
∆redfirst∆05_TEST←'redfirst∆R2'  MK∆T1 (⍬)
∆redfirst∆06_TEST←'redfirst∆R1'  MK∆T1 (⍬)
∆redfirst∆07_TEST←'redfirst∆R3'  MK∆T1 (⍬⍴1)
∆redfirst∆08_TEST←'redfirst∆R3'  MK∆T1 (5⍴⍳5)
∆redfirst∆09_TEST←'redfirst∆R3'  MK∆T1 (3 3⍴⍳9)
∆redfirst∆10_TEST←'redfirst∆R1'  MK∆T1 (?15⍴2)
∆redfirst∆11_TEST←'redfirst∆R1'  MK∆T1 (?128⍴2)
∆redfirst∆12_TEST←'redfirst∆R1'  MK∆T1 (?100⍴2)
∆redfirst∆13_TEST←'redfirst∆R1'  MK∆T1 (?3 3⍴2)
∆redfirst∆14_TEST←'redfirst∆R1'  MK∆T1 (?10 10⍴2)
∆redfirst∆15_TEST←'redfirst∆R1'  MK∆T1 (?32 32⍴2)
∆redfirst∆16_TEST←'redfirst∆R1'  MK∆T1 (?128 128⍴2)
∆redfirst∆17_TEST←'redfirst∆R1'  MK∆T1 (?100 100⍴2)
∆redfirst∆18_TEST←'redfirst∆R1'  MK∆T1 (?500 500⍴2)
∆redfirst∆19_TEST←'redfirst∆R1'  MK∆T1 (?512 512⍴2)
∆redfirst∆20_TEST←'redfirst∆R1'  MK∆T1 (?512⍴2)
∆redfirst∆21_TEST←'redfirst∆R4'  MK∆T1 (1⍴1)
∆redfirst∆22_TEST←'redfirst∆R4'  MK∆T1 (1 5⍴⍳5)
∆redfirst∆23_TEST←'redfirst∆R4'  MK∆T1 (1 3 3⍴⍳9)
∆redfirst∆24_TEST←'redfirst∆R1'  MK∆T1 (?128⍴2)
∆redfirst∆25_TEST←'redfirst∆R1'  MK∆T1 (?2048⍴2)
∆redfirst∆26_TEST←'redfirst∆R1'  MK∆T1 (?128⍴0)
∆redfirst∆27_TEST←'redfirst∆R1'  MK∆T1 (?2048⍴0)
∆redfirst∆28_TEST←'redfirst∆R1'  MK∆T1 ((?128⍴0)+0j1×?128⍴0)
∆redfirst∆29_TEST←'redfirst∆R1'  MK∆T1 ((?2048⍴0)+0j1×?2048⍴0)
∆redfirst∆30_TEST←'redfirst∆R2'  MK∆T1 (?128⍴2)
∆redfirst∆31_TEST←'redfirst∆R2'  MK∆T1 (?2048⍴2)
∆redfirst∆32_TEST←'redfirst∆R2'  MK∆T1 (?128⍴0)
∆redfirst∆33_TEST←'redfirst∆R2'  MK∆T1 (?2048⍴0)
∆redfirst∆34_TEST←'redfirst∆R2'  MK∆T1 ((?128⍴0)+0j1×?128⍴0)
∆redfirst∆35_TEST←'redfirst∆R2' 1E¯322 MK∆T3 ((?2048⍴0)+0j1×?2048⍴0)
∆redfirst∆36_TEST←'redfirst∆min' MK∆T1 (?128⍴2)
∆redfirst∆37_TEST←'redfirst∆min' MK∆T1 (?2048⍴2)
∆redfirst∆38_TEST←'redfirst∆min' MK∆T1 (?128⍴0)
∆redfirst∆39_TEST←'redfirst∆min' MK∆T1 (?2048⍴0)
∆redfirst∆40_TEST←'redfirst∆max' MK∆T1 (?128⍴2)
∆redfirst∆41_TEST←'redfirst∆max' MK∆T1 (?2048⍴2)
∆redfirst∆42_TEST←'redfirst∆max' MK∆T1 (?128⍴0)
∆redfirst∆43_TEST←'redfirst∆max' MK∆T1 (?2048⍴0)
∆redfirst∆44_TEST←'redfirst∆and' MK∆T1 (?128⍴2)
∆redfirst∆45_TEST←'redfirst∆and' MK∆T1 (?2048⍴2)
∆redfirst∆46_TEST←'redfirst∆lor' MK∆T1 (?128⍴2)
∆redfirst∆47_TEST←'redfirst∆lor' MK∆T1 (?2048⍴2)
∆redfirst∆48_TEST←'redfirst∆xor' MK∆T1 (?128⍴2)
∆redfirst∆49_TEST←'redfirst∆xor' MK∆T1 (?2048⍴2)
∆redfirst∆50_TEST←'redfirst∆R1'  MK∆T1 (?16 16⍴2)
∆redfirst∆51_TEST←'redfirst∆R1'  MK∆T1 (?1024 1024⍴2)
∆redfirst∆52_TEST←'redfirst∆R1'  MK∆T1 (?16 16⍴0)
∆redfirst∆53_TEST←'redfirst∆R1'  MK∆T1 (?1024 1024⍴0)
∆redfirst∆54_TEST←'redfirst∆R2'  MK∆T1 (?16 16⍴2)
∆redfirst∆55_TEST←'redfirst∆R2'  MK∆T1 (?1024 1024⍴2)
∆redfirst∆56_TEST←'redfirst∆R2'  MK∆T1 (?16 16⍴0)
∆redfirst∆57_TEST←'redfirst∆R2'  MK∆T1 (?1024 1024⍴0)
∆redfirst∆58_TEST←'redfirst∆min' MK∆T1 (?16 16⍴2)
∆redfirst∆59_TEST←'redfirst∆min' MK∆T1 (?1024 1024⍴2)
∆redfirst∆60_TEST←'redfirst∆min' MK∆T1 (?16 16⍴0)
∆redfirst∆61_TEST←'redfirst∆min' MK∆T1 (?1024 1024⍴0)
∆redfirst∆62_TEST←'redfirst∆max' MK∆T1 (?16 16⍴2)
∆redfirst∆63_TEST←'redfirst∆max' MK∆T1 (?1024 1024⍴2)
∆redfirst∆64_TEST←'redfirst∆max' MK∆T1 (?16 16⍴0)
∆redfirst∆65_TEST←'redfirst∆max' MK∆T1 (?1024 1024⍴0)
∆redfirst∆66_TEST←'redfirst∆and' MK∆T1 (?16 16⍴2)
∆redfirst∆67_TEST←'redfirst∆and' MK∆T1 (?1024 1024⍴2)
∆redfirst∆68_TEST←'redfirst∆lor' MK∆T1 (?16 16⍴2)
∆redfirst∆69_TEST←'redfirst∆lor' MK∆T1 (?1024 1024⍴2)
∆redfirst∆70_TEST←'redfirst∆xor' MK∆T1 (?16 16⍴2)
∆redfirst∆71_TEST←'redfirst∆xor' MK∆T1 (?1024 1024⍴2)

∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace