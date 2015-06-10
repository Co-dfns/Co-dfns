:Namespace blackscholes

BS←':Namespace' 'r←0.02	⋄ v←0.03' 
BS,←⊂'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
BS,←⊂'CNDP2←{L←|⍵ ⋄ B←⍵≥0'
BS,←⊂'R←(÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L'
BS,←'(1	¯1)[B]×((0 ¯1)[B])+R' '}'
BS,←'Run←{' 'S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5'
BS,←⊂'D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT'
BS,←⊂'CD1←CNDP2 D1 ⋄ CD2←CNDP2 D2 ⋄ e←*(-r)×T'
BS,←⊂'((S×CD1)-X×e×CD2),[0.5](X×e×1-CD2)-S×1-CD1'
BS,←'}' ':EndNamespace'

NS←⎕FIX BS

GD←{⍉↑(5+?⍵⍴25)(1+?⍵⍴100)(0.25+100÷⍨?⍵⍴1000)}

icc_TEST←{D←⍉GD 7 ⋄ R←2↑D ⋄ L←,¯1↑D ⋄ interp←L NS.Run R
  _←'Scratch/blackscholes_icc.c'#.codfns.C.Fix BS
  _←⎕SH './icc Scratch/blackscholes_icc'
  _←'Run_icc'⎕NA'./Scratch/blackscholes_icc.so|Run >PP <PP <PP'
  #.UT.expect←7 2⍴1
  0.0000001≥interp-Run_icc 0 L (⊃((⎕DR R)323)⎕DR R)}

pgi_TEST←{D←⍉GD 7 ⋄ R←2↑D ⋄ L←,¯1↑D ⋄ interp←L NS.Run R
  _←'Scratch/blackscholes_pgi.c'#.codfns.C.Fix BS
  _←⎕SH './pgi Scratch/blackscholes_pgi'
  _←'Run_pgi'⎕NA'./Scratch/blackscholes_pgi.so|Run >PP <PP <PP'
  #.UT.expect←7 2⍴1
  0.0000001≥interp-Run_pgi 0 L (⊃((⎕DR R)323)⎕DR R)}


:EndNamespace
