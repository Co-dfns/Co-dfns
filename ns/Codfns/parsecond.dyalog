 ParseCond←{cod env←⍺⍺
     err ast ne←env ParseExpr ⍺           ⍝ Try to parse the test expression 1st
     0≠err:⎕SIGNAL err                    ⍝ Parsing test expression failed
     (0⌷⍉ast)+←1                          ⍝ Bump test depth to fit in condition
     m←(¯1+⊃⍺)'Condition' ''MtA          ⍝ We're returning a condition node
     0=≢⍵:(cod⍪m⍪ast)ne                   ⍝ Emtpy consequent expression
     err con ne←ne ParseExpr ⍵            ⍝ Try to parse consequent
     0≠err:⎕SIGNAL err                    ⍝ Failed to parse consequent
     (0⌷⍉con)+←1                          ⍝ Consequent depth jumps as well
     (cod⍪m⍪ast⍪con)ne                    ⍝ Condition with conseuqent and test
 }