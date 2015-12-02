:Namespace scalar

BS←':Namespace' 'r←0.02	⋄ v←0.03' 
BS,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
BS,←⊂'L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT'
BS,←⊂'(÷(○2)*0.5)×(*(L×L)÷¯2)×÷1+0.2316419×L' 
BS,←'}' ':EndNamespace'

D←{⍉1+?⍵ 3⍴1000}2*20 ⋄ L←,¯1↑D ⋄ R←2↑D

''('scalar' BS 'Run' #.util.GEN∆T3 ⎕THIS) L R

:EndNamespace
