:Class Timer
    ⎕IO ⎕ML←0 0
    
    start←0
    end←0
    
    ∇ T←CurrentTime
      :Access Public
      T←(÷1000)×24 60 60 1000⊥3↓⎕TS
    ∇
    
    ∇ Start
      :Access Public
      start←CurrentTime
    ∇
    
    ∇ End
      :Access Public
      end←CurrentTime
    ∇
    
    ∇ Extend
      :Access Public
      End
    ∇
    
    ∇ R←Spent
      :Access Public
      R←end-start
    ∇
:EndClass
