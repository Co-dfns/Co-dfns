:Namespace codfns
⎕IO ⎕ML ⎕WX VERSION AF∆PREFIX AF∆LIB←0 1 3 (3 0 0) '/opt/arrayfire' 'cuda'
VS∆PS←⊂'\Program Files (x86)\Microsoft Visual Studio\'
VS∆PS,¨←,'2019\' '2017\'∘.,'Enterprise' 'Professional' 'Community'
VS∆PS,¨←⊂'\VC\Auxiliary\Build\vcvarsall.bat'
VS∆PS,←⊂'\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat'
Cmp←{_←1 ⎕NDELETE f←⍺,soext⍬
 _←(⍺,'.cpp')put⍨gc{⍵⊣⍞←'G'}tt{⍵⊣⍞←'C'}a n s src←ps ⍵⊣⍞←'P'
 _←(⍎opsys'vsc' 'gcc' 'clang')⍺ ⋄ ⎕←⍪⊃⎕NGET(⍺,'.log')1 ⋄ ⎕NEXISTS f:n
 'COMPILE ERROR' ⎕SIGNAL 22}
MkNS←{ns←#.⎕NS⍬ ⋄ _←'∆⍙'ns.⎕NS¨⊂⍬ ⋄ ∆ ⍙←ns.(∆ ⍙) ⋄ ∆.names←(0⍴⊂''),(1=1⊃⍵)⌿0⊃⍵
 fns←'Rtm∆Init' 'MKA' 'EXA' 'Display' 'LoadImage' 'SaveImage' 'Image' 'Plot'
 fns,←'Histogram' 'soext' 'opsys' 'mkna'
 _←∆.⎕FX∘⎕CR¨fns ⋄ ∆.(decls←⍺∘mkna¨names) ⋄ _←ns.⎕FX¨(⊂''),⍺∘mkf¨∆.names
 _←∆.⎕FX'Z←Init'('Z←Rtm∆Init ''',⍺,'''')'→0⌿⍨0=≢names' 'names ##.⍙.⎕NA¨decls'
 ns}
Fix←{⍺ MkNS ⍺ Cmp ⍵}
P2D←{z←⍪⍳≢⍵ ⋄ d←⍵≠,z ⋄ _←{p⊣d+←⍵≠p←⍺[z,←⍵]}⍣≡⍨⍵ ⋄ d(⍋(-1+d)↑⍤0 1⊢⌽z)}
Xml←{⍺←0 ⋄ ast←⍺{d i←P2D⊃⍵ ⋄ i∘{⍵[⍺]}¨(⊂d),1↓⍺↓⍵}⍣(0≠⍺)⊢⍵ ⋄ d t k n←4↑ast
 cls←N∆[t],¨('-..'[1+×k]),¨⍕¨|k ⋄ fld←{((≢⍵)↑3↓f∆),⍪⍵}¨↓⍉↑3↓ast
 ⎕XML⍉↑d cls(⊂'')fld}
opsys←{⍵⊃⍨'Win' 'Lin' 'Mac'⍳⊂3↑⊃'.'⎕WG'APLVersion'}
soext←{opsys'.dll' '.so' '.dylib'}
mkna←{(⍺,soext⍬),'|',('∆'⎕R'__'⊢⍵),'_cdf P P P'}
mkf←{fn←(⍺,soext⍬),'|',('∆'⎕R'__'⊢⍵),'_dwa ' ⋄ mon dya←⍵∘,¨'_mon' '_dya'
 z←('Z←{A}',⍵,' W')(':If 0=⎕NC''⍙.',mon,'''')
 z,←(mon dya{'''',⍺,'''⍙.⎕NA''',fn,⍵,' <PP'''}¨'>PP P' '>PP <PP'),⊂':EndIf'
 z,':If 0=⎕NC''A'''('Z←⍙.',mon,' 0 0 W')':Else'('Z←⍙.',dya,' 0 A W')':EndIf'}
tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
put←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}
ccf←{' -o ''',⍵,'.',⍺,''' ''',⍵,'.cpp'' -laf',AF∆LIB,' > ',⍵,'.log 2>&1'}
cci←{'-I''',AF∆PREFIX,'/include'' -L''',AF∆PREFIX,'/lib64'' '}
cco←'-std=c++17 -Ofast -g -Wall -fPIC -shared -Wno-parentheses '
cco,←'-Wno-misleading-indentation '
ucc←{⍵⍵(⎕SH ⍺⍺,' ',cco,cci,ccf)⍵}
gcc←'g++'ucc'so'
clang←'clang++'ucc'dylib'
vsco←{z←'/W3 /wd4102 /wd4275 /Gm- /O2 /Zc:inline /Zi /FS /Fd"',⍵,'.pdb" '
 z,←'/errorReport:prompt /WX- /MD /EHsc /nologo /std:c++latest '
 z,'/I"%AF_PATH%\include" /D "NOMINMAX" /D "AF_DEBUG" '}
vslo←{z←'/link /DLL /OPT:REF /INCREMENTAL:NO /SUBSYSTEM:WINDOWS '
 z,←'/LIBPATH:"%AF_PATH%\lib" /DYNAMICBASE "af', AF∆LIB, '.lib" '
 z,'/OPT:ICF /ERRORREPORT:PROMPT /TLBID:1 '}
vsc0←{~∨⌿b←⎕NEXISTS¨VS∆PS:'VISUAL C++?'⎕SIGNAL 99 ⋄ '""','" amd64',⍨⊃b⌿VS∆PS}
vsc1←{' && cd "',(⊃⎕CMD'echo %CD%'),'" && cl ',(vsco ⍵),'/fast "',⍵,'.cpp" '}
vsc2←{(vslo ⍵),'/OUT:"',⍵,'.dll" > "',⍵,'.log""'}
vsc←{⎕CMD('%comspec% /C ',vsc0,vsc1,vsc2)⍵}
MKA←{mka⊂⍵} ⋄ EXA←{exa ⍬ ⍵}
Display←{⍺←'Co-dfns' ⋄ W←w_new⊂⍺ ⋄ 777::w_del W
 w_del W⊣W ⍺⍺{w_close ⍺:⍎'⎕SIGNAL 777' ⋄ ⍺ ⍺⍺ ⍵}⍣⍵⍵⊢⍵}
LoadImage←{⍺←1 ⋄ ~⎕NEXISTS ⍵:⎕SIGNAL 22 ⋄ loadimg ⍬ ⍵ ⍺}
SaveImage←{⍺←'image.png' ⋄ saveimg ⍵ ⍺}
Image←{~2 3∨.=≢⍴⍵:⎕SIGNAL 4 ⋄ (3≠⊃⍴⍵)∧3=≢⍴⍵:⎕SIGNAL 5 ⋄ ⍵⊣w_img ⍵ ⍺}
Plot←{2≠≢⍴⍵:⎕SIGNAL 4 ⋄ ~2 3∨.=1⊃⍴⍵:⎕SIGNAL 5 ⋄ ⍵⊣w_plot (⍉⍵) ⍺}
Histogram←{⍵⊣w_hist ⍵,⍺}
∇r←List
 r←⎕NS¨1⍴⊂⍬ ⋄ r.Name←,¨⊂'Compile' ⋄ r.Group←⊂'CODFNS' 
 r[0].Desc←'Compile an object using Co-dfns'
 r.Parse←⊂'2S -af=cpu opencl cuda ' 
