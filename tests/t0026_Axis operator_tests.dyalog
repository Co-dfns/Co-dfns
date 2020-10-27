:Require file://t0026.dyalog
:Namespace t0026_tests

 tn←'t0026' ⋄ cn←'c0026'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆000_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0026←tn #.codfns.Fix ⎕SRC dy}

 ∆001_TEST←{#.UT.expect←'SYNTAX ERROR' ⋄ 2::'SYNTAX ERROR'
  code←':Namespace' 'f←{(⍳5)+[]⍳5}' ':EndNamespace'
  'Successful compile'⊣'t0026_a'#.codfns.Fix code}

 ∆002_TEST←{A←0       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆003_TEST←{A←0       ⋄ X←5 3⍴⍳15      ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆004_TEST←{A←0       ⋄ X←5 3 3⍴⍳45    ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆005_TEST←{A←0       ⋄ X←5 2 3 3⍴⍳90  ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆006_TEST←{A←1       ⋄ X←3 5⍴⍳15      ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆007_TEST←{A←1       ⋄ X←3 5 3⍴⍳45    ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆008_TEST←{A←1       ⋄ X←2 5 3 3⍴⍳90  ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆009_TEST←{A←2       ⋄ X←3 3 5⍴⍳45    ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆010_TEST←{A←2       ⋄ X←2 3 5 3⍴⍳90  ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆011_TEST←{A←3       ⋄ X←2 3 3 5⍴⍳90  ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆012_TEST←{A←⍬       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f0 X ⋄ A cd.f0 X}
 ∆013_TEST←{A←⍬       ⋄ X←5 3⍴⍳15      ⋄ #.UT.expect←A dy.f0 X ⋄ A cd.f0 X}
 ∆014_TEST←{A←⍬       ⋄ X←5 3 3⍴⍳45    ⋄ #.UT.expect←A dy.f0 X ⋄ A cd.f0 X}
 ∆015_TEST←{A←⍬       ⋄ X←5 2 3 3⍴⍳90  ⋄ #.UT.expect←A dy.f0 X ⋄ A cd.f0 X}
 ∆016_TEST←{A←1       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f2 X ⋄ A cd.f2 X}
 ∆017_TEST←{A←1 0     ⋄ X←5 2⍴⍳15      ⋄ #.UT.expect←⍉(2 5⍴⍳10)-⍉X ⋄ A cd.f2 X}
 ∆018_TEST←{A←2 0     ⋄ X←5 3 2⍴⍳45    ⋄ #.UT.expect←A dy.f2 X ⋄ A cd.f2 X}
 ∆019_TEST←{A←1 0     ⋄ X←5 2 3 3⍴⍳90  ⋄ #.UT.expect←A dy.f2 X ⋄ A cd.f2 X}
 ∆020_TEST←{A←2       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f3 X ⋄ A cd.f3 X}
 ∆021_TEST←{A←2 1     ⋄ X←5 3⍴⍳15      ⋄ #.UT.expect←A dy.f3 X ⋄ A cd.f3 X}
 ∆022_TEST←{A←2 1 0   ⋄ X←5 3 2⍴⍳45    ⋄ #.UT.expect←⍉(2 3 5⍴⍳30)-⍉X ⋄ A cd.f3 X}
 ∆023_TEST←{A←1 3 0   ⋄ X←5 2 6 3⍴⍳180 ⋄ #.UT.expect←A dy.f3 X ⋄ A cd.f3 X}
 ∆024_TEST←{A←2       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f4 X ⋄ A cd.f4 X}
 ∆025_TEST←{A←2 1     ⋄ X←5 3⍴⍳15      ⋄ #.UT.expect←A dy.f4 X ⋄ A cd.f4 X}
 ∆026_TEST←{A←2 1 0   ⋄ X←5 3 2⍴⍳45    ⋄ #.UT.expect←A dy.f4 X ⋄ A cd.f4 X}
 ∆027_TEST←{A←1 3 0 2 ⋄ X←5 2 6 3⍴⍳180 ⋄
  #.UT.expect←1 3 0 2⍉(2 3 5 6⍴⍳180)-2 0 3 1⍉X ⋄ A cd.f4 X}

 ∆028_TEST←{A←⍬   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rev0 ⍳5}
 ∆029_TEST←{A←0 1 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rev0 2 5⍴⍳10}
 ∆030_TEST←{A←1   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rev0 ⍳20}
 ∆031_TEST←{A←0.5 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rev0 ⍳20}
 ∆032_TEST←{A←0   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rev0 0}

 ∆033_TEST←{A←0 ⋄ X←⍳20          ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆034_TEST←{A←0 ⋄ X←2 10⍴⍳20     ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆035_TEST←{A←0 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆036_TEST←{A←0 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆037_TEST←{A←1 ⋄ X←2 10⍴⍳20     ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆038_TEST←{A←1 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆039_TEST←{A←1 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆040_TEST←{A←2 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆041_TEST←{A←2 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆042_TEST←{A←3 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}

 ∆043_TEST←{A←⍬   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rev1 ⍳5}
 ∆044_TEST←{A←0 1 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rev1 2 5⍴⍳10}
 ∆045_TEST←{A←1   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rev1 ⍳20}
 ∆046_TEST←{A←0.5 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rev1 ⍳20}
 ∆047_TEST←{A←0   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rev1 0}

 ∆048_TEST←{A←0 ⋄ X←⍳20          ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆049_TEST←{A←0 ⋄ X←2 10⍴⍳20     ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆050_TEST←{A←0 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆051_TEST←{A←0 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆052_TEST←{A←1 ⋄ X←2 10⍴⍳20     ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆053_TEST←{A←1 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆054_TEST←{A←1 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆055_TEST←{A←2 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆056_TEST←{A←2 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆057_TEST←{A←3 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}

 ∆058_TEST←{A←1       ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 ⍳5}
 ∆059_TEST←{A←0       ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 5}
 ∆060_TEST←{A←1       ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 ⍳5}
 ∆061_TEST←{A←0 1 2   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 2 3⍴⍳6}
 ∆062_TEST←{A←0 2     ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rav0 2 3 5⍴⍳30}
 ∆063_TEST←{A←1.5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 ⍳5}
 ∆064_TEST←{A←0.5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 5}
 ∆065_TEST←{A←2.5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 2 3⍴⍳6}
 ∆066_TEST←{A←0.5 0.5 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rav0 ⍳5}
 ∆067_TEST←{A←1 2⍴⍳2  ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 2 3⍴⍳5}
 ∆068_TEST←{A←⍬       ⋄ #.UT.expect←x←'NONCE ERROR'  ⋄ 16::x ⋄ A cd.rav0 1 2 3 4⍴⍳24}
 ∆069_TEST←{A←1 0 1⍴0 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 ⍳5}
 ∆070_TEST←{A←1 1 1⍴0 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rav0 ⍳5}
 ∆071_TEST←{A←¯1 0    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rav0 ⍳5}

 ∆072_TEST←{A←0       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆073_TEST←{A←0       ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆074_TEST←{A←1       ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆075_TEST←{A←0       ⋄ X←1 2 3⍴⍳6     ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆076_TEST←{A←1       ⋄ X←1 2 3⍴⍳6     ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆077_TEST←{A←2       ⋄ X←1 2 3⍴⍳6     ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆078_TEST←{A←⍬       ⋄ X←0            ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆079_TEST←{A←⍬       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆080_TEST←{A←⍬       ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆081_TEST←{A←⍬       ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆082_TEST←{A←¯0.5    ⋄ X←0            ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆083_TEST←{A←¯0.5    ⋄ X←⍳5           ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆084_TEST←{A← 0.5    ⋄ X←⍳5           ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆085_TEST←{A←¯0.5    ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆086_TEST←{A← 0.5    ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆087_TEST←{A← 1.5    ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆088_TEST←{A←¯0.5    ⋄ X←2 3 5⍴⍳6     ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆089_TEST←{A← 0.5    ⋄ X←2 3 5⍴⍳6     ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆090_TEST←{A← 1.5    ⋄ X←2 3 5⍴⍳6     ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆091_TEST←{A← 2.5    ⋄ X←2 3 5⍴⍳6     ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆092_TEST←{A←0 1     ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆093_TEST←{A←1 2     ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆094_TEST←{A←0 1 2   ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆095_TEST←{A←0 1     ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆096_TEST←{A←1 2     ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆097_TEST←{A←2 3     ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆098_TEST←{A←0 1 2   ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆099_TEST←{A←1 2 3   ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}
 ∆100_TEST←{A←0 1 2 3 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.rav0 X ⋄ A cd.rav0 X}

 ∆101_TEST←{A←  ⍬ ⋄ X←1    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.red0 X}
 ∆102_TEST←{A← ¯1 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.red0 X}
 ∆103_TEST←{A←  0 ⋄ X←1    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.red0 X}
 ∆104_TEST←{A←0.5 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.red0 X}
 ∆105_TEST←{A←0 ⋄ X←0 0 0  ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.red1 X}
 ∆106_TEST←{A←0 ⋄ X←1 5⍴⍳5 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.red1 X}

 ∆107_TEST←{A←0 ⋄ X←⍳5         ⋄ #.UT.expect←A dy.red1 X ⋄ A cd.red1 X}
 ∆108_TEST←{A←0 ⋄ X←2|⍳5       ⋄ #.UT.expect←A dy.red1 X ⋄ A cd.red1 X}
 ∆109_TEST←{A←0 ⋄ X←(-2|⍳5)×⍳5 ⋄ #.UT.expect←A dy.red1 X ⋄ A cd.red1 X}
 ∆110_TEST←{A←0 ⋄ X←⍳2         ⋄ #.UT.expect←A dy.red2 X ⋄ A cd.red2 X}
 ∆111_TEST←{A←0 ⋄ X←2|⍳2       ⋄ #.UT.expect←A dy.red2 X ⋄ A cd.red2 X}
 ∆112_TEST←{A←0 ⋄ X←(-2|⍳2)×⍳2 ⋄ #.UT.expect←A dy.red2 X ⋄ A cd.red2 X}
 ∆113_TEST←{A←1 ⋄ X←⍳3         ⋄ #.UT.expect←A dy.red2 X ⋄ A cd.red2 X}
 ∆114_TEST←{A←1 ⋄ X←2|⍳3       ⋄ #.UT.expect←A dy.red2 X ⋄ A cd.red2 X}
 ∆115_TEST←{A←1 ⋄ X←(-2|⍳3)×⍳3 ⋄ #.UT.expect←A dy.red2 X ⋄ A cd.red2 X}
 ∆116_TEST←{A←0 ⋄ X←⍳2         ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆117_TEST←{A←0 ⋄ X←2|⍳2       ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆118_TEST←{A←0 ⋄ X←(-2|⍳2)×⍳2 ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆119_TEST←{A←1 ⋄ X←⍳3         ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆120_TEST←{A←1 ⋄ X←2|⍳3       ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆121_TEST←{A←1 ⋄ X←(-2|⍳3)×⍳3 ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆122_TEST←{A←2 ⋄ X←⍳4         ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆123_TEST←{A←2 ⋄ X←2|⍳4       ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆124_TEST←{A←2 ⋄ X←(-2|⍳4)×⍳4 ⋄ #.UT.expect←A dy.red3 X ⋄ A cd.red3 X}
 ∆125_TEST←{A←0 ⋄ X←⍳2         ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆126_TEST←{A←0 ⋄ X←2|⍳2       ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆127_TEST←{A←0 ⋄ X←(-2|⍳2)×⍳2 ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆128_TEST←{A←1 ⋄ X←⍳3         ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆129_TEST←{A←1 ⋄ X←2|⍳3       ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆130_TEST←{A←1 ⋄ X←(-2|⍳3)×⍳3 ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆131_TEST←{A←2 ⋄ X←⍳4         ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆132_TEST←{A←2 ⋄ X←2|⍳4       ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆133_TEST←{A←2 ⋄ X←(-2|⍳4)×⍳4 ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆134_TEST←{A←3 ⋄ X←⍳5         ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆135_TEST←{A←3 ⋄ X←2|⍳5       ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆136_TEST←{A←3 ⋄ X←(-2|⍳5)×⍳5 ⋄ #.UT.expect←A dy.red4 X ⋄ A cd.red4 X}
 ∆137_TEST←{A←0 ⋄ X←⍳5         ⋄ #.UT.expect←A dy.red5 X ⋄ A cd.red5 X}
 ∆138_TEST←{A←0 ⋄ X←2|⍳5       ⋄ #.UT.expect←A dy.red5 X ⋄ A cd.red5 X}
 ∆139_TEST←{A←0 ⋄ X←(-2|⍳5)×⍳5 ⋄ #.UT.expect←A dy.red5 X ⋄ A cd.red5 X}

 ∆140_TEST←{A←  ⍬ ⋄ X←1    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rdf0 X}
 ∆141_TEST←{A← ¯1 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rdf0 X}
 ∆142_TEST←{A←  0 ⋄ X←1    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rdf0 X}
 ∆143_TEST←{A←0.5 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rdf0 X}
 ∆144_TEST←{A←0 ⋄ X←0 0 0  ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rdf1 X}
 ∆145_TEST←{A←0 ⋄ X←1 5⍴⍳5 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rdf1 X}

 ∆146_TEST←{A←0 ⋄ X←⍳5         ⋄ #.UT.expect←A dy.rdf1 X ⋄ A cd.rdf1 X}
 ∆147_TEST←{A←0 ⋄ X←2|⍳5       ⋄ #.UT.expect←A dy.rdf1 X ⋄ A cd.rdf1 X}
 ∆148_TEST←{A←0 ⋄ X←(-2|⍳5)×⍳5 ⋄ #.UT.expect←A dy.rdf1 X ⋄ A cd.rdf1 X}
 ∆149_TEST←{A←0 ⋄ X←⍳2         ⋄ #.UT.expect←A dy.rdf2 X ⋄ A cd.rdf2 X}
 ∆150_TEST←{A←0 ⋄ X←2|⍳2       ⋄ #.UT.expect←A dy.rdf2 X ⋄ A cd.rdf2 X}
 ∆151_TEST←{A←0 ⋄ X←(-2|⍳2)×⍳2 ⋄ #.UT.expect←A dy.rdf2 X ⋄ A cd.rdf2 X}
 ∆152_TEST←{A←1 ⋄ X←⍳3         ⋄ #.UT.expect←A dy.rdf2 X ⋄ A cd.rdf2 X}
 ∆153_TEST←{A←1 ⋄ X←2|⍳3       ⋄ #.UT.expect←A dy.rdf2 X ⋄ A cd.rdf2 X}
 ∆154_TEST←{A←1 ⋄ X←(-2|⍳3)×⍳3 ⋄ #.UT.expect←A dy.rdf2 X ⋄ A cd.rdf2 X}
 ∆155_TEST←{A←0 ⋄ X←⍳2         ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆156_TEST←{A←0 ⋄ X←2|⍳2       ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆157_TEST←{A←0 ⋄ X←(-2|⍳2)×⍳2 ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆158_TEST←{A←1 ⋄ X←⍳3         ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆159_TEST←{A←1 ⋄ X←2|⍳3       ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆160_TEST←{A←1 ⋄ X←(-2|⍳3)×⍳3 ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆161_TEST←{A←2 ⋄ X←⍳4         ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆162_TEST←{A←2 ⋄ X←2|⍳4       ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆163_TEST←{A←2 ⋄ X←(-2|⍳4)×⍳4 ⋄ #.UT.expect←A dy.rdf3 X ⋄ A cd.rdf3 X}
 ∆164_TEST←{A←0 ⋄ X←⍳2         ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆165_TEST←{A←0 ⋄ X←2|⍳2       ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆166_TEST←{A←0 ⋄ X←(-2|⍳2)×⍳2 ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆167_TEST←{A←1 ⋄ X←⍳3         ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆168_TEST←{A←1 ⋄ X←2|⍳3       ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆169_TEST←{A←1 ⋄ X←(-2|⍳3)×⍳3 ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆170_TEST←{A←2 ⋄ X←⍳4         ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆171_TEST←{A←2 ⋄ X←2|⍳4       ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆172_TEST←{A←2 ⋄ X←(-2|⍳4)×⍳4 ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆173_TEST←{A←3 ⋄ X←⍳5         ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆174_TEST←{A←3 ⋄ X←2|⍳5       ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆175_TEST←{A←3 ⋄ X←(-2|⍳5)×⍳5 ⋄ #.UT.expect←A dy.rdf4 X ⋄ A cd.rdf4 X}
 ∆176_TEST←{A←0 ⋄ X←⍳5         ⋄ #.UT.expect←A dy.rdf5 X ⋄ A cd.rdf5 X}
 ∆177_TEST←{A←0 ⋄ X←2|⍳5       ⋄ #.UT.expect←A dy.rdf5 X ⋄ A cd.rdf5 X}
 ∆178_TEST←{A←0 ⋄ X←(-2|⍳5)×⍳5 ⋄ #.UT.expect←A dy.rdf5 X ⋄ A cd.rdf5 X}

 ∆179_TEST←{A←  ⍬ ⋄ X←1    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.scn0 X}
 ∆180_TEST←{A← ¯1 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.scn0 X}
 ∆181_TEST←{A←  0 ⋄ X←1    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.scn0 X}
 ∆182_TEST←{A←0.5 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.scn0 X}
 ∆183_TEST←{A←0 ⋄ X←0 0 0  ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.scn1 X}
 ∆184_TEST←{A←0 ⋄ X←1 5⍴⍳5 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.scn1 X}

 ∆185_TEST←{A←0 ⋄ X←1+⍳5           ⋄ #.UT.expect←A dy.scn1 X ⋄ A cd.scn1 X}
 ∆186_TEST←{A←0 ⋄ X←2|⍳10          ⋄ #.UT.expect←A dy.scn1 X ⋄ A cd.scn1 X}
 ∆187_TEST←{A←0 ⋄ X←(¯1+3|⍳15)×⍳15 ⋄ #.UT.expect←A dy.scn1 X ⋄ A cd.scn1 X}
 ∆188_TEST←{A←0 ⋄ X←1+⍳2           ⋄ #.UT.expect←A dy.scn2 X ⋄ A cd.scn2 X}
 ∆189_TEST←{A←0 ⋄ X←2|⍳4           ⋄ #.UT.expect←A dy.scn2 X ⋄ A cd.scn2 X}
 ∆190_TEST←{A←0 ⋄ X←(¯1+3|⍳6)×⍳6   ⋄ #.UT.expect←A dy.scn2 X ⋄ A cd.scn2 X}
 ∆191_TEST←{A←1 ⋄ X←1+⍳3           ⋄ #.UT.expect←A dy.scn2 X ⋄ A cd.scn2 X}
 ∆192_TEST←{A←1 ⋄ X←2|⍳6           ⋄ #.UT.expect←A dy.scn2 X ⋄ A cd.scn2 X}
 ∆193_TEST←{A←1 ⋄ X←(¯1+3|⍳9)×⍳9   ⋄ #.UT.expect←A dy.scn2 X ⋄ A cd.scn2 X}
 ∆194_TEST←{A←0 ⋄ X←1+⍳2           ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆195_TEST←{A←0 ⋄ X←2|⍳4           ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆196_TEST←{A←0 ⋄ X←(¯1+3|⍳6)×⍳6   ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆197_TEST←{A←1 ⋄ X←1+⍳3           ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆198_TEST←{A←1 ⋄ X←2|⍳6           ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆199_TEST←{A←1 ⋄ X←(¯1+3|⍳9)×⍳9   ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆200_TEST←{A←2 ⋄ X←1+⍳4           ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆201_TEST←{A←2 ⋄ X←2|⍳8           ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆202_TEST←{A←2 ⋄ X←(¯1+3|⍳12)×⍳12 ⋄ #.UT.expect←A dy.scn3 X ⋄ A cd.scn3 X}
 ∆203_TEST←{A←0 ⋄ X←1+⍳2           ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆204_TEST←{A←0 ⋄ X←2|⍳4           ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆205_TEST←{A←0 ⋄ X←(¯1+3|⍳6)×⍳6   ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆206_TEST←{A←1 ⋄ X←1+⍳3           ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆207_TEST←{A←1 ⋄ X←2|⍳6           ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆208_TEST←{A←1 ⋄ X←(¯1+3|⍳9)×⍳9   ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆209_TEST←{A←2 ⋄ X←1+⍳4           ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆210_TEST←{A←2 ⋄ X←2|⍳8           ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆211_TEST←{A←2 ⋄ X←(¯1+3|⍳12)×⍳12 ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆212_TEST←{A←3 ⋄ X←1+⍳5           ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆213_TEST←{A←3 ⋄ X←2|⍳10          ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆214_TEST←{A←3 ⋄ X←(¯1+3|⍳15)×⍳15 ⋄ #.UT.expect←A dy.scn4 X ⋄ A cd.scn4 X}
 ∆215_TEST←{A←0 ⋄ X←1+⍳5           ⋄ #.UT.expect←A dy.scn5 X ⋄ A cd.scn5 X}
 ∆216_TEST←{A←0 ⋄ X←2|⍳10          ⋄ #.UT.expect←A dy.scn5 X ⋄ A cd.scn5 X}
 ∆217_TEST←{A←0 ⋄ X←(¯1+3|⍳15)×⍳15 ⋄ #.UT.expect←A dy.scn5 X ⋄ A cd.scn5 X}

 ∆218_TEST←{A←  ⍬ ⋄ X←1    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.scf0 X}
 ∆219_TEST←{A← ¯1 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.scf0 X}
 ∆220_TEST←{A←  0 ⋄ X←1    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.scf0 X}
 ∆221_TEST←{A←0.5 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.scf0 X}
 ∆222_TEST←{A←0 ⋄ X←0 0 0  ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.scf1 X}
 ∆223_TEST←{A←0 ⋄ X←1 5⍴⍳5 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.scf1 X}

 ∆224_TEST←{A←0 ⋄ X←1+⍳5           ⋄ #.UT.expect←A dy.scf1 X ⋄ A cd.scf1 X}
 ∆225_TEST←{A←0 ⋄ X←2|⍳10          ⋄ #.UT.expect←A dy.scf1 X ⋄ A cd.scf1 X}
 ∆226_TEST←{A←0 ⋄ X←(¯1+3|⍳15)×⍳15 ⋄ #.UT.expect←A dy.scf1 X ⋄ A cd.scf1 X}
 ∆227_TEST←{A←0 ⋄ X←1+⍳2           ⋄ #.UT.expect←A dy.scf2 X ⋄ A cd.scf2 X}
 ∆228_TEST←{A←0 ⋄ X←2|⍳4           ⋄ #.UT.expect←A dy.scf2 X ⋄ A cd.scf2 X}
 ∆229_TEST←{A←0 ⋄ X←(¯1+3|⍳6)×⍳6   ⋄ #.UT.expect←A dy.scf2 X ⋄ A cd.scf2 X}
 ∆230_TEST←{A←1 ⋄ X←1+⍳3           ⋄ #.UT.expect←A dy.scf2 X ⋄ A cd.scf2 X}
 ∆231_TEST←{A←1 ⋄ X←2|⍳6           ⋄ #.UT.expect←A dy.scf2 X ⋄ A cd.scf2 X}
 ∆232_TEST←{A←1 ⋄ X←(¯1+3|⍳9)×⍳9   ⋄ #.UT.expect←A dy.scf2 X ⋄ A cd.scf2 X}
 ∆233_TEST←{A←0 ⋄ X←1+⍳2           ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆234_TEST←{A←0 ⋄ X←2|⍳4           ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆235_TEST←{A←0 ⋄ X←(¯1+3|⍳6)×⍳6   ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆236_TEST←{A←1 ⋄ X←1+⍳3           ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆237_TEST←{A←1 ⋄ X←2|⍳6           ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆238_TEST←{A←1 ⋄ X←(¯1+3|⍳9)×⍳9   ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆239_TEST←{A←2 ⋄ X←1+⍳4           ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆240_TEST←{A←2 ⋄ X←2|⍳8           ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆241_TEST←{A←2 ⋄ X←(¯1+3|⍳12)×⍳12 ⋄ #.UT.expect←A dy.scf3 X ⋄ A cd.scf3 X}
 ∆242_TEST←{A←0 ⋄ X←1+⍳2           ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆243_TEST←{A←0 ⋄ X←2|⍳4           ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆244_TEST←{A←0 ⋄ X←(¯1+3|⍳6)×⍳6   ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆245_TEST←{A←1 ⋄ X←1+⍳3           ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆246_TEST←{A←1 ⋄ X←2|⍳6           ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆247_TEST←{A←1 ⋄ X←(¯1+3|⍳9)×⍳9   ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆248_TEST←{A←2 ⋄ X←1+⍳4           ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆249_TEST←{A←2 ⋄ X←2|⍳8           ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆250_TEST←{A←2 ⋄ X←(¯1+3|⍳12)×⍳12 ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆251_TEST←{A←3 ⋄ X←1+⍳5           ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆252_TEST←{A←3 ⋄ X←2|⍳10          ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆253_TEST←{A←3 ⋄ X←(¯1+3|⍳15)×⍳15 ⋄ #.UT.expect←A dy.scf4 X ⋄ A cd.scf4 X}
 ∆254_TEST←{A←0 ⋄ X←1+⍳5           ⋄ #.UT.expect←A dy.scf5 X ⋄ A cd.scf5 X}
 ∆255_TEST←{A←0 ⋄ X←2|⍳10          ⋄ #.UT.expect←A dy.scf5 X ⋄ A cd.scf5 X}
 ∆256_TEST←{A←0 ⋄ X←(¯1+3|⍳15)×⍳15 ⋄ #.UT.expect←A dy.scf5 X ⋄ A cd.scf5 X}

 ∆257_TEST←{A←  ⍬ ⋄ X←1    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rot0 X}
 ∆258_TEST←{A← ¯1 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rot0 X}
 ∆259_TEST←{A←  0 ⋄ X←1    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rot0 X}
 ∆260_TEST←{A←0.5 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rot0 X}
 ∆261_TEST←{A←0 ⋄ X←0 0 0  ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rot1 X}
 ∆262_TEST←{A←0 ⋄ X←1 5⍴⍳5 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rot1 X}
 ∆263_TEST←{A←0 ⋄ X←1 3⍴⍳3 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rot2 X}
 ∆264_TEST←{A←0 ⋄ X←1 3⍴⍳3 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rot2 X}
 ∆265_TEST←{A←0 ⋄ X←2⍴⍳2   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rot2 X}
 ∆266_TEST←{A←1 ⋄ X←2⍴⍳2   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rot3 X}
 ∆267_TEST←{A←1 ⋄ X←2 3⍴⍳6 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rot3 X}
 ∆268_TEST←{A←1 ⋄ X←2⍴⍳2   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rot3 X}

 ∆269_TEST←{A←0 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆270_TEST←{A←0 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆271_TEST←{A←0 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆272_TEST←{A←0 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆273_TEST←{A←0 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆274_TEST←{A←0 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆275_TEST←{A←0 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆276_TEST←{A←0 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆277_TEST←{A←0 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆278_TEST←{A←0 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆279_TEST←{A←0 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆280_TEST←{A←0 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆281_TEST←{A←0 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆282_TEST←{A←0 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot1 X ⋄ A cd.rot1 X}
 ∆283_TEST←{A←0 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆284_TEST←{A←0 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆285_TEST←{A←0 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆286_TEST←{A←0 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆287_TEST←{A←0 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆288_TEST←{A←0 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆289_TEST←{A←0 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆290_TEST←{A←0 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆291_TEST←{A←0 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆292_TEST←{A←0 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆293_TEST←{A←0 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆294_TEST←{A←0 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆295_TEST←{A←0 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆296_TEST←{A←0 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆297_TEST←{A←0 ⋄ X← ⍳3        ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆298_TEST←{A←0 ⋄ X←-⍳3        ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆299_TEST←{A←1 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆300_TEST←{A←1 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆301_TEST←{A←1 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆302_TEST←{A←1 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆303_TEST←{A←1 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆304_TEST←{A←1 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆305_TEST←{A←1 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆306_TEST←{A←1 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆307_TEST←{A←1 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆308_TEST←{A←1 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆309_TEST←{A←1 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆310_TEST←{A←1 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆311_TEST←{A←1 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆312_TEST←{A←1 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆313_TEST←{A←1 ⋄ X← ⍳2        ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆314_TEST←{A←1 ⋄ X←-⍳2        ⋄ #.UT.expect←A dy.rot2 X ⋄ A cd.rot2 X}
 ∆315_TEST←{A←0 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆316_TEST←{A←0 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆317_TEST←{A←0 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆318_TEST←{A←0 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆319_TEST←{A←0 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆320_TEST←{A←0 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆321_TEST←{A←0 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆322_TEST←{A←0 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆323_TEST←{A←0 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆324_TEST←{A←0 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆325_TEST←{A←0 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆326_TEST←{A←0 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆327_TEST←{A←0 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆328_TEST←{A←0 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆330_TEST←{A←0 ⋄ X← 3 4⍴⍳12   ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆331_TEST←{A←0 ⋄ X←-3 4⍴⍳12   ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆332_TEST←{A←1 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆333_TEST←{A←1 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆334_TEST←{A←1 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆335_TEST←{A←1 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆336_TEST←{A←1 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆337_TEST←{A←1 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆338_TEST←{A←1 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆339_TEST←{A←1 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆340_TEST←{A←1 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆341_TEST←{A←1 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆342_TEST←{A←1 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆343_TEST←{A←1 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆344_TEST←{A←1 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆345_TEST←{A←1 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆348_TEST←{A←1 ⋄ X← 2 4⍴⍳8    ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆349_TEST←{A←1 ⋄ X←-2 4⍴⍳8    ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆350_TEST←{A←2 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆351_TEST←{A←2 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆352_TEST←{A←2 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆353_TEST←{A←2 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆354_TEST←{A←2 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆355_TEST←{A←2 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆356_TEST←{A←2 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆357_TEST←{A←2 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆358_TEST←{A←2 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆359_TEST←{A←2 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆360_TEST←{A←2 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆361_TEST←{A←2 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆362_TEST←{A←2 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆363_TEST←{A←2 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆366_TEST←{A←2 ⋄ X← 2 3⍴⍳6    ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆367_TEST←{A←2 ⋄ X←-2 3⍴⍳6    ⋄ #.UT.expect←A dy.rot3 X ⋄ A cd.rot3 X}
 ∆368_TEST←{A←0 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆369_TEST←{A←0 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆370_TEST←{A←0 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆371_TEST←{A←0 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆372_TEST←{A←0 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆373_TEST←{A←0 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆374_TEST←{A←0 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆375_TEST←{A←0 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆376_TEST←{A←0 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆377_TEST←{A←0 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆378_TEST←{A←0 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆379_TEST←{A←0 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆380_TEST←{A←0 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆381_TEST←{A←0 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆384_TEST←{A←0 ⋄ X← 3 4 5⍴⍳60 ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆385_TEST←{A←0 ⋄ X←-3 4 5⍴⍳60 ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆386_TEST←{A←1 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆387_TEST←{A←1 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆388_TEST←{A←1 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆389_TEST←{A←1 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆390_TEST←{A←1 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆391_TEST←{A←1 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆392_TEST←{A←1 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆393_TEST←{A←1 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆394_TEST←{A←1 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆395_TEST←{A←1 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆396_TEST←{A←1 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆397_TEST←{A←1 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆398_TEST←{A←1 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆399_TEST←{A←1 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆402_TEST←{A←1 ⋄ X← 2 4 5⍴⍳40 ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆403_TEST←{A←1 ⋄ X←-2 4 5⍴⍳40 ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆404_TEST←{A←2 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆405_TEST←{A←2 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆406_TEST←{A←2 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆407_TEST←{A←2 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆408_TEST←{A←2 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆409_TEST←{A←2 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆410_TEST←{A←2 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆411_TEST←{A←2 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆412_TEST←{A←2 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆413_TEST←{A←2 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆414_TEST←{A←2 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆415_TEST←{A←2 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆416_TEST←{A←2 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆417_TEST←{A←2 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆420_TEST←{A←2 ⋄ X← 2 3 5⍴⍳30 ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆421_TEST←{A←2 ⋄ X←-2 3 5⍴⍳30 ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆422_TEST←{A←3 ⋄ X← 0         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆423_TEST←{A←3 ⋄ X← 1         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆424_TEST←{A←3 ⋄ X← 2         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆425_TEST←{A←3 ⋄ X← 3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆426_TEST←{A←3 ⋄ X← 4         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆427_TEST←{A←3 ⋄ X← 5         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆428_TEST←{A←3 ⋄ X← 6         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆429_TEST←{A←3 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆430_TEST←{A←3 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆431_TEST←{A←3 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆432_TEST←{A←3 ⋄ X←,3         ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆433_TEST←{A←3 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆434_TEST←{A←3 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆435_TEST←{A←3 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆438_TEST←{A←3 ⋄ X← 2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}
 ∆439_TEST←{A←3 ⋄ X←-2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.rot4 X ⋄ A cd.rot4 X}

 ∆440_TEST←{A←  ⍬ ⋄ X←1    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rtf0 X}
 ∆441_TEST←{A← ¯1 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rtf0 X}
 ∆442_TEST←{A←  0 ⋄ X←1    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rtf0 X}
 ∆443_TEST←{A←0.5 ⋄ X←1    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rtf0 X}
 ∆444_TEST←{A←0 ⋄ X←0 0 0  ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rtf1 X}
 ∆445_TEST←{A←0 ⋄ X←1 5⍴⍳5 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rtf1 X}
 ∆446_TEST←{A←0 ⋄ X←1 3⍴⍳3 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rtf2 X}
 ∆447_TEST←{A←0 ⋄ X←1 3⍴⍳3 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rtf2 X}
 ∆448_TEST←{A←0 ⋄ X←2⍴⍳2   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rtf2 X}
 ∆449_TEST←{A←1 ⋄ X←2⍴⍳2   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rtf3 X}
 ∆450_TEST←{A←1 ⋄ X←2 3⍴⍳6 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rtf3 X}
 ∆451_TEST←{A←1 ⋄ X←2⍴⍳2   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rtf3 X}

 ∆452_TEST←{A←0 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆453_TEST←{A←0 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆454_TEST←{A←0 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆455_TEST←{A←0 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆456_TEST←{A←0 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆457_TEST←{A←0 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆458_TEST←{A←0 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆459_TEST←{A←0 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆460_TEST←{A←0 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆461_TEST←{A←0 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆462_TEST←{A←0 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆463_TEST←{A←0 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆464_TEST←{A←0 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆465_TEST←{A←0 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf1 X ⋄ A cd.rtf1 X}
 ∆466_TEST←{A←0 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆467_TEST←{A←0 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆468_TEST←{A←0 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆469_TEST←{A←0 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆470_TEST←{A←0 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆471_TEST←{A←0 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆472_TEST←{A←0 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆473_TEST←{A←0 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆474_TEST←{A←0 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆475_TEST←{A←0 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆476_TEST←{A←0 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆477_TEST←{A←0 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆478_TEST←{A←0 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆479_TEST←{A←0 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆480_TEST←{A←0 ⋄ X← ⍳3        ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆481_TEST←{A←0 ⋄ X←-⍳3        ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆482_TEST←{A←1 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆483_TEST←{A←1 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆484_TEST←{A←1 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆485_TEST←{A←1 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆486_TEST←{A←1 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆487_TEST←{A←1 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆488_TEST←{A←1 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆489_TEST←{A←1 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆490_TEST←{A←1 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆491_TEST←{A←1 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆492_TEST←{A←1 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆493_TEST←{A←1 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆494_TEST←{A←1 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆495_TEST←{A←1 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆496_TEST←{A←1 ⋄ X← ⍳2        ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆497_TEST←{A←1 ⋄ X←-⍳2        ⋄ #.UT.expect←A dy.rtf2 X ⋄ A cd.rtf2 X}
 ∆498_TEST←{A←0 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆499_TEST←{A←0 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆500_TEST←{A←0 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆501_TEST←{A←0 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆502_TEST←{A←0 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆503_TEST←{A←0 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆504_TEST←{A←0 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆505_TEST←{A←0 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆506_TEST←{A←0 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆507_TEST←{A←0 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆508_TEST←{A←0 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆509_TEST←{A←0 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆510_TEST←{A←0 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆511_TEST←{A←0 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆514_TEST←{A←0 ⋄ X← 3 4⍴⍳12   ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆515_TEST←{A←0 ⋄ X←-3 4⍴⍳12   ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆516_TEST←{A←1 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆517_TEST←{A←1 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆518_TEST←{A←1 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆519_TEST←{A←1 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆520_TEST←{A←1 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆521_TEST←{A←1 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆522_TEST←{A←1 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆523_TEST←{A←1 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆524_TEST←{A←1 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆525_TEST←{A←1 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆526_TEST←{A←1 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆527_TEST←{A←1 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆528_TEST←{A←1 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆529_TEST←{A←1 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆532_TEST←{A←1 ⋄ X← 2 4⍴⍳8    ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆533_TEST←{A←1 ⋄ X←-2 4⍴⍳8    ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆534_TEST←{A←2 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆535_TEST←{A←2 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆536_TEST←{A←2 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆537_TEST←{A←2 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆538_TEST←{A←2 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆539_TEST←{A←2 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆540_TEST←{A←2 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆541_TEST←{A←2 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆542_TEST←{A←2 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆543_TEST←{A←2 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆544_TEST←{A←2 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆545_TEST←{A←2 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆546_TEST←{A←2 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆547_TEST←{A←2 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆550_TEST←{A←2 ⋄ X← 2 3⍴⍳6    ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆551_TEST←{A←2 ⋄ X←-2 3⍴⍳6    ⋄ #.UT.expect←A dy.rtf3 X ⋄ A cd.rtf3 X}
 ∆552_TEST←{A←0 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆553_TEST←{A←0 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆554_TEST←{A←0 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆555_TEST←{A←0 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆556_TEST←{A←0 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆557_TEST←{A←0 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆558_TEST←{A←0 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆559_TEST←{A←0 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆560_TEST←{A←0 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆561_TEST←{A←0 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆562_TEST←{A←0 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆563_TEST←{A←0 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆564_TEST←{A←0 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆565_TEST←{A←0 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆568_TEST←{A←0 ⋄ X← 3 4 5⍴⍳60 ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆569_TEST←{A←0 ⋄ X←-3 4 5⍴⍳60 ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆570_TEST←{A←1 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆571_TEST←{A←1 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆572_TEST←{A←1 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆573_TEST←{A←1 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆574_TEST←{A←1 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆575_TEST←{A←1 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆576_TEST←{A←1 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆577_TEST←{A←1 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆578_TEST←{A←1 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆579_TEST←{A←1 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆580_TEST←{A←1 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆581_TEST←{A←1 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆582_TEST←{A←1 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆583_TEST←{A←1 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆586_TEST←{A←1 ⋄ X← 2 4 5⍴⍳40 ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆587_TEST←{A←1 ⋄ X←-2 4 5⍴⍳40 ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆588_TEST←{A←2 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆589_TEST←{A←2 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆590_TEST←{A←2 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆591_TEST←{A←2 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆592_TEST←{A←2 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆593_TEST←{A←2 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆594_TEST←{A←2 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆595_TEST←{A←2 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆596_TEST←{A←2 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆597_TEST←{A←2 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆598_TEST←{A←2 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆599_TEST←{A←2 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆600_TEST←{A←2 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆601_TEST←{A←2 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆604_TEST←{A←2 ⋄ X← 2 3 5⍴⍳30 ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆605_TEST←{A←2 ⋄ X←-2 3 5⍴⍳30 ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆606_TEST←{A←3 ⋄ X← 0         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆607_TEST←{A←3 ⋄ X← 1         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆608_TEST←{A←3 ⋄ X← 2         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆609_TEST←{A←3 ⋄ X← 3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆610_TEST←{A←3 ⋄ X← 4         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆611_TEST←{A←3 ⋄ X← 5         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆612_TEST←{A←3 ⋄ X← 6         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆613_TEST←{A←3 ⋄ X←¯1         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆614_TEST←{A←3 ⋄ X←¯2         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆615_TEST←{A←3 ⋄ X←¯3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆616_TEST←{A←3 ⋄ X←,3         ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆617_TEST←{A←3 ⋄ X←1 1⍴3      ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆618_TEST←{A←3 ⋄ X←1 1 1⍴3    ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆619_TEST←{A←3 ⋄ X←1 1 1 1⍴3  ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆622_TEST←{A←3 ⋄ X← 2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}
 ∆623_TEST←{A←3 ⋄ X←-2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.rtf4 X ⋄ A cd.rtf4 X}

 ∆624_TEST←{A←  ⍬ ⋄ X←1           ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat0 X}
 ∆625_TEST←{A←  0 ⋄ X←1           ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 X}
 ∆626_TEST←{A← ¯1 ⋄ X←1           ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.cat0 X}
 ∆627_TEST←{A←0.5 ⋄ X←1           ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 X}
 ∆628_TEST←{A←  0 ⋄ X←5 1⍴⍳5      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat1 X}
 ∆629_TEST←{A←  0 ⋄ X←1 3 4⍴⍳5    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat1 X}
 ∆630_TEST←{A←  0 ⋄ X←3 1⍴⍳3      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat2 X}
 ∆631_TEST←{A←  0 ⋄ X←⍳2          ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat2 X}
 ∆632_TEST←{A←  0 ⋄ X←2 3 1⍴⍳6    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat2 X}
 ∆633_TEST←{A←  0 ⋄ X←2 3 4 1⍴⍳12 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat2 X}
 ∆634_TEST←{A←  1 ⋄ X←1 3⍴⍳3      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat2 X}
 ∆635_TEST←{A←  1 ⋄ X←⍳3          ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat2 X}
 ∆636_TEST←{A←  1 ⋄ X←2 3 1⍴⍳6    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat2 X}
 ∆637_TEST←{A←  1 ⋄ X←2 3 4 1⍴⍳12 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat2 X}
 ∆638_TEST←{A←  0 ⋄ X←3 4 5⍴⍳60   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆639_TEST←{A←  0 ⋄ X←2 1⍴⍳2      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆640_TEST←{A←  0 ⋄ X←2 3 1 5⍴⍳30 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆641_TEST←{A←  0 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat3 X}
 ∆642_TEST←{A←  1 ⋄ X←3 4 5⍴⍳60   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆643_TEST←{A←  1 ⋄ X←1 3⍴⍳2      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆644_TEST←{A←  1 ⋄ X←2 3 1 5⍴⍳30 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆645_TEST←{A←  1 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat3 X}
 ∆646_TEST←{A←  2 ⋄ X←3 4 5⍴⍳60   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆647_TEST←{A←  2 ⋄ X←1 3⍴⍳2      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆648_TEST←{A←  2 ⋄ X←2 3 1 5⍴⍳30 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat3 X}
 ∆649_TEST←{A←  2 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat3 X}
 ∆650_TEST←{A←  0 ⋄ X←3 4 5 1⍴⍳60 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat4 X}
 ∆651_TEST←{A←  0 ⋄ X←2 3 1⍴⍳2    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat4 X}
 ∆652_TEST←{A←  0 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat4 X}
 ∆653_TEST←{A←  1 ⋄ X←3 4 5 1⍴⍳60 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat4 X}
 ∆654_TEST←{A←  1 ⋄ X←2 3 1⍴⍳2    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat4 X}
 ∆655_TEST←{A←  1 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat4 X}
 ∆656_TEST←{A←  2 ⋄ X←3 4 5 1⍴⍳60 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat4 X}
 ∆657_TEST←{A←  2 ⋄ X←2 3 1⍴⍳2    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat4 X}
 ∆658_TEST←{A←  2 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat4 X}
 ∆659_TEST←{A←  3 ⋄ X←3 4 5 1⍴⍳60 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat4 X}
 ∆660_TEST←{A←  3 ⋄ X←2 3 1⍴⍳2    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat4 X}
 ∆661_TEST←{A←  3 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat4 X}
 ∆662_TEST←{A←  0 ⋄ X←1 5⍴⍳5      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat5 X}
 ∆663_TEST←{A←  0 ⋄ X←3 1 4⍴⍳5    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat5 X}

 ∆664_TEST←{A←0 ⋄ X←5            ⋄ #.UT.expect←A dy.cat1 X ⋄ A cd.cat1 X}
 ∆665_TEST←{A←0 ⋄ X←⍳5           ⋄ #.UT.expect←A dy.cat1 X ⋄ A cd.cat1 X}
 ∆666_TEST←{A←0 ⋄ X←2 5⍴⍳10      ⋄ #.UT.expect←A dy.cat1 X ⋄ A cd.cat1 X}
 ∆667_TEST←{A←0 ⋄ X←5            ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆668_TEST←{A←0 ⋄ X←⍳3           ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆669_TEST←{A←0 ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆670_TEST←{A←0 ⋄ X←4 2 3⍴⍳24    ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆671_TEST←{A←1 ⋄ X←5            ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆672_TEST←{A←1 ⋄ X←⍳2           ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆673_TEST←{A←1 ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆674_TEST←{A←1 ⋄ X←2 4 3⍴⍳24    ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆675_TEST←{A←0 ⋄ X←5            ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆676_TEST←{A←0 ⋄ X←3 4⍴⍳6       ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆677_TEST←{A←0 ⋄ X←2 3 4⍴⍳24    ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆678_TEST←{A←0 ⋄ X←5 2 3 4⍴⍳120 ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆679_TEST←{A←1 ⋄ X←5            ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆680_TEST←{A←1 ⋄ X←2 4⍴⍳8       ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆681_TEST←{A←1 ⋄ X←2 3 4⍴⍳24    ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆682_TEST←{A←1 ⋄ X←2 5 3 4⍴⍳120 ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆683_TEST←{A←2 ⋄ X←5            ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆684_TEST←{A←2 ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆685_TEST←{A←2 ⋄ X←2 3 4⍴⍳24    ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆686_TEST←{A←2 ⋄ X←2 3 5 4⍴⍳120 ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆687_TEST←{A←0 ⋄ X←5            ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆688_TEST←{A←0 ⋄ X←3 4 5⍴⍳60    ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆689_TEST←{A←0 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆690_TEST←{A←1 ⋄ X←5            ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆691_TEST←{A←1 ⋄ X←2 4 5⍴⍳40    ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆692_TEST←{A←1 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆693_TEST←{A←2 ⋄ X←5            ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆694_TEST←{A←2 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆695_TEST←{A←2 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆696_TEST←{A←3 ⋄ X←5            ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆697_TEST←{A←3 ⋄ X←2 3 4⍴⍳24    ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}
 ∆698_TEST←{A←3 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat4 X ⋄ A cd.cat4 X}

 ∆699_TEST←{A←  ⍬ ⋄ X←1           ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf0 X}
 ∆700_TEST←{A←  0 ⋄ X←1           ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf0 X}
 ∆701_TEST←{A← ¯1 ⋄ X←1           ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.ctf0 X}
 ∆702_TEST←{A←0.5 ⋄ X←1           ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf0 X}
 ∆703_TEST←{A←  0 ⋄ X←5 1⍴⍳5      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf1 X}
 ∆704_TEST←{A←  0 ⋄ X←1 3 4⍴⍳5    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf1 X}
 ∆705_TEST←{A←  0 ⋄ X←3 1⍴⍳3      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf2 X}
 ∆706_TEST←{A←  0 ⋄ X←⍳2          ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf2 X}
 ∆707_TEST←{A←  0 ⋄ X←2 3 1⍴⍳6    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf2 X}
 ∆708_TEST←{A←  0 ⋄ X←2 3 4 1⍴⍳12 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf2 X}
 ∆709_TEST←{A←  1 ⋄ X←1 3⍴⍳3      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf2 X}
 ∆710_TEST←{A←  1 ⋄ X←⍳3          ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf2 X}
 ∆711_TEST←{A←  1 ⋄ X←2 3 1⍴⍳6    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf2 X}
 ∆712_TEST←{A←  1 ⋄ X←2 3 4 1⍴⍳12 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf2 X}
 ∆713_TEST←{A←  0 ⋄ X←3 4 5⍴⍳60   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆714_TEST←{A←  0 ⋄ X←2 1⍴⍳2      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆715_TEST←{A←  0 ⋄ X←2 3 1 5⍴⍳30 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆716_TEST←{A←  0 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf3 X}
 ∆717_TEST←{A←  1 ⋄ X←3 4 5⍴⍳60   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆718_TEST←{A←  1 ⋄ X←1 3⍴⍳2      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆719_TEST←{A←  1 ⋄ X←2 3 1 5⍴⍳30 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆720_TEST←{A←  1 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf3 X}
 ∆721_TEST←{A←  2 ⋄ X←3 4 5⍴⍳60   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆722_TEST←{A←  2 ⋄ X←1 3⍴⍳2      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆723_TEST←{A←  2 ⋄ X←2 3 1 5⍴⍳30 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf3 X}
 ∆724_TEST←{A←  2 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf3 X}
 ∆725_TEST←{A←  0 ⋄ X←3 4 5 1⍴⍳60 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf4 X}
 ∆726_TEST←{A←  0 ⋄ X←2 3 1⍴⍳2    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf4 X}
 ∆727_TEST←{A←  0 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf4 X}
 ∆728_TEST←{A←  1 ⋄ X←3 4 5 1⍴⍳60 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf4 X}
 ∆729_TEST←{A←  1 ⋄ X←2 3 1⍴⍳2    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf4 X}
 ∆730_TEST←{A←  1 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf4 X}
 ∆731_TEST←{A←  2 ⋄ X←3 4 5 1⍴⍳60 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf4 X}
 ∆732_TEST←{A←  2 ⋄ X←2 3 1⍴⍳2    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf4 X}
 ∆733_TEST←{A←  2 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf4 X}
 ∆734_TEST←{A←  3 ⋄ X←3 4 5 1⍴⍳60 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf4 X}
 ∆735_TEST←{A←  3 ⋄ X←2 3 1⍴⍳2    ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf4 X}
 ∆736_TEST←{A←  3 ⋄ X←⍳12         ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf4 X}
 ∆737_TEST←{A←  0 ⋄ X←1 5⍴⍳5      ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf5 X}
 ∆738_TEST←{A←  0 ⋄ X←3 1 4⍴⍳5    ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf5 X}

 ∆739_TEST←{A←0 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf1 X ⋄ A cd.ctf1 X}
 ∆740_TEST←{A←0 ⋄ X←⍳5           ⋄ #.UT.expect←A dy.ctf1 X ⋄ A cd.ctf1 X}
 ∆741_TEST←{A←0 ⋄ X←2 5⍴⍳10      ⋄ #.UT.expect←A dy.ctf1 X ⋄ A cd.ctf1 X}
 ∆742_TEST←{A←0 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆743_TEST←{A←0 ⋄ X←⍳3           ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆744_TEST←{A←0 ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆745_TEST←{A←0 ⋄ X←4 2 3⍴⍳24    ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆746_TEST←{A←1 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆747_TEST←{A←1 ⋄ X←⍳2           ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆748_TEST←{A←1 ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆749_TEST←{A←1 ⋄ X←2 4 3⍴⍳24    ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆750_TEST←{A←0 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆751_TEST←{A←0 ⋄ X←3 4⍴⍳6       ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆752_TEST←{A←0 ⋄ X←2 3 4⍴⍳24    ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆753_TEST←{A←0 ⋄ X←5 2 3 4⍴⍳120 ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆754_TEST←{A←1 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆755_TEST←{A←1 ⋄ X←2 4⍴⍳8       ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆756_TEST←{A←1 ⋄ X←2 3 4⍴⍳24    ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆757_TEST←{A←1 ⋄ X←2 5 3 4⍴⍳120 ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆758_TEST←{A←2 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆759_TEST←{A←2 ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆760_TEST←{A←2 ⋄ X←2 3 4⍴⍳24    ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆761_TEST←{A←2 ⋄ X←2 3 5 4⍴⍳120 ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆762_TEST←{A←0 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆763_TEST←{A←0 ⋄ X←3 4 5⍴⍳60    ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆764_TEST←{A←0 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆765_TEST←{A←1 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆766_TEST←{A←1 ⋄ X←2 4 5⍴⍳40    ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆767_TEST←{A←1 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆768_TEST←{A←2 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆769_TEST←{A←2 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆770_TEST←{A←2 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆771_TEST←{A←3 ⋄ X←5            ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆772_TEST←{A←3 ⋄ X←2 3 4⍴⍳24    ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}
 ∆773_TEST←{A←3 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.ctf4 X ⋄ A cd.ctf4 X}

 ∆774_TEST←{A← 1.5  ⋄ X←5      ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat1 X}
 ∆775_TEST←{A←¯1.5  ⋄ X←5      ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.cat1 X}
 ∆776_TEST←{A← 0.5  ⋄ X←⍳9     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat1 X}
 ∆777_TEST←{A←¯0.5  ⋄ X←⍳9     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat1 X}
 ∆778_TEST←{A← 0.5  ⋄ X←⍳9     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat2 X}
 ∆779_TEST←{A← 0.5  ⋄ X←2 4⍴⍳8 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat2 X}
 ∆780_TEST←{A← 0.5  ⋄ X←,5     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat1 X}
 ∆781_TEST←{A← ¯.5  ⋄ X←,5     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.cat1 X}
 ∆782_TEST←{A← 0.5  ⋄ X←5      ⋄ #.UT.expect←x←'NONCE ERROR'  ⋄ 16::x ⋄ A cd.cat4 X}

 ∆783_TEST←{A←¯.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆784_TEST←{A←¯.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat1 X ⋄ A cd.cat1 X}
 ∆785_TEST←{A←0.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat1 X ⋄ A cd.cat1 X}
 ∆786_TEST←{A←¯.5 ⋄ X←⍳5        ⋄ #.UT.expect←A dy.cat1 X ⋄ A cd.cat1 X}
 ∆787_TEST←{A←0.5 ⋄ X←⍳5        ⋄ #.UT.expect←A dy.cat1 X ⋄ A cd.cat1 X}
 ∆788_TEST←{A←¯.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆789_TEST←{A←0.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆790_TEST←{A←1.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆791_TEST←{A←¯.5 ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆792_TEST←{A←0.5 ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆793_TEST←{A←1.5 ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.cat2 X ⋄ A cd.cat2 X}
 ∆794_TEST←{A←¯.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆795_TEST←{A←0.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆796_TEST←{A←1.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆797_TEST←{A←2.5 ⋄ X←5         ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆798_TEST←{A←¯.5 ⋄ X←2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆799_TEST←{A←0.5 ⋄ X←2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆800_TEST←{A←1.5 ⋄ X←2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}
 ∆801_TEST←{A←2.5 ⋄ X←2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.cat3 X ⋄ A cd.cat3 X}

 ∆802_TEST←{A← 1.5  ⋄ X←5      ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf1 X}
 ∆803_TEST←{A←¯1.5  ⋄ X←5      ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.ctf1 X}
 ∆804_TEST←{A← 0.5  ⋄ X←⍳9     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf1 X}
 ∆805_TEST←{A←¯0.5  ⋄ X←⍳9     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf1 X}
 ∆806_TEST←{A← 0.5  ⋄ X←⍳9     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.ctf2 X}
 ∆807_TEST←{A← 0.5  ⋄ X←2 4⍴⍳8 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf2 X}
 ∆808_TEST←{A← 0.5  ⋄ X←,5     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf1 X}
 ∆809_TEST←{A← ¯.5  ⋄ X←,5     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.ctf1 X}
 ∆810_TEST←{A← 0.5  ⋄ X←5      ⋄ #.UT.expect←x←'NONCE ERROR'  ⋄ 16::x ⋄ A cd.ctf4 X}

 ∆811_TEST←{A←¯.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf0 X ⋄ A cd.ctf0 X}
 ∆812_TEST←{A←¯.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf1 X ⋄ A cd.ctf1 X}
 ∆813_TEST←{A←0.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf1 X ⋄ A cd.ctf1 X}
 ∆814_TEST←{A←¯.5 ⋄ X←⍳5        ⋄ #.UT.expect←A dy.ctf1 X ⋄ A cd.ctf1 X}
 ∆815_TEST←{A←0.5 ⋄ X←⍳5        ⋄ #.UT.expect←A dy.ctf1 X ⋄ A cd.ctf1 X}
 ∆816_TEST←{A←¯.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆817_TEST←{A←0.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆818_TEST←{A←1.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆819_TEST←{A←¯.5 ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆820_TEST←{A←0.5 ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆821_TEST←{A←1.5 ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.ctf2 X ⋄ A cd.ctf2 X}
 ∆822_TEST←{A←¯.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆823_TEST←{A←0.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆824_TEST←{A←1.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆825_TEST←{A←2.5 ⋄ X←5         ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆826_TEST←{A←¯.5 ⋄ X←2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆827_TEST←{A←0.5 ⋄ X←2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆828_TEST←{A←1.5 ⋄ X←2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}
 ∆829_TEST←{A←2.5 ⋄ X←2 3 4⍴⍳24 ⋄ #.UT.expect←A dy.ctf3 X ⋄ A cd.ctf3 X}

 ∆830_TEST←{A← 0    ⋄ X←5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.tke0 X}
 ∆831_TEST←{A←¯1    ⋄ X←5     ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.tke0 X}
 ∆832_TEST←{A← 1    ⋄ X←5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.tke1 X}
 ∆833_TEST←{A←1 1⍴0 ⋄ X←5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.tke1 X}
 ∆834_TEST←{A←0     ⋄ X←1 1⍴5 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.tke1 X}
 ∆835_TEST←{A←0     ⋄ X←5 5   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.tke1 X}
 ∆836_TEST←{A←0 1   ⋄ X←5     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.tke2 X}
 ∆837_TEST←{A←0 1   ⋄ X←5 5   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.tke1 X}

 ∆838_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.tke1 X ⋄ A cd.tke1 X}
 ∆839_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆840_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆841_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆842_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.tke5 X ⋄ A cd.tke5 X}
 ∆843_TEST←{A←0     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke1 X ⋄ A cd.tke1 X}
 ∆844_TEST←{A←0     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆845_TEST←{A←0     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆846_TEST←{A←0     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆847_TEST←{A←0     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke5 X ⋄ A cd.tke5 X}
 ∆848_TEST←{A←0     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke1 X ⋄ A cd.tke1 X}
 ∆849_TEST←{A←0     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆850_TEST←{A←0     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆851_TEST←{A←0     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆852_TEST←{A←0     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke5 X ⋄ A cd.tke5 X}
 ∆853_TEST←{A←1     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆854_TEST←{A←1     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆855_TEST←{A←1     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆856_TEST←{A←1     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆857_TEST←{A←1     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆858_TEST←{A←1     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆859_TEST←{A←2     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆860_TEST←{A←2     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆861_TEST←{A←2     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆862_TEST←{A←2     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆863_TEST←{A←3     ⋄ X←¯9     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆864_TEST←{A←3     ⋄ X← 9     ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆865_TEST←{A←0 1   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆866_TEST←{A←0 1   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆867_TEST←{A←0 1   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆868_TEST←{A←0 1   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆869_TEST←{A←0 1   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆870_TEST←{A←0 1   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆871_TEST←{A←0 2   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆872_TEST←{A←0 2   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆873_TEST←{A←0 2   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆874_TEST←{A←0 2   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆875_TEST←{A←0 3   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆876_TEST←{A←0 3   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆877_TEST←{A←1 0   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆878_TEST←{A←1 0   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆879_TEST←{A←1 0   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆880_TEST←{A←1 0   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke2 X ⋄ A cd.tke2 X}
 ∆881_TEST←{A←1 0   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆882_TEST←{A←1 0   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆883_TEST←{A←2 0   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆884_TEST←{A←2 0   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆885_TEST←{A←2 0   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆886_TEST←{A←2 0   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆887_TEST←{A←3 0   ⋄ X←9 ¯9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆888_TEST←{A←3 0   ⋄ X←¯9 9   ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆889_TEST←{A←2 0 1 ⋄ X←9 ¯9 7 ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆890_TEST←{A←2 0 1 ⋄ X←9 ¯9 7 ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆891_TEST←{A←2 0 1 ⋄ X←¯9 9 7 ⋄ #.UT.expect←A dy.tke3 X ⋄ A cd.tke3 X}
 ∆892_TEST←{A←2 0 1 ⋄ X←¯9 9 7 ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆893_TEST←{A←3 0 1 ⋄ X←9 ¯9 7 ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}
 ∆894_TEST←{A←3 0 1 ⋄ X←¯9 9 7 ⋄ #.UT.expect←A dy.tke4 X ⋄ A cd.tke4 X}

 ∆895_TEST←{A←0 ⋄ X←5.5 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.tke1 X}

 ∆896_TEST←{A← 0    ⋄ X←5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.drp0 X}
 ∆897_TEST←{A←¯1    ⋄ X←5     ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.drp0 X}
 ∆898_TEST←{A← 1    ⋄ X←5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.drp1 X}
 ∆899_TEST←{A←1 1⍴0 ⋄ X←5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.drp1 X}
 ∆900_TEST←{A←0     ⋄ X←1 1⍴5 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.drp1 X}
 ∆901_TEST←{A←0     ⋄ X←5 5   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.drp1 X}
 ∆902_TEST←{A←0 1   ⋄ X←5     ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.drp2 X}
 ∆903_TEST←{A←0 1   ⋄ X←5 5   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.drp1 X}
 ∆904_TEST←{A←0     ⋄ X←5.5   ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.drp1 X}

 ∆905_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.drp1 X ⋄ A cd.drp1 X}
 ∆906_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆907_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆908_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆909_TEST←{A←⍬     ⋄ X← ⍬     ⋄ #.UT.expect←A dy.drp5 X ⋄ A cd.drp5 X}
 ∆910_TEST←{A←0     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp1 X ⋄ A cd.drp1 X}
 ∆911_TEST←{A←0     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆912_TEST←{A←0     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆913_TEST←{A←0     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆914_TEST←{A←0     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp5 X ⋄ A cd.drp5 X}
 ∆915_TEST←{A←0     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp1 X ⋄ A cd.drp1 X}
 ∆916_TEST←{A←0     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆917_TEST←{A←0     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆918_TEST←{A←0     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆919_TEST←{A←0     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp5 X ⋄ A cd.drp5 X}
 ∆920_TEST←{A←1     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆921_TEST←{A←1     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆922_TEST←{A←1     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆923_TEST←{A←1     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆924_TEST←{A←1     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆925_TEST←{A←1     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆926_TEST←{A←2     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆927_TEST←{A←2     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆928_TEST←{A←2     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆929_TEST←{A←2     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆930_TEST←{A←3     ⋄ X←¯3     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆931_TEST←{A←3     ⋄ X← 3     ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆932_TEST←{A←0 1   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆933_TEST←{A←0 1   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆934_TEST←{A←0 1   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆935_TEST←{A←0 1   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆936_TEST←{A←0 1   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆937_TEST←{A←0 1   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆938_TEST←{A←0 2   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆939_TEST←{A←0 2   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆940_TEST←{A←0 2   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆941_TEST←{A←0 2   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆942_TEST←{A←0 3   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆943_TEST←{A←0 3   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆944_TEST←{A←1 0   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆945_TEST←{A←1 0   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆946_TEST←{A←1 0   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆947_TEST←{A←1 0   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp2 X ⋄ A cd.drp2 X}
 ∆948_TEST←{A←1 0   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆949_TEST←{A←1 0   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆950_TEST←{A←2 0   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆951_TEST←{A←2 0   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆952_TEST←{A←2 0   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆953_TEST←{A←2 0   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆954_TEST←{A←3 0   ⋄ X←3 ¯3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆955_TEST←{A←3 0   ⋄ X←¯3 3   ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆956_TEST←{A←2 0 1 ⋄ X←3 ¯3 2 ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆957_TEST←{A←2 0 1 ⋄ X←3 ¯3 2 ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆958_TEST←{A←2 0 1 ⋄ X←¯3 3 2 ⋄ #.UT.expect←A dy.drp3 X ⋄ A cd.drp3 X}
 ∆959_TEST←{A←2 0 1 ⋄ X←¯3 3 2 ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆960_TEST←{A←3 0 1 ⋄ X←3 ¯3 2 ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}
 ∆961_TEST←{A←3 0 1 ⋄ X←¯3 3 2 ⋄ #.UT.expect←A dy.drp4 X ⋄ A cd.drp4 X}

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
