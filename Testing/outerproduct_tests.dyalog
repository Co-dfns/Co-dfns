:Namespace outerproduct

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}

S←':Namespace' 'R1←{⍺∘.×⍵}' 'R2←{⍺∘.{⍺×⍵}⍵}' ':EndNamespace'

NS←⎕FIX S ⋄ C←#.codfns

MK∆TST←{id cmp fn←⍺⍺ ⋄ ls rs←⍵⍵ ⋄ l←⍎ls ⋄ r←⍎rs
  ~(⊂cmp)∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←cmp ⋄ CS←('outerproduct',⍕id)C.Fix S
  #.UT.expect←l(⍎'NS.',fn)r ⋄ l(⍎'CS.',fn)r
}

OUTERPRODUCT∆01∆GCC_TEST←01 'gcc' 'R1' MK∆TST '1'          '1'
OUTERPRODUCT∆01∆ICC_TEST←01 'icc' 'R1' MK∆TST '1'          '1'
OUTERPRODUCT∆01∆VSC_TEST←01 'vsc' 'R1' MK∆TST '1'          '1'
OUTERPRODUCT∆02∆GCC_TEST←02 'gcc' 'R1' MK∆TST '1'          'I ⍬'
OUTERPRODUCT∆02∆ICC_TEST←02 'icc' 'R1' MK∆TST '1'          'I ⍬'
OUTERPRODUCT∆02∆VSC_TEST←02 'vsc' 'R1' MK∆TST '1'          'I ⍬'
OUTERPRODUCT∆03∆GCC_TEST←03 'gcc' 'R1' MK∆TST 'I ⍬'        'I ⍬'
OUTERPRODUCT∆03∆ICC_TEST←03 'icc' 'R1' MK∆TST 'I ⍬'        'I ⍬'
OUTERPRODUCT∆03∆VSC_TEST←03 'vsc' 'R1' MK∆TST 'I ⍬'        'I ⍬'
OUTERPRODUCT∆04∆GCC_TEST←04 'gcc' 'R1' MK∆TST 'I ⍬'        'I 1+⍳3'
OUTERPRODUCT∆04∆ICC_TEST←04 'icc' 'R1' MK∆TST 'I ⍬'        'I 1+⍳3'
OUTERPRODUCT∆04∆VSC_TEST←04 'vsc' 'R1' MK∆TST 'I ⍬'        'I 1+⍳3'
OUTERPRODUCT∆05∆GCC_TEST←05 'gcc' 'R1' MK∆TST 'I 1+⍳3'     'I ⍬'
OUTERPRODUCT∆05∆ICC_TEST←05 'icc' 'R1' MK∆TST 'I 1+⍳3'     'I ⍬'
OUTERPRODUCT∆05∆VSC_TEST←05 'vsc' 'R1' MK∆TST 'I 1+⍳3'     'I ⍬'
OUTERPRODUCT∆06∆GCC_TEST←06 'gcc' 'R1' MK∆TST '5'          'I 1+⍳3'
OUTERPRODUCT∆06∆ICC_TEST←06 'icc' 'R1' MK∆TST '5'          'I 1+⍳3'
OUTERPRODUCT∆06∆VSC_TEST←06 'vsc' 'R1' MK∆TST '5'          'I 1+⍳3'
OUTERPRODUCT∆07∆GCC_TEST←07 'gcc' 'R1' MK∆TST 'I 1+⍳3'     'I 1+⍳3'
OUTERPRODUCT∆07∆ICC_TEST←07 'icc' 'R1' MK∆TST 'I 1+⍳3'     'I 1+⍳3'
OUTERPRODUCT∆07∆VSC_TEST←07 'vsc' 'R1' MK∆TST 'I 1+⍳3'     'I 1+⍳3'
OUTERPRODUCT∆08∆GCC_TEST←08 'gcc' 'R1' MK∆TST 'I 2 2⍴3'    'I 1+⍳7'
OUTERPRODUCT∆08∆ICC_TEST←08 'icc' 'R1' MK∆TST 'I 2 2⍴3'    'I 1+⍳7'
OUTERPRODUCT∆08∆VSC_TEST←08 'vsc' 'R1' MK∆TST 'I 2 2⍴3'    'I 1+⍳7'
OUTERPRODUCT∆09∆GCC_TEST←09 'gcc' 'R1' MK∆TST 'I 2 2⍴1+⍳4' 'I 2 2⍴1+⍳4'
OUTERPRODUCT∆09∆ICC_TEST←09 'icc' 'R1' MK∆TST 'I 2 2⍴1+⍳4' 'I 2 2⍴1+⍳4'
OUTERPRODUCT∆09∆VSC_TEST←09 'vsc' 'R1' MK∆TST 'I 2 2⍴1+⍳4' 'I 2 2⍴1+⍳4'
OUTERPRODUCT∆10∆GCC_TEST←10 'gcc' 'R1' MK∆TST 'I 2 2⍴1+⍳4' '2 2⍴÷1+⍳4'
OUTERPRODUCT∆10∆ICC_TEST←10 'icc' 'R1' MK∆TST 'I 2 2⍴1+⍳4' '2 2⍴÷1+⍳4'
OUTERPRODUCT∆10∆VSC_TEST←10 'vsc' 'R1' MK∆TST 'I 2 2⍴1+⍳4' '2 2⍴÷1+⍳4'
OUTERPRODUCT∆11∆GCC_TEST←11 'gcc' 'R2' MK∆TST '1'          '1'
OUTERPRODUCT∆11∆ICC_TEST←11 'icc' 'R2' MK∆TST '1'          '1'
OUTERPRODUCT∆11∆VSC_TEST←11 'vsc' 'R2' MK∆TST '1'          '1'
OUTERPRODUCT∆12∆GCC_TEST←12 'gcc' 'R2' MK∆TST '1'          'I ⍬'
OUTERPRODUCT∆12∆ICC_TEST←12 'icc' 'R2' MK∆TST '1'          'I ⍬'
OUTERPRODUCT∆12∆VSC_TEST←12 'vsc' 'R2' MK∆TST '1'          'I ⍬'
OUTERPRODUCT∆13∆GCC_TEST←13 'gcc' 'R2' MK∆TST 'I ⍬'        'I ⍬'
OUTERPRODUCT∆13∆ICC_TEST←13 'icc' 'R2' MK∆TST 'I ⍬'        'I ⍬'
OUTERPRODUCT∆13∆VSC_TEST←13 'vsc' 'R2' MK∆TST 'I ⍬'        'I ⍬'
OUTERPRODUCT∆14∆GCC_TEST←14 'gcc' 'R2' MK∆TST 'I ⍬'        'I 1+⍳3'
OUTERPRODUCT∆14∆ICC_TEST←14 'icc' 'R2' MK∆TST 'I ⍬'        'I 1+⍳3'
OUTERPRODUCT∆14∆VSC_TEST←14 'vsc' 'R2' MK∆TST 'I ⍬'        'I 1+⍳3'
OUTERPRODUCT∆15∆GCC_TEST←15 'gcc' 'R2' MK∆TST 'I 1+⍳3'     'I ⍬'
OUTERPRODUCT∆15∆ICC_TEST←15 'icc' 'R2' MK∆TST 'I 1+⍳3'     'I ⍬'
OUTERPRODUCT∆15∆VSC_TEST←15 'vsc' 'R2' MK∆TST 'I 1+⍳3'     'I ⍬'
OUTERPRODUCT∆16∆GCC_TEST←16 'gcc' 'R2' MK∆TST '5'          'I 1+⍳3'
OUTERPRODUCT∆16∆ICC_TEST←16 'icc' 'R2' MK∆TST '5'          'I 1+⍳3'
OUTERPRODUCT∆16∆VSC_TEST←16 'vsc' 'R2' MK∆TST '5'          'I 1+⍳3'
OUTERPRODUCT∆17∆GCC_TEST←17 'gcc' 'R2' MK∆TST 'I 1+⍳3'     'I 1+⍳3'
OUTERPRODUCT∆17∆ICC_TEST←17 'icc' 'R2' MK∆TST 'I 1+⍳3'     'I 1+⍳3'
OUTERPRODUCT∆17∆VSC_TEST←17 'vsc' 'R2' MK∆TST 'I 1+⍳3'     'I 1+⍳3'
OUTERPRODUCT∆18∆GCC_TEST←18 'gcc' 'R2' MK∆TST 'I 2 2⍴3'    'I 1+⍳7'
OUTERPRODUCT∆18∆ICC_TEST←18 'icc' 'R2' MK∆TST 'I 2 2⍴3'    'I 1+⍳7'
OUTERPRODUCT∆18∆VSC_TEST←18 'vsc' 'R2' MK∆TST 'I 2 2⍴3'    'I 1+⍳7'
OUTERPRODUCT∆19∆GCC_TEST←19 'gcc' 'R2' MK∆TST 'I 2 2⍴1+⍳4' 'I 2 2⍴1+⍳4'
OUTERPRODUCT∆19∆ICC_TEST←19 'icc' 'R2' MK∆TST 'I 2 2⍴1+⍳4' 'I 2 2⍴1+⍳4'
OUTERPRODUCT∆19∆VSC_TEST←19 'vsc' 'R2' MK∆TST 'I 2 2⍴1+⍳4' 'I 2 2⍴1+⍳4'
OUTERPRODUCT∆20∆GCC_TEST←20 'gcc' 'R2' MK∆TST 'I 2 2⍴1+⍳4' '2 2⍴÷1+⍳4'
OUTERPRODUCT∆20∆ICC_TEST←20 'icc' 'R2' MK∆TST 'I 2 2⍴1+⍳4' '2 2⍴÷1+⍳4'
OUTERPRODUCT∆20∆VSC_TEST←20 'vsc' 'R2' MK∆TST 'I 2 2⍴1+⍳4' '2 2⍴÷1+⍳4'

:EndNamespace

