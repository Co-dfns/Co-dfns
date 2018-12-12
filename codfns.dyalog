:Namespace codfns
⎕IO ⎕ML ⎕WX VERSION AF∆PREFIX AF∆LIB←0 1 3 (2018 12 0) '/opt/arrayfire' 'cuda'
VS∆PS←⊂'\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC'
VS∆PS,←⊂'\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC'
VS∆PS,←⊂'\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC'
VS∆PS,¨←⊂'\Auxiliary\Build\vcvarsall.bat'
VS∆PS,←⊂'\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat'
Cmp←{_←1 ⎕NDELETE f←⍺,soext⍬ ⋄ _←(⍺,'.cpp')put⍨gc tt⊢a n s←ps ⍵
 _←(⍎opsys'vsc' 'gcc' 'clang')⍺ ⋄ ⎕NEXISTS f:n ⋄ 'COMPILE ERROR' ⎕SIGNAL 22}
MkNS←{f←'Rtm∆Init' 'MKA' 'EXA' 'Display' 'LoadImage' 'SaveImage'
 f,←'Image' 'Plot' 'Histogram' 'soext' 'opsys' 'mkna'
 ns←#.⎕NS ⍬ ⋄ ns.∆←⎕NS ↑f ⋄ ns.∆._←ns ⋄ _←ns.(⍙←⎕NS ⍬)
 ns.∆.names←(0⍴⊂''),(1=1⊃⍵)⌿0⊃⍵ ⋄ ns.∆.decls←⍺∘mkna¨ns.∆.names
 _←ns.⍎¨(⊂'0'),⍺∘mkf¨ns.∆.names
 _←ns.∆.⎕FX'Z←Init'('Z←Rtm∆Init ''',⍺,'''')('names _.⍙.⎕NA¨ decls')
 ns}
Fix←{⍺ MkNS ⍺ Cmp ⍵}
Xml←{⎕XML(0⌷⍉⍵),(,∘⍕⌿2↑1↓⍉⍵),(⊂''),⍪(⊂(¯3+≢⍉⍵)↑,¨'nrsgvyel'),∘⍪¨↓⍕∘,¨⍉3↓⍉⍵}
opsys←{⍵⊃⍨'Win' 'Lin' 'Mac'⍳⊂3↑⊃'.'⎕WG'APLVersion'}
soext←{opsys'.dll' '.so' '.dylib'}
mkna←{(⍺,soext⍬),'|',('∆'⎕R'__'⊢⍵),'_cdf P P P'}
mkf←{fn←(⍺,soext⍬),'|',('∆'⎕R'__'⊢⍵),'_dwa '
 f←⍵,'←{_←''dya''⎕NA''',fn,'>PP <PP <PP'' ⋄ '
 f,←'_←''mon''⎕NA''',fn,'>PP P <PP'' ⋄ '
 f,'0=⎕NC''⍺'':mon 0 0 ⍵ ⋄ dya 0 ⍺ ⍵} ⋄ 0'}
tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
put←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}
ccf←{' -o ''',⍵,'.',⍺,''' ''',⍵,'.cpp'' -laf',AF∆LIB,' > ',⍵,'.log 2>&1'}
cci←{'-I''',AF∆PREFIX,'/include'' -L''',AF∆PREFIX,'/lib'' '}
cco←'-std=c++11 -Ofast -g -Wall -fPIC -shared '
ucc←{⍵⍵(⎕SH ⍺⍺,' ',cco,cci,ccf)⍵}
gcc←'g++'ucc'so'
clang←'clang++'ucc'dylib'
vsco←{z←'/W3 /wd4102 /wd4275 /Gm- /O2 /Zc:inline /Zi /Fd"',⍵,'.pdb" '
 z,←'/errorReport:prompt /WX- /MD /EHsc /nologo '
 z,'/I"%AF_PATH%\include" /D "NOMINMAX" /D "AF_DEBUG" '}
vslo←{z←'/link /DLL /OPT:REF /INCREMENTAL:NO /SUBSYSTEM:WINDOWS '
 z,←'/LIBPATH:"%AF_PATH%\lib" /DYNAMICBASE "af', AF∆LIB, '.lib" '
 z,'/OPT:ICF /ERRORREPORT:PROMPT /TLBID:1 '}
