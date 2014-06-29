 LiftFuncs←{
     I←¯1 ⋄ MkV←{'FN',⍕I⊣(⊃I)+←1}         ⍝ New variable maker
     vis←{lft ast←⍵                       ⍝ Fn to visit each node
         (0=⍺⍺)∧'Function'≡⊃0 1⌷⍺:⍺(⍺⍺{     ⍝ Traverse Top-level Fn Nodes
             z←(⌽1 Kids ⍺),⊂lft MtAST         ⍝ Recur over children
             lft ka←⊃(1+⍺⍺)vis/z              ⍝ Bump up the depth for kids
             lft(ast⍪(1↑⍺)⍪ka)                ⍝ Return unchanged
         })⍵
         'Function'≡⊃0 1⌷⍺:⍺(⍺⍺{            ⍝ Only lift nested Function nodes
             z←(⌽1 Kids ⍺),⊂lft MtAST         ⍝ Recur over children, updating lifted
             lft ka←⊃(1+⍺⍺)vis/z              ⍝ Bump up the depth over children
             (0⌷⍉ka)-←(⊃ka)-3                 ⍝ Lift children down to root depth 3
             at←(⊃0 3⌷⍺)⍪'depth'(⍕⍺⍺)         ⍝ New depth attribute for Function node
             nfn←(1 4⍴2,(0(1 2)⌷⍺),⊂at)⍪ka    ⍝ New Fn node lifted to depth 2
             at←1 2⍴'name'(nm←MkV ⍬)           ⍝ Fe gets new name
             at⍪←'class' 'ambivalent'         ⍝ Ambivalent class; this is a Fn
             nlf←(1 4⍴1 'FuncExpr' ''at)⍪nfn ⍝ Containing Fe node at depth 1
             vn←1 2⍴'class' 'ambivalent'      ⍝ Replace with ambivalent variable
             vn⍪←2 2⍴'depth'(⍕⍺⍺)'name'nm    ⍝ With the same depth and new name
             vn←1 4⍴(⊃⍺)'Variable' ''vn      ⍝ Node has same depth
             (lft⍪nlf)(ast⍪vn)                ⍝ Fn lifted and replaced by variable
         })⍵
         z←(⌽1 Kids ⍺),⊂lft MtAST           ⍝ Otherwise, traverse
         nlf ka←⊃∇/z                        ⍝ without changing anything
         nlf(ast⍪(1↑⍺)⍪ka)                  ⍝ Tack on the head
     }
     z←(⌽1 Kids ⍵),⊂2⍴⊂MtAST              ⍝ Must traverse all top-level
     (1↑⍵)⍪⊃⍪/⊃0 vis/z                    ⍝ Nodes just the same
 }
