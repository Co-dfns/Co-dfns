:Namespace Load
    Interfaces←'TokParser' 'NumTokParser' 'VarTokParser' 'AssgnTokParser'
    Interfaces,←'FactProto' 'ASTVis' 'ASTNumVis' 'ASTVarVis' 'ASTAssgnVis'
    Classes←'FileOutput' 'ChainTokParser'
    Classes,←'Token' 'NumToken' 'VarToken' 'AssgnToken' 'Tokenizer'
    Classes,←'ASTNode' 'ASTNumber' 'ASTVar' 'ASTAssgn'
    Classes,←'ASTFactory' 'NumFact' 'VarFact' 'AssgnFact' 'VarOrNumFact'
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
