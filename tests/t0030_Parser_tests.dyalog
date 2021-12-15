:Namespace t0030_tests

⍝ A  B  E  F  G  L  M  N  O  P  V  Z
⍝ 0  1  2  3  4  5  6  7  8  9 10 11

A B C E F G K L M N O P S V Z←1+⍳15

sym_base←,¨'' '⍵' '⍺' '⍺⍺' '⍵⍵' ⋄ mt_env←(0⍴⊂'')⍬
CR LF←⎕UCS 13 10
LFZ←∊LF,⍨⍪

PARSE∆SUCC←{in←⍵⍵ ⋄ exp←⍺⍺ ⋄ ##.codfns.PS ⍵⍵⊣##.UT.expect←⍺⍺,⊂LFZ in}
PARSE∆FAIL←{in←⍵⍵ ⋄ EN DM MSG←⍺⍺
 ##.UT.expect←EN DM EN 'Compiler' 'Co-dfns' MSG
 0::'Failure to execute ##.codfns.(EN DM)'
 0::##.codfns.(EN DM),⎕DMX.(EN Category Vendor Message)
 ##.codfns.PS in}

inp←':Namespace' ':EndNamespace'
out←(,¨0 F 0 0 0 24)mt_env sym_base
∆0000_TEST←out PARSE∆SUCC inp

inp←':NamespAce' ':EnDnamespace'
out←(,¨0 F 0 0 0 24)mt_env sym_base
∆0001_TEST←out PARSE∆SUCC inp

inp←':Namespace' ':End'
msg←'STRUCTURED STATEMENTS MUST APPEAR WITHIN TRAD-FNS',CR
msg,←'[2] :End',CR
msg,←'    ▔▔▔▔ '
out←2('SYNTAX ERROR' '[2] :End' '    ^')msg
∆0002_TEST←out PARSE∆FAIL inp

NS←{(⊂':Namespace'),⍵,⊂':EndNamespace'}

inp←NS⊂'5'
ast←(0 1 2)(F A N)(0 1 1)(0 0 ¯5)(0 11 11)(26 12 12)
out←ast mt_env(sym_base,5)
∆0003_TEST←out PARSE∆SUCC inp

inp←NS⊂'123'
ast←(0 1 2)(F A N)(0 1 1)(0 0 ¯5)(0 11 11)(28 14 14)
out←ast mt_env(sym_base,123)
∆0004_TEST←out PARSE∆SUCC inp

inp←NS⊂'.5'
ast←(0 1 2)(F A N)(0 1 1)(0 0 ¯5)(0 11 11)(27 13 13)
out←ast mt_env(sym_base,.5)
∆0005_TEST←out PARSE∆SUCC inp

inp←NS⊂'05.123'
ast←(0 1 2)(F A N)(0 1 1)(0 0 ¯5)(0 11 11)(31 17 17)
out←ast mt_env(sym_base,5.123)
∆0006_TEST←out PARSE∆SUCC inp

inp←NS⊂'¯05'
ast←(0 1 2)(F A N)(0 1 1)(0 0 ¯5)(0 11 11)(28 14 14)
out←ast mt_env(sym_base,¯5)
∆0007_TEST←out PARSE∆SUCC inp

inp←NS⊂'¯05.123'
ast←(0 1 2)(F A N)(0 1 1)(0 0 ¯5)(0 11 11)(32 18 18)
out←ast mt_env(sym_base,¯5.123)
∆0008_TEST←out PARSE∆SUCC inp

inp←NS⊂'¯05.'
ast←(0 1 2)(F A N)(0 1 1)(0 0 ¯5)(0 11 11)(29 15 15)
out←ast mt_env(sym_base,¯5)
∆0009_TEST←out PARSE∆SUCC inp

inp←NS⊂'(¯05.)'
ast←(0 1 2)(F A N)(0 1 1)(0 0 ¯5)(0 12 12)(31 16 16)
out←ast mt_env(sym_base,¯5)
∆0010_TEST←out PARSE∆SUCC inp

inp←NS⊂'⍬'
ast←(0 1)(F A)(0 1)(0 ¯5)(0 11)(26 12)
out←ast mt_env(sym_base,⊂,'⍬')
∆0011_TEST←out PARSE∆SUCC inp

inp←NS⊂'⍬(5 4) 5'
d←  0  1  2  2  3  3  2  3
t←  F  A  A  A  N  N  A  N
k←  0  6  1  1  1  1  1  1
n←  0  0 ¯5  0 ¯6 ¯7  0 ¯6
ss← 0 11 11 13 13 15 18 18
se←33 19 12 16 14 16 19 19
out←(d t k n ss se)mt_env(sym_base,(,'⍬')5 4)
∆0012_TEST←out PARSE∆SUCC inp

inp←NS⊂'(4'
msg←'UNBALANCED PARENTHESES',CR
msg,←'[2] (4',CR
msg,←'    ▔▔ '
out←2('SYNTAX ERROR' '[2] (4' '    ^ ') msg
∆0013_TEST←out PARSE∆FAIL inp

inp←NS⊂'¯ 4'
msg←'ORPHANED ¯',CR
msg,←'[2] ¯ 4',CR
msg,←'    ▔   '
out←2('SYNTAX ERROR' '[2] ¯ 4' '    ^  ') msg
∆0014_TEST←out PARSE∆FAIL inp

inp←NS⊂'4)'
msg←'UNBALANCED PARENTHESES',CR
msg,←'[2] 4)',CR
msg,←'     ▔ '
out←2('SYNTAX ERROR' '[2] 4)' '     ^') msg
∆0015_TEST←out PARSE∆FAIL inp

inp←NS⊂'⍬(5 4) 5[1 2 3]'
d←  0  1  2  3 3  4   4  3  4  2  2  3  4   4   4
t←  F  E  A  A A  N   N  A  N  P  E  A  N   N   N
k←  0  2  6  1 1  1   1  1  1  2  6  1  1   1   1
n←  0  0  0 ¯6 0 ¯7  ¯8  0 ¯7 ¯5  0  0 ¯9 ¯10 ¯11
ss← 0 11 11 11 13 13 15 18 18 19 19 20 20  22  24
se←40 26 19 12 16 14 16 19 19 20 26 25 21  23  25
out←(d t k n ss se)mt_env(sym_base,(,'[')(,'⍬')5 4 1 2 3)
∆0016_TEST←out PARSE∆SUCC inp

inp←NS⊂'⍬(5 4) 5[1 2 3'
msg←'UNBALANCED BRACKETS',CR
msg,←'[2] ⍬(5 4) 5[1 2 3',CR
msg,←'            ▔▔▔▔▔▔ '
out←2('SYNTAX ERROR' '[2] ⍬(5 4) 5[1 2 3' '            ^     ')msg
∆0017_TEST←out PARSE∆FAIL inp

inp←NS⊂'⍬(5 4) 5 1 2 3]'
out←2('SYNTAX ERROR' '[2] ⍬(5 4) 5 1 2 3] ' '    ^               ')
∆0018_TEST←out PARSE∆FAIL inp

inp←NS⊂'name'
out←6('VALUE ERROR' '[2] name ' '    ^    ')
∆0019_TEST←out PARSE∆FAIL inp

inp←NS'blah←5' '⎕blah'
out←2('SYNTAX ERROR' '[3] ⎕blah ' '    ^     ')
∆0020_TEST←out PARSE∆FAIL inp

inp←NS'FFT←5' '⎕FFT'
d←  0  1  2  3  1
t←  F  B  A  N  P 
k←  0  0  0  0  1
n←  0 ¯5  0 ¯6 ¯7
ss← 0 11 15 15 17
se←36 15 16 16 21
out←(d t k n ss se)((,⊂'FFT')(,0))(sym_base,'FFT' 5 '⎕FFT')
∆0021_TEST←out PARSE∆SUCC inp

inp←NS'F←{' '4+5+' '}'
out←2('SYNTAX ERROR' '[3] 4+5+ ' '      ^  ')
∆0022_TEST←out PARSE∆FAIL inp

inp←NS'F←{' '4+⍵' '}'
d←  0  1  2  3  4  5  4  4
t←  F  B  F  E  A  N  P  V
k←  0  1  1  2  0  0  1  0
n←  0 ¯5  0  0  0 ¯6 ¯7 ¯1
ss← 0 11 14 15 15 15 16 17
se←35 13 21 17 16 16 17 18
out←(d t k n ss se)((,⊂,'F')(,1))(sym_base,(,'F')4(,'+'))
∆0023_TEST←out PARSE∆SUCC inp

:EndNamespace