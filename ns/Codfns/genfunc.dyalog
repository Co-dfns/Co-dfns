 GenFunc←{
     0=≢fn←Split⊃'name'Prop 1↑⍵:0            ⍝ Ignore functions without names
     'Variable'≡⊃1 1⌷⍵:0                     ⍝ Ignore named function references
     fs←⍎⊃'alloca'Prop 1↑1↓⍵                 ⍝ Allocation for local scope
     fr←GetNamedFunction ⍺(⊃fn)              ⍝ Get the function reference
     bldr←CreateBuilder                      ⍝ Setup builder
     bb←AppendBasicBlock fr''                ⍝ Initial basic block
     _←PositionBuilderAtEnd bldr bb          ⍝ Link builder and basic block
     env0←⍺{                                 ⍝ Setup local frame
         fsz←ConstInt Int32Type fs 0         ⍝ Frame size value reference
         0=fs:(GenNullArrayPtr ⍬)fsz         ⍝ If frame is empty, do nothing
         ftp←ArrayTypeV                      ⍝ Frame is array pointer
         args←bldr ftp fsz'env0'             ⍝ Frame is env0
         z←(BuildArrayAlloca args)fsz        ⍝ Return pointer and size
         fn←GetNamedFunction ⍺'init_env'     ⍝ We must initialize the environment
         0=fn:'MISSING RUNTIME FN'⎕SIGNAL 99 ⍝ Sanity Check
         z⊣BuildCall bldr fn z 2 ''          ⍝ Using our helper function
     }⍬
     k←2 Kids ⍵                              ⍝ Nodes of the Function body
     _←⍬ ⍬(⍺ fr bldr env0 GenFnBlock)k       ⍝ Generate the function body
     fr⊣DisposeBuilder bldr                  ⍝ Builder cleanup
 }