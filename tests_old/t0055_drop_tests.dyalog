:Require file://t0055.dyalog
:Namespace t0055_tests

 tn←'t0055' ⋄ cn←'c0055'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0055←tn #.codfns.Fix ⎕SRC dy}

 MK∆T1←{##.UT.expect←(⍎'dy.',⍺⍺)⍵⍵ ⋄ (⍎'cd.',⍺⍺)⍵⍵}
 MK∆T2←{##.UT.expect←⊃(⍎'dy.',⍺⍺)/⍵⍵ ⋄ ⊃(⍎'cd.',⍺⍺)/⍵⍵}
 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}
 MK∆T4←{fn tl←⍺⍺ ⋄ nv←(⍎'dy.',fn)⍵⍵ ⋄ cv←(⍎'cd.',fn)⍵⍵
  ##.UT.expect←(≢,nv)⍴tl ⋄ ,tl⌈|nv-cv}

F←{⊃((⎕DR ⍵)645)⎕DR ⍵}
B←{⊃((⎕DR ⍵)11)⎕DR ⍵}
I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I32←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I16←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)163)⎕DR ⍵}
I8←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)83)⎕DR ⍵}

∆drop∆001_TEST←'drop∆R1' MK∆T2 1 (5 5⍴⍳5)
∆drop∆002_TEST←'drop∆R1' MK∆T2 3 (⍳10)
∆drop∆003_TEST←'drop∆R2' MK∆T2 (5 7) (⍳35)
∆drop∆004_TEST←'drop∆R1' MK∆T2 ¯1 (0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆005_TEST←'drop∆R1' MK∆T2 ¯1 (0 1 0 1 0 0)
∆drop∆006_TEST←'drop∆R1' MK∆T2 1 ⍬
∆drop∆007_TEST←'drop∆R1' MK∆T2 ¯1 (3 10⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆008_TEST←'drop∆R1' MK∆T2 5 (5 5⍴⍳5)
∆drop∆009_TEST←'drop∆R1' MK∆T2 6 (5 5⍴⍳5)
∆drop∆010_TEST←'drop∆R1' MK∆T2 ¯1 (5 5⍴⍳5)
∆drop∆011_TEST←'drop∆R1' MK∆T2 ¯5 (5 5⍴⍳5)
∆drop∆012_TEST←'drop∆R1' MK∆T2 ¯20 (5 5⍴⍳5)
∆drop∆013_TEST←'drop∆R1' MK∆T2 ¯20 (⍳10)
∆drop∆014_TEST←'drop∆R1' MK∆T2 ¯3 (⍳10)
∆drop∆015_TEST←'drop∆R1' MK∆T2 ¯1 ⍬
∆drop∆016_TEST←'drop∆R1' MK∆T2 1 (÷1+5 5⍴⍳5)
∆drop∆017_TEST←'drop∆R1' MK∆T2 3 (÷1+⍳10)
∆drop∆018_TEST←'drop∆R2' MK∆T2 (5 7) (÷1+⍳35)
∆drop∆019_TEST←'drop∆R1' MK∆T2 5 (÷1+5 5⍴⍳5)
∆drop∆020_TEST←'drop∆R1' MK∆T2 6 (÷1+5 5⍴⍳5)
∆drop∆021_TEST←'drop∆R1' MK∆T2 ¯1 (÷1+5 5⍴⍳5)
∆drop∆022_TEST←'drop∆R1' MK∆T2 ¯5 (÷1+5 5⍴⍳5)
∆drop∆023_TEST←'drop∆R1' MK∆T2 ¯20 (÷1+5 5⍴⍳5)
∆drop∆024_TEST←'drop∆R1' MK∆T2 ¯20 (÷1+⍳10)
∆drop∆025_TEST←'drop∆R1' MK∆T2 ¯3 (÷1+⍳10)
∆drop∆026_TEST←'drop∆R2' MK∆T2 (F 7 1) (5 5⍴⍳5)
∆drop∆027_TEST←'drop∆R2' MK∆T2 (F 7 3) (⍳10)
∆drop∆028_TEST←'drop∆R2' MK∆T2 (F 7 5) (⍳35)
∆drop∆029_TEST←'drop∆R2' MK∆T2 (F 7 5) (5 5⍴⍳5)
∆drop∆030_TEST←'drop∆R2' MK∆T2 (F 7 6) (5 5⍴⍳5)
∆drop∆031_TEST←'drop∆R2' MK∆T2 (F 7 ¯1) (5 5⍴⍳5)
∆drop∆032_TEST←'drop∆R2' MK∆T2 (F 7 ¯5) (5 5⍴⍳5)
∆drop∆033_TEST←'drop∆R2' MK∆T2 (F 7 ¯20) (5 5⍴⍳5)
∆drop∆034_TEST←'drop∆R2' MK∆T2 (F 7 ¯20) (⍳10)
∆drop∆035_TEST←'drop∆R2' MK∆T2 (F 7 ¯3) (⍳10)
∆drop∆036_TEST←'drop∆R2' MK∆T2 (F 7 ¯1) ⍬
∆drop∆037_TEST←'drop∆R2' MK∆T2 (F 7 1) ⍬
∆drop∆038_TEST←'drop∆R2' MK∆T2 (F 7 1) (÷1+5 5⍴⍳5)
∆drop∆039_TEST←'drop∆R2' MK∆T2 (F 7 3) (÷1+⍳10)
∆drop∆040_TEST←'drop∆R2' MK∆T2 (F 7 5) (÷1+⍳35)
∆drop∆041_TEST←'drop∆R2' MK∆T2 (F 7 5) (÷1+5 5⍴⍳5)
∆drop∆042_TEST←'drop∆R2' MK∆T2 (F 7 6) (÷1+5 5⍴⍳5)
∆drop∆043_TEST←'drop∆R2' MK∆T2 (F 7 ¯1) (÷1+5 5⍴⍳5)
∆drop∆044_TEST←'drop∆R2' MK∆T2 (F 7 ¯5) (÷1+5 5⍴⍳5)
∆drop∆045_TEST←'drop∆R2' MK∆T2 (F 7 ¯20) (÷1+5 5⍴⍳5)
∆drop∆046_TEST←'drop∆R2' MK∆T2 (F 7 ¯20) (÷1+⍳10)
∆drop∆047_TEST←'drop∆R2' MK∆T2 (F 7 ¯3) (÷1+⍳10)
∆drop∆048_TEST←'drop∆R1' MK∆T2 ¯7 (0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆049_TEST←'drop∆R1' MK∆T2 ¯7 (0 1 0 1 0 0)
∆drop∆050_TEST←'drop∆R1' MK∆T2 ¯7 (3 10⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆051_TEST←'drop∆R1' MK∆T2 ¯7 (128⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆052_TEST←'drop∆R1' MK∆T2 ¯7 (100⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆053_TEST←'drop∆R1' MK∆T2 ¯7 (3 30⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆054_TEST←'drop∆R1' MK∆T2 ¯7 (30 30⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆055_TEST←'drop∆R1' MK∆T2 7 (0 1 0 1 0 0)
∆drop∆056_TEST←'drop∆R1' MK∆T2 64 (64⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆057_TEST←'drop∆R1' MK∆T2 64 (128⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆058_TEST←'drop∆R1' MK∆T2 64 (192⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆059_TEST←'drop∆R1' MK∆T2 7 (70⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆060_TEST←'drop∆R1' MK∆T2 7 (0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆061_TEST←'drop∆R1' MK∆T2 7 (3 30⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆062_TEST←'drop∆R1' MK∆T2 2 (4 32⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆063_TEST←'drop∆R1' MK∆T2 3 (4 32⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆064_TEST←'drop∆R2' MK∆T2 (F 7 ¯7) (0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆065_TEST←'drop∆R2' MK∆T2 (F 7 ¯7) (0 1 0 1 0 0)
∆drop∆066_TEST←'drop∆R2' MK∆T2 (F 7 ¯7) (3 10⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆067_TEST←'drop∆R2' MK∆T2 (F 7 ¯7) (128⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆068_TEST←'drop∆R2' MK∆T2 (F 7 ¯7) (100⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆069_TEST←'drop∆R2' MK∆T2 (F 7 ¯7) (3 30⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆070_TEST←'drop∆R2' MK∆T2 (F 7 ¯7) (30 30⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆071_TEST←'drop∆R2' MK∆T2 (F 7 7) (0 1 0 1 0 0)
∆drop∆072_TEST←'drop∆R2' MK∆T2 (F 7 64) (64⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆073_TEST←'drop∆R2' MK∆T2 (F 7 64) (128⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆074_TEST←'drop∆R2' MK∆T2 (F 7 64) (192⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆075_TEST←'drop∆R2' MK∆T2 (F 7 7) (70⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆076_TEST←'drop∆R2' MK∆T2 (F 7 7) (0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆077_TEST←'drop∆R2' MK∆T2 (F 7 7) (3 30⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆078_TEST←'drop∆R2' MK∆T2 (F 7 2) (4 32⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆079_TEST←'drop∆R2' MK∆T2 (F 7 3) (4 32⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆080_TEST←'drop∆R1' MK∆T2 (B 1) (5 5⍴⍳5)
∆drop∆081_TEST←'drop∆R1' MK∆T2 (B 1) (⍳10)
∆drop∆082_TEST←'drop∆R1' MK∆T2 (B 1) (⍳35)
∆drop∆083_TEST←'drop∆R1' MK∆T2 (B 0) (⍳35)
∆drop∆084_TEST←'drop∆R1' MK∆T2 (B 1) ⍬
∆drop∆085_TEST←'drop∆R1' MK∆T2 (B 0) ⍬
∆drop∆086_TEST←'drop∆R1' MK∆T2 (B 0) (5 5⍴⍳5)
∆drop∆087_TEST←'drop∆R1' MK∆T2 (B 0) (⍳10)
∆drop∆088_TEST←'drop∆R1' MK∆T2 (B 1) (÷1+5 5⍴⍳5)
∆drop∆089_TEST←'drop∆R1' MK∆T2 (B 1) (÷1+⍳10)
∆drop∆090_TEST←'drop∆R1' MK∆T2 (B 0) (÷1+⍳35)
∆drop∆091_TEST←'drop∆R1' MK∆T2 (B 0) (÷1+5 5⍴⍳5)
∆drop∆092_TEST←'drop∆R1' MK∆T2 (B 1) (0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆093_TEST←'drop∆R1' MK∆T2 (B 0) (0 1 0 1 0 0)
∆drop∆094_TEST←'drop∆R1' MK∆T2 (B 1) (3 10⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆095_TEST←'drop∆R1' MK∆T2 (B 0) (128⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆096_TEST←'drop∆R3' MK∆T1 (6 5⍴⍳5)
∆drop∆097_TEST←'drop∆R3' MK∆T1 (⍳10)
∆drop∆098_TEST←'drop∆R3' MK∆T1 (⍳35)
∆drop∆099_TEST←'drop∆R3' MK∆T1 (0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆100_TEST←'drop∆R3' MK∆T1 (0 1 0 1)
∆drop∆101_TEST←'drop∆R3' MK∆T1 ⍬
∆drop∆102_TEST←'drop∆R3' MK∆T1 (3 10⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
∆drop∆103_TEST←'drop∆R3' MK∆T1 (5 5⍴⍳5)
∆drop∆104_TEST←'drop∆R3' MK∆T1 (3 5⍴⍳5)
∆drop∆105_TEST←'drop∆R3' MK∆T1 (7 5⍴⍳5)
∆drop∆106_TEST←'drop∆R3' MK∆T1 (8 5⍴⍳5)
∆drop∆107_TEST←'drop∆R3' MK∆T1 (1 5⍴⍳5)
∆drop∆108_TEST←'drop∆R3' MK∆T1 (÷1+6 5⍴⍳5)
∆drop∆109_TEST←'drop∆R3' MK∆T1 (÷1+⍳10)
∆drop∆110_TEST←'drop∆R3' MK∆T1 (÷1+⍳35)
∆drop∆111_TEST←'drop∆R3' MK∆T1 (÷1+5 5⍴⍳5)
∆drop∆112_TEST←'drop∆R3' MK∆T1 (÷1+3 5⍴⍳5)
∆drop∆113_TEST←'drop∆R3' MK∆T1 (÷1+7 5⍴⍳5)
∆drop∆114_TEST←'drop∆R3' MK∆T1 (÷1+8 5⍴⍳5)
∆drop∆115_TEST←'drop∆R3' MK∆T1 (÷1+1 5⍴⍳5)
∆drop∆116_TEST←'drop∆R1' MK∆T2 (¯2 2) (5 5 3⍴⍳75)
∆drop∆117_TEST←'drop∆R1' MK∆T2 (25) (⍳12)
∆drop∆118_TEST←'drop∆R1' MK∆T2 (10 10) (5 5⍴⍳25)
∆drop∆119_TEST←'drop∆R1' MK∆T2 (10 10) (5)
∆drop∆120_TEST←'drop∆R1' MK∆T2 (10) (5)
∆drop∆121_TEST←'drop∆R1' MK∆T2 (2 5 5) (3 3 3⍴⍳27)
∆drop∆122_TEST←'drop∆R1' MK∆T2 (2 ¯5 5) (3 3 3⍴⍳27)

 ∆∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
