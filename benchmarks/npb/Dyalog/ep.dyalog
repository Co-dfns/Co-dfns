:Namespace EP
    ⎕IO ⎕ML←1 0
    
    Gen←⍬
    
    DoBlock←{
        n←⎕←⍵
        s←271828183
        r←Gen.RandI 2×n
        x y←⊂[2]¯1+2×r[¯1 0+[1]2 n⍴2×⍳n]
        tf←1≥t←⊃+/x y*2
        x y t←(⊂tf)/¨x y t
        X Y←x y×⊂((-2×⍟t)÷t)*÷2
        Q←+/(l∘.≤M)×(l+1)∘.<M←(|X)⌈|Y⊣l←¯1+⍳10
        (+/¨X Y),Q
    }
    
    ∇Run N
       Gen←⎕NEW #.Util(271828183,5*13)
       (N÷16)∘({⍵+DoBlock ⍺}⍣16) 12⍴0
    ∇

:EndNamespace
