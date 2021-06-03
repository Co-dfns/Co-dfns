:Namespace t0030_tests

⍝ A  B  E  F  G  L  M  N  O  P  V  Z
⍝ 0  1  2  3  4  5  6  7  8  9 10 11

sym_base←0,,¨'⍵' '⍺' '⍺⍺' '⍵⍵'
CR LF←⎕UCS 13 10
LFZ←∊LF,⍨⍪
EPR←{∊CR,'─'⍪⍨'─'⍪↑⍵[1 2]}

∆0000_TEST←{in←':Namespace' ':EndNamespace'
 d←,0
 t←,3
 k←,0
 n←,0
 ss←,0
 se←,25
 exn←⍬
 ext←⍬
 sym←sym_base
 ##.codfns.ps in⊣##.UT.expect←(d t k n ss se) (exn ext) sym,⊂src←LFZ in}

∆0001_TEST←{in←':NamespAce' ':EnDnamespace'
 d←,0
 t←,3
 k←,0
 n←,0
 ss←,0
 se←,25
 exn←⍬
 ext←⍬
 sym←sym_base
 ##.codfns.ps in⊣##.UT.expect←(d t k n ss se) (exn ext) sym,⊂src←LFZ in}

∆0002_TEST←{in←':Namespace' ':End'
 EN←2 ⋄ DM←'SYNTAX ERROR' '[3] :End' '       ^'
 ##.UT.expect←EN DM (EPR DM)
 0::'Failure to execute ##.codfns.(EN DM)'
 0::##.codfns.(EN DM),⊂⎕DMX.Message
 ##.codfns.ps in}

:EndNamespace