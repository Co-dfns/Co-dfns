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

 ∆058_TEST←{A←1       ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 ⍳5}
 ∆059_TEST←{A←0       ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 5}
 ∆060_TEST←{A←1       ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 ⍳5}
 ∆061_TEST←{A←0 1 2   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 2 3⍴⍳6}
 ∆062_TEST←{A←0 2     ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.cat0 2 3 5⍴⍳30}
 ∆063_TEST←{A←1.5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 ⍳5}
 ∆064_TEST←{A←0.5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 5}
 ∆065_TEST←{A←2.5     ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 2 3⍴⍳6}
 ∆066_TEST←{A←0.5 0.5 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.cat0 ⍳5}
 ∆067_TEST←{A←1 2⍴⍳2  ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 2 3⍴⍳5}
 ∆068_TEST←{A←⍬       ⋄ #.UT.expect←x←'NONCE ERROR'  ⋄ 16::x ⋄ A cd.cat0 1 2 3 4⍴⍳24}
 ∆069_TEST←{A←1 0 1⍴0 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 ⍳5}
 ∆070_TEST←{A←1 1 1⍴0 ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.cat0 ⍳5}
 ∆071_TEST←{A←¯1 0    ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.cat0 ⍳5}

 ∆072_TEST←{A←0       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆073_TEST←{A←0       ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆074_TEST←{A←1       ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆075_TEST←{A←0       ⋄ X←1 2 3⍴⍳6     ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆076_TEST←{A←1       ⋄ X←1 2 3⍴⍳6     ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆077_TEST←{A←2       ⋄ X←1 2 3⍴⍳6     ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆078_TEST←{A←⍬       ⋄ X←0            ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆079_TEST←{A←⍬       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆080_TEST←{A←⍬       ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆081_TEST←{A←⍬       ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆082_TEST←{A←¯0.5    ⋄ X←0            ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆083_TEST←{A←¯0.5    ⋄ X←⍳5           ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆084_TEST←{A← 0.5    ⋄ X←⍳5           ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆085_TEST←{A←¯0.5    ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆086_TEST←{A← 0.5    ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆087_TEST←{A← 1.5    ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆088_TEST←{A←¯0.5    ⋄ X←2 3 5⍴⍳6     ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆089_TEST←{A← 0.5    ⋄ X←2 3 5⍴⍳6     ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆090_TEST←{A← 1.5    ⋄ X←2 3 5⍴⍳6     ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆091_TEST←{A← 2.5    ⋄ X←2 3 5⍴⍳6     ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆092_TEST←{A←0 1     ⋄ X←2 3⍴⍳6       ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆093_TEST←{A←1 2     ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆094_TEST←{A←0 1 2   ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆095_TEST←{A←0 1     ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆096_TEST←{A←1 2     ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆097_TEST←{A←2 3     ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆098_TEST←{A←0 1 2   ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆099_TEST←{A←1 2 3   ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆100_TEST←{A←0 1 2 3 ⋄ X←2 3 4 5⍴⍳120 ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}

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

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
