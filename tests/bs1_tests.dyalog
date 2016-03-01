:Namespace bs1

S←':Namespace' 'r←0.02	⋄ v←0.03' 
S,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
S,←'((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT' '}' ':EndNamespace'

GD←{⍉↑(5+?⍵⍴25)(1+?⍵⍴100)(0.25+100÷⍨?⍵⍴1000)}
D←⍉GD 7 ⋄ R←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L←,¯1↑D

''('bs1' S 'Run' #.util.GEN∆T2 ⎕THIS) L R

:EndNamespace
