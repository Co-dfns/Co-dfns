:Namespace t0030_tests

⍝ A  B  E  F  G  L  M  N  O  P  V  Z
⍝ 0  1  2  3  4  5  6  7  8  9 10 11

sym_base←0,,¨'⍵' '⍺' '⍺⍺' '⍵⍵'
CR LF←⎕UCS 13 10
LFZ←∊LF,⍨⍪
EPR←{∊CR,'─'⍪⍨'─'⍪↑⍵[1 2]}

PARSE∆SUCC←{in←⍵⍵ ⋄ exp←⍺⍺ ⋄ ##.codfns.ps ⍵⍵⊣##.UT.expect←⍺⍺,⊂LFZ in}
PARSE∆FAIL←{in←⍵⍵ ⋄ EN DM←⍺⍺ ⋄ ##.UT.expect←EN DM (EPR DM)
 0::'Failure to execute ##.codfns.(EN DM)'
 0::##.codfns.(EN DM),⊂⎕DMX.Message
 ##.codfns.ps in}

inp←':Namespace' ':EndNamespace'
out←(,¨0 3 0 0 0 25)(⍬ ⍬)(sym_base)
∆0000_TEST←out PARSE∆SUCC inp

inp←':NamespAce' ':EnDnamespace'
out←(,¨0 3 0 0 0 25)(⍬ ⍬)(sym_base)
∆0001_TEST←out PARSE∆SUCC inp

inp←':Namespace' ':End'
out←2('SYNTAX ERROR' '[3] :End' '       ^')
∆0002_TEST←out PARSE∆FAIL inp

:EndNamespace