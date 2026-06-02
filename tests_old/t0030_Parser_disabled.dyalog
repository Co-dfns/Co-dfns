:Namespace t0030_tests

⍝ A  B  E  F  G  L  M  N  O  P  V  Z
⍝ 0  1  2  3  4  5  6  7  8  9 10 11

A B C E F G K L M N O P S V Z←1+⍳15

sym_base←,¨'' '⍵' '⍺' '⍺⍺' '⍵⍵' ⋄ mt_env←(0⍴⊂'')⍬
CR LF←⎕UCS 13 10
LFZ←∊LF,⍨⍪∘⊆

PARSE∆SUCC←{in←⍵⍵ ⋄ exp←⍺⍺ ⋄ ##.UT.expect←⍺⍺,⊂LFZ in
  (d t k n ss se)env sym src←##.codfns.PS ⍵⍵
  (d t k(sym[-n])(ss{src[⍺+⍳⍵-⍺]}¨se))env sym src}
PARSE∆FAIL←{in←⍵⍵ ⋄ EN DM MSG←⍺⍺
 ##.UT.expect←EN DM EN 'Compiler' 'Co-dfns' MSG
 0::'Failure to execute ##.codfns.(EN DM)'
 0::##.codfns.(EN DM),⎕DMX.(EN Category Vendor Message)
 ##.codfns.PS in}

inp←':Namespace' ':EndNamespace'
out←(,¨0 F 0(1⍴⊂'')(,⊂¯1↓LFZ inp))mt_env sym_base
∆0000_TEST←out PARSE∆SUCC inp

inp←':NamespAce' ':EnDnamespace'
out←(,¨0 F 0(1⍴⊂'')(,⊂¯1↓LFZ inp))mt_env sym_base
∆0001_TEST←out PARSE∆SUCC inp

inp←':Namespace' ':End'
msg←'STRUCTURED STATEMENTS MUST APPEAR WITHIN TRAD-FNS',CR
msg,←'[2] :End',CR
msg,←'    ▔▔▔▔ '
out←2('SYNTAX ERROR' '[2] :End' '    ^   ')msg
∆0002_TEST←out PARSE∆FAIL inp

NS←{(⊂':Namespace'),⍵,⊂':EndNamespace'}

oup←¯1↓LFZ⊢inp←NS⊂'5'
ast←(0 1 2)(F A N)(0 1 1)('' '' 5)(,¨oup '5' '5')
out←ast mt_env(sym_base,5)
∆0003_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'123'
ast←(0 1 2)(F A N)(0 1 1)('' '' 123)(,¨oup '123' '123')
out←ast mt_env(sym_base,123)
∆0004_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'.5'
ast←(0 1 2)(F A N)(0 1 1)('' '' .5)(,¨oup '.5' '.5')
out←ast mt_env(sym_base,.5)
∆0005_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'05.123'
ast←(0 1 2)(F A N)(0 1 1)('' '' 5.123)(,¨oup '05.123' '05.123')
out←ast mt_env(sym_base,5.123)
∆0006_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'¯05'
ast←(0 1 2)(F A N)(0 1 1)('' '' ¯5)(,¨oup '¯05' '¯05')
out←ast mt_env(sym_base,¯5)
∆0007_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'¯05.123'
ast←(0 1 2)(F A N)(0 1 1)('' '' ¯5.123)(,¨oup '¯05.123' '¯05.123')
out←ast mt_env(sym_base,¯5.123)
∆0008_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'¯05.'
ast←(0 1 2)(F A N)(0 1 1)('' '' ¯5)(,¨oup '¯05.' '¯05.')
out←ast mt_env(sym_base,¯5)
∆0009_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'(¯05.)'
ast←(0 1 2)(F A N)(0 1 1)('' '' ¯5)(,¨oup '(¯05.)' '¯05.')
out←ast mt_env(sym_base,¯5)
∆0010_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'⍬'
ast←(0 1)(F A)(0 1)(,¨'' '⍬')(,¨oup '⍬')
out←ast mt_env(sym_base,⊂,'⍬')
∆0011_TEST←out PARSE∆SUCC inp

oup←¯1↓LFZ⊢inp←NS⊂'⍬(5 4) 5'
d←    0  1         2      2      3   3    2  3
t←    F  A         A      A      N   N    A  N
k←    0  6         1      1      1   1    1  1
n←   '' ''         (,'⍬')''      5   4   ''  5
s←,¨oup '⍬(5 4) 5' '⍬'   '(5 4)' '5' '4' '5' '5'
out←(d t k n s)mt_env(sym_base,(,'⍬')5 4)
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

oup←¯1↓LFZ⊢inp←NS⊂'⍬(5 4) 5[1 2 3]' ⋄ d t k n s←⊂⍬
d t k n s,←⊂¨0 F 0 ''   oup
d t k n s,←⊂¨1 E 2 ''   '⍬(5 4) 5[1 2 3]'
d t k n s,←⊂¨2 A 6 ''   '⍬(5 4) 5'
d t k n s,←⊂¨3 A 1(,'⍬')(,'⍬')
d t k n s,←⊂¨3 A 1 ''   '(5 4)'
d t k n s,←⊂¨4 N 1 5    (,'5')
d t k n s,←⊂¨4 N 1 4    (,'4')
d t k n s,←⊂¨3 A 1 ''   (,'5')
d t k n s,←⊂¨4 N 1 5    (,'5')
d t k n s,←⊂¨2 P 2(,'[')(,'[')
d t k n s,←⊂¨2 E 6 ''   '[1 2 3]'
d t k n s,←⊂¨3 A 1 ''   '1 2 3'
d t k n s,←⊂¨4 N 1 1    (,'1')
d t k n s,←⊂¨4 N 1 2    (,'2')
d t k n s,←⊂¨4 N 1 3    (,'3')
out←(d t k n s)mt_env(sym_base,(,'⍬')5 4(,'[')1 2 3)
∆0016_TEST←out PARSE∆SUCC inp

inp←NS⊂'⍬(5 4) 5[1 2 3'
msg←'UNBALANCED BRACKETS',CR
msg,←'[2] ⍬(5 4) 5[1 2 3',CR
msg,←'            ▔▔▔▔▔▔ '
out←2('SYNTAX ERROR' '[2] ⍬(5 4) 5[1 2 3' '            ^     ')msg
∆0017_TEST←out PARSE∆FAIL inp

inp←NS⊂'⍬(5 4) 5 1 2 3]'
msg←'UNBALANCED BRACKETS',CR
msg,←'[2] ⍬(5 4) 5 1 2 3]',CR
msg,←'                  ▔ '
out←2('SYNTAX ERROR' '[2] ⍬(5 4) 5 1 2 3]' '                  ^')msg
∆0018_TEST←out PARSE∆FAIL inp

inp←NS⊂'name'
msg←'ALL VARIABLES MUST REFERENCE A BINDING',CR
msg,←'[2] name',CR
msg,←'    ▔▔▔▔ '
out←6('VALUE ERROR' '[2] name' '    ^   ')msg
∆0019_TEST←out PARSE∆FAIL inp

inp←NS'blah←5' '⎕blah'
msg←'INVALID SYSTEM VARIABLE, FUNCTION, OR OPERATOR',CR
msg,←'[3] ⎕blah',CR
msg,←'    ▔▔▔▔▔ '
out←2('SYNTAX ERROR' '[3] ⎕blah' '    ^    ')msg
∆0020_TEST←out PARSE∆FAIL inp

oup←¯1↓LFZ⊢inp←NS'FFT←5' '⎕FFT'
d←  0  1  2  3  1
t←  F  B  A  N  P 
k←  0  1  1  1  2
n←  '' 'FFT' '' 5 '⎕FFT'
s←,¨oup 'FFT←5' '5' '5' '⎕FFT'
out←(d t k n s)((,⊂'FFT')(,1))(sym_base,'FFT' 5 '⎕FFT')
∆0021_TEST←out PARSE∆SUCC inp

⍝ inp←NS'F←{' '4+5+' '}'
⍝ msg←'',CR
⍝ out←2('SYNTAX ERROR' '[3] 4+5+ ' '      ^  ')msg
⍝ ∆0022_TEST←out PARSE∆FAIL inp

oup←¯1↓LFZ⊢inp←NS'F←{' '4+⍵' '}' ⋄ d t k n s←⊂⍬
d t k n s,←⊂¨0 F 0 ''   oup
d t k n s,←⊂¨1 B 2(,'F')('F←{',LF,'4+⍵',LF,'}')
d t k n s,←⊂¨2 F 2 ''   ('{',LF,'4+⍵',LF,'}')
d t k n s,←⊂¨3 E 2 ''   '4+⍵'
d t k n s,←⊂¨4 A 1 ''   (,'4')
d t k n s,←⊂¨5 N 1 4    (,'4')
d t k n s,←⊂¨4 P 2(,'+')(,'+')
d t k n s,←⊂¨4 V 1(,'⍵')(,'⍵')
out←(d t k n s)((,⊂,'F')(,2))(sym_base,(,'F')4(,'+'))
∆0023_TEST←out PARSE∆SUCC inp

inp←'{⍵}'
out←((0 1)(F V)(2 1)(''(,'⍵'))('{⍵}'(,'⍵')))mt_env sym_base
∆0024_TEST←out PARSE∆SUCC inp

inp←'{+ ⍵}'
ast←(0 1 2 2)(F E P V)(2 1 2 1)('' ''(,'+')(,'⍵'))('{+ ⍵}' '+ ⍵'(,'+')(,'⍵'))
∆0025_TEST←ast mt_env(sym_base,⊂,'+') PARSE∆SUCC inp

inp←'{⍺⍺ ⍵}'
ast←(0 1 2 2)(F E P V)(3 1 2 1)('' '' '⍺⍺'(,'⍵'))('{⍺⍺ ⍵}' '⍺⍺ ⍵' '⍺⍺'(,'⍵'))
∆0026_TEST←ast mt_env sym_base PARSE∆SUCC inp

inp←'{⍵⍵ ⍵}'
ast←(0 1 2 2)(F E P V)(4 1 2 1)('' '' '⍵⍵'(,'⍵'))('{⍵⍵ ⍵}' '⍵⍵ ⍵' '⍵⍵'(,'⍵'))
∆0027_TEST←ast mt_env sym_base PARSE∆SUCC inp

inp←'Op←{⍺⍺ ⍵}' '+ Op 5' ⋄ d t k n s←⊂⍬
d t k n s,←⊂¨0 B 3 'Op' 'Op←{⍺⍺ ⍵}'
d t k n s,←⊂¨1 F 3 ''   '{⍺⍺ ⍵}'
d t k n s,←⊂¨2 E 1 ''   '⍺⍺ ⍵'
d t k n s,←⊂¨3 P 2 '⍺⍺' '⍺⍺'
d t k n s,←⊂¨3 V 1(,'⍵')(,'⍵')
d t k n s,←⊂¨0 E 1 ''   '+ Op 5'
d t k n s,←⊂¨1 O 2 ''   '+ Op'
d t k n s,←⊂¨2 P 2(,'+')(,'+')
d t k n s,←⊂¨2 V 3 'Op' 'Op'
d t k n s,←⊂¨1 A 1 ''   (,'5')
d t k n s,←⊂¨2 N 1 5    (,'5')
∆0028_TEST←(d t k n s)mt_env(sym_base,'Op'(,'+')5) PARSE∆SUCC inp


:EndNamespace
