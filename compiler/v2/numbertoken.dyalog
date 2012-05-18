:Class NumberToken: Token
    ⎕IO ⎕ML←0 0
    :Interface NumTokVisitor
    :Access Public
    ∇N←NumCase(host param)
    ∇
:EndInterface

    ∇ R←Exec(algo param)
  :If NumTokVisitor=⊃⎕CLASS algo
      R←algo.NumCase ⎕THIS param
  :Else 
      R←algo.DefCase ⎕THIS param
  :EndIf
∇

    ∇ Make value
      :Access Public 
      :Implements Constructor :Base value
    ∇
:EndClass
