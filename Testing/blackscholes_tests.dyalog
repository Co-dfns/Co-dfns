:Namespace blackscholes

⍝ Test the Black Scholes benchmark for the correct output

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

C←#.codfns.C

gcc_TEST←{D←⍉GD 7 ⋄ R←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L←,¯1↑D ⋄ C.compiler←'gcc'
  _←'Scratch/blackscholes_gcc.c'#.codfns.C.Fix BS
  _←⎕SH './gcc Scratch/blackscholes_gcc'
  _←'Run_gcc'⎕NA'./Scratch/blackscholes_gcc.so|Run >PP <PP <PP'
  #.UT.expect←interp←L NS.Run R
  Run_gcc 0 L R}

icc_TEST←{D←⍉GD 7 ⋄ R←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L←,¯1↑D ⋄ C.compiler←'icc'
  _←'Scratch/blackscholes_icc.c'#.codfns.C.Fix BS
  _←⎕SH './icc Scratch/blackscholes_icc'
  _←'Run_icc'⎕NA'./Scratch/blackscholes_icc.so|Run >PP <PP <PP'
  #.UT.expect←interp←L NS.Run R ⋄ C.compiler←'gcc'
  Run_icc 0 L R}

pgi_TEST←{D←⍉GD 7 ⋄ R←⊃((⎕DR 2↑D)323)⎕DR 2↑D ⋄ L←,¯1↑D ⋄ C.compiler←'pgcc'
  _←'Scratch/blackscholes_pgi.c'#.codfns.C.Fix BS
  _←⎕SH './pgi Scratch/blackscholes_pgi'
  _←'Run_pgi'⎕NA'./Scratch/blackscholes_pgi.so|Run >PP <PP <PP'
  #.UT.expect←interp←L NS.Run R ⋄ C.compiler←'gcc'
  Run_pgi 0 L R}


:EndNamespace
