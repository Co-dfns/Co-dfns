 GenLLVM←{
     nam←(0 3)(0 1)⊃⍵                     ⍝ Namespace must have name
     nam←nam'Unamed Namespace'⌷⍨''≡nam   ⍝ Possibly empty, so fix it
     mod←ModuleCreateWithName nam         ⍝ Empty module to start with
     0=≢k←1 Kids ⍵:mod                    ⍝ Quit if nothing to do
     nm←1⌷⍉(1=0⌷⍉⍵)⌿⍵                     ⍝ Top-level nodes and node names
     exm←nm∊⊂'Expression'                 ⍝ Mask of expressions
     fem←nm∊⊂'FuncExpr'                   ⍝ Mask of function expressions
     _←GenRuntime mod                     ⍝ Generate declarations for runtime
     tex←⊃,/(⊂⍬),mod GenGlobal¨exm/k      ⍝ Generate top-level globals
     _←mod GenFnDec¨fem/k                 ⍝ Generate Function declarations
     _←mod GenFunc¨fem/k                  ⍝ Generate functions
     _←mod GenInit tex                    ⍝ Generate Initialization function
     _←⍎'Initialize',Target,'TargetInfo'  ⍝ Setup targeting information
     _←⍎'Initialize',Target,'Target'      ⍝ Based on given Machine
     _←⍎'Initialize',Target,'TargetMC'    ⍝ Parameters in CoDfns namespace
     _←SetTarget mod TargetTriple         ⍝ JIT must have machine target
     mod
 }
