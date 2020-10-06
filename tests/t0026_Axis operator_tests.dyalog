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

 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
