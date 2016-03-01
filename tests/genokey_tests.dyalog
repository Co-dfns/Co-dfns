:Namespace genokey

S←⊂':Namespace'
S,←⊂'rp_joinx←{'
S,←⊂'⍝ Join relations ⍺ and ⍵ into a single relation'
S,←⊂'⍝ 1994-03-17 / GLM'
S,←⊂'⍝ 1999-06-17 / GLM'
S,←⊂'     A0 V0←⍺'
S,←⊂'     A1 V1←⍵'
S,←⊂'     V←V0,V1                         ⍝ both sets of variables'
S,←⊂'     (⍳≢V)≡V⍳V:(↓[0]↑,(↓[0]↑A0)∘.,↓[0]↑A1)[I](V[I←⍋V])    ⍝ if no common variables'
S,←⊂'     BM←1'
S,←⊂'     colligate←{                     ⍝ colligate common variables two at a time'
S,←⊂'         G0←⍺⍳⍨D0←∪⍺'
S,←⊂'         G1←⍵⍳⍨D1←∪⍵'
S,←⊂'         J0←D0∘.∩D1                  ⍝ The unique elements are colligated by intersection'
S,←⊂'         BM∧←0≠G0 G1⌷≢¨J0'
S,←⊂'         J0 G0 G1'
S,←⊂'     }'
S,←⊂'     R←((V0∊V1)/A0)colligate¨(V1∊V0)/A1'
S,←⊂'     I0 I1←↓(⍴BM)⊤(,BM)/⍳×/⍴BM'
S,←⊂'     ⍬≡I0:⍬                          ⍝ Exit if contradiction'
S,←⊂'     CA←{(0⊃⍵)[((1⊃⍵)[I0]),¨(2⊃⍵)[I1]]}¨R'
S,←⊂'     A0←↓(↑(~V0∊V1)/A0)[;I0]         ⍝ Arguments of free variables in first  relation in the joined relation'
S,←⊂'     A1←↓(↑(~V1∊V0)/A1)[;I1]         ⍝ Arguments of free variables in second relation in the joined relation'
S,←⊂'     V←(V0∩V1),(V0~V1),V1~V0'
S,←⊂'     (CA,A0,A1)[I](V[I←⍋V])          ⍝ Joined relation ordered by variables'
S,←⊂'}'
S,←⊂':EndNamespace'

∇AF←af BA
⍝ 1993-02-16 / GLM
⍝ BA: binary array in N dimensions
⍝ AF: the affirmative form (list with N elements)
⍝     Note that the legal tuples are determined	as pack	AF)
 AF←↓(⍴BA)⊤(,BA)/⍳⍴,BA
∇

⎕SE.SALT.Load './Testing/genokey_RP0'
⎕SE.SALT.Load './Testing/genokey_RP1'
RP2←((af∘.≤⍨0 1)(0 1))((af∘.∨⍨0 1)(2 3))

genokey_TEST←{#.UT.expect←0 ⋄ 1}

:EndNamespace