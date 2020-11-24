:Namespace codfns
⎕IO ⎕ML ⎕WX VERSION AF∆PREFIX AF∆LIB←0 1 3 (1 3 0) '/opt/arrayfire' 'cuda'
VS∆PS←⊂'\Program Files (x86)\Microsoft Visual Studio\'
VS∆PS,¨←,'2019\' '2017\'∘.,'Enterprise' 'Professional' 'Community'
VS∆PS,¨←⊂'\VC\Auxiliary\Build\vcvarsall.bat'
VS∆PS,←⊂'\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat'
Cmp←{_←1 ⎕NDELETE f←⍺,soext⍬ ⋄ _←(⍺,'.cpp')put⍨gc tt⊢a n s←ps ⍵
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
cco←'-std=c++11 -Ofast -g -Wall -fPIC -shared '
ucc←{⍵⍵(⎕SH ⍺⍺,' ',cco,cci,ccf)⍵}
gcc←'g++'ucc'so'
clang←'clang++'ucc'dylib'
vsco←{z←'/W3 /wd4102 /wd4275 /Gm- /O2 /Zc:inline /Zi /FS /Fd"',⍵,'.pdb" '
 z,←'/errorReport:prompt /WX- /MD /EHsc /nologo '
 z,'/I"%AF_PATH%\include" /D "NOMINMAX" /D "AF_DEBUG" '}
vslo←{z←'/link /DLL /OPT:REF /INCREMENTAL:NO /SUBSYSTEM:WINDOWS '
 z,←'/LIBPATH:"%AF_PATH%\lib" /DYNAMICBASE "af', AF∆LIB, '.lib" '
 z,'/OPT:ICF /ERRORREPORT:PROMPT /TLBID:1 '}
vsc0←{~∨⌿b←⎕NEXISTS¨VS∆PS:'VISUAL C++?'⎕SIGNAL 99 ⋄ '""','" amd64',⍨⊃b⌿VS∆PS}
vsc1←{' && cd "',(⊃⎕CMD'echo %CD%'),'" && cl ',(vsco ⍵),'/fast "',⍵,'.cpp" '}
vsc2←{(vslo ⍵),'/OUT:"',⍵,'.dll" > "',⍵,'.log""'}
vsc←{⎕CMD('%comspec% /C ',vsc0,vsc1,vsc2)⍵}
f∆ N∆←'ptknfsrdx' 'ABEFGLMNOPVZ'
⎕FX∘⍉∘⍪¨'GLM',¨'←{⍪/(0 '∘,¨(⍕¨N∆⍳'GLM'),¨⊂' 0 0),1+@0⍉↑(⊂4⍴⊂⍬),⍵}'
⎕FX∘⍉∘⍪¨'ABEFO',¨'←{⍺←0 ⋄ ⍪/(0 '∘,¨(⍕¨N∆⍳'ABEFO'),¨⊂' ⍺⍺ ⍺),1+@0⍉↑(⊂4⍴⊂⍬),⍵}'
⎕FX∘⍉∘⍪¨'NPVZ',¨'←{0(N∆⍳'''∘,¨'NPVZ',¨''')'∘,¨'0(⍎⍵)' '⍺⍺(⊂⍵)' '⍺⍺(⊂⍵)' '1(⊂⍵)',¨'}'
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
_o←{0≥⊃c a e r←p←⍺ ⍺⍺ ⍵:p ⋄ 0≥⊃c a e r2←p←⍺ ⍵⍵ ⍵:p ⋄ c a e(r↑⍨-⌊/≢¨r r2)}
_s←{0<⊃c a e r←p←⍺ ⍺⍺ ⍵:p ⋄ 0<⊃c2 a2 e r←p←e ⍵⍵ r:p ⋄ (c⌈c2)(a,a2)e r}
_noenv←{0<⊃c a e r←p←⍺ ⍺⍺ ⍵:p ⋄ c a ⍺ r}
_env←{0<⊃c a e r←p←⍺ ⍺⍺ ⍵:p ⋄ c a (e ⍵⍵ a) r}
_then←{0<⊃c a e r←p←⍺ ⍺⍺ ⍵:p ⋄ 0<⊃c a e _←p←e(⍵⍵ _s eot)a:p ⋄ c a e r}
_not←{0<⊃c a e r←⍺ ⍺⍺ ⍵:0 a ⍺ ⍵ ⋄ 2 a ⍺ ⍵}
_as←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ c (,⊂⍵⍵ a) e r}
_t←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ e ⍵⍵ a:c a e r ⋄ 2 ⍬ ⍺ ⍵}
_ign←{c a e r←⍺ ⍺⍺ ⍵ ⋄ c ⍬ e r}
_peek←{0<p←⊃⍺ ⍺⍺ ⍵:p ⋄ 0 ⍬ ⍺ ⍵}
_yes←{0 ⍬ ⍺ ⍵}
_opt←{⍺(⍺⍺ _o _yes)⍵}
_any←{⍺(⍺⍺ _s ∇ _o _yes)⍵}
_some←{⍺(⍺⍺ _s (⍺⍺ _any))⍵}
_set←{(0≠≢⍵)∧(⊃⍵)∊⍺⍺:0(,⊃⍵)⍺(1↓⍵) ⋄ 2 ⍬ ⍺ ⍵}
_tk←{((≢,⍺⍺)↑⍵)≡,⍺⍺:0(⊂,⍺⍺)⍺((≢,⍺⍺)↓⍵) ⋄ 2 ⍬ ⍺ ⍵}
_eat←{0=≢⍵:2 ⍬ ⍺ ⍵ ⋄ 0(⍺⍺↑⍵)⍺(⍺⍺↓⍵)}
ws←(' ',⎕UCS 9)_set
aws←ws _any _ign
awslf←(⎕UCS 10 13) _set _o ws _any _ign
gets←aws _s ('←'_tk) _s aws _ign
him←'¯' _set ⋄ dot←'.' _set ⋄ jot←'∘' _set
lbrc←aws _s ('{'_set) _s aws ⋄ rbrc←aws _s ('}'_set) _s aws
lpar←aws _s ('('_tk) _s aws _ign ⋄ rpar←aws _s (')'_tk) _s aws _ign
lbrk←aws _s ('['_tk) _s aws _ign ⋄ rbrk←aws _s (']'_tk) _s aws _ign
semi←aws _s (';' _tk) _s aws _ign
grd←aws _s (':'_tk) _s aws _ign
zil←aws _s ('⍬'_tk) _s aws _ign
egrd←aws _s ('::'_tk) _s aws _ign
alpha←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz∆'_set
digits←'0123456789'_set
prims←'+-÷×|*⍟⌈⌊!<≤=≠≥>∧∨⍲⍱⌷?⍴,⍪⌽⊖⍉∊⍷⊃⍳○~≡≢⊢⊣/⌿\⍀⊤⊥↑↓∪∩⍋⍒∇⌹'
prim←aws _s (prims _set) _s aws
mop←aws _s ('¨/⌿⍀\⍨'_set) _s aws
dop1←aws _s ('.⍣∘'_set) _s aws
dop2←aws _s ('⍤⍣∘'_set) _s aws
dop3←aws _s ('∘'_set) _s aws
eot←aws _s {(''≡⍵)∨⍬≡⍵:0 ⍬ ⍺ '' ⋄ 2 ⍬ ⍺ ⍵} _ign
digs←digits _some
odigs←digits _any
int←aws _s digs _s (him _opt) _s aws
float←aws _s (odigs _s dot _s int _o (digs _s dot)) _s aws
name←aws _s (alpha _o (digits _some _s alpha) _some) _s aws
aw←aws _s ('⍺⍵'_set) _s aws
aaww←aws _s (('⍺⍺'_tk) _o ('⍵⍵'_tk)) _s aws
sep←aws _s (('⋄',⎕UCS 10 13) _set _ign) _s aws
nssn←alpha _s (alpha _o digits _any)
nss←awslf _s (':Namespace'_tk) _s aws _s (nssn _opt) _s awslf _ign
nse←awslf _s (':EndNamespace'_tk) _s awslf _ign
Sfn←aws _s (('TFF⎕'_tk) _o ('TFFI⎕'_tk)) _s aws _as {1P⌽∊⍵}
Prim←prim _as(1P)
Vt←(⊢⍳⍨0⊃⊣)⊃¯1,⍨1⊃⊣
Name←{⍺((name _as ⌽) _t (⍺⍺=Vt) _as (⍺⍺ V∘,∘⊃))⍵}
Args←{⍺(aaww _o aw _t (⍺⍺=Vt) _as (⍺⍺ V∘,∘⊃))⍵}
Var←{⍺(⍺⍺ Args _o (⍺⍺ Name))⍵}
Num←float _o int _as (N∘⌽)
Strand←0 Var _s (0 Var _some) _as (3 A∘⌽)
Pex←{⍺(rpar _s Ex _s lpar)⍵}
Atom←Strand _o (0 Var) _o (zil _as (0 A)) _o (Num _some _as (0 A∘⌽)) _o Pex
Semx←{⍺(Ex _o (_yes _as {3 A,⊂0P,';'}))⍵}
Brk←rbrk _s (Semx _s (semi _s Semx _any)) _s lbrk _as (3 E∘⌽)
Idx←Brk _s (_yes _as {1P,'['}) _s Atom _as (2 E∘⌽)
Blrp←{⍺(⍺⍺ _s (⍵⍵ Slrp ∇))⍵}
Slrp←{⍺(⍺⍺ _o (⍵⍵ _s ∇) _o ((1 _eat) _s ∇))⍵}
Fax←{⍺ Gex _o Ex _o Fex Stmts _then Fn ⍵}
Fa←{e←(⊂⍺),¨¨⍨(⊂'⍵⍵' '⍺⍺','⍺⍵')∘,∘⊂¨↓⍉¯1+3 3 2 2⊤(6 4 4⌿1 5 9)+2×⍳14
 0=⊃z←(0⊃e)Fax ⍵:0(,⊂0(N∆⍳'F')1 0⍪¨1+@0⊃(0⍴⊂4⍴⊂⍬),1⊃z)⍺ ⍵
 0=⊃z←(1⊃e)Fax ⍵:0(,⊂0(N∆⍳'F')1 0⍪¨1+@0⊃(0⍴⊂4⍴⊂⍬),1⊃z)⍺ ⍵
 m←(0=⊃a)∧∧⌿(∨⍀∘.=⍨⍳12)∨∘.≢⍨1⊃a←↓⍉↑(2↓e)Fax¨⊂⍵
 ~∨⌿m:(⌈⌿⊃a) ⍬ ⍺ ⍵
 z←⍪⌿↑(⊂0(N∆⍳'F')¯1 0),({1(N∆⍳'F')⍵ 0}¨2+m⌿⍳12)⍪¨(2+@0⊃)¨m⌿1⊃a 
 0(,⊂z)⍺ ⍵}
Fn←{0=≢⍵:0 ⍬ ⍺ '' ⋄ ns←(3⊃z)⌿⍨m←((3=1⊃⊢)∧¯1=2⊃⊢)⊢z←⍪⌿↑⍵ ⋄ 0=≢ns:0(,⊂z)⍺ ''
 r←↓⍉↑⍺∘Fa¨ns ⋄ 0<c←⌈⌿⊃r:c ⍬ ⍺ ⍵
 z←(⊂¨¨z)((⊃⍪⌿)⊣@{m})¨⍨↓(m⌿0⊃z)+@0⍉↑⊃¨1⊃r
 0(,⊂z)⍺ ''}
Pfe←{⍺(rpar _s Fex _s lpar)⍵}
Bfn←rbrc Blrp lbrc _as {0(N∆⍳'F')¯1(,⊂⌽1↓¯1↓⍵)}
Fnp←Prim _o (1 Var) _o Sfn _o Bfn _o Pfe
Mop←{⍺((mop _as(2P)) _s Afx _as (2 O))⍵}
Dop1←{⍺((dop1 _as(2P)) _s Afx _as (8 O∘⌽))⍵}
Dop2←{⍺(Atom _s (dop2 _as(2P)) _s Afx _as (7 O∘⌽))⍵}
Dop3←(dop3 _as(2P)) _s Atom _as (5 O∘⌽) _o (dot _s jot _as (2P∘⌽) _as (2 O))
Bop←{⍺(rbrk _s Ex _s lbrk _s (_yes _as {2P,'['}) _s Afx _as (7 O∘⌽))⍵}
Afx←Mop _o (Fnp _s (Dop1 _o Dop3 _opt) _as (⍪/⍳∘≢+@0⍉∘↑∘⌽)) _o Dop2 _o Bop
Trn←{⍺(Afx _s ((Afx _o Idx _o Atom) _s (∇ _opt) _opt))⍵} _as (3 F∘⌽)
Bind←{⍺(gets _s (name _as ⌽) _env (⊣⍪¨⍨⍺⍺,⍨∘⊂⊢) _as (⍺⍺ B∘⍬))⍵}
Mname←(0 Name) _as (0 3∘⊃4 E⊢)
Mbrk←_yes _as {2P,'←'} _as (2 O∘⌽) _s Brk _s (0 Name) _as (2 3∘⊃4 E∘⌽2↑⊢)
Mget←Afx _s (Mname _o Mbrk) _as {⍪/(0,1+2<≢⊃z)+@0⊢z←⍉↑⌽⍵}
Bget←_yes _as {1P,'←'} _s Brk _s (0 Name) _as (2 3∘⊃4 E∘⌽2↑⊢)
Asgn←gets _s (Bget _o Mget)
Fex←Afx _s (Trn _opt) _s (1 Bind _any) _as (⍪/⍳∘≢+@0⍉∘↑∘⌽)
IAx←Idx _o Atom _s (dop2 _not)
App←Afx _s (IAx _opt) _as {(≢⍵)E⌽⍵}
Ex←IAx _s {⍺(Asgn _o (0 Bind) _o App _s ∇ _opt)⍵} _as (⍪/⍳∘≢+@0⍉∘↑∘⌽)
Gex←Ex _s grd _s Ex _as (G∘⌽)
Nlrp←sep _o eot Slrp (lbrc Blrp rbrc)
Stmts←{⍺(sep _any _s (Nlrp _then (⍺⍺ _s eot∘⌽)) _any _s eot)⍵}
Ns←nss Blrp nse _then (Ex _o Fex Stmts _then Fn) _s eot _as (0 F)
ps←{⍞←'P' ⋄ 0≠⊃c a e r←⍬ ⍬ Ns∊{⍵/⍨∧\'⍝'≠⍵}¨⍵,¨⎕UCS 10:⎕SIGNAL c
 (↓s(-⍳)@3↑⊃a)e(s←∪0(,'⍵')(,'⍺')'⍺⍺' '⍵⍵',3⊃⊃a)}
⍝ A  B  E  F  G  L  M  N  O  P  V  Z
⍝ 0  1  2  3  4  5  6  7  8  9 10 11
tt←{⍞←'C' ⋄ ((d t k n)exp sym)←⍵ ⋄ I←{(⊂⍵)⌷⍺}
 r←I@{t[⍵]≠3}⍣≡⍨p⊣2{p[⍵]←⍺[⍺⍸⍵]}⌿⊢∘⊂⌸d⊣p←⍳≢d				⍝ PV
 p,←n[i]←(≢p)+⍳≢i←⍸(t=3)∧p≠⍳≢p ⋄ t k n r,←3 1 0(r[i])⍴⍨¨≢i		⍝ LF
 p r I⍨←⊂n[i]@i⊢⍳≢p ⋄ t k(⊣@i⍨)←10 1
 i←(⍸(~t∊3 4)∧t[p]=3),{⍵⌿⍨2|⍳≢⍵}⍸t[p]=4 ⋄ p t k n r⌿⍨←⊂m←2@i⊢1⍴⍨≢p	⍝ WX
 p r i I⍨←⊂j←(+⍀m)-1 ⋄ n←j I@(0≤⊢)n ⋄ p[i]←j←i-1
 k[j]←-(k[r[j]]=0)∨0@({⊃⌽⍵}⌸p[j])⊢(t[j]=1)∨(t[j]=2)∧k[j]=4 ⋄ t[j]←2
 p[i]←p[x←¯1+i←{⍵⌿⍨~2|⍳≢⍵}⍸t[p]=4] ⋄ t[i,x]←t[x,i] ⋄ k[i,x]←k[x,i]	⍝ LG
 n[x]←n[i] ⋄ p←((x,i)@(i,x)⊢⍳≢p)[p]
 n[p⌿⍨(t[p]=2)∧k[p]=3]+←1						⍝ CI
 p[i]←p[x←p I@{~t[p[⍵]]∊3 4}⍣≡i←⍸t∊4,(⍳3),8+⍳3] ⋄ j←(⌽i)[⍋⌽x]		⍝ LX
 p t k n r{⍺[⍵]@i⊢⍺}←⊂j ⋄ p←(i@j⊢⍳≢p)[p]
 s←¯1,⍨∊⍳¨n[∪x]←⊢∘≢⌸x←0⌷⍉e←∪I∘⍋⍨rn←r[b],⍪n[b←⍸t=1]			⍝ SL
 d←(≢p)↑d ⋄ d[i←⍸t=3]←0 ⋄ _←{z⊣d[i]+←⍵≠z←r[⍵]}⍣≡i ⋄ f←d[0⌷⍉e],¯1	⍝ FR
 xn←n⌿⍨(t=1)∧k[r]=0							⍝ XN
 v←⍸(n<¯4)∧(t=10)∨(t=2)∧k=4 ⋄ x←n[y←v,b] ⋄ n[b]←s[e⍳rn] ⋄ i←(≢x)⍴c←≢e	⍝ AV
 _←{z/⍨c=i[1⌷z]←e⍳⍉x I@1⊢z←r I@0⊢⍵}⍣≡(v,r[b])⍪⍉⍪⍳≢x
 f s←(f s I¨⊂i)⊣@y¨⊂¯1⍴⍨≢r
 p t k n f s r d xn sym}
gck← (0 0)(0 1)(0 3)(1 0)(1 1)(2 ¯1)(2 0)(2 1)(2 2)(2 3)(2 4)(3 0)(3 1)(4 0)
gcv← 'Aa' 'Av' 'As' 'Bv' 'Bf' 'Ek'  'Er' 'Em' 'Ed' 'Ei' 'Eb' 'Fz' 'Fn' 'Gd'
gck,←(7 0)(8 1)(8 2)(8 4) (8 5) (8 7) (8 8) (9 0)(9 1)(9 2)(10 0)(10 1)
gcv,←'Na' 'Ov' 'Of' 'Ovv' 'Ovf' 'Ofv' 'Off' 'Pv' 'Pf' 'Po' 'Va'  'Vf'
gck+←⊂1 0
gcv,←⊂'{''/* Unhandled '',(⍕⍺),'' */'',NL}'
NL←⎕UCS 13 10

gc←{⍞←'G' ⋄ p t k n fr sl rf fd xn sym←⍵ ⋄ xi←⍸(t=1)∧k[rf]=0 ⋄ d i←P2D p
 I←{(⊂⍵)⌷⍺} ⋄ com←{⊃{⍺,',',⍵}/⍵} ⋄  ks←{⍵⊂[0]⍨(⊃⍵)=⍵[;0]}
 nam←{'∆'⎕R'__'∘⍕¨sym[|⍵]} ⋄ slt←{'(*e[',(⍕6⊃⍵),'])[',(⍕7⊃⍵),']'}
 ast←(⍉↑d p (1+t)k n(⍳≢p)fr sl fd)[i;]
 Aa←{0=≢ns←dis¨⍵:'PUSH(A(1,dim4(0),scl(0)));',NL
  1=≢ns←dis¨⍵:'PUSH(scl(scl(',(⊃ns),')));',NL
  c←⍕≢⍵ ⋄ v←'std::vector<',('DI'⊃⍨∧.=∘⌊⍨⍎¨ns),'>{',(com ns),'}.data()'
  'PUSH(A(SHP(1,',c,'),array(',c,',',v,')));',NL}
 As←{'PUSH(A(-1,eshp,array()));',NL}
 Bf←{'(*e[fd])[',(⍕4⊃⍺),']=s.top();',NL}
 Bv←{'(*e[fd])[',(⍕4⊃⍺),']=s.top();',NL}
 Eb←{'{A x,y;FN*f;POP(v,x);POP(f,f);POP(v,y);(*f)(',(slt⍺),'.v,x,y,e);PUSH(y);}',NL}
 Ed←{'{A z,x,y;FN*f;POP(v,x);POP(f,f);POP(v,y);(*f)(z,x,y,e);PUSH(z);}',NL}
 Ei←{'{A x;x.nv.resize(',(⍕4⊃⍺),');DO(',(⍕4⊃⍺),',POP(v,x.nv[i]));PUSH(x);}',NL}
 Ek←{'s.pop();',NL}
 Em←{'{A z,x;FN*f;POP(f,f);POP(v,x);(*f)(z,x,e);PUSH(z);}',NL}
 Er←{'POP(v,z);z.f=1;e[fd]=of;R;',NL}
 Fn←{z←NL,'DF(',('fn',⍕5⊃⍺),'_f){FRM*of=NULL;I fd=',(⍕8⊃⍺),';try{STK s;',NL
  z,←'FRM f(',(⍕4⊃⍺),');if(e.size()<=fd)e.resize(fd+1);of=e[fd];e[fd]=&f;',NL
  B←{'(*e[fd])[',(⍕n[⍵]),']=(*e[',(⍕fr[⍵]),'])[',(⍕sl[⍵]),'];',NL}
  z,←⊃,⌿(B¨⍸(p=5⊃⍺)∧(t=1)∧fr≠¯1),' ',¨dis¨⍵
  z,←' }catch(U x){e[fd]=of;throw x;}',NL
  z,' catch(exception x){e[fd]=of;throw x;}}',NL}
 Fz←{z←NL,'ENV e',(⍕5⊃⍺),'(1);I is',(⍕5⊃⍺),'=0;',NL
  z,←'DF(',('fn',⍕5⊃⍺),'_f){if(is0)R;I fd=0;STK s;e[0]=new FRM(',(⍕4⊃⍺),');',NL
  z,(⊃,⌿' ',¨dis¨⍵),' is0=1;}',NL,NL}
 Gd←{z←'{A x;POP(v,x);if(cnt(x)!=1)err(5);',NL
  z,←' if(!(x.v.isinteger()||x.v.isbool()))err(11);',NL
  z,←' I t=x.v.as(s32).scalar<I>();if(t!=0&&t!=1)err(11);',NL
  z,' if(t){',NL,(⊃,/' ',¨dis¨⍵),' }}',NL}
 Na←{'¯'⎕R'-'⍕sym⌷⍨|4⊃⍺}
 Ov←{'{A x;FN*f;MOK*o;POP(m,o);POP(v,x);(*o)(f,x);EX(o);PUSH(f);}',NL}
 Of←{'{FN*f,*g;MOK*o;POP(m,o);POP(f,g);(*o)(f,*g);EX(o);PUSH(f);}',NL}
 Ovv←{'{A x,y;FN*f;DOK*o;POP(v,x);POP(d,o);POP(v,y);(*o)(f,x,y);EX(o);PUSH(f);}',NL}
 Ovf←{'{A x;FN*f,*g;DOK*o;POP(v,x);POP(d,o);POP(f,g);(*o)(f,x,*g);EX(o);PUSH(f);}',NL}
 Ofv←{'{A x;FN*f,*g;DOK*o;POP(f,g);POP(d,o);POP(v,x);(*o)(f,*g,x);EX(o);PUSH(f);}',NL}
 Off←{'{FN*f,*g,*h;DOK*o;POP(f,g);POP(d,o);POP(f,h);(*o)(f,*g,*h);EX(o);PUSH(f);}',NL}
 Pf←{'PUSH(&',(nams⊃⍨syms⍳sym⌷⍨|4⊃⍺),'_c);',NL}
 Po←{'PUSH(new ',(nams⊃⍨syms⍳sym⌷⍨|4⊃⍺),'_k());',NL}
 Pv←{''}
 Zp←{n←'fn',⍕⍵ ⋄ z←'S ',n,'_f:FN{MFD;DFD;',n,'_f():FN("fn',n,'",0,0){};};',NL
  z,n,'_f ',n,'_c;MF(',n,'_f){',n,'_c(z,A(),r,e);}',NL}
 Va←{(x←4⊃⍺)∊-1+⍳4:'PUSH(',(,'r' 'l' 'll' 'rr'⊃⍨¯1+|x),');',NL
  'PUSH(',(slt ⍺),'.v);',NL}
 Vf←{0>x←4⊃⍺:'PUSH(',(slt ⍺),'.f);',NL ⋄ 'PUSH(&fn',(⍕x),'_c);',NL}
 dis←{0=2⊃h←,1↑⍵:'' ⋄ c←ks 1↓⍵ ⋄ (≢gck)=i←gck⍳⊂h[2 3]:⎕SIGNAL 16 ⋄ h(⍎i⊃gcv)c}
 z←(⊂rth),(rtn[syms⍳∪⊃,/deps⌿⍨syms∊sym]),(,/Zp¨⍸t=3)
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
syms,←,¨'⍋'   '⍒'   '∘.'  '⍷'   '⊂'   '⌹'   '⎕FFT' '⎕IFFT' '∇'    ';'
nams,←  'gdu' 'gdd' 'oup' 'fnd' 'par' 'mdv' 'fft'  'ift'   'this' 'span'
syms,←⊂'%u' ⋄ nams,←⊂''
deps←⊂¨syms
deps[syms⍳,¨sclsyms]←,¨¨'⍉⍴⍋'∘,¨sclsyms←'+-×÷*⍟|○⌊⌈!<≤=≥>∧∨⍱⍲'
deps[syms⍳,¨'∧⌿/.⍪⍤\']←,¨¨'⍉⍴⍋∨∧' '¨,/⌿' '¨,/' '¨,/.' ',⍪' '¨⍳⌷⍤' '¨,\'
deps[syms⍳,¨'←⌽⊖⌷⍀']←,¨¨'[¨←' '⍉⍴⍋|,⌽' '⍉⍴⍋|,⌽⊖' '⍳⌷' '¨,\⍀'
deps[syms⍳⊂'∘.']←⊂(,'¨')'∘.'

rth←''
rtn←(⍴nams)⍴⊂''
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
rth,←'#define this_c *this',NL
rth,←'#define VEC std::vector',NL
rth,←'#define RANK(lp) ((lp)->p->r)',NL
rth,←'#define TYPE(lp) ((lp)->p->t)',NL
rth,←'#define SHAPE(lp) ((lp)->p->s)',NL
rth,←'#define ETYPE(lp) ((lp)->p->e)',NL
rth,←'#define DATA(lp) ((V*)&SHAPE(lp)[RANK(lp)])',NL
rth,←'#define CS(n,x) case n:x;break;',NL
rth,←'#define DO(n,x) {I i=0,_i=(n);for(;i<_i;++i){x;}}',NL
rth,←'#define DOB(n,x) {B i=0,_i=(n);for(;i<_i;++i){x;}}',NL
rth,←'#define NM(n,nm,sm,sd,di,mf,df,ma,da) S n##_f:FN{di;mf;df;ma;da;\',NL
rth,←' n##_f():FN(nm,sm,sd){}};',NL
rth,←'#define OM(n,nm,sm,sd,mf,df,ma,da) S n##_o:MOP{mf;df;ma;da;\',NL
rth,←' n##_o(FN&l):MOP(nm,sm,sd,l){}};\',NL
rth,←' S n##_k:MOK{V operator()(FN*&f,FN&l){f=new n##_o(l);}};',NL
rth,←'#define OD(n,nm,sm,sd,mf,df,ma,da) S n##_o:DOP{mf;df;ma;da;\',NL
rth,←' n##_o(FN&l,FN&r):DOP(nm,sm,sd,l,r){}\',NL
rth,←' n##_o(CA&l,FN&r):DOP(nm,sm,sd,l,r){}\',NL
rth,←' n##_o(FN&l,CA&r):DOP(nm,sm,sd,l,r){}};\',NL
rth,←' S n##_k:DOK{V operator()(FN*&f,FN&l,FN&r){f=new n##_o(l,r);}\',NL
rth,←'  V operator()(FN*&f,CA&l,FN&r){f=new n##_o(l,r);}\',NL
rth,←'  V operator()(FN*&f,FN&l,CA&r){f=new n##_o(l,r);}};',NL
rth,←'#define MT',NL
rth,←'#define DID inline array id(SHP)',NL
rth,←'#define MFD inline V operator()(A&,CA&,ENV&)',NL
rth,←'#define MAD inline V operator()(A&,CA&,ENV&,CA&)',NL
rth,←'#define DFD inline V operator()(A&,CA&,CA&,ENV&)',NL
rth,←'#define DAD inline V operator()(A&,CA&,CA&,ENV&,CA&)',NL
rth,←'#define DI(n) inline array n::id(SHP s)',NL
rth,←'#define ID(n,x,t) DI(n##_f){R constant(x,dim4(cnt(s)),t);}',NL
rth,←'#define MF(n) inline V n::operator()(A&z,CA&r,ENV&e)',NL
rth,←'#define MA(n) inline V n::operator()(A&z,CA&r,ENV&e,CA&ax)',NL
rth,←'#define DF(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e)',NL
rth,←'#define DA(n) inline V n::operator()(A&z,CA&l,CA&r,ENV&e,CA&ax)',NL
rth,←'#define SF(n,x) \',NL
rth,←' DF(n##_f){B lr=rnk(l),rr=rnk(r);\',NL
rth,←'  if(lr==rr){\',NL
rth,←'   DOB(rr,if(l.s[i]!=r.s[i])err(5))z.s=l.s;carr&lv=l.v;carr&rv=r.v;x;R;}\',NL
rth,←'  if(!lr){z.s=r.s;carr&rv=r.v;arr lv=tile(l.v,r.v.dims());x;R;}\',NL
rth,←'  if(!rr){z.s=l.s;carr rv=tile(r.v,l.v.dims());carr&lv=l.v;x;R;}\',NL
rth,←'  if(lr!=rr)err(4);err(99);}\',NL
rth,←' DA(n##_f){A a=l,b=r;I f=rnk(l)>rnk(r);if(f){a=r;b=l;}\',NL
rth,←'  B ar=rnk(a),br=rnk(b);B d=br-ar;B rk=cnt(ax);if(rk!=ar)err(5);\',NL
rth,←'  VEC<D> axd(rk);SHP axv(rk);ax.v.as(f64).host(axd.data());\',NL
rth,←'  DOB(rk,if(axd[i]!=rint(axd[i]))err(11))DOB(rk,axv[i]=(B)axd[i])\',NL
rth,←'  DOB(rk,if(axv[i]<0||br<=axv[i])err(11))\',NL
rth,←'  VEC<B> t(br);VEC<U8> tf(br,1);DOB(rk,B j=axv[i];tf[j]=0;t[j]=d+i)\',NL
rth,←'  B c=0;DOB(br,if(tf[i])t[i]=c++)A ta(SHP(1,br),array(br,t.data()));\',NL
rth,←'  trn_c(z,ta,b,e);rho_c(b,z,e);rho_c(a,b,a,e);\',NL
rth,←'  if(f)n##_c(b,z,a,e);else n##_c(b,a,z,e);\',NL
rth,←'  gdu_c(ta,ta,e);trn_c(z,ta,b,e);}',NL
rth,←'#define PUSH(x) s.emplace(BX(x))',NL
rth,←'#define POP(f,x) x=s.top().f;s.pop()',NL
rth,←'#define EX(x) delete x',NL
rth,←'#define EF(init,ex,fun) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\',NL
rth,←'  A cl,cr,za;fn##init##_c(za,cl,cr,e##init);\',NL
rth,←'  cpda(cr,r);cpda(cl,l);(*(*e##init[0])[fun].f)(za,cl,cr,e##init);cpad(z,za);}\',NL
rth,←' catch(U n){derr(n);}\',NL
rth,←' catch(exception e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\',NL
rth,←'EXPORT V ex##_cdf(A*z,A*l,A*r){{A il,ir,iz;fn##init##_c(iz,il,ir,e##init);}\',NL
rth,←' (*(*e##init[0])[fun].f)(*z,*l,*r,e##init);}',NL
rth,←'#define EV(init,ex,slt)',NL
rth,←'typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,',NL
rth,←' APLR,APLF,APLQ}APLTYPE;',NL
rth,←'typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;',NL
rth,←'typedef double D;typedef unsigned char U8;typedef unsigned U;',NL
rth,←'typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;',NL
rth,←'typedef VEC<dim_t> SHP;typedef array arr;typedef const array carr;',NL
rth,←'S{U f=3;U n;U x=0;const wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;',NL
rth,←'S lp{S{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];}*p;};',NL
rth,←'S dwa{B z;S{B z;V*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};',NL
rth,←'S dwa*dwafns;Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}',NL
rth,←'EXPORT I DyalogGetInterpreterFunctions(dwa*p){',NL
rth,←' if(p)dwafns=p;else R 0;if(dwafns->z<sizeof(S dwa))R 16;R 0;}',NL
rth,←'Z V err(U n,wchar_t*e){dmx.e=e;throw n;}Z V err(U n){dmx.e=L"";throw n;}',NL
rth,←'SHP eshp=SHP(0);',NL
rth,←'std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;',NL
rth,←'std::wstring msg;S BX;',NL
rth,←'typedef VEC<BX> FRM;typedef VEC<FRM*> ENV;',NL
rth,←'typedef std::stack<BX> STK;',NL
rth,←'S A{I f;SHP s;arr v;VEC<A> nv;',NL
rth,←' A(SHP s,arr v):f(1),s(s),v(v){}',NL
rth,←' A(I r,arr v):f(1),s(SHP(r)),v(v){}',NL
rth,←' A():f(0),s(SHP()),v(arr()){}};',NL
rth,←'typedef const A CA;',NL
rth,←'S FN{STR nm;I sm;I sd;FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}',NL
rth,←' FN():nm(""),sm(0),sd(0){}',NL
rth,←' virtual arr id(SHP s){err(16);R arr();}',NL
rth,←' virtual V operator()(A&z,CA&r,ENV&e){err(99);}',NL
rth,←' virtual V operator()(A&z,CA&r,ENV&e,CA&ax){err(2);}',NL
rth,←' virtual V operator()(A&z,CA&l,CA&r,ENV&e){err(99);}',NL
rth,←' virtual V operator()(A&z,CA&l,CA&r,ENV&e,CA&ax){err(2);}};',NL
rth,←'FN MTFN;',NL
rth,←'S MOP:FN{FN&ll;',NL
rth,←' MOP(STR nm,I sm,I sd,FN&ll):FN(nm,sm,sd),ll(ll){}};',NL
rth,←'S DOP:FN{I fl;I fr;FN&ll;A aa;FN&rr;A ww;',NL
rth,←' DOP(STR nm,I sm,I sd,FN&l,FN&r)',NL
rth,←'  :FN(nm,sm,sd),fl(1),fr(1),ll(l),aa(A()),rr(r),ww(A()){}',NL
rth,←' DOP(STR nm,I sm,I sd,A l,FN&r)',NL
rth,←'  :FN(nm,sm,sd),fl(0),fr(1),ll(MTFN),aa(l),rr(r),ww(A()){}',NL
rth,←' DOP(STR nm,I sm,I sd,FN&l,A r)',NL
rth,←'  :FN(nm,sm,sd),fl(1),fr(0),ll(l),aa(A()),rr(MTFN),ww(r){}};',NL
rth,←'S MOK{virtual V operator()(FN*&f,FN&l){err(99);}};',NL
rth,←'S DOK{virtual V operator()(FN*&f,FN&l,FN&r){err(99);}',NL
rth,←' virtual V operator()(FN*&f,CA&l,FN&r){err(99);}',NL
rth,←' virtual V operator()(FN*&f,FN&l,CA&r){err(99);}};',NL
rth,←'S BX{A v;union{FN*f;MOK*m;DOK*d;};',NL
rth,←' BX(){}BX(FN*f):f(f){}BX(CA&v):v(v){}BX(MOK*m):m(m){}BX(DOK*d):d(d){}};',NL
rth,←'',NL
rth,←'std::wstring mkstr(const char*s){R strconv.from_bytes(s);}',NL
rth,←'I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}',NL
rth,←'I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}',NL
rth,←'B rnk(const A&a){R a.s.size();}',NL
rth,←'B cnt(SHP s){B c=1;DOB(s.size(),c*=s[i]);R c;}',NL
rth,←'B cnt(const A&a){B c=1;DOB(rnk(a),c*=a.s[i]);R c;}',NL
rth,←'B cnt(lp*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}',NL
rth,←'array scl(D x){R constant(x,dim4(1),f64);}',NL
rth,←'array scl(I x){R constant(x,dim4(1),s32);}',NL
rth,←'A scl(array v){R A(0,v);}',NL
rth,←'dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;',NL
rth,←' if(at==f64||bt==f64)R f64;',NL
rth,←' if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;',NL
rth,←' if(at==b8||bt==b8)R b8;err(16);R f64;}',NL
rth,←'dtype mxt(const array&a,const array&b){R mxt(a.type(),b.type());}',NL
rth,←'dtype mxt(dtype at,const A&b){R mxt(at,b.v.type());}',NL
rth,←'Z array da16(B c,lp*d){std::vector<S16>b(c);S8*v=(S8*)DATA(d);',NL
rth,←' DOB(c,b[i]=v[i]);R array(c,b.data());}',NL
rth,←'Z array da8(B c,lp*d){std::vector<char>b(c);U8*v=(U8*)DATA(d);',NL
rth,←' DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))R array(c,b.data());}',NL
rth,←'V cpad(lp*d,A&a){I t;B c=cnt(a),ar=rnk(a);if(!a.f){d->p=NULL;R;}',NL
rth,←' switch(a.v.type()){CS(c64,t=APLZ);',NL
rth,←'  CS(s32,t=APLI);CS(s16,t=APLSI);CS(b8,t=APLTI);CS(f64,t=APLD);',NL
rth,←'  default:if(c)err(16);t=APLI;}',NL
rth,←' if(ar>15)err(16);B s[15];DOB(ar,s[ar-i-1]=a.s[i]);dwafns->ws->ga(t,(U)ar,s,d);',NL
rth,←' if(c)a.v.host(DATA(d));}',NL
rth,←'V cpda(A&a,lp*d){if(d==NULL)R;if(15!=TYPE(d))err(16);a.f=1;a.v=scl(0);',NL
rth,←' a.s=SHP(RANK(d));DO(RANK(d),a.s[RANK(d)-i-1]=SHAPE(d)[i]);B c=cnt(d);',NL
rth,←' if(c){',NL
rth,←'  switch(ETYPE(d)){',NL
rth,←'   CS(APLZ ,a.v=array(c,(DZ*)DATA(d))) CS(APLI ,a.v=array(c,(I*)DATA(d)))',NL
rth,←'   CS(APLD ,a.v=array(c,(D*)DATA(d)))  CS(APLSI,a.v=array(c,(S16*)DATA(d)))',NL
rth,←'   CS(APLTI,a.v=da16(c,d))             CS(APLU8,a.v=da8(c,d))',NL
rth,←'   default:err(16);}}}',NL
rth,←'inline I isint(D x){R x!=nearbyint(x);}',NL
rth,←'inline I isint(A x){R x.v.isinteger()||x.v.isbool()',NL
rth,←'  ||(x.v.isreal()&&allTrue<I>(x.v==trunc(x.v)));}',NL
rth,←'inline I isbool(A x){R x.v.isbool()',NL
rth,←'  ||(x.v.isreal()&&allTrue<I>(x.v==0||x.v==1));}',NL
rth,←'EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}',NL
rth,←'EXPORT V frea(A*a){delete a;}',NL
rth,←'EXPORT V exarray(lp*d,A*a){cpad(d,*a);}',NL
rth,←'EXPORT V afsync(){sync();}',NL
rth,←'EXPORT Window *w_new(char *k){R new Window(k);}',NL
rth,←'EXPORT I w_close(Window*w){R w->close();}',NL
rth,←'EXPORT V w_del(Window*w){delete w;}',NL
rth,←'EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);',NL
rth,←' w->image(a.v.as(rnk(a)==2?f32:u8));}',NL
rth,←'EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);w->plot(a.v.as(f32));}',NL
rth,←'EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);',NL
rth,←' w->hist(a.v.as(u32),l,h);}',NL
rth,←'EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);',NL
rth,←' I rk=a.numdims();dim4 s=a.dims();',NL
rth,←' A b(rk,flat(a).as(s16));DO(rk,b.s[i]=s[i])cpad(z,b);}',NL
rth,←'EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);',NL
rth,←' saveImageNative(p,a.v.as(a.v.type()==s32?u16:u8));}',NL
rth,←'EXPORT V cd_sync(V){sync();}',NL
rtn[0],←⊂'NM(add,"add",1,1,DID,MFD,DFD,MT,DAD)',NL
rtn[0],←⊂'add_f add_c;',NL
rtn[0],←⊂'ID(add,0,s32)',NL
rtn[0],←⊂'MF(add_f){z=r;}',NL
rtn[0],←⊂'SF(add,z.v=lv+rv)',NL
rtn[1],←⊂'NM(sub,"sub",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[1],←⊂'sub_f sub_c;',NL
rtn[1],←⊂'ID(sub,0,s32)',NL
rtn[1],←⊂'MF(sub_f){z.s=r.s;z.v=-r.v;}',NL
rtn[1],←⊂'SF(sub,z.v=lv-rv)',NL
rtn[1],←⊂'',NL
rtn[2],←⊂'NM(mul,"mul",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[2],←⊂'mul_f mul_c;',NL
rtn[2],←⊂'ID(mul,1,s32)',NL
rtn[2],←⊂'MF(mul_f){z.s=r.s;z.v=(r.v>0)-(r.v<0);}',NL
rtn[2],←⊂'SF(mul,z.v=lv*rv)',NL
rtn[2],←⊂'',NL
rtn[3],←⊂'NM(div,"div",1,1,DID,MFD,DFD,MT,DAD)',NL
rtn[3],←⊂'div_f div_c;',NL
rtn[3],←⊂'ID(div,1,s32)',NL
rtn[3],←⊂'MF(div_f){z.s=r.s;z.v=1.0/r.v.as(f64);}',NL
rtn[3],←⊂'SF(div,z.v=lv.as(f64)/rv.as(f64))',NL
rtn[4],←⊂'NM(exp,"exp",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[4],←⊂'ID(exp,1,s32)',NL
rtn[4],←⊂'exp_f exp_c;',NL
rtn[4],←⊂'MF(exp_f){z.s=r.s;z.v=exp(r.v.as(f64));}',NL
rtn[4],←⊂'SF(exp,z.v=pow(lv.as(f64),rv.as(f64)))',NL
rtn[4],←⊂'',NL
rtn[5],←⊂'NM(log,"log",1,1,MT ,MFD,DFD,MT ,DAD)',NL
rtn[5],←⊂'log_f log_c;',NL
rtn[5],←⊂'MF(log_f){z.s=r.s;z.v=log(r.v.as(f64));}',NL
rtn[5],←⊂'SF(log,z.v=log(rv.as(f64))/log(lv.as(f64)))',NL
rtn[5],←⊂'',NL
rtn[6],←⊂'NM(res,"res",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[6],←⊂'res_f res_c;',NL
rtn[6],←⊂'ID(res,0,s32)',NL
rtn[6],←⊂'MF(res_f){z.s=r.s;z.v=abs(r.v).as(r.v.type());}',NL
rtn[6],←⊂'SF(res,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))',NL
rtn[6],←⊂'',NL
rtn[7],←⊂'NM(cir,"cir",1,1,MT,MFD,DFD,MT,DAD)',NL
rtn[7],←⊂'cir_f cir_c;',NL
rtn[7],←⊂'MF(cir_f){z.s=r.s;z.v=Pi*r.v.as(f64);}',NL
rtn[7],←⊂'SF(cir,arr fv=rv.as(f64);',NL
rtn[7],←⊂' if(!lr){I x=l.v.as(s32).scalar<I>();if(abs(x)>10)err(16);',NL
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
rtn[8],←⊂'min_f min_c;',NL
rtn[8],←⊂'ID(min,DBL_MAX,f64)',NL
rtn[8],←⊂'MF(min_f){z.s=r.s;z.v=floor(r.v).as(r.v.type());}',NL
rtn[8],←⊂'SF(min,z.v=min(lv,rv))',NL
rtn[8],←⊂'',NL
rtn[9],←⊂'NM(max,"max",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[9],←⊂'max_f max_c;',NL
rtn[9],←⊂'ID(max,-DBL_MAX,f64)',NL
rtn[9],←⊂'MF(max_f){z.s=r.s;z.v=ceil(r.v).as(r.v.type());}',NL
rtn[9],←⊂'SF(max,z.v=max(lv,rv))',NL
rtn[9],←⊂'',NL
rtn[10],←⊂'NM(fac,"fac",1,1,DID,MFD,DFD,MT ,DAD)',NL
rtn[10],←⊂'fac_f fac_c;',NL
rtn[10],←⊂'ID(fac,1,s32)',NL
rtn[10],←⊂'MF(fac_f){z.s=r.s;z.v=factorial(r.v.as(f64));}',NL
rtn[10],←⊂'SF(fac,arr lvf=lv.as(f64);arr rvf=rv.as(f64);',NL
rtn[10],←⊂' z.v=exp(lgamma(1+rvf)-(lgamma(1+lvf)+lgamma(1+rvf-lvf))))',NL
rtn[11],←⊂'NM(lth,"lth",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[11],←⊂'lth_f lth_c;',NL
rtn[11],←⊂'ID(lth,0,s32)',NL
rtn[11],←⊂'SF(lth,z.v=lv<rv)',NL
rtn[11],←⊂'',NL
rtn[12],←⊂'NM(lte,"lte",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[12],←⊂'lte_f lte_c;',NL
rtn[12],←⊂'ID(lte,1,s32)',NL
rtn[12],←⊂'SF(lte,z.v=lv<=rv)',NL
rtn[12],←⊂'',NL
rtn[13],←⊂'NM(eql,"eql",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[13],←⊂'eql_f eql_c;',NL
rtn[13],←⊂'ID(eql,1,s32)',NL
rtn[13],←⊂'SF(eql,z.v=lv==rv)',NL
rtn[14],←⊂'NM(gte,"gte",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[14],←⊂'gte_f gte_c;',NL
rtn[14],←⊂'ID(gte,1,s32)',NL
rtn[14],←⊂'SF(gte,z.v=lv>=rv)',NL
rtn[14],←⊂'',NL
rtn[15],←⊂'NM(gth,"gth",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[15],←⊂'gth_f gth_c;',NL
rtn[15],←⊂'ID(gth,0,s32)',NL
rtn[15],←⊂'SF(gth,z.v=lv>rv)',NL
rtn[15],←⊂'',NL
rtn[16],←⊂'NM(neq,"neq",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[16],←⊂'neq_f neq_c;',NL
rtn[16],←⊂'ID(neq,0,s32)',NL
rtn[16],←⊂'SF(neq,z.v=lv!=rv)',NL
rtn[16],←⊂'',NL
rtn[17],←⊂'NM(not,"not",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[17],←⊂'not_f not_c;',NL
rtn[17],←⊂'MF(not_f){z.s=r.s;z.v=!r.v;}',NL
rtn[17],←⊂'DF(not_f){err(16);}',NL
rtn[17],←⊂'',NL
rtn[18],←⊂'NM(and,"and",1,1,DID,MT,DFD,MT,DAD)',NL
rtn[18],←⊂'and_f and_c;',NL
rtn[18],←⊂'ID(and,1,s32)',NL
rtn[18],←⊂'SF(and,if(lv.isbool()&&rv.isbool())z.v=lv&&rv;',NL
rtn[18],←⊂' else if(allTrue<I>(lv>=0&&lv<=1&&rv>0&&rv<=1))z.v=lv&&rv;',NL
rtn[18],←⊂' else{A a(z.r,z.s,lv);A b(z.r,z.s,rv);',NL
rtn[18],←⊂'  lor_c(a,a,b,e);z.v=lv.as(f64)*(rv/((!a.v)+a.v));})',NL
rtn[19],←⊂'NM(lor,"lor",1,1,DID,MT ,DFD,MT ,DAD)',NL
rtn[19],←⊂'lor_f lor_c;',NL
rtn[19],←⊂'ID(lor,0,s32)',NL
rtn[19],←⊂'SF(lor,if(rv.isbool()&&lv.isbool())z.v=lv||rv;',NL
rtn[19],←⊂' else if(lv.isbool()&&rv.isinteger())z.v=lv+(!lv)*abs(rv).as(rv.type());',NL
rtn[19],←⊂' else if(rv.isbool()&&lv.isinteger())z.v=rv+(!rv)*abs(lv).as(lv.type());',NL
rtn[19],←⊂' else if(lv.isinteger()&&rv.isinteger()){B c=cnt(z);',NL
rtn[19],←⊂'  std::vector<I> a(c);abs(lv).as(s32).host(a.data());',NL
rtn[19],←⊂'  std::vector<I> b(c);abs(rv).as(s32).host(b.data());',NL
rtn[19],←⊂'  DOB(c,while(b[i]){I t=b[i];b[i]=a[i]%b[i];a[i]=t;})',NL
rtn[19],←⊂'  z.v=array(z.s,a.data());}',NL
rtn[19],←⊂' else{B c=cnt(z);',NL
rtn[19],←⊂'  std::vector<D> a(c);abs(lv).as(f64).host(a.data());',NL
rtn[19],←⊂'  std::vector<D> b(c);abs(rv).as(f64).host(b.data());',NL
rtn[19],←⊂'  DOB(c,while(b[i]>1e-12){D t=b[i];b[i]=fmod(a[i],b[i]);a[i]=t;})',NL
rtn[19],←⊂'  z.v=array(z.s,a.data());})',NL
rtn[19],←⊂'',NL
rtn[20],←⊂'NM(nan,"nan",1,1,MT ,MT ,DFD,MT ,DAD)',NL
rtn[20],←⊂'nan_f nan_c;',NL
rtn[20],←⊂'SF(nan,z.v=!(lv&&rv))',NL
rtn[20],←⊂'',NL
rtn[21],←⊂'NM(nor,"nor",1,1,MT ,MT ,DFD,MT ,DAD)',NL
rtn[21],←⊂'nor_f nor_c;',NL
rtn[21],←⊂'SF(nor,z.v=!(lv||rv))',NL
rtn[22],←⊂'NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,DAD)',NL
rtn[22],←⊂'sqd_f sqd_c;',NL
rtn[22],←⊂'MF(sqd_f){z=r;}',NL
rtn[22],←⊂'DA(sqd_f){if(ax.r>1)err(4);if(!isint(ax))err(11);I av[4];ax.v.as(s32).host(av);',NL
rtn[22],←⊂' B ac=cnt(ax);DOB(ac,if(av[i]<0)err(11))DOB(ac,if(av[i]>=r.r)err(4))',NL
rtn[22],←⊂' B lc=cnt(l);if(lc!=ac)err(5);if(!lc){z=r;R;};af::index x[4];',NL
rtn[22],←⊂' I m[]={0,0,0,0};DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',NL
rtn[22],←⊂' if(!isint(l))err(11);I lv[4];l.v.as(s32).host(lv);',NL
rtn[22],←⊂' DOB(lc,if(lv[i]<0||lv[i]>=r.s[r.r-av[i]-1])err(3))',NL
rtn[22],←⊂' z.r=r.r-(I)lc;z.s=dim4(1);I j=0;DO(r.r,if(!m[r.r-i-1])z.s[j++]=r.s[i])',NL
rtn[22],←⊂' DOB(lc,x[r.r-av[i]-1]=lv[i]);z.v=r.v(x[0],x[1],x[2],x[3]);}',NL
rtn[22],←⊂'DF(sqd_f){A ax;iot_c(ax,scl(scl((I)cnt(l))),e);sqd_c(z,l,r,e,ax);}',NL
rtn[23],←⊂'NM(brk,"brk",0,0,MT,MT,DFD,MT,MT)',NL
rtn[23],←⊂'brk_f brk_c;',NL
rtn[23],←⊂'DF(brk_f){B lr=rnk(l);const std::vector<A>&rv=r.nv;B rl=rv.size();',NL
rtn[23],←⊂' if(!rl){if(lr!=1)err(4);z=l;R;}',NL
rtn[23],←⊂' if(rl!=lr)err(4);B zr=0;DOB(rl,zr+=rnk(rv[i]))B s=zr;z.s=SHP(zr,1);',NL
rtn[23],←⊂' DOB(rl,B j=i;B k=rnk(rv[j]);s-=k;',NL
rtn[23],←⊂'  DOB(k,z.s[s+i]=(k==rnk(rv[j]))?rv[j].s[i]:l.s[rl-j-1]))',NL
rtn[23],←⊂' if(zr<=4){index x[4];DOB(rl,if(rnk(rv[i])>=0)x[rl-i-1]=rv[i].v.as(s32))',NL
rtn[23],←⊂'  dim4 sp;DO((I)lr,sp[i]=l.s[i])z.v=moddims(l.v,sp)(x[0],x[1],x[2],x[3]);R;}',NL
rtn[23],←⊂' err(16);}',NL
rtn[23],←⊂'',NL
rtn[23],←⊂'OD(brk,"brk",scm(l),scd(l),MFD,DFD,MT ,MT )',NL
rtn[23],←⊂'MF(brk_o){if(rnk(ww)>1)err(4);ll(z,r,e,ww);}',NL
rtn[23],←⊂'DF(brk_o){if(rnk(ww)>1)err(4);ll(z,l,r,e,ww);}',NL
rtn[23],←⊂'',NL
rtn[24],←⊂'NM(iot,"iot",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[24],←⊂'iot_f iot_c;',NL
rtn[24],←⊂'MF(iot_f){if(r.r>1)err(4);B c=cnt(r);if(c>4)err(10);',NL
rtn[24],←⊂' if(c>1)err(16);',NL
rtn[24],←⊂' z.r=1;z.s=dim4(r.v.as(s32).scalar<I>());',NL
rtn[24],←⊂' z.v=z.s[0]?iota(z.s,dim4(1),s32):scl(0);}',NL
rtn[24],←⊂'DF(iot_f){z.r=r.r;z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}',NL
rtn[24],←⊂' I lc=(I)cnt(l)+1;if(lc==1){z.v=constant(0,cnt(r),s16);R;};if(l.r>1)err(16);',NL
rtn[24],←⊂' array lv,ix,rv;sort(lv,ix,l.v);rv=flat(r.v);z.v=constant(0,cnt(r),s32);',NL
rtn[24],←⊂' for(I h;h=lc/2;lc-=h){array t=z.v+h;replace(z.v,lv(t)>rv,t);}',NL
rtn[24],←⊂' z.v=array(select(lv(z.v)==rv,ix(z.v).as(s32),(I)cnt(l)),z.s);}',NL
rtn[25],←⊂'NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[25],←⊂'rho_f rho_c;',NL
rtn[25],←⊂'MF(rho_f){B rr=rnk(r);VEC<I> sp(rr);DOB(rr,sp[rr-i-1]=(I)r.s[i])',NL
rtn[25],←⊂' z.s=SHP(1,rr);if(!cnt(z)){z.v=scl(0);R;}z.v=array(rr,sp.data());}',NL
rtn[25],←⊂'DF(rho_f){B cr=cnt(r);B cl=cnt(l);SHP s(cl);',NL
rtn[25],←⊂' if(rnk(l)>1)err(11);if(!isint(l))err(11);l.v.as(s64).host(s.data());',NL
rtn[25],←⊂' z.s=SHP(cl);DOB(cl,z.s[i]=s[cl-i-1])B cz=cnt(z);if(!cz){z.v=scl(0);R;}',NL
rtn[25],←⊂' z.v=array(cz==cr?r.v:r.v(iota(cz)%cr));}',NL
rtn[26],←⊂'NM(cat,"cat",0,0,MT ,MFD,DFD,MAD,DAD)',NL
rtn[26],←⊂'cat_f cat_c;',NL
rtn[26],←⊂'MF(cat_f){z.r=1;z.s=dim4(cnt(r));z.v=flat(r.v);}',NL
rtn[26],←⊂'MA(cat_f){B ac=cnt(ax);if(ac>1&&ax.r>1)err(4);D axv[4];ax.v.as(f64).host(axv);',NL
rtn[26],←⊂' if(ac==1&&(*axv<=-1||r.r<=*axv))err(4);',NL
rtn[26],←⊂' if(ac>1){I c=(I)axv[0];if(c<0)err(11);DO((I)ac,if(axv[i]!=c++)err(11))',NL
rtn[26],←⊂'  if(c>r.r)err(4);}',NL
rtn[26],←⊂' I xt=(!ac||(ac==1&&isint(axv[0])));if(r.r==4&&xt)err(16);',NL
rtn[26],←⊂' z=r;if(!xt&&ac==1)R;DO((I)ac,axv[i]=ceil(z.r-axv[i]-1))',NL
rtn[26],←⊂' if(xt){z.r++;I pt=ac?(I)axv[0]:0;DO(3-pt,z.s[3-i]=z.s[2-i])z.s[pt]=1;',NL
rtn[26],←⊂'  z.v=moddims(z.v,z.s);R;}',NL
rtn[26],←⊂' I s=(I)axv[ac-1],ei=(I)axv[0],c=1;',NL
rtn[26],←⊂' DO((I)ac-1,z.s[s]*=z.s[s+i+1])DO(z.r-ei-1,z.s[s+i+1]=z.s[ei+i+1])',NL
rtn[26],←⊂' z.r-=(I)ac-1;DO(4-z.r,z.s[z.r+i]=1)z.v=moddims(z.v,z.s);}',NL
rtn[26],←⊂'DA(cat_f){if(ax.r>1)err(4);if(cnt(ax)!=1)err(5);D ox=ax.v.as(f64).scalar<D>();',NL
rtn[26],←⊂' I rk=l.r>r.r?l.r:r.r;if(ox<=-1)err(11);if(ox>=rk)err(4);',NL
rtn[26],←⊂' if(l.r&&r.r&&std::abs((I)l.r-(I)r.r)>1)err(4);',NL
rtn[26],←⊂' A nl=l,nr=r;D axv=rk-ox-1;I fx=(I)ceil(axv);',NL
rtn[26],←⊂' if(axv!=fx){if(r.r>3||l.r>3)err(16);if(r.r&&l.r&&l.r!=r.r)err(4);',NL
rtn[26],←⊂'  if(l.r)cat_c(nl,l,e,ax);if(r.r)cat_c(nr,r,e,ax);',NL
rtn[26],←⊂'  if(!l.r&&!r.r)cat_c(nl,l,e,ax);cat_c(nr,r,e,ax);',NL
rtn[26],←⊂'  cat_c(z,nl,nr,e,scl(scl((I)ceil(ox))));R;}',NL
rtn[26],←⊂' z.r=(l.r>=r.r)*l.r+(r.r>l.r)*r.r+(!r.r&&!l.r);',NL
rtn[26],←⊂' dim4 ls=l.s;dim4 rs=r.s;',NL
rtn[26],←⊂' if(!l.r){ls=rs;ls[fx]=1;}if(!r.r){rs=ls;rs[fx]=1;}',NL
rtn[26],←⊂' if(r.r&&l.r>r.r){DO(3-fx,rs[3-i]=rs[3-(i+1)]);rs[fx]=1;}',NL
rtn[26],←⊂' if(l.r&&r.r>l.r){DO(3-fx,ls[3-i]=ls[3-(i+1)]);ls[fx]=1;}',NL
rtn[26],←⊂' DO(4,if(i!=fx&&rs[i]!=ls[i])err(5));',NL
rtn[26],←⊂' DO(4,z.s[i]=(l.r>=r.r||i==fx)*ls[i]+(r.r>l.r||i==fx)*rs[i]);',NL
rtn[26],←⊂' dtype mt=mxt(r.v,l.v);',NL
rtn[26],←⊂' array lv=(l.r?moddims(l.v,ls):tile(l.v,ls)).as(mt);',NL
rtn[26],←⊂' array rv=(r.r?moddims(r.v,rs):tile(r.v,rs)).as(mt);',NL
rtn[26],←⊂' if(!cnt(l)){z.v=rv;R;}if(!cnt(r)){z.v=lv;R;}',NL
rtn[26],←⊂' z.v=join(fx,lv,rv);}',NL
rtn[26],←⊂'DF(cat_f){if(l.r||r.r){cat_c(z,l,r,e,scl(scl((l.r>r.r?l.r:r.r)-1)));R;}',NL
rtn[26],←⊂' A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}',NL
rtn[27],←⊂'NM(ctf,"ctf",0,0,MT,MFD,DFD,MT,DAD)',NL
rtn[27],←⊂'ctf_f ctf_c;',NL
rtn[27],←⊂'MF(ctf_f){dim4 sp=z.s;sp[1]=r.r?r.s[r.r-1]:1;sp[0]=sp[1]?cnt(r)/sp[1]:1;',NL
rtn[27],←⊂' sp[2]=sp[3]=1;z.r=2;z.s=sp;z.v=!cnt(z)?scl(0):array(r.v,z.s);}',NL
rtn[27],←⊂'DA(ctf_f){cat_c(z,l,r,e,ax);}',NL
rtn[27],←⊂'DF(ctf_f){if(l.r||r.r){cat_c(z,l,r,e,scl(scl(0)));R;}',NL
rtn[27],←⊂' A a,b;cat_c(a,l,e);cat_c(b,r,e);cat_c(z,a,b,e);}',NL
rtn[28],←⊂'NM(rot,"rot",0,0,DID,MFD,DFD,MAD,DAD)',NL
rtn[28],←⊂'rot_f rot_c;',NL
rtn[28],←⊂'ID(rot,0,s32)',NL
rtn[28],←⊂'MF(rot_f){z.r=r.r;z.s=r.s;z.v=flip(r.v,0);}',NL
rtn[28],←⊂'MA(rot_f){if(1!=cnt(ax))err(5);if(!ax.v.isinteger())err(11);',NL
rtn[28],←⊂' I axv=ax.v.as(s32).scalar<I>();if(axv<0||r.r<=axv)err(4);',NL
rtn[28],←⊂' z.r=r.r;z.s=r.s;z.v=flip(r.v,r.r-(1+axv));}',NL
rtn[28],←⊂'DA(rot_f){if(ax.r>1||cnt(ax)!=1)err(5);if(!ax.v.isinteger())err(11);',NL
rtn[28],←⊂' I ra=ax.v.as(s32).scalar<I>();if(ra<0)err(11);if(ra>=r.r)err(4);',NL
rtn[28],←⊂' B lc=cnt(l);I aa=ra;ra=r.r-ra-1;if(lc!=1&&l.r!=r.r-1)err(4);',NL
rtn[28],←⊂' if(lc==1){I ix[]={0,0,0,0};z.r=r.r;z.s=r.s;ix[ra]=-l.v.as(s32).scalar<I>();',NL
rtn[28],←⊂'  z.v=shift(r.v,ix[0],ix[1],ix[2],ix[3]);R;}',NL
rtn[28],←⊂' I j=0;DO(l.r,if(i==ra)j++;if(l.s[i]!=r.s[j++])err(5))',NL
rtn[28],←⊂' res_c(z,scl(scl((D)r.s[ra])),l,e);B tc=1;DO(ra,tc*=r.s[i])z.v*=tc;',NL
rtn[28],←⊂' cat_c(z,z,e,scl(scl(aa-.5)));I ix[]={1,1,1,1};ix[ra]=(I)r.s[ra];',NL
rtn[28],←⊂' z.v=tile(z.v,ix[0],ix[1],ix[2],ix[3]);z.s[ra]=r.s[ra];',NL
rtn[28],←⊂' dim4 s1(1),s2(1);DO(ra+1,s1[i]=r.s[i])DO(r.r-ra-1,s2[ra+i+1]=r.s[ra+i+1])',NL
rtn[28],←⊂' z.v+=iota(s1,s2);res_c(z,scl(scl((D)tc*r.s[ra])),z,e);',NL
rtn[28],←⊂' z.v=r.v(z.v+(tc*r.s[ra])*iota(s2,s1));}',NL
rtn[28],←⊂'DF(rot_f){if(!r.r){B lc=cnt(l);if(lc!=1&&l.r)err(4);z=r;R;}',NL
rtn[28],←⊂' rot_c(z,l,r,e,scl(scl(r.r-1)));}',NL
rtn[29],←⊂'NM(trn,"trn",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[29],←⊂'trn_f trn_c;',NL
rtn[29],←⊂'MF(trn_f){B rr=rnk(r);A t(SHP(1,rr),flip(range(dim4(rr),s32),0));',NL
rtn[29],←⊂' trn_c(z,t,r,e);}',NL
rtn[29],←⊂'DF(trn_f){B lr=rnk(l),rr=rnk(r);if(lr>1||cnt(l)!=rr)err(5);VEC<I> lv(rr);',NL
rtn[29],←⊂' if(!isint(l))err(11);l.v.as(s32).host(lv.data());',NL
rtn[29],←⊂' DOB(rr,if(lv[i]<0||lv[i]>=rr)err(4))VEC<U8> f(rr,0);DOB(rr,f[lv[i]]=1)',NL
rtn[29],←⊂' U8 t=1;DOB(rr,if(t&&!f[i])t=0;else if(!t&&f[i])err(5))',NL
rtn[29],←⊂' if(t&&rr<=4){z.s=SHP(rr);DOB(rr,z.s[rr-lv[i]-1]=r.s[rr-i-1])',NL
rtn[29],←⊂'  switch(rr){case 0:case 1:z.v=r.v;R;}VEC<I> s;DOB(rr,s[rr-lv[i]-1]=(I)(rr-i-1))',NL
rtn[29],←⊂'  dim4 rs;DO((I)rr,rs[i]=r.s[i])arr rv=moddims(r.v,rs);',NL
rtn[29],←⊂'  switch(rr){CS(2,z.v=flat(reorder(rv,s[0],s[1])))',NL
rtn[29],←⊂'   CS(3,z.v=flat(reorder(rv,s[0],s[1],s[2])))',NL
rtn[29],←⊂'   CS(4,z.v=flat(reorder(rv,s[0],s[1],s[2],s[3])))}}',NL
rtn[29],←⊂' else{B rk=0;DOB(rr,if(rk<lv[i])rk=lv[i])rk++;z.s=SHP(rk,LLONG_MAX);',NL
rtn[29],←⊂'  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;if(z.s[j]>r.s[k])z.s[j]=r.s[k])',NL
rtn[29],←⊂'  SHP zs(rk),rs(rr);',NL
rtn[29],←⊂'  B c=1;DOB(rk,zs[i]=c;c*=z.s[i])c=1;DOB(rr,rs[i]=c;c*=r.s[i])c=cnt(z);',NL
rtn[29],←⊂'  arr ix=iota(dim4(c),dim4(1),s32),jx=constant(0,dim4(c),s32);',NL
rtn[29],←⊂'  DOB(rr,B j=rk-lv[i]-1;B k=rr-i-1;jx+=rs[k]*((ix/zs[j])%z.s[j]))',NL
rtn[29],←⊂'  z.v=r.v(jx);}}',NL
rtn[30],←⊂'NM(rtf,"rtf",0,0,DID,MFD,DFD,MAD,DAD)',NL
rtn[30],←⊂'rtf_f rtf_c;',NL
rtn[30],←⊂'ID(rtf,0,s32)',NL
rtn[30],←⊂'MF(rtf_f){z.r=r.r;z.s=r.s;z.v=r.r?flip(r.v,r.r-1):r.v;}',NL
rtn[30],←⊂'MA(rtf_f){if(1!=cnt(ax))err(5);if(!ax.v.isinteger())err(11);',NL
rtn[30],←⊂' I axv=ax.v.as(s32).scalar<I>();if(axv<0||r.r<=axv)err(4);',NL
rtn[30],←⊂' z.r=r.r;z.s=r.s;z.v=flip(r.v,r.r-(1+axv));}',NL
rtn[30],←⊂'DA(rtf_f){rot_c(z,l,r,e,ax);}',NL
rtn[30],←⊂'DF(rtf_f){if(!r.r){B lc=cnt(l);if(lc!=1&&l.r)err(4);z=r;R;}',NL
rtn[30],←⊂' rot_c(z,l,r,e,scl(scl(0)));}',NL
rtn[31],←⊂'NM(mem,"mem",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[31],←⊂'mem_f mem_c;',NL
rtn[31],←⊂'MF(mem_f){z.s=SHP(1,cnt(r));z.v=r.v;}',NL
rtn[31],←⊂'DF(mem_f){z.s=l.s;B lc=cnt(z);if(!lc){z.v=scl(0);R;}',NL
rtn[31],←⊂' if(!cnt(r)){z.v=arr(lc,b8);z.v=0;R;}',NL
rtn[31],←⊂' arr y=setUnique(r.v);B rc=y.elements();',NL
rtn[31],←⊂' arr x=arr(l.v,lc,1);y=arr(y,1,rc);',NL
rtn[31],←⊂' z.v=arr(anyTrue(tile(x,1,(I)rc)==tile(y,(I)lc,1),1),lc);}',NL
rtn[31],←⊂'',NL
rtn[32],←⊂'NM(dis,"dis",0,0,MT,MFD,DFD,MT,MT)',NL
rtn[32],←⊂'dis_f dis_c;',NL
rtn[32],←⊂'MF(dis_f){z.r=0;z.s=eshp;z.v=r.v(0);}',NL
rtn[32],←⊂'DF(dis_f){if(l.v.isfloating())err(1);if(l.r>1)err(4);',NL
rtn[32],←⊂' B lc=cnt(l);if(!lc){z=r;R;}if(lc!=1||r.r!=1)err(4);',NL
rtn[32],←⊂' if(allTrue<char>(cnt(r)<=l.v(0)))err(3);',NL
rtn[32],←⊂' z.r=0;z.s=eshp;array i=l.v(0);z.v=r.v(i);}',NL
rtn[33],←⊂'NM(eqv,"eqv",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[33],←⊂'eqv_f eqv_c;',NL
rtn[33],←⊂'MF(eqv_f){z.r=0;z.s=eshp;z.v=scl(r.r!=0);}',NL
rtn[33],←⊂'DF(eqv_f){z.r=0;z.s=eshp;',NL
rtn[33],←⊂' if(l.r==r.r&&l.s==r.s){z.v=allTrue(l.v==r.v);R;}z.v=scl(0);}',NL
rtn[33],←⊂'',NL
rtn[34],←⊂'NM(nqv,"nqv",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[34],←⊂'nqv_f nqv_c;',NL
rtn[34],←⊂'MF(nqv_f){z.v=scl(r.r?(I)r.s[r.r-1]:1);z.r=0;z.s=dim4(1);}',NL
rtn[34],←⊂'DF(nqv_f){z.r=0;z.s=eshp;I t=l.r==r.r&&l.s==r.s;',NL
rtn[34],←⊂' if(t)t=allTrue<I>(l.v==r.v);z.v=scl(!t);}',NL
rtn[34],←⊂'',NL
rtn[35],←⊂'NM(rgt,"rgt",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[35],←⊂'rgt_f rgt_c;',NL
rtn[35],←⊂'MF(rgt_f){z=r;}',NL
rtn[35],←⊂'DF(rgt_f){z=r;}',NL
rtn[35],←⊂'',NL
rtn[36],←⊂'NM(lft,"lft",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[36],←⊂'lft_f lft_c;',NL
rtn[36],←⊂'MF(lft_f){z=r;}',NL
rtn[36],←⊂'DF(lft_f){z=l;}',NL
rtn[36],←⊂'',NL
rtn[37],←⊂'NM(enc,"enc",0,0,DID,MT ,DFD,MT ,MT )',NL
rtn[37],←⊂'enc_f enc_c;',NL
rtn[37],←⊂'ID(enc,0,s32)',NL
rtn[37],←⊂'DF(enc_f){I rk=r.r+l.r;if(rk>4)err(16);dim4 sp=r.s;DO(l.r,sp[i+r.r]=l.s[i])',NL
rtn[37],←⊂' if(!cnt(sp)){z.r=rk;z.s=sp;z.v=scl(0);R;}dim4 lt=sp,rt=sp;I k=l.r?l.r-1:0;',NL
rtn[37],←⊂' DO(r.r,rt[i]=1)DO(l.r,lt[i+r.r]=1)array rv=tile(r.v,rt);z.r=rk;z.s=sp;',NL
rtn[37],←⊂' array sv=flip(scan(flip(l.v,k),k,AF_BINARY_MUL),k);',NL
rtn[37],←⊂' array lv=tile(array(sv,rt),lt);af::index x[4];x[k]=0;',NL
rtn[37],←⊂' array dv=sv;dv(x[0],x[1],x[2],x[3])=1;I s[]={0,0,0,0};s[k]=-1;',NL
rtn[37],←⊂' dv=shift(dv,s[0],s[1],s[2],s[3]);dv=tile(array(dv,rt),lt);',NL
rtn[37],←⊂' array ix=where(lv);z.v=rv.as(s32);z.v(ix)=rem(rv(ix),lv(ix)).as(s32);',NL
rtn[37],←⊂' ix=where(dv);z.v*=dv!=0;z.v(ix)=(z.v(ix)/dv(ix)).as(s32);}',NL
rtn[38],←⊂'NM(dec,"dec",0,0,MT,MT,DFD,MT,MT)',NL
rtn[38],←⊂'dec_f dec_c;',NL
rtn[38],←⊂'DF(dec_f){I ra=r.r?r.r-1:0;I la=l.r?l.r-1:0;z.r=ra+la;z.s=dim4(1);',NL
rtn[38],←⊂' if(l.s[0]!=1&&l.s[0]!=r.s[ra]&&r.s[ra]!=1)err(5);',NL
rtn[38],←⊂' DO(ra,z.s[i]=r.s[i])DO(la,z.s[i+ra]=l.s[i+1])',NL
rtn[38],←⊂' if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[38],←⊂' if(!cnt(r)||!cnt(l)){z.v=constant(0,z.s,s32);R;}',NL
rtn[38],←⊂' B lc=l.s[0];array x=l.v;if(lc==1){lc=r.s[ra];x=tile(x,(I)lc);}',NL
rtn[38],←⊂' x=flip(scan(x,0,AF_BINARY_MUL,false),0);',NL
rtn[38],←⊂' x=array(x,lc,x.elements()/lc).as(f64);',NL
rtn[38],←⊂' array y=array(r.v,cnt(r)/r.s[ra],r.s[ra]).as(f64);',NL
rtn[38],←⊂' z.v=array(matmul(r.s[ra]==1?tile(y,1,(I)l.s[0]):y,x),z.s);}',NL
rtn[39],←⊂'NM(red,"red",0,0,DID,MT ,DFD,MT ,DAD)',NL
rtn[39],←⊂'ID(red,1,s32)',NL
rtn[39],←⊂'red_f red_c;',NL
rtn[39],←⊂'OM(red,"red",0,0,MFD,DFD,MAD,DAD)',NL
rtn[39],←⊂'DA(red_f){if(ax.r>1||cnt(ax)!=1)err(5);if(!ax.v.isinteger())err(11);',NL
rtn[39],←⊂' I axv=ax.v.as(s32).scalar<I>();if(axv<0)err(11);if(axv>=r.r)err(4);',NL
rtn[39],←⊂' if(l.r>1)err(4);axv=r.r-axv-1;B lc=cnt(l),rsx=r.s[axv];',NL
rtn[39],←⊂' if(l.r!=0&&lc!=1&&r.r!=0&&rsx!=1&&lc!=rsx)err(5);',NL
rtn[39],←⊂' array x=lc==1?tile(l.v,(I)rsx):l.v,y=rsx==1?tile(r.v,(I)lc):r.v;',NL
rtn[39],←⊂' B zc=sum<B>(abs(x));z.r=r.r?r.r:1;z.s=r.s;z.s[axv]=zc;',NL
rtn[39],←⊂' if(!cnt(z)){z.v=scl(0);R;}array w=where(x).as(s32);index ix[4];',NL
rtn[39],←⊂' if(zc==w.elements()){ix[axv]=w;z.v=y(ix[0],ix[1],ix[2],ix[3]);',NL
rtn[39],←⊂'  if(zc==sum<B>(x(w)))R;dim4 sp(z.s);sp[axv]=1;',NL
rtn[39],←⊂'  z.v*=tile(x(w)>0,(I)sp[0],(I)sp[1],(I)sp[2],(I)sp[3]);R;}',NL
rtn[39],←⊂' array i=shift(accum(abs(x(w))),1),d=shift(w,1);i(0)=0;d(0)=0;',NL
rtn[39],←⊂' array v=array(zc,s32),u=array(zc,s32);v=0;u=0;',NL
rtn[39],←⊂' array s=(!sign(x(w))).as(s32);array t=shift(s,1);t(0)=0;',NL
rtn[39],←⊂' v(i)=w-d;u(i)=s-t;ix[axv]=accum(v);z.v=y(ix[0],ix[1],ix[2],ix[3]);',NL
rtn[39],←⊂' dim4 s1(1),s2(z.s);s1[axv]=zc;s2[axv]=1;u=array(accum(u),s1);',NL
rtn[39],←⊂' z.v*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);}',NL
rtn[39],←⊂'DF(red_f){A x=r;if(!r.r)cat_c(x,r,e);red_c(z,l,x,e,scl(scl(x.r-1)));}',NL
rtn[39],←⊂'MA(red_o){if(ax.r>1)err(4);if(cnt(ax)!=1)err(5);',NL
rtn[39],←⊂' if(!isint(ax))err(11);I av;ax.v.as(s32).host(&av);',NL
rtn[39],←⊂' if(av<0)err(11);if(av>=r.r)err(4);av=r.r-av-1;I rc=(I)r.s[av];',NL
rtn[39],←⊂' A t(r.r-1,dim4(1),r.v(0));I ib=isbool(r);',NL
rtn[39],←⊂' DO(av,t.s[i]=r.s[i])DO(t.r-av,t.s[av+i]=r.s[av+i+1])',NL
rtn[39],←⊂' if(!cnt(t)){t.v=scl(0);z=t;R;}',NL
rtn[39],←⊂' if(!rc){t.v=ll.id(t.s);z=t;R;}',NL
rtn[39],←⊂' if(1==rc){t.v=array(r.v,t.s);z=t;R;}',NL
rtn[39],←⊂' if("add"==ll.nm&&ib){t.v=count(r.v,av).as(s32);z=t;R;}',NL
rtn[39],←⊂' if("add"==ll.nm){t.v=moddims(sum(r.v.as(f64),av),t.s);z=t;R;}',NL
rtn[39],←⊂' if("mul"==ll.nm){t.v=moddims(product(r.v.as(f64),av),t.s);z=t;R;}',NL
rtn[39],←⊂' if("min"==ll.nm){t.v=moddims(min(r.v,av),t.s);z=t;R;}',NL
rtn[39],←⊂' if("max"==ll.nm){t.v=moddims(max(r.v,av),t.s);z=t;R;}',NL
rtn[39],←⊂' if("and"==ll.nm&&ib){t.v=moddims(allTrue(r.v,av),t.s);z=t;R;}',NL
rtn[39],←⊂' if("lor"==ll.nm&&ib){t.v=moddims(anyTrue(r.v,av),t.s);z=t;R;}',NL
rtn[39],←⊂' if("neq"==ll.nm&&ib){t.v=moddims((1&sum(r.v,0)).as(b8),t.s);z=t;R;}',NL
rtn[39],←⊂' map_o mfn_c(ll);af::index x[4];x[av]=rc-1;',NL
rtn[39],←⊂' t.v=moddims(r.v(x[0],x[1],x[2],x[3]),t.s);',NL
rtn[39],←⊂' DO(rc-1,x[av]=rc-i-2;',NL
rtn[39],←⊂'  mfn_c(t,A(t.r,t.s,moddims(r.v(x[0],x[1],x[2],x[3]),t.s)),t,e))',NL
rtn[39],←⊂' z=t;}',NL
rtn[39],←⊂'MF(red_o){A x=r;if(!r.r)cat_c(x,r,e);',NL
rtn[39],←⊂' red_o mfn(ll);mfn(z,x,e,scl(scl(x.r-1)));}',NL
rtn[39],←⊂'DA(red_o){if(ax.r>1)err(4);if(cnt(ax)!=1)err(5);',NL
rtn[39],←⊂' if(!isint(ax))err(11);I av;ax.v.as(s32).host(&av);',NL
rtn[39],←⊂' if(av<0)err(11);if(av>=r.r)err(4);av=r.r-av-1;',NL
rtn[39],←⊂' if(l.r>1)err(4);if(cnt(l)!=1)err(5);',NL
rtn[39],←⊂' if(!isint(l))err(11);I lv=l.v.as(s32).scalar<I>();I rc=(I)r.s[av]+1;',NL
rtn[39],←⊂' if(rc<lv)err(5);rc=(I)(rc-abs(lv));map_o mfn_c(ll);',NL
rtn[39],←⊂' A t(r.r,r.s,scl(0));t.s[av]=rc;if(!cnt(t)){z=t;R;}',NL
rtn[39],←⊂' if(!lv){t.v=ll.id(t.s);z=t;R;}seq rng(rc);af::index x[4];',NL
rtn[39],←⊂' if(lv>=0){x[av]=rng+((D)lv-1);t.v=r.v(x[0],x[1],x[2],x[3]);',NL
rtn[39],←⊂'  DO(lv-1,x[av]=rng+(D)(lv-i-2);',NL
rtn[39],←⊂'   mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,e))',NL
rtn[39],←⊂' }else{x[av]=rng;t.v=r.v(x[0],x[1],x[2],x[3]);',NL
rtn[39],←⊂'  DO(abs(lv)-1,x[av]=rng+(D)(i+1);',NL
rtn[39],←⊂'   mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,e))}',NL
rtn[39],←⊂' z=t;}',NL
rtn[39],←⊂'DF(red_o){if(!r.r)err(4);',NL
rtn[39],←⊂' red_o mfn_c(ll);mfn_c(z,l,r,e,scl(scl(r.r-1)));}',NL
rtn[40],←⊂'NM(rdf,"rdf",0,0,DID,MT ,DFD,MT,DAD)',NL
rtn[40],←⊂'ID(rdf,1,s32)',NL
rtn[40],←⊂'OM(rdf,"rdf",0,0,MFD,DFD,MAD,DAD)',NL
rtn[40],←⊂'rdf_f rdf_c;',NL
rtn[40],←⊂'DA(rdf_f){red_c(z,l,r,e,ax);}',NL
rtn[40],←⊂'DF(rdf_f){A x=r;if(!r.r)cat_c(x,r,e);red_c(z,l,x,e,scl(scl(0)));}',NL
rtn[40],←⊂'MA(rdf_o){red_o mfn_c(ll);mfn_c(z,r,e,ax);}',NL
rtn[40],←⊂'MF(rdf_o){A t(r.r?r.r-1:0,dim4(1),r.v(0));DO(t.r,t.s[i]=r.s[i])',NL
rtn[40],←⊂' I rc=(I)r.s[t.r];I zc=(I)cnt(t);map_o mfn_c(ll);',NL
rtn[40],←⊂' if(!zc){t.v=scl(0);z=t;R;}if(!rc){t.v=ll.id(t.s);z=t;R;}',NL
rtn[40],←⊂' if(1==rc){t.v=array(r.v,t.s);z=t;R;}',NL
rtn[40],←⊂' if("add"==ll.nm){if(r.v.isbool())t.v=count(r.v,t.r).as(s32);',NL
rtn[40],←⊂'  else t.v=sum(r.v.as(f64),t.r);z=t;R;}',NL
rtn[40],←⊂' if("mul"==ll.nm){t.v=product(r.v.as(f64),t.r);z=t;R;}',NL
rtn[40],←⊂' if("min"==ll.nm){t.v=min(r.v,t.r);z=t;R;}',NL
rtn[40],←⊂' if("max"==ll.nm){t.v=max(r.v,t.r);z=t;R;}',NL
rtn[40],←⊂' if("and"==ll.nm){t.v=allTrue(r.v,t.r);z=t;R;}',NL
rtn[40],←⊂' if("lor"==ll.nm){t.v=anyTrue(r.v,t.r);z=t;R;}',NL
rtn[40],←⊂' af::index x[4];x[t.r]=rc-1;t.v=r.v(x[0],x[1],x[2],x[3]);',NL
rtn[40],←⊂' DO(rc-1,x[t.r]=rc-(i+2);',NL
rtn[40],←⊂'  mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t,e));z=t;}',NL
rtn[40],←⊂'DA(rdf_o){red_o mfn_c(ll);mfn_c(z,l,r,e,ax);}',NL
rtn[40],←⊂'DF(rdf_o){if(!r.r)err(4);red_o mfn_c(ll);mfn_c(z,l,r,e,scl(scl(0)));}',NL
rtn[41],←⊂'NM(scn,"scn",0,0,DID,MT ,DFD,MT ,DAD)',NL
rtn[41],←⊂'scn_f scn_c;',NL
rtn[41],←⊂'ID(scn,1,s32)',NL
rtn[41],←⊂'OM(scn,"scn",1,1,MFD,MT,MAD,MT )',NL
rtn[41],←⊂'DA(scn_f){if(ax.r>1||cnt(ax)!=1)err(5);if(!ax.v.isinteger())err(11);',NL
rtn[41],←⊂' I ra=ax.v.as(s32).scalar<I>();if(ra<0)err(11);if(ra>=r.r)err(4);',NL
rtn[41],←⊂' if(l.r>1)err(4);ra=r.r-ra-1;if(r.s[ra]!=1&&r.s[ra]!=sum<I>(l.v>0))err(5);',NL
rtn[41],←⊂' index sx[4],tx[4];array ca=max(1,abs(l.v)).as(s32);I c=sum<I>(ca);',NL
rtn[41],←⊂' if(!cnt(l))c=0;A t(r.r,r.s,scl(0));t.s[ra]=c;',NL
rtn[41],←⊂' if(!cnt(t)){z=t;R;}t.v=array(t.s,r.v.type());t.v=0;',NL
rtn[41],←⊂' array pw=0<l.v;array pa=pw*l.v;I pc=sum<I>(pa);if(!pc){z=t;R;}',NL
rtn[41],←⊂' pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);',NL
rtn[41],←⊂' array si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;sx[ra]=si;',NL
rtn[41],←⊂' array ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);',NL
rtn[41],←⊂' ti=scanByKey(si,ti);tx[ra]=ti;',NL
rtn[41],←⊂' t.v(tx[0],tx[1],tx[2],tx[3])=r.v(sx[0],sx[1],sx[2],sx[3]);z=t;',NL
rtn[41],←⊂'}',NL
rtn[41],←⊂'DF(scn_f){A x=r;if(!x.r)cat_c(x,r,e);scn_c(z,l,x,e,scl(scl(x.r-1)));}',NL
rtn[41],←⊂'',NL
rtn[41],←⊂'MA(scn_o){if(ax.r>1)err(4);if(cnt(ax)!=1)err(5);',NL
rtn[41],←⊂' if(!isint(ax))err(11);I av;ax.v.as(s32).host(&av);',NL
rtn[41],←⊂' if(av<0)err(11);if(av>=r.r)err(4);av=r.r-av-1;',NL
rtn[41],←⊂' z.r=r.r;z.s=r.s;I rc=(I)r.s[av];I ib=isbool(r);',NL
rtn[41],←⊂' if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[41],←⊂' if("add"==ll.nm){z.v=scan(r.v.as(f64),av,AF_BINARY_ADD);R;}',NL
rtn[41],←⊂' if("mul"==ll.nm){z.v=scan(r.v.as(f64),av,AF_BINARY_MUL);R;}',NL
rtn[41],←⊂' if("min"==ll.nm){z.v=scan(r.v.as(f64),av,AF_BINARY_MIN);R;}',NL
rtn[41],←⊂' if("max"==ll.nm){z.v=scan(r.v.as(f64),av,AF_BINARY_MAX);R;}',NL
rtn[41],←⊂' if("and"==ll.nm&&ib){z.v=scan(r.v,av,AF_BINARY_MIN);R;}',NL
rtn[41],←⊂' if("lor"==ll.nm&&ib){z.v=scan(r.v,av,AF_BINARY_MAX);R;}',NL
rtn[41],←⊂' A t(z.r-1,dim4(1),r.v(0));af::index x[4];map_o mfn_c(ll);z.v=array(z.s,f64);',NL
rtn[41],←⊂' DO(av,t.s[i]=r.s[i])DO(t.r-av,t.s[av+i]=r.s[av+i+1])dim4 sp=z.s;sp[av]=1;',NL
rtn[41],←⊂' DO(rc,x[av]=i;t.v=moddims(r.v(x[0],x[1],x[2],x[3]).as(f64),t.s);I c=i;',NL
rtn[41],←⊂'  DO(c,x[av]=c-i-1;A y(t.r,t.s,moddims(r.v(x[0],x[1],x[2],x[3]),t.s));',NL
rtn[41],←⊂'   mfn_c(t,y,t,e))',NL
rtn[41],←⊂'  x[av]=i;z.v(x[0],x[1],x[2],x[3])=moddims(t.v,sp))}',NL
rtn[41],←⊂'MF(scn_o){if(!r.r){z=r;R;}scn_o mfn_c(ll);mfn_c(z,r,e,scl(scl(r.r-1)));}',NL
rtn[42],←⊂'NM(scf,"scf",0,0,DID,MT ,DFD,MT ,DAD)',NL
rtn[42],←⊂'scf_f scf_c;',NL
rtn[42],←⊂'ID(scf,1,s32)',NL
rtn[42],←⊂'OM(scf,"scf",1,1,MFD,MT,MAD,MT )',NL
rtn[42],←⊂'DA(scf_f){scn_c(z,l,r,e,ax);}',NL
rtn[42],←⊂'DF(scf_f){A x=r;if(!x.r)cat_c(x,r,e);scn_c(z,l,x,e,scl(scl(0)));}',NL
rtn[42],←⊂'',NL
rtn[42],←⊂'MA(scf_o){scn_o mfn_c(ll);mfn_c(z,r,e,ax);}',NL
rtn[42],←⊂'MF(scf_o){if(!r.r){z=r;R;}scn_o mfn_c(ll);mfn_c(z,r,e,scl(scl(0)));}',NL
rtn[43],←⊂'NM(rol,"rol",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[43],←⊂'rol_f rol_c;',NL
rtn[43],←⊂'MF(rol_f){z.s=r.s;if(!cnt(r)){z.v=r.v;R;}',NL
rtn[43],←⊂' arr rnd=randu(r.v.dims(),f64);z.v=(0==r.v)*rnd+trunc(r.v*rnd);}',NL
rtn[43],←⊂'DF(rol_f){if(cnt(r)!=1||cnt(l)!=1)err(5);',NL
rtn[43],←⊂' D lv=l.v.as(f64).scalar<D>();D rv=r.v.as(f64).scalar<D>();',NL
rtn[43],←⊂' if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);',NL
rtn[43],←⊂' I s=(I)lv;I t=(I)rv;z.s=SHP(1,s);if(!s){z.v=scl(0);R;}',NL
rtn[43],←⊂' VEC<I> g(t);VEC<I> d(t);',NL
rtn[43],←⊂' ((1+range(t))*randu(t)).as(s32).host(g.data());',NL
rtn[43],←⊂' DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=arr(s,d.data());}',NL
rtn[44],←⊂'NM(tke,"tke",0,0,MT ,MFD,DFD,MAD,DAD)',NL
rtn[44],←⊂'tke_f tke_c;',NL
rtn[44],←⊂'MF(tke_f){z=r;}',NL
rtn[44],←⊂'MA(tke_f){err(16);}',NL
rtn[44],←⊂'DA(tke_f){B c=cnt(l),ac=cnt(ax);if(ax.r>1||l.r>1)err(4);if(ac!=c)err(5);',NL
rtn[44],←⊂' if(c>4)err(16);',NL
rtn[44],←⊂' if(!isint(ax))err(11);I m[4]={0,0,0,0},av[4];ax.v.as(s32).host(av);',NL
rtn[44],←⊂' DOB(ac,if(av[i]<0)err(11);if(av[i]>=r.r)err(4))',NL
rtn[44],←⊂' DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',NL
rtn[44],←⊂' if(!c){z=r;R;}if(!isint(l))err(11);I lv[4];l.v.as(s32).host(lv);',NL
rtn[44],←⊂' seq it[4],ix[4];z.r=r.r;z.s=r.s;',NL
rtn[44],←⊂' DOB(c,{U j=z.r-av[i]-1;I a=std::abs(lv[i]);z.s[j]=a;',NL
rtn[44],←⊂'  if(a>r.s[j])ix[j]=seq((D)r.s[j]);',NL
rtn[44],←⊂'  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);',NL
rtn[44],←⊂'  else ix[j]=seq(a);',NL
rtn[44],←⊂'  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})',NL
rtn[44],←⊂' if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;',NL
rtn[44],←⊂' z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}',NL
rtn[44],←⊂'DF(tke_f){I c=(I)cnt(l);if(c>4)err(16);',NL
rtn[44],←⊂' A nr=r;if(!nr.r){nr.r=c;nr.s=dim4(1);}',NL
rtn[44],←⊂' A ax;iot_c(ax,scl(scl(c)),e);tke_c(z,l,nr,e,ax);}',NL
rtn[45],←⊂'NM(drp,"drp",0,0,MT ,MFD,DFD,MAD,DAD)',NL
rtn[45],←⊂'drp_f drp_c;',NL
rtn[45],←⊂'MF(drp_f){if(r.r)err(16);z=r;}',NL
rtn[45],←⊂'MA(drp_f){err(16);}',NL
rtn[45],←⊂'DA(drp_f){B c=cnt(l),ac=cnt(ax);if(ax.r>1||l.r>1)err(4);if(ac!=c)err(5);',NL
rtn[45],←⊂' if(c>4)err(16);',NL
rtn[45],←⊂' if(!isint(ax))err(11);I m[4]={0,0,0,0},av[4];ax.v.as(s32).host(av);',NL
rtn[45],←⊂' DOB(ac,if(av[i]<0)err(11);if(av[i]>=r.r)err(4))',NL
rtn[45],←⊂' DOB(ac,if(m[av[i]])err(11);m[av[i]]=1)',NL
rtn[45],←⊂' if(!c){z=r;R;}if(!isint(l))err(11);I lv[4];l.v.as(s32).host(lv);',NL
rtn[45],←⊂' seq it[4],ix[4];z.r=r.r;z.s=r.s;',NL
rtn[45],←⊂' DO((I)c,{U j=z.r-av[i]-1;I a=std::abs(lv[i]);z.s[j]=r.s[j]-a;',NL
rtn[45],←⊂'  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}',NL
rtn[45],←⊂'  else if(lv[i]<0){ix[j]=seq((D)z.s[j]);it[j]=ix[j];}',NL
rtn[45],←⊂'  else{ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})',NL
rtn[45],←⊂' if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;',NL
rtn[45],←⊂' z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}',NL
rtn[45],←⊂'DF(drp_f){I c=(I)cnt(l);if(c>4)err(16);',NL
rtn[45],←⊂' A nr=r;if(!nr.r){nr.r=c;nr.s=dim4(1);}',NL
rtn[45],←⊂' A ax;iot_c(ax,scl(scl(c)),e);drp_c(z,l,nr,e,ax);}',NL
rtn[46],←⊂'OM(map,"map",1,1,MFD,DFD,MT ,MT )',NL
rtn[46],←⊂'MF(map_o){if(scm(ll)){ll(z,r,e);R;}',NL
rtn[46],←⊂' z.r=r.r;z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}',NL
rtn[46],←⊂' A zs;A rs=scl(r.v(0));ll(zs,rs,e);if(c==1){z.v=zs.v;R;}',NL
rtn[46],←⊂' array v=array(z.s,zs.v.type());v(0)=zs.v(0);',NL
rtn[46],←⊂' DO(c-1,rs.v=r.v(i+1);ll(zs,rs,e);v(i+1)=zs.v(0))z.v=v;}',NL
rtn[46],←⊂'DF(map_o){if(scd(ll)){ll(z,l,r,e);R;}',NL
rtn[46],←⊂' if((l.r==r.r&&l.s==r.s)||!l.r){z.r=r.r;z.s=r.s;}',NL
rtn[46],←⊂' else if(!r.r){z.r=l.r;z.s=l.s;}else if(l.r!=r.r)err(4);',NL
rtn[46],←⊂' else if(l.s!=r.s)err(5);else err(99);I c=(I)cnt(z);',NL
rtn[46],←⊂' if(!c){z.v=scl(0);R;}A zs;A rs=scl(r.v(0));A ls=scl(l.v(0));',NL
rtn[46],←⊂' ll(zs,ls,rs,e);if(c==1){z.v=zs.v;R;}',NL
rtn[46],←⊂' array v=array(z.s,zs.v.type());v(0)=zs.v(0);',NL
rtn[46],←⊂' if(!r.r){rs.v=r.v;',NL
rtn[46],←⊂'  DO(c-1,ls.v=l.v(i+1);ll(zs,ls,rs,e);v(i+1)=zs.v(0);)',NL
rtn[46],←⊂'  z.v=v;R;}',NL
rtn[46],←⊂' if(!l.r){ls.v=l.v;',NL
rtn[46],←⊂'  DO(c-1,rs.v=r.v(i+1);ll(zs,ls,rs,e);v(i+1)=zs.v(0);)',NL
rtn[46],←⊂'  z.v=v;R;}',NL
rtn[46],←⊂' DO(c-1,ls.v=l.v(i+1);rs.v=r.v(i+1);ll(zs,ls,rs,e);',NL
rtn[46],←⊂'  v(i+1)=zs.v(0))z.v=v;}',NL
rtn[47],←⊂'OM(com,"com",scm(l),scd(l),MFD,DFD,MT ,MT )',NL
rtn[47],←⊂'MF(com_o){ll(z,r,r,e);}DF(com_o){ll(z,r,l,e);}',NL
rtn[47],←⊂'',NL
rtn[48],←⊂'OD(dot,"dot",0,0,MT,DFD,MT ,MT )',NL
rtn[48],←⊂'DF(dot_o){I ra=r.r?r.r-1:0;if(r.r&&l.r&&l.s[0]!=r.s[ra])err(5);',NL
rtn[48],←⊂' I la=l.r?l.r-1:0;A t(la+ra,r.s,r.v(0));if(t.r>4)err(10);',NL
rtn[48],←⊂' t.s[ra]=1;DO(la,t.s[i+ra]=l.s[i+1])if(!cnt(t)){t.v=scl(0);z=t;R;}',NL
rtn[48],←⊂' if(!l.s[0]||!r.s[ra]){t.v=ll.id(t.s);z=t;R;}',NL
rtn[48],←⊂' I c=(I)(l.r?l.s[0]:r.s[ra]);',NL
rtn[48],←⊂' I rc=(I)(cnt(r)/r.s[ra]);I lc=(I)(cnt(l)/l.s[0]);',NL
rtn[48],←⊂' array x=array(l.v,(I)l.s[0],lc);array y=array(r.v,rc,(I)r.s[ra]);',NL
rtn[48],←⊂' if(1==l.s[0]){x=tile(x,c,1);}if(1==r.s[ra]){y=tile(y,1,c);}',NL
rtn[48],←⊂' if("add"==ll.nm&&"mul"==rr.nm){',NL
rtn[48],←⊂'  t.v=array(matmul(y.as(f64),x.as(f64)),t.s);z=t;R;}',NL
rtn[48],←⊂' if(x.isbool()&&y.isbool()&&"neq"==ll.nm&&"and"==rr.nm){',NL
rtn[48],←⊂'  t.v=array((1&matmul(y.as(f32),x.as(f32)).as(s16)).as(b8),t.s);z=t;R;}',NL
rtn[48],←⊂' x=tile(array(x,c,1,lc),1,rc,1);y=tile(y.T(),1,1,lc);',NL
rtn[48],←⊂' A X(3,dim4(c,rc,lc),x.as(f64));A Y(3,dim4(c,rc,lc),y.as(f64));',NL
rtn[48],←⊂' map_o mfn_c(rr);red_o rfn_c(ll);mfn_c(X,X,Y,e);rfn_c(X,X,e);',NL
rtn[48],←⊂' t.v=array(X.v,t.s);z=t;}',NL
rtn[48],←⊂'',NL
rtn[49],←⊂'OD(rnk,"rnk",scm(l),0,MFD,DFD,MT ,MT )',NL
rtn[49],←⊂'MF(rnk_o){if(cnt(ww)!=1)err(4);I cr=ww.v.as(s32).scalar<I>();',NL
rtn[49],←⊂' if(scm(ll)||cr>=r.r){ll(z,r,e);R;}',NL
rtn[49],←⊂' if(cr<=-r.r||!cr){map_o f(ll);f(z,r,e);R;}',NL
rtn[49],←⊂' if(cr<0)cr=r.r+cr;if(cr>3)err(10);I dr=r.r-cr;',NL
rtn[49],←⊂' dim4 sp(1);DO(dr,sp[cr]*=r.s[i+cr])DO(cr,sp[i]=r.s[i])',NL
rtn[49],←⊂' std::vector<A> tv(sp[cr]);A b(cr+1,sp,array(r.v,sp));',NL
rtn[49],←⊂' I mr=0;dim4 ms(1);dtype mt=b8;',NL
rtn[49],←⊂' DO((I)sp[cr],A t;sqd_c(t,scl(scl(i)),b,e);ll(tv[i],t,e);',NL
rtn[49],←⊂'  t=tv[i];if(mr<t.r)mr=t.r;if(mr>3)err(10);mt=mxt(mt,t);',NL
rtn[49],←⊂'  DO(4,if(ms[i]<t.s[i])ms[i]=t.s[i]))',NL
rtn[49],←⊂' B mc=cnt(ms);array v(mc*sp[cr],mt);v=0;',NL
rtn[49],←⊂' DO((I)sp[cr],seq ix((D)cnt(tv[i]));v(ix+(D)(i*mc))=flat(tv[i].v))',NL
rtn[49],←⊂' z.r=mr+dr;z.s=ms;z.s[mr]=sp[cr];z.v=array(v,z.s);}',NL
rtn[49],←⊂'DF(rnk_o){I cl,cr,dl,dr;dim4 sl(1),sr(1);array wwv=ww.v.as(s32);',NL
rtn[49],←⊂' if(cnt(ww)==1)cl=cr=wwv.scalar<I>();',NL
rtn[49],←⊂' else if(cnt(ww)==2){cl=wwv.scalar<I>();cr=wwv(1).scalar<I>();}',NL
rtn[49],←⊂' else err(4);',NL
rtn[49],←⊂' if(cl>l.r)cl=l.r;if(cr>r.r)cr=r.r;if(cl<-l.r)cl=0;if(cr<-r.r)cr=0;',NL
rtn[49],←⊂' if(cl<0)cl=l.r+cl;if(cr<0)cr=r.r+cr;if(cr>3||cl>3)err(10);',NL
rtn[49],←⊂' dl=l.r-cl;dr=r.r-cr;if(dl!=dr&&dl&&dr)err(4);',NL
rtn[49],←⊂' if(dl==dr)DO(dr,if(l.s[i+cl]!=r.s[i+cr])err(5))',NL
rtn[49],←⊂' DO(dl,sl[cl]*=l.s[i+cl])DO(cl,sl[i]=l.s[i])',NL
rtn[49],←⊂' DO(dr,sr[cr]*=r.s[i+cr])DO(cr,sr[i]=r.s[i])',NL
rtn[49],←⊂' B sz=dl>dr?sl[cl]:sr[cr];std::vector<A> tv(sz);',NL
rtn[49],←⊂' A a(cl+1,sl,array(l.v,sl));A b(cr+1,sr,array(r.v,sr));',NL
rtn[49],←⊂' I mr=0;dim4 ms(1);dtype mt=b8;',NL
rtn[49],←⊂' DO((I)sz,A ta;A tb;A ai=scl(scl((I)(i%sl[cl])));A bi=scl(scl((I)(i%sr[cr])));',NL
rtn[49],←⊂'  sqd_c(ta,ai,a,e);sqd_c(tb,bi,b,e);ll(tv[i],ta,tb,e);',NL
rtn[49],←⊂'  if(mr<tv[i].r)mr=tv[i].r;mt=mxt(mt,tv[i]);A t=tv[i];',NL
rtn[49],←⊂'  DO(4,if(ms[i]<t.s[i])ms[i]=t.s[i]))',NL
rtn[49],←⊂' B mc=cnt(ms);array v(mc*sz,mt);v=0;',NL
rtn[49],←⊂' DOB(sz,seq ix((D)cnt(tv[i]));v(ix+(D)(i*mc))=flat(tv[i].v))',NL
rtn[49],←⊂' z.r=mr+(dr>dl?dr:dl);z.s=ms;z.s[mr]=sz;z.v=array(v,z.s);}',NL
rtn[49],←⊂'',NL
rtn[50],←⊂'OD(pow,"pow",scm(l),scd(l),MFD,DFD,MT ,MT )',NL
rtn[50],←⊂'MF(pow_o){if(fr){A t;A v=r;',NL
rtn[50],←⊂'  do{A u;ll(u,v,e);rr(t,u,v,e);if(t.r)err(5);v=u;}',NL
rtn[50],←⊂'  while(!t.v.as(s32).scalar<I>());z=v;R;}',NL
rtn[50],←⊂' if(ww.r)err(4);I c=ww.v.as(s32).scalar<I>();z=r;DO(c,ll(z,z,e))}',NL
rtn[50],←⊂'DF(pow_o){if(fr){A t;A v=r;',NL
rtn[50],←⊂'  do{A u;ll(u,l,v,e);rr(t,u,v,e);if(t.r)err(5);v=u;}',NL
rtn[50],←⊂'  while(!t.v.as(s32).scalar<I>());z=v;R;}',NL
rtn[50],←⊂' if(ww.r)err(4);I c=ww.v.as(s32).scalar<I>();',NL
rtn[50],←⊂' A t=r;DO(c,ll(t,l,t,e))z=t;}',NL
rtn[50],←⊂'',NL
rtn[51],←⊂'OD(jot,"jot",(scm(l)&&scm(r)),(scd(l)&&scd(r)),MFD,DFD,MT ,MT )',NL
rtn[51],←⊂'MF(jot_o){if(!fl){rr(z,aa,r,e);R;}if(!fr){ll(z,r,ww,e);R;}',NL
rtn[51],←⊂' rr(z,r,e);ll(z,z,e);}',NL
rtn[51],←⊂'DF(jot_o){if(!fl||!fr){err(2);}rr(z,r,e);ll(z,l,z,e);}',NL
rtn[51],←⊂'',NL
rtn[52],←⊂'NM(unq,"unq",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[52],←⊂'unq_f unq_c;',NL
rtn[52],←⊂'MF(unq_f){if(r.r>1)err(4);z.r=1;if(!cnt(r)){z.s=r.s;z.v=r.v;R;}',NL
rtn[52],←⊂' array a,b;sort(a,b,r.v);z.v=a!=shift(a,1);z.v(0)=1;',NL
rtn[52],←⊂' z.v=where(z.v);sort(b,z.v,b(z.v),a(z.v));',NL
rtn[52],←⊂' z.s=dim4(z.v.elements());}',NL
rtn[52],←⊂'DF(unq_f){if(r.r>1||l.r>1)err(4);z.r=1;dtype mt=mxt(l.v,r.v);',NL
rtn[52],←⊂' if(!cnt(l)){z.s=r.s;z.v=r.v;R;}if(!cnt(r)){z.s=l.s;z.v=l.v;R;}',NL
rtn[52],←⊂' array x=setUnique(l.v);B c=x.elements();',NL
rtn[52],←⊂' z.v=!anyTrue(tile(r.v,1,(U)c)==tile(array(x,1,c),(U)r.s[0],1),1);',NL
rtn[52],←⊂' z.v=join(0,l.v.as(mt),r.v(where(z.v)).as(mt));',NL
rtn[52],←⊂' z.s=dim4(z.v.elements());}',NL
rtn[52],←⊂'',NL
rtn[53],←⊂'NM(int,"int",0,0,MT ,MT ,DFD,MT ,MT )',NL
rtn[53],←⊂'int_f int_c;',NL
rtn[53],←⊂'DF(int_f){if(r.r>1||l.r>1)err(4);',NL
rtn[53],←⊂' if(!cnt(r)||!cnt(l)){z.v=scl(0);z.s=dim4(0);z.r=1;R;}',NL
rtn[53],←⊂' array pv=setUnique(r.v);B pc=pv.elements();z.v=constant(0,cnt(l),s64);',NL
rtn[53],←⊂' for(B h;h=pc/2;pc-=h){array t=z.v+h;replace(z.v,pv(t)>l.v,t);}',NL
rtn[53],←⊂' array ix=where(pv(z.v)==l.v);z.r=1;z.s=dim4(ix.elements());',NL
rtn[53],←⊂' z.v=z.s[0]?l.v(ix):scl(0);}',NL
rtn[53],←⊂'',NL
rtn[54],←⊂'NM(get,"get",0,0,MT,MT,DFD,MT,MT)',NL
rtn[54],←⊂'get_f get_c;',NL
rtn[54],←⊂'DF(get_f){const std::vector<A>&lv=l.nv;I ll=(I)lv.size();',NL
rtn[54],←⊂' if(!ll){if(z.r!=1)err(4);if(r.r!=1)err(5);DO(4,if(z.s[i]!=r.s[i])err(5));z=r;R;}',NL
rtn[54],←⊂' if(ll!=z.r)err(4);I rk=0;DO(ll,rk+=abs(lv[i].r))if(r.r>0&&rk!=r.r)err(5);',NL
rtn[54],←⊂' const B*rs=r.s.get();af::index x[4];',NL
rtn[54],←⊂' if(!r.r)DO(ll,A v=lv[ll-(i+1)];I r=v.r;if(r>=0)x[i]=v.v.as(s32))',NL
rtn[54],←⊂' if(r.r>0)',NL
rtn[54],←⊂'  DO(ll,A v=lv[ll-(i+1)];I r=v.r;if(r<0)if(z.s[i]!=*rs++)err(5);',NL
rtn[54],←⊂'   if(r>=0){DO(r,if(v.s[i]!=*rs++)err(5))x[i]=v.v.as(s32);})',NL
rtn[54],←⊂' z.v(x[0],x[1],x[2],x[3])=r.v;}',NL
rtn[54],←⊂'',NL
rtn[54],←⊂'OM(get,"get",0,0,MT,DFD)',NL
rtn[54],←⊂'DF(get_o){A t;brk_c(t,z,l,e);map_o mfn_c(ll);mfn_c(t,t,r,e);get_c(z,l,t,e);}',NL
rtn[55],←⊂'NM(gdu,"gdu",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[55],←⊂'gdu_f gdu_c;',NL
rtn[55],←⊂'MF(gdu_f){B rr=rnk(r);if(rr<1)err(4);z.s=SHP(1,r.s[rr-1]);',NL
rtn[55],←⊂' if(!cnt(r)){z.v=r.v;R;}B c=1;DOB(rr-1,c*=r.s[i])',NL
rtn[55],←⊂' arr mt,a=arr(r.v,c,r.s[rr-1]);z.v=iota(dim4(z.s[0]),dim4(1),s32);',NL
rtn[55],←⊂' DOB(c,sort(mt,z.v,flat(a((I)(c-i-1),z.v)),z.v,0,true))}',NL
rtn[55],←⊂'DF(gdu_f){err(16);}',NL
rtn[56],←⊂'NM(gdd,"gdd",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[56],←⊂'gdd_f gdd_c;',NL
rtn[56],←⊂'MF(gdd_f){if(r.r<1)err(4);z.r=1;z.s=dim4(r.s[r.r-1]);',NL
rtn[56],←⊂' if(!cnt(r)){z.v=r.v;R;}I c=1;DO(r.r-1,c*=(I)r.s[i]);',NL
rtn[56],←⊂' array mt,a=array(r.v,c,r.s[r.r-1]);z.v=iota(z.s,dim4(1),s32);',NL
rtn[56],←⊂' DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,false))}',NL
rtn[56],←⊂'DF(gdd_f){err(16);}',NL
rtn[56],←⊂'',NL
rtn[57],←⊂'OM(oup,"oup",0,0,MT,DFD,MT ,MT )',NL
rtn[57],←⊂'DF(oup_o){A t(l.r+r.r,r.s,r.v(0));if(t.r>4)err(10);',NL
rtn[57],←⊂' DO(l.r,t.s[i+r.r]=l.s[i])if(!cnt(t)){t.v=scl(0);z=t;R;}',NL
rtn[57],←⊂' array x(flat(l.v),1,cnt(l));array y(flat(r.v),cnt(r),1);',NL
rtn[57],←⊂' dim4 ts(cnt(r),cnt(l));x=tile(x,(I)ts[0],1);y=tile(y,1,(I)ts[1]);',NL
rtn[57],←⊂' map_o mfn(ll);A xa(2,ts,x);A ya(2,ts,y);mfn(xa,xa,ya,e);',NL
rtn[57],←⊂' t.v=array(xa.v,t.s);z=t;}',NL
rtn[57],←⊂'',NL
rtn[58],←⊂'NM(fnd,"fnd",0,0,MT ,MT ,DFD,MT ,MT )',NL
rtn[58],←⊂'fnd_f fnd_c;',NL
rtn[58],←⊂'DF(fnd_f){A t(r.r,r.s,array(r.s,b8));if(!cnt(t)){t.v=scl(0);z=t;R;}',NL
rtn[58],←⊂' t.v=0;if(l.r>r.r){z=t;R;}DO(4,if(l.s[i]>r.s[i]){z=t;R;})',NL
rtn[58],←⊂' if(!cnt(l)){t.v=1;z=t;R;}dim4 sp;DO(4,sp[i]=1+(t.s[i]-l.s[i]))',NL
rtn[58],←⊂' seq x[4];DO(4,x[i]=seq((D)sp[i]))t.v(x[0],x[1],x[2],x[3])=1;',NL
rtn[58],←⊂' DO((I)l.s[0],I m=i;',NL
rtn[58],←⊂'  DO((I)l.s[1],I k=i;',NL
rtn[58],←⊂'   DO((I)l.s[2],I j=i;',NL
rtn[58],←⊂'    DO((I)l.s[3],t.v(x[0],x[1],x[2],x[3])=t.v(x[0],x[1],x[2],x[3])',NL
rtn[58],←⊂'     &(tile(l.v(m,k,j,i),sp)',NL
rtn[58],←⊂'      ==r.v(x[0]+(D)m,x[1]+(D)k,x[2]+(D)j,x[3]+(D)i))))))',NL
rtn[58],←⊂' z=t;}',NL
rtn[58],←⊂'',NL
rtn[59],←⊂'NM(par,"par",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[59],←⊂'par_f par_c;',NL
rtn[59],←⊂'MF(par_f){err(16);}',NL
rtn[59],←⊂'DF(par_f){err(16);}',NL
rtn[59],←⊂'',NL
rtn[60],←⊂'NM(mdv,"mdv",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[60],←⊂'mdv_f mdv_c;',NL
rtn[60],←⊂'MF(mdv_f){if(r.r>2)err(4);if(r.r==2&&r.s[1]<r.s[0])err(5);if(!cnt(r))err(5);',NL
rtn[60],←⊂' if(r.s[0]==r.s[1]){z.r=r.r;z.s=r.s;z.v=inverse(r.v);R;}',NL
rtn[60],←⊂' if(r.r==1){z.v=matmulNT(inverse(matmulTN(r.v,r.v)),r.v);z.r=r.r;z.s=r.s;R;}',NL
rtn[60],←⊂' z.v=matmulTN(inverse(matmulNT(r.v,r.v)),r.v);z.r=r.r;z.s=r.s;',NL
rtn[60],←⊂' B k=z.s[0];z.s[0]=z.s[1];z.s[1]=k;z.v=transpose(z.v);}',NL
rtn[60],←⊂'DF(mdv_f){if(r.r>2)err(4);if(l.r>2)err(4);if(r.r==2&&r.s[1]<r.s[0])err(5);',NL
rtn[60],←⊂' if(!cnt(r)||!cnt(l))err(5);if(r.r&&l.r&&l.s[l.r-1]!=r.s[r.r-1])err(5);',NL
rtn[60],←⊂' array rv=r.v,lv=l.v;if(r.r==1)rv=transpose(rv);if(l.r==1)lv=transpose(lv);',NL
rtn[60],←⊂' z.v=transpose(matmul(inverse(matmulNT(rv,rv)),matmulNT(rv,lv)));',NL
rtn[60],←⊂' z.r=(l.r-(l.r>0))+(r.r-(r.r>0));',NL
rtn[60],←⊂' if(l.r>1)z.s[0]=l.s[0];if(r.r>1)z.s[l.r>1]=r.s[0];}',NL
rtn[60],←⊂'',NL
rtn[61],←⊂'NM(fft,"fft",1,0,MT ,MFD,MT ,MT ,MT )',NL
rtn[61],←⊂'fft_f fft_c;',NL
rtn[61],←⊂'MF(fft_f){z.r=r.r;z.s=r.s;z.v=dft(r.v.type()==c64?r.v:r.v.as(c64),1,r.s);}',NL
rtn[61],←⊂'',NL
rtn[62],←⊂'NM(ift,"ift",1,0,MT ,MFD,MT ,MT ,MT )',NL
rtn[62],←⊂'ift_f ift_c;',NL
rtn[62],←⊂'MF(ift_f){z.r=r.r;z.s=r.s;z.v=idft(r.v.type()==c64?r.v:r.v.as(c64),1,r.s);}',NL
rtn[62],←⊂'',NL
:EndNamespace