vsc0←{~∨⌿b←⎕NEXISTS¨VS∆PS:'VISUAL C++?'⎕SIGNAL 99 ⋄ '""','" amd64',⍨⊃b⌿VS∆PS}
vsc1←{' && cd "',(⊃⎕CMD'echo %CD%'),'" && cl ',(vsco ⍵),'/fast "',⍵,'.cpp" '}
vsc2←{(vslo ⍵),'/OUT:"',⍵,'.dll" > "',⍵,'.log""'}
vsc←{⎕CMD('%comspec% /C ',vsc0,vsc1,vsc2)⍵}
f∆ N∆←'ptknrsgvyeld' 'ABEFGLMNOPVZ'
⎕FX∘⍉∘⍪¨'GLM',¨'←{⍪/(0 '∘,¨(⍕¨N∆⍳'GLM'),¨⊂' 0 0),1+@0⍉↑(⊂4⍴⊂⍬),⍵}'
⎕FX∘⍉∘⍪¨'ABEFO',¨'←{⍪/(0 '∘,¨(⍕¨N∆⍳'ABEFO'),¨⊂' ⍺⍺ 0),1+@0⍉↑(⊂4⍴⊂⍬),⍵}'
⎕FX∘⍉∘⍪¨'NPVZ',¨'←{0(N∆⍳'''∘,¨'NPVZ',¨''')'∘,¨'0(⍎⍵)' '0(⊂⍵)' '⍺⍺(⊂⍵)' '1(⊂⍵)',¨'}'
MKA←{mka⊂⍵} ⋄ EXA←{exa ⍬ ⍵}
Display←{⍺←'Co-dfns' ⋄ W←w_new⊂⍺ ⋄ 777::w_del W
 w_del W⊣W ⍺⍺{w_close ⍺:⍎'⎕SIGNAL 777' ⋄ ⍺ ⍺⍺ ⍵}⍣⍵⍵⊢⍵}
LoadImage←{⍺←1 ⋄ ~⎕NEXISTS ⍵:⎕SIGNAL 22 ⋄ ⍉loadimg ⍬ ⍵ ⍺}
SaveImage←{⍺←'image.png' ⋄ saveimg (⍉⍵) ⍺}
Image←{~2 3∨.=≢⍴⍵:⎕SIGNAL 4 ⋄ (3≠2⊃3↑⍴⍵)∧3=≢⍴⍵:⎕SIGNAL 5 ⋄ ⍵⊣w_img (⍉⍵) ⍺}
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
pp3←{⍺←'○' ⋄ p l←⍵ ⋄ o←0⍴⍨≢p ⋄ _←l{z⊣o+←⍵≠z←⍺[⍵]}⍣≡⍳≢l ⋄ i←⍋o
 d←(⍳≢p)≠p ⋄ _←p{z⊣d+←⍵≠z←⍺[⍵]}⍣≡p ⋄ p←i⍳p[i] ⋄ d←d[i] ⋄ lbl←((≢p)⍴⍺)[i]
 lyr←{i←⍸⍺=d ⋄ k v←↓⍉p[i],∘⊂⌸i ⋄ (⍵∘{⍺[⍵]}¨v)⍺⍺¨@k⊢⍵}                    
 (p=⍳≢p)⌿⊃⍺⍺ lyr⌿(1+⍳⌈/d),⊂⍉∘⍪∘⍕¨lbl}                                     
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
Sfn←aws _s (('TFF⎕'_tk) _o ('TFFI⎕'_tk)) _s aws _as {P⌽∊⍵}
Prim←prim _as P
Vt←(⊢⍳⍨0⊃⊣)⊃¯1,⍨1⊃⊣
Var←{⍺(aaww _o aw _o (name _as ⌽) _t (⍺⍺=Vt) _as (⍺⍺V∘,∘⊃))⍵}
Num←float _o int _as (N∘⌽)
Strand←0 Var _s (0 Var _some) _as (3 A∘⌽)
Pex←{⍺(rpar _s Ex _s lpar)⍵}
Atom←Strand _o (0 Var _as (1 A)) _o (Num _some _as (0 A∘⌽)) _o Pex
Semx←{⍺(Ex _o (_yes _as {3 A,⊂P,';'}))⍵}
Brk←rbrk _s (Semx _s (semi _s Semx _any)) _s lbrk _as (3 E∘⌽)
Idx←Brk _s (_yes _as {P,'['}) _s Atom _as (2 E∘⌽)
Blrp←{⍺(⍺⍺ _s (⍵⍵ Slrp ∇))⍵}
Slrp←{⍺(⍺⍺ _o (⍵⍵ _s ∇) _o ((1 _eat) _s ∇))⍵}
Fa←{e←(⊂'⍵⍵' '⍺⍺','⍺⍵')∘,∘⊂¨↓⍉¯1+3 3 2 2⊤(6 4 4⌿1 5 9)+2×⍳14
 a←↓⍉↑(e,¨¨⊂⍺)Gex _o Ex _o Fex Stmts _then Fn¨⊂⍵
 m←(0=⊃a)∧∧⌿(∨⍀∘.=⍨⍳14)∨∘.≢⍨1⊃a
 ~∨⌿m:(⌈⌿⊃a) ⍬ ⍺ ⍵
 (1=+⌿m)∧2>m⍳1:0(,⊂0(N∆⍳'F')1 0⍪¨1+@0⊃(0⍴⊂4⍴⊂⍬),⊃m⌿1⊃a)⍺ ⍵
 z←⍪⌿↑(⊂0(N∆⍳'F')¯1 0),({1(N∆⍳'F')⍵ 0}¨1+m⌿⍳14)⍪¨(2+@0⊃)¨m⌿1⊃a 
 0(,⊂z)⍺ ⍵}
Fn←{0=≢⍵:0 ⍬ ⍺ '' ⋄ ns←(3⊃z)⌿⍨m←((3=1⊃⊢)∧¯1=2⊃⊢)⊢z←⍪⌿↑⍵ ⋄ 0=≢ns:0(,⊂z)⍺ ''
 r←↓⍉↑⍺∘Fa¨ns ⋄ 0<c←⌈⌿⊃r:c ⍬ ⍺ ⍵
 z←(⊂¨¨z)((⊃⍪⌿)⊣@{m})¨⍨↓(m⌿0⊃z)+@0⍉↑⊃¨1⊃r
 0(,⊂z)⍺ ''}
Pfe←{⍺(rpar _s Fex _s lpar)⍵}
Bfn←rbrc Blrp lbrc _as {0(N∆⍳'F')¯1(,⊂⌽1↓¯1↓⍵)}
Fnp←Prim _o (1 Var) _o Sfn _o Bfn _o Pfe
Mop←{⍺((mop _as P) _s Afx _as (1 O))⍵}
Dop1←{⍺((dop1 _as P) _s Afx _as (2 O∘⌽))⍵}
Dop2←{⍺(Atom _s (dop2 _as P) _s Afx _as (2 O∘⌽))⍵}
Dop3←(dop3 _as P) _s Atom _as (2 O∘⌽) _o (dot _s jot _as (P∘⌽) _as (1 O))
Bop←{⍺(rbrk _s Ex _s lbrk _s (_yes _as {P,'['}) _s Afx _as (2 O∘⌽))⍵}
Afx←Mop _o (Fnp _s (Dop1 _o Dop3 _opt) _as (⍪/⍳∘≢+@0⍉∘↑∘⌽)) _o Dop2 _o Bop
Trn←{⍺(Afx _s ((Afx _o Idx _o Atom) _s (∇ _opt) _opt))⍵} _as (3 F∘⌽)
Bind←{⍺(gets _s (name _as ⌽) _env (⊣⍪¨⍨⍺⍺,⍨∘⊂⊢) _as (0(N∆⍳'B')⍺⍺,∘⊂⊢))⍵}
Asgn←gets _s Brk _s (name _as ⌽ _t (0=Vt) _as (0 V∘,∘⊃)) _as (4 E∘⌽)
Fex←Afx _s (Trn _opt) _s (1 Bind _any) _as (⍪/⍳∘≢+@0⍉∘↑∘⌽)
IAx←Idx _o Atom _s (dop2 _not)
App←Afx _s (IAx _opt) _as {(≢⍵)E⌽⍵}
Ex←IAx _s {⍺(0 Bind _o Asgn _o App _s ∇ _opt)⍵} _as (⍪/⍳∘≢+@0⍉∘↑∘⌽)
Gex←Ex _s grd _s Ex _as (G∘⌽)
Nlrp←sep _o eot Slrp (lbrc Blrp rbrc)
Stmts←{⍺(sep _any _s (Nlrp _then (⍺⍺ _s eot∘⌽)) _any _s eot)⍵}
Ns←nss Blrp nse _then (Ex _o Fex Stmts _then Fn) _s eot _as (1 F)
ps←{⍞←'P' ⋄ 0≠⊃c a e r←⍬ ⍬ Ns∊{⍵/⍨∧\'⍝'≠⍵}¨⍵,¨⎕UCS 10:⎕SIGNAL c
 (↓s(-⍳)@3↑⊃a)e(s←∪0(,'⍵')(,'⍺')'⍺⍺' '⍵⍵',3⊃⊃a)}
⍝ A  B  E  F  G  L  M  N  O  P  V  Z
⍝ 0  1  2  3  4  5  6  7  8  9 10 11
tt←{⍞←'C' ⋄ ((d t k n)exp sym)←⍵ ⋄ I←{(⊂⍵)⌷⍺}

 ⍝ Convert to Parent Vector 
 _←2{l[⍵[i]]←⍵[¯1+i←⍸0,2=⌿i]⊣p[⍵]←⍺[i←⍺⍸⍵]}⌿⊢∘⊂⌸d⊣p←l←⍳≢d

 ⍝ Binding Table
 bv←I@{1=t[⍵]}⍣≡⍨i@(p[i←⍸1=t[p]])⍳≢p

 ⍝ Mark and record top-level bindings
 tlb←⍸(t=1)∧{⍵=p[⍵]}p I@{3≠t[⍵]}⍣≡⍳≢p ⋄ rn←⍸(t=3)∧p=⍳≢p
 tlx←k[tlb],n[tlb],⍪p I⍣≡tlb ⋄ k[tlb]×←2

 ⍝ Lift Functions
 i←⍸(t=3)∧p≠⍳s←≢p ⋄ l←i(s+⍳)@{⍵∊i}l ⋄ p l(⊣,I)←⊂i ⋄ t k,←10 1⍴⍨¨≢i 
 n,←i ⋄ p[i]←i ⋄ l[j]←⊃(⌽i),j←⍸(p=⍳≢p)∧l=⍳≢l ⋄ l[i]←(≢i)↑(⊃i),i

 ⍝ Wrap Return Expressions
 i←⍸((t∊0 2)∧t[p]=3)∨(t[p]∊3 4)∧(~(⍳≢l)∊¯1@{⍵=⍳≢⍵}l)∧(t∊0 2)∨(t=1)∧k=0
 p,←p[i] ⋄ p[i]←(≢l)+⍳≢i ⋄ l←i((≢l)+⍳)@{⍵∊i}l ⋄ l,←l[i] ⋄ l[i]←i
 t k n,←2 0 0⍴⍨¨≢i

 ⍝ Lift Guard Tests
 fi←p[i←⍸(t∊⍳3)∧(l=⍳≢l)∧t[p]=4] ⋄ l←j@(j←⍸l∊i)⊢l 
 l[i]←fl[j]@(j←⍸fi≠fl←l[fi])⊢i ⋄ l[fi]←i ⋄ n[fi]←i ⋄ p[i]←p[fi]

 ⍝ Lift Expressions
 i←⍸(t∊8,⍳3)∧m←~t[p]∊3 4 ⋄ xw←x@(l[x])⊢x@(x←⍸m)⊢l ⋄ l←i((≢l)+⍳)@{⍵∊i}l
 p,←∆←p[i] ⋄ l,←l[i] ⋄ t,←10⍴⍨≢i ⋄ k,←(8∘=∨k[i]∧1∘=)t[i] ⋄ n,←i
 l[∪∆]←∆⊢∘⊃⌸i ⋄ net←{~t[⍵]∊8,⍳5} ⋄ wk←xw I p∘I@(xw∘I=⊢)⍣≡
 l[j]←((j×⊢)+×∘~)∘net⍨wk@net⍣≡wk⊢j←i~∆ ⋄ p[i]←p I@(~3 4∊⍨t∘I)⍣≡∆

 ⍝ Resolve Local Names
 vl←p I@{(l=⍳≢l)∧t[p]=4}l
 loc←{m←⍺{(t[⍵]=1)∧n[⍵]=⍺⍺} ⋄ b+⍺×0=b←bv[×∘m⍨vl I@(~m)⍣≡l[⍵]]}
 n[i]←n[i]loc p[i←⍸(t=10)∧n<¯4]

 ⍝ Collapse Variable and Binding Reference Chains
 n←bv I@{t[0⌈⍵]=1}I@{t[0⌈⍵]=10}⍣≡⍨n

 ⍝ Inline Functions

 ⍝ Build call sites, operator reference, closure, and free variable tables
 t3←t[0⌈n]=3 ⋄ ov←(8=tp←t[p])∧lv←(t=10)∧n≥0 ⋄ ev←lv∧(tp=2)∨(tp=1)∧k[p]=2
 xc←((m[l]∧(~m)∧2=⊢)∨m∧1=⊢)k[p]⊣m←l=⍳≢l ⋄ i←⍸ov∧t3∧xc ⋄ of←n[i] ⋄ os←p[i]
 i←⍸ov∧(nos←n∊os)∨t3∧~xc ⋄ on←n[i] ⋄ oi←p[i] ⋄ i←⍸ov ⋄ pom←p[i] ⋄ nom←n[i]
 i←⍸ev∧t3∨nos ⋄ cf←n[i] ⋄ cs←p[i] ⋄ x←⍸ev
 _←{(oi,←(≢¨g)[i]⌿pom)(on,←∊(g←(⊃⊢∘⊂⌸⌿⍵),⊂⍬)[i←(∪⊃⍵)⍳nom])}⍣≡oi on
 i←(∪oi)⍳n[x] ⋄ g←(oi⊢∘⊂⌸on),⊂⍬ ⋄ on←∊g[i] ⋄ oi←(≢¨g)[i]⌿p[x]
 fi←⍬ ⋄ ftn←0 2⍴⍬ ⋄ ci←⍬ ⋄ ctvr←0 3⍴⍬

 ⍝ Propagate and ground free references up the lexical stack
 _←{g←(⊃⊢∘⊂⌸⌿⍵),⊂2/⍪⍬ ⋄ x←(∪⊃⍵)∘⍳ ⋄ fi ftn⍪←⍵⍪¨((≢¨g)[i]⌿os)(⊃⍪⌿g[i←x of])
  s←⍬ ⋄ tv←2/⍪⍬ ⋄ r←⍬
  _←{ci,←s,←ns←(≢¨g)[i←x⊃⍵]⌿1⊃⍵
   ctvr⍪←ntv,r,←nr←n I@{t[0⌈⍵]=10}(⊢/tv⍪←ntv←⊃⍪/g[i])loc ns
   (nr[i])(ns[i←⍸(nr≥0)∧1=⊣/ntv])}⍣{(0=≢⊃⍺)∨⍺≡⍵}(cf,on,⊢/ctvr)(cs,oi,ci)
  (p[s[i]])(tv[i←⍸r<0;])
 }⍣{(0=≢⊃⍺)∨⍺≡⍵}(p I@{t[⍵]≠3}⍣≡i)(k[i],⍪n[i←⍸(t=10)∧n<¯4])

 ⍝ Inline Primitive References
 i←⍸(t=10)∧(n≥0)∧t[0⌈n]=9 ⋄ t[i]←9 ⋄ k[i]←0 ⋄ n[i]←n[n[i]] 

 ⍝ Propagate constants
 ⍝ Fold constants
 ⍝ Dead, useless code elimination
 ⍝ Allocate frames

 ⍝ Extend top-level exports with their bindings
 tlx,←bv[tlb] ⋄ k[tlb](⊣+⊢×0=⊣)←3

 p l t k n exp sym tlx rn fi ftn ci ctvr oi on}
gck← (0 0)(0 1)(0 3)(1 2)(1 3)(2 0)(2 1)(2 2)(2 3)(3 1)(4 0)(7 0)(8 1)(8 2)
gcv← 'Aa' 'Av' 'As' 'Bf' 'Bv' 'Er' 'Em' 'Ed' 'Ei' 'Fn' 'Gd' 'Na' 'Om' 'Od' 
gck,←(9 0)(10 0)(10 1)
gcv,←'Pm' 'Va'  'Vf'  
gck+←⊂1 0
gcv,←⊂'{''/* Unhandled '',(⍕⍺),'' */'',NL}'
NL←⎕UCS 13 10

gc←{⍞←'G' ⋄ p l t k n exp sym tlx rn fi ftn ci ctvr oi on←⍵
 I←{(⊂⍵)⌷⍺} ⋄ com←{⊃{⍺,',',⍵}/⍵}
 fx←(∪fi)∘⍳ ⋄ ftn←(fi{⊂∪⍵}⌸ftn),⊂0 2⍴⍬
 cx←(∪ci)∘⍳ ⋄ ctvr←(ci{⊂∪⍵}⌸ctvr),⊂0 3⍴⍬
 ox←(∪oi)∘⍳ ⋄ on←(oi{⊂∪⍵}⌸on),⊂⍬
 nam←{'∆'⎕R'__'⊢⍕sym⊃⍨|⍵}
 o←0⍴⍨≢p ⋄ _←l{z⊣o+←⍵≠z←⍺[⍵]}⍣≡⍳≢l ⋄ d←(⍳≢p)≠p ⋄ _←{z⊣d+←⍵≠z←⍺[⍵]}⍣≡⍨p
 z←⍪⍳≢p ⋄ _←p{z,←p[⍵]}⍣≡z ⋄ i←⍋(-1+d)(1+o I ↑)⍤0 1⊢⌽z
 var←{('va' 'fv'⊃⍨⍵<0),⍕|⍵}
 ast←(⍉↑d p l(1+t)k n(⍳≢p))[i;] ⋄ ks←{⍵⊂[0]⍨(⊃⍵)=⍵[;0]}
 Aaa←{'(1,dim4(',(⍕≢⍵),'),array(',(⍕≢⍵),',',(Aav ⍵),'));',NL}
 Aas←{'(0,eshp,constant(',('¯'⎕R'-'⍕⍵),',eshp,',('f64' 's32'⊃⍨⍵=⌊⍵),'));',NL}
 Aav←{'std::vector<',('DI'⊃⍨∧/⍵=⌊⍵),'>{',('¯'⎕R'-'com⍕¨⍵),'}.data()'}
 Aa←{h←'A va',⍕6⊃⍺ ⋄ 1=≢ns←dis¨⍵:h,Aas⊃ns ⋄ h,Aaa ns}
 As←{'A va',(⍕6⊃⍺),'(-1,eshp,array());',NL}
 Av←{'A va',(⍕6⊃⍺),'=',(⊃,/dis¨⍵),';',NL}
 Bv←{('gv_',nam 5⊃⍺),'=',(⊃dis¨⍵),';',NL}
 Bcv←{t v r←⍵ ⋄ ts←t⊃'A' 'FN' ⋄ vp←'&' '&fn' 'this->fv'⊃⍨2⌊t+2×r<0
  rn←t⊃('gv_',nam v)(⍕|r) ⋄ x←'' '_c'⊃⍨(t=1)∧r>0
  ts,'*fv',(⍕|v),x,'=',vp,rn,x,';',NL,' '}
 Bf←{i←fx⊢x←∪(0(0 5)⊃⍵),(on⊃⍨ox 6⊃⍺),{r⌿⍨(1=0⌷⍉⍵)∧0<r←2⌷⍉⍵}tvr←ctvr⊃⍨cx 6⊃⍺
  '{',NL,⍨'}',⍨⊃,/((⊂Bcv)⍤1⊢tvr),⊃,/x Ecf¨ftn[i]}
 Ecv←{t v r←⍵ ⋄ ts←t⊃'A' 'FN' ⋄ vp←'&va' '&fn' 'this->fv'⊃⍨2⌊t+2×r<0
  ts,'*fv',(⍕|v),x,'=',vp,(⍕|r),(x←'' '_c'⊃⍨(t=1)∧r>0),';',NL,'  '}
 Ecf←{⊃,/⍺{'fn',(⍕⍺⍺),'_c.fv',x,'=fv',(x←(⍕|⍵),⍺⊃'' '_c'),';',NL,'  '}/⍵}
 Ecz←{i←fx⊢x←∪⍵,(on⊃⍨ox ⍺),{r⌿⍨(1=0⌷⍉⍵)∧0<r←2⌷⍉⍵}tvr←ctvr⊃⍨cx ⍺
  ⊃,/((⊂Ecv)⍤1⊢tvr),⊃,/x Ecf¨ftn[i]}
 Ed←{x f y←dis¨⍵ ⋄ z←'A va',(⍕6⊃⍺),';',NL
  z,' {',((6⊃⍺)Ecz 1(0 5)⊃⍵),'(',f,'_c)(',(com('va',⍕6⊃⍺)x y),');}',NL}
 Ei←{'std::vector<A> va',(⍕6⊃⍺),'={',(com dis¨⍵),'};',NL}
 Em←{f v←dis¨⍵ ⋄ z←'A va',(⍕6⊃⍺),';',NL
  z,' {',((6⊃⍺)Ecz 0(0 5)⊃⍵),'(',f,'_c)(',('va',⍕6⊃⍺),',',v,');}',NL}
 Er←{'z=',(⊃dis¨⍵),';z.f=1;R;',NL}
 Fn←{NL,'DF(',('fn',⍕6⊃⍺),'_f){',NL,(⊃,/' ',¨dis¨⍵),'}',NL}
 Gd←{t←⍺ Va ⍬ ⋄ z←'{if(cnt(',t,')!=1)err(5);',NL
  z,←' if(!(',t,'.v.isinteger()||',t,'.v.isbool()))err(11);',NL
  z,←' I t=',t,'.v.as(s32).scalar<I>();if(t!=0&&t!=1)err(11);',NL
  z,' if(t){',NL,(⊃,/' ',¨dis¨⍵),' }}',NL}
 Na←{sym⌷⍨|5⊃⍺}
 Oc←{com{'_c',⍨⍣('va'≢2↑⍵)⊢⍵}¨⍵}
 Om←{f v←dis¨⍵ ⋄ f,'_o fn',(⍕6⊃⍺),'_c(',(Oc⊂v),');',NL}
 Od←{x f y←dis¨⍵ ⋄ f,'_o fn',(⍕6⊃⍺),'_c(',(Oc x y),');',NL}
 Pm←{nams⊃⍨syms⍳sym⌷⍨|5⊃⍺}
 Zi←{'I isfn',(⍕⍵),'=0;',NL}
 Zp←{n←'fn',⍕⍵ ⋄ z←'S ',n,'_f:FN{MFD;DFD;',n,'_f():FN("",0,0){};'
  z,←⊃,/{NL,' ',(⍺⊃'A' 'FN'),'*fv',(⍕|⍵),(⍺⊃'' '_c'),';'}/ftn⊃⍨fx ⍵
  z,'};',NL,n,'_f ',n,'_c;MF(',n,'_f){',n,'_c(z,A(),r);}',NL}
 gx←{⊃t n p v←⍵:'EF(',(com(⊂nam n),'fn'∘,¨(⍕v)(⍕p)),');',NL
  'A gv_',(nam n),';',NL}
 Va←{(x←5⊃⍺)∊-1+⍳4:,'r' 'l' 'll' 'rr'⊃⍨¯1+|x ⋄ ('va' '*fv'⊃⍨x<0),⍕|x}
 Vf←{('fn' '*fv'⊃⍨x<0),⍕|x←5⊃⍺}
 dis←{h←,1↑⍵ ⋄ c←ks 1↓⍵ ⋄ h(⍎gcv⊃⍨gck⍳⊂h[3 4])c}
 z←(⊂rth),(rtn[syms⍳∪⊃,/deps⌿⍨syms∊sym]),(,/Zp¨⍸t=3),(,/Zi¨rn),(⊂gx)⍤1⊢tlx
 ⊃,/z,dis¨ks ast⊣⍞←⎕UCS 10}

syms ←,¨'+'   '-'   '×'   '÷'   '*'   '⍟'   '|'    '○'     '⌊'    '⌈'   '!'
nams ←  'add' 'sub' 'mul' 'div' 'exp' 'log' 'res'  'cir'   'min'  'max' 'fac'
syms,←,¨'<'   '≤'   '='   '≥'   '>'   '≠'   '~'    '∧'     '∨'    '⍲'   '⍱'
nams,←  'lth' 'lte' 'eql' 'gte' 'gth' 'neq' 'not'  'and'   'lor'  'nan' 'nor'
syms,←,¨'⌷'   '['   '⍳'   '⍴'   ','   '⍪'   '⌽'    '⍉'     '⊖'    '∊'   '⊃'
nams,←  'sqd' 'brk' 'iot' 'rho' 'cat' 'ctf' 'rot'  'trn'   'rtf'  'mem' 'dis'
syms,←,¨'≡'   '≢'   '⊢'   '⊣'   '⊤'   '⊥'   '/'    '⌿'     '\'    '⍀'   '?'
nams,←  'eqv' 'nqv' 'rgt' 'lft' 'enc' 'dec' 'red'  'rdf'   'scn'  'scf' 'rol'
syms,←,¨'↑'   '↓'   '¨'   '⍨'   '.'   '⍤'   '⍣'    '∘'     '∪'    '∩'
nams,←  'tke' 'drp' 'map' 'com' 'dot' 'rnk' 'pow'  'jot'   'unq'  'int'
syms,←,¨'⍋'   '⍒'   '∘.'  '⍷'   '⊂'   '⌹'   '⎕FFT' '⎕IFFT' '∇'    ';'  
nams,←  'gdu' 'gdd' 'oup' 'fnd' 'par' 'mdv' 'fft'  'ift'   'this' 'span'
syms,←⊂'%u' ⋄ nams,←⊂''
deps←⊂¨syms
deps[syms⍳,¨'∧⌿/.⍪⍤\⍀']←,¨¨'∨∧' '¨⌿' '¨/' '¨/.' ',⍪' '¨⌷⍤' '¨\' '¨⍀'
deps[syms⍳⊂'∘.']←⊂(,'¨')'∘.'

rth←''
rtn←(⍴nams)⍴⊂''
rth,←'#include <time.h>',NL
rth,←'#include <stdint.h>',NL
rth,←'#include <inttypes.h>',NL
rth,←'#include <limits.h>',NL
rth,←'#include <float.h>',NL
rth,←'#include <locale>',NL
rth,←'#include <codecvt>',NL
rth,←'#include <math.h>',NL
rth,←'#include <memory>',NL
rth,←'#include <algorithm>',NL
rth,←'#include <string>',NL
rth,←'#include <cstring>',NL
rth,←'#include <vector>',NL
rth,←'#include <unordered_map>',NL
rth,←'#include <arrayfire.h>',NL
rth,←'using namespace af;',NL
rth,←'',NL
rth,←'#if AF_API_VERSION < 35',NL
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
rth,←'#define OM(n,nm,sm,sd,mf,df) S n##_o:MOP{mf;df;\',NL
rth,←' n##_o(FN&l):MOP(nm,sm,sd,l){}};',NL
rth,←'#define OD(n,nm,sm,sd,mf,df) S n##_o:DOP{mf;df;\',NL
rth,←' n##_o(FN&l,FN&r):DOP(nm,sm,sd,l,r){}\',NL
rth,←' n##_o(const A&l,FN&r):DOP(nm,sm,sd,l,r){}\',NL
rth,←' n##_o(FN&l,const A&r):DOP(nm,sm,sd,l,r){}};',NL
rth,←'#define MT',NL
rth,←'#define DID inline array id(dim4)',NL
rth,←'#define MFD inline V operator()(A&,const A&)',NL
rth,←'#define MAD inline V operator()(A&,const A&,D)',NL
rth,←'#define DFD inline V operator()(A&,const A&,const A&)',NL
rth,←'#define DAD inline V operator()(A&,const A&,const A&,D)',NL
rth,←'#define DI(n) inline array n::id(dim4 s)',NL
rth,←'#define ID(n,x,t) DI(n##_f){R constant(x,s,t);}',NL
rth,←'#define MF(n) inline V n::operator()(A&z,const A&r)',NL
rth,←'#define MA(n) inline V n::operator()(A&z,const A&r,D ax)',NL
rth,←'#define DF(n) inline V n::operator()(A&z,const A&l,const A&r)',NL
rth,←'#define DA(n) inline V n::operator()(A&z,const A&l,const A&r,D ax)',NL
rth,←'#define SF(n,x) inline V n::operator()(A&z,const A&l,const A&r){\',NL
rth,←' if(l.r==r.r&&l.s==r.s){\',NL
rth,←'  z.r=l.r;z.s=l.s;const array&lv=l.v;const array&rv=r.v;x;R;}\',NL
rth,←' if(!l.r){\',NL
rth,←'  z.r=r.r;z.s=r.s;const array&rv=r.v;array lv=tile(l.v,r.s);x;R;}\',NL
rth,←' if(!r.r){\',NL
rth,←'  z.r=l.r;z.s=l.s;array rv=tile(r.v,l.s);const array&lv=l.v;x;R;}\',NL
rth,←' if(l.r!=r.r)err(4);if(l.s!=r.s)err(5);err(99);}',NL
rth,←'#define EF(ex,fun,init) EXPORT V ex##_dwa(lp*z,lp*l,lp*r){try{\',NL
rth,←'  A cl,cr,za;if(!is##init){init##_c(za,cl,cr);is##init=1;}\',NL
rth,←'  cpda(cr,r);cpda(cl,l);fun##_c(za,cl,cr);cpad(z,za);}\',NL
rth,←' catch(U n){derr(n);}\',NL
rth,←' catch(exception e){msg=mkstr(e.what());dmx.e=msg.c_str();derr(500);}}\',NL
rth,←'EXPORT V ex##_cdf(A*z,A*l,A*r){try{fun##_c(*z,*l,*r);}catch(U n){derr(n);}\',NL
rth,←' catch(exception x){msg=mkstr(x.what());dmx.e=msg.c_str();derr(500);}}',NL
rth,←'',NL
rth,←'typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD,APLP,APLU,APLV,APLW,APLZ,',NL
rth,←' APLR,APLF,APLQ}APLTYPE;',NL
rth,←'typedef long long L;typedef int I;typedef int16_t S16;typedef int8_t S8;',NL
rth,←'typedef double D;typedef unsigned char U8;typedef unsigned U;',NL
rth,←'typedef dim_t B;typedef cdouble DZ;typedef void V;typedef std::string STR;',NL
rth,←'',NL
rth,←'S{U f=3;U n;U x=0;wchar_t*v=L"Co-dfns";const wchar_t*e;V*c;}dmx;',NL
rth,←'S lp{S{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[1];}*p;};',NL
rth,←'S dwa{B z;S{B z;V*(*ga)(U,U,B*,S lp*);V(*p[16])();V(*er)(V*);}*ws;V*p[4];};',NL
rth,←'S dwa*dwafns;Z V derr(U n){dmx.n=n;dwafns->ws->er(&dmx);}',NL
rth,←'EXPORT I DyalogGetInterpreterFunctions(dwa*p){',NL
rth,←' if(p)dwafns=p;else R 0;if(dwafns->z<sizeof(S dwa))R 16;R 0;}',NL
rth,←'Z V err(U n,wchar_t*e){dmx.e=e;throw n;}Z V err(U n){dmx.e=L"";throw n;}',NL
rth,←'S A{I r,f;dim4 s;array v;A(I r,dim4 s,array v):r(r),f(1),s(s),v(v){}',NL
rth,←' A():r(0),f(0),s(dim4()),v(array()){}};',NL
rth,←'dim4 eshp=dim4(0,(B*)NULL);',NL
rth,←'std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> strconv;',NL
rth,←'std::wstring msg;',NL
rth,←'',NL
rth,←'S FN{STR nm;I sm;I sd;FN(STR nm,I sm,I sd):nm(nm),sm(sm),sd(sd){}',NL
rth,←' FN():nm(""),sm(0),sd(0){}',NL
rth,←' virtual array id(dim4 s){err(16);R array();}',NL
rth,←' virtual V operator()(A&z,const A&r){err(99);}',NL
rth,←' virtual V operator()(A&z,const A&r,D ax){err(99);}',NL
rth,←' virtual V operator()(A&z,const A&l,const A&r){err(99);}',NL
rth,←' virtual V operator()(A&z,const A&l,const A&r,D ax){err(99);}};',NL
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
rth,←'std::wstring mkstr(const char*s){R strconv.from_bytes(s);}',NL
rth,←'I scm(FN&f){R f.sm;}I scm(const A&a){R 1;}',NL
rth,←'I scd(FN&f){R f.sd;}I scd(const A&a){R 1;}',NL
rth,←'B cnt(dim4 s){B c=1;DO(4,c*=s[i]);R c;}',NL
rth,←'B cnt(const A&a){B c=1;DO(a.r,c*=a.s[i]);R c;}',NL
rth,←'B cnt(lp*d){B c=1;DO(RANK(d),c*=SHAPE(d)[i]);R c;}',NL
rth,←'array scl(I x){R constant(x,dim4(1),s32);}',NL
rth,←'A scl(array v){R A(0,dim4(1),v);}',NL
rth,←'dtype mxt(dtype at,dtype bt){if(at==c64||bt==c64)R c64;',NL
rth,←' if(at==f64||bt==f64)R f64;',NL
rth,←' if(at==s32||bt==s32)R s32;if(at==s16||bt==s16)R s16;',NL
rth,←' if(at==b8||bt==b8)R b8;err(16);R f64;}',NL
rth,←'dtype mxt(const array&a,const array&b){R mxt(a.type(),b.type());}',NL
rth,←'dtype mxt(dtype at,const A&b){R mxt(at,b.v.type());}',NL
rth,←'Z array da16(B c,dim4 s,lp*d){std::vector<S16>b(c);',NL
rth,←' S8*v=(S8*)DATA(d);DOB(c,b[i]=v[i]);R array(s,b.data());}',NL
rth,←'Z array da8(B c,dim4 s,lp*d){std::vector<char>b(c);',NL
rth,←' U8*v=(U8*)DATA(d);DOB(c,b[i]=1&(v[i/8]>>(7-(i%8))))',NL
rth,←' R array(s,b.data());}',NL
rth,←'V cpad(lp*d,A&a){I t;B c=cnt(a);if(!a.f){d->p=NULL;R;}',NL
rth,←' switch(a.v.type()){CS(c64,t=APLZ);',NL
rth,←'  CS(s32,t=APLI);CS(s16,t=APLSI);CS(b8,t=APLTI);CS(f64,t=APLD);',NL
rth,←'  default:if(c)err(16);t=APLI;}',NL
rth,←' B s[4];DO(a.r,s[a.r-(i+1)]=a.s[i]);dwafns->ws->ga(t,a.r,s,d);',NL
rth,←' if(c)a.v.host(DATA(d));}',NL
rth,←'V cpda(A&a,lp*d){if(d==NULL)R;if(15!=TYPE(d))err(16);if(4<RANK(d))err(16);',NL
rth,←' dim4 s(1);DO(RANK(d),s[RANK(d)-(i+1)]=SHAPE(d)[i]);B c=cnt(d);',NL
rth,←' switch(ETYPE(d)){',NL
rth,←'  CS(APLZ,a=A(RANK(d),s,c?array(s,(DZ*)DATA(d)):scl(0)))',NL
rth,←'  CS(APLI,a=A(RANK(d),s,c?array(s,(I*)DATA(d)):scl(0)))',NL
rth,←'  CS(APLD,a=A(RANK(d),s,c?array(s,(D*)DATA(d)):scl(0)))',NL
rth,←'  CS(APLSI,a=A(RANK(d),s,c?array(s,(S16*)DATA(d)):scl(0)))',NL
rth,←'  CS(APLTI,a=A(RANK(d),s,c?da16(c,s,d):scl(0)))',NL
rth,←'  CS(APLU8,a=A(RANK(d),s,c?da8(c,s,d):scl(0)))',NL
rth,←'  default:err(16);}}',NL
rth,←'EXPORT A*mkarray(lp*d){A*z=new A;cpda(*z,d);R z;}',NL
rth,←'EXPORT V frea(A*a){delete a;}',NL
rth,←'EXPORT V exarray(lp*d,A*a){cpad(d,*a);}',NL
rth,←'EXPORT V afsync(){sync();}',NL
rth,←'EXPORT Window *w_new(char *k){R new Window(k);}',NL
rth,←'EXPORT I w_close(Window*w){R w->close();}',NL
rth,←'EXPORT V w_del(Window*w){delete w;}',NL
rth,←'EXPORT V w_img(lp*d,Window*w){A a;cpda(a,d);',NL
rth,←' w->image(a.v.as(a.r==2?f32:u8));}',NL
rth,←'EXPORT V w_plot(lp*d,Window*w){A a;cpda(a,d);w->plot(a.v.as(f32));}',NL
rth,←'EXPORT V w_hist(lp*d,D l,D h,Window*w){A a;cpda(a,d);',NL
rth,←' w->hist(a.v.as(u32),l,h);}',NL
rth,←'EXPORT V loadimg(lp*z,char*p,I c){array a=loadImage(p,c);',NL
rth,←' A b(a.numdims(),a.dims(),a.as(s16));cpad(z,b);}',NL
rth,←'EXPORT V saveimg(lp*im,char*p){A a;cpda(a,im);',NL
rth,←' saveImageNative(p,a.v.as(a.v.type()==s32?u16:u8));}',NL
rth,←'EXPORT V cd_sync(V){sync();}',NL
rtn[0],←⊂'NM(add,"add",1,1,DID,MFD,DFD,MT,MT)',NL
rtn[0],←⊂'add_f add_c;',NL
rtn[0],←⊂'ID(add,0,s32)',NL
rtn[0],←⊂'MF(add_f){z=r;}',NL
rtn[0],←⊂'SF(add_f,z.v=lv+rv)',NL
rtn[1],←⊂'NM(sub,"sub",1,1,DID,MFD,DFD,MT ,MT )',NL
rtn[1],←⊂'sub_f sub_c;',NL
rtn[1],←⊂'ID(sub,0,s32)',NL
rtn[1],←⊂'MF(sub_f){z.r=r.r;z.s=r.s;z.v=-r.v;}',NL
rtn[1],←⊂'SF(sub_f,z.v=lv-rv)',NL
rtn[1],←⊂'',NL
rtn[2],←⊂'NM(mul,"mul",1,1,DID,MFD,DFD,MT ,MT )',NL
rtn[2],←⊂'mul_f mul_c;',NL
rtn[2],←⊂'ID(mul,1,s32)',NL
rtn[2],←⊂'MF(mul_f){z.r=r.r;z.s=r.s;z.v=(r.v>0)-(r.v<0);}',NL
rtn[2],←⊂'SF(mul_f,z.v=lv*rv)',NL
rtn[2],←⊂'',NL
rtn[3],←⊂'NM(div,"div",1,1,DID,MFD,DFD,MT,MT)',NL
rtn[3],←⊂'div_f div_c;',NL
rtn[3],←⊂'ID(div,1,s32)',NL
rtn[3],←⊂'MF(div_f){z.r=r.r;z.s=r.s;z.v=1.0/r.v.as(f64);}',NL
rtn[3],←⊂'SF(div_f,z.v=lv.as(f64)/rv.as(f64))',NL
rtn[4],←⊂'NM(exp,"exp",1,1,DID,MFD,DFD,MT ,MT )',NL
rtn[4],←⊂'ID(exp,1,s32)',NL
rtn[4],←⊂'exp_f exp_c;',NL
rtn[4],←⊂'MF(exp_f){z.r=r.r;z.s=r.s;z.v=exp(r.v.as(f64));}',NL
rtn[4],←⊂'SF(exp_f,z.v=pow(lv.as(f64),rv.as(f64)))',NL
rtn[4],←⊂'',NL
rtn[5],←⊂'NM(log,"log",1,1,MT ,MFD,DFD,MT ,MT )',NL
rtn[5],←⊂'log_f log_c;',NL
rtn[5],←⊂'MF(log_f){z.r=r.r;z.s=r.s;z.v=log(r.v.as(f64));}',NL
rtn[5],←⊂'SF(log_f,z.v=log(rv.as(f64))/log(lv.as(f64)))',NL
rtn[5],←⊂'',NL
rtn[6],←⊂'NM(res,"res",1,1,DID,MFD,DFD,MT ,MT )',NL
rtn[6],←⊂'res_f res_c;',NL
rtn[6],←⊂'ID(res,0,s32)',NL
rtn[6],←⊂'MF(res_f){z.r=r.r;z.s=r.s;z.v=abs(r.v).as(r.v.type());}',NL
rtn[6],←⊂'SF(res_f,z.v=rv-lv*floor(rv.as(f64)/(lv+(0==lv))))',NL
rtn[6],←⊂'',NL
rtn[7],←⊂'NM(cir,"cir",1,1,MT,MFD,DFD,MT,MT)',NL
rtn[7],←⊂'cir_f cir_c;',NL
rtn[7],←⊂'MF(cir_f){z.r=r.r;z.s=r.s;z.v=Pi*r.v.as(f64);}',NL
rtn[7],←⊂'SF(cir_f,array fv=rv.as(f64);',NL
rtn[7],←⊂' if(!l.r){I x=l.v.as(s32).scalar<I>();if(abs(x)>10)err(16);',NL
rtn[7],←⊂'  switch(x){CS(0,z.v=sqrt(1-fv*fv))CS(1,z.v=sin(fv))CS(2,z.v=cos(fv))',NL
rtn[7],←⊂'   CS(3,z.v=tan(fv))CS(4,z.v=sqrt(1+fv*fv))CS(5,z.v=sinh(fv))',NL
rtn[7],←⊂'   CS(6,z.v=cosh(fv))CS(7,z.v=tanh(fv))CS(8,z.v=sqrt(fv*fv-1))CS(9,z.v=fv)',NL
rtn[7],←⊂'   CS(10,z.v=abs(fv))CS(-1,z.v=asin(fv))CS(-2,z.v=acos(fv))',NL
rtn[7],←⊂'   CS(-3,z.v=atan(fv))CS(-4,z.v=(fv+1)*sqrt((fv-1)/(fv+1)))',NL
rtn[7],←⊂'   CS(-5,z.v=asinh(fv))CS(-6,z.v=acosh(fv))CS(-7,z.v=atanh(fv))',NL
rtn[7],←⊂'   CS(-8,z.v=-sqrt(fv*fv-1))CS(-9,z.v=fv)CS(-10,z.v=fv)}R;}',NL
rtn[7],←⊂' if(anyTrue<I>(abs(lv)>10))err(16);B c=cnt(z);std::vector<I> a(c);',NL
rtn[7],←⊂' std::vector<D> b(c);lv.as(s32).host(a.data());fv.host(b.data());',NL
rtn[7],←⊂' std::vector<D> zv(c);',NL
rtn[7],←⊂' DOB(c,switch(a[i]){CS(0,zv[i]=sqrt(1-b[i]*b[i]))CS(1,zv[i]=sin(b[i]))',NL
rtn[7],←⊂'  CS(2,zv[i]=cos(b[i]))CS(3,zv[i]=tan(b[i]))CS(4,zv[i]=sqrt(1+b[i]*b[i]))',NL
rtn[7],←⊂'  CS(5,zv[i]=sinh(b[i]))CS(6,zv[i]=cosh(b[i]))CS(7,zv[i]=tanh(b[i]))',NL
rtn[7],←⊂'  CS(8,zv[i]=sqrt(b[i]*b[i]-1))CS(9,zv[i]=b[i])CS(10,zv[i]=abs(b[i]))',NL
rtn[7],←⊂'  CS(-1,zv[i]=asin(b[i]))CS(-2,zv[i]=acos(b[i]))CS(-3,zv[i]=atan(b[i]))',NL
rtn[7],←⊂'  CS(-4,zv[i]=(b[i]==-1)?0:(b[i]+1)*sqrt((b[i]-1)/(b[i]+1)))',NL
rtn[7],←⊂'  CS(-5,zv[i]=asinh(b[i]))CS(-6,zv[i]=acosh(b[i]))CS(-7,zv[i]=atanh(b[i]))',NL
rtn[7],←⊂'  CS(-8,zv[i]=-sqrt(b[i]*b[i]-1))CS(-9,zv[i]=b[i])CS(-10,zv[i]=b[i])})',NL
rtn[7],←⊂' z.v=array(z.s,zv.data());)',NL
rtn[8],←⊂'NM(min,"min",1,1,DID,MFD,DFD,MT ,MT )',NL
rtn[8],←⊂'min_f min_c;',NL
rtn[8],←⊂'ID(min,DBL_MAX,f64)',NL
rtn[8],←⊂'MF(min_f){z.r=r.r;z.s=r.s;z.v=floor(r.v).as(r.v.type());}',NL
rtn[8],←⊂'SF(min_f,z.v=min(lv,rv))',NL
rtn[8],←⊂'',NL
rtn[9],←⊂'NM(max,"max",1,1,DID,MFD,DFD,MT ,MT )',NL
rtn[9],←⊂'max_f max_c;',NL
rtn[9],←⊂'ID(max,-DBL_MAX,f64)',NL
rtn[9],←⊂'MF(max_f){z.r=r.r;z.s=r.s;z.v=ceil(r.v).as(r.v.type());}',NL
rtn[9],←⊂'SF(max_f,z.v=max(lv,rv))',NL
rtn[9],←⊂'',NL
rtn[10],←⊂'NM(fac,"fac",1,1,DID,MFD,DFD,MT ,MT )',NL
rtn[10],←⊂'fac_f fac_c;',NL
rtn[10],←⊂'ID(fac,1,s32)',NL
rtn[10],←⊂'MF(fac_f){z.r=r.r;z.s=r.s;z.v=factorial(r.v.as(f64));}',NL
rtn[10],←⊂'SF(fac_f,array lvf=lv.as(f64);array rvf=rv.as(f64);',NL
rtn[10],←⊂' z.v=exp(lgamma(1+rvf)-(lgamma(1+lvf)+lgamma(1+rvf-lvf))))',NL
rtn[11],←⊂'NM(lth,"lth",1,1,DID,MT ,DFD,MT ,MT )',NL
rtn[11],←⊂'lth_f lth_c;',NL
rtn[11],←⊂'ID(lth,0,s32)',NL
rtn[11],←⊂'SF(lth_f,z.v=lv<rv)',NL
rtn[11],←⊂'',NL
rtn[12],←⊂'NM(lte,"lte",1,1,DID,MT ,DFD,MT ,MT )',NL
rtn[12],←⊂'lte_f lte_c;',NL
rtn[12],←⊂'ID(lte,1,s32)',NL
rtn[12],←⊂'SF(lte_f,z.v=lv<=rv)',NL
rtn[12],←⊂'',NL
rtn[13],←⊂'NM(eql,"eql",1,1,DID,MT ,DFD,MT ,MT )',NL
rtn[13],←⊂'eql_f eql_c;',NL
rtn[13],←⊂'ID(eql,1,s32)',NL
rtn[13],←⊂'SF(eql_f,z.v=lv==rv)',NL
rtn[14],←⊂'NM(gte,"gte",1,1,DID,MT ,DFD,MT ,MT )',NL
rtn[14],←⊂'gte_f gte_c;',NL
rtn[14],←⊂'ID(gte,1,s32)',NL
rtn[14],←⊂'SF(gte_f,z.v=lv>=rv)',NL
rtn[14],←⊂'',NL
rtn[15],←⊂'NM(gth,"gth",1,1,DID,MT ,DFD,MT ,MT )',NL
rtn[15],←⊂'gth_f gth_c;',NL
rtn[15],←⊂'ID(gth,0,s32)',NL
rtn[15],←⊂'SF(gth_f,z.v=lv>rv)',NL
rtn[15],←⊂'',NL
rtn[16],←⊂'NM(neq,"neq",1,1,DID,MT ,DFD,MT ,MT )',NL
rtn[16],←⊂'neq_f neq_c;',NL
rtn[16],←⊂'ID(neq,0,s32)',NL
rtn[16],←⊂'SF(neq_f,z.v=lv!=rv)',NL
rtn[16],←⊂'',NL
rtn[17],←⊂'NM(not,"not",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[17],←⊂'not_f not_c;',NL
rtn[17],←⊂'MF(not_f){z.r=r.r;z.s=r.s;z.v=!r.v;}',NL
rtn[17],←⊂'DF(not_f){err(16);}',NL
rtn[17],←⊂'',NL
rtn[18],←⊂'NM(and,"and",1,1,DID,MT,DFD,MT,MT)',NL
rtn[18],←⊂'and_f and_c;',NL
rtn[18],←⊂'ID(and,1,s32)',NL
rtn[18],←⊂'SF(and_f,if(lv.isbool()&&rv.isbool())z.v=lv&&rv;',NL
rtn[18],←⊂' else if(allTrue<I>(lv>=0&&lv<=1&&rv>0&&rv<=1))z.v=lv&&rv;',NL
rtn[18],←⊂' else{A a(z.r,z.s,lv);A b(z.r,z.s,rv);',NL
rtn[18],←⊂'  lor_c(a,a,b);z.v=lv*(rv/((!a.v)+a.v));})',NL
rtn[19],←⊂'NM(lor,"lor",1,1,DID,MT ,DFD,MT ,MT )',NL
rtn[19],←⊂'lor_f lor_c;',NL
rtn[19],←⊂'ID(lor,0,s32)',NL
rtn[19],←⊂'SF(lor_f,if(rv.isbool()&&lv.isbool())z.v=lv||rv;',NL
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
rtn[20],←⊂'NM(nan,"nan",1,1,MT ,MT ,DFD,MT ,MT )',NL
rtn[20],←⊂'nan_f nan_c;',NL
rtn[20],←⊂'SF(nan_f,z.v=!(lv&&rv))',NL
rtn[20],←⊂'',NL
rtn[21],←⊂'NM(nor,"nor",1,1,MT ,MT ,DFD,MT ,MT )',NL
rtn[21],←⊂'nor_f nor_c;',NL
rtn[21],←⊂'SF(nor_f,z.v=!(lv||rv))',NL
rtn[22],←⊂'NM(sqd,"sqd",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[22],←⊂'sqd_f sqd_c;',NL
rtn[22],←⊂'MF(sqd_f){z=r;}',NL
rtn[22],←⊂'DF(sqd_f){if(l.r>1)err(4);B s=!l.r?1:l.s[l.r-1];',NL
rtn[22],←⊂' if(s>r.r)err(5);if(!cnt(l)){z=r;R;}',NL
rtn[22],←⊂' I sv[4];af::index x[4];l.v.as(s32).host(sv);',NL
rtn[22],←⊂' DO((I)s,if(sv[i]<0||sv[i]>=r.s[i])err(3));',NL
rtn[22],←⊂' DO((I)s,x[r.r-(i+1)]=sv[i]);z.r=r.r-(U)s;z.s=dim4(z.r,r.s.get());',NL
rtn[22],←⊂' z.v=r.v(x[0],x[1],x[2],x[3]);}',NL
rtn[22],←⊂'',NL
rtn[23],←⊂'void brk_c(A&z,const A&l,const std::vector<A>&r){I rl=(I)r.size();',NL
rtn[23],←⊂' if(!rl){if(l.r!=1)err(4);z=l;R;}',NL
rtn[23],←⊂' if(rl!=l.r)err(4);z.r=0;DO(rl,z.r+=abs(r[i].r))if(z.r>4)err(16);',NL
rtn[23],←⊂' I s=z.r;DO(4,z.s[i]=1)',NL
rtn[23],←⊂' DO(rl,I j=i;I k=abs(r[j].r);s-=k;',NL
rtn[23],←⊂'  DO(k,z.s[s+i]=(k==r[j].r)?r[j].s[i]:l.s[j]))',NL
rtn[23],←⊂' af::index x[4];DO(rl,if(r[i].r>=0)x[rl-(i+1)]=r[i].v.as(s32))',NL
rtn[23],←⊂' z.v=l.v(x[0],x[1],x[2],x[3]);}',NL
rtn[23],←⊂'',NL
rtn[23],←⊂'OD(brk,"brk",scm(l),scd(l),MFD,DFD)',NL
rtn[23],←⊂'MF(brk_o){ll(z,r,(r.r?r.r-1:0)-ww.v.as(f64).scalar<D>());}',NL
rtn[23],←⊂'DF(brk_o){D ax=l.r;if(r.r>l.r)ax=r.r;if(ax)ax--;',NL
rtn[23],←⊂' ll(z,l,r,ax-ww.v.as(f64).scalar<D>());}',NL
rtn[23],←⊂'',NL
rtn[23],←⊂' ',NL
rtn[24],←⊂'NM(iot,"iot",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[24],←⊂'iot_f iot_c;',NL
rtn[24],←⊂'MF(iot_f){if(r.r>1)err(4);B c=cnt(r);if(c>4)err(10);',NL
rtn[24],←⊂' if(c>1)err(16);',NL
rtn[24],←⊂' z.r=1;z.s=dim4(r.v.as(s32).scalar<I>());',NL
rtn[24],←⊂' z.v=z.s[0]?iota(z.s,dim4(1),s32):scl(0);}',NL
rtn[24],←⊂'DF(iot_f){z.r=r.r;z.s=r.s;B c=cnt(r);if(!c){z.v=scl(0);R;}',NL
rtn[24],←⊂' B lc=cnt(l)+1;if(lc==1){z.v=scl(0);R;};if(l.r>1)err(16);',NL
rtn[24],←⊂' array rf=flat(r.v).T();dtype mt=mxt(l.v,rf);',NL
rtn[24],←⊂' z.v=join(0,tile(l.v,1,(U)c).as(mt),rf.as(mt))==tile(rf,(U)lc,1);',NL
rtn[24],←⊂' z.v=min((z.v*iota(dim4(lc),dim4(1,c),s32)+((!z.v)*lc).as(s32)),0);',NL
rtn[24],←⊂' z.v=array(z.v,z.s);}',NL
rtn[24],←⊂'',NL
rtn[25],←⊂'NM(rho,"rho",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[25],←⊂'rho_f rho_c;',NL
rtn[25],←⊂'MF(rho_f){I sp[4]={1,1,1,1};DO(r.r,sp[r.r-(i+1)]=(I)r.s[i]);',NL
rtn[25],←⊂' z.s=dim4(r.r);z.r=1;if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,sp);}',NL
rtn[25],←⊂'DF(rho_f){B cr=cnt(r);B cl=cnt(l);B s[4];if(l.r>1)err(11);if(cl>4)err(16);',NL
rtn[25],←⊂' l.v.as(s64).host(s);z.r=(I)cl;DO(4,z.s[i]=i>=z.r?1:s[z.r-(i+1)])B cz=cnt(z);',NL
rtn[25],←⊂' if(!cz){z.v=scl(0);R;}z.v=array(cz==cr?r.v:flat(r.v)(iota(cz)%cr),z.s);}',NL
rtn[25],←⊂'',NL
rtn[26],←⊂'NM(cat,"cat",0,0,MT ,MFD,DFD,MT ,DAD)',NL
rtn[26],←⊂'cat_f cat_c;',NL
rtn[26],←⊂'MF(cat_f){z.r=1;z.s[0]=cnt(r);z.v=flat(r.v);}',NL
rtn[26],←⊂'DA(cat_f){A nl=l,nr=r;I fx=(I)ceil(ax);',NL
rtn[26],←⊂' if(fx<0||(fx>r.r&&fx>l.r))err(4);',NL
rtn[26],←⊂' if(ax!=fx){if(r.r>3||l.r>3)err(10);',NL
rtn[26],←⊂'  if(nl.r){nl.r++;DO(3-fx,nl.s[3-i]=nl.s[3-(i+1)]);nl.s[fx]=1;}',NL
rtn[26],←⊂'  if(nr.r){nr.r++;DO(3-fx,nr.s[3-i]=nr.s[3-(i+1)]);nr.s[fx]=1;}',NL
rtn[26],←⊂'  if(nl.r)nl.v=moddims(nl.v,nl.s);if(nr.r)nr.v=moddims(nr.v,nr.s);',NL
rtn[26],←⊂'  cat_c(z,nl,nr,fx);R;}',NL
rtn[26],←⊂' if(fx>=r.r&&fx>=l.r)err(4);',NL
rtn[26],←⊂' if(l.r&&r.r&&std::abs((I)l.r-(I)r.r)>1)err(4);',NL
rtn[26],←⊂' z.r=(l.r>=r.r)*l.r+(r.r>l.r)*r.r+(!r.r&&!l.r);',NL
rtn[26],←⊂' dim4 ls=l.s;dim4 rs=r.s;',NL
rtn[26],←⊂' if(!l.r){ls=rs;ls[fx]=1;}if(!r.r){rs=ls;rs[fx]=1;}',NL
rtn[26],←⊂' if(r.r&&l.r>r.r){DO(3-fx,rs[3-i]=rs[3-(i+1)]);rs[fx]=1;}',NL
rtn[26],←⊂' if(l.r&&r.r>l.r){DO(3-fx,ls[3-i]=ls[3-(i+1)]);ls[fx]=1;}',NL
rtn[26],←⊂' DO(4,if(i!=fx&&rs[i]!=ls[i])err(5));',NL
rtn[26],←⊂' DO(4,z.s[i]=(l.r>=r.r||i==fx)*ls[i]+(r.r>l.r||i==fx)*rs[i]);',NL
rtn[26],←⊂' if(!cnt(l)){z.v=r.v;R;}if(!cnt(r)){z.v=l.v;R;}',NL
rtn[26],←⊂' dtype mt=mxt(r.v,l.v);',NL
rtn[26],←⊂' array lv=(l.r?moddims(l.v,ls):tile(l.v,ls)).as(mt);',NL
rtn[26],←⊂' array rv=(r.r?moddims(r.v,rs):tile(r.v,rs)).as(mt);',NL
rtn[26],←⊂' z.v=join(fx,lv,rv);}',NL
rtn[26],←⊂'DF(cat_f){if(l.r||r.r){cat_c(z,l,r,0);R;}',NL
rtn[26],←⊂' A a,b;cat_c(a,l);cat_c(b,r);cat_c(z,a,b,0);}',NL
rtn[27],←⊂'NM(ctf,"ctf",0,0,MT,MFD,DFD,MT,MT)',NL
rtn[27],←⊂'ctf_f ctf_c;',NL
rtn[27],←⊂'MF(ctf_f){dim4 sp=z.s;sp[1]=r.r?r.s[r.r-1]:1;sp[0]=sp[1]?cnt(r)/sp[1]:1;',NL
rtn[27],←⊂' sp[2]=sp[3]=1;z.r=2;z.s=sp;z.v=!cnt(z)?scl(0):array(r.v,z.s);}',NL
rtn[27],←⊂'DF(ctf_f){I x=l.r>r.r?l.r:r.r;if(l.r||r.r){cat_c(z,l,r,x-1);R;}',NL
rtn[27],←⊂' A a,b;cat_c(a,l);cat_c(b,r);cat_c(z,a,b,0);}',NL
rtn[28],←⊂'NM(rot,"rot",0,0,DID,MFD,DFD,MT ,MT )',NL
rtn[28],←⊂'rot_f rot_c;',NL
rtn[28],←⊂'ID(rot,0,s32)',NL
rtn[28],←⊂'MF(rot_f){z.r=r.r;z.s=r.s;z.v=flip(r.v,0);}',NL
rtn[28],←⊂'DF(rot_f){I lc=(I)cnt(l);if(lc==1){z.r=r.r;z.s=r.s;',NL
rtn[28],←⊂'  z.v=shift(r.v,-l.v.as(s32).scalar<I>());R;}',NL
rtn[28],←⊂' if(l.r!=r.r-1)err(5);DO(l.r,if(l.s[i]!=r.s[i+1])err(5))',NL
rtn[28],←⊂' std::vector<I> x(lc);l.v.as(s32).host(x.data());',NL
rtn[28],←⊂' z.v=array(r.v,r.s[0],lc);z.r=r.r;z.s=r.s;',NL
rtn[28],←⊂' DO(lc,z.v(span,i)=shift(z.v(span,i),-x[i]))z.v=array(z.v,z.s);}',NL
rtn[28],←⊂'',NL
rtn[29],←⊂'NM(trn,"trn",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[29],←⊂'trn_f trn_c;',NL
rtn[29],←⊂'MF(trn_f){z.r=r.r;DO(r.r,z.s[i]=r.s[r.r-(i+1)])',NL
rtn[29],←⊂' switch(r.r){CS(0,z.v=r.v)CS(1,z.v=r.v)CS(2,z.v=r.v.T())',NL
rtn[29],←⊂'  CS(3,z.v=reorder(r.v,2,1,0))CS(4,z.v=reorder(r.v,3,2,1,0))}}',NL
rtn[29],←⊂'DF(trn_f){I lv[4];if(l.r>1||cnt(l)!=r.r)err(5);',NL
rtn[29],←⊂' l.v.as(s32).host(lv);DO(r.r,if(lv[i]<0||lv[i]>=r.r)err(4))',NL
rtn[29],←⊂' U8 f[]={0,0,0,0};DO(r.r,f[lv[i]]=1)',NL
rtn[29],←⊂' U8 t=1;DO(r.r,if(t&&!f[i])t=0;else if(!t&&f[i])err(5))',NL
rtn[29],←⊂' DO(r.r,if(!f[i])err(16))',NL
rtn[29],←⊂' z.r=r.r;DO(r.r,z.s[r.r-(lv[i]+1)]=r.s[r.r-(i+1)])',NL
rtn[29],←⊂' I s[4];DO(r.r,s[r.r-(lv[i]+1)]=r.r-(i+1))',NL
rtn[29],←⊂' switch(r.r){CS(0,z.v=r.v)CS(1,z.v=r.v)',NL
rtn[29],←⊂'  CS(2,z.v=reorder(r.v,s[0],s[1]))',NL
rtn[29],←⊂'  CS(3,z.v=reorder(r.v,s[0],s[1],s[2]))',NL
rtn[29],←⊂'  CS(4,z.v=reorder(r.v,s[0],s[1],s[2],s[3]))}}',NL
rtn[29],←⊂'',NL
rtn[30],←⊂'NM(rtf,"rtf",0,0,DID,MFD,DFD,MT ,MT )',NL
rtn[30],←⊂'rtf_f rtf_c;',NL
rtn[30],←⊂'ID(rtf,0,s32)',NL
rtn[30],←⊂'MF(rtf_f){z.r=r.r;z.s=r.s;z.v=r.r?flip(r.v,r.r-1):r.v;}',NL
rtn[30],←⊂'DF(rtf_f){I lc=(I)cnt(l);I ra=r.r?r.r-1:0;I ix[]={0,0,0,0};',NL
rtn[30],←⊂' if(lc==1){z.r=r.r;z.s=r.s;ix[ra]=-l.v.as(s32).scalar<I>();',NL
rtn[30],←⊂'  z.v=shift(r.v,ix[0],ix[1],ix[2],ix[3]);R;}',NL
rtn[30],←⊂' if(l.r!=r.r-1)err(5);DO(l.r,if(l.s[i]!=r.s[i])err(5))',NL
rtn[30],←⊂' std::vector<I> x(lc);l.v.as(s32).host(x.data());',NL
rtn[30],←⊂' z.v=array(r.v,lc,r.s[ra]);z.r=r.r;z.s=r.s;',NL
rtn[30],←⊂' DO(lc,z.v(i,span)=shift(z.v(i,span),0,-x[i]))',NL
rtn[30],←⊂' z.v=array(z.v,z.s);}',NL
rtn[30],←⊂'',NL
rtn[31],←⊂'NM(mem,"mem",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[31],←⊂'mem_f mem_c;',NL
rtn[31],←⊂'MF(mem_f){z.r=1;z.s=dim4(cnt(r));z.v=flat(r.v);}',NL
rtn[31],←⊂'DF(mem_f){z.r=l.r;z.s=l.s;I lc=(I)cnt(z);if(!lc){z.v=scl(0);R;}',NL
rtn[31],←⊂' if(!cnt(r)){z.v=array(z.s,b8);z.v=0;R;}',NL
rtn[31],←⊂' array y=setUnique(flat(r.v));I rc=(I)y.elements();',NL
rtn[31],←⊂' array x=array(flat(l.v),lc,1);y=array(y,1,rc);',NL
rtn[31],←⊂' z.v=array(anyTrue(tile(x,1,rc)==tile(y,lc,1),1),z.s);}',NL
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
rtn[37],←⊂' z.v=(lv!=0)*rem(rv,lv)+(lv==0)*rv;z.v=(dv!=0)*(z.v/dv).as(s32);}',NL
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
rtn[39],←⊂'NM(red,"red",0,0,DID,MT ,DFD,MT ,MT )',NL
rtn[39],←⊂'ID(red,1,s32)',NL
rtn[39],←⊂'red_f red_c;',NL
rtn[39],←⊂'OM(red,"red",0,0,MFD,DFD)',NL
rtn[39],←⊂'DF(red_f){if(l.r>1)err(4);z.r=r.r?r.r:1;z.s=r.s;',NL
rtn[39],←⊂' if(l.r!=0&&l.s[0]!=1&&r.r!=0&&r.s[0]!=1&&l.s[0]!=r.s[0])err(5);',NL
rtn[39],←⊂' array x=l.v;if(cnt(l)==1)x=tile(x,(I)r.s[0]);',NL
rtn[39],←⊂' array y=r.v;if(r.s[0]==1)y=tile(y,(I)cnt(l));',NL
rtn[39],←⊂' z.s[0]=sum<B>(abs(x));if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[39],←⊂' array w=where(x).as(s32);',NL
rtn[39],←⊂' if(z.s[0]==w.elements()){z.v=y(w,span);R;}',NL
rtn[39],←⊂' array i=shift(accum(abs(x(w))),1),d=shift(w,1);i(0)=0;d(0)=0;',NL
rtn[39],←⊂' array v=array(z.s[0],s32),u=array(z.s[0],s32);v=0;u=0;',NL
rtn[39],←⊂' array s=(!sign(x(w))).as(s32);array t=shift(s,1);t(0)=0;',NL
rtn[39],←⊂' v(i)=w-d;u(i)=s-t;z.v=y(accum(v),span);',NL
rtn[39],←⊂' z.v*=tile(accum(u),1,(I)z.s[1],(I)z.s[2],(I)z.s[3]);}',NL
rtn[39],←⊂'MF(red_o){A t(r.r?r.r-1:0,dim4(1),z.v);DO(t.r,t.s[i]=r.s[i+1])',NL
rtn[39],←⊂' I rc=(I)r.s[0];I zc=(I)cnt(t);if(!zc){t.v=scl(0);z=t;R;}',NL
rtn[39],←⊂' if(!rc){t.v=ll.id(t.s);z=t;R;}',NL
rtn[39],←⊂' if(1==rc){t.v=array(r.v,t.s);z=t;R;}',NL
rtn[39],←⊂' if("add"==ll.nm){if(r.v.isbool())t.v=count(r.v,0).as(s32);',NL
rtn[39],←⊂'  else t.v=sum(r.v.as(f64),0);z=t;R;}',NL
rtn[39],←⊂' if("mul"==ll.nm){t.v=product(r.v.as(f64),0);z=t;R;}',NL
rtn[39],←⊂' if("min"==ll.nm){t.v=min(r.v,0);z=t;R;}',NL
rtn[39],←⊂' if("max"==ll.nm){t.v=max(r.v,0);z=t;R;}',NL
rtn[39],←⊂' if("and"==ll.nm){t.v=allTrue(r.v,0);z=t;R;}',NL
rtn[39],←⊂' if("lor"==ll.nm){t.v=anyTrue(r.v,0);z=t;R;}',NL
rtn[39],←⊂' t.v=r.v(rc-1,span);map_o mfn_c(ll);',NL
rtn[39],←⊂' DO(rc-1,mfn_c(t,A(t.r,t.s,r.v(rc-(i+2),span)),t))z=t;}',NL
rtn[39],←⊂'DF(red_o){if(l.r!=0&&(l.r!=1||l.s[0]!=1))err(5);if(!r.r)err(4);',NL
rtn[39],←⊂' I lv=l.v.as(s32).scalar<I>();if((r.s[0]+1)<lv)err(5);',NL
rtn[39],←⊂' I rc=(I)((1+r.s[0])-abs(lv));map_o mfn_c(ll);',NL
rtn[39],←⊂' A t(r.r,r.s,scl(0));t.s[0]=rc;if(!cnt(t)){z=t;R;}',NL
rtn[39],←⊂' if(!lv){t.v=ll.id(t.s);z=t;R;}seq rng(rc);',NL
rtn[39],←⊂' if(lv>=0){t.v=r.v(rng+((D)lv-1),span);',NL
rtn[39],←⊂'  DO(lv-1,mfn_c(t,A(t.r,t.s,r.v(rng+((D)lv-(i+2)),span)),t))',NL
rtn[39],←⊂' }else{t.v=r.v(rng,span);',NL
rtn[39],←⊂'  DO(abs(lv)-1,mfn_c(t,A(t.r,t.s,r.v(rng+(D)(i+1),span)),t))}',NL
rtn[39],←⊂' z=t;}',NL
rtn[39],←⊂'',NL
rtn[40],←⊂'NM(rdf,"rdf",0,0,DID,MT ,DFD,MT ,MT )',NL
rtn[40],←⊂'ID(rdf,1,s32)',NL
rtn[40],←⊂'OM(rdf,"rdf",0,0,MFD,DFD)',NL
rtn[40],←⊂'rdf_f rdf_c;',NL
rtn[40],←⊂'DF(rdf_f){if(l.r>1)err(4);I ra=r.r?r.r-1:0;z.r=ra+1;z.s=r.s;',NL
rtn[40],←⊂' if(l.r!=0&&l.s[0]!=1&&r.r!=0&&r.s[ra]!=1&&l.s[0]!=r.s[ra])err(5);',NL
rtn[40],←⊂' array x=l.v;array y=r.v;if(cnt(l)==1)x=tile(x,(I)r.s[ra]);',NL
rtn[40],←⊂' if(r.s[ra]==1){dim4 s(1);s[ra]=cnt(l);y=tile(y,s);}',NL
rtn[40],←⊂' z.s[ra]=sum<B>(abs(x));if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[40],←⊂' array w=where(x).as(s32);af::index ix[4];if(z.s[ra]==w.elements()){',NL
rtn[40],←⊂'  ix[ra]=w;z.v=y(ix[0],ix[1],ix[2],ix[3]);R;}',NL
rtn[40],←⊂' array i=shift(accum(abs(x(w))),1),d=shift(w,1);i(0)=0;d(0)=0;',NL
rtn[40],←⊂' array v=array(z.s[ra],s32),u=array(z.s[ra],s32);v=0;u=0;',NL
rtn[40],←⊂' array s=(!sign(x(w))).as(s32);array t=shift(s,1);t(0)=0;',NL
rtn[40],←⊂' v(i)=w-d;u(i)=s-t;ix[ra]=accum(v);z.v=y(ix[0],ix[1],ix[2],ix[3]);',NL
rtn[40],←⊂' dim4 s1(1),s2(z.s);s1[ra]=z.s[ra];s2[ra]=1;u=array(accum(u),s1);',NL
rtn[40],←⊂' z.v*=tile(u,(I)s2[0],(I)s2[1],(I)s2[2],(I)s2[3]);}',NL
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
rtn[40],←⊂'  mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t));z=t;}',NL
rtn[40],←⊂'DF(rdf_o){if(l.r!=0&&(l.r!=1||l.s[0]!=1))err(5);if(!r.r)err(4);',NL
rtn[40],←⊂' I lv=l.v.as(s32).scalar<I>();I ra=r.r-1;',NL
rtn[40],←⊂'  if((r.s[ra]+1)<lv)err(5);I rc=(I)((1+r.s[ra])-abs(lv));',NL
rtn[40],←⊂' map_o mfn_c(ll);A t(r.r,r.s,scl(0));t.s[ra]=rc;if(!cnt(t)){z=t;R;}',NL
rtn[40],←⊂' if(!lv){t.v=ll.id(t.s);z=t;R;}seq rng(rc);af::index x[4];',NL
rtn[40],←⊂' if(lv>=0){x[ra]=rng+((D)lv-1);t.v=r.v(x[0],x[1],x[2],x[3]);',NL
rtn[40],←⊂'  DO(lv-1,x[ra]=rng+((D)lv-(i+2));',NL
rtn[40],←⊂'   mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t))',NL
rtn[40],←⊂' }else{x[ra]=rng;t.v=r.v(x[0],x[1],x[2],x[3]);',NL
rtn[40],←⊂'  DO(abs(lv)-1,x[ra]=rng+(D)(i+1);',NL
rtn[40],←⊂'   mfn_c(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t))}',NL
rtn[40],←⊂' z=t;}',NL
rtn[40],←⊂'',NL
rtn[41],←⊂'NM(scn,"scn",0,0,DID,MT ,DFD,MT ,MT )',NL
rtn[41],←⊂'scn_f scn_c;',NL
rtn[41],←⊂'ID(scn,1,s32)',NL
rtn[41],←⊂'OM(scn,"scn",1,1,MFD,MT)',NL
rtn[41],←⊂'DF(scn_f){if(r.s[0]!=1&&r.s[0]!=sum<I>(l.v>0))err(5);',NL
rtn[41],←⊂' if(l.r>1)err(5);array ca=max(1,abs(l.v)).as(s32);I c=sum<I>(ca);',NL
rtn[41],←⊂' if(!cnt(l))c=0;A t(r.r?r.r:1,r.s,scl(0));t.s[0]=c;',NL
rtn[41],←⊂' if(!cnt(t)){z=t;R;}t.v=array(t.s,r.v.type());t.v=0;',NL
rtn[41],←⊂' array pw=0<l.v;array pa=pw*l.v;I pc=sum<I>(pa);if(!pc){z=t;R;}',NL
rtn[41],←⊂' pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);',NL
rtn[41],←⊂' array si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;',NL
rtn[41],←⊂' array ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);',NL
rtn[41],←⊂' ti=scanByKey(si,ti);t.v(ti,span)=r.v(si,span);z=t;}',NL
rtn[41],←⊂'',NL
rtn[41],←⊂'MF(scn_o){z.r=r.r;z.s=r.s;I rc=(I)r.s[0];',NL
rtn[41],←⊂' if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[41],←⊂' if("add"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_ADD);R;}',NL
rtn[41],←⊂' if("mul"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MUL);R;}',NL
rtn[41],←⊂' if("min"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MIN);R;}',NL
rtn[41],←⊂' if("max"==ll.nm){z.v=scan(r.v.as(f64),0,AF_BINARY_MAX);R;}',NL
rtn[41],←⊂' map_o mfn(ll);z.v=array(z.s,f64);A t(z.r?z.r-1:0,z.s,r.v(0));',NL
rtn[41],←⊂' DO(t.r,t.s[i]=t.s[i+1]);t.s[t.r]=1;I tc=(I)cnt(t);',NL
rtn[41],←⊂' DO(rc,t.v=r.v(i,span).as(f64);I c=i;',NL
rtn[41],←⊂'  DO(c,mfn(t,A(t.r,t.s,r.v(c-(i+1),span)),t))',NL
rtn[41],←⊂'  z.v(i,span)=t.v)}',NL
rtn[41],←⊂'',NL
rtn[42],←⊂'NM(scf,"scf",0,0,DID,MT ,DFD,MT ,MT )',NL
rtn[42],←⊂'scf_f scf_c;',NL
rtn[42],←⊂'ID(scf,1,s32)',NL
rtn[42],←⊂'OM(scf,"scf",1,1,MFD,MT)',NL
rtn[42],←⊂'DF(scf_f){I ra=r.r?r.r-1:0;af::index sx[4];af::index tx[4];',NL
rtn[42],←⊂' if(r.s[ra]!=1&&r.s[ra]!=sum<I>(l.v>0))err(5);',NL
rtn[42],←⊂' if(l.r>1)err(5);array ca=max(1,abs(l.v)).as(s32);I c=sum<I>(ca);',NL
rtn[42],←⊂' if(!cnt(l))c=0;A t(ra+1,r.s,scl(0));t.s[ra]=c;',NL
rtn[42],←⊂' if(!cnt(t)){z=t;R;}t.v=array(t.s,r.v.type());t.v=0;',NL
rtn[42],←⊂' array pw=0<l.v;array pa=pw*l.v;I pc=sum<I>(pa);if(!pc){z=t;R;}',NL
rtn[42],←⊂' pw=where(pw);pa=scan(pa(pw),0,AF_BINARY_ADD,false);',NL
rtn[42],←⊂' array si(pc,s32);si=0;si(pa)=1;si=accum(si)-1;sx[ra]=si;',NL
rtn[42],←⊂' array ti(pc,s32);ti=1;ti(pa)=scan(ca,0,AF_BINARY_ADD,false)(pw);',NL
rtn[42],←⊂' ti=scanByKey(si,ti);tx[ra]=ti;',NL
rtn[42],←⊂' t.v(tx[0],tx[1],tx[2],tx[3])=r.v(sx[0],sx[1],sx[2],sx[3]);z=t;}',NL
rtn[42],←⊂'',NL
rtn[42],←⊂'MF(scf_o){z.r=r.r;z.s=r.s;I ra=r.r?r.r-1:0;I rc=(I)r.s[ra];',NL
rtn[42],←⊂' if(1==rc){z.v=r.v;R;}if(!cnt(z)){z.v=scl(0);R;}',NL
rtn[42],←⊂' if("add"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_ADD);R;}',NL
rtn[42],←⊂' if("mul"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MUL);R;}',NL
rtn[42],←⊂' if("min"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MIN);R;}',NL
rtn[42],←⊂' if("max"==ll.nm){z.v=scan(r.v.as(f64),ra,AF_BINARY_MAX);R;}',NL
rtn[42],←⊂' z.v=array(z.s,f64);A t(z.r?z.r-1:0,z.s,r.v(0));t.s[ra]=1;',NL
rtn[42],←⊂' I tc=(I)cnt(t);af::index x[4];map_o mfn(ll);',NL
rtn[42],←⊂' DO(rc,x[ra]=i;t.v=r.v(x[0],x[1],x[2],x[3]).as(f64);I c=i;',NL
rtn[42],←⊂'  DO(c,x[ra]=c-(i+1);',NL
rtn[42],←⊂'   mfn(t,A(t.r,t.s,r.v(x[0],x[1],x[2],x[3])),t))',NL
rtn[42],←⊂'  x[ra]=i;z.v(x[0],x[1],x[2],x[3])=t.v)}',NL
rtn[42],←⊂'',NL
rtn[43],←⊂'NM(rol,"rol",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[43],←⊂'rol_f rol_c;',NL
rtn[43],←⊂'MF(rol_f){z.r=r.r;z.s=r.s;if(!cnt(r)){z.v=r.v;R;}',NL
rtn[43],←⊂' array rnd=randu(r.v.dims(),f64);z.v=(0==r.v)*rnd+trunc(r.v*rnd);}',NL
rtn[43],←⊂'DF(rol_f){if(cnt(r)!=1||cnt(l)!=1)err(5);',NL
rtn[43],←⊂' D lv=l.v.as(f64).scalar<D>();D rv=r.v.as(f64).scalar<D>();',NL
rtn[43],←⊂' if(lv>rv||lv!=floor(lv)||rv!=floor(rv)||lv<0||rv<0)err(11);',NL
rtn[43],←⊂' I s=(I)lv;I t=(I)rv;z.r=1;z.s=dim4(s);if(!s){z.v=scl(0);R;}',NL
rtn[43],←⊂' std::vector<I> g(t);std::vector<I> d(t);',NL
rtn[43],←⊂' ((1+range(t))*randu(t)).as(s32).host(g.data());',NL
rtn[43],←⊂' DO(t,I j=g[i];if(i!=j)d[i]=d[j];d[j]=i)z.v=array(z.s,d.data());}',NL
rtn[44],←⊂'NM(tke,"tke",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[44],←⊂'tke_f tke_c;',NL
rtn[44],←⊂'MF(tke_f){z=r;}',NL
rtn[44],←⊂'DF(tke_f){I lv[4];seq it[4];seq ix[4];B c=cnt(l);',NL
rtn[44],←⊂' if(l.r>1||(c>r.r&&r.r))err(4);if(!c){z=r;R;}',NL
rtn[44],←⊂' U rk=r.r?r.r:(U)l.s[0];z.r=rk;z.s=r.s;l.v.as(s32).host(lv);',NL
rtn[44],←⊂' DO((I)c,{U j=rk-(i+1);I a=std::abs(lv[i]);z.s[j]=a;',NL
rtn[44],←⊂'  if(a>r.s[j])ix[j]=seq((D)r.s[j]);',NL
rtn[44],←⊂'  else if(lv[i]<0)ix[j]=seq((D)r.s[j]-a,(D)r.s[j]-1);',NL
rtn[44],←⊂'  else ix[j]=seq(a);',NL
rtn[44],←⊂'  it[j]=ix[j]+(lv[i]<0)*(a-(D)r.s[j]);})',NL
rtn[44],←⊂' if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;',NL
rtn[44],←⊂' z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}',NL
rtn[44],←⊂'',NL
rtn[45],←⊂'NM(drp,"drp",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[45],←⊂'drp_f drp_c;',NL
rtn[45],←⊂'MF(drp_f){if(r.r)err(16);z=r;}',NL
rtn[45],←⊂'DF(drp_f){I lv[4];seq it[4];seq ix[4];B c=cnt(l);',NL
rtn[45],←⊂' if(l.r>1||(c>r.r&&r.r))err(4);if(!c){z=r;R;}',NL
rtn[45],←⊂' U rk=r.r?r.r:(U)l.s[0];z.r=rk;z.s=r.s;l.v.as(s32).host(lv);',NL
rtn[45],←⊂' DO((I)c,{U j=rk-(i+1);I a=std::abs(lv[i]);',NL
rtn[45],←⊂'  if(a>=r.s[j]){z.s[j]=0;ix[j]=seq(0);it[j]=seq(0);}',NL
rtn[45],←⊂'  else if(lv[i]<0){',NL
rtn[45],←⊂'   z.s[j]=r.s[j]-a;ix[j]=seq((D)z.s[j]);it[j]=ix[j];}',NL
rtn[45],←⊂'  else{z.s[j]=r.s[j]-a;ix[j]=seq(a,(D)r.s[j]-1);it[j]=ix[j]-(D)a;}})',NL
rtn[45],←⊂' if(!cnt(z)){z.v=scl(0);R;}z.v=array(z.s,r.v.type());z.v=0;',NL
rtn[45],←⊂' z.v(it[0],it[1],it[2],it[3])=r.v(ix[0],ix[1],ix[2],ix[3]);}',NL
rtn[46],←⊂'OM(map,"map",1,1,MFD,DFD)',NL
rtn[46],←⊂'MF(map_o){if(scm(ll)){ll(z,r);R;}',NL
rtn[46],←⊂' z.r=r.r;z.s=r.s;I c=(I)cnt(z);if(!c){z.v=scl(0);R;}',NL
rtn[46],←⊂' A zs;A rs=scl(r.v(0));ll(zs,rs);if(c==1){z.v=zs.v;R;}',NL
rtn[46],←⊂' array v=array(z.s,zs.v.type());v(0)=zs.v(0);',NL
rtn[46],←⊂' DO(c-1,rs.v=r.v(i+1);ll(zs,rs);v(i+1)=zs.v(0))z.v=v;}',NL
rtn[46],←⊂'DF(map_o){if(scd(ll)){ll(z,l,r);R;}',NL
rtn[46],←⊂' if((l.r==r.r&&l.s==r.s)||!l.r){z.r=r.r;z.s=r.s;}',NL
rtn[46],←⊂' else if(!r.r){z.r=l.r;z.s=l.s;}else if(l.r!=r.r)err(4);',NL
rtn[46],←⊂' else if(l.s!=r.s)err(5);else err(99);I c=(I)cnt(z);',NL
rtn[46],←⊂' if(!c){z.v=scl(0);R;}A zs;A rs=scl(r.v(0));A ls=scl(l.v(0));',NL
rtn[46],←⊂' ll(zs,ls,rs);if(c==1){z.v=zs.v;R;}',NL
rtn[46],←⊂' array v=array(z.s,zs.v.type());v(0)=zs.v(0);',NL
rtn[46],←⊂' if(!r.r){rs.v=r.v;',NL
rtn[46],←⊂'  DO(c-1,ls.v=l.v(i+1);ll(zs,ls,rs);v(i+1)=zs.v(0);)',NL
rtn[46],←⊂'  z.v=v;R;}',NL
rtn[46],←⊂' if(!l.r){ls.v=l.v;',NL
rtn[46],←⊂'  DO(c-1,rs.v=r.v(i+1);ll(zs,ls,rs);v(i+1)=zs.v(0);)',NL
rtn[46],←⊂'  z.v=v;R;}',NL
rtn[46],←⊂' DO(c-1,ls.v=l.v(i+1);rs.v=r.v(i+1);ll(zs,ls,rs);',NL
rtn[46],←⊂'  v(i+1)=zs.v(0))z.v=v;}',NL
rtn[47],←⊂'OM(com,"com",scm(l),scd(l),MFD,DFD)',NL
rtn[47],←⊂'MF(com_o){ll(z,r,r);}DF(com_o){ll(z,r,l);}',NL
rtn[47],←⊂'',NL
rtn[48],←⊂'OD(dot,"dot",0,0,MT,DFD)',NL
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
rtn[48],←⊂' x=tile(array(x,c,1,lc),1,rc,1);y=tile(y.T(),1,1,lc);',NL
rtn[48],←⊂' A X(3,dim4(c,rc,lc),x.as(f64));A Y(3,dim4(c,rc,lc),y.as(f64));',NL
rtn[48],←⊂' map_o mfn_c(rr);red_o rfn_c(ll);mfn_c(X,X,Y);rfn_c(X,X);',NL
rtn[48],←⊂' t.v=array(X.v,t.s);z=t;}',NL
rtn[48],←⊂'',NL
rtn[49],←⊂'OD(rnk,"rnk",scm(l),0,MFD,DFD)',NL
rtn[49],←⊂'MF(rnk_o){if(cnt(ww)!=1)err(4);I cr=ww.v.as(s32).scalar<I>();',NL
rtn[49],←⊂' if(scm(ll)||cr>=r.r){ll(z,r);R;}',NL
rtn[49],←⊂' if(cr<=-r.r||!cr){map_o f(ll);f(z,r);R;}',NL
rtn[49],←⊂' if(cr<0)cr=r.r+cr;if(cr>3)err(10);I dr=r.r-cr;',NL
rtn[49],←⊂' dim4 sp(1);DO(dr,sp[cr]*=r.s[i+cr])DO(cr,sp[i]=r.s[i])',NL
rtn[49],←⊂' std::vector<A> tv(sp[cr]);A b(cr+1,sp,array(r.v,sp));',NL
rtn[49],←⊂' DO((I)sp[cr],sqd_c(tv[i],scl(scl(i)),b);ll(tv[i],tv[i]))',NL
rtn[49],←⊂' I mr=0;dim4 ms(1);dtype mt=b8;if(mr>3)err(10);',NL
rtn[49],←⊂' DO((I)sp[cr],if(mr<tv[i].r)mr=tv[i].r;mt=mxt(mt,tv[i]);I si=i;',NL
rtn[49],←⊂'  DO(4,if(ms[3-i]<tv[si].s[3-i]){ms=tv[si].s;break;}))',NL
rtn[49],←⊂' I mc=(I)cnt(ms);array v(mc*sp[cr],mt);v=0;',NL
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
rtn[49],←⊂' DO((I)sz,A ta;A tb;A ai=scl(scl(i%sl[cl]));A bi=scl(scl(i%sr[cr]));',NL
rtn[49],←⊂'  sqd_c(ta,ai,a);sqd_c(tb,bi,b);ll(tv[i],ta,tb);',NL
rtn[49],←⊂'  if(mr<tv[i].r)mr=tv[i].r;mt=mxt(mt,tv[i]);A t=tv[i];',NL
rtn[49],←⊂'  DO(4,if(ms[i]<t.s[i])ms[i]=t.s[i]))',NL
rtn[49],←⊂' B mc=cnt(ms);array v(mc*sz,mt);v=0;',NL
rtn[49],←⊂' DOB(sz,seq ix((D)cnt(tv[i]));v(ix+(D)(i*mc))=flat(tv[i].v))',NL
rtn[49],←⊂' z.r=mr+(dr>dl?dr:dl);z.s=ms;z.s[mr]=sz;z.v=array(v,z.s);}',NL
rtn[49],←⊂'',NL
rtn[50],←⊂'OD(pow,"pow",scm(l),scd(l),MFD,DFD)',NL
rtn[50],←⊂'MF(pow_o){if(fr){A t;A v=r;',NL
rtn[50],←⊂'  do{A u;ll(u,v);rr(t,u,v);if(t.r)err(5);v=u;}',NL
rtn[50],←⊂'  while(!t.v.as(s32).scalar<I>());z=v;R;}',NL
rtn[50],←⊂' if(ww.r)err(4);I c=ww.v.as(s32).scalar<I>();z=r;DO(c,ll(z,z))}',NL
rtn[50],←⊂'DF(pow_o){if(fr){A t;A v=r;',NL
rtn[50],←⊂'  do{A u;ll(u,l,v);rr(t,u,v);if(t.r)err(5);v=u;}',NL
rtn[50],←⊂'  while(!t.v.as(s32).scalar<I>());z=v;R;}',NL
rtn[50],←⊂' if(ww.r)err(4);I c=ww.v.as(s32).scalar<I>();',NL
rtn[50],←⊂' A t=r;DO(c,ll(t,l,t))z=t;}',NL
rtn[50],←⊂'',NL
rtn[51],←⊂'OD(jot,"jot",(scm(l)&&scm(r)),(scd(l)&&scd(r)),MFD,DFD)',NL
rtn[51],←⊂'MF(jot_o){if(!fl){rr(z,aa,r);R;}if(!fr){ll(z,r,ww);R;}',NL
rtn[51],←⊂' rr(z,r);ll(z,z);}',NL
rtn[51],←⊂'DF(jot_o){if(!fl||!fr){err(2);}rr(z,r);ll(z,l,z);}',NL
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
rtn[53],←⊂' dtype mt=mxt(l.v,r.v);z.v=setIntersect(l.v.as(mt),r.v.as(mt));',NL
rtn[53],←⊂' z.r=1;z.s=dim4(z.v.elements());}',NL
rtn[53],←⊂'',NL
rtn[54],←⊂'NM(gdu,"gdu",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[54],←⊂'gdu_f gdu_c;',NL
rtn[54],←⊂'MF(gdu_f){if(r.r<1)err(4);z.r=1;z.s=dim4(r.s[r.r-1]);',NL
rtn[54],←⊂' if(!cnt(r)){z.v=r.v;R;}I c=1;DO(r.r-1,c*=(I)r.s[i]);',NL
rtn[54],←⊂' array mt,a=array(r.v,c,r.s[r.r-1]);z.v=iota(z.s,dim4(1),s32);',NL
rtn[54],←⊂' DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,true))}',NL
rtn[54],←⊂'DF(gdu_f){err(16);}',NL
rtn[55],←⊂'NM(gdd,"gdd",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[55],←⊂'gdd_f gdd_c;',NL
rtn[55],←⊂'MF(gdd_f){if(r.r<1)err(4);z.r=1;z.s=dim4(r.s[r.r-1]);',NL
rtn[55],←⊂' if(!cnt(r)){z.v=r.v;R;}I c=1;DO(r.r-1,c*=(I)r.s[i]);',NL
rtn[55],←⊂' array mt,a=array(r.v,c,r.s[r.r-1]);z.v=iota(z.s,dim4(1),s32);',NL
rtn[55],←⊂' DO(c,sort(mt,z.v,flat(a(c-(i+1),z.v)),z.v,0,false))}',NL
rtn[55],←⊂'DF(gdd_f){err(16);}',NL
rtn[55],←⊂'',NL
rtn[56],←⊂'OM(oup,"oup",0,0,MT,DFD)',NL
rtn[56],←⊂'DF(oup_o){A t(l.r+r.r,r.s,r.v(0));if(t.r>4)err(10);',NL
rtn[56],←⊂' DO(l.r,t.s[i+r.r]=l.s[i])if(!cnt(t)){t.v=scl(0);z=t;R;}',NL
rtn[56],←⊂' array x(flat(l.v),1,cnt(l));array y(flat(r.v),cnt(r),1);',NL
rtn[56],←⊂' dim4 ts(cnt(r),cnt(l));x=tile(x,(I)ts[0],1);y=tile(y,1,(I)ts[1]);',NL
rtn[56],←⊂' map_o mfn(ll);A xa(2,ts,x);A ya(2,ts,y);mfn(xa,xa,ya);',NL
rtn[56],←⊂' t.v=array(xa.v,t.s);z=t;}',NL
rtn[56],←⊂'',NL
rtn[57],←⊂'NM(fnd,"fnd",0,0,MT ,MT ,DFD,MT ,MT )',NL
rtn[57],←⊂'fnd_f fnd_c;',NL
rtn[57],←⊂'DF(fnd_f){A t(r.r,r.s,array(r.s,b8));if(!cnt(t)){t.v=scl(0);z=t;R;}',NL
rtn[57],←⊂' t.v=0;if(l.r>r.r){z=t;R;}DO(4,if(l.s[i]>r.s[i]){z=t;R;})',NL
rtn[57],←⊂' if(!cnt(l)){t.v=1;z=t;R;}dim4 sp;DO(4,sp[i]=1+(t.s[i]-l.s[i]))',NL
rtn[57],←⊂' seq x[4];DO(4,x[i]=seq((D)sp[i]))t.v(x[0],x[1],x[2],x[3])=1;',NL
rtn[57],←⊂' DO((I)l.s[0],I m=i;',NL
rtn[57],←⊂'  DO((I)l.s[1],I k=i;',NL
rtn[57],←⊂'   DO((I)l.s[2],I j=i;',NL
rtn[57],←⊂'    DO((I)l.s[3],t.v(x[0],x[1],x[2],x[3])=t.v(x[0],x[1],x[2],x[3])',NL
rtn[57],←⊂'     &(tile(l.v(m,k,j,i),sp)',NL
rtn[57],←⊂'      ==r.v(x[0]+(D)m,x[1]+(D)k,x[2]+(D)j,x[3]+(D)i))))))',NL
rtn[57],←⊂' z=t;}',NL
rtn[57],←⊂'',NL
rtn[58],←⊂'NM(par,"par",0,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[58],←⊂'par_f par_c;',NL
rtn[58],←⊂'MF(par_f){err(16);}',NL
rtn[58],←⊂'DF(par_f){err(16);}',NL
rtn[58],←⊂'',NL
rtn[59],←⊂'NM(mdv,"mdv",1,0,MT ,MFD,DFD,MT ,MT )',NL
rtn[59],←⊂'mdv_f mdv_c;',NL
rtn[59],←⊂'MF(mdv_f){if(r.r>2)err(4);if(r.r==2&&r.s[1]<r.s[0])err(5);if(!cnt(r))err(5);',NL
rtn[59],←⊂' if(r.s[0]==r.s[1]){z.r=r.r;z.s=r.s;z.v=inverse(r.v);R;}',NL
rtn[59],←⊂' if(r.r==1){z.v=matmulNT(inverse(matmulTN(r.v,r.v)),r.v);z.r=r.r;z.s=r.s;R;}',NL
rtn[59],←⊂' z.v=matmulTN(inverse(matmulNT(r.v,r.v)),r.v);z.r=r.r;z.s=r.s;',NL
rtn[59],←⊂' B k=z.s[0];z.s[0]=z.s[1];z.s[1]=k;z.v=transpose(z.v);}',NL
rtn[59],←⊂'DF(mdv_f){if(r.r>2)err(4);if(l.r>2)err(4);if(r.r==2&&r.s[1]<r.s[0])err(5);',NL
rtn[59],←⊂' if(!cnt(r)||!cnt(l))err(5);if(r.r&&l.r&&l.s[l.r-1]!=r.s[r.r-1])err(5);',NL
rtn[59],←⊂' array rv=r.v,lv=l.v;if(r.r==1)rv=transpose(rv);if(l.r==1)lv=transpose(lv);',NL
rtn[59],←⊂' z.v=transpose(matmul(inverse(matmulNT(rv,rv)),matmulNT(rv,lv)));',NL
rtn[59],←⊂' z.r=(l.r-(l.r>0))+(r.r-(r.r>0));',NL
rtn[59],←⊂' if(l.r>1)z.s[0]=l.s[0];if(r.r>1)z.s[l.r>1]=r.s[0];}',NL
rtn[59],←⊂'',NL
rtn[60],←⊂'NM(fft,"fft",1,0,MT ,MFD,MT ,MT ,MT )',NL
rtn[60],←⊂'fft_f fft_c;',NL
rtn[60],←⊂'MF(fft_f){z.r=r.r;z.s=r.s;z.v=dft(r.v.type()==c64?r.v:r.v.as(c64),1,r.s);}',NL
rtn[60],←⊂'',NL
rtn[61],←⊂'NM(ift,"ift",1,0,MT ,MFD,MT ,MT ,MT )',NL
rtn[61],←⊂'ift_f ift_c;',NL
rtn[61],←⊂'MF(ift_f){z.r=r.r;z.s=r.s;z.v=idft(r.v.type()==c64?r.v:r.v.as(c64),1,r.s);}',NL
rtn[61],←⊂'',NL
:EndNamespace
