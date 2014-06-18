 AnchorVars←{S←Split ⋄ nm←'name'∘(P←Prop)
     es fs←'Expression' 'Function'        ⍝ Names of expression and function nodes
     e f←es fs∊∘⊂¨⍨⊂1⌷⍉⍵                  ⍝ Mask of expression and function nodes
     n←∨/(↑0⌷∘⍉¨3⌷⍉⍵)∊⊂'name'             ⍝ Mask of nodes with names
     ~∨/e∧n:⍵                             ⍝ Short circuit on empty
     c←(1+d)↑⍤¯1+⍀d∘.=⍳1+⌈/d←0⌷⍉⍵         ⍝ Node coordinates
     p←c×↑∨/c(⊣,∧).=⍉(rf←1,1↓f)⌿c         ⍝ Parent scope coordinates per node
     o←⍳∘∪⍨vs←(⊃,/)(b←0⌷∘⍉⊢)              ⍝ Fn: First index of vars from bindings
     lr←1 2(o⊃¨∘⊂(≢¨b)(\∘⊢)⌷∘⍉)¨∘⊂⊢       ⍝ Fn: Binding level and depth
     gk←⊂⊣,⍤1 0(∪vs) ⋄ gi←⊂∘⍳gz←≢∘∪vs     ⍝ Fn: Binding key and slot
     w←⍵ ⋄ ep←(m←e∧n)⌿p ⋄ s←gz,gk,lr,gi   ⍝ AST temp, expr scopes, scope info fn
     edn←(en←S¨nm m⌿⍵),m⌿d,⍪⍳≢⍵           ⍝ Expression name, node, and depth
     z k l r i←(⊃⍪/)¨↓⍉ep s⌸edn           ⍝ Size, keys, levels, rows, ids
     (rf⌿3⌷⍉w)⍪←↓(⊂'alloca'),⍪⍕¨z         ⍝ Function frame size attributes
     ei←ep(⊂∘⍕i⊃¨∘⊂⍨k⍳⊣,⍤1 0(⊃⊢))⍤¯1⊢en   ⍝ Expression slot values
     (m⌿3⌷⍉w)⍪←↓(⊂'slots'),⍪⍕¨ei          ⍝ Slots attr. given to each named expr
     v←¯1⌽e\'atomic'∊∘⊂⍨'class'P e⌿⍵      ⍝ Mask of atomic expressions
     v∧←(1⌷⍉⍵)∊⊂'Variable'                ⍝ Mask of variable Expressions
     v≠←v\'⍺⍵'∊∘(,¨)⍨'name'P v⌿⍵          ⍝ Mask of non-⍺⍵ variables
     kr←(kp←⍉¯1↓⍉k),l,⍪r ⋄ vr←v⌿p,d,⍪⍳≢⍵  ⍝ Binding/variable unique range token
     kr vr←(rd←1+⌈⌿kr⍪vr)∘⊥∘⍉¨kr vr       ⍝ Decode range tokens
     kz←kp,kv⍳⍨av←∪(⊂''),kv←⊢/k           ⍝ Binding integer encoding
     vz←(vp←v⌿p),av⍳nm v⌿⍵                ⍝ Variable integer encoding
     vi←kr⍳kr⌈.×(kr∘.<vr)∧kz∧.(=∨0=⊣)⍉vz  ⍝ Variable resolutions referencing k
     pl←¯1++/∧.(=∨0=⊢)∘⍉⍨fp←rf⌿p          ⍝ Scope depths including root
     (v⌿3⌷⍉w)⍪←↓(⊂'slot'),⍪⍕¨vi⊃¨⊂i       ⍝ Variable slot attribute
     ve←⊃-/(pl⊃¨∘⊂⍨fp⍳⊢)¨vp(kp[vi;])      ⍝ Variable environment references
     (v⌿3⌷⍉w)⍪←↓(⊂'env'),⍪⍕¨ve            ⍝ Variable environment attributes
     w                                    ⍝ Return updated AST
 }