:Class ASTFactory
    ⎕IO ⎕ML←0 0
    
    :Field Private tokenizer
    
    ∇ Make tkz
      ⎕SIGNAL(#.Tokenizer≠⊃⎕CLASS tkz)/11 ⍝ tkz is a Tokenizer
      tokenizer←tkz
    ∇
    
    ∇ R←NextToken
      :Access Public
      R←tokenizer.NextToken
    ∇
    
    ∇ PutBackToken
      :Access Public
      tokenizer.PutBackToken
    ∇
:EndClass
