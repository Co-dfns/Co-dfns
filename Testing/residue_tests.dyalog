:Namespace residue

I←{⍬≡⍴⍵:⍵ ⋄ ⊃((⎕DR ⍵)323)⎕DR ⍵}
I1←I ¯5000+?10⍴10000
I2←I ¯5000+?10⍴10000
F1←100÷⍨¯5000+?10⍴10000
F2←100÷⍨¯5000+?10⍴10000

S←':Namespace' 'Run←{⍺|⍵}' ':EndNamespace'
NS←⎕FIX S ⋄ C←#.codfns

RESIDUE∆II∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/residueii'C.Fix S
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

RESIDUE∆II∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/residueii'C.Fix S
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

RESIDUE∆II∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'residueii'C.Fix S
  #.UT.expect←I1 NS.Run I2 ⋄ I1 CS.Run I2
}

RESIDUE∆FF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/residueff'C.Fix S
  #.UT.expect←F1 NS.Run F2 ⋄ F1 CS.Run F2
}

RESIDUE∆FF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/residueff'C.Fix S
  #.UT.expect←F1 NS.Run F2 ⋄ F1 CS.Run F2
}

RESIDUE∆FF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'residueff'C.Fix S
  #.UT.expect←F1 NS.Run F2 ⋄ F1 CS.Run F2
}

RESIDUE∆IF∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/residueif'C.Fix S
  #.UT.expect←I1 NS.Run F2 ⋄ I1 CS.Run F2
}

RESIDUE∆IF∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/residueif'C.Fix S
  #.UT.expect←I1 NS.Run F2 ⋄ I1 CS.Run F2
}

RESIDUE∆IF∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'residueif'C.Fix S
  #.UT.expect←I1 NS.Run F2 ⋄ I1 CS.Run F2
}

RESIDUE∆FI∆GCC_TEST←{~(⊂'gcc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'gcc' ⋄ CS←'Scratch/residuefi'C.Fix S
  #.UT.expect←10⍴1 ⋄ 1E¯12≥(I1 NS.Run F2)-I1 CS.Run F2
}

RESIDUE∆FI∆ICC_TEST←{~(⊂'icc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'icc' ⋄ CS←'Scratch/residuefi'C.Fix S
  #.UT.expect←10⍴1 ⋄ 1E¯12≥(I1 NS.Run F2)-I1 CS.Run F2
}

RESIDUE∆FI∆VSC_TEST←{~(⊂'vsc')∊C.TEST∆COMPILERS:0⊣#.UT.expect←0
  C.COMPILER←'vsc' ⋄ CS←'residuefi'C.Fix S
  #.UT.expect←10⍴1 ⋄ 1E¯12≥(I1 NS.Run F2)-I1 CS.Run F2
}

:EndNamespace

