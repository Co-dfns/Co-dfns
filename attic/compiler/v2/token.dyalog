:Class Token
    ⎕IO ⎕ML←0 0
    :Field Private Instance lexeme
    ∇ Make value
      :Access Public
      :Implements Constructor
      lexeme←value
    ∇
:EndClass
