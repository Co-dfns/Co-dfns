:Namespace bs2

S←':Namespace' 'r←0.02	⋄ v←0.03' 
S,←⊂'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
S,←⊂'CNDP2←{L←|⍵ ⋄ B←⍵≥0'
S,←⊂'R←(÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L'
S,←'(1 ¯1)[B]×((0 ¯1)[B])+R' '}'
S,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
S,←⊂'D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT'
S,←'CNDP2 D1' '}' ':EndNamespace'

GD←{⍉↑(5+?⍵⍴25)(1+?⍵⍴100)(0.25+100÷⍨?⍵⍴1000)}
D←⍉GD 7 ⋄ R←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L←,¯1↑D 

''('bs2' S 'Run' #.GEN∆T3 ⎕THIS) L R

:EndNamespace
