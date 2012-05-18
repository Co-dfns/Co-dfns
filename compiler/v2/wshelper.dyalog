:Namespace WSHelper

    ∇ C TangleLoad FN;O
      C #.ConTeXtLP.Tangle (⊂'./hpapl.tex'),⊂('./',FN,'.dyalog')
      O←#.⎕SE.SALT.Load './',FN,' -Target=#'
      ⎕←'Loaded ',⍕O
    ∇

    ∇ Load;chunks;output
      #.⎕SE.SALT.Load './ConTeXtLP -Target=#'
      'Workspace Helper' TangleLoad 'wshelper' 
      'Token Class' TangleLoad 'token'
'NumberToken Class' TangleLoad 'numbertoken'
'Tokenizer Class' TangleLoad 'tokenizer'
'ASTNumber Class' TangleLoad 'astnumber'
'ASTFactory Class' TangleLoad 'astfactory'
'FactoryProtocol Interface' TangleLoad 'factoryprotocol'
'DefaultVisitor Class' TangleLoad 'defaultvisitor'
⍝ 'NumVisitor Class' TangleLoad 'numvisitor' 

    ∇

:EndNamespace
