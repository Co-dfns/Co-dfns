:Class ASTNumber
    ⎕IO ⎕ML←0 0
    
    :Field Public numtok  ⍝ NumberToken
    
    ∇ Make num
      :Access Public
      :Implements Constructor
      ⎕SIGNAL(#.NumberToken≠⊃⎕CLASS num)/11
      numtok←num
    ∇
:EndClass
