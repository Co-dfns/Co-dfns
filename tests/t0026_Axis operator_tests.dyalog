:Require file://t0026.dyalog
:Namespace t0026_tests

 tn←'t0026' ⋄ cn←'c0026'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn

 ∆00_TEST←{#.UT.expect←'Successful compile'
  _←#.⎕EX cn ⋄ 'Successful compile'⊣cd∘←#.c0026←tn #.codfns.Fix ⎕SRC dy}

 ∆01_TEST←{#.UT.expect←'SYNTAX ERROR' ⋄ 2::'SYNTAX ERROR'
  code←':Namespace' 'f←{(⍳5)+[]⍳5}' ':EndNamespace'
  'Successful compile'⊣'t0026_a'#.codfns.Fix code}

 ∆02_TEST←{A←0       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆03_TEST←{A←0       ⋄ X←5 3⍴⍳15      ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆04_TEST←{A←0       ⋄ X←5 3 3⍴⍳45    ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆05_TEST←{A←0       ⋄ X←5 2 3 3⍴⍳90  ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆06_TEST←{A←1       ⋄ X←3 5⍴⍳15      ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆07_TEST←{A←1       ⋄ X←3 5 3⍴⍳45    ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆08_TEST←{A←1       ⋄ X←2 5 3 3⍴⍳90  ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆09_TEST←{A←2       ⋄ X←3 3 5⍴⍳45    ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆10_TEST←{A←2       ⋄ X←2 3 5 3⍴⍳90  ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆11_TEST←{A←3       ⋄ X←2 3 3 5⍴⍳90  ⋄ #.UT.expect←A dy.f1 X ⋄ A cd.f1 X}
 ∆12_TEST←{A←⍬       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f0 X ⋄ A cd.f0 X}
 ∆13_TEST←{A←⍬       ⋄ X←5 3⍴⍳15      ⋄ #.UT.expect←A dy.f0 X ⋄ A cd.f0 X}
 ∆14_TEST←{A←⍬       ⋄ X←5 3 3⍴⍳45    ⋄ #.UT.expect←A dy.f0 X ⋄ A cd.f0 X}
 ∆15_TEST←{A←⍬       ⋄ X←5 2 3 3⍴⍳90  ⋄ #.UT.expect←A dy.f0 X ⋄ A cd.f0 X}
 ∆16_TEST←{A←1       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f2 X ⋄ A cd.f2 X}
 ∆17_TEST←{A←1 0     ⋄ X←5 2⍴⍳15      ⋄ #.UT.expect←⍉(2 5⍴⍳10)-⍉X ⋄ A cd.f2 X}
 ∆18_TEST←{A←2 0     ⋄ X←5 3 2⍴⍳45    ⋄ #.UT.expect←A dy.f2 X ⋄ A cd.f2 X}
 ∆19_TEST←{A←1 0     ⋄ X←5 2 3 3⍴⍳90  ⋄ #.UT.expect←A dy.f2 X ⋄ A cd.f2 X}
 ∆20_TEST←{A←2       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f3 X ⋄ A cd.f3 X}
 ∆21_TEST←{A←2 1     ⋄ X←5 3⍴⍳15      ⋄ #.UT.expect←A dy.f3 X ⋄ A cd.f3 X}
 ∆22_TEST←{A←2 1 0   ⋄ X←5 3 2⍴⍳45    ⋄ #.UT.expect←⍉(2 3 5⍴⍳30)-⍉X ⋄ A cd.f3 X}
 ∆23_TEST←{A←1 3 0   ⋄ X←5 2 6 3⍴⍳180 ⋄ #.UT.expect←A dy.f3 X ⋄ A cd.f3 X}
 ∆24_TEST←{A←2       ⋄ X←⍳5           ⋄ #.UT.expect←A dy.f4 X ⋄ A cd.f4 X}
 ∆25_TEST←{A←2 1     ⋄ X←5 3⍴⍳15      ⋄ #.UT.expect←A dy.f4 X ⋄ A cd.f4 X}
 ∆26_TEST←{A←2 1 0   ⋄ X←5 3 2⍴⍳45    ⋄ #.UT.expect←A dy.f4 X ⋄ A cd.f4 X}
 ∆27_TEST←{A←1 3 0 2 ⋄ X←5 2 6 3⍴⍳180 ⋄ 
  #.UT.expect←1 3 0 2⍉(2 3 5 6⍴⍳180)-2 0 3 1⍉X ⋄ A cd.f4 X}

 ∆28_TEST←{A←⍬   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rev0 ⍳5}
 ∆29_TEST←{A←0 1 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rev0 2 5⍴⍳10}
 ∆30_TEST←{A←1   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rev0 ⍳20}
 ∆31_TEST←{A←0.5 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rev0 ⍳20}
 ∆32_TEST←{A←0   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rev0 0}

 ∆33_TEST←{A←0 ⋄ X←⍳20          ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆34_TEST←{A←0 ⋄ X←2 10⍴⍳20     ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆35_TEST←{A←0 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆36_TEST←{A←0 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆37_TEST←{A←1 ⋄ X←2 10⍴⍳20     ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆38_TEST←{A←1 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆39_TEST←{A←1 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆40_TEST←{A←2 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆41_TEST←{A←2 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}
 ∆42_TEST←{A←3 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev0 X}

 ∆43_TEST←{A←⍬   ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rev1 ⍳5}
 ∆44_TEST←{A←0 1 ⋄ #.UT.expect←x←'LENGTH ERROR' ⋄  5::x ⋄ A cd.rev1 2 5⍴⍳10}
 ∆45_TEST←{A←1   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rev1 ⍳20}
 ∆46_TEST←{A←0.5 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.rev1 ⍳20}
 ∆47_TEST←{A←0   ⋄ #.UT.expect←x←'RANK ERROR'   ⋄  4::x ⋄ A cd.rev1 0}

 ∆48_TEST←{A←0 ⋄ X←⍳20          ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆49_TEST←{A←0 ⋄ X←2 10⍴⍳20     ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆50_TEST←{A←0 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆51_TEST←{A←0 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆52_TEST←{A←1 ⋄ X←2 10⍴⍳20     ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆53_TEST←{A←1 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆54_TEST←{A←1 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆55_TEST←{A←2 ⋄ X←2 3 5⍴⍳30    ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆56_TEST←{A←2 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}
 ∆57_TEST←{A←3 ⋄ X←2 3 5 6⍴⍳180 ⋄ #.UT.expect←A dy.rev0 X ⋄ A cd.rev1 X}

 ∆58_TEST←{A←1 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 ⍳5}
 ∆59_TEST←{A←0 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 5}
 ∆60_TEST←{A←1 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 ⍳5}
 ∆61_TEST←{A←0 1 2 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 2 3⍴⍳6}
 ∆62_TEST←{A←0 2 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.cat0 2 3 5⍴⍳30}
 ∆63_TEST←{A←1.5 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 ⍳5}
 ∆64_TEST←{A←0.5 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 5}
 ∆65_TEST←{A←2.5 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 2 3⍴⍳6}
 ∆66_TEST←{A←0.5 0.5 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.cat0 ⍳5}
 ∆67_TEST←{A←1 2⍴⍳2 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 2 3⍴⍳5}
 ∆68_TEST←{A←⍬ ⋄ #.UT.expect←x←'NONCE ERROR' ⋄ 16::x ⋄ A cd.cat0 1 2 3 4⍴⍳24}
 ∆69_TEST←{A←1 0 1⍴0 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 ⍳5}
 ∆70_TEST←{A←1 1 1⍴0 ⋄ #.UT.expect←x←'RANK ERROR' ⋄ 4::x ⋄ A cd.cat0 ⍳5}
 ∆71_TEST←{A←¯1 0 ⋄ #.UT.expect←x←'DOMAIN ERROR' ⋄ 11::x ⋄ A cd.cat0 ⍳5}

 ∆72_TEST←{A←0 ⋄ X←⍳5        ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆73_TEST←{A←0 ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆74_TEST←{A←1 ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆75_TEST←{A←0 ⋄ X←1 2 3⍴⍳6  ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆76_TEST←{A←1 ⋄ X←1 2 3⍴⍳6  ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆77_TEST←{A←2 ⋄ X←1 2 3⍴⍳6  ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆78_TEST←{A←⍬ ⋄ X←0         ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆79_TEST←{A←⍬ ⋄ X←⍳5        ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆80_TEST←{A←⍬ ⋄ X←2 3⍴⍳6    ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}
 ∆81_TEST←{A←⍬ ⋄ X←2 3 5⍴⍳30 ⋄ #.UT.expect←A dy.cat0 X ⋄ A cd.cat0 X}


 ∆∆∆_TEST←{#.UT.expect←0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC cn tn}

:EndNamespace
