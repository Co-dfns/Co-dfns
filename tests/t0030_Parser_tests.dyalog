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
out←2('SYNTAX ERROR' '[2] :End' '       ^')
∆0002_TEST←out PARSE∆FAIL inp

NS←{(⊂':Namespace'),⍵,⊂':EndNamespace'}

inp←NS⊂'5'
ast←(0 1 2)(3 0 7)(0 0 0)(0 0 ¯5)(0 10 10)(27 11 11)
out←ast(⍬ ⍬)(sym_base,5)
∆0003_TEST←out PARSE∆SUCC inp

inp←NS⊂'123'
ast←(0 1 2)(3 0 7)(0 0 0)(0 0 ¯5)(0 10 10)(29 13 13)
out←ast(⍬ ⍬)(sym_base,123)
∆0004_TEST←out PARSE∆SUCC inp

inp←NS⊂'.5'
ast←(0 1 2)(3 0 7)(0 0 0)(0 0 ¯5)(0 10 10)(28 12 12)
out←ast(⍬ ⍬)(sym_base,.5)
∆0005_TEST←out PARSE∆SUCC inp

inp←NS⊂'05.123'
ast←(0 1 2)(3 0 7)(0 0 0)(0 0 ¯5)(0 10 10)(32 16 16)
out←ast(⍬ ⍬)(sym_base,5.123)
∆0006_TEST←out PARSE∆SUCC inp

inp←NS⊂'¯05'
ast←(0 1 2)(3 0 7)(0 0 0)(0 0 ¯5)(0 10 10)(29 13 13)
out←ast(⍬ ⍬)(sym_base,¯5)
∆0007_TEST←out PARSE∆SUCC inp

inp←NS⊂'¯05.123'
ast←(0 1 2)(3 0 7)(0 0 0)(0 0 ¯5)(0 10 10)(33 17 17)
out←ast(⍬ ⍬)(sym_base,¯5.123)
∆0008_TEST←out PARSE∆SUCC inp

inp←NS⊂'¯05.'
ast←(0 1 2)(3 0 7)(0 0 0)(0 0 ¯5)(0 10 10)(30 14 14)
out←ast(⍬ ⍬)(sym_base,¯5)
∆0009_TEST←out PARSE∆SUCC inp

inp←NS⊂'(¯05.)'
ast←(0 1 2)(3 0 7)(0 0 0)(0 0 ¯5)(0 11 11)(32 15 15)
out←ast(⍬ ⍬)(sym_base,¯5)
∆0010_TEST←out PARSE∆SUCC inp

inp←NS⊂'⍬'
ast←(0 1)(3 0)(0 0)(0 0)(0 10)(27 11)
out←ast(⍬ ⍬)(sym_base)
∆0011_TEST←out PARSE∆SUCC inp

inp←NS⊂'⍬(5 4) 5'
d←  0  1  2  2  3  3  2  3
t←  3  0  0  0  7  7  0  7
k←  0  3  0  0  0  0  0  0
n←  0  0  0  0 ¯5 ¯6  0 ¯5
ss← 0 10 10 12 12 13 16 16
se←34 18 11 15 13 15 18 18
out←(d t k n ss se)(⍬ ⍬)(sym_base,5 4)
∆0012_TEST←out PARSE∆SUCC inp

inp←NS⊂'(4'
out←2('SYNTAX ERROR' '[2] (4' '    ^ ')
∆0013_TEST←out PARSE∆FAIL inp

inp←NS⊂'¯ 4'
out←2('SYNTAX ERROR' '[2] ¯ 4' '    ^  ')
∆0014_TEST←out PARSE∆FAIL inp

inp←NS⊂'4)'
out←2('SYNTAX ERROR' '[2] 4)' '     ^')
∆0015_TEST←out PARSE∆FAIL inp

inp←NS⊂'⍬(5 4) 5[1 2 3]'
d←  0  1  2  3  3  4  4 3   4  2  2  3  4  4   4
t←  3  2  0  0  0  7  7 0   7  9  2  0  7  7   7
k←  0  2  3  0  0  0  0 0   0  1  3  0  0  0   0
n←  0  0  0  0  0 ¯5 ¯6 0  ¯5 ¯7  0  0 ¯8 ¯9 ¯10
ss← 0 10 10 10 12 12 13 16 16 18 18 19 19  20 22
se←41 25 18 11 15 13 15 18 18 18 25 24 20  22 24
out←(d t k n ss se)(⍬ ⍬)(sym_base,5 4(,'[')1 2 3)
∆0016_TEST←out PARSE∆SUCC inp

inp←NS⊂'⍬(5 4) 5[1 2 3'
out←2('SYNTAX ERROR' '[2] ⍬(5 4) 5[1 2 3' '            ^     ')
∆0017_TEST←out PARSE∆FAIL inp

inp←NS⊂'⍬(5 4) 5 1 2 3]'
out←2('SYNTAX ERROR' '[2] ⍬(5 4) 5 1 2 3]' '                  ^')
∆0018_TEST←out PARSE∆FAIL inp

inp←NS⊂'name'
out←6('VALUE ERROR' '[2] name' '    ^   ')
∆0019_TEST←out PARSE∆FAIL inp

:EndNamespace