 FlattenExprs←{
     vex←{                                ⍝ Function to make var expr
         at←2 2⍴'name'⍵'class' 'array'    ⍝ Variable name is right argument
         v←1 4⍴(1+⍺)'Variable' ''at        ⍝ Variable node, depth in left argument
         at←1 2⍴'class' 'atomic'            ⍝ Expression is atomic
         e←1 4⍴⍺'Expression' ''at         ⍝ Expression node has no name
         e⍪v                                ⍝ Give valid AST as result
     }
     up←{a←⍺ ⋄ a[;0]-←(⊃a)-⍵ ⋄ a}         ⍝ Fn: Lift node ⍺ to depth ⍵
     lft←'lbz'{                           ⍝ Op; Lift all expressions to scope root
         nam cls←⊃¨'name' 'class'Prop¨⊂1↑⍺  ⍝ Name and class of node
         isn←~∧/' '=nam ⋄ isa←'atomic'≡cls  ⍝ Tests of namedness and atomicity
         isa∧isn:(⍺ up ⍵)((⊃⍺)vex nam)      ⍝ Lifted named ref & unnamed replacement
         isa∨0=≢⍺:MtAST ⍺                   ⍝ Untouched unnamed reference or empty
         ret←(⊃⍺)vex⊢nam←isn⊃⍺⍺ nam         ⍝ Final name & ref replacement for call
         rlf rex←(⊃⌽k←1 Kids ⍺)nam ∇∇ ⍵       ⍝ Lifted right argument of call
         lfn←LiftBound⊃⌽¯1↓k               ⍝ Lifted function in call
         nex←((⊃¯2↓k)⍪lfn⍪rex)up ⍵          ⍝ Lifted call with right arg replacement
         (rlf⍪isn⊃(nam Bind nex)nex)ret     ⍝ Right lifts + Bound call, & Return var
     }
     1=≢⍵:⍵                               ⍝ Do nothing for leaves
     'Expression'≡⊃0 1⌷⍵:⊃⍪/⍵ lft⊃⍵       ⍝ Lift root expressions
     'Condition'≡⊃0 1⌷⍵:{                 ⍝ Lifting Condition nodes is special
         l←⊃,/(2↑1 Kids ⍵)lft¨0 1+⊃⍵        ⍝ All lifted children and lifted code
         ⊃⍪/(1↑l),(⊂1↑⍵),1↓l                ⍝ Test Expr lifted above the node
     }⍵
     (∇⊢)Eachk ⍵                          ⍝ Ignore non-expr nodes
 }