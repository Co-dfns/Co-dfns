:Namespace catenate

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
S←':Namespace' 'Run←{⍺,⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

MK∆TST←{id cmp fn←⍺⍺ ⋄ ls rs←⍵⍵ ⋄ l←⍎ls ⋄ r←⍎rs
  ~(⊂cmp)∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←cmp ⋄ CS←('catenate',⍕id)C.Fix S
  #.UT.expect←l(⍎'NS.',fn)r ⋄ l(⍎'CS.',fn)r
}

CATENATE∆01∆GCC_TEST← '01' 'gcc'  'Run' MK∆TST 'I ⍬'       'I ⍬'
CATENATE∆01∆ICC_TEST← '01' 'icc'  'Run' MK∆TST 'I ⍬'       'I ⍬'
CATENATE∆01∆VSC_TEST← '01' 'vsc'  'Run' MK∆TST 'I ⍬'       'I ⍬'
CATENATE∆01∆PGCC_TEST←'01' 'pgcc' 'Run' MK∆TST 'I ⍬'       'I ⍬'
CATENATE∆02∆GCC_TEST← '02' 'gcc'  'Run' MK∆TST 'I 0'       'I 0'
CATENATE∆02∆ICC_TEST← '02' 'icc'  'Run' MK∆TST 'I 0'       'I 0'
CATENATE∆02∆VSC_TEST← '02' 'vsc'  'Run' MK∆TST 'I 0'       'I 0'
CATENATE∆02∆PGCC_TEST←'02' 'pgcc' 'Run' MK∆TST 'I 0'       'I 0'
CATENATE∆03∆GCC_TEST← '03' 'gcc'  'Run' MK∆TST 'I ⍬'       'I 0'
CATENATE∆03∆ICC_TEST← '03' 'icc'  'Run' MK∆TST 'I ⍬'       'I 0'
CATENATE∆03∆VSC_TEST← '03' 'vsc'  'Run' MK∆TST 'I ⍬'       'I 0'
CATENATE∆03∆PGCC_TEST←'03' 'pgcc' 'Run' MK∆TST 'I ⍬'       'I 0'
CATENATE∆04∆GCC_TEST← '04' 'gcc'  'Run' MK∆TST 'I ⍬'       'I ⍳5'
CATENATE∆04∆ICC_TEST← '04' 'icc'  'Run' MK∆TST 'I ⍬'       'I ⍳5'
CATENATE∆04∆VSC_TEST← '04' 'vsc'  'Run' MK∆TST 'I ⍬'       'I ⍳5'
CATENATE∆04∆PGCC_TEST←'04' 'pgcc' 'Run' MK∆TST 'I ⍬'       'I ⍳5'
CATENATE∆05∆GCC_TEST← '05' 'gcc'  'Run' MK∆TST 'I ⍳7'      'I ⍳5'
CATENATE∆05∆ICC_TEST← '05' 'icc'  'Run' MK∆TST 'I ⍳7'      'I ⍳5'
CATENATE∆05∆VSC_TEST← '05' 'vsc'  'Run' MK∆TST 'I ⍳7'      'I ⍳5'
CATENATE∆05∆PGCC_TEST←'05' 'pgcc' 'Run' MK∆TST 'I ⍳7'      'I ⍳5'
CATENATE∆06∆GCC_TEST← '06' 'gcc'  'Run' MK∆TST 'I 0'       'I ⍳5'
CATENATE∆06∆ICC_TEST← '06' 'icc'  'Run' MK∆TST 'I 0'       'I ⍳5'
CATENATE∆06∆VSC_TEST← '06' 'vsc'  'Run' MK∆TST 'I 0'       'I ⍳5'
CATENATE∆06∆PGCC_TEST←'06' 'pgcc' 'Run' MK∆TST 'I 0'       'I ⍳5'
CATENATE∆07∆GCC_TEST← '07' 'gcc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2⍴0'
CATENATE∆07∆ICC_TEST← '07' 'icc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2⍴0'
CATENATE∆07∆VSC_TEST← '07' 'vsc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2⍴0'
CATENATE∆07∆PGCC_TEST←'07' 'pgcc' 'Run' MK∆TST 'I 2 2⍴0'   'I 2 2⍴0'
CATENATE∆08∆GCC_TEST← '08' 'gcc'  'Run' MK∆TST 'I 2 2 3⍴0' 'I 2 2⍴0'
CATENATE∆08∆ICC_TEST← '08' 'icc'  'Run' MK∆TST 'I 2 2 3⍴0' 'I 2 2⍴0'
CATENATE∆08∆VSC_TEST← '08' 'vsc'  'Run' MK∆TST 'I 2 2 3⍴0' 'I 2 2⍴0'
CATENATE∆08∆PGCC_TEST←'08' 'pgcc' 'Run' MK∆TST 'I 2 2 3⍴0' 'I 2 2⍴0'
CATENATE∆09∆GCC_TEST← '09' 'gcc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2 3⍴0'
CATENATE∆09∆ICC_TEST← '09' 'icc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2 3⍴0'
CATENATE∆09∆VSC_TEST← '09' 'vsc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2 3⍴0'
CATENATE∆09∆PGCC_TEST←'09' 'pgcc' 'Run' MK∆TST 'I 2 2⍴0'   'I 2 2 3⍴0'
CATENATE∆10∆GCC_TEST← '10' 'gcc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2 3⍴0'
CATENATE∆10∆ICC_TEST← '10' 'icc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2 3⍴0'
CATENATE∆10∆VSC_TEST← '10' 'vsc'  'Run' MK∆TST 'I 2 2⍴0'   'I 2 2 3⍴0'
CATENATE∆10∆PGCC_TEST←'10' 'pgcc' 'Run' MK∆TST 'I 2 2⍴0'   'I 2 2 3⍴0'
CATENATE∆11∆GCC_TEST← '11' 'gcc'  'Run' MK∆TST 'I 0'       'I 2 2⍴0'
CATENATE∆11∆ICC_TEST← '11' 'icc'  'Run' MK∆TST 'I 0'       'I 2 2⍴0'
CATENATE∆11∆VSC_TEST← '11' 'vsc'  'Run' MK∆TST 'I 0'       'I 2 2⍴0'
CATENATE∆11∆PGCC_TEST←'11' 'pgcc' 'Run' MK∆TST 'I 0'       'I 2 2⍴0'
CATENATE∆12∆GCC_TEST← '12' 'gcc'  'Run' MK∆TST 'I ,0 0'    'I 2 2⍴0'
CATENATE∆12∆ICC_TEST← '12' 'icc'  'Run' MK∆TST 'I ,0 0'    'I 2 2⍴0'
CATENATE∆12∆VSC_TEST← '12' 'vsc'  'Run' MK∆TST 'I ,0 0'    'I 2 2⍴0'
CATENATE∆12∆PGCC_TEST←'12' 'pgcc' 'Run' MK∆TST 'I ,0 0'    'I 2 2⍴0'
CATENATE∆13∆GCC_TEST← '13' 'gcc'  'Run' MK∆TST 'I ,0'      'I ,0'
CATENATE∆13∆ICC_TEST← '13' 'icc'  'Run' MK∆TST 'I ,0'      'I ,0'
CATENATE∆13∆VSC_TEST← '13' 'vsc'  'Run' MK∆TST 'I ,0'      'I ,0'
CATENATE∆13∆PGCC_TEST←'13' 'pgcc' 'Run' MK∆TST 'I ,0'      'I ,0'

:EndNamespace

