:Namespace residue

I1←{⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?10⍴10000
I2←{⊃((⎕DR ⍵)323)⎕DR ⍵}¯5000+?10⍴10000
F1←100÷⍨¯5000+?10⍴10000
F2←100÷⍨¯5000+?10⍴10000

S←':Namespace' 'Run←{⍺|⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns.C

RESIDUE∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/residueii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

RESIDUE∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/residueii'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

RESIDUE∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/residueff'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F1 NS.Run F2 ⋄ F1 CS.Run F2
}

RESIDUE∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/residueff'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←F1 NS.Run F2 ⋄ F1 CS.Run F2
}

RESIDUE∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/residueif'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I1 NS.Run F2 ⋄ I1 CS.Run F2
}

RESIDUE∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/residueif'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←I1 NS.Run F2 ⋄ I1 CS.Run F2
}

RESIDUE∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/residuefi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←10⍴1 ⋄ 1E¯12≥(I1 NS.Run F2)-I1 CS.Run F2
}

RESIDUE∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/residuefi'C.Fix S ⋄ C.COMPILER←'gcc'
  #.UT.expect←10⍴1 ⋄ 1E¯12≥(I1 NS.Run F2)-I1 CS.Run F2
}

:EndNamespace

