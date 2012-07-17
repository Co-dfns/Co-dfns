:Class HPAPL
⎕IO ⎕ML←0 0

:Class FileOutput
    :Access Public
    :Field Private tie
    
    ∇ Make fname
      :Access Public
      :Implements Constructor
      :Trap 22
          tie←fname ⎕NCREATE 0
      :Else
          tie←fname ⎕NTIE 0
          fname ⎕NERASE tie
          tie←fname ⎕NCREATE 0
      :EndTrap
    ∇
    
    ∇ Close
      :Access Public
      ⎕NUNTIE tie
    ∇
    
    ∇ println data
      :Access Public
      (⎕UCS 'UTF-8' ⎕UCS data) ⎕NAPPEND tie,80
      (⎕UCS 10) ⎕NAPPEND tie,80
    ∇
    
:EndClass

:Class Token
    :Access Public
    
    :Field Public Instance lexeme
    
    ∇ Make value
      :Access Public
      :Implements Constructor
      lexeme←value
    ∇
    
    ∇ R←Exec(algo param)
      :Access Public 
      'METHOD NOT OVERIDDEN'⎕SIGNAL 11
    ∇
:EndClass
:Class NumberToken: Token
    :Access Public
    
    ∇ Make value
      :Access Public
      :Implements Constructor :Base (value)
    ∇
    
    ∇ R←Exec(algo param)
      :Access Public
      R←{NumTokVis∊⊃⎕CLASS ⍵: ⍵.NumCase ⎕THIS param
         ⍵.DefaultCase ⎕THIS param
      }algo
    ∇
    
:EndClass

:Class Tokenizer
    :Access Public

    :Field Private tokens
    :Field Private lasttok←⍬
    :Field Public types← ,(⊂'number')
    :Field Private tokpats← ,(⊂'[0-9]+')
    
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
    R←⎕NEW NumberToken(M.Block[(⊃M.Offsets)+⍳⊃M.Lengths])

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

:Class ASTNumber: ASTNode
    :Access Public
    
    :Field Public numtok  ⍝ NumberToken
    
    ∇ Make num
      :Access Public
      :Implements Constructor :Base #.ASTNumVis
      ⎕SIGNAL(~NumberToken∊⊃⎕CLASS num)/11
      numtok←num
    ∇
:EndClass
:Class ASTNode
    :Access Public
    :Field Private visitor
    
    ∇ Make vis
      :Access Public
      :Implements Constructor
      visitor←vis
    ∇
    
    ∇ R←Accept host
      :Access Public
      :If visitor∊⊃⎕CLASS host
          R←(visitor ⎕CLASS host).Visit ⎕THIS
      :Else
          R←(#.ASTVis ⎕CLASS host).Visit ⎕THIS
      :EndIf
    ∇
:EndClass

:Class ASTFactory
    :Access Public
    
    :Field Private tokenizer
    
    ∇ Make tkz
      :Access Public
      :Implements Constructor
      ⎕SIGNAL(~Tokenizer∊⊃⎕CLASS tkz)/11 ⍝ tkz is a Tokenizer
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
:Class NumFact: ASTFactory,#.FactProto
    :Access Public
    
    ∇ Make tkz
      :Access Public
      :Implements Constructor :Base tkz
    ∇
    
    :Class NumVis: ,#.NumTokVis,#.TokVisitor
        :Access Public
        
        ∇ R←NumCase(host param)
          :Implements Method #.NumTokVis.NumCase
          R←⎕NEW HPAPL.ASTNumber host
        ∇
        
        ∇ R←DefaultCase(host param)
          :Implements Method #.TokVisitor.DefaultCase
          'UNEXPECTED TOKEN'⎕SIGNAL 2
        ∇
    :EndClass
    
    ∇ R←MakeVisitor
      :Implements Method #.FactProto.MakeVisitor
      R←⎕NEW NumVis
    ∇
:EndClass

:Class OutCVisitor: ,#.ASTVis,#.ASTNumVis
    :Access Public
    :Field Private Instance out

    ∇ Make fout
      :Access Public
      :Implements Constructor
      out←fout
    ∇
    
    ∇ R←NumVisit host
      :Implements Method #.ASTNumVis.Visit
      out.println '#include <stdio.h>'
      out.println '#include <stdlib.h>'
      out.println ''
      out.println 'int main(int argc, char *argv[])'
      out.println '{'
      out.println '  int64_t x;'
      out.println '  x = ',host.numtok.lexeme,';'
      out.println '  printf("%d\n", x);'
      out.println '  return 0;'
      out.println '}'
      R←0 0⍴⍬
    ∇
    
    ∇ R←Visit host
      :Implements Method #.ASTVis.Visit
      'UNKNOWN AST NODE'⎕SIGNAL 11
      R←0 0⍴⍬
    ∇
:EndClass

:EndClass
