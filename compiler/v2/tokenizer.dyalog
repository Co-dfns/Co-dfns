:Class Tokenizer
    ⎕IO ⎕ML←0 0
    :Field Private tokens
    :Field Private lasttok←⍬
    :Field Public types← 1⍴⊂'number'
    :Field Private tokpats← 1⍴⊂'[0-9]+'
    
    ∇ R←NextToken
  :Access Public
  :If 0<⍴tokens
      R←lasttok←⊃tokens
      tokens←1↓tokens
  :Else
      R←⍬
  :EndIf
∇

∇ PutBackToken
  :Access Public
  tokens←lasttok,tokens
∇

    
    ∇ R←MakeToken M;F
      F←(types∘⍳)∘⊂
      :Select M.PatternNum
      :Case F'number'
    R←⎕NEW #.NumberToken(M.Block[(⊃M.Offsets)+⍳⊃M.Lengths])

      :Else 
          'UNKNOWN TOKEN TYPE'⎕SIGNAL 11
      :EndSelect
    ∇
    
    ∇ Make file;tie
      :Access Public
      :Implements Constructor
      tie←file ⎕NTIE 0
      tokens←(tokpats⎕S MakeToken ⍠ 'Mode' 'D') tie
      ⎕NUNTIE tie
    ∇
    
:EndClass
