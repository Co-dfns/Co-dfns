:Class NumVisitor: DefaultVisitor,NumberToken.NumTokVisitor
    ⎕IO ⎕ML←0 0
    
    ∇ N←NumCase(host param)
      :Implements Method NumberToken.NumTokVisitor.NumCase
      R←⎕NEW #.Number host
    ∇
:EndClass
