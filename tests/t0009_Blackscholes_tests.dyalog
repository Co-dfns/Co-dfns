:Require file://t0009.dyalog
:Namespace t0009_tests

 MK∆T3←{fn tl←⍺⍺ ⋄ nv←⊃(⍎'dy.',fn)/⍵⍵ ⋄ cv←⊃(⍎'cd.',fn)/⍵⍵
  ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

 tn←'t0009' ⋄ cn←'c0009'
 cd←⎕NS⍬ ⋄ dy←#.⍎tn
 bindings←0⍴⊂''
 bindings,←'extract_S' 'extract_X' 'extract_T' 'vsqrtT' 'get_L'
 bindings,←'Run' 'bs' 'CNDP2'
 bindings,←('CNDP2∆'∘,∘⍕¨1+⍳6),'bs'∘,∘⍕¨1+⍳9
 bindings←{⍵[⍋⍵;]}↑bindings
 coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442
 D←{⍉1+?⍵ 3⍴1000}25 ⋄ L1←,¯1↑D ⋄ R1←2↑D
 GD←{⍉↑(5+?⍵⍴25)(1+?⍵⍴100)(0.25+100÷⍨?⍵⍴1000)}
 D←⍉GD 7 ⋄ R2←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L2←,¯1↑D

 ∆00_TEST←{#.UT.expect←0
  _←#.⎕EX cn ⋄ 0⊣cd∘←#.c0009←tn #.codfns.Fix ⎕SRC dy}
 ∆01_TEST←{#.UT.expect←bindings ⋄ cd.⎕NL 3}
 ∆02_TEST←{#.UT.expect←L1 dy.extract_S R1 ⋄ L1 cd.extract_S R1}
 ∆03_TEST←{#.UT.expect←L1 dy.extract_X R1 ⋄ L1 cd.extract_X R1}
 ∆04_TEST←{#.UT.expect←L1 dy.extract_T R1 ⋄ L1 cd.extract_T R1}
 ∆05_TEST←{#.UT.expect←L1 dy.vsqrtT R1 ⋄ L1 cd.vsqrtT R1}
 ∆06_TEST←{#.UT.expect←L1 dy.get_L R1 ⋄ L1 cd.get_L R1}
 ∆07_TEST←'Run' 1e¯10 MK∆T3 L1 R1
 ∆08_TEST←{#.UT.expect←L2 dy.bs1 R2 ⋄ L2 cd.bs1 R2}
 ∆09_TEST←'bs2' 1e¯10 MK∆T3 L2 R2
 ∆10_TEST←'bs3' 1e¯10 MK∆T3 L2 R2
 ∆11_TEST←{#.UT.expect←L2 dy.bs4 R2 ⋄ L2 cd.bs4 R2}
 ∆12_TEST←{#.UT.expect←L2 dy.bs5 R2 ⋄ L2 cd.bs5 R2}
 ∆13_TEST←{#.UT.expect←dy.bs6 coeff ⋄ L2 cd.bs6 coeff}
 ∆14_TEST←{#.UT.expect←dy.bs7 coeff ⋄ L2 cd.bs7 coeff}
 ∆15_TEST←{#.UT.expect←dy.CNDP2∆6 R2 ⋄ cd.CNDP2∆6 R2}
 ∆16_TEST←{#.UT.expect←L2 dy.bs8 R2 ⋄ L2 cd.bs8 R2}
 ∆17_TEST←{#.UT.expect←L2 dy.bs9 R2 ⋄ L2 cd.bs9 R2}
 ∆18_TEST←'bs' 1e¯10 MK∆T3 L2 R2
 ∆∆_TEST←{#.UT.expect←,¨0 0 ⋄ _←#.⎕EX¨cn tn ⋄ #.⎕NC¨cn tn}

:EndNamespace
