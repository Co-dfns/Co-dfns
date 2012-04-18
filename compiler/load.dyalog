:Namespace Load
    Interfaces←'TokParser' 'NumTokParser' 'VarTokParser' 'AssgnTokParser'
    Interfaces,←'FactProto' 'ASTVis' 'ASTNumVis'
    Classes←1⍴⊂'FileOutput'
    Classes,←'Token' 'NumToken' 'VarToken' 'AssgnToken' 'Tokenizer'
    Classes,←'ASTNode' 'ASTNumber'
    Classes,←'ASTFactory' 'NumFact'
    Classes,←⊂'OutCVisitor'
    
    ∇ TangleLoad CN;N
      CN #.ConTeXtLP.Tangle './hpapl.tex' './tmp.dyalog'
      N←#.⎕SE.SALT.Load './tmp -Target=#'
      ⎕←'Loaded ',⍕N
    ∇
    
    ∇ All
      TangleLoad¨Interfaces,¨⊂' Interface'
      TangleLoad¨Classes,¨⊂' Class'
    ∇
:EndNamespace
