:Namespace and

I1←#.I ?10⍴2 ⋄ I2←#.I ?10⍴2
S←':Namespace' 'Run←{⍺∧⍵}' ':EndNamespace'

AND∆II∆GCC_TEST← 'andii' 'gcc'  S 'Run' #.MK∆T2 I1 I2
AND∆II∆ICC_TEST← 'andii' 'icc'  S 'Run' #.MK∆T2 I1 I2
AND∆II∆VSC_TEST← 'andii' 'vsc'  S 'Run' #.MK∆T2 I1 I2
AND∆II∆PGCC_TEST←'andii' 'pgcc' S 'Run' #.MK∆T2 I1 I2

:EndNamespace

