:Namespace EP
    ⎕IO ⎕ML←1 0
    
    Gen←⍬
    
    DoBlock←{
        n←⍵
        r←Gen.RandI 2×n
        ⍝ ⎕←'Randoms done.'
        x y←⊂[2]¯1+2×r[¯1 0+[1]2 n⍴2×⍳n]
        ⍝ ⎕←'Split done.'
        tf←1≥t←⊃+/x y*2
        ⍝ ⎕←'Test and filter done.'
        x y t←(⊂tf)/¨x y t
        ⍝ ⎕←'Shrinking x and y done.'
        X Y←x y×⊂((¯2×⍟t)÷t)*÷2
        ⍝ ⎕←'Computing X Y done.'
        Q←+/(l∘.≤M)×(l+1)∘.>M←(|X)⌈|Y⊣l←¯1+⍳10
        ⍝ ⎕←'Computing Q done.'
        (+/¨X Y),Q
    }
    
    ∇R←BS Run N;Time;C
       Gen←⎕NEW #.Random(271828183,5*13)
       Time←⎕NEW #.Timer
       C←⌊N÷BS
       Time.Start
       R←BS({⍵+DoBlock ⍺}⍣C)12⍴0
       R+←{0≠⍵: DoBlock ⍵ ⋄ 12⍴0} N-BS×C
       Time.End
       ⎕←'Running took ',(⍕Time.Spent),' seconds.'
    ∇

:EndNamespace
