:Class Util
   ⎕IO ⎕ML←0 0
   Seed A V←0 0,2*24
   
   ∇Make S
    :Access Public
    :Implements Constructor
    ⎕SIGNAL (1≡⊃⍴S)/11
    Seed A←S,5*13
   ∇
   
   ∇MakeWithA(s a)
    :Access Public
    :Implements Constructor
    Seed A←s a
   ∇
   
   Mul←{(2*46)|V⊥(V|A+.×B),[¯0.5](0⌷A←⌽V V⊤⍺)×1⌷B←V V⊤⍵}
	
   ∇R←RandI N
    :Access Public
    R←Seed
	0 0⍴({⍵ Mul ⍵⊣R,←⍵ Mul R}⍣(⌈2⍟N))A
	Seed←⊢/R←N↑R⊣R,←A Mul⊢/R←1↓R
	R←R×2*¯46
   ∇
   
   ∇S TimerSecs E
	(÷1000)×-/24 60 60 1000∘{⍺⊥3↓⍵}¨E S
   ∇
   
:EndClass