∇
Convert←{⍺(⎕SE.SALT.Load '[SALT]/lib/NStoScript -noname').ntgennscode ⍵}
Run←{C I←⍵ ⋄ in out←I.Arguments ⋄ AF∆LIB∘←I.af ''⊃⍨I.af≡0
 S←(⊂':Namespace ',out),2↓0 0 0 out Convert ##.THIS.⍎in
 'Compile'≡C:{}{_←{##.THIS.⍎out,'←⍵'}out Fix S⊣⎕EX'##.THIS.',out
  ⎕CMD'copy "%CUDA_PATH%\nvvm\bin\nvvm64*" /Y'/⍨(I.af≡'cuda')∧opsys 1 0 0}⍬}
Help←{'Usage: <object> <target> [-af={cpu,opencl,cuda}]'}
∇Z←Rtm∆Init S
 'w_new'⎕NA'P ',(S,soext⍬),'|w_new <C[]'
 'w_close'⎕NA'I ',(S,soext ⍬),'|w_close P'
 'w_del'⎕NA(S,soext⍬),'|w_del P'
 'w_img'⎕NA(S,soext⍬),'|w_img <PP P'
 'w_plot'⎕NA(S,soext⍬),'|w_plot <PP P'
 'w_hist'⎕NA(S,soext⍬),'|w_hist <PP F8 F8 P'
 'loadimg'⎕NA(S,soext⍬),'|loadimg >PP <C[] I'
 'saveimg'⎕NA(S,soext⍬),'|saveimg <PP <C[]'
 'exa'⎕NA(S,soext⍬),'|exarray >PP P'
 'mka'⎕NA'P ',(S,soext⍬),'|mkarray <PP'
 'FREA'⎕NA(S,soext⍬),'|frea P'
 'Sync'⎕NA(S,soext⍬),'|cd_sync'
 Z ← 0 0 ⍴ ⍬
∇
dct←{⍺[(2×2≠/n,0)+(1↑⍨≢m)+m+n←⌽∨\⌽m←' '≠⍺⍺ ⍵]⍵⍵ ⍵}
dlk←{((x⌷⍴⍵)↑[x←2|1+⍵⍵]⍺),[⍵⍵]⍺⍺@(⊂0 0)⍣('┌'=⊃⍵)⊢⍵}
dwh←{⍵('┬'dlk 1)' │├┌└─'(0⌷⍉)dct,⊃⍪/((≢¨⍺),¨⊂⌈/≢∘⍉¨⍺)↑¨⍺}
dwv←{⍵('├'dlk 0)' ─┬┌┐│'(0⌷⊢)dct(⊣⍪1↓⊢)⊃{⍺,' ',⍵}/(1+⌈/≢¨⍺){⍺↑⍵⍪⍨'│'↑⍨≢⍉⍵}¨⍺}
pp3←{⍺←'○' ⋄ d←(⍳≢⍵)≠⍵ ⋄ _←{z⊣d+←⍵≠z←⍺[⍵]}⍣≡⍨⍵ ⋄ lbl←⍺⍴⍨≢⍵
 lyr←{i←⍸⍺=d ⋄ k v←↓⍉⍵⍵[i],∘⊂⌸i ⋄ (⍵∘{⍺[⍵]}¨v)⍺⍺¨@k⊢⍵}⍵                  
 (⍵=⍳≢⍵)⌿⊃⍺⍺ lyr⌿(1+⍳⌈/d),⊂⍉∘⍪∘⍕¨lbl}                                     
lb3←{⍺←⍳≢⊃⍵
 '(',¨')',¨⍨{⍺,';',⍵}⌿⍕¨(N∆{⍺[⍵]}@2⊢(2⊃⍵){⍺[|⍵]}@{0>⍵}@4↑⊃⍵)[⍺;]}
_o←{0≥⊃c1 a e(i1 d1)←A←⍺ ⍺⍺ ⍵:A ⋄ 0≥⊃c2 a e(i2 d2)←B←⍺ ⍵⍵ ⍵:B
 (i1=i2∧c1<c2)∨i1 _less i2:B ⋄ A}
_s←{0<⊃c a e d←p←⍺ ⍺⍺ ⍵:p ⋄ 0<⊃c2 a2 e d←p←e ⍵⍵ d:p ⋄ (c⌈c2)(a⍪a2)e d}
_noenv←{0<⊃c a e d←p←⍺ ⍺⍺ ⍵:p ⋄ c a ⍺ d}
_env←{0<⊃c a e d←p←⍺ ⍺⍺ ⍵:p ⋄ c a ((⊆a)⍵⍵⍪¨e) d}
_then←{0<⊃c a e d←p←⍺ ⍺⍺ ⍵:p ⋄ 0<⊃c a e _←p←e ⍵⍵ a d:p ⋄ c a e d}
_not←{0<⊃c a e d←⍺ ⍺⍺ ⍵:0 a ⍺ ⍵ ⋄ 2 a ⍺ ⍵}
_as←{0<⊃c a e d←⍺ ⍺⍺ ⍵:c a e d ⋄ c (,⊂((⌊/,⌈/)⊃¨⍵ d)⍵⍵ a) e d}
_t←{0<⊃c a e(i d)←p←⍺ ⍺⍺ ⍵:p ⋄ e ⍵⍵ a:p ⋄ i>⊃⍵:6 ⍬ ⍺ ⍵ ⋄ 6 ⍬ ⍺(i d)}
_ign←{c a e d←⍺ ⍺⍺ ⍵ ⋄ c ⍬ e d}
_peek←{0<p←⊃⍺ ⍺⍺ ⍵:p ⋄ 0 ⍬ ⍺ ⍵}
_yes←{0 ⍬ ⍺ ⍵}
_opt←{⍺(⍺⍺ _o _yes)⍵}
_any←{⍺(⍺⍺ _s ∇ _o _yes)⍵}
_some←{⍺(⍺⍺ _s (⍺⍺ _any))⍵}
_set←{i d←⍵ ⋄ 3::2 ⍬ ⍺ ⍵ ⋄ (i⌷d)∊⍺⍺:0(,i⌷d)⍺((i _step 1)d) ⋄ 2 ⍬ ⍺ ⍵}
_tk←{i d←⍵ ⋄ m←(,⍺⍺)=⍥⎕C c↑d⌷⍨⊂x⌿⍨(0≤x)∧(≢d)>x←i _step ⍳c←≢,⍺⍺
 x←(i _step +⌿∧⍀m)d ⋄ ∧⌿m:0(⊂,⍺⍺)⍺ x ⋄ 2 ⍬ ⍺ x}
_eat←{i d←⍵ ⋄ i≥≢d:2 ⍬ ⍺ ⍵ ⋄ 0(i⌷d)⍺((i _step 1)d)}
_eot←{i d←⍵ ⋄ (i<0)∨i≥≢d:0 ⍬ ⍺ ((≢d)d) ⋄ 2 ⍬ ⍺ ⍵}
_gof←{_step∘←+ ⋄ _less∘←< ⋄ _←0} ⋄ _gob←{_step∘←- ⋄ _less∘←> ⋄ _←0}
_step←⊢ ⋄ _less←⊢ ⋄ _gof⍬
_bkwd←{c a e d1←⍺ ⍵⍵ ⍵ ⋄ _gob⍬: ⋄ c a e d2←⍺ ⍺⍺ -∘1@0⊢d1 ⋄ _gof⍬:
 0<c:c a e((⌈⌿⊃¨⍵ d2),1↓⍵) ⋄ c a e d1}
PEG←{⍺←⎕THIS
 A←,¨'`([^`]*)`'    '"([^"]*)"'   '\[\]'   '\[([^]]+)\]'  '\|'  ','
 B←  '(''\1''_set)' '(''\1''_tk)' '_noenv' '_env(\1)'     '_o'  '_s'
 A,←,¨'→'     '!'    '&'  '∊'    '\?'   '\*'   '\+'    '⍥'    '↓'    '↑'     '⌽'
 B,←  '_then' '_not' '_t' '_yes' '_opt' '_any' '_some' '_eat' '_ign' '_peek' '_bkwd'
 A,←⊂,'⍬'
 B,←⊂,'_eot'
 noq←' '@(∊{⍺+⍳⍵}⌿¨'`[^`]*`' '"[^"]*"'⎕S 0 1⊢x)⊢x←' ',⍵
 nm peg as←1↓¨3↑x⊂⍨1@(0,⊃∘⍸¨('←'=noq)(':'=noq))⊢0⍴⍨≢x
 peg←A ⎕R(' ',¨B,¨' ')⊢peg ⋄ as←{' _as (',⍵,')'}⍣(∨⌿as≠' ')⊢as
 ⍺.⎕FX(nm,'←{')('Z←⍺(',peg,as,')⍵')(''⊣'⎕←''',nm,': '',⍕(0)(3 0)⊃¨⊂Z')('Z}')}
EN←0 ⋄ DM←'' '' ''
_report←{c a e(i d)←⍵ ⋄ 0=c:⍵⊣⎕←'Parsing successful.'⊣EN∘←0⊣DM∘←'' '' ''
 0>c:('Unhandled return code: ',(⍕c))⎕SIGNAL 16
 li←⍸lm←¯1⌽lm∨(CR=d)∧~1⌽lm←LF=d←d,LF⊣CR LF←⎕UCS 13 10
 EN∘←c
 DM[0]←⊂⎕EM c
 DM[1]←⊂(lnm←'[',(⍕1+ln),'] '),' '@{⍵∊CR LF}⊢l←(ln←0⌈li⍸i)⊃lm⊂d
 DM[2]←⊂(' '⍴⍨≢lnm),'^'@(0⌈i-ln⌷li)⊢' '⍴⍨≢l
 msg←∊CR,'─'⍪⍨'─'⍪↑DM[1 2]
 ⎕SIGNAL⊂('EN' c)('Category' 'Compiler')('Vendor' 'Co-dfns')('Message' msg)}
ws←(' ',⎕UCS 9)_set
crlf←(⎕UCS 10 13)_set
PEG'aws   ← ws * ↓'
PEG'awslf ← crlf | ws * ↓'
PEG'eot   ← aws , ⍬ ↓'
PEG'alpha ← `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz∆_`'
PEG'digit ← `0123456789`'
PEG'jot   ← aws , `∘` , aws'
PEG'dot   ← aws , `.` , aws'
PEG'lbrc  ← aws , `{` , aws ↓'
PEG'rbrc  ← aws , `}` , aws ↓'
PEG'zil   ← aws , "⍬" , aws ↓'
PEG'gets  ← aws , "←" , aws ↓'
PEG'lpar  ← aws , "(" , aws ↓'
PEG'rpar  ← aws , ")" , aws ↓'
PEG'lbrk  ← aws , "[" , aws ↓'
PEG'rbrk  ← aws , "]" , aws ↓'
PEG'semi  ← aws , ";" , aws ↓'
PEG'grd   ← aws , ":" , aws ↓'
PEG'egrd  ← aws , "::" , aws ↓'
PEG'mop   ← aws , `¨/⌿\⍀⍨` , aws'
PEG'dop1  ← aws , `.⍣∘` , aws'
PEG'dop2  ← aws , `⍤⍣∘` , aws'
PEG'dop3  ← aws , `∘` , aws'
PEG'prim  ← aws,`+-÷×|*⍟⌈⌊!<≤=≠≥>∧∨⍲⍱⌷?⍴,⍪⌽⊖⍉∊⍷⊂⊆⊃⍳○~≡≢⊢⊣/⌿\⍀⊤⊥↑↓∪∩⍋⍒∇⌹`,aws'
PEG'ndlm  ← `¯` | (alpha! ↑)'
PEG'int   ← aws , (digit+) , ndlm , aws'
PEG'float ← aws , (digit* , `.` , int | (digit+ , `.` , ndlm)) , aws'
PEG'aw    ← aws , ("⍵" | "⍺") , aws'
PEG'aaww  ← aws , ("⍺⍺" | "⍵⍵") , aws'
PEG'sep   ← aws , (`⋄` | crlf ↓) , aws'
PEG'nss   ← awslf , ":Namespace" , aws , (alpha,(alpha|digit*)?) , awslf ↓'
PEG'nse   ← awslf , ":EndNamespace" , awslf ↓'
PEG'sfn   ← aws , ("TFFI⎕" | "TFF⎕") , aws'
PEG'name  ← aws , (alpha | (digit+ , alpha) +) , (`⎕` !) , aws'
f∆ N∆←'ptknfsrdx' 'ABEFGLMNOPVZ'
⎕FX∘⍉∘⍪¨'GLM',¨'←{⍪/(0 '∘,¨(⍕¨N∆⍳'GLM'),¨⊂' 0 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}'
⎕FX∘⍉∘⍪¨'AEFO',¨'←{⍪/(0 '∘,¨(⍕¨N∆⍳'AEFO'),¨⊂' ⍺⍺ 0,1+⍺),1+@0⍉↑(⊂6⍴⊂⍬),⍵}'
⎕FX∘⍉∘⍪¨'BNPVZ',¨'←{0(N∆⍳'''∘,¨'BNPVZ',¨''')'∘,¨'⍺⍺(0⌷⍵)' '0(⍎⍵)' '⍺⍺(⊂⍵)' '⍺⍺(⊂⍵)' '1(⊂⍵)',¨⊂',1+⍺}'
Vt←(⊢⍳⍨0⊃⊣)⊃¯1,⍨1⊃⊣
MkAST←{⍪/(⍳≢⍵)+@0⍉↑⌽⍵}
MkAtom←{∧⌿m←(N∆⍳'N')=⊃¨1⊃¨⍵:⍺(0A)⌽⍵ ⋄ 1=≢⍵:0⊃⍵ ⋄ ⍺(3A)⌽({⊃¨⍵[4 5]}0A⊂)¨@{m}⍵}
MkMget←{⍪/(0,1+2<≢⊃z)+@0⊢z←⍉↑⌽⍵}
Atn←{(0 3⊃⍵)@(⊂3 0)⊢⍺ ⍺⍺ ⍵}
Fn←{a(i d)←⍵ ⋄ 0=≢a:0 ⍬ ⍺(i d)
 0=≢ss←(4⊃z)⌿⍨m←((3=1⊃⊢)∧¯1=2⊃⊢)⊢z←⍪⌿↑a:0(,⊂z)⍺(i d)
 0<c←r⊃⍨0,pi←⊃⍒⊃r←↓⍉↑ps←⍺∘Fa¨ss,¨⊂⊂d:pi⊃ps
 0(,⊂(⊂¨¨z)((⊃⍪⌿)⊣@{m})¨⍨↓(m⌿0⊃z)+@0⍉↑⊃¨1⊃r)⍺(i d)}
FnType←3 3 2 2⊥1+(⊂⊃⍳(,¨'⍵⍵' '⍺⍺','⍺⍵')⍨)⌷1∘⊃,¯1⍨
PEG'Sfn    ← sfn                                              : 1P∘⌽∘∊       '
PEG'Prim   ← prim                                             : 1P           '
PEG'Symbol ← name                                             : ⊢∘⌽          '
PEG'Name   ← Symbol & (⍺⍺=Vt)                                 : ⍺⍺ V∘,∘⊃     '
PEG'Args   ← aaww | aw & (⍺⍺=Vt)                              : ⍺⍺ V∘,∘⊃     '
PEG'Var    ← ⍺⍺ Args | (⍺⍺ Name)                                             '
PEG'Num    ← float | int                                      : N∘⌽          '
PEG'Pex    ← rpar , Ex , lpar                                                '
PEG'Zil    ← zil                                              : 0A           '
PEG'Unit   ← (0 Var) | Num | Zil | Pex                                       '
PEG'Atom   ← Unit+                                            : MkAtom       '
PEG'Semi   ← ∊                                                : ⊣0 P{,'';''} '
PEG'Semx   ← Ex | Semi                                                       '
PEG'Brk    ← rbrk , (Semx , (semi , Semx *)) , lbrk           : 3E∘⌽         '
PEG'Lbrk   ← ∊                                                : ⊣⍺⍺ P{,''[''}'
PEG'Idx    ← Brk , (1 Lbrk) , Atom                            : 2E∘⌽         '
PEG'Slrp   ← ⍺⍺ | (⍵⍵ , ∇) | (⍥ , ∇) ↓                                       '
PEG'Blrp   ← ⍺⍺ , (⍵⍵ Slrp ∇) ↓                                              '
PEG'Bfn    ← rbrc Blrp lbrc                                   : ¯1F          '
PEG'Pfe    ← rpar , Fex , lpar                                               '
PEG'Fnp    ← Prim | Sfn | (1 Var) | Bfn | Pfe                                '
PEG'Pmop   ← mop                                              : 2P           '
PEG'Mop    ← Pmop , Afx                                       : 2O           '
PEG'Pdop1  ← dop1                                             : 2P           '
PEG'Dop1   ← Pdop1 , Afx                                      : 8O∘⌽         '
PEG'Pdop2  ← dop2                                             : 2P           '
PEG'Vop    ← Atom , Pdop2 , Afx                               : 7O∘⌽         '
PEG'Pdop3  ← dop3                                             : 2P           '
PEG'JotDot ← dot , jot                                        : ⊣2O∘,∘⊂2P∘⌽  '
PEG'Dop3a  ← Pdop3 , Atom                                     : 5O∘⌽         '
PEG'Dop3   ← Dop3a | JotDot                                                  '
PEG'Bop    ← rbrk , Ex , lbrk , (2 Lbrk) , Afx                : 7O∘⌽         '
PEG'Fop    ← Fnp , (Dop1 | Dop3 ?)                            : MkAST        '
PEG'Afx    ← Mop | Fop | Vop | Bop                                           '
PEG'Trn    ← Afx , (Afx | Idx | Atom , (∇ ?) ?)               : 3F∘⌽         '
PEG'Bind   ← gets , Symbol [⍺⍺]                               : ⍺⍺ B         '
PEG'Mname  ← 0 Name                                           : 4E Atn       '
PEG'Gets   ← ∊                                                : ⊣⍺⍺ P{,''←''}'
PEG'Ogets  ← 2 Gets                                           : 2O∘⌽         '
PEG'Mbrk   ← Ogets , Brk , (0 Name)                           : 4E∘(1∘↓)Atn∘⌽'
PEG'Mget   ← Afx , (Mname | Mbrk)                             : MkMget       '
PEG'Bget   ← 1 Gets , Brk , (0 Name)                          : 4E∘(1∘↓)Atn∘⌽'
PEG'Asgn   ← gets , (Bget | Mget)                                            '
PEG'Fex    ← Afx , (Trn ?) , (1 Bind *)                       : MkAST        '
PEG'IAx    ← Idx | Atom , (dop2 !)                                           '
PEG'App    ← Afx , (IAx ?)                                    : {⍺((≢⍵)E)⌽⍵} '
PEG'ExHd   ← Asgn | (0 Bind) | App , ∇ ?                                     '
PEG'Ex     ← IAx , ExHd                                       : MkAST        '
PEG'Gex    ← Ex , grd , Ex                                    : G∘⌽          '
PEG'Alp    ← ∊                                                : ''⍺''⍨       '
PEG'Omg    ← ∊                                                : ''⍵''⍨       '
PEG'ClrEnv ← (Alp[¯1]),(Alp,Alp[¯1]),(Omg[¯1]),(Omg,Omg[¯1])↓                '
PEG'Fax    ← lbrc , (Gex | Ex | Fex Stmts rbrc) → Fn          : (FnType ⍺)F  '
PEG'FaFnW  ← Omg[0]↓ , Fax []                                                '
PEG'FaFnA  ← Omg[0] , (Alp[0])↓ , Fax []                                     '
PEG'FaFn   ← FaFnW | FaFnA                                                   '
PEG'FaMopV ← Alp,Alp[0]↓ , FaFn []                                           '
PEG'FaMopF ← Alp,Alp[1]↓ , FaFn []                                           '
PEG'FaMop  ← FaMopV , (FaMopF ?) | FaMopF                                    '
PEG'FaDopV ← Omg,Omg[0]↓ , FaMop []                                          '
PEG'FaDopF ← Omg,Omg[1]↓ , FaMop []                                          '
PEG'FaDop  ← FaDopV , (FaDopF ?) | FaDopF                                    '
PEG'Fa     ← ClrEnv , (FaFn | FaMop | FaDop) []                              '
PEG'Nlrp   ← sep | rbrc ↑ Slrp (lbrc Blrp rbrc)                              '
PEG'Stmt   ← sep | (⍺⍺ , (sep | lbrc) ⌽ Nlrp)                                '
PEG'Stmts  ← ⍵⍵ | (⍺⍺ Stmt , ∇)                                              '
PEG'Ns     ← nss , (Ex | Fex Stmts nse) , eot → Fn             : (¯1+⊣)0F⊢   '
ps←{⍺←⍬ ⍬ ⋄ src←∊{⍵/⍨∧\'⍝'≠⍵}¨⍵,¨⎕UCS 10
 0≠⊃c a e(i d)←p←⍺ Ns 0,⊂src:_report p
 (↓s(-⍳)@3↑⊃a)e(s←∪0(,'⍵')(,'⍺')'⍺⍺' '⍵⍵',3⊃⊃a)src}
⍝ A  B  E  F  G  L  M  N  O  P  V  Z
⍝ 0  1  2  3  4  5  6  7  8  9 10 11
tt←{((d t k n ss se)exp sym src)←⍵ ⋄ I←{(⊂⍵)⌷⍺}
 r←I@{t[⍵]≠3}⍣≡⍨p⊣2{p[⍵]←⍺[⍺⍸⍵]}⌿⊢∘⊂⌸d⊣p←⍳≢d                            ⍝ PV
 p,←n[i]←(≢p)+⍳≢i←⍸(t=3)∧p≠⍳≢p ⋄ t k n r(⊣,I)←⊂i ⋄ p r I⍨←⊂n[i]@i⊢⍳≢p   ⍝ LF
 t[i]←10
 i←(⍸(~t∊3 4)∧t[p]=3),{⍵⌿⍨2|⍳≢⍵}⍸t[p]=4 ⋄ p t k n r⌿⍨←⊂m←2@i⊢1⍴⍨≢p      ⍝ WX
 p r i I⍨←⊂j←(+⍀m)-1 ⋄ n←j I@(0≤⊢)n ⋄ p[i]←j←i-1
 k[j]←-(k[r[j]]=0)∨0@({⊃⌽⍵}⌸p[j])⊢(t[j]=1)∨(t[j]=2)∧k[j]=4 ⋄ t[j]←2
 p[i]←p[x←¯1+i←{⍵⌿⍨~2|⍳≢⍵}⍸t[p]=4] ⋄ t[i,x]←t[x,i] ⋄ k[i,x]←k[x,i]      ⍝ LG
 n[x]←n[i] ⋄ p←((x,i)@(i,x)⊢⍳≢p)[p]
 n[p⌿⍨(t[p]∊0 2)∧k[p]=3]+←1                                             ⍝ CI
 p[i]←p[x←p I@{~t[p[⍵]]∊3 4}⍣≡i←⍸t∊4,(⍳3),8+⍳3] ⋄ j←(⌽i)[⍋⌽x]           ⍝ LX
 p t k n r{⍺[⍵]@i⊢⍺}←⊂j ⋄ p←(i@j⊢⍳≢p)[p]
 s←¯1,⍨∊⍳¨n[∪x]←⊢∘≢⌸x←0⌷⍉e←∪I∘⍋⍨rn←r[b],⍪n[b←⍸t=1]                      ⍝ SL
 d←(≢p)↑d ⋄ d[i←⍸t=3]←0 ⋄ _←{z⊣d[i]+←⍵≠z←r[⍵]}⍣≡i ⋄ f←d[0⌷⍉e],¯1        ⍝ FR
 xn←n⌿⍨(t=1)∧k[r]=0                                                     ⍝ XN
 v←⍸(n<¯4)∧(t=10)∨(t=2)∧k=4 ⋄ x←n[y←v,b] ⋄ n[b]←s[e⍳rn] ⋄ i←(≢x)⍴c←≢e   ⍝ AV
 _←{z/⍨c=i[1⌷z]←e⍳⍉x I@1⊢z←r I@0⊢⍵}⍣≡(v,r[b])⍪⍉⍪⍳≢x
 f s←(f s I¨⊂i)⊣@y¨⊂¯1⍴⍨≢r
 p t k n f s r d xn sym}
gck← (0 0)(0 1)(0 3)(1 0)(1 1)
gcv← 'Aa' 'Av' 'As' 'Bv' 'Bf'
gck,←(2 ¯2)(2 ¯1)(2 0)(2 1)(2 2)(2 3)(2 4)
gcv,←'Ec'  'Ek'  'Er' 'Em' 'Ed' 'Ei' 'Eb'
gck,←(3 ¯1)(3 0)(3 1)(3 3)
gcv,←'Fa'  'Fz' 'Fn' 'Fn'
gck,←(4 0)(7 0)(8 1)(8 2)(8 4) (8 5) (8 7) (8 8)
gcv,←'Gd' 'Na' 'Ov' 'Of' 'Ovv' 'Ovf' 'Ofv' 'Off'
gck,←(9 0)(9 1)(9 2)(10 0)(10 1)(10 3)
gcv,←'Pv' 'Pf' 'Po' 'Va'  'Vf'  'Vf'
gck+←⊂1 0
gcv,←⊂'{''/* Unhandled '',(⍕⍺),'' */'',NL}'
NL←⎕UCS 13 10

gc←{p t k n fr sl rf fd xn sym←⍵ ⋄ xi←⍸(t=1)∧k[rf]=0 ⋄ d i←P2D p
 I←{(⊂⍵)⌷⍺} ⋄ com←{⊃{⍺,',',⍵}/⍵} ⋄  ks←{⍵⊂[0]⍨(⊃⍵)=⍵[;0]}
 nam←{'∆'⎕R'__'∘⍕¨sym[|⍵]} ⋄ slt←{'(*e[',(⍕6⊃⍵),'])[',(⍕7⊃⍵),']'}
 ast←(⍉↑d p (1+t)k n(⍳≢p)fr sl fd)[i;]
 Aa←{0=≢ns←dis¨⍵:'PUSH(A(SHP(1,0),scl(0)));',NL
  1=≢ns:'PUSH(scl(scl(',(⊃ns),')));',NL
  c←⍕≢⍵ ⋄ v←'VEC<',('DI'⊃⍨∧.=∘⌊⍨⍎¨ns),'>{',(com ns),'}.data()'
  'PUSH(A(SHP(1,',c,'),arr(',c,',',v,')));',NL}
 As←{c←⍕4⊃⍺ ⋄ z←'{A z(SHP(1,',c,'),VEC<A>(',c,'));',NL
  z,←'  VEC<A>&zv=std::get<VEC<A>>(z.v);',NL
  z,'  DOB(',c,',POP(A,zv[i]))coal(z);PUSH(z);}',NL}
 Bf←{'(*e[fd])[',(⍕4⊃⍺),']=s.top();',NL}
 Bv←{'(*e[fd])[',(⍕4⊃⍺),']=s.top();',NL}
 Eb←{z←'{A x,y;FNP f;POP(A,x);POP(FNP,f);POP(A,y);'
  z,'(*f)(std::get<A>(',(slt⍺),'),x,y,e);PUSH(y);}',NL}
 Ed←{z←'{A z,x,y;FNP f;POP(A,x);POP(FNP,f);POP(A,y);'
  z,'(*f)(z,x,y,e);PUSH(z);}',NL}
 Ei←{c←⍕4⊃⍺ ⋄ z←'{A x(SHP(1,',c,'),VEC<A>(',c,'));'
  z,'VEC<A>&v=std::get<VEC<A>>(x.v);DOB(',c,',POP(A,v[i]));PUSH(x);}',NL}
 Ek←{'s.pop();',NL}
 Em←{'{A z,x;FNP f;POP(FNP,f);POP(A,x);(*f)(z,x,e);PUSH(z);}',NL}
 Er←{'POP(A,z);e[fd]=std::move(of);R;',NL}
 Fn←{z←NL,'DF(',('fn',⍕5⊃⍺),'_f){U fd=',(⍕8⊃⍺),';STK s;',NL
  z,←' if(e.size()<=fd)e.resize(fd+1);',NL
  z,←' FRMP of=std::move(e[fd]);e[fd]=std::make_unique<FRM>(',(⍕4⊃⍺),');',NL
  z,←' try{',NL
  B←{'(*e[fd])[',(⍕n[⍵]),']=(*e[',(⍕fr[⍵]),'])[',(⍕sl[⍵]),'];',NL}
  z,←⊃,⌿(B¨⍸(p=5⊃⍺)∧(t=1)∧fr≠¯1),' ',¨dis¨⍵
  z,←' }catch(U x){e[fd]=std::move(of);throw x;}',NL
  z,←' catch(exception&x){e[fd]=std::move(of);throw x;}',NL
  z,' e[fd]=std::move(of);}',NL}
 Fz←{z←NL,'ENV e',(⍕5⊃⍺),'(1);I is',(⍕5⊃⍺),'=0;',NL
  z,←'DF(',('fn',⍕5⊃⍺),'_f){if(is0)R;','' 'I fd=0;'⊃⍨×≢⍵
  z,←'STK s;e[0]=std::make_unique<FRM>(',(⍕4⊃⍺),');',NL
  z,(⊃,⌿' ',¨dis¨⍵),' is0=1;}',NL,NL}
 Gd←{z←'{A x;POP(A,x);if(cnt(x)!=1)err(5);',NL
  z,←' if(!(isint(x)||isbool(x)))err(11);',NL
  z,←' I t;CVSWITCH(x.v,err(6),t=v.as(s32).scalar<I>(),err(11))',NL
  z,←' if(t!=0&&t!=1)err(11);',NL
  z,' if(t){',NL,(⊃,/' ',¨dis¨⍵),' }}',NL}
 Na←{'¯'⎕R'-'⍕sym⌷⍨|4⊃⍺}
 Ov←{z←'{A x;MOKP o;POP(MOKP,o);POP(A,x);'
  z,'FNP f=(*o)(x);f->this_p=f;PUSH(f);}',NL}
 Of←{z←'{FNP f,g;MOKP o;POP(MOKP,o);POP(FNP,g);'
  z,'f=(*o)(g);f->this_p=f;PUSH(f);}',NL}
 Ovv←{z←'{A x,y;DOKP o;POP(A,x);POP(DOKP,o);POP(A,y);'
  z,'FNP f=(*o)(x,y);f->this_p=f;PUSH(f);}',NL}
 Ovf←{z←'{A x;FNP f,g;DOKP o;POP(A,x);POP(DOKP,o);POP(FNP,g);'
  z,'f=(*o)(x,g);f->this_p=f;PUSH(f);}',NL}
 Ofv←{z←'{A x;FNP f,g;DOKP o;POP(FNP,g);POP(DOKP,o);POP(A,x);'
  z,'f=(*o)(g,x);f->this_p=f;PUSH(f);}',NL}
 Off←{z←'{FNP f,g,h;DOKP o;POP(FNP,g);POP(DOKP,o);POP(FNP,h);'
  z,'f=(*o)(g,h);f->this_p=f;PUSH(f);}',NL}
 Pf←{'PUSH(',(nams⊃⍨syms⍳sym⌷⍨|4⊃⍺),'_p);',NL}
 Po←{'PUSH(std::make_shared<',(nams⊃⍨syms⍳sym⌷⍨|4⊃⍺),'_k>());',NL}
 Pv←{'PUSH(A());',NL}
 Zp←{n←'fn',⍕⍵ ⋄ z←'S ',n,'_f:FN{MFD;DFD;',n,'_f():FN("',n,'",0,0){};};',NL
  z,'DEFN(',n,')',NL,'MF(',n,'_f){this_c(z,A(),r,e);}',NL}
 Va←{(x←4⊃⍺)∊-1+⍳4:'PUSH(',(,'r' 'l' 'll' 'rr'⊃⍨¯1+|x),');',NL
  'PUSH(',(slt ⍺),');',NL}
 Vf←{0>x←4⊃⍺:'PUSH(',(slt ⍺),');',NL
  'fn',(⍕x),'_p->this_p=fn',(⍕x),'_p;PUSH(fn',(⍕x),'_p);',NL}
 dis←{0=2⊃h←,1↑⍵:'' ⋄ (≢gck)=i←gck⍳⊂h[2 3]:⎕SIGNAL 16 ⋄ h(⍎i⊃gcv)ks 1↓⍵}
 z←(⊂rth),(rtn[syms⍳{∪⊃,/(deps,⊂⍬)[syms⍳⍵]}⍣≡sym]),(,/Zp¨⍸t=3)
 z,←dis¨ks ast
 z,←'E',¨('VF'[k[xi]]),¨'(',¨(⍕¨rf[xi]),¨',',¨(nam xn),¨',',¨(⍕¨n[xi]),¨')',¨⊂NL
 ⊃,⌿z⊣⍞←⎕UCS 10}
syms ←,¨'+'   '-'   '×'   '÷'   '*'   '⍟'   '|'    '○'     '⌊'    '⌈'   '!'
nams ←  'add' 'sub' 'mul' 'div' 'exp' 'log' 'res'  'cir'   'min'  'max' 'fac'
syms,←,¨'<'   '≤'   '='   '≥'   '>'   '≠'   '~'    '∧'     '∨'    '⍲'   '⍱'
nams,←  'lth' 'lte' 'eql' 'gte' 'gth' 'neq' 'not'  'and'   'lor'  'nan' 'nor'
syms,←,¨'⌷'   '['   '⍳'   '⍴'   ','   '⍪'   '⌽'    '⍉'     '⊖'    '∊'   '⊃'
nams,←  'sqd' 'brk' 'iot' 'rho' 'cat' 'ctf' 'rot'  'trn'   'rtf'  'mem' 'dis'
syms,←,¨'≡'   '≢'   '⊢'   '⊣'   '⊤'   '⊥'   '/'    '⌿'     '\'    '⍀'   '?'
nams,←  'eqv' 'nqv' 'rgt' 'lft' 'enc' 'dec' 'red'  'rdf'   'scn'  'scf' 'rol'
syms,←,¨'↑'   '↓'   '¨'   '⍨'   '.'   '⍤'   '⍣'    '∘'     '∪'    '∩'   '←'
nams,←  'tke' 'drp' 'map' 'com' 'dot' 'rnk' 'pow'  'jot'   'unq'  'int' 'get'
syms,←,¨'⍋'   '⍒'   '∘.'  '⍷'   '⊂'   '⌹'   '⎕FFT' '⎕IFFT' '%s'   '⊆'
nams,←  'gdu' 'gdd' 'oup' 'fnd' 'par' 'mdv' 'fft'  'ift'   'scl'  'nst'
syms,←,¨'∇'    ';'    '%u'
nams,←  'this' 'span' ''
deps←⊂¨syms
deps[syms⍳,¨sclsyms]←,¨¨('⍉⍴⍋',⊂'%s')∘,¨sclsyms←'+-×÷*⍟|○⌊⌈!<≤=≠≥>∨⍱⍲~?'
deps[syms⍳,¨'∧⌿/.⍪⍤\↓↑']←,¨¨'∨∧' '/⌿' '¨/' '/.' ',⍪' '↑⌷⍤' '¨\' '⍳↓' '⍳↑'
deps[syms⍳,¨'←⌽⊖⌷⍀¨≢⊂']←,¨¨'[⊃,¨←' '|,⌽' '⌽⊖' '⍳⌷' '\⍀' '⊃,¨' '≡≢' '¨⌷⊂'
deps[syms⍳,¨'⊆']←,¨¨⊂'⊂⊆'
deps[syms⍳⊂'∘.']←⊂(,¨'¨' '∘.')

rth←''
rtn←(⍴nams)⍴⊂''
rth,←'#define _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING',NL
rth,←'',NL
rth,←'#include <time.h>',NL
rth,←'#include <stdint.h>',NL
rth,←'#include <stdio.h>',NL
rth,←'#include <inttypes.h>',NL
rth,←'#include <limits.h>',NL
rth,←'#include <float.h>',NL
rth,←'#include <locale>',NL
rth,←'#include <codecvt>',NL
rth,←'#include <math.h>',NL
rth,←'#include <memory>',NL
rth,←'#include <algorithm>',NL
rth,←'#include <stack>',NL
rth,←'#include <string>',NL
rth,←'#include <cstring>',NL
rth,←'#include <variant>',NL
rth,←'#include <vector>',NL
rth,←'#include <unordered_map>',NL
rth,←'#include <arrayfire.h>',NL
rth,←'using namespace af;',NL
rth,←'',NL
rth,←'#if AF_API_VERSION < 36',NL
rth,←'#error "Your ArrayFire version is too old."',NL
rth,←'#endif',NL
rth,←'#ifdef _WIN32',NL
rth,←' #define EXPORT extern "C" __declspec(dllexport)',NL
rth,←'#elif defined(__GNUC__)',NL
rth,←' #define EXPORT extern "C" __attribute__ ((visibility ("default")))',NL
rth,←'#else',NL
rth,←' #define EXPORT extern "C"',NL
rth,←'#endif',NL
rth,←'#ifdef _MSC_VER',NL
rth,←' #define RSTCT __restrict',NL
rth,←'#else',NL
rth,←' #define RSTCT restrict',NL
rth,←'#endif',NL
rth,←'#define S struct',NL
rth,←'#define Z static',NL
rth,←'#define R return',NL
rth,←'#define this_c (*this)',NL
rth,←'#define VEC std::vector',NL
rth,←'#define CVEC const std::vector',NL
rth,←'#define RANK(pp) ((pp)->r)',NL
rth,←'#define TYPE(pp) ((pp)->t)',NL
rth,←'#define SHAPE(pp) ((pp)->s)',NL
rth,←'#define ETYPE(pp) ((pp)->e)',NL
rth,←'#define DATA(pp) ((V*)&SHAPE(pp)[RANK(pp)])',NL
rth,←'#define CS(n,x) case n:x;break;',NL
rth,←'#define DO(n,x) {I _i=(n),i=0;for(;i<_i;++i){x;}}',NL
rth,←'#define DOB(n,x) {B _i=(n),i=0;for(;i<_i;++i){x;}}',NL
rth,←'#define MT',NL
rth,←'#define PUSH(x) s.emplace(x)',NL
rth,←'#define POP(f,x) x=std::get<f>(s.top());s.pop()',NL
rth,←'#define DEFN(n) FNP n##_p=std::make_shared<n##_f>();FN&n##_c=*n##_p;',NL
rth,←'#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\',NL
rth,←' n##_f():FN(nm,sm,sd){}};',NL
rth,←'#define OM(n,nm,sm,sd,mf,df,ma,da) S n##_o:MOP{mf;df;ma;da;\',NL
rth,←' n##_o(FNP l):MOP(nm,sm,sd,l){}\',NL
rth,←' n##_o(CA&l):MOP(nm,sm,sd,l){}};\',NL
rth,←' S n##_k:MOK{\',NL
rth,←'  FNP operator()(FNP l){R std::make_shared<n##_o>(l);}\',NL
rth,←'  FNP operator()(CA&l){R std::make_shared<n##_o>(l);}};',NL
rth,←'#define OD(n,nm,sm,sd,mf,df,ma,da) S n##_o:DOP{mf;df;ma;da;\',NL
rth,←' n##_o(FNP l,FNP r):DOP(nm,sm,sd,l,r){}\',NL
rth,←' n##_o(CA&l,FNP r):DOP(nm,sm,sd,l,r){}\',NL
rth,←' n##_o(FNP l,CA&r):DOP(nm,sm,sd,l,r){}\',NL
rth,←' n##_o(CA&l,CA&r):DOP(nm,sm,sd,l,r){}};\',NL
rth,←' S n##_k:DOK{\',NL
rth,←'  FNP operator()(FNP l,FNP r){R std::make_shared<n##_o>(l,r);}\',NL
rth,←'  FNP operator()(CA&l,CA&r){R std::make_shared<n##_o>(l,r);}\',NL
rth,←'  FNP operator()(FNP l,CA&r){R std::make_shared<n##_o>(l,r);}\',NL
rth,←'  FNP operator()(CA&l,FNP r){R std::make_shared<n##_o>(l,r);}};',NL
rth,←'#define DID inline array id(SHP)',NL
rth,←'#define MFD inline V operator()(A&z,CA&r,ENV&e)',NL
rth,←'#define MAD inline V operator()(A&z,CA&r,ENV&e,CA&ax)',NL
rth,←'#define DFD inline V operator()(A&z,CA&l,CA&r,ENV&e)',NL
rth,←'#define DAD inline V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)',NL
rth,←'#define DI(n) inline array n::id(SHP s)',NL
rth,←'#define ID(n,x,t) DI(n##_f){R constant(x,dim4(cnt(s)),t);}',NL
rth,←'#define MF(n) inline V n::operator()(A&z,CA&r,ENV&e)',NL
rth,←'#define MA(n) inline V n::operator()(A&z,CA&r,ENV&e,CA&ax)',NL
rth,←'#define DF(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e)',NL
rth,←'#define DA(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)',NL
rth,←'#define SF(n,lb) \',NL
rth,←' DF(n##_f){sclfn(z,l,r,e,[&](A&z,carr&lv,carr&rv,ENV&e){lb;});}\',NL
rth,←' DA(n##_f){sclfn(z,l,r,e,ax,n##_c);}',NL
rth,←'#define SMF(n,lb) \',NL
rth,←' MF(n##_f){msclfn(z,r,e,n##_c,[](A&z,carr&rv,ENV&e){lb;});}',NL
rth,←'#define EF(init,ex,fun) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\',NL
rth,←'  A cl,cr,za;fn##init##_f fn_c;fn_c(za,cl,cr,e##init);\',NL
rth,←'  cpda(cr,r);cpda(cl,l);\',NL
rth,←'  (*std::get<FNP>((*e##init[0])[fun]))(za,cl,cr,e##init);\',NL
rth,←'  cpad(z,za);}\',NL
rth,←' catch(U n){derr(n);}\',NL
rth,←' catch(exception&e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\',NL
rth,←'EXPORT V ex##_cdf(A*z,A*l,A*r){{A il,ir,iz;\',NL
rth,←' fn##init##_f fn_c;fn_c(iz,il,ir,e##init);}\',NL
rth,←' (*std::get<FNP>((*e##init[0])[fun]))(*z,*l,*r,e##init);}',NL
rth,←'#define EV(init,ex,slt)',NL
rth,←'#define VSWITCH(x,nil,arry,vec) \',NL
rth,←' std::visit(\',NL
rth,←'  visitor{[&](NIL v){nil;},[&](arr&v){arry;},[&](VEC<A>&v){vec;}},\',NL
rth,←'  (x));',NL
rth,←'#define CVSWITCH(x,nil,arr,vec) \',NL
rth,←' std::visit(\',NL
rth,←'  visitor{[&](NIL v){nil;},[&](carr&v){arr;},[&](CVEC<A>&v){vec;}},\',NL
rth,←'  (x));',NL
rth,←'typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,',NL
rth,←' APLR,APLF,APLQ}APLTYPE;',NL
rth,←'typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;',NL
rth,←'typedef double D;typedef unsigned char U8;typedef unsigned U;',NL
rth,←'typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;',NL
rth,←'typedef array arr;typedef const array carr;typedef af::index IDX;',NL
rth,←'typedef std::monostate NIL;',NL
rth,←'S{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;',NL
rth,←'S pkt{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];};',NL
rth,←'S lp{pkt*p;V*i;};',NL
rth,←'S dwa{B z;S{B z;pkt*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};',NL
rth,←'S dwa*dwafns;Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}',NL
rth,←'EXPORT I DyalogGetInterpreterFunctions(dwa*p){',NL
rth,←' if(p)dwafns=p;else R 0;if(dwafns->z<(B)sizeof(S dwa))R 16;R 0;}',NL
rth,←'Z V err(U n,const wchar_t*e){dmx.e=e;throw n;}Z V err(U n){err(n,L"");}',NL
rth,←'std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;',NL
rth,←'typedef VEC<dim_t> SHP;S A;',NL
rth,←'typedef std::variant<NIL,arr,VEC<A>> VALS;',NL
rth,←'S A{SHP s;VALS v;',NL
rth,←' A(){}',NL
rth,←' A(B r):s(SHP(r,1)){}',NL
rth,←' A(SHP s,VALS v):s(s),v(v){}',NL
rth,←' A(B r,VALS v):s(SHP(r,1)),v(v){}};',NL
rth,←'typedef const A CA;S FN;S MOK;S DOK;typedef std::shared_ptr<FN> FNP;',NL
rth,←'typedef std::shared_ptr<MOK> MOKP;typedef std::shared_ptr<DOK> DOKP;',NL
rth,←'typedef std::variant<A,FNP,MOKP,DOKP> BX;',NL
rth,←'typedef VEC<BX> FRM;typedef std::unique_ptr<FRM> FRMP;',NL
rth,←'typedef VEC<FRMP> ENV;typedef std::stack<BX> STK;',NL
rth,←'SHP eshp=SHP(0);std::wstring msg;',NL
rth,←'S FN{STR nm;I sm;I sd;FNP this_p;virtual ~FN() = default;',NL
rth,←' FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}',NL
rth,←' FN():nm(""),sm(0),sd(0){}',NL
rth,←' virtual arr id(SHP s){err(16);R arr();}',NL
rth,←' virtual V operator()(A&z,CA&r,ENV&e){err(99);}',NL
rth,←' virtual V operator()(A&z,CA&r,ENV&e,CA&ax){err(2);}',NL
rth,←' virtual V operator()(A&z,CA&l,CA&r,ENV&e){err(99);}',NL
rth,←' virtual V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax){err(2);}};',NL
rth,←'FNP MTFN = std::make_shared<FN>();',NL
rth,←'S MOP:FN{CA aa;FNP llp=MTFN;FN&ll=*llp;',NL
rth,←' MOP(STR nm,I sm,I sd,CA&l):FN(nm,sm,sd),aa(l),llp(MTFN){ll=*llp;}',NL
rth,←' MOP(STR nm,I sm,I sd,FNP llp):FN(nm,sm,sd),llp(llp){ll=*llp;}};',NL
rth,←'S DOP:FN{I fl;I fr;CA aa;CA ww;FNP llp=MTFN;FNP rrp=MTFN;FN&ll=*llp;FN&rr=*rrp;',NL
rth,←' DOP(STR nm,I sm,I sd,FNP l,FNP r)',NL
rth,←'  :FN(nm,sm,sd),fl(1),fr(1),llp(l),rrp(r){ll=*llp;rr=*rrp;}',NL
rth,←' DOP(STR nm,I sm,I sd,CA&l,FNP r)',NL
rth,←'  :FN(nm,sm,sd),fl(0),fr(1),aa(l),rrp(r){rr=*rrp;}',NL
rth,←' DOP(STR nm,I sm,I sd,FNP l,CA&r)',NL
rth,←'  :FN(nm,sm,sd),fl(1),fr(0),ww(r),llp(l){ll=*llp;}',NL
rth,←' DOP(STR nm,I sm,I sd,CA&l,CA&r)',NL
rth,←'  :FN(nm,sm,sd),fl(0),fr(0),aa(l),ww(r){}};',NL
rth,←'S MOK{virtual ~MOK() = default;',NL
rth,←' virtual FNP operator()(FNP l){err(99);R MTFN;}',NL
rth,←' virtual FNP operator()(CA&l){err(99);R MTFN;}};',NL
rth,←'S DOK{virtual ~DOK() = default;',NL
rth,←' virtual FNP operator()(FNP l,FNP r){err(99);R MTFN;}',NL
rth,←' virtual FNP operator()(CA&l,CA&r){err(99);R MTFN;}',NL
rth,←' virtual FNP operator()(FNP l,CA&r){err(99);R MTFN;}',NL
rth,←' virtual FNP operator()(CA&l,FNP r){err(99);R MTFN;}};',NL
rth,←'S DVSTR {',NL
rth,←' V operator()(NIL l,NIL r){err(6);}',NL
rth,←' V operator()(NIL l,carr&r){err(6);}',NL
rth,←' V operator()(NIL l,CVEC<A>&r){err(6);}',NL
rth,←' V operator()(carr&l,NIL r){err(6);}',NL
rth,←' V operator()(CVEC<A>&l,NIL r){err(6);}};',NL
rth,←'S MVSTR {V operator()(NIL r){err(6);}};',NL
rth,←'template<class... Ts> S visitor : Ts... { using Ts::operator()...; };',NL
rth,←'template<class... Ts> visitor(Ts...) -> visitor<Ts...>;',NL
rth,←'std::wstring mkstr(const char*s){R strconv.from_bytes(s);}',NL
rth,←'I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}I scm(FNP f){R (*f).sm;}',NL
rth,←'I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}I scd(FNP f){R (*f).sd;}',NL
rth,←'B rnk(const SHP&s){R s.size();}',NL
rth,←'B rnk(const A&a){R rnk(a.s);}',NL
rth,←'B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}',NL
rth,←'B cnt(const A&a){R cnt(a.s);}',NL
rth,←'B cnt(pkt*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}',NL
rth,←'B cnt(arr&a){R a.elements();}',NL
rth,←'I geti(CA&a){I x;CVSWITCH(a.v,err(6),x=v.as(s32).scalar<I>(),err(11));R x;}',NL
rth,←'arr scl(D x){R constant(x,dim4(1),f64);}',NL
rth,←'arr scl(I x){R constant(x,dim4(1),s32);}',NL
rth,←'arr scl(B x){R constant(x,dim4(1),u64);}',NL
rth,←'A scl(arr v){R A(0,v);}',NL
rth,←'arr axis(carr&a,const SHP&s,B ax){B l=1,m=1,r=1;if(ax>=rnk(s))R a;m=s[ax];',NL
rth,←' DOB(ax,l*=s[i])DOB(rnk(s)-ax-1,r*=s[ax+i+1])',NL
rth,←' R moddims(a,l,m,r);}',NL
rth,←'arr table(carr&a,const SHP&s,B ax){B l=1,r=1;if(ax>=rnk(s))R a;',NL
rth,←' DOB(ax,l*=s[i])DOB(rnk(s)-ax,r*=s[ax+i])',NL
rth,←' R moddims(a,l,r);}',NL
rth,←'arr unrav(carr&a,const SHP&sp){if(rnk(sp)>4)err(99);',NL
rth,←' dim4 s(1);DO((I)rnk(sp),s[i]=sp[i])',NL
rth,←' R moddims(a,s);}',NL
rth,←'V af2cd(A&a,const arr&b){dim4 bs=b.dims();a.s=SHP(4,1);DO(4,a.s[i]=bs[i])',NL
rth,←' a.v=flat(b);}',NL
rth,←'dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;',NL
rth,←' if(at==f64||bt==f64)R f64;',NL
rth,←' if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;',NL
rth,←' if(at==b8||bt==b8)R b8;err(16);R f64;}',NL
rth,←'dtype mxt(carr&a,carr&b){R mxt(a.type(),b.type());}',NL
rth,←'dtype mxt(dtype at,CA&b){',NL
rth,←' R std::visit(visitor{',NL
rth,←'   [&](NIL _){err(99,L"Unexpected value error.");R s32;},',NL
rth,←'   [&](carr&v){R mxt(at,v.type());},',NL
rth,←'   [&](CVEC<A>&v){dtype zt=at;DOB(v.size(),zt=mxt(zt,v[i]));R zt;}},',NL
rth,←'  b.v);}',NL
rth,←'dtype mxt(CA&a,CA&b){R mxt(mxt(b8,a),mxt(b8,b));}',NL
rth,←'inline I isint(D x){R x==nearbyint(x);}',NL
rth,←'inline I isint(CA&x){I res=1;',NL
rth,←' CVSWITCH(x.v',NL
rth,←'  ,err(99,L"Unexpected value error.")',NL
rth,←'  ,res=v.isinteger()||v.isbool()||(v.isreal()&&allTrue<I>(v==trunc(v)))',NL
rth,←'  ,DOB(v.size(),if(!isint(v[i])){res=0;R;}))',NL
rth,←' R res;}',NL
rth,←'inline I isbool(carr&v){R v.isbool()||(v.isreal()&&allTrue<I>(v==0||v==1));}',NL
rth,←'inline I isbool(CA&x){I res=1;',NL
rth,←' CVSWITCH(x.v',NL
rth,←'  ,err(99,L"Unexpected value error.")',NL
rth,←'  ,res=isbool(v)',NL
rth,←'  ,DOB(v.size(),if(!isbool(v[i])){res=0;R;}))',NL
rth,←' R res;}',NL
rth,←'V coal(A&a){',NL
rth,←' VSWITCH(a.v,,,',NL
rth,←'  B c=cnt(a);I can=1;',NL
rth,←'  DOB(c,A&b=v[i];',NL
rth,←'   coal(b);if(rnk(b))can=0;CVSWITCH(b.v,can=0,,can=0)',NL
rth,←'   if(!can)break)',NL
rth,←'  if(can){dtype tp=mxt(b8,a);arr nv(c,tp);',NL
rth,←'   const wchar_t*msg=L"Unexpected non-simple array type.";',NL
rth,←'   DOB(c,CVSWITCH(v[i].v,err(99,msg),nv((I)i)=v(0).as(tp),err(99,msg)))',NL
rth,←'   a.v=nv;})}',NL
rth,←'arr proto(carr&);VEC<A> proto(CVEC<A>&);A proto(CA&);',NL
rth,←'arr proto(carr&a){arr z=a;z=0;R z;}',NL
rth,←'VEC<A> proto(CVEC<A>&a){VEC<A> z(a.size());DOB(a.size(),z[i]=proto(a[i]));R z;}',NL
rth,←'A proto(CA&a){A z;z.s=a.s;CVSWITCH(a.v,err(6),z.v=proto(v),z.v=proto(v));R z;}',NL
rth,←'Z arr da16(B c,pkt*d){VEC<S16>b(c);S8*v=(S8*)DATA(d);',NL
rth,←' DOB(c,b[i]=v[i]);R arr(c,b.data());}',NL
rth,←'Z arr da8(B c,pkt*d){VEC<char>b(c);U8*v=(U8*)DATA(d);',NL
rth,←' DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R arr(c,b.data());}',NL
rth,←'pkt*cpad(lp*l,CA&a){I t;B c=cnt(a),ar=rnk(a);pkt*p=NULL;',NL
rth,←' if(ar>15)err(16,L"Dyalog APL does not support ranks > 15.");',NL
rth,←' B s[15];DOB(ar,s[ar-i-1]=a.s[i]);',NL
rth,←' std::visit(visitor{',NL
rth,←'   [&](NIL _){if(l)l->p=NULL;},',NL
rth,←'   [&](carr&v){',NL
rth,←'    switch(v.type()){',NL
rth,←'     CS(c64,t=APLZ);CS(s32,t=APLI);CS(s16,t=APLSI);',NL
rth,←'     CS(b8,t=APLTI);CS(f64,t=APLD);',NL
rth,←'     default:if(c)err(16);t=APLI;}',NL
rth,←'    p=dwafns->ws->ga(t,(U)ar,s,l);if(c)v.host(DATA(p));},',NL
rth,←'   [&](CVEC<A>&v){',NL
rth,←'    p=dwafns->ws->ga(APLP,(U)ar,s,l);pkt**d=(pkt**)DATA(p);',NL
rth,←'    DOB(c,if(!(d[i]=cpad(NULL,v[i])))err(6))}},',NL
rth,←'  a.v);',NL
rth,←'  R p;}',NL
rth,←'V cpda(A&a,pkt*d){',NL
rth,←' B c=cnt(d);a.s=SHP(RANK(d));DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);',NL
rth,←' switch(TYPE(d)){',NL
rth,←'  CS(15,',NL
rth,←'   if(!c){a.v=scl(0);R;}',NL
rth,←'   switch(ETYPE(d)){',NL
rth,←'    CS(APLZ ,a.v=arr(c,(DZ*)DATA(d))) CS(APLI ,a.v=arr(c,(I*)DATA(d)))',NL
rth,←'    CS(APLD ,a.v=arr(c,(D*)DATA(d)))  CS(APLSI,a.v=arr(c,(S16*)DATA(d)))',NL
rth,←'    CS(APLTI,a.v=da16(c,d))           CS(APLU8,a.v=da8(c,d))',NL
rth,←'    default:err(16);})',NL
rth,←'  CS(7,{if(APLP!=ETYPE(d))err(16);',NL
rth,←'   pkt**dv=(pkt**)DATA(d);',NL
rth,←'   if(!c)c++;a.v=VEC<A>(c);',NL
rth,←'   DOB(c,cpda(std::get<VEC<A>>(a.v)[i],dv[i]))})',NL
rth,←'  default:err(16);}}',NL
rth,←'V cpda(A&a,lp*d){if(d==NULL)R;cpda(a,d->p);}',NL
rth,←'EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}',NL
rth,←'EXPORT V frea(A*a){delete a;}',NL
rth,←'EXPORT V exarray(lp*d,A*a){cpad(d,*a);}',NL
rth,←'EXPORT V afsync(){sync();}',NL
rth,←'EXPORT Window *w_new(char *k){R new Window(k);}',NL
rth,←'EXPORT I w_close(Window*w){R w->close();}',NL
rth,←'EXPORT V w_del(Window*w){delete w;}',NL
rth,←'EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);',NL
rth,←' std::visit(visitor{',NL
rth,←'   [&](NIL&_){err(6);},',NL
rth,←'   [&](VEC<A>&v){err(16,L"Image requires a flat array.");},',NL
rth,←'   [&](carr&v){w->image(v.as(rnk(a)==2?f32:u8));}},',NL
rth,←'  a.v);}',NL
rth,←'EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);',NL
rth,←' std::visit(visitor{',NL
rth,←'   [&](NIL&_){err(6);},',NL
rth,←'   [&](VEC<A>&v){err(16,L"Plot requires a flat array.");},',NL
rth,←'   [&](carr&v){w->plot(v.as(f32));}},',NL
rth,←'  a.v);}',NL
rth,←'EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);',NL
rth,←' std::visit(visitor{',NL
rth,←'   [&](NIL&_){err(6);},',NL
rth,←'   [&](VEC<A>&v){err(16,L"Hist requires a flat array.");},',NL
rth,←'   [&](carr&v){w->hist(v.as(u32),l,h);}},',NL
rth,←'  a.v);}',NL
rth,←'EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);',NL
rth,←' I rk=a.numdims();dim4 s=a.dims();',NL
rth,←' A b(rk,flat(a).as(s16));DO(rk,b.s[i]=s[i])cpad(z,b);}',NL
rth,←'EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);',NL
rth,←' std::visit(visitor{',NL
rth,←'   [&](NIL&_){err(6);},',NL
rth,←'   [&](VEC<A>&v){err(16,L"Save requires a flat array.");},',NL
rth,←'   [&](carr&v){saveImageNative(p,v.as(v.type()==s32?u16:u8));}},',NL
rth,←'  a.v);}',NL
rth,←'EXPORT V cd_sync(V){sync();}',NL
rtn[0],←⊂'NM(add,"add",1,1,DID,MFD,DFD,MT,DAD)',NL
rtn[0],←⊂'DEFN(add)',NL
rtn[0],←⊂'ID(add,0,s32)',NL
rtn[0],←⊂'MF(add_f){z=r;}',NL
rtn[0],←⊂'SF(add,z.v=lv+rv)',NL
rtn[1],←⊂'NM(sub,"sub",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[1],←⊂'DEFN(sub)',NL
rtn[1],←⊂'ID(sub,0,s32)',NL
rtn[1],←⊂'SMF(sub,z.v=-rv)',NL
rtn[1],←⊂'SF(sub,z.v=lv-rv)',NL
rtn[1],←⊂'',NL
rtn[2],←⊂'NM(mul,"mul",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[2],←⊂'DEFN(mul)',NL
rtn[2],←⊂'ID(mul,1,s32)',NL
rtn[2],←⊂'SMF(mul,z.v=(rv>0)-(rv<0))',NL
rtn[2],←⊂'SF(mul,z.v=lv*rv)',NL
rtn[2],←⊂'',NL
rtn[3],←⊂'NM(div,"div",1,1,DID,MFD,DFD,MT,DAD)',NL
rtn[3],←⊂'DEFN(div)',NL
rtn[3],←⊂'ID(div,1,s32)',NL
rtn[3],←⊂'SMF(div,z.v=1.0/rv.as(f64))',NL
rtn[3],←⊂'SF(div,z.v=lv.as(f64)/rv.as(f64))',NL
rtn[4],←⊂'NM(exp,"exp",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[4],←⊂'ID(exp,1,s32)',NL
rtn[4],←⊂'DEFN(exp)',NL
rtn[4],←⊂'SMF(exp,z.v=exp(rv.as(f64)))',NL
rtn[4],←⊂'SF(exp,z.v=pow(lv.as(f64),rv.as(f64)))',NL
rtn[5],←⊂'NM(log,"log",1,1,MT ,MFD,DFD,MT ,DAD)',NL
rtn[5],←⊂'DEFN(log)',NL
rtn[5],←⊂'SMF(log,z.v=log(rv.as(f64)))',NL
rtn[5],←⊂'SF(log,z.v=log(rv.as(f64))/log(lv.as(f64)))',NL
rtn[5],←⊂'',NL
rtn[6],←⊂'NM(res,"res",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[6],←⊂'DEFN(res)',NL
rtn[6],←⊂'ID(res,0,s32)',NL
rtn[6],←⊂'SMF(res,z.v=abs(rv).as(rv.type()))',NL
rtn[6],←⊂'SF(res,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))',NL
rtn[6],←⊂'',NL
rtn[7],←⊂'NM(cir,"cir",1,1,MT,MFD,DFD,MT,DAD)',NL
rtn[7],←⊂'DEFN(cir)',NL
rtn[7],←⊂'SMF(cir,z.v=Pi*rv.as(f64))',NL
rtn[7],←⊂'SF(cir,arr fv=rv.as(f64);B lr=rnk(l);',NL
rtn[7],←⊂' if(!lr){I x=lv.as(s32).scalar<I>();if(abs(x)>10)err(16);',NL
rtn[7],←⊂'  switch(x){CS(0,z.v=sqrt(1-fv*fv))CS(1,z.v=sin(fv))CS(2,z.v=cos(fv))',NL
rtn[7],←⊂'   CS(3,z.v=tan(fv))CS(4,z.v=sqrt(1+fv*fv))CS(5,z.v=sinh(fv))',NL
rtn[7],←⊂'   CS(6,z.v=cosh(fv))CS(7,z.v=tanh(fv))CS(8,z.v=sqrt(fv*fv-1))CS(9,z.v=fv)',NL
rtn[7],←⊂'   CS(10,z.v=abs(fv))CS(-1,z.v=asin(fv))CS(-2,z.v=acos(fv))',NL
rtn[7],←⊂'   CS(-3,z.v=atan(fv))CS(-4,z.v=(fv+1)*sqrt((fv-1)/(fv+1)))',NL
rtn[7],←⊂'   CS(-5,z.v=asinh(fv))CS(-6,z.v=acosh(fv))CS(-7,z.v=atanh(fv))',NL
rtn[7],←⊂'   CS(-8,z.v=-sqrt(fv*fv-1))CS(-9,z.v=fv)CS(-10,z.v=fv)}R;}',NL
rtn[7],←⊂' if(anyTrue<I>(abs(lv)>10))err(16);B c=cnt(z);VEC<D> zv(c);',NL
rtn[7],←⊂' VEC<I> a(c);lv.as(s32).host(a.data());VEC<D> b(c);fv.host(b.data());',NL
rtn[7],←⊂' DOB(c,switch(a[i]){CS(0,zv[i]=sqrt(1-b[i]*b[i]))CS(1,zv[i]=sin(b[i]))',NL
rtn[7],←⊂'  CS(2,zv[i]=cos(b[i]))CS(3,zv[i]=tan(b[i]))CS(4,zv[i]=sqrt(1+b[i]*b[i]))',NL
rtn[7],←⊂'  CS(5,zv[i]=sinh(b[i]))CS(6,zv[i]=cosh(b[i]))CS(7,zv[i]=tanh(b[i]))',NL
rtn[7],←⊂'  CS(8,zv[i]=sqrt(b[i]*b[i]-1))CS(9,zv[i]=b[i])CS(10,zv[i]=abs(b[i]))',NL
rtn[7],←⊂'  CS(-1,zv[i]=asin(b[i]))CS(-2,zv[i]=acos(b[i]))CS(-3,zv[i]=atan(b[i]))',NL
rtn[7],←⊂'  CS(-4,zv[i]=(b[i]==-1)?0:(b[i]+1)*sqrt((b[i]-1)/(b[i]+1)))',NL
rtn[7],←⊂'  CS(-5,zv[i]=asinh(b[i]))CS(-6,zv[i]=acosh(b[i]))CS(-7,zv[i]=atanh(b[i]))',NL
rtn[7],←⊂'  CS(-8,zv[i]=-sqrt(b[i]*b[i]-1))CS(-9,zv[i]=b[i])CS(-10,zv[i]=b[i])})',NL
rtn[7],←⊂' z.v=arr(c,zv.data());)',NL
rtn[8],←⊂'NM(min,"min",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[8],←⊂'DEFN(min)',NL
rtn[8],←⊂'ID(min,DBL_MAX,f64)',NL
rtn[8],←⊂'SMF(min,z.v=floor(rv).as(rv.type()))',NL
rtn[8],←⊂'SF(min,z.v=min(lv,rv))',NL
rtn[8],←⊂'',NL
rtn[9],←⊂'NM(max,"max",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[9],←⊂'DEFN(max)',NL
rtn[9],←⊂'ID(max,-DBL_MAX,f64)',NL
rtn[9],←⊂'SMF(max,z.v=ceil(rv).as(rv.type()))',NL
rtn[9],←⊂'SF(max,z.v=max(lv,rv))',NL
rtn[9],←⊂'',NL
rtn[10],←⊂'NM(fac,"fac",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[10],←⊂'DEFN(fac)',NL
rtn[10],←⊂'ID(fac,1,s32)',NL
rtn[10],←⊂'SMF(fac,z.v=factorial(rv.as(f64)))',NL
rtn[10],←⊂'SF(fac,arr lvf=lv.as(f64);arr rvf=rv.as(f64);',NL
rtn[10],←⊂' z.v=exp(lgamma(1+rvf)-(lgamma(1+lvf)+lgamma(1+rvf-lvf))))',NL
rtn[11],←⊂'NM(lth,"lth",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[11],←⊂'DEFN(lth)',NL
rtn[11],←⊂'ID(lth,0,s32)',NL
rtn[11],←⊂'SF(lth,z.v=lv<rv)',NL
rtn[11],←⊂'',NL
rtn[12],←⊂'NM(lte,"lte",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[12],←⊂'DEFN(lte)',NL
rtn[12],←⊂'ID(lte,1,s32)',NL
rtn[12],←⊂'SF(lte,z.v=lv<=rv)',NL
rtn[12],←⊂'',NL
rtn[13],←⊂'NM(eql,"eql",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[13],←⊂'DEFN(eql)',NL
rtn[13],←⊂'ID(eql,1,s32)',NL
rtn[13],←⊂'SF(eql,z.v=lv==rv)',NL
rtn[14],←⊂'NM(gte,"gte",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[14],←⊂'DEFN(gte)',NL
rtn[14],←⊂'ID(gte,1,s32)',NL
rtn[14],←⊂'SF(gte,z.v=lv>=rv)',NL
rtn[14],←⊂'',NL
rtn[15],←⊂'NM(gth,"gth",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[15],←⊂'DEFN(gth)',NL
rtn[15],←⊂'ID(gth,0,s32)',NL
rtn[15],←⊂'SF(gth,z.v=lv>rv)',NL
rtn[15],←⊂'',NL
rtn[16],←⊂'NM(neq,"neq",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[16],←⊂'DEFN(neq)',NL
rtn[16],←⊂'ID(neq,0,s32)',NL
rtn[16],←⊂'SF(neq,z.v=lv!=rv)',NL
rtn[16],←⊂'',NL
rtn[17],←⊂'NM(not,"not",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[17],←⊂'DEFN(not)',NL
rtn[17],←⊂'SMF(not,z.v=!rv)',NL
rtn[17],←⊂'DF(not_f){err(16);}',NL
rtn[17],←⊂'',NL
rtn[18],←⊂'NM(and,"and",1,1,DID,MT,DFD,MT,DAD)',NL
rtn[18],←⊂'DEFN(and)',NL
rtn[18],←⊂'ID(and,1,s32)',NL
rtn[18],←⊂'SF(and,if(lv.isbool()&&rv.isbool())z.v=lv&&rv;',NL
rtn[18],←⊂' else if(allTrue<I>(lv>=0&&lv<=1&&rv>0&&rv<=1))z.v=lv&&rv;',NL
rtn[18],←⊂' else{A a(z.s,lv);A b(z.s,rv);',NL
rtn[18],←⊂'  lor_c(a,a,b,e);arr&av=std::get<arr>(a.v);',NL
rtn[18],←⊂'  z.v=lv.as(f64)*(rv/((!av)+av));})',NL
rtn[19],←⊂'NM(lor,"lor",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[19],←⊂'DEFN(lor)',NL
rtn[19],←⊂'ID(lor,0,s32)',NL
rtn[19],←⊂'SF(lor,if(rv.isbool()&&lv.isbool())z.v=lv||rv;',NL
rtn[19],←⊂' else if(lv.isbool()&&rv.isinteger())z.v=lv+(!lv)*abs(rv).as(rv.type());',NL
rtn[19],←⊂' else if(rv.isbool()&&lv.isinteger())z.v=rv+(!rv)*abs(lv).as(lv.type());',NL
rtn[19],←⊂' else if(lv.isinteger()&&rv.isinteger()){B c=cnt(z);',NL
rtn[19],←⊂'  VEC<I> a(c);abs(lv).as(s32).host(a.data());',NL
rtn[19],←⊂'  VEC<I> b(c);abs(rv).as(s32).host(b.data());',NL
rtn[19],←⊂'  DOB(c,while(b[i]){I t=b[i];b[i]=a[i]%b[i];a[i]=t;})',NL
rtn[19],←⊂'  z.v=arr(c,a.data());}',NL
rtn[19],←⊂' else{B c=cnt(z);',NL
rtn[19],←⊂'  VEC<D> a(c);abs(lv).as(f64).host(a.data());',NL
rtn[19],←⊂'  VEC<D> b(c);abs(rv).as(f64).host(b.data());',NL
rtn[19],←⊂'  DOB(c,while(b[i]>1e-12){D t=b[i];b[i]=fmod(a[i],b[i]);a[i]=t;})',NL
rtn[19],←⊂'  z.v=arr(c,a.data());})',NL
rtn[19],←⊂'',NL
rtn[20],←⊂'NM(nan,"nan",1,1,MT ,MT ,DFD,MT ,DAD)',NL
rtn[20],←⊂'DEFN(nan)',NL
rtn[20],←⊂'SF(nan,z.v=!(lv&&rv))',NL
rtn[20],←⊂'',NL
rtn[21],←⊂'NM(nor,"nor",1,1,MT ,MT ,DFD,MT ,DAD)',NL
rtn[21],←⊂'DEFN(nor)',NL
rtn[21],←⊂'SF(nor,z.v=!(lv||rv))',NL
rtn[22],←⊂'NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,DAD)',NL
rtn[22],←⊂'DEFN(sqd)',NL
rtn[22],←⊂'MF(sqd_f){z=r;}',NL
rtn[22],←⊂'DA(sqd_f){if(rnk(ax)>1)err(4);if(!isint(ax))err(11);',NL
rtn[22],←⊂' B ac=cnt(ax);VEC<I> av(ac);',NL
rtn[22],←⊂' if(ac)CVSWITCH(ax.v,err(6),v.as(s32).host(av.data()),err(11))',NL
rtn[22],←⊂' B rr=rnk(r);DOB(ac,if(av[i]<0)err(11))DOB(ac,if(av[i]>=rr)err(4))',NL
rtn[22],←⊂' B lc=cnt(l);if(rnk(l)>1)err(4);if(lc!=ac)err(5);if(!lc){z=r;R;}',NL
rtn[22],←⊂' VEC<U8> m(rr);DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)if(!isint(l))err(11);',NL
rtn[22],←⊂' VEC<I> lv(lc);CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(16))',NL
rtn[22],←⊂' DOB(lc,if(lv[i]<0||lv[i]>=r.s[rr-av[i]-1])err(3))',NL
rtn[22],←⊂' z.s=SHP(rr-lc);I j=0;DOB(rr,if(!m[rr-i-1])z.s[j++]=r.s[i])',NL
rtn[22],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[22],←⊂'  ,if(rr<5){IDX x[4];DOB(lc,x[rr-av[i]-1]=lv[i]);',NL
rtn[22],←⊂'    dim4 rs(1);DO((I)rr,rs[i]=r.s[i])',NL
rtn[22],←⊂'    z.v=flat(moddims(v,rs)(x[0],x[1],x[2],x[3]));R;}',NL
rtn[22],←⊂'   VEC<seq> x(rr);arr ix=scl(0);',NL
rtn[22],←⊂'   DOB(rr,x[i]=seq((D)r.s[i]))DOB(lc,x[rr-av[i]-1]=seq(lv[i],lv[i]))',NL
rtn[22],←⊂'   DOB(rr,B j=rr-i-1;ix=moddims(ix*r.s[j],1,(U)cnt(ix));',NL
rtn[22],←⊂'    ix=flat(tile(ix,(U)x[j].size,1)+tile(x[j],1,(U)cnt(ix))))',NL
rtn[22],←⊂'   z.v=v(ix)',NL
rtn[22],←⊂'  ,err(16))}',NL
rtn[22],←⊂'DF(sqd_f){A ax;iot_c(ax,scl(scl((I)cnt(l))),e);sqd_c(z,l,r,e,ax);}',NL
rtn[23],←⊂'NM(brk,"brk",0,0,MT,MT,DFD,MT,MT)',NL
rtn[23],←⊂'DEFN(brk)',NL
rtn[23],←⊂'DF(brk_f){B lr=rnk(l);B rc=cnt(r);',NL
rtn[23],←⊂' if(!rc){if(lr!=1)err(4);z=l;R;}if(rc!=lr)err(4);',NL
rtn[23],←⊂' CVSWITCH(r.v,err(6),err(99,L"Unexpected bracket index set."),',NL
rtn[23],←⊂'  VEC<B> rm(rc);CVEC<A>&rv=v;',NL
rtn[23],←⊂'  DOB(rc,CVSWITCH(rv[i].v,rm[i]=1,rm[i]=rnk(rv[i]),err(11)))',NL
rtn[23],←⊂'  B zr=0;DOB(rc,zr+=rm[i])z.s=SHP(zr);B s=zr;',NL
rtn[23],←⊂'  DOB(rc,B j=i;s-=rm[j];',NL
rtn[23],←⊂'   DOB(rm[j],B&x=z.s[s+i];',NL
rtn[23],←⊂'    CVSWITCH(rv[j].v,x=l.s[rc-j-1],x=rv[j].s[i],err(99))))',NL
rtn[23],←⊂'  if(zr<=4){IDX x[4];',NL
rtn[23],←⊂'   DOB(rc,CVSWITCH(rv[i].v,,x[rc-i-1]=v.as(s32),err(99)))',NL
rtn[23],←⊂'   dim4 sp(1);DO((I)lr,sp[i]=l.s[i])',NL
rtn[23],←⊂'   CVSWITCH(l.v,err(6)',NL
rtn[23],←⊂'    ,z.v=flat(moddims(v,sp)(x[0],x[1],x[2],x[3]))',NL
rtn[23],←⊂'    ,err(16))}',NL
rtn[23],←⊂'  else err(16))}',NL
rtn[23],←⊂'',NL
rtn[23],←⊂'OD(brk,"brk",scm(l),scd(l),MFD,DFD,MT ,MT )',NL
rtn[23],←⊂'MF(brk_o){if(rnk(ww)>1)err(4);ll(z,r,e,ww);}',NL
rtn[23],←⊂'DF(brk_o){if(rnk(ww)>1)err(4);ll(z,l,r,e,ww);}',NL
rtn[23],←⊂'',NL
rtn[24],←⊂'NM(iot,"iot",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[24],←⊂'DEFN(iot)',NL
rtn[24],←⊂'MF(iot_f){if(rnk(r)>1)err(4);B c=cnt(r);if(c>4)err(10);if(c>1)err(16);',NL
rtn[24],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[24],←⊂'  ,I rv=v.as(s32).scalar<I>();',NL
rtn[24],←⊂'   z.s=SHP(1,rv);z.v=z.s[0]?iota(dim4(rv),dim4(1),s32):scl(0);',NL
rtn[24],←⊂'  ,err(11))}',NL
rtn[24],←⊂'DF(iot_f){z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}',NL
rtn[24],←⊂' I lc=(I)cnt(l)+1;if(lc==1){z.v=constant(0,cnt(r),s16);R;};if(rnk(l)>1)err(16);',NL
rtn[24],←⊂' std::visit(visitor{DVSTR(),',NL
rtn[24],←⊂'   [&](carr&olv,carr&orv){arr lv=olv,rv=orv,ix;sort(lv,ix,lv);',NL
rtn[24],←⊂'    z.v=constant(0,cnt(r),s32);arr&zv=std::get<arr>(z.v);',NL
rtn[24],←⊂'    for(I h;h=lc/2;lc-=h){arr t=zv+h;replace(zv,lv(t)>rv,t);}',NL
rtn[24],←⊂'    zv=arr(select(lv(zv)==rv,ix(zv).as(s32),(I)cnt(l)),c);},',NL
rtn[24],←⊂'   [&](CVEC<A>&lv,carr&rv){err(16);},',NL
rtn[24],←⊂'   [&](carr&lv,CVEC<A>&rv){err(16);},',NL
rtn[24],←⊂'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);}},',NL
rtn[24],←⊂'  l.v,r.v);}',NL
rtn[25],←⊂'NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[25],←⊂'DEFN(rho)',NL
rtn[25],←⊂'MF(rho_f){B rr=rnk(r);VEC<I> sp(rr);DOB(rr,sp[rr-i-1]=(I)r.s[i])',NL
rtn[25],←⊂' z.s=SHP(1,rr);if(!cnt(z)){z.v=scl(0);R;}z.v=arr(rr,sp.data());}',NL
rtn[25],←⊂'DF(rho_f){B cr=cnt(r),cl=cnt(l);VEC<I> s(cl);',NL
rtn[25],←⊂' if(rnk(l)>1)err(11);if(!isint(l))err(11);',NL
rtn[25],←⊂' CVSWITCH(l.v,err(6),if(cl)v.as(s32).host(s.data()),if(cl)err(16))',NL
rtn[25],←⊂' DOB(cl,if(s[i]<0)err(11))z.s=SHP(cl);DOB(cl,z.s[i]=(B)s[cl-i-1])',NL
rtn[25],←⊂' B cz=cnt(z);',NL
rtn[25],←⊂' if(!cz){CVSWITCH(r.v,err(6),z.v=proto(v(0)),z.v=VEC<A>(1,proto(v[0])))R;}',NL
rtn[25],←⊂' if(cz==cr){z.v=r.v;R;}',NL
rtn[25],←⊂' CVSWITCH(r.v,err(6),z.v=v(iota(cz)%cr),',NL
rtn[25],←⊂'  z.v=VEC<A>(cz);VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(cz,zv[i]=v[i%cr]))}',NL
rtn[26],←⊂'NM(cat,"cat",0,0,MT ,MFD,DFD,MAD,DAD)',NL
rtn[26],←⊂'DEFN(cat)',NL
rtn[26],←⊂'MF(cat_f){z.s=SHP(1,cnt(r));z.v=r.v;}',NL
rtn[26],←⊂'MA(cat_f){B ac=cnt(ax),ar=rnk(ax),rr=rnk(r);if(ac>1&&ar>1)err(4);',NL
rtn[26],←⊂' VEC<D> axv(ac);if(ac)CVSWITCH(ax.v,err(6),v.as(f64).host(axv.data()),err(11))',NL
rtn[26],←⊂' if(ac==1&&(axv[0]<=-1||rr<=axv[0]))err(4);',NL
rtn[26],←⊂' if(ac>1){I c=(I)axv[0];if(c<0)err(11);DO((I)ac,if(axv[i]!=c++)err(11))',NL
rtn[26],←⊂'  if(c>rr)err(4);}',NL
rtn[26],←⊂' I xt=(!ac||(ac==1&&!isint(axv[0])));if(rr==4&&xt)err(16);',NL
rtn[26],←⊂' z=r;B zr=rr;if(!xt&&ac==1)R;DO((I)ac,axv[i]=ceil(rr-axv[i]-1))',NL
rtn[26],←⊂' if(xt){zr++;SHP sp(zr);DOB(rr,sp[i]=r.s[i])B pt=ac?(B)axv[0]:0;',NL
rtn[26],←⊂'  DOB(rr-pt,sp[zr-i-1]=sp[zr-i-2])sp[pt]=1;z.s=sp;R;}',NL
rtn[26],←⊂' B s=(B)axv[ac-1],ei=(B)axv[0];',NL
rtn[26],←⊂' zr=rr-ac+1;z.s=SHP(zr,1);DOB(s,z.s[i]=r.s[i])',NL
rtn[26],←⊂' DOB(ac,z.s[s]*=r.s[s+i])DOB(rr-ei-1,z.s[s+i+1]=r.s[ei+i+1])}',NL
rtn[26],←⊂'DA(cat_f){B ar=rnk(ax),lr=rnk(l),rr=rnk(r);',NL
rtn[26],←⊂' if(lr>4||rr>4)err(16);',NL
rtn[26],←⊂' if(ar>1)err(4);if(cnt(ax)!=1)err(5);',NL
rtn[26],←⊂' D ox;CVSWITCH(ax.v,err(6),ox=v.as(f64).scalar<D>(),err(11))',NL
rtn[26],←⊂' B rk=lr>rr?lr:rr;if(ox<=-1)err(11);if(ox>=rk)err(4);',NL
rtn[26],←⊂' if(lr&&rr&&std::abs((I)lr-rr)>1)err(4);',NL
rtn[26],←⊂' A nl=l,nr=r;D axv=rk-ox-1;I fx=(I)ceil(axv);',NL
rtn[26],←⊂' if(axv!=fx){if(rr>3||lr>3)err(16);if(rr&&lr&&lr!=rr)err(4);',NL
rtn[26],←⊂'  if(lr)cat_c(nl,l,e,ax);if(rr)cat_c(nr,r,e,ax);',NL
rtn[26],←⊂'  if(!lr&&!rr)cat_c(nl,l,e,ax);cat_c(nr,r,e,ax);',NL
rtn[26],←⊂'  cat_c(z,nl,nr,e,scl(scl((I)ceil(ox))));R;}',NL
rtn[26],←⊂' z.s=SHP((lr>=rr)*lr+(rr>lr)*rr+(!rr&&!lr));',NL
rtn[26],←⊂' dim4 ls(1),rs(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',NL
rtn[26],←⊂' if(!lr){ls=rs;ls[fx]=1;}if(!rr){rs=ls;rs[fx]=1;}',NL
rtn[26],←⊂' if(rr&&lr>rr){DO(3-fx,rs[3-i]=rs[3-i-1]);rs[fx]=1;}',NL
rtn[26],←⊂' if(lr&&rr>lr){DO(3-fx,ls[3-i]=ls[3-i-1]);ls[fx]=1;}',NL
rtn[26],←⊂' DO(4,if(i!=fx&&rs[i]!=ls[i])err(5));',NL
rtn[26],←⊂' DO((I)rnk(z),z.s[i]=(lr>=rr||i==fx)*ls[i]+(rr>lr||i==fx)*rs[i]);',NL
rtn[26],←⊂' std::visit(visitor{DVSTR(),',NL
rtn[26],←⊂'   [&](CVEC<A>&lv,carr&rv){err(16);},',NL
rtn[26],←⊂'   [&](carr&lv,CVEC<A>&rv){err(16);},',NL
rtn[26],←⊂'   [&](CVEC<A>&lv,CVEC<A>&rv){if(rr>1||lr>1)err(16);B lc=cnt(l),rc=cnt(r);',NL
rtn[26],←⊂'    z.v=VEC<A>(lc+rc,A());VEC<A>&zv=std::get<VEC<A>>(z.v);',NL
rtn[26],←⊂'    DOB(lc,zv[i]=lv[i])DOB(rc,zv[i+lc]=rv[i])},',NL
rtn[26],←⊂'   [&](carr&olv,carr&orv){dtype mt=mxt(orv,olv);',NL
rtn[26],←⊂'    array lv=(lr?moddims(olv,ls):tile(olv,ls)).as(mt);',NL
rtn[26],←⊂'    array rv=(rr?moddims(orv,rs):tile(orv,rs)).as(mt);',NL
rtn[26],←⊂'    if(!cnt(l)){z.v=flat(rv);R;}if(!cnt(r)){z.v=flat(lv);R;}',NL
rtn[26],←⊂'    z.v=flat(join(fx,lv,rv));}},',NL
rtn[26],←⊂'  l.v,r.v);}',NL
rtn[26],←⊂'DF(cat_f){B lr=rnk(l),rr=rnk(r);',NL
rtn[26],←⊂' if(lr||rr){cat_c(z,l,r,e,scl(scl((lr>rr?lr:rr)-1)));R;}',NL
rtn[26],←⊂' A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}',NL
rtn[27],←⊂'NM(ctf,"ctf",0,0,MT,MFD,DFD,MT,DAD)',NL
rtn[27],←⊂'DEFN(ctf)',NL
rtn[27],←⊂'MF(ctf_f){B rr=rnk(r);z.s=SHP(2,1);z.v=r.v;',NL
rtn[27],←⊂' if(rr)z.s[1]=r.s[rr-1];if(z.s[1])z.s[0]=cnt(r)/z.s[1];}',NL
rtn[27],←⊂'DA(ctf_f){cat_c(z,l,r,e,ax);}',NL
rtn[27],←⊂'DF(ctf_f){if(rnk(l)||rnk(r)){cat_c(z,l,r,e,scl(scl(0)));R;}',NL
rtn[27],←⊂' A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}',NL
rtn[28],←⊂'NM(rot,"rot",0,0,DID,MFD,DFD,MAD,DAD)',NL
rtn[28],←⊂'DEFN(rot)',NL
rtn[28],←⊂'ID(rot,0,s32)',NL
rtn[28],←⊂'MF(rot_f){if(!rnk(r)){z=r;R;}rot_c(z,r,e,scl(scl(rnk(r)-1)));}',NL
rtn[28],←⊂'MA(rot_f){if(1!=cnt(ax))err(5);if(!isint(ax))err(11);',NL
rtn[28],←⊂' I axv;CVSWITCH(ax.v,err(6),axv=v.as(s32).scalar<I>(),err(11))',NL
rtn[28],←⊂' B rr=rnk(r);if(axv<0||rr<=axv)err(4);z.s=r.s;if(!cnt(r)){z.v=r.v;R;}',NL
rtn[28],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[28],←⊂'  ,z.v=flat(flip(axis(v,r.s,rr-axv-1),1))',NL
rtn[28],←⊂'  ,err(16))}',NL
rtn[28],←⊂'DA(rot_f){B rr=rnk(r),lr=rnk(l);if(rr>4)err(16);',NL
rtn[28],←⊂' if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',NL
rtn[28],←⊂' I ra;CVSWITCH(ax.v,err(6),ra=v.as(s32).scalar<I>(),err(11))',NL
rtn[28],←⊂' if(ra<0)err(11);if(ra>=rr)err(4);B lc=cnt(l);I aa=ra;ra=(I)rr-ra-1;',NL
rtn[28],←⊂' if(lc!=1&&lr!=rr-1)err(4);',NL
rtn[28],←⊂' if(lc==1){z.s=r.s;I ix[]={0,0,0,0};',NL
rtn[28],←⊂'  CVSWITCH(l.v,err(6),ix[ra]=-v.as(s32).scalar<I>(),err(11))',NL
rtn[28],←⊂'  CVSWITCH(r.v,err(6)',NL
rtn[28],←⊂'   ,z.v=flat(shift(unrav(v,r.s),ix[0],ix[1],ix[2],ix[3]))',NL
rtn[28],←⊂'   ,err(16))',NL
rtn[28],←⊂'  R;}',NL
rtn[28],←⊂' I j=0;DOB(lr,if(i==ra)j++;if(l.s[i]!=r.s[j++])err(5))',NL
rtn[28],←⊂' res_c(z,scl(scl(r.s[ra])),l,e);arr&zv=std::get<arr>(z.v);',NL
rtn[28],←⊂' B tc=1;DO(ra,tc*=r.s[i])zv*=tc;cat_c(z,z,e,scl(scl(aa-.5)));',NL
rtn[28],←⊂' zv=flat(tile(axis(zv,z.s,ra),1,(U)r.s[ra],1));z.s[ra]=r.s[ra];',NL
rtn[28],←⊂' dim4 s1(1);dim4 s2(1);',NL
rtn[28],←⊂' DO(ra+1,s1[i]=r.s[i])DO((I)rr-ra-1,s2[ra+i+1]=r.s[ra+i+1])',NL
rtn[28],←⊂' zv+=flat(iota(s1,s2));zv=zv%(tc*r.s[ra]);',NL
rtn[28],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',NL
rtn[28],←⊂' zv=flat(rv(zv+(tc*r.s[ra])*flat(iota(s2,s1))));}',NL
rtn[28],←⊂'DF(rot_f){B rr=rnk(r),lr=rnk(l);if(!rr){B lc=cnt(l);if(lc!=1&&lr)err(4);z=r;R;}',NL
rtn[28],←⊂' rot_c(z,l,r,e,scl(scl(rr-1)));}',NL
rtn[29],←⊂'NM(trn,"trn",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[29],←⊂'DEFN(trn)',NL
rtn[29],←⊂'MF(trn_f){B rr=rnk(r);if(rr<=1){z=r;R;}',NL
rtn[29],←⊂' A t(SHP(1,rr),seq((D)rr-1,0,-1));trn_c(z,t,r,e);}',NL
rtn[29],←⊂'DF(trn_f){B lr=rnk(l),rr=rnk(r);if(lr>1||cnt(l)!=rr)err(5);if(rr<=1){z=r;R;}',NL
rtn[29],←⊂' VEC<I> lv(rr);if(!isint(l))err(11);',NL
rtn[29],←⊂' CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(11))',NL
rtn[29],←⊂' DOB(rr,if(lv[i]<0||lv[i]>=rr)err(4))VEC<U8> f(rr,0);DOB(rr,f[lv[i]]=1)',NL
rtn[29],←⊂' U8 t=1;DOB(rr,if(t&&!f[i])t=0;else if(!t&&f[i])err(5))',NL
rtn[29],←⊂' if(t&&rr<=4){z.s=SHP(rr);DOB(rr,z.s[rr-lv[i]-1]=r.s[rr-i-1])',NL
rtn[29],←⊂'  switch(rr){case 0:case 1:z.v=r.v;R;}',NL
rtn[29],←⊂'  VEC<I> s(rr);DOB(rr,s[rr-lv[i]-1]=(I)(rr-i-1))',NL
rtn[29],←⊂'  arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(16))',NL
rtn[29],←⊂'  switch(rr){CS(2,z.v=flat(reorder(rv,s[0],s[1])))',NL
rtn[29],←⊂'   CS(3,z.v=flat(reorder(rv,s[0],s[1],s[2])))',NL
rtn[29],←⊂'   CS(4,z.v=flat(reorder(rv,s[0],s[1],s[2],s[3])))}}',NL
rtn[29],←⊂' else{B rk=0;DOB(rr,if(rk<lv[i])rk=lv[i])rk++;z.s=SHP(rk,LLONG_MAX);',NL
rtn[29],←⊂'  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;if(z.s[j]>r.s[k])z.s[j]=r.s[k])',NL
rtn[29],←⊂'  SHP zs(rk),rs(rr);',NL
rtn[29],←⊂'  B c=1;DOB(rk,zs[i]=c;c*=z.s[i])c=1;DOB(rr,rs[i]=c;c*=r.s[i])c=cnt(z);',NL
rtn[29],←⊂'  arr ix=iota(dim4(c),dim4(1),s32),jx=constant(0,dim4(c),s32);',NL
rtn[29],←⊂'  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;jx+=rs[k]*((ix/zs[j])%z.s[j]))',NL
rtn[29],←⊂'  CVSWITCH(r.v,err(6),z.v=v(jx),err(16))}}',NL
rtn[30],←⊂'NM(rtf,"rtf",0,0,DID,MFD,DFD,MAD,DAD)',NL
rtn[30],←⊂'DEFN(rtf)',NL
rtn[30],←⊂'ID(rtf,0,s32)',NL
rtn[30],←⊂'MF(rtf_f){if(!rnk(r)){z=r;R;}rot_c(z,r,e,scl(scl(0)));}',NL
rtn[30],←⊂'MA(rtf_f){rot_c(z,r,e,ax);}',NL
rtn[30],←⊂'DA(rtf_f){rot_c(z,l,r,e,ax);}',NL
rtn[30],←⊂'DF(rtf_f){if(!rnk(r)){B lc=cnt(l);if(lc!=1&&rnk(l))err(4);z=r;R;}',NL
rtn[30],←⊂' rot_c(z,l,r,e,scl(scl(0)));}',NL
rtn[31],←⊂'NM(mem,"mem",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[31],←⊂'DEFN(mem)',NL
rtn[31],←⊂'MF(mem_f){z.s=SHP(1,cnt(r));z.v=r.v;}',NL
rtn[31],←⊂'DF(mem_f){z.s=l.s;B lc=cnt(z);if(!lc){z.v=scl(0);R;}',NL
rtn[31],←⊂' if(!cnt(r)){arr zv(lc,b8);zv=0;z.v=zv;R;}',NL
rtn[31],←⊂' arr y;CVSWITCH(r.v,err(6),y=setUnique(v),err(16))',NL
rtn[31],←⊂' B rc=y.elements();',NL
rtn[31],←⊂' arr x;CVSWITCH(l.v,err(6),x=arr(v,lc,1),err(16))',NL
rtn[31],←⊂' y=arr(y,1,rc);',NL
rtn[31],←⊂' z.v=arr(anyTrue(tile(x,1,(I)rc)==tile(y,(I)lc,1),1),lc);}',NL
rtn[31],←⊂'',NL
rtn[32],←⊂'NM(dis,"dis",0,0,MT,MFD,DFD,MT,MT)',NL
rtn[32],←⊂'DEFN(dis)',NL
rtn[32],←⊂'MF(dis_f){CVSWITCH(r.v,err(6),z.s=eshp;z.v=v(0),z=v[0])}',NL
rtn[32],←⊂'DF(dis_f){if(!isint(l))err(11);if(rnk(l)>1)err(4);',NL
rtn[32],←⊂' B lc=cnt(l);if(!lc){z=r;R;}if(lc!=1||rnk(r)!=1)err(16);',NL
rtn[32],←⊂' I i;CVSWITCH(l.v,err(6),i=v.as(s32).scalar<I>(),err(16))',NL
rtn[32],←⊂' if(i<0||i>=cnt(r))err(3);',NL
rtn[32],←⊂' CVSWITCH(r.v,err(6),z.s=eshp;z.v=v(i),z=v[i])}',NL
rtn[33],←⊂'NM(eqv,"eqv",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[33],←⊂'DEFN(eqv)',NL
rtn[33],←⊂'MF(eqv_f){z.s=eshp;z.v=scl(rnk(r)!=0);}',NL
rtn[33],←⊂'I is_eqv(CA&l,CA&r){B lr=rnk(l),rr=rnk(r);if(lr!=rr)R 0;',NL
rtn[33],←⊂' DOB(lr,if(l.s[i]!=r.s[i])R 0)',NL
rtn[33],←⊂' I res=1;',NL
rtn[33],←⊂' std::visit(visitor{DVSTR(),',NL
rtn[33],←⊂'   [&](carr&lv,carr&rv){res=allTrue<I>(lv==rv);},',NL
rtn[33],←⊂'   [&](CVEC<A>&lv,carr&rv){res=0;},',NL
rtn[33],←⊂'   [&](carr&lv,CVEC<A>&rv){res=0;},',NL
rtn[33],←⊂'   [&](CVEC<A>&lv,CVEC<A>&rv){B c=cnt(l);',NL
rtn[33],←⊂'    DOB(c,if(!is_eqv(lv[i],rv[i])){res=0;R;})}},',NL
rtn[33],←⊂'  l.v,r.v);',NL
rtn[33],←⊂' R res;}',NL
rtn[33],←⊂'DF(eqv_f){z.s=eshp;z.v=scl(is_eqv(l,r));}',NL
rtn[34],←⊂'NM(nqv,"nqv",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[34],←⊂'DEFN(nqv)',NL
rtn[34],←⊂'MF(nqv_f){B rr=rnk(r);z.v=scl(rr?(I)r.s[rr-1]:1);z.s=eshp;}',NL
rtn[34],←⊂'DF(nqv_f){z.s=eshp;z.v=scl(!is_eqv(l,r));}',NL
rtn[35],←⊂'NM(rgt,"rgt",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[35],←⊂'DEFN(rgt)',NL
rtn[35],←⊂'MF(rgt_f){z=r;}',NL
rtn[35],←⊂'DF(rgt_f){z=r;}',NL
rtn[35],←⊂'',NL
rtn[36],←⊂'NM(lft,"lft",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[36],←⊂'DEFN(lft)',NL
rtn[36],←⊂'MF(lft_f){z=r;}',NL
rtn[36],←⊂'DF(lft_f){z=l;}',NL
rtn[36],←⊂'',NL
rtn[37],←⊂'NM(enc,"enc",0,0,DID,MT ,DFD,MT ,MT )',NL
rtn[37],←⊂'DEFN(enc)',NL
rtn[37],←⊂'ID(enc,0,s32)',NL
rtn[37],←⊂'DF(enc_f){B rr=rnk(r),lr=rnk(l),rk=rr+lr;if(rk>4)err(16);',NL
rtn[37],←⊂' SHP sp(rk);DOB(rr,sp[i]=r.s[i])DOB(lr,sp[i+rr]=l.s[i])',NL
rtn[37],←⊂' if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}',NL
rtn[37],←⊂' dim4 lt(1),rt(1);DO((I)rk,lt[i]=rt[i]=sp[i])I k=lr?(I)lr-1:0;',NL
rtn[37],←⊂' DO((I)rr,rt[i]=1)DO((I)lr,lt[i+(I)rr]=1)',NL
rtn[37],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=v,err(11))',NL
rtn[37],←⊂' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',NL
rtn[37],←⊂' rv=tile(unrav(rv,r.s),rt);z.s=sp;',NL
rtn[37],←⊂' arr dv=flip(scan(flip(unrav(lv.as(s64),l.s),k),k,AF_BINARY_MUL),k);',NL
rtn[37],←⊂' lv=tile(arr(dv,rt),lt);IDX x[4];x[k]=0;',NL
rtn[37],←⊂' dv(x[0],x[1],x[2],x[3])=1;I s[]={0,0,0,0};s[k]=-1;',NL
rtn[37],←⊂' dv=shift(dv,s[0],s[1],s[2],s[3]);dv=tile(arr(dv,rt),lt);',NL
rtn[37],←⊂' arr ix=where(lv);z.v=arr();arr&zv=std::get<arr>(z.v);',NL
rtn[37],←⊂' zv=rv.as(s32);',NL
rtn[37],←⊂' zv=(rv-lv*floor(rv.as(f64)/(lv+(lv==0)))).as(s32);',NL
rtn[37],←⊂' ix=where(dv);zv*=dv!=0;zv(ix)=floor(zv(ix).as(f64)/dv(ix)).as(s32);',NL
rtn[37],←⊂' zv=flat(zv);}',NL
rtn[38],←⊂'NM(dec,"dec",0,0,MT,MT,DFD,MT,MT)',NL
rtn[38],←⊂'DEFN(dec)',NL
rtn[38],←⊂'DF(dec_f){B rr=rnk(r),lr=rnk(l),ra=rr?rr-1:0,la=lr?lr-1:0;z.s=SHP(ra+la);',NL
rtn[38],←⊂' if(rr&&lr)if(l.s[0]!=1&&l.s[0]!=r.s[ra]&&r.s[ra]!=1)err(5);',NL
rtn[38],←⊂' DOB(ra,z.s[i]=r.s[i])DOB(la,z.s[i+ra]=l.s[i+1])',NL
rtn[38],←⊂' if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[38],←⊂' if(!cnt(r)||!cnt(l)){z.v=constant(0,cnt(z),s32);R;}',NL
rtn[38],←⊂' B lc=lr?l.s[0]:1;',NL
rtn[38],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=v,err(11))',NL
rtn[38],←⊂' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',NL
rtn[38],←⊂' arr x=unrav(lv,l.s);if(lc==1){lc=r.s[ra];x=tile(x,(I)lc);}',NL
rtn[38],←⊂' x=flip(scan(x,0,AF_BINARY_MUL,false),0);',NL
rtn[38],←⊂' x=arr(x,lc,x.elements()/lc).as(f64);',NL
rtn[38],←⊂' arr y=arr(rv,cnt(r)/r.s[ra],r.s[ra]).as(f64);',NL
rtn[38],←⊂' z.v=flat(matmul(r.s[ra]==1?tile(y,1,(I)lc):y,x));}',NL
rtn[39],←⊂'NM(red,"red",0,0,DID,MT ,DFD,MT ,DAD)',NL
rtn[39],←⊂'ID(red,1,s32)',NL
rtn[39],←⊂'DEFN(red)',NL
rtn[39],←⊂'OM(red,"red",0,0,MFD,DFD,MAD,DAD)',NL
rtn[39],←⊂'DA(red_f){B ar=rnk(ax),lr=rnk(l),rr=rnk(r),zr;if(lr>4||rr>4)err(16);',NL
rtn[39],←⊂' if(ar>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',NL
rtn[39],←⊂' I axv;CVSWITCH(ax.v,err(6),axv=v.as(s32).scalar<I>(),err(11))',NL
rtn[39],←⊂' if(axv<0)err(11);if(axv>=rr)err(4);',NL
rtn[39],←⊂' dim4 zs(1),ls(1),rs(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',NL
rtn[39],←⊂' if(lr>1)err(4);axv=(I)rr-axv-1;B lc=cnt(l),rsx=rs[axv];',NL
rtn[39],←⊂' if(lr!=0&&lc!=1&&rr!=0&&rsx!=1&&lc!=rsx)err(5);',NL
rtn[39],←⊂' arr lv;CVSWITCH(l.v,err(6),lv=moddims(v,ls),err(11))',NL
rtn[39],←⊂' arr x=lc==1?tile(lv,(I)rsx):lv;B zc=sum<B>(abs(x));',NL
rtn[39],←⊂' zr=rr?rr:1;zs=rs;zs[axv]=zc;z.s=SHP(zr);DO((I)zr,z.s[i]=zs[i])',NL
rtn[39],←⊂' if(!cnt(z)){z.v=scl(0);R;}arr w=where(x).as(s32);',NL
rtn[39],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[39],←⊂'  ,arr rv=moddims(v,rs);arr y=rsx==1?tile(rv,(I)lc):rv;IDX ix[4];',NL
rtn[39],←⊂'   z.v=arr();arr&zv=std::get<arr>(z.v);',NL
rtn[39],←⊂'   if(zc==w.elements()){ix[axv]=w;zv=y(ix[0],ix[1],ix[2],ix[3]);',NL
rtn[39],←⊂'    if(zc==sum<B>(x(w)))R;dim4 sp(zs);sp[axv]=1;',NL
rtn[39],←⊂'    zv*=tile(x(w)>0,(I)sp[0],(I)sp[1],(I)sp[2],(I)sp[3]);zv=flat(zv);R;}',NL
rtn[39],←⊂'   arr s=(!sign(x(w))).as(s32);arr i=shift(accum(abs(x(w))),1);',NL
rtn[39],←⊂'   arr d=shift(w,1);arr t=shift(s,1);arr q(zc,s32);arr u(zc,s32);',NL
rtn[39],←⊂'   i(0)=0;d(0)=0;q=0;u=0;t(0)=0;q(i)=w-d;u(i)=s-t;ix[axv]=accum(q);',NL
rtn[39],←⊂'   zv=y(ix[0],ix[1],ix[2],ix[3]);',NL
rtn[39],←⊂'   dim4 s1(1);dim4 s2(zs);s1[axv]=zc;s2[axv]=1;u=arr(accum(u),s1);',NL
rtn[39],←⊂'   zv*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);zv=flat(zv)',NL
rtn[39],←⊂'  ,err(16))}',NL
rtn[39],←⊂'DF(red_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(rnk(x)-1)));}',NL
rtn[39],←⊂'MA(red_o){B ar=rnk(ax),rr=rnk(r);if(rr>4)err(16);',NL
rtn[39],←⊂' if(ar>1)err(4);if(cnt(ax)!=1)err(5);if(!isint(ax))err(11);',NL
rtn[39],←⊂' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',NL
rtn[39],←⊂' if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;I rc=(I)r.s[av];',NL
rtn[39],←⊂' z.s=SHP(rr-1);I ib=isbool(r);',NL
rtn[39],←⊂' DO(av,z.s[i]=r.s[i])DO((I)rr-av-1,z.s[av+i]=r.s[av+i+1])',NL
rtn[39],←⊂' if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[39],←⊂' if(!rc){z.v=ll.id(z.s);R;}',NL
rtn[39],←⊂' if(1==rc){z.v=r.v;R;}',NL
rtn[39],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[39],←⊂'  ,arr rv=axis(v,r.s,av);',NL
rtn[39],←⊂'   if("rgt"==ll.nm){z.v=flat(rv(span,rc-1,span));R;}',NL
rtn[39],←⊂'   if("lft"==ll.nm){z.v=flat(rv(span,0,span));R;}',NL
rtn[39],←⊂'   if("add"==ll.nm&&ib){z.v=flat(count(rv,1).as(s32));R;}',NL
rtn[39],←⊂'   if("add"==ll.nm){z.v=flat(sum(rv.as(f64),1));R;}',NL
rtn[39],←⊂'   if("mul"==ll.nm){z.v=flat(product(rv.as(f64),1));R;}',NL
rtn[39],←⊂'   if("min"==ll.nm){z.v=flat(min(rv,1));R;}',NL
rtn[39],←⊂'   if("max"==ll.nm){z.v=flat(max(rv,1));R;}',NL
rtn[39],←⊂'   if("and"==ll.nm&&ib){z.v=flat(allTrue(rv,1));R;}',NL
rtn[39],←⊂'   if("lor"==ll.nm&&ib){z.v=flat(anyTrue(rv,1));R;}',NL
rtn[39],←⊂'   if("neq"==ll.nm&&ib){z.v=flat((1&sum(rv,1)).as(b8));R;}',NL
rtn[39],←⊂'   map_o mfn_c(llp);dim4 zs;DO((I)rnk(z),zs[i]=z.s[i])',NL
rtn[39],←⊂'   z.v=flat(rv(span,rc-1,span));',NL
rtn[39],←⊂'   DO(rc-1,mfn_c(z,A(z.s,flat(rv(span,rc-i-2,span))),z,e))',NL
rtn[39],←⊂'  ,B zc=cnt(z);z.v=VEC<A>(cnt(z));VEC<A>&zv=std::get<VEC<A>>(z.v);',NL
rtn[39],←⊂'   B bs=1;DOB(av,bs*=z.s[i])B as=1;DOB(rr-av-1,as*=z.s[av+i])',NL
rtn[39],←⊂'   B ms=bs*rc;B mi=rc*bs-bs;',NL
rtn[39],←⊂'   if("rgt"==ll.nm){DOB(as,B j=i;DOB(bs,zv[j*bs+i]=v[j*ms+mi+i]))R;}',NL
rtn[39],←⊂'   if("lft"==ll.nm){DOB(as,B j=i;DOB(bs,zv[j*bs+i]=v[j*ms+i]))R;}',NL
rtn[39],←⊂'   DOB(as,B k=i;DOB(bs,zv[k*bs+i]=v[k*ms+mi+i]))',NL
rtn[39],←⊂'   DOB(rc-1,B j=(rc-i-2)*bs;',NL
rtn[39],←⊂'    DOB(as,B k=i;DOB(bs,A&zvi=zv[k*bs+i];ll(zvi,v[k*ms+j+i],zvi,e)))))}',NL
rtn[39],←⊂'MF(red_o){A x=r;if(!rnk(r))cat_c(x,r,e);this_c(z,x,e,scl(scl(rnk(x)-1)));}',NL
rtn[39],←⊂'DA(red_o){B ar=rnk(ax),lr=rnk(l),rr=rnk(r);if(lr>4||rr>4)err(16);',NL
rtn[39],←⊂' if(ar>1)err(4);if(cnt(ax)!=1)err(5);if(!isint(ax))err(11);',NL
rtn[39],←⊂' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',NL
rtn[39],←⊂' if(av<0)err(11);if(av>=rr)err(4);av=(I)rr-av-1;',NL
rtn[39],←⊂' if(lr>1)err(4);if(cnt(l)!=1)err(5);if(!isint(l))err(11);',NL
rtn[39],←⊂' I lv;CVSWITCH(l.v,err(6),lv=v.as(s32).scalar<I>(),err(11))',NL
rtn[39],←⊂' I rc=(I)r.s[av]+1;if(rc<lv)err(5);rc=(I)(rc-abs(lv));',NL
rtn[39],←⊂' A t(r.s,scl(0));t.s[av]=rc;',NL
rtn[39],←⊂' if(!cnt(t)){z=t;R;}if(!lv){t.v=ll.id(t.s);z=t;R;}',NL
rtn[39],←⊂' seq rng(rc);IDX x[4];map_o mfn_c(llp);',NL
rtn[39],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[39],←⊂'  ,arr rv=unrav(v,r.s);',NL
rtn[39],←⊂'   if(lv>=0){x[av]=rng+((D)lv-1);t.v=flat(rv(x[0],x[1],x[2],x[3]));',NL
rtn[39],←⊂'    DO(lv-1,x[av]=rng+(D)(lv-i-2);',NL
rtn[39],←⊂'     mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))',NL
rtn[39],←⊂'   }else{x[av]=rng;t.v=flat(rv(x[0],x[1],x[2],x[3]));',NL
rtn[39],←⊂'    DO(abs(lv)-1,x[av]=rng+(D)(i+1);',NL
rtn[39],←⊂'     mfn_c(t,A(t.s,flat(rv(x[0],x[1],x[2],x[3]))),t,e))}',NL
rtn[39],←⊂'   z=t;',NL
rtn[39],←⊂'  ,err(16))}',NL
rtn[39],←⊂'DF(red_o){if(!rnk(r))err(4);',NL
rtn[39],←⊂' red_o mfn_c(llp);mfn_c(z,l,r,e,scl(scl((I)rnk(r)-1)));}',NL
rtn[40],←⊂'NM(rdf,"rdf",0,0,DID,MT ,DFD,MT,DAD)',NL
rtn[40],←⊂'ID(rdf,1,s32)',NL
rtn[40],←⊂'OM(rdf,"rdf",0,0,MFD,DFD,MAD,DAD)',NL
rtn[40],←⊂'DEFN(rdf)',NL
rtn[40],←⊂'DA(rdf_f){red_c(z,l,r,e,ax);}',NL
rtn[40],←⊂'DF(rdf_f){A x=r;if(!rnk(r))cat_c(x,r,e);red_c(z,l,x,e,scl(scl(0)));}',NL
rtn[40],←⊂'MA(rdf_o){red_o mfn_c(llp);mfn_c(z,r,e,ax);}',NL
rtn[40],←⊂'MF(rdf_o){A x=r;if(!rnk(r))cat_c(x,r,e);this_c(z,x,e,scl(scl(0)));}',NL
rtn[40],←⊂'DA(rdf_o){red_o mfn_c(llp);mfn_c(z,l,r,e,ax);}',NL
rtn[40],←⊂'DF(rdf_o){if(!rnk(r))err(4);red_o mfn_c(llp);mfn_c(z,l,r,e,scl(scl(0)));}',NL
rtn[41],←⊂'NM(scn,"scn",0,0,DID,MT ,DFD,MT ,DAD)',NL
rtn[41],←⊂'DEFN(scn)',NL
rtn[41],←⊂'ID(scn,1,s32)',NL
rtn[41],←⊂'OM(scn,"scn",1,1,MFD,MT,MAD,MT )',NL
rtn[41],←⊂'DA(scn_f){if(rnk(ax)>1||cnt(ax)!=1)err(5);if(!isint(ax))err(11);',NL
rtn[41],←⊂' B rr=rnk(r),lr=rnk(l);',NL
rtn[41],←⊂' I ra;CVSWITCH(ax.v,err(6),ra=v.as(s32).scalar<I>(),err(11))',NL
rtn[41],←⊂' if(ra<0)err(11);if(ra>=rr)err(4);if(lr>1)err(4);ra=(I)rr-ra-1;',NL
rtn[41],←⊂' arr lv;CVSWITCH(l.v,err(6),lv=v,err(11))',NL
rtn[41],←⊂' if(r.s[ra]!=1&&r.s[ra]!=sum<I>(lv>0))err(5);',NL
rtn[41],←⊂' arr ca=max(1,abs(lv)).as(s32);I c=sum<I>(ca);',NL
rtn[41],←⊂' if(!cnt(l))c=0;z.s=r.s;z.s[ra]=c;B zc=cnt(z);if(!zc){z.v=scl(0);R;}',NL
rtn[41],←⊂' arr pw=0<lv,pa=pw*lv;I pc=sum<I>(pa);if(!pc){z.v=scl(0);R;}',NL
rtn[41],←⊂' pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);',NL
rtn[41],←⊂' arr si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;',NL
rtn[41],←⊂' arr ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);',NL
rtn[41],←⊂' ti=scanByKey(si,ti);',NL
rtn[41],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[41],←⊂'  ,arr zv(zc,v.type());zv=0;zv=axis(zv,z.s,ra);',NL
rtn[41],←⊂'   zv(span,ti,span)=axis(v,r.s,ra)(span,si,span);z.v=flat(zv)',NL
rtn[41],←⊂'  ,err(16))}',NL
rtn[41],←⊂'DF(scn_f){A x=r;if(!rnk(r))cat_c(x,r,e);',NL
rtn[41],←⊂' scn_c(z,l,x,e,scl(scl(rnk(x)-1)));}',NL
rtn[41],←⊂'',NL
rtn[41],←⊂'MA(scn_o){if(rnk(ax)>1)err(4);if(cnt(ax)!=1)err(5);',NL
rtn[41],←⊂' if(!isint(ax))err(11);',NL
rtn[41],←⊂' I av;CVSWITCH(ax.v,err(6),av=v.as(s32).scalar<I>(),err(11))',NL
rtn[41],←⊂' if(av<0)err(11);B rr=rnk(r);if(av>=rr)err(4);av=(I)rr-av-1;z.s=r.s;',NL
rtn[41],←⊂' I rc=(I)r.s[av];if(rc==1){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[41],←⊂' I ib=isbool(r);arr rv;CVSWITCH(r.v,err(6),rv=axis(v,r.s,av),err(16))',NL
rtn[41],←⊂' if("add"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_ADD));R;}',NL
rtn[41],←⊂' if("mul"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MUL));R;}',NL
rtn[41],←⊂' if("min"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MIN));R;}',NL
rtn[41],←⊂' if("max"==ll.nm){z.v=flat(scan(rv.as(f64),1,AF_BINARY_MAX));R;}',NL
rtn[41],←⊂' if("and"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MIN));R;}',NL
rtn[41],←⊂' if("lor"==ll.nm&&ib){z.v=flat(scan(rv,1,AF_BINARY_MAX));R;}',NL
rtn[41],←⊂' map_o mfn_c(llp);B tr=rnk(z)-1;SHP ts(tr,1);',NL
rtn[41],←⊂' DOB(av,ts[i]=r.s[i])DOB(tr-av,ts[av+i]=r.s[av+i+1])',NL
rtn[41],←⊂' rv=rv.as(f64);arr zv(cnt(z),f64);zv=axis(zv,z.s,av);',NL
rtn[41],←⊂' DO(rc,arr rvi=rv(span,i,span);dim4 rvs=rvi.dims();',NL
rtn[41],←⊂'  A t(ts,flat(rv(span,i,span)));I c=i;',NL
rtn[41],←⊂'  DO(c,A y(ts,flat(rv(span,c-i-1,span)));mfn_c(t,y,t,e))',NL
rtn[41],←⊂'  CVSWITCH(t.v,err(6),zv(span,i,span)=moddims(v,rvs),err(16)))',NL
rtn[41],←⊂' z.v=flat(zv);}',NL
rtn[41],←⊂'MF(scn_o){B rr=rnk(r);if(!rr){z=r;R;}',NL
rtn[41],←⊂' scn_o mfn_c(llp);mfn_c(z,r,e,scl(scl(rr-1)));}',NL
rtn[42],←⊂'NM(scf,"scf",0,0,DID,MT ,DFD,MT ,DAD)',NL
rtn[42],←⊂'DEFN(scf)',NL
rtn[42],←⊂'ID(scf,1,s32)',NL
rtn[42],←⊂'OM(scf,"scf",1,1,MFD,MT,MAD,MT )',NL
rtn[42],←⊂'DA(scf_f){scn_c(z,l,r,e,ax);}',NL
rtn[42],←⊂'DF(scf_f){A x=r;if(!rnk(x))cat_c(x,r,e);scn_c(z,l,x,e,scl(scl(0)));}',NL
rtn[42],←⊂'',NL
rtn[42],←⊂'MA(scf_o){scn_o mfn_c(llp);mfn_c(z,r,e,ax);}',NL
rtn[42],←⊂'MF(scf_o){if(!rnk(r)){z=r;R;}scn_o mfn_c(llp);mfn_c(z,r,e,scl(scl(0)));}',NL
rtn[43],←⊂'NM(rol,"rol",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[43],←⊂'DEFN(rol)',NL
rtn[43],←⊂'SMF(rol,arr rnd=randu(rv.dims(),f64);z.v=(0==rv)*rnd+trunc(rv*rnd))',NL
rtn[43],←⊂'DF(rol_f){if(cnt(r)!=1||cnt(l)!=1)err(5);',NL
rtn[43],←⊂' D lv;CVSWITCH(l.v,err(6),lv=v.as(f64).scalar<D>(),err(11))',NL
rtn[43],←⊂' D rv;CVSWITCH(r.v,err(6),rv=v.as(f64).scalar<D>(),err(11))',NL
rtn[43],←⊂' if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);',NL
rtn[43],←⊂' I s=(I)lv;I t=(I)rv;z.s=SHP(1,s);if(!s){z.v=scl(0);R;}',NL
rtn[43],←⊂' VEC<I> g(t);VEC<I> d(t);',NL
rtn[43],←⊂' ((1+range(t))*randu(t)).as(s32).host(g.data());',NL
rtn[43],←⊂' DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=arr(s,d.data());}',NL
rtn[44],←⊂'NM(tke,"tke",0,0,MT ,MFD,DFD,MAD,DAD)',NL
rtn[44],←⊂'DEFN(tke)',NL
rtn[44],←⊂'MF(tke_f){',NL
rtn[44],←⊂' CVSWITCH(r.v,err(6),z=r,',NL
rtn[44],←⊂'  B rc=cnt(r);if(!rc&&!v.size())err(99,L"Missing prototype");',NL
rtn[44],←⊂'  B rr=rnk(r);B mr=rnk(v[0]);U8 speq=1;U8 nv=0;',NL
rtn[44],←⊂'  DOB(v.size(),B nr=rnk(v[i]);if(nr>mr){mr=nr;speq=0;})',NL
rtn[44],←⊂'  DOB(v.size(),CVSWITCH(v[i].v,err(6),,nv=1))',NL
rtn[44],←⊂'  A x(mr+rr);DOB(rr,x.s[mr+rr-i-1]=r.s[rr-i-1])',NL
rtn[44],←⊂'  dtype tp=b8;if(!nv)tp=mxt(b8,r);',NL
rtn[44],←⊂'  if(!mr){',NL
rtn[44],←⊂'   if(nv){x.v=VEC<A>(rc);VEC<A>&xv=std::get<VEC<A>>(x.v);',NL
rtn[44],←⊂'    DOB(rc,CVSWITCH(v[i].v,err(6),xv[i]=scl(v),xv[i]=v[0]))}',NL
rtn[44],←⊂'   if(!nv){x.v=arr(rc,tp);arr&xv=std::get<arr>(x.v);',NL
rtn[44],←⊂'    DOB(rc,CVSWITCH(v[i].v,err(6),xv((I)i)=v(0).as(tp),err(99)))}',NL
rtn[44],←⊂'   z=x;R;}',NL
rtn[44],←⊂'  DOB(mr,x.s[i]=0)B rk=rnk(v[0]);DOB(rk,x.s[mr-i-1]=v[0].s[rk-i-1])',NL
rtn[44],←⊂'  DOB(rc,A vi=v[i];rk=rnk(vi);',NL
rtn[44],←⊂'   DOB(rk,B j=mr-i-1;B k=rk-i-1;if(x.s[j]!=vi.s[k])speq=0;',NL
rtn[44],←⊂'    if(x.s[j]<vi.s[k])x.s[j]=vi.s[k]))',NL
rtn[44],←⊂'  B bc=1;DOB(mr,bc*=x.s[i])seq bx((D)bc);B xc=rc*bc;',NL
rtn[44],←⊂'  if(!speq)err(16);',NL
rtn[44],←⊂'  if(nv)err(16);',NL
rtn[44],←⊂'  if(!nv&&!xc){x.v=scl(0);}',NL
rtn[44],←⊂'  if(!nv&&xc){x.v=arr(xc,tp);arr&xv=std::get<arr>(x.v);',NL
rtn[44],←⊂'   DOB(rc,CVSWITCH(v[i].v,err(6),xv(bx+(D)i*bc)=v.as(tp),err(99)))}',NL
rtn[44],←⊂'  z=x)}',NL
rtn[44],←⊂'MA(tke_f){err(16);}',NL
rtn[44],←⊂'DA(tke_f){B c=cnt(l),ac=cnt(ax),axr=rnk(ax),lr=rnk(l),rr=rnk(r);',NL
rtn[44],←⊂' if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);',NL
rtn[44],←⊂' VEC<I> av(ac),m(rr,0);',NL
rtn[44],←⊂' if(ac)CVSWITCH(ax.v,err(6),v.as(s32).host(av.data()),err(11))',NL
rtn[44],←⊂' DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))',NL
rtn[44],←⊂' DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',NL
rtn[44],←⊂' if(!c){z=r;R;}if(!isint(l))err(11);',NL
rtn[44],←⊂' VEC<I> lv(c);CVSWITCH(l.v,err(6),v.as(s32).host(lv.data()),err(11))',NL
rtn[44],←⊂' seq it[4],ix[4];z.s=r.s;if(rr>4)err(16);',NL
rtn[44],←⊂' DOB(c,{U j=(U)rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=a;',NL
rtn[44],←⊂'  if(a>r.s[j])ix[j]=seq((D)r.s[j]);',NL
rtn[44],←⊂'  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);',NL
rtn[44],←⊂'  else ix[j]=seq(a);',NL
rtn[44],←⊂'  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})',NL
rtn[44],←⊂' B zc=cnt(z);if(!zc){z.v=scl(0);R;}',NL
rtn[44],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[44],←⊂'  ,z.v=arr(zc,v.type());arr&zv=std::get<arr>(z.v);zv=0;',NL
rtn[44],←⊂'   arr rv=unrav(v,r.s);zv=unrav(zv,z.s);',NL
rtn[44],←⊂'   zv(it[0],it[1],it[2],it[3])=rv(ix[0],ix[1],ix[2],ix[3]);',NL
rtn[44],←⊂'   zv=flat(zv)',NL
rtn[44],←⊂'  ,err(16))}',NL
rtn[44],←⊂'DF(tke_f){I c=(I)cnt(l);if(c>4)err(16);',NL
rtn[44],←⊂' A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}',NL
rtn[44],←⊂' A ax;iot_c(ax,scl(scl(c)),e);tke_c(z,l,nr,e,ax);}',NL
rtn[45],←⊂'NM(drp,"drp",0,0,MT ,MFD,DFD,MAD,DAD)',NL
rtn[45],←⊂'DEFN(drp)',NL
rtn[45],←⊂'MF(drp_f){if(rnk(r))err(16);z=r;}',NL
rtn[45],←⊂'MA(drp_f){err(16);}',NL
rtn[45],←⊂'DA(drp_f){B c=cnt(l),ac=cnt(ax),rr=rnk(r),lr=rnk(l),axr=rnk(ax);',NL
rtn[45],←⊂' if(axr>1||lr>1)err(4);if(ac!=c)err(5);if(c>4)err(16);if(!isint(ax))err(11);',NL
rtn[45],←⊂' I m[4]={0,0,0,0},av[4];CVSWITCH(ax.v,err(6),v.as(s32).host(av),err(11))',NL
rtn[45],←⊂' DOB(ac,if(av[i]<0)err(11);if(av[i]>=rr)err(4))',NL
rtn[45],←⊂' DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',NL
rtn[45],←⊂' if(!c){z=r;R;}if(!isint(l))err(11);',NL
rtn[45],←⊂' I lv[4];CVSWITCH(l.v,err(6),v.as(s32).host(lv),err(11))',NL
rtn[45],←⊂' seq it[4],ix[4];z.s=r.s;',NL
rtn[45],←⊂' DO((I)c,{B j=rr-av[i]-1;I a=std::abs(lv[i]);z.s[j]=r.s[j]-a;',NL
rtn[45],←⊂'  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}',NL
rtn[45],←⊂'  else if(lv[i]<0){ix[j]=seq((D)z.s[j]);it[j]=ix[j];}',NL
rtn[45],←⊂'  else{ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})',NL
rtn[45],←⊂' if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[45],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[45],←⊂'  ,arr tv(cnt(z),v.type());tv=0;tv=unrav(tv,z.s);',NL
rtn[45],←⊂'   tv(it[0],it[1],it[2],it[3])=unrav(v,r.s)(ix[0],ix[1],ix[2],ix[3]);',NL
rtn[45],←⊂'   z.v=flat(tv)',NL
rtn[45],←⊂'  ,z.v=VEC<A>(cnt(z),scl(scl(0)));VEC<A>&zv=std::get<VEC<A>>(z.v);',NL
rtn[45],←⊂'   if(rr!=1)err(16);B shft=0;if(lv[0]>=0)shft=lv[0];',NL
rtn[45],←⊂'   DOB(z.s[0],zv[i]=v[i+shft]))}',NL
rtn[45],←⊂'DF(drp_f){B c=cnt(l);if(c>4)err(16);',NL
rtn[45],←⊂' A nr=r;if(!rnk(nr)){nr.s=SHP(c,1);}',NL
rtn[45],←⊂' A ax;iot_c(ax,scl(scl(c)),e);drp_c(z,l,nr,e,ax);}',NL
rtn[46],←⊂'OM(map,"map",1,1,MFD,DFD,MT ,MT )',NL
rtn[46],←⊂'MF(map_o){if(scm(ll)){ll(z,r,e);R;}',NL
rtn[46],←⊂' if("par"==ll.nm&&std::holds_alternative<arr>(r.v)){z=r;R;}',NL
rtn[46],←⊂' z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}',NL
rtn[46],←⊂' z.v=VEC<A>(c);VEC<A>&zv=std::get<VEC<A>>(z.v);',NL
rtn[46],←⊂' CVSWITCH(r.v,err(6),DOB(c,ll(zv[i],scl(v((I)i)),e)),DOB(c,ll(zv[i],v[i],e)))',NL
rtn[46],←⊂' coal(z);}',NL
rtn[46],←⊂'DF(map_o){if(scd(ll)){ll(z,l,r,e);R;}B lr=rnk(l),rr=rnk(r);',NL
rtn[46],←⊂' A rv,lv,a,b;cat_c(rv,r,e);cat_c(lv,l,e);',NL
rtn[46],←⊂' if((lr==rr&&l.s==r.s)||!lr){z.s=r.s;}',NL
rtn[46],←⊂' else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);',NL
rtn[46],←⊂' else if(l.s!=r.s)err(5);else err(99);',NL
rtn[46],←⊂' I c=(I)cnt(z);if(!c){z.v=scl(0);R;}',NL
rtn[46],←⊂' z.v=VEC<A>(c);VEC<A>&v=std::get<VEC<A>>(z.v);',NL
rtn[46],←⊂' if(lr==rr){',NL
rtn[46],←⊂'  DOB(c,A ix=scl(scl(i));dis_c(a,ix,lv,e);dis_c(b,ix,rv,e);ll(v[i],a,b,e))}',NL
rtn[46],←⊂' else if(!lr){',NL
rtn[46],←⊂'  dis_c(a,scl(scl(0)),lv,e);DOB(c,dis_c(b,scl(scl(i)),rv,e);ll(v[i],a,b,e))}',NL
rtn[46],←⊂' else if(!rr){',NL
rtn[46],←⊂'  dis_c(b,scl(scl(0)),rv,e);DOB(c,dis_c(a,scl(scl(i)),lv,e);ll(v[i],a,b,e))}',NL
rtn[46],←⊂' coal(z);}',NL
rtn[47],←⊂'OM(com,"com",scm(l),scd(l),MFD,DFD,MT ,MT )',NL
rtn[47],←⊂'MF(com_o){ll(z,r,r,e);}DF(com_o){ll(z,r,l,e);}',NL
rtn[47],←⊂'',NL
rtn[48],←⊂'OD(dot,"dot",0,0,MT,DFD,MT ,MT )',NL
rtn[48],←⊂'DF(dot_o){B lr=rnk(l),rrk=rnk(r),ra=rrk?rrk-1:0,la=lr?lr-1:0;',NL
rtn[48],←⊂' if(rrk&&lr&&l.s[0]!=r.s[ra])err(5);',NL
rtn[48],←⊂' A t(la+ra,scl(0));DOB(ra,t.s[i]=r.s[i])DOB(la,t.s[i+ra]=l.s[i+1])',NL
rtn[48],←⊂' if(!cnt(t)){z=t;R;}if((lr&&!l.s[0])||(rrk&&!r.s[ra])){t.v=ll.id(t.s);z=t;R;}',NL
rtn[48],←⊂' B c=lr?l.s[0]:rrk?r.s[ra]:1;',NL
rtn[48],←⊂' std::visit(visitor{DVSTR(),',NL
rtn[48],←⊂'   [&](carr&lv,carr&rv){',NL
rtn[48],←⊂'    arr x=table(lv,l.s,1),y=table(rv,r.s,ra);',NL
rtn[48],←⊂'    if(!lr||1==l.s[0])x=tile(x,(U)c,1);if(!rrk||1==r.s[ra])y=tile(y,1,(U)c);',NL
rtn[48],←⊂'    if("add"==ll.nm&&"mul"==rr.nm){',NL
rtn[48],←⊂'     t.v=flat(matmul(y.as(f64),x.as(f64)));z=t;R;}',NL
rtn[48],←⊂'    if(isbool(x)&&isbool(y)&&"neq"==ll.nm&&"and"==rr.nm){',NL
rtn[48],←⊂'     t.v=flat((1&matmul(y.as(f32),x.as(f32)).as(s16)).as(b8));z=t;R;}',NL
rtn[48],←⊂'    B rc=1,lc=1;if(rrk)rc=cnt(r)/r.s[ra];if(lr)lc=cnt(l)/l.s[0];',NL
rtn[48],←⊂'    x=tile(arr(x,c,1,lc),1,(U)rc,1);y=tile(y.T(),1,1,(U)lc);',NL
rtn[48],←⊂'    A X(SHP{c,rc,lc},flat(x.as(f64)));A Y(SHP{c,rc,lc},flat(y.as(f64)));',NL
rtn[48],←⊂'    map_o mfn_c(rrp);red_o rfn_c(llp);mfn_c(X,X,Y,e);rfn_c(X,X,e);',NL
rtn[48],←⊂'    t.v=X.v;z=t;},',NL
rtn[48],←⊂'   [&](CVEC<A>&lv,carr&rv){err(16);},',NL
rtn[48],←⊂'   [&](carr&lv,CVEC<A>&rv){err(16);},',NL
rtn[48],←⊂'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);}},',NL
rtn[48],←⊂'  l.v,r.v);}',NL
rtn[49],←⊂'OD(rnk,"rnk",scm(l),0,MFD,DFD,MT ,MT )',NL
rtn[49],←⊂'MF(rnk_o){if(cnt(ww)!=1)err(4);B cr=geti(ww);',NL
rtn[49],←⊂' B rr=rnk(r);if(scm(ll)||cr>=rr){ll(z,r,e);R;}',NL
rtn[49],←⊂' if(cr<=-rr)cr=0;if(cr<0)cr=rr+cr;B dr=rr-cr;',NL
rtn[49],←⊂' A x(cr+1,r.v);DOB(cr,x.s[i]=r.s[i])DOB(dr,x.s[cr]*=r.s[rr-i-1])',NL
rtn[49],←⊂' B dc=x.s[cr];A y(dr,VEC<A>(dc?dc:1));DOB(dr,y.s[dr-i-1]=r.s[rr-i-1])',NL
rtn[49],←⊂' VEC<A>&yv=std::get<VEC<A>>(y.v);',NL
rtn[49],←⊂' if(!dc)tke_c(x,scl(scl(1)),x,e);',NL
rtn[49],←⊂' DOB(dc?dc:1,A t;sqd_c(t,scl(scl(i)),x,e);ll(yv[i],t,e))',NL
rtn[49],←⊂' if(!dc)y=proto(y);tke_c(z,y,e);}',NL
rtn[49],←⊂'DF(rnk_o){I rr=(I)rnk(r),lr=(I)rnk(l),cl,cr,dl,dr;dim4 sl(1),sr(1);',NL
rtn[49],←⊂' arr wwv;CVSWITCH(ww.v,err(6),wwv=v.as(s32),err(11))',NL
rtn[49],←⊂' switch(cnt(ww)){',NL
rtn[49],←⊂'  CS(1,cl=cr=wwv.scalar<I>())',NL
rtn[49],←⊂'  CS(2,cl=wwv.scalar<I>();cr=wwv(1).scalar<I>())',NL
rtn[49],←⊂'  default:err(4);}',NL
rtn[49],←⊂' if(cl>lr)cl=lr;if(cr>rr)cr=rr;if(cl<-lr)cl=0;if(cr<-rr)cr=0;',NL
rtn[49],←⊂' if(cl<0)cl=lr+cl;if(cr<0)cr=rr+cr;if(cr>3||cl>3)err(10);',NL
rtn[49],←⊂' dl=lr-cl;dr=rr-cr;if(dl!=dr&&dl&&dr)err(4);',NL
rtn[49],←⊂' if(dl==dr)DO(dr,if(l.s[i+cl]!=r.s[i+cr])err(5))',NL
rtn[49],←⊂' DO(dl,sl[cl]*=l.s[i+cl])DO(cl,sl[i]=l.s[i])',NL
rtn[49],←⊂' DO(dr,sr[cr]*=r.s[i+cr])DO(cr,sr[i]=r.s[i])',NL
rtn[49],←⊂' B sz=dl>dr?sl[cl]:sr[cr];VEC<A> tv(sz);',NL
rtn[49],←⊂' A a(cl+1,l.v);DO(cl+1,a.s[i]=sl[i])A b(cr+1,r.v);DO(cr+1,b.s[i]=sr[i])',NL
rtn[49],←⊂' DOB(sz,A ta;A tb; A ai=scl(scl((I)(i%sl[cl])));A bi=scl(scl((I)(i%sr[cr])));',NL
rtn[49],←⊂'  sqd_c(ta,ai,a,e);sqd_c(tb,bi,b,e);ll(tv[i],ta,tb,e))',NL
rtn[49],←⊂' if(dr>=dl){z.s=SHP(dr);DOB(dr,z.s[i]=r.s[cr+i])}',NL
rtn[49],←⊂' if(dr<dl){z.s=SHP(dl);DOB(dl,z.s[i]=l.s[cl+i])}',NL
rtn[49],←⊂' z.v=tv;tke_c(z,z,e);}',NL
rtn[50],←⊂'OD(pow,"pow",scm(l),scd(l),MFD,DFD,MT ,MT )',NL
rtn[50],←⊂'MF(pow_o){if(fr){A t;A v=r;I flg;',NL
rtn[50],←⊂'  do{A u;ll(u,v,e);rr(t,u,v,e);',NL
rtn[50],←⊂'   if(cnt(t)!=1)err(5);CVSWITCH(t.v,err(6),flg=v.as(s32).scalar<I>(),err(11))',NL
rtn[50],←⊂'   v=u;}while(!flg);',NL
rtn[50],←⊂'  z=v;R;}',NL
rtn[50],←⊂' if(rnk(ww))err(4);I c;CVSWITCH(ww.v,err(6),c=v.as(s32).scalar<I>(),err(11))',NL
rtn[50],←⊂' z=r;DO(c,ll(z,z,e))}',NL
rtn[50],←⊂'DF(pow_o){if(!fl)err(2);',NL
rtn[50],←⊂' if(fr){A t;A v=r;I flg;',NL
rtn[50],←⊂'  do{A u;ll(u,l,v,e);rr(t,u,v,e);',NL
rtn[50],←⊂'   if(cnt(t)!=1)err(5);CVSWITCH(t.v,err(6),flg=v.as(s32).scalar<I>(),err(11))',NL
rtn[50],←⊂'   v=u;}while(!flg);',NL
rtn[50],←⊂'  z=v;R;}',NL
rtn[50],←⊂' if(rnk(ww))err(4);I c;CVSWITCH(ww.v,err(6),c=v.as(s32).scalar<I>(),err(11))',NL
rtn[50],←⊂' A t=r;DO(c,ll(t,l,t,e))z=t;}',NL
rtn[50],←⊂'',NL
rtn[51],←⊂'OD(jot,"jot",(scm(l)&&scm(r)),(scd(l)&&scd(r)),MFD,DFD,MT ,MT )',NL
rtn[51],←⊂'MF(jot_o){if(!fl){rr(z,aa,r,e);R;}if(!fr){ll(z,r,ww,e);R;}',NL
rtn[51],←⊂' rr(z,r,e);ll(z,z,e);}',NL
rtn[51],←⊂'DF(jot_o){if(!fl||!fr){err(2);}rr(z,r,e);ll(z,l,z,e);}',NL
rtn[51],←⊂'',NL
rtn[52],←⊂'NM(unq,"unq",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[52],←⊂'DEFN(unq)',NL
rtn[52],←⊂'MF(unq_f){if(rnk(r)>1)err(4);if(!cnt(r)){z.s=r.s;z.v=r.v;R;}',NL
rtn[52],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[52],←⊂'  ,arr a;arr b;sort(a,b,v);arr zv=a!=shift(a,1);zv(0)=1;',NL
rtn[52],←⊂'   zv=where(zv);sort(b,zv,b(zv),a(zv));z.s=SHP(1,zv.elements());z.v=zv',NL
rtn[52],←⊂'  ,err(16))}',NL
rtn[52],←⊂'DF(unq_f){if(rnk(r)>1||rnk(l)>1)err(4);',NL
rtn[52],←⊂' B lc=cnt(l),rc=cnt(r);',NL
rtn[52],←⊂' if(!cnt(l)){z.s=SHP(1,rc);z.v=r.v;R;}if(!cnt(r)){z.s=SHP(1,lc);z.v=l.v;R;}',NL
rtn[52],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',NL
rtn[52],←⊂' arr lv;CVSWITCH(l.v,err(6),lv=v,err(16))',NL
rtn[52],←⊂' dtype mt=mxt(l,r);arr x=setUnique(lv);B c=x.elements();',NL
rtn[52],←⊂' x=!anyTrue(tile(rv,1,(U)c)==tile(arr(x,1,c),(U)rc,1),1);',NL
rtn[52],←⊂' x=join(0,lv.as(mt),rv(where(x)).as(mt));z.s=SHP(1,x.elements());z.v=x;}',NL
rtn[53],←⊂'NM(int,"int",0,0,MT ,MT ,DFD,MT ,MT )',NL
rtn[53],←⊂'DEFN(int)',NL
rtn[53],←⊂'DF(int_f){if(rnk(r)>1||rnk(l)>1)err(4);',NL
rtn[53],←⊂' if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=SHP(1,0);R;}',NL
rtn[53],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',NL
rtn[53],←⊂' arr lv;CVSWITCH(l.v,err(6),lv=v,err(16))',NL
rtn[53],←⊂' arr pv=setUnique(rv);B pc=pv.elements();arr zv=constant(0,cnt(l),s64);',NL
rtn[53],←⊂' for(B h;h=pc/2;pc-=h){arr t=zv+h;replace(zv,pv(t)>lv,t);}',NL
rtn[53],←⊂' arr ix=where(pv(zv)==lv);z.s=SHP(1,ix.elements());',NL
rtn[53],←⊂' z.v=z.s[0]?lv(ix):scl(0);}',NL
rtn[54],←⊂'NM(get,"get",0,0,MT,MT,DFD,MT,MT)',NL
rtn[54],←⊂'DEFN(get)',NL
rtn[54],←⊂'DF(get_f){CVSWITCH(l.v,err(6),err(99,L"Unexpected simple array"),)',NL
rtn[54],←⊂' CVEC<A>&lv=std::get<VEC<A>>(l.v);B ll=lv.size();B zr=rnk(z),rr=rnk(r);',NL
rtn[54],←⊂' if(!ll){if(zr!=1)err(4);if(rr!=1)err(5);if(z.s[0]!=r.s[0])err(5);z=r;R;}',NL
rtn[54],←⊂' if(ll!=zr)err(4);B rk=0;DOB(ll,CVSWITCH(lv[i].v,rk+=1,rk+=rnk(lv[i]),err(11)))',NL
rtn[54],←⊂' if(rr>0&&rk!=rr)err(5);',NL
rtn[54],←⊂' const B*rs=r.s.data();IDX x[4];',NL
rtn[54],←⊂' if(!rr)DOB(ll,A v=lv[ll-i-1];CVSWITCH(v.v,,x[i]=v.as(s32),err(11)))',NL
rtn[54],←⊂' if(rr>0)',NL
rtn[54],←⊂'  DOB(ll,A u=lv[ll-i-1];',NL
rtn[54],←⊂'   CVSWITCH(u.v',NL
rtn[54],←⊂'    ,if(z.s[i]!=*rs++)err(5)',NL
rtn[54],←⊂'    ,DOB(rnk(u),if(u.s[i]!=*rs++)err(5))x[i]=v.as(s32)',NL
rtn[54],←⊂'    ,err(11)))',NL
rtn[54],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(16))',NL
rtn[54],←⊂' arr zv;CVSWITCH(z.v,err(6),zv=unrav(v,z.s),err(16))',NL
rtn[54],←⊂' zv(x[0],x[1],x[2],x[3])=rv;z.v=flat(zv);}',NL
rtn[54],←⊂'',NL
rtn[54],←⊂'OM(get,"get",0,0,MT,DFD,MT,MT)',NL
rtn[54],←⊂'DF(get_o){A t;brk_c(t,z,l,e);map_o mfn_c(llp);mfn_c(t,t,r,e);',NL
rtn[54],←⊂' get_c(z,l,t,e);}',NL
rtn[55],←⊂'NM(gdu,"gdu",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[55],←⊂'DEFN(gdu)',NL
rtn[55],←⊂'MF(gdu_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);',NL
rtn[55],←⊂' if(!cnt(r)){z.v=r.v;R;}B c=1;DOB(rr-1,c*=r.s[i])',NL
rtn[55],←⊂' CVSWITCH(r.v,err(6)',NL
rtn[55],←⊂'  ,arr mt;arr a(v,c,r.s[rr-1]);arr zv=iota(dim4(z.s[0]),dim4(1),s32);',NL
rtn[55],←⊂'   DOB(c,sort(mt,zv,flat(a((I)(c-i-1),zv)),zv,0,true))z.v=zv',NL
rtn[55],←⊂'  ,err(16))}',NL
rtn[55],←⊂'DF(gdu_f){err(16);}',NL
rtn[56],←⊂'NM(gdd,"gdd",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[56],←⊂'DEFN(gdd)',NL
rtn[56],←⊂'MF(gdd_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);',NL
rtn[56],←⊂' if(!cnt(r)){z.v=r.v;R;}I c=1;DOB(rr-1,c*=(I)r.s[i]);',NL
rtn[56],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=v,err(16))',NL
rtn[56],←⊂' arr mt,a(rv,c,r.s[rr-1]);arr zv=iota(dim4(z.s[0]),dim4(1),s32);',NL
rtn[56],←⊂' DO(c,sort(mt,zv,flat(a(c-(i+1),zv)),zv,0,false));z.v=zv;}',NL
rtn[56],←⊂'DF(gdd_f){err(16);}',NL
rtn[56],←⊂'',NL
rtn[57],←⊂'OM(oup,"oup",0,0,MT,DFD,MT ,MT )',NL
rtn[57],←⊂'DF(oup_o){B lr=rnk(l),rr=rnk(r),lc=cnt(l),rc=cnt(r);',NL
rtn[57],←⊂' SHP sp(lr+rr);DOB(rr,sp[i]=r.s[i])DOB(lr,sp[i+rr]=l.s[i])',NL
rtn[57],←⊂' if(!cnt(sp)){z.s=sp;z.v=scl(0);R;}',NL
rtn[57],←⊂' std::visit(visitor{DVSTR(),',NL
rtn[57],←⊂'   [&](carr&lv,carr&rv){arr x(lv,1,lc),y(rv,rc,1);',NL
rtn[57],←⊂'    x=flat(tile(x,(I)rc,1));y=flat(tile(y,1,(I)lc));',NL
rtn[57],←⊂'    map_o mfn_c(llp);A xa(sp,x),ya(sp,y);mfn_c(z,xa,ya,e);},',NL
rtn[57],←⊂'   [&](CVEC<A>&lv,CVEC<A>&rv){z.s=sp;z.v=VEC<A>(lc*rc);',NL
rtn[57],←⊂'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],lv[i],rv[i],e))',NL
rtn[57],←⊂'    coal(z);},',NL
rtn[57],←⊂'   [&](CVEC<A>&lv,carr&rv){z.s=sp;z.v=VEC<A>(lc*rc);',NL
rtn[57],←⊂'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],lv[i],A(0,rv((I)i)),e))',NL
rtn[57],←⊂'    coal(z);},',NL
rtn[57],←⊂'   [&](carr&lv,CVEC<A>&rv){z.s=sp;z.v=VEC<A>(lc*rc);',NL
rtn[57],←⊂'    VEC<A>&zv=std::get<VEC<A>>(z.v);DOB(lc*rc,ll(zv[i],A(0,lv((I)i)),rv[i],e))',NL
rtn[57],←⊂'    coal(z);}},',NL
rtn[57],←⊂'  l.v,r.v);}',NL
rtn[58],←⊂'NM(fnd,"fnd",0,0,MT ,MT ,DFD,MT ,MT )',NL
rtn[58],←⊂'DEFN(fnd)',NL
rtn[58],←⊂'DF(fnd_f){B lr=rnk(l),rr=rnk(r),rc=cnt(r),lc=cnt(l);',NL
rtn[58],←⊂' if(!rc){z=r;R;}z=r;arr zv(rc,b8);zv=0;',NL
rtn[58],←⊂' if(lr>rr){z.v=zv;R;}',NL
rtn[58],←⊂' DOB(lr,if(l.s[i]>r.s[i]){z.v=zv;R;})',NL
rtn[58],←⊂' if(!lc){zv=1;z.v=zv;R;}',NL
rtn[58],←⊂' if(lr>4||rr>4)err(16);',NL
rtn[58],←⊂' dim4 rs(1),ls(1);DO((I)lr,ls[i]=l.s[i])DO((I)rr,rs[i]=r.s[i])',NL
rtn[58],←⊂' dim4 sp;DO(4,sp[i]=rs[i]-ls[i]+1)seq x[4];DO(4,x[i]=seq((D)sp[i]))',NL
rtn[58],←⊂' zv=unrav(zv,z.s);zv(x[0],x[1],x[2],x[3])=1;',NL
rtn[58],←⊂' arr lv;CVSWITCH(l.v,err(6),lv=unrav(v,l.s),err(16))',NL
rtn[58],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(16))',NL
rtn[58],←⊂' DO((I)ls[0],I m=i;',NL
rtn[58],←⊂'  DO((I)ls[1],I k=i;',NL
rtn[58],←⊂'   DO((I)ls[2],I j=i;',NL
rtn[58],←⊂'    DO((I)ls[3],zv(x[0],x[1],x[2],x[3])=zv(x[0],x[1],x[2],x[3])',NL
rtn[58],←⊂'     &(tile(lv(m,k,j,i),sp)',NL
rtn[58],←⊂'      ==rv(x[0]+(D)m,x[1]+(D)k,x[2]+(D)j,x[3]+(D)i))))))',NL
rtn[58],←⊂' z.v=zv;}',NL
rtn[59],←⊂'NM(par,"par",0,0,MT ,MFD,DFD,MAD,MT )',NL
rtn[59],←⊂'DEFN(par)',NL
rtn[59],←⊂'MF(par_f){I nv=0;CVSWITCH(r.v,err(6),,nv=1)',NL
rtn[59],←⊂' if(!rnk(r)&&!nv){z=r;R;}z=A(0,VEC<A>(1,r));}',NL
rtn[59],←⊂'MA(par_f){if(rnk(ax)>1)err(4);B axc=cnt(ax);',NL
rtn[59],←⊂' if(!axc){map_o f(par_p);f(z,r,e);R;}',NL
rtn[59],←⊂' B rr=rnk(r);VEC<I> axm(rr,0);VEC<I> axv(axc);',NL
rtn[59],←⊂' CVSWITCH(ax.v,err(6),v.as(s32).host(axv.data()),err(11))',NL
rtn[59],←⊂' DOB(axc,I v=axv[i];if(v<0)err(11);if(v>=rr)err(4);if(axm[v])err(11);axm[v]=1)',NL
rtn[59],←⊂' B ic=rr-axc;if(!ic){z=A(0,VEC<A>(1,r));R;}',NL
rtn[59],←⊂' A nax(SHP(1,ic),arr(ic,s32));arr&naxv=std::get<arr>(nax.v);A x;x.s=SHP(ic);',NL
rtn[59],←⊂' B j=0;DOB(rr,if(!axm[i]){naxv((I)j)=i;x.s[ic-j-1]=r.s[rr-i-1];j++;})',NL
rtn[59],←⊂' B xc=cnt(x);x.v=VEC<A>(xc);VEC<A>&xv=std::get<VEC<A>>(x.v);',NL
rtn[59],←⊂' VEC<I> ixh(ic,0);A ix(SHP(1,ic),arr(ic,s32));arr&ixv=std::get<arr>(ix.v);',NL
rtn[59],←⊂' DOB(xc,ixv=arr(ic,ixh.data());sqd_c(xv[i],ix,r,e,nax);',NL
rtn[59],←⊂'  ixh[ic-1]++;DOB(ic-1,B j=ic-i-1;if(ixh[j]==x.s[i]){ixh[j-1]++;ixh[j]=0;}))',NL
rtn[59],←⊂' z=x;}',NL
rtn[59],←⊂'DF(par_f){err(16);}',NL
rtn[59],←⊂'',NL
rtn[60],←⊂'NM(mdv,"mdv",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[60],←⊂'DEFN(mdv)',NL
rtn[60],←⊂'MF(mdv_f){B rr=rnk(r),rc=cnt(r);',NL
rtn[60],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',NL
rtn[60],←⊂' if(rr>2)err(4);if(rr==2&&r.s[1]<r.s[0])err(5);if(!rc)err(5);',NL
rtn[60],←⊂' if(!rr||rc==1||r.s[0]==r.s[1]){z.s=r.s;z.v=flat(inverse(rv));R;}',NL
rtn[60],←⊂' if(rr==1){z.v=flat(matmulNT(inverse(matmulTN(rv,rv)),rv));z.s=r.s;R;}',NL
rtn[60],←⊂' arr zv=matmulTN(inverse(matmulNT(rv,rv)),rv);z.s=r.s;',NL
rtn[60],←⊂' B k=z.s[0];z.s[0]=z.s[1];z.s[1]=k;z.v=flat(transpose(zv));}',NL
rtn[60],←⊂'DF(mdv_f){B rr=rnk(r),lr=rnk(l),rc=cnt(r),lc=cnt(l);',NL
rtn[60],←⊂' if(rr>2)err(4);if(lr>2)err(4);if(rr==2&&r.s[1]<r.s[0])err(5);',NL
rtn[60],←⊂' if(!rc||!lc)err(5);if(rr&&lr&&l.s[lr-1]!=r.s[rr-1])err(5);',NL
rtn[60],←⊂' arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',NL
rtn[60],←⊂' arr lv;CVSWITCH(l.v,err(6),lv=unrav(v,l.s),err(11))',NL
rtn[60],←⊂' if(rr==1)rv=transpose(rv);if(lr==1)lv=transpose(lv);',NL
rtn[60],←⊂' z.v=flat(transpose(matmul(inverse(matmulNT(rv,rv)),matmulNT(rv,lv))));',NL
rtn[60],←⊂' z.s=SHP((lr-(lr>0))+(rr-(rr>0)));',NL
rtn[60],←⊂' if(lr>1)z.s[0]=l.s[0];if(rr>1)z.s[lr>1]=r.s[0];}',NL
rtn[61],←⊂'NM(fft,"fft",1,0,MT ,MFD,MT ,MT ,MT )',NL
rtn[61],←⊂'DEFN(fft)',NL
rtn[61],←⊂'MF(fft_f){arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',NL
rtn[61],←⊂' z.s=r.s;z.v=dft(rv.type()==c64?rv:rv.as(c64),1,rv.dims());}',NL
rtn[61],←⊂'',NL
rtn[62],←⊂'NM(ift,"ift",1,0,MT ,MFD,MT ,MT ,MT )',NL
rtn[62],←⊂'DEFN(ift)',NL
rtn[62],←⊂'MF(ift_f){arr rv;CVSWITCH(r.v,err(6),rv=unrav(v,r.s),err(11))',NL
rtn[62],←⊂' z.s=r.s;z.v=idft(rv.type()==c64?rv:rv.as(c64),1,rv.dims());}',NL
rtn[62],←⊂'',NL
rtn[63],←⊂'template<class fncls> inline V msclfn(A&z,CA&r,ENV&e,FN&rec_c,fncls fn){',NL
rtn[63],←⊂' z.s=r.s;',NL
rtn[63],←⊂' CVSWITCH(r.v,err(6),fn(z,v,e)',NL
rtn[63],←⊂'  ,B cr=cnt(r);z.v=VEC<A>(cr);VEC<A>&zv=std::get<VEC<A>>(z.v);',NL
rtn[63],←⊂'   DOB(cr,rec_c(zv[i],v[i],e)))}',NL
rtn[63],←⊂'template<class fncls> inline V sclfn(A&z,CA&l,CA&r,ENV&e,fncls fn){',NL
rtn[63],←⊂' B lr=rnk(l),rr=rnk(r);',NL
rtn[63],←⊂' if(lr==rr){DOB(rr,if(l.s[i]!=r.s[i])err(5));z.s=l.s;}',NL
rtn[63],←⊂' else if(!lr){z.s=r.s;}else if(!rr){z.s=l.s;}else if(lr!=rr)err(4);',NL
rtn[63],←⊂' std::visit(visitor{DVSTR(),',NL
rtn[63],←⊂'   [&](CVEC<A>&lv,carr&rv){err(16);},',NL
rtn[63],←⊂'   [&](carr&lv,CVEC<A>&rv){err(16);},',NL
rtn[63],←⊂'   [&](CVEC<A>&lv,CVEC<A>&rv){err(16);},',NL
rtn[63],←⊂'   [&](carr&lv,carr&rv){',NL
rtn[63],←⊂'    if(lr==rr){fn(z,lv,rv,e);}',NL
rtn[63],←⊂'    else if(!lr){fn(z,tile(lv,rv.dims()),rv,e);}',NL
rtn[63],←⊂'    else if(!rr){fn(z,lv,tile(rv,lv.dims()),e);}}},',NL
rtn[63],←⊂'  l.v,r.v);}',NL
rtn[63],←⊂'inline V sclfn(A&z,CA&l,CA&r,ENV&e,CA&ax,FN&me_c){',NL
rtn[63],←⊂' A a=l,b=r;I f=rnk(l)>rnk(r);if(f){a=r;b=l;}',NL
rtn[63],←⊂' B ar=rnk(a),br=rnk(b);B d=br-ar;B rk=cnt(ax);if(rk!=ar)err(5);',NL
rtn[63],←⊂' VEC<D> axd(rk);SHP axv(rk);',NL
rtn[63],←⊂' if(rk)',NL
rtn[63],←⊂'  CVSWITCH(ax.v',NL
rtn[63],←⊂'   ,err(99,L"Unexpected value error.")',NL
rtn[63],←⊂'   ,v.as(f64).host(axd.data())',NL
rtn[63],←⊂'   ,err(99,L"Unexpected nested shape."))',NL
rtn[63],←⊂' DOB(rk,if(axd[i]!=rint(axd[i]))err(11))DOB(rk,axv[i]=(B)axd[i])',NL
rtn[63],←⊂' DOB(rk,if(axv[i]<0||br<=axv[i])err(11))',NL
rtn[63],←⊂' VEC<B> t(br);VEC<U8> tf(br,1);DOB(rk,B j=axv[i];tf[j]=0;t[j]=d+i)',NL
rtn[63],←⊂' B c=0;DOB(br,if(tf[i])t[i]=c++)A ta(SHP(1,br),arr(br,t.data()));',NL
rtn[63],←⊂' trn_c(z,ta,b,e);rho_c(b,z,e);rho_c(a,b,a,e);',NL
rtn[63],←⊂' if(f)me_c(b,z,a,e);else me_c(b,a,z,e);',NL
rtn[63],←⊂' gdu_c(ta,ta,e);trn_c(z,ta,b,e);}',NL
rtn[64],←⊂'NM(nst,"nst",0,0,MT ,MFD,MT ,MT ,MT )',NL
rtn[64],←⊂'DEFN(nst)',NL
rtn[64],←⊂'MF(nst_f){CVSWITCH(r.v,err(6),par_c(z,r,e),z=r)}',NL
:EndNamespace
