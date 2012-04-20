:Namespace Load
    Interfaces←'TokParser' 'NumTokParser' 'VarTokParser' 'AssgnTokParser'
    Interfaces,←'FactProto' 'ASTVis' 'ASTNumVis' 'ASTVarVis' 'ASTAssgnVis'
    Classes←1⍴⊂'FileOutput'
    Classes,←'Token' 'NumToken' 'VarToken' 'AssgnToken' 'Tokenizer'
    Classes,←'ASTNode' 'ASTNumber' 'ASTVar' 'ASTAssgn'
    Classes,←'ASTFactory' 'NumFact' 'VarFact' 'AssgnFact'
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
