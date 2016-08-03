⍝⍝ The Co-dfns Compiler: High-performance, Parallel APL Compiler
⍝⍝ Copyright (c) 2011-2016 Aaron W. Hsu <arcfide@sacrideo.us>
⍝⍝ 
⍝⍝ This program is free software: you can redistribute it and/or modify
⍝⍝ it under the terms of the GNU Affero General Public License as published by
⍝⍝ the Free Software Foundation, either version 3 of the License, or
⍝⍝ (at your option) any later version.
⍝⍝ 
⍝⍝ This program is distributed in the hope that it will be useful,
⍝⍝ but WITHOUT ANY WARRANTY; without even the implied warranty of
⍝⍝ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
⍝⍝ GNU Affero General Public License for more details.
⍝⍝ 
⍝⍝ You should have received a copy of the GNU Affero General Public License
⍝⍝ along with this program.  If not, see <http://www.gnu.org/licenses/>.
⍝⍝ 
:Namespace codfns

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Public API

⍝  Global Settings
⎕IO ⎕ML ⎕WX        ←0 1 3
COMPILER           ←'vsc'
TEST∆COMPILERS     ←⊂'vsc'
DWA∆PATH           ←'dwa'
BUILD∆PATH         ←'build'
VISUAL∆STUDIO∆PATH ←'C:\Program Files (x86)\Microsoft Visual Studio 14.0\'
INTEL∆C∆PATH       ←'C:\Program Files (x86)\IntelSWTools\'
INTEL∆C∆PATH      ,←'compilers_and_libraries_2016.0.110\windows\bin\'
PGI∆PATH           ←'C:\Program Files\PGI\win64\15.7\'
VERSION            ←0 5 0

⍝  Primary Interface
Cmp ←{_←{22::⍬ ⋄ ⍵ ⎕NERASE ⍵ ⎕NTIE 0}so←BSO ⍺
  _←(⍎COMPILER)⍺⊣(BUILD∆PATH,(dirc⍬),⍺,'_',COMPILER,'.c')put⍨gc tt⊃a n←ps ⍵
  22::'COMPILE ERROR'⎕SIGNAL 22 ⋄ n⊣⎕NUNTIE so ⎕NTIE 0}
MkNS←{ns⊣⍺∘{ns.⍎⍺ mkf ⍵}¨(1=1⌷⍉⍵)⌿0⌷⍉⍵⊣ns←#.⎕NS⍬}
Fix ←{⍺ MkNS ⍺ Cmp ⍵}
Xml ←{⎕XML (0⌷⍉⍵),(,∘⍕⌿2↑1↓⍉⍵),(⊂''),⍪(⊂(¯3+≢⍉⍵)↑,¨'nrsvyel'),∘⍪¨↓⍉3↓⍉⍵}
BSO ←{BUILD∆PATH,(dirc⍬),⍵,'_',COMPILER,(soext⍬)}
MKA ←{mka⊂⍵⊣'mka'⎕NA 'P ',(BSO ⍺),'|mkarray <PP'}
EXA ←{exa⍬(0⊃⍵)(1⊃⍵)⊣'exa'⎕NA (BSO ⍺),'|exarray >PP P I4'}
FREA←{frea⍵⊣'frea'⎕NA (BSO ⍺),'|frea P'}

⍝   Helpers for the Primary Interface
dirc ←{'\/'⊃⍨'gcc' 'icc' 'pgcc'∊⍨⊂COMPILER}
soext←{'.dll' '.so'⊃⍨'gcc' 'icc' 'pgcc'∊⍨⊂COMPILER}
tie  ←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
put  ←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}
mkf  ←{f←⍵,'←{' ⋄ fn←BUILD∆PATH,(dirc⍬),⍺,'_',COMPILER,(soext⍬),'|',⍵,' '
       f,←'_←''dya''⎕NA''',fn,'>PP <PP <PP'' ⋄ '
       f,←'_←''mon''⎕NA''',fn,'>PP P <PP'' ⋄ '
       f,'0=⎕NC''⍺'':mon 0 0 ⍵ ⋄ dya 0 ⍺ ⍵} ⋄ 0'}

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Backend Compilers

⍝  UNIX Generic Flags/Options
cfs←'-funsigned-bitfields -funsigned-char -fvisibility=hidden '
cds←'-DxxBIT=64 -DHAS_UNICODE=1 -DUNIX=1 -DWANT_REFCOUNTS=1 -D_DEBUG=1 -lbsd '
cio←{'-I',DWA∆PATH,' -o ''',BUILD∆PATH,'/',⍵,'_',⍺,'.',⍺⍺,''' '}
fls←{'''',DWA∆PATH,'/dwa_fns.c'' ''',BUILD∆PATH,'/',⍵,'_',⍺,'.c'' '}
log←{'> ',BUILD∆PATH,'/',⍵,'_',⍺,'.log 2>&1'}

⍝  Clang (Mac OS X)
cop←'-Ofast -g -Wall -Wno-unused-function -Wno-unused-variable -fPIC -shared '
clang←{⎕SH'clang ',cfs,cds,gop,'gcc'('dylib'cio,fls,log)⍵}

⍝  GCC (Linux Only)
gop←'-Ofast -g -Wall -Wno-unused-function -Wno-unused-variable -fPIC -shared '
gcc←{⎕SH'gcc ',cfs,cds,gop,'gcc'('so'cio,fls,log)⍵}

⍝  Intel C Linux
iop←'-fast -g -fno-alias -static-intel -mkl -Wall -Wno-unused-function -fPIC -shared '
icc←{⎕SH'icc ',cfs,cds,iop,'icc'('so'cio,fls,log)⍵}

⍝  PGI C Linux
pop←' -fast -acc -ta=tesla:maxregcount:32,nollvm,nordc,cuda7.5 -Minfo -fPIC '
pgcco←{cmd←'pgcc -c ',cds,pop,'-I',DWA∆PATH,' '
  ⎕SH cmd,'-o ''',⍵,'.o'' ''',⍵,'.c'' >> ''',BUILD∆PATH,'/',⍺,'_pgcc.log'' 2>&1'}
pgccld←{cmd←'pgcc -shared ',cds,pop,'-o ''',BUILD∆PATH,'/',⍺,'_pgcc.so'' '
  ⎕SH cmd,⍵,' >> ''',BUILD∆PATH,'/',⍺,'_pgcc.log'' 2>&1'}
pgcc←{_←⎕SH'echo "" > ''',BUILD∆PATH,'/',⍵,'_pgcc.log'''
  _←⍵ pgcco DWA∆PATH,'/dwa_fns' ⋄ _←⍵ pgcco BUILD∆PATH,'/',⍵,'_pgcc'
  ⍵ pgccld '''',DWA∆PATH,'/dwa_fns.o'' ''',BUILD∆PATH,'/',⍵,'_pgcc.o'''}

⍝  VS/IC Windows Flags
vsco←'/W3 /Gm- /O2 /Zc:inline ' ⍝ /Zi /Fd"build\vc140.pdb" '
vsco,←'/D "HAS_UNICODE=1" /D "xxBIT=64" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" '
vsco,←'/D "_USRDLL" /D "DWA_EXPORTS" /D "_WINDLL" '
vsco,←'/errorReport:prompt /WX- /MD /EHsc /nologo '
vslo←'/link /DLL /OPT:REF /INCREMENTAL:NO /SUBSYSTEM:WINDOWS '
vslo,←'/OPT:ICF /ERRORREPORT:PROMPT /TLBID:1 '

⍝  Visual Studio C
vsc1←{'""',VISUAL∆STUDIO∆PATH,'VC\vcvarsall.bat" amd64 && cl ',vsco,'/fast '}
vsc2←{'/I"',DWA∆PATH,'\\" /Fo"',BUILD∆PATH,'\\" "',DWA∆PATH,'\dwa_fns.c" '}
vsc3←{'"',BUILD∆PATH,'\',⍵,'_vsc.c" ',vslo,'/OUT:"',BUILD∆PATH,'\',⍵,'_vsc.dll" '}
vsc4←{'> "',BUILD∆PATH,'\',⍵,'_vsc.log""'}
vsc←⎕CMD '%comspec% /C ',vsc1,vsc2,vsc3,vsc4

⍝  Intel C Windows
icl1←{'""',INTEL∆C∆PATH,'\ipsxe-comp-vars.bat" intel64 vs2015 && icl ',vsco,'/Ofast '}
icl3←{'"',BUILD∆PATH,'\',⍵,'_icl.c" ',vslo,'/OUT:"',BUILD∆PATH,'\',⍵,'_icl.dll" '}
icl4←{'> "',BUILD∆PATH,'\',⍵,'_icl.log""'}
icl←⎕CMD '%comspec% /E:ON /V:ON /C ',icl1,vsc2,icl3,icl4

⍝  PGI C Windows
pgio←'-D "HAS_UNICODE=1" -D "xxBIT=64" -D "WIN32" -D "NDEBUG" -D "_WINDOWS" '
pgio,←'-D "_USRDLL" -D "DWA_EXPORTS" -D "_WINDLL" -D "HASACC" '
pgwc←{z←'pgcc -fast -Bdynamic -acc -Minfo ',pgio,'-I "',DWA∆PATH,'\\" '
  z,←'-c "',⍵,'.c" -o "',⍵,'.obj"' ⋄ z}
pglk←{z←'pgcc -fast -Mmakedll -acc -Minfo -o "',BUILD∆PATH,'\',⍵,'_pgi.dll" "'
  z,←BUILD∆PATH,'\',⍵,'_pgi.obj" "',DWA∆PATH,'\dwa_fns.obj"' ⋄ z}
pgi1←{'""',PGI∆PATH,'pgi_env.bat" && ',(pgcc BUILD∆PATH,'\',⍵,'_pgi'),' && '}
pgi2←{(pgwc DWA∆PATH,'\dwa_fns'),' && ',pglk ⍵}
pgi3←{' > "',BUILD∆PATH,'\',⍵,'_pgi.log""'}
pgi←⎕CMD '%comspec% /C ',pgi1,pgi2,pgi3

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ AST

get     ←{⍺⍺⌷⍉⍵}
up      ←⍉(1+1↑⍉)⍪1↓⍉
bind    ←{n _ e←⍵ ⋄ (0 n_⌷e)←⊂n ⋄ e}

⍝  Field Descriptors/Accessors
d_ t_ k_ n_   ←⍳f∆←4   ⋄ d←d_ get ⋄ t←t_ get ⋄ k←k_ get ⋄ n←n_ get
r_ s_ v_ y_ e_←f∆+⍳5   ⋄ r←r_ get ⋄ s←s_ get ⋄ v←v_ get ⋄ y←y_ get ⋄ e←e_ get
l_            ←f∆+5+⍳1 ⋄ l←l_ get

⍝  Node Constructors, Masks, and Selectors
new←{⍉⍪f∆↑0 ⍺,⍵}                  ⋄ msk←{(t ⍵)∊⊂⍺⍺} ⋄ sel←{(⍺⍺ msk ⍵)⌿⍵}
A  ←{('A'new ⍺⍺)⍪up⊃⍪/⍵}          ⋄ Am←'A'msk       ⋄ As←'A'sel
E  ←{('E'new ⍺⍺)⍪up⊃⍪/⍵}          ⋄ Em←'E'msk       ⋄ Es←'E'sel
F  ←{('F'new 1)⍪up⊃⍪/(⊂0 f∆⍴⍬),⍵} ⋄ Fm←'F'msk       ⋄ Fs←'F'sel
M  ←{('M'new⍬)⍪up⊃⍪/(⊂0 f∆⍴⍬),⍵}  ⋄ Mm←'M'msk       ⋄ Ms←'M'sel
N  ←{'N'new 0 (⍎⍵)}               ⋄ Nm←'N'msk       ⋄ Ns←'N'sel
O  ←{('O'new ⍺⍺)⍪up⊃⍪/⍵}          ⋄ Om←'O'msk       ⋄ Os←'O'sel
P  ←{'P'new 0 ⍵}                  ⋄ Pm←'P'msk       ⋄ Ps←'P'sel
S  ←{'S'new 0 ⍵}                  ⋄ Sm←'S'msk       ⋄ Ss←'S'sel
V  ←{'V'new ⍺⍺ ⍵}                 ⋄ Vm←'V'msk       ⋄ Vs←'V'sel
Y  ←{'Y'new 0 ⍵}                  ⋄ Ym←'Y'msk       ⋄ Ys←'Y'sel
Z  ←{'Z'new 1 ⍵}                  ⋄ Zm←'Z'msk       ⋄ Zs←'Z'sel

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Parser

⍝  Parsing Combinators
_s←{0<⊃c a e r←z←⍺ ⍺⍺ ⍵:z ⋄ 0<⊃c2 a2 e r←z←e ⍵⍵ r:z ⋄ (c⌈c2)(a,a2) e r}
_o←{0≥⊃c a e r←z←⍺ ⍺⍺ ⍵:z ⋄ 0≥⊃c a e r2←z←⍺ ⍵⍵ ⍵:z ⋄ c a e(r↑⍨-⌊/≢¨r r2)}
_any←{⍺(⍺⍺ _s ∇ _o _yes)⍵} ⋄ _some←{⍺(⍺⍺ _s (⍺⍺ _any))⍵}
_opt←{⍺(⍺⍺ _o _yes)⍵} ⋄ _yes←{0 ⍬ ⍺ ⍵}
_t←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ e ⍵⍵ a:c a e r ⋄ 2 ⍬ ⍺ ⍵}
_set←{(0≠≢⍵)∧(⊃⍵)∊⍺⍺:0(,⊃⍵)⍺(1↓⍵) ⋄ 2 ⍬ ⍺ ⍵}
_tk←{((≢,⍺⍺)↑⍵)≡,⍺⍺:0(⊂,⍺⍺)⍺((≢,⍺⍺)↓⍵) ⋄ 2 ⍬ ⍺ ⍵}
_as←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ c (,⊂⍵⍵ a) e r} ⋄ _enc←{⍺(⍺⍺ _as {⍵})⍵}
_ign←{c a e r←⍺ ⍺⍺ ⍵ ⋄ c ⍬ e r}
_env←{0<⊃c a e r←p←⍺ ⍺⍺ ⍵:p ⋄ c a (e ⍵⍵ a) r}
_aew←{⍺(⍵⍵ _o (⍺⍺ _s ∇))⍵}

⍝  Terminals/Tokens
ws←(' ',⎕UCS 9)_set
aws←ws _any _ign ⋄ awslf←(⎕UCS 10 13)_set _o ws _any _ign
nss←awslf _s(':Namespace'_tk)_s awslf _ign
nse←awslf _s(':EndNamespace'_tk)_s awslf _ign
gets←aws _s('←'_tk)_s aws ⋄ him←'¯'_set ⋄ dot←'.'_set ⋄ jot←'∘'_set
lbrc←aws _s('{'_tk)_s aws _ign ⋄ rbrc←aws _s('}'_tk)_s aws _ign
lpar←aws _s('('_tk)_s aws _ign ⋄ rpar←aws _s(')'_tk)_s aws _ign
lbrk←aws _s('['_tk)_s aws _ign ⋄ rbrk←aws _s(']'_tk)_s aws _ign
alpha←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'_set
digits←'0123456789'_set
prim←(prims←'+-÷×|*⍟⌈⌊!<≤=≠≥>∧∨⍲⍱⌷?⍴,⍪⌽⊖⍉∊⊃⍳○~≡≢⊢⊣/⌿\⍀⊤⊥↑↓')_set
mop←'¨/⌿⍀\⍨'_set ⋄ dop←'.⍤⍣∘'_set
eot←aws _s {''≡⍵:0 ⍬ ⍺ '' ⋄ 2 ⍬ ⍺ ⍵} _ign
digs←digits _some ⋄ odigs←digits _any
int←aws _s (him _opt) _s digs _s aws
float←aws _s (int _s dot _s odigs _o (dot _s digs)) _s aws
name←aws _s alpha _s (alpha _o digits _any) _s aws
aw←aws _s ('⍺⍵'_set) _s aws
sep←aws _s (('⋄',⎕UCS 10 13)_set _ign) _s aws

⍝  Productions
Sfn   ←aws _s (('⎕sp' _tk)_o('⎕XOR' _tk)) _s aws _as {P ∊⍵}
Prim  ←prim _as {P⍵⍴⍨1+⍵∊'/⌿⍀\'} _o Sfn
Fn    ←{0<⊃c a e r←p←⍺(lbrc _s (Stmt _aew rbrc) _as F)⍵:p ⋄ c a ⍺ r}
Fnp   ←Fn _o Prim
Mop   ←(jot _s dot _as P) _s Fnp _as (1 O∘⌽) _o (Fnp _s (mop _as P) _as (1 O))
Dop   ←Fnp _s (dop _as P) _s Fnp _as (2 O)
Bop   ←{⍺(Prim _s lbrk _s Ex _s rbrk _as ('i'O))⍵}
Bind  ←{⍺(name _enc _s gets _s ⍺⍺ _env (⍵⍵{(⊃⍵)⍺⍺⍪⍺}) _as bind)⍵}
Fex   ←{⍺(∇ Bind 1 _o Dop _o Mop _o Bop _o Fn _o (1 Var'f') _o Prim)⍵}
Vt    ←{((0⌷⍉⍺)⍳⊂⍵)1⌷⍺⍪'' ¯1}
Var   ←{⍺(aw _o (name _t (⍺⍺=Vt)) _as (⍵⍵ V))⍵}
Num   ←float _o int _as N
Strand←0 Var 'a'  _s (0 Var 'a' _some) _as ('s'A)
Atom  ←{⍺(Num _some _as ('n'A) _o Strand _o (0 Var'a' _as ('v'A)) _o Pex)⍵}
Mon   ←{⍺(Fex _s Ex _as (1 E))⍵}
Dya   ←{⍺((Idx _o Atom) _s Fex _s Ex _as (2 E))⍵}
Idx   ←{⍺(Atom _s lbrk _s Ex _s rbrk _as ('i'E))⍵}
Ex    ←{⍺(∇ Bind 0 _o Dya _o Mon _o Idx _o Atom)⍵}
Pex   ←lpar _s Ex _s rpar
Stmt  ←sep _any _s (Ex _o Fex) _s (sep _any)
Ns    ←nss _s (Stmt _aew nse) _s eot _as M

ps←{0≠⊃c a e r←(0 2⍴⍬)Ns ∊⍵,¨⎕UCS 10:⎕SIGNAL c ⋄ (⊃a)e}

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Core Compiler

tt←{fd fz ff if ef td vc fs rl av va lt nv fv ce ur fc∘pc⍣≡ ca fe mr dn lf du df rd rn ⍵}

⍝  Utilities
scp←(1,1↓Fm)⊂[0]⊢
mnd←{A⊣((⍺ ⍺⍺ ⍵)⌿A)←⍺⊣A←⍵⍵ ⍵}
sub←{⍺←⊢ ⋄ A⊣(m⌿A)←⍺ ⍺⍺(m←⍺ ⍵⍵ ⍵)⌿A←⍵}
at←{⍺←⊢ ⋄ A⊣((,B)⌿(r A)⍴A)←⍺ ⍺⍺(,B)⌿((r←(≢⍴B←⍵⍵ ⍵)((×/↑),↓)⍴)A)⍴(A←⍵)}
prf←((≢↑¯1↓(0≠⊢)(/∘⊢)⊢)⍤1↑∘r)⊢
blg←{⍺←⊢ ⋄ ⍺((prf(⌈/(⍳∘≢⊢)×⍤1(1↓⊣)∧.(=∨0=⊢)∘⍉⊢)⍺⍺(⌿∘↑)r)⌷⍤0 2 ⍺⍺(⌿∘⊢)⍵⍵)⍵}
enc←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
veo←∪((⊂'%u'),(,¨prims),⊣)~⍨∘{⊃,/{⊂⍣(1≡≡⍵)⊢⍵}¨⍵}¯1↓⊢(/⍨)(∧/¨0≠((⊃0⍴⊢)¨⊢))
ndo←{⍺←⊢ ⋄ m⊃∘(⊂,⊢)¨⍺∘⍺⍺¨¨⍵⊃∘(,∘⊂⍨⊂)¨⍨m←1≥≡¨⍵}
n2f←(⊃,/)((1=≡)⊃,∘⊂⍨∘⊂)¨

⍝  Compiler Passes

⍝   Record Node Coordinates
rn←⊢,∘↓(1+d)↑⍤¯1(+⍀d∘.=∘⍳1+(⌈/0,d))

⍝   Record Function Depths
rd←⊢,(+/↑∘r∧.(=∨0=⊢)∘⍉∘↑∘r Fs)

⍝   Drop Unnamed Functions
df←(~(+\1=d)∊((1=d)∧(Om∨Fm)∧0∊⍨n)(/∘⊢)(+\1=d))(⌿∘⊢)⊢

⍝   Drop Unreachable Code
dua     ←(Fm∨↓∘prf∊r∘Fs)(⊣(⍀∘⊢)(⊣(⌿∘⊢)0∊⍨n)(0,1↓(¯1⌽⊣)∧⊢=¯1⌽⊢)⊣(⌿∘⊢)d)⊢
du      ←(~dua∨(∨/(prf∧.(=∨0=⊢)∘⍉dua(⌿∘⊢)prf)∧↑∘r∧.≥∘⍉dua(⌿∘⊢)↑∘r×0=prf))(⌿∘⊢)⊢

⍝   Lift Functions
lfv     ←⍉∘⍪(1+⊣),'Vf',('fn'enc 4⊃⊢),4↓⊢
lfn     ←('F'≡1⊃⊢)⌷(⊣-⍨∘⊃⊢)((⊂∘⍉∘⍪⊣,1↓⊢),∘⊂(⊣,'Of',3↓⊢)⍪lfv)⊢
lfh     ←(1<(+/⊣))⊃(⊂0↑⊢),∘⊂∘⍉∘⍪1'F'1,('fn'enc⊣),(⊂⊣),5↓∘,1↑⊢
lf      ←(1↑⊢)⍪∘⊃(⍪/(1,1↓Fm)blg(↑r)(⊂lfh⍪∘⊃(⍪/((¯2+1=(+/⊣))+∘⊃⊢)lfn⍤¯1⊢))⌸1↓⊢)

⍝   Drop Redundant Nodes
dn←((0∊⍨n)∧(Am∧'v'∊⍨k)∨Om∧'f'∊⍨k)((~⊣)(⌿∘⊢)(d-¯1⌽⊣),1↓[1]⊢)⊢

⍝   Mark/Unmark Unit Returns
mre     ←(⊢⍴⍨6,⍨≢×2<≢)(2 'E' 'u',3↓∘,1↑⊢)⍪(3'P'0(,'⊢'),4↓∘,1↑⊢)⍪(1+d),1↓⍤1⊢
mrm     ←∨\(Vm∨Am)∧((¯1+≢)-1⍳⍨∘⌽2=d)=(⍳≢)
mr      ←(⊃⍪/)((1↑⊢),((⊢(⌿⍨∘~⍪∘mre(⌿⍨))mrm)¨1↓⊢))∘scp
ur      ←((2↑⊢),1,('um'enc∘⊃r),4↓⊢)⍤1sub(Em∧'u'∊⍨k)

⍝   Flatten Expressions
fen←n((3↑⊢),('fe'enc∘⊃r),4↓⊢)⍤1 at((0∊⍨n)∧Em∨Om∨Am)
fet←('V'0⍴⍨2,⍨(+/0,1↓Em∨Om∨Am))(0,1↓Em∨Om∨Am)mnd(t,∘⍪k)⊢
fee←(⍪/⌽)(1,1↓Em∨Om∨Am)blg⊢((⊂(d-⊃-2⌊⊃),fet,fen,4↓⍤1⊢)⍪)⌸1↓⊢
fe←(⊃⍪/)(+\Fm)(⍪/(⊂1↑⊢),∘((+\d=⊃)fee⌸⊢)1↓⊢)⌸⊢

⍝   Compress Atomic Nodes
can     ←(+\Am∨Om)((,1↑⊢),∘(⊂(¯1+2⌊≢)⊃(⊂∘⊂⊃),⊂)∘n 1↓⊢)⌸⊢
cam     ←Om∧'f'∊⍨k
cas     ←(Am(1↑⊢)⍪(Mm∨Am)blg⊢)∨¯1⌽cam
ca      ←(can (cam∨cas∨Am)(⌿∘⊢)⊢)(Am∨cam)mnd⊢⍬,∘⊂⍨(~cas)(⌿∘⊢)⊢

⍝   Propogate Constants
pcc     ←(⊂⊢(⌿⍨)Am∨Om∧'f'∊⍨k)∘((⍳∘∪⍨n)⌷⍤0 2(1⌈≢)↑⊢)∘((1+⊃),1↓⍤1⊢)∘(⊃⍪⌿)∘⌽(⌿∘⊢)
pcs     ←(d,'V','f',(⊃v),r,(⊂⍬),⍨∘⍪s)sub Om
pcv     ←(d,'V','a',(⊃v),r,(⊂⍬),⍨∘⍪s)sub (Am∧'v'∊⍨k)
pcb     ←((,∧.(=∨0=⊣)∘⍪)⍤2 1⍨∘↑∘r(1↑⊢)⍪Fs)pcc⍤1((⊢(⌿⍨)d=1+⊃)¨⊣)
pcd     ←((~(Om∧('f'∊⍨k)∧1≠d)∨Am∧d=1+(∨\Fm))(⌿∘⊢)⊢)∘(⊃⍪/)
pc      ←pcd scp(pcb(pcv∘pcs(((1⌈≢)↑⊢)⊣)⌷⍤0 2⍨(n⊣)⍳n)sub(Vm∧n∊∘n⊣)¨⊣)⊢

⍝   Fold Constant Expressions
fce     ←(⊃∘n Ps){⊂⍎' ⍵',⍨(≢⍵)⊃''(⍺,'⊃')('⊃',⍺,'/')⊣⍵}(v As)
fcm     ←(∧/Em∨Am∨Pm)∧'u'≢∘⊃∘⊃k
fc      ←((⊃⍪/)(((d,'An',3↓¯1↓,)1↑⊢),fce)¨sub(fcm¨))('MFOE'∊⍨t)⊂[0]⊢

⍝   Compress Expressions
ce←(+\Fm∨Em∨Om)((¯1↓∘,1↑⊢),∘⊂(⊃∘v 1↑⊢),∘((v As)Am mnd n⊢)1↓⊢)⌸⊢

⍝   Record Final Return Value
fv←(⊃⍪/)(((1↓⊢)⍪⍨(,1 6↑⊢),∘⊂∘n ¯1↑⊢)¨scp)

⍝   Normalize Values Field
nvu     ←⊂'%u' ⋄ nvi      ←⊂'%i'
nvo     ←((¯1↓⊢),({⍺'%b'⍵}/∘⊃v))⍤1sub(Om∧'i'∊⍨k)
nve     ←((¯1↓⊢),({,¨⍺'['⍵}/∘⊃v))⍤1sub(Em∧'i'∊⍨k)
nvk     ←((2↑⊢),2,(3↓⊢))⍤1sub(Em∧'i'∊⍨k)
nv      ←nvk(⊢,⍨¯1↓⍤1⊣)Om((¯1⊖(¯1+≢)⊃(⊂nvu,nvi,⊢),(⊂nvu⍪⊢),∘⊂⊢){⌽⍣⍺⊢⍵})¨v∘nvo∘nve

⍝   Lift Type-checking

⍝⍝ Index Right     Left       Value Type Type
⍝⍝    0  Unknown   Unknown    Unknown    0
⍝⍝    1  Unknown   Integer    Integer    1
⍝⍝    2  Unknown   Float      Float      2
⍝⍝    3  Unknown   Bitvector  Bitvector  3
⍝⍝    4  Unknown   Not bound  Not bound  4
⍝⍝    5  Integer   Unknown
⍝⍝    6  Integer   Integer
⍝⍝    7  Integer   Float      Ops. Code  Meaning
⍝⍝    8  Integer   Bitvector  Left       0
⍝⍝    9  Integer   Not bound  Right      1
⍝⍝   10  Float     Unknown    Error     ¯N
⍝⍝   11  Float     Integer
⍝⍝   12  Float     Float
⍝⍝   13  Float     Bitvector
⍝⍝   14  Float     Not bound
⍝⍝   15  Bitvector Unknown
⍝⍝   16  Bitvector Integer
⍝⍝   17  Bitvector Float
⍝⍝   18  Bitvector Bitvector
⍝⍝   19  Bitvector Not bound

⍝    Primitive Types
pfs←{⍺←0 ⋄ A⊣A[9 14 19 6 7 8 11 12 13 16 17 18]←⍵⊣A←20⍴⍺}
pn←⍬ ⋄ pt←0 20⍴0

⍝⍝   RL: IN  FN  BN  II  IF  IB  FI  FF  FB  BI  BF  BB
pt⍪←4 pfs 4                                            ⊣pn,←⊂'%u'
pt⍪←pfs   1   2   3   1   1   1   2   2   2   3   3   3⊣pn,←⊂'%b'
pt⍪←pfs   1   2   3   1   1   1   2   2   2   3   3   3⊣pn,←⊂'%i'
pt⍪←pfs  ¯6  ¯6  ¯6   1   2   3   1   2   3   1   2   3⊣pn,←⊂,'⍺'
pt⍪←pfs   1   2   3   1   1   1   2   2   2   3   3   3⊣pn,←⊂,'⍵'
pt⍪←pfs   1   2   3   1   2   1   2   2   2   1   2   1⊣pn,←⊂,'+'
pt⍪←pfs   1   2   1   1   2   1   2   2   2   1   2   1⊣pn,←⊂,'-'
pt⍪←pfs   2   2   3   2   2   2   2   2   2   1   2   3⊣pn,←⊂,'÷'
pt⍪←pfs   1   1   3   1   2   1   2   2   2   1   2   3⊣pn,←⊂,'×'
pt⍪←pfs   1   2   3   1   2   1   2   2   2   1   2   3⊣pn,←⊂,'|'
pt⍪←pfs   2   2   2   2   2   2   2   2   3   1   2   3⊣pn,←⊂,'*'
pt⍪←pfs   2   2 ¯11   2   2 ¯11   2   2 ¯11 ¯11 ¯11 ¯11⊣pn,←⊂,'⍟'
pt⍪←pfs   1   1   3   1   2   1   2   2   2   1   2   3⊣pn,←⊂,'⌈'
pt⍪←pfs   1   1   3   1   2   1   2   2   2   1   2   3⊣pn,←⊂,'⌊'
pt⍪←pfs  ¯2  ¯2  ¯2   3   3   3   3   3   3   3   3   3⊣pn,←⊂,'<'
pt⍪←pfs  ¯2  ¯2  ¯2   3   3   3   3   3   3   3   3   3⊣pn,←⊂,'≤'
pt⍪←pfs  ¯2  ¯2  ¯2   3   3   3   3   3   3   3   3   3⊣pn,←⊂,'='
pt⍪←pfs  ¯2  ¯2  ¯2   3   3   3   3   3   3   3   3   3⊣pn,←⊂,'≠'
pt⍪←pfs  ¯2  ¯2  ¯2   3   3   3   3   3   3   3   3   3⊣pn,←⊂,'≥'
pt⍪←pfs  ¯2  ¯2  ¯2   3   3   3   3   3   3   3   3   3⊣pn,←⊂,'>'
pt⍪←pfs   1   2   3   1 ¯11   1   2 ¯11   2   3 ¯11   3⊣pn,←⊂,'⌷'
pt⍪←pfs   1   1   1   1 ¯11   1   2 ¯11   2   3 ¯11   3⊣pn,←⊂,'⍴'
pt⍪←pfs   1   2   3   1   2   1   2   2   2   1   2   3⊣pn,←⊂,','
pt⍪←pfs   1 ¯11   3   1   1   1   1   1   1   1   1   1⊣pn,←⊂,'⍳'
pt⍪←pfs   2   2   2   2 ¯11   2   2 ¯11   2   2 ¯11   2⊣pn,←⊂,'○'
pt⍪←pfs ¯11 ¯11   3   1   2   3   1   2   3   1   2   3⊣pn,←⊂,'~'
pt⍪←pfs  ¯2  ¯2  ¯2   1   2   3 ¯11 ¯11 ¯11   1   2   3⊣pn,←⊂,'['
pt⍪←pfs  ¯2  ¯2  ¯2   1   1   1   1   2   2   1   2   3⊣pn,←⊂,'∧'
pt⍪←pfs  ¯2  ¯2  ¯2   1   2   1   2   2   2   1   2   3⊣pn,←⊂,'∨'
pt⍪←pfs  ¯2  ¯2  ¯2 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11   3⊣pn,←⊂,'⍲'
pt⍪←pfs  ¯2  ¯2  ¯2 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11   3⊣pn,←⊂,'⍱'
pt⍪←pfs   1   2   3   1   2   1   2   2   2   1   2   3⊣pn,←⊂,'⍪'
pt⍪←pfs   1   2   3   1 ¯11   1   2 ¯11   2   3 ¯11   3⊣pn,←⊂,'⌽'
pt⍪←pfs   1   2   3   3   3   3   3   3   3   3   3   3⊣pn,←⊂,'∊'
pt⍪←pfs   1   2   3   1   1   1   2   2   2   3   3   3⊣pn,←⊂,'⊃'
pt⍪←pfs   1   2   3   1 ¯11   1   2 ¯11   2   3 ¯11   3⊣pn,←⊂,'⊖'
pt⍪←pfs   1   1   1   1   1   1   1   1   1   1   1   1⊣pn,←⊂,'≡'
pt⍪←pfs   1   1   1   1   1   1   1   1   1   1   1   1⊣pn,←⊂,'≢'
pt⍪←pfs   1   2   3   1   1   1   2   2   2   3   3   3⊣pn,←⊂,'⊢'
pt⍪←pfs   1   2   3   1   2   3   1   2   3   1   2   3⊣pn,←⊂,'⊣'
pt⍪←pfs  ¯2  ¯2  ¯2   1 ¯11   1   2 ¯11   2   3 ¯11   3⊣pn,←⊂'//'
pt⍪←pfs   1   2   3   1   1   1   2   2   2   3   3   3⊣pn,←⊂,'⍉'
pt⍪←pfs   1   2   3   1   1   1   2   2   2   3   3   3⊣pn,←⊂,'↑'
pt⍪←pfs   1   2   3   1   1   1   2   2   2   3   3   3⊣pn,←⊂,'↓'
pt⍪←pfs  ¯2  ¯2  ¯2   1 ¯16   1 ¯16 ¯16 ¯16   3   3   3⊣pn,←⊂,'⊤'
pt⍪←pfs  ¯2  ¯2  ¯2   1 ¯16   1 ¯16 ¯16 ¯16   1 ¯16   1⊣pn,←⊂,'⊥'
pt⍪←pfs   2   2   3   1   2   1   2   2   2   1   2   3⊣pn,←⊂,'!'
pt⍪←pfs   2 ¯11   2 ¯16 ¯16 ¯16 ¯16 ¯16 ¯16 ¯16 ¯16 ¯16⊣pn,←⊂,'?'
pt⍪←pfs   0   0   0   0   0   0   0   0   0   0   0   0⊣pn,←⊂,'¨'
pt⍪←pfs   0   0   0   0   0   0   0   0   0   0   0   0⊣pn,←⊂,'⍨'
pt⍪←pfs   0   0   0   0 ¯11   0   0 ¯11   0   0 ¯11   0⊣pn,←⊂,'/'
pt⍪←pfs   0   0   0   0 ¯11   0   0 ¯11   0   0 ¯11   0⊣pn,←⊂,'⌿'
pt⍪←pfs   0   0   0 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11⊣pn,←⊂,'\'
pt⍪←pfs   0   0   0 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11⊣pn,←⊂,'⍀'
pt⍪←pfs  ¯2  ¯2  ¯2   0   0   0   0   0   0   0   0   0⊣pn,←⊂'∘.'
pt⍪←pfs  ¯2  ¯2  ¯2   0   0   0   0   0   0   0   0   0⊣pn,←⊂,'.'
pt⍪←pfs  ¯2  ¯2  ¯2   1 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11 ¯11⊣pn,←⊂'⎕sp'
pt⍪←pfs  ¯2  ¯2  ¯2   1 ¯16 ¯16 ¯16 ¯16 ¯16 ¯16 ¯16 ¯16⊣pn,←⊂'⎕XOR'

⍝    Operator Indirections

⍝[c]oti:      (0 Lop) (1 Rop) (2 Rarg) (3 Larg)
otn←⍬       ⋄ oti←0 2 2⍴⍬
otn,←⊂,'.'  ⋄ oti⍪←↑(1 1)   (2 3)   ⋄ otn,←⊂,'/'      ⋄ oti⍪←↑(2 2)   (2 3)
otn,←⊂,'⌿'        ⋄ oti⍪←↑(2 2)   (2 3)   ⋄ otn,←⊂,'\'      ⋄ oti⍪←↑(2 2)   (2 3)
otn,←⊂,'⍀'        ⋄ oti⍪←↑(2 2)   (2 3)   ⋄ otn,←⊂'∘.'    ⋄ oti⍪←↑(2 3)   (2 3)
otn,←⊂,'¨' ⋄ oti⍪←↑(2 3)   (2 3)
        oti⍪←↑(2 3)       (2 3)
⍝[cf]

lte     ←((20⌊1 4 5⊥((∨⌿¯1=×)⍪|))2↑⊢)⌷⍤0 1∘,(⌊/∘,2↑⊢),⍨¯1↑⊢
ltoa    ←lte⍤2(2↑⊣),[1]⍨(oti⌷⍨otn⍳¯1↑∘⊃v)(⌷⍤0 2)(4 5⊤⍳20)⍪⍨(2↑1↓(⊃y))
ltob    ←(⍴⊣)⍴(,(⌈/⊢))(⌷⍤0 1)0 4 3 1 2,⍤1 0∘,⊣
ltoc    ←ltoa(⊣ltob 5 0 3 4 2 1⌷⍤0 1⍨1+¯1⌈,∘⍪⍤1)(4 5⊤⍳20)×(,¨'/⌿\⍀')∊⍨¯1↑∘⊃v
lto     ←(((1+¯1⌈⊃)⌷0 0,⍨⊢)⍤1∘⍉⍪1⊖⊢)(¯1↑⊣)⍪ltoc
ltv     ←(1⊃⊣)⌷⍤0 2⍨(⊃¨(0⊃⊣)⍳∘⊂ndo(⊃v))
ltt     ←(Om∧1 2∨.=∘⊃k)⊃⊣(((lte⍪⊢)ltv){⍺⍵}ltv lto ⊢)(⍉∘⍪⊢)
lta     ←(1↓¨(⊂⊢),∘⊂(20⍴1+(≢∘⌊⍨⊃∘⊃))⍤0)∘(0,∘∪(0≡∘⊃0⍴⊢)¨(⌿∘⊢)⊢)∘(⊃,/)∘v Es⍪Os
ltb     ←⊣⍪¨(⊂n),∘⊂∘↑((,1↑⊢)¨y)
lt      ←(pn pt⍪¨lta)(ltb((,¯1↓⊢),∘⊂ltt)⍤1⊢)⍣≡(⊂4 20⍴0),⍨⊢

⍝   Allocate Value Slots
val     ←(n⍳∘∪n),¨⊢(⊢+(≢⊣)×0=⊢)(⌈/(⍳≢)×⍤1(∪n)∘.((⊂⊣)∊⊢)(n2f¨v))
vag     ←∧∘~∘(∘.=⍨∘⍳≢)⍨(∘.(((1⌷⊢)>0⌷⊣)∧(0⌷⊢)<1⌷⊣)⍨val)
vae     ←(∪n)(⊣,⍤0⊣(⌷⍨⍤1 0)∘⊃((⊢,(⊃(⍳∘≢⊣)~((≢⊢)↑⊣)(/∘⊢)⊢))/∘⌽(⊂⍬),∘↓⊢))vag
vac     ←(((0⌷∘⍉⊣)⍳∘⊂⊢)⊃(1⌷∘⍉⊣),∘⊂⊢)ndo
va      ←((⊃⍪/)(1↑⊢),(((vae Es)(d,t,k,(⊣vac n),r,s,y,∘⍪⍨(⊂⊣)vac¨v)⊢)¨1↓⊢))scp

⍝   Anchor Variables to Values
avb     ←{(((,¨'⍺⍵')↑⍨1↓⍴)⍪⊢)⍺⌷⍨⍤2 0⊢⍺⍺⍳⍺⍺∩⍨(↓(⌽1+∘⍳0⍳⍨⊢)((≢⊢)↑↑)⍤0 1⊢)⊃r ⍵}
avi     ←¯1 0+(⍴⊣)⊤(,⊣)⍳(⊂⊢)
avh     ←{⊂⍵,(n⍵)((⍺⍺(⍵⍵ avb)⍵){⍺⍺ avi ndo(⊂⍺),⍵})¨v⍵}
av      ←(⊃⍪/)(+\Fm){⍺((⍺((∪∘⌽n)Es)⌸⍵)avh(r(1↑⍵)⍪Fs ⍵))⌸⍵}⊢

⍝   Record Live Variables
rlf     ←(⌽↓(((1⊃⊣)∪⊢~0⌷⊣)/∘⌽(⊂⍬),↑)⍤0 1⍨1+∘⍳≢)(⊖1⊖n,⍤0(⊂⊣)veo¨v)
rl      ←⊢,∘(⊃,/)(⊂∘n Os⍪Fs)rlf¨scp

⍝   Fuse Scalar Loops
fsf     ←(∪∘⊃,/)(⊂⊂⍬ ⍬ ⍬),(⌽¯1↓⊢)¨~¨(⊂,⊂'%u'(4⍴⍨≢⍉pt)(¯1 0))∪¨∘(⍳∘≢↑¨⊂)⊣
fsn     ←↓n,((,1↑⊢)¨y),⍤0(⊃¨e)
fsv     ←v(↓,∘⊃⍤0)¨((↓1↓⊢)¨y)(↓,⍤0)¨1↓¨e
fsh     ←(⍉⍪)2'S'0 ⍬ ⍬ 0,(((⊂0⌷⊢),(⊂∘↑1⌷⊢),(⊂2⌷⊢))∘⍉1↓∘↑fsn fsf fsv),∘l ¯1↑⊢
fsm     ←Em∧(1∊⍨k)∧(,¨'~⌷')∊⍨(⊃∘⌽¨v)
fss     ←fsm∨Em∧(1 2∊⍨k)∧((⊂'⎕XOR'),⍨,¨'+-×÷|⌊⌈*⍟○!∧∨⍱⍲<≤=≥>≠')∊⍨(⊃∘⌽¨v)
fsx     ←(⊣(/∘⊢)fss∧⊣)(⊣⊃(⊂⊢),(⊂fsh⍪(1+d),'E',0,3↓⍤1⊢))¨⊂[0]
fs      ←(⊃⍪/)(((((⊃⍪/)(⊂0 10⍴⍬),((2≠/(~⊃),⊢)fss)fsx⊢)Es)⍪⍨(~Em)(⌿∘⊢)⊢)¨scp)
⍝   Compress Scalar Expressions
vc←(⊃⍪/)(((1↓⊢)⍪⍨(1 6↑⊢),(≢∘∪∘n Es),1 ¯3↑⊢)¨scp)

⍝   Type Dispatch/Specialization
tdn     ←'ii' 'if' 'ib' 'in' 'fi' 'ff' 'fb' 'fn' 'bi' 'bf' 'bb' 'bn'
tdi     ←6 7 8 9 11 12 13 14 16 17 18 19
tde     ←((¯3↓⊢),(Om⌷y,⍨∘⊂(tdi⌷⍨⊣)⌷∘⍉∘⊃y),¯2↑⊢)⍤1
tdf     ←(1↓⊢)⍪⍨(,1 3↑⊢),(⊂(⊃n),tdn⊃⍨⊣),(4↓∘,1↑⊢)
td      ←((⊃⍪/)(1↑⊢),∘(⊃,/)(((⍳12)(⊣tdf tde)¨⊂)¨1↓⊢))scp

⍝   Convert Error Functions
eff     ←(⊃⍪/)⊢(((⊂∘⍉∘⍪d,'Fe',3↓,)1↑⊣),1↓⊢)(d=∘⊃d)⊂[0]⊢
ef      ←(Fm∧¯1=∘×∘⊃¨y)((⊃⍪/)(⊂⊢(⌿⍨)∘~(∨\⊣)),(eff¨⊂[0]))⊢

⍝   Create Initializer for Globals
ifn     ←1 'F' 0 'Init' ⍬ 0,(4⍴0) ⍬ ⍬,⍨⊢
if      ←(1↑⊢)⍪(⊢(⌿⍨)Om∧1=d)⍪((up⍪⍨∘ifn∘≢∘∪n)⊢(⌿⍨)Em∧1=d)⍪(∨\Fm)(⌿∘⊢)⊢

⍝   Flatten Functions
fft     ←(,1↑⊢)(1 'Z',(2↓¯5↓⊣),(v⊣),n,y,(⊂2↑∘,∘⊃∘⊃e),l)(¯1↑⊢)
ff      ←((⊃⍪/)(1↑⊢),(((1↑⊢)⍪(((¯1+d),1↓⍤1⊢)1↓⊢)⍪fft)¨1↓⊢))scp

⍝   Flatten Scalar Groups
fzh     ←((∪n)∩(⊃∘l⊣))(¯1⌽(⊂⊣),((≢⊢)-1+(⌽n)⍳⊣)((⊂⊣⊃¨∘⊂(⊃¨e)),(⊂⊣⊃¨∘⊂(⊃¨y)),∘⊂⊣)⊢)⊢
fzf     ←0≠(≢∘⍴¨∘⊃∘v⊣)
fzb     ←(((⊃∘v⊣)(⌿⍨)fzf),n),∘⍪('f'∘,∘⍕¨∘⍳(+/fzf)),('s'∘,∘⍕¨∘⍳∘≢⊢)
fzv     ←((⊂⊣)(⊖↑)⍨¨(≢⊣)(-+∘⍳⊢)(≢⊢))((⊢,⍨1⌷∘⍉⊣)⌷⍨(0⌷∘⍉⊣)⍳⊢)⍤2 0¨v
fze     ←(¯1+d),t,k,fzb((⊢/(-∘≢⊢)↑⊣),r,s,fzv,y,e,∘⍪l)⊢
fzs     ←(,1↑⊢)(1⊖(⊣((1 'Y',(2⌷⊣),⊢)⍪∘⍉∘⍪(3↑⊣),⊢)1⌽fzh,¯1↓6↓⊣)⍪fze)(⌿∘⊢)
fz      ←((⊃⍪/)(1↑⊢),(((2=d)(fzs⍪(1↓∘~⊣)(⌿∘⊢)1↓⊢)⊢)¨1↓⊢))(1,1↓Sm)⊂[0]⊢

⍝   Create Function Declarations
fd←(1↑⊢)⍪((1,'Fd',3↓⊢)⍤1 Fs)⍪1↓⊢

⍝  Code Generator
dis     ←{⍺←⊢ ⋄ 0=⊃t⍵:5⍴⍬ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}
gc      ←{((⊃,/)⊢((fdb⍪⍨∘(dis⍤1)(⌿⍨))(⊂dis)⍤2 1(⌿⍨∘~))(Om∧1 2 'i'∊⍨k))⍵}
E1←{⍺('mf'gcl)⍵}
E2      ←{r l f←⊃v⍵ ⋄ (¯1↓⊃y⍵)(f fcl ⍺)((⊃n⍵)r l),⍪¯1↓⊃e⍵}
E0      ←{r l f←⊃v⍵ ⋄ (n⍵)((⊃y⍵)sget)(¯1↓⊃y⍵)(f scal sdb)r l}
Oi      ←{(⊃n⍵)('Fexim()i',nl)('catdo')'' ''}
O1      ←{(n⍵),odb(o ocl(⊃y⍵))⊂f⊣f u o←⊃v⍵}
O2      ←{(n⍵),odb(o ocl(⊃y⍵))2↑⊣r l o←⊃v⍵}
O0      ←{'' '' '' '' ''}
Of      ←{(fndy ⍵),nl,nl,(⊃,/(⍳12)fncd¨⊂⍵),nl}
Fd      ←{frt,(⊃n⍵),flp,';',nl}
Fe      ←{frt,(⊃n⍵),flp,'{',nl,'error(',(⍕|⊃⊃y⍵),');',nl}
F0      ←{frt,(⊃n⍵),flp,'{',nl,'A*env[]={tenv};',nl,('tenv'reg ⍵),nl}
F1      ←{frt,(⊃n⍵),flp,'{',nl,('env0'dnv ⍵),(fnv ⍵),('env0'reg ⍵),nl,''⊣fnacc⍵}
Z0      ←{'}',nl,nl}
zap     ←{'memcpy(z,',((⊃n⍵)var ⊃e⍵),',sizeof(A));'}
Z1      ←{'cpaa(z,',((⊃n⍵)var⊃e⍵),');',nl,'fe(&env0[1],',(⍕¯1+⊃s⍵),');}',nl,nl}
Ze      ←{'}',nl,nl}
M0      ←{rth,('tenv'dnv ⍵),nl,'A*env[]={',((0≡⊃⍵)⊃'tenv' 'NULL'),'};',nl}
S0      ←{(('{',rk0,srk,'DO(i,prk)cnt*=sp[i];',spp,sfv,slp)⍵)}
Y0      ←{⊃,/((⍳≢⊃n⍵)((⊣sts¨(⊃l),¨∘⊃s),'}',nl,⊣ste¨(⊃n)var¨∘⊃r)⍵),'}',nl}

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Runtime Code

⍝  Runtime Utilities
nl   ←⎕UCS 13 10
fvs  ←,⍤0(⌿⍨)0≠(≢∘⍴¨⊣)
cln  ←'¯'⎕R'-'
var  ←{⍺≡,'⍺':,'l' ⋄ ⍺≡,'⍵':,'r' ⋄ ¯1≥⊃⍵:,⍺ ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
dnv  ←{(0≡z)⊃('A ',⍺,'[',(⍕z←⊃v⍵),'];')('A*',⍺,'=NULL;')}
reg  ←{'DO(i,',(⍕⊃v⍵),')',⍺,'[i].v=NULL;'}
fnv  ←{'A*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
git  ←{⍵⊃¨⊂'/* XXX */ aplint32 ' 'aplint32 ' 'double ' 'U8 ' '?type? '}
gie  ←{⍵⊃¨⊂'/* XXX */ APLLONG' 'APLLONG' 'APLDOUB' 'APLBOOL' 'APLNA'}
pacc←{('pg'≡2↑COMPILER)⊃''('#pragma acc ',⍵,nl)}
aclp←{('pg'≡2↑COMPILER)⊃''('#pragma acc loop independent ',⍵,nl)}
ackn←{('pg'≡2↑COMPILER)⊃''('#pragma acc kernels ',⍵,nl)}
acup←{('pg'≡2↑COMPILER)⊃''('#pragma acc update ',⍵,nl)}
acdt←{('pg'≡2↑COMPILER)⊃''('#pragma acc data ',⍵,nl)}
simdc←{('#pragma acc kernels loop ',⍵,nl)('')('')}
simd ←{('pg' 'ic'⍳⊂2↑COMPILER)⊃simdc ⍵}

⍝[of]:Function Entry
frt     ←'static void '
fre     ←'void EXPORT '
foi     ←'if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}',nl
flp     ←'(A*z,A*l,A*r,A*penv[])'
elp     ←'(LOCALP*z,LOCALP*l,LOCALP*r)'
tps     ←'A cl,cr;cl.v=NULL;cr.v=NULL;cpda(&cr,r);if(l!=NULL)cpda(&cl,l);',nl
tps     ,←'int tp=0;switch(r->p->ELTYPE){',nl
tps     ,←'case APLINTG:case APLSINT:case APLLONG:break;',nl
tps     ,←'case APLDOUB:tp=4;break;case APLBOOL:tp=8;break;',nl
tps     ,←'default:error(16);}',nl
tps     ,←'if(l==NULL)tp+=3;else switch(l->p->ELTYPE){',nl
tps     ,←'case APLINTG:case APLSINT:case APLLONG:break;',nl
tps     ,←'case APLDOUB:tp+=1;break;case APLBOOL:tp+=2;break;',nl
tps     ,←'default:error(16);}',nl
tps     ,←'A za;za.v=NULL;',nl,'switch(tp){',nl
fcln    ←'frea(&cl);',nl,'frea(&cr);',nl,'frea(&za);',nl
dcl     ←{(0>e)⊃((⊃⊃v⍵),(⍺⊃tdn),'(',⍺⍺,',env);')('error(',(cln⍕|e←⊃(⍺⌷tdi)⌷⍉⊃y⍵),');')}
dcp     ←{(0>e)⊃('cpad(z,&za,',(⊃gie 0⌈e←⊃(⍺⌷tdi)⌷⍉⊃y ⍵),');')''}
case    ←{'case ',(⍕⍺),':',(⍺('&za,&cl,&cr'dcl)⍵),(⍺ dcp ⍵),'break;',nl}
fnacc   ←{(pacc 'data copyin(env0[:',(⍕⊃v⍵),'])'),'{'}
fndy    ←{fre,(⊃n⍵),elp,'{',nl,foi,tps,(⊃,/(⍳12)case¨⊂⍵),'}',nl,fcln,'}'}
fncd    ←{fre,(⊃n⍵),(⍺⊃tdn),'(A*z,A*l,A*r){',(⍺('z,l,r'dcl)⍵),'}',nl}

⍝  Symbol → Name Table
syms ←,¨'+'   '-'   '×'   '÷'   '*'   '⍟'   '|'   '○'   '⌊'   '⌈'   '!'   '<'
nams ←  'add' 'sub' 'mul' 'div' 'exp' 'log' 'res' 'cir' 'min' 'max' 'fac' 'lth'
syms,←,¨'≤'   '='   '≥'   '>'   '≠'   '~'   '∧'   '∨'   '⍲'   '⍱'   '⌷'   '['
nams,←  'lte' 'eql' 'gte' 'gth' 'neq' 'not' 'and' 'lor' 'nan' 'nor' 'sqd' 'brk'
syms,←,¨'⍳'   '⍴'   ','   '⍪'   '⌽'   '⍉'   '⊖'   '∊'   '⊃'   '≡'   '≢'   '⊢'
nams,←  'iot' 'rho' 'cat' 'ctf' 'rot' 'trn' 'rtf' 'mem' 'dis' 'eqv' 'nqv' 'rgt'
syms,←,¨'⊣'   '⊤'   '⊥'   '/'   '⌿'   '\'   '⍀'   '?'   '↑'   '↓'   '¨'   '⍨'
nams,←  'lft' 'enc' 'dec' 'red' 'rdf' 'scn' 'scf' 'rol' 'tke' 'drp' 'map' 'com'
syms,←,¨'.'   '⍤'   '⍣'   '∘'
nams,←  'dot' 'rnk' 'pow' 'jot'

⍝  Generator Dispatch
gnmtp←'xifbn'⊃¨∘⊂⍨2↑1↓∘⊃y
gnmid←(nams,⊂'')⊃⍨syms⍳¯1↑∘⊃v
gnmsla←'las'⊃¨∘⊂⍨(∧/¯1=∘↑3↑∘⊃e)+0≠((⊃0⍴⊃)¨n,2↑∘⊃v)
gluecl←{n←0 '_' 0 (⊃⍵) ⍬ 0 ((1↓0⌷⍉⍵),⊂,⍵⍵)(⍺,0)((1⌷⍉⍵),⊂¯1 0) 0
  (0 5⍴⊂'')(⍺⍺ gcl)n}
gcl←{''≢id←gnmid ⍵:(⍎id,⍺⍺,(gnmtp ⍵),gnmsla ⍵)((⊂n,∘⊃v),e,y)⍵
  r u f←⊃v⍵ ⋄ (2↑⊃y⍵)(f fcl ⍺)(⊃n⍵)r,⍪2↑⊃e⍵
  ⎕SIGNAL 16}

⍝  Scalar Primitives
⍝⍝residue←'⍵ % ⍺'
respos ←'fmod((D)⍵,(D)⍺)'
resneg ←'⍵-⍺*floor(((D)⍵)/(D)(⍺+(0==⍺)))'
residue←'(0==⍺)?⍵:((0<=⍺&&0<=⍵)?',respos,':',resneg,')'

⍝   Scalar Dispatch Table
sdb←0 5⍴⊂''
⍝⍝     Prim Monadic            Dyadic                Monadic Bool     Dyadic Bool
sdb⍪←,¨'+'  '⍵'           '⍺+⍵'                 '⍵'         '⍺+⍵'
sdb⍪←,¨'-'  '-1*⍵'        '⍺-⍵'                 '-1*⍵'      '⍺-⍵'
sdb⍪←,¨'×'  '(⍵>0)-(⍵<0)' '⍺*⍵'                 '⍵'         '⍺&⍵'
sdb⍪←,¨'÷'  '1.0/⍵'       '((D)⍺)/((D)⍵)'       '⍵'         '⍺&⍵'
sdb⍪←,¨'*'  'exp((D)⍵)'   'pow((D)⍺,(D)⍵)'      'exp((D)⍵)' '⍺|~⍵'
sdb⍪←,¨'⍟'  'log((D)⍵)'   'log((D)⍵)/log((D)⍺)' ''          ''
sdb⍪←,¨'|'  'fabs(⍵)'     residue               '⍵'         '⍵&(⍺^⍵)'
sdb⍪←,¨'○'  'PI*⍵'        'circ(⍺,⍵)'           'PI*⍵'      'circ(⍺,⍵)'
sdb⍪←,¨'⌊'  'floor((D)⍵)' '⍺ < ⍵ ? ⍺ : ⍵'       '⍵'         '⍺&⍵'
sdb⍪←,¨'⌈'  'ceil((D)⍵)'  '⍺ > ⍵ ? ⍺ : ⍵'       '⍵'         '⍺|⍵'
sdb⍪←,¨'!'  'fact(⍵)'     'binomial(⍺,⍵)'       '255'       '(~⍺)|⍵'
sdb⍪←,¨'<'  'error(99)'   '⍺<⍵'                 'error(99)' '(~⍺)&⍵'
sdb⍪←,¨'≤'  'error(99)'   '⍺<=⍵'                'error(99)' '(~⍺)|⍵'
sdb⍪←,¨'='  'error(99)'   '⍺==⍵'                'error(99)' '(⍺&⍵)|((~⍺)&(~⍵))'
sdb⍪←,¨'≥'  'error(99)'   '⍺>=⍵'                'error(99)' '⍺|(~⍵)'
sdb⍪←,¨'>'  'error(99)'   '⍺>⍵'                 'error(99)' '⍺&(~⍵)'
sdb⍪←,¨'≠'  'error(99)'   '⍺!=⍵'                'error(99)' '⍺^⍵'
sdb⍪←,¨'~'  '0==⍵'        'error(16)'           '~⍵'        'error(16)'
sdb⍪←,¨'∧'  'error(99)'   'lcm(⍺,⍵)'            'error(99)' '⍺&⍵'
sdb⍪←,¨'∨'  'error(99)'   'gcd(⍺,⍵)'            'error(99)' '⍺|⍵'
sdb⍪←,¨'⍲'  'error(99)'   '!(⍺ && ⍵)'           'error(99)' '~(⍺&⍵)'
sdb⍪←,¨'⍱'  'error(99)'   '!(⍺ || ⍵)'           'error(99)' '~(⍺|⍵)'
sdb⍪←,¨'⌷'  '⍵'           'error(99)'           '⍵'         'error(99)'
sdb⍪←'⎕XOR' 'error(99)'   '⍺^⍵'                 'error(99)' '⍺ ^ ⍵'

⍝   Scalar Loop Generators
simp←{' present(',(⊃{⍺,',',⍵}/'d',∘⍕¨⍳≢var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵),')'}
sima←{{' copyin(',(⊃{⍺,',',⍵}/⍵),')'}⍣(0<a)⊢'d',∘⍕¨(+/~m)+⍳a←≢⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
simr←{' present(',(⊃{⍺,',',⍵}/'r',∘⍕¨⍳≢⊃n⍵),')'}
simc←{fv←(⊃v⍵)fvs(⊃e⍵) ⋄ ' independent ',(simp fv),(sima fv),simr ⍵}
slpd←'I n=ceil(cnt/8.0);',nl
slp←{slpd,(simd simc ⍵),'DO(i,n){',nl,⊃,/(1⌷⍉(⊃v⍵)fvs(⊃y⍵))sip¨⍳≢(⊃v⍵)fvs(⊃e⍵)}
rk0←'I prk=0;B sp[15];B cnt=1;',nl
rk1←'if(prk!=(' ⋄ rk2←')->r){if(prk==0){',nl
rsp←{'prk=(',⍵,')->r;',nl,'DO(i,prk) sp[i]=(',⍵,')->s[i];'}
rk3←'}else if((' ⋄ rk4←')->r!=0)error(4);',nl
spt←{'if(sp[i]!=(',⍵,')->s[i])error(4);'}
rkv←{rk1,⍵,rk2,(rsp ⍵),rk3,⍵,rk4,'}else{',nl,'DO(i,prk){',(spt ⍵),'}}',nl}
rk5←'if(prk!=1){if(prk==0){prk=1;sp[0]='
rka←{rk5,l,';}else error(4);}else if(sp[0]!=',(l←⍕≢⍵),')error(4);',nl}
crk←{⍵((⊃,/)((rkv¨var/)⊣(⌿⍨)(~⊢)),(rka¨0⌷∘⍉(⌿⍨)))0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵}
srk←{crk(⊃v⍵)(,⍤0(⌿⍨)0≠(≢∘⍴¨⊣))(⊃e⍵)}
ste←{'cpaa(',⍵,',&p',(⍕⍺),');',nl}
stsn←{⊃,/((⍳8){'r',(⍕⍵),'[i*8+',(⍕⍺),']='}¨⍺),¨(⍳8){'s',(⍕⍵),'_',(⍕⍺),';',nl}¨⍵}
sts←{i t←⍵ ⋄ 3≡t:'r',(⍕⍺),'[i]=s',(⍕i),';',nl ⋄ ⍺ stsn i}
rkp←{'I m',(⍕⊃⌽⍺),'=(',(⍕⍵),')->r!=0;',nl}
gdp←{(⊃git ⊃⍺),'*restrict d',(⍕⊃⌽⍺),'=(',⍵,')->v;',nl}
gda←{'d',(⍕⍺),'[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl,'B m',(⍕⍺),'=1;',nl}
sfa←{(git m/⍺),¨{((+/~m)+⍳≢⍵)gda¨⍵}⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfp←{(m⌿⍺){(⍺,¨⍳≢⍵)(gdp,rkp)¨⍵}var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfv←(1⌷∘⍉(⊃v)fvs(⊃y))((⊃,/)sfp,sfa)(⊃v)fvs(⊃e)
ack←{'ai(&p',(⍕⍺),',prk,sp,',(⍕⍺⌷⍺⍺),');',nl}
gpp←{⊃,/{'A p',(⍕⍵),';p',(⍕⍵),'.v=NULL;',nl}¨⍳≢⍵}
grs←{(⊃git ⍺),'*restrict r',(⍕⍵),'=p',(⍕⍵),'.v;',nl}
spp←(⊃s){(gpp⍵),(⊃,/(⍳≢⍵)(⍺ ack)¨⍵),(⊃,/⍺ grs¨⍳≢⍵)}(⊃n)var¨(⊃r)
sip←{w←⍕⍵ ⋄ 3≡⍺:(⊃git ⍺),'f',w,'=d',w,'[i*m',w,'];',nl
  ⊃,/(⍕¨⍳8)((⊃git ⍺){⍺⍺,'f',⍵,'_',⍺,'=d',⍵,'[(i*8+',⍺,')*m',⍵,'];',nl})¨⊂w}

⍝   Scalar Expression Generators
sfnl    ←{⊃⍺⍺⌷⍨((⊂⍺)⍳⍨0⌷⍉⍺⍺),(2×∧/∨⌿3 4∘.=⍵)+4+.≠⍵}
scln    ←(,¨'%&')⎕R'\\\%' '\\\&'
sstm    ←{cln (,¨'⍵⍺')⎕R(scln∘⍕∘⊃¨⍺ ⍵)⊢⍺⍺(⍵⍵ sfnl)⊃∘⌽¨⍺ ⍵}
sidx←{        0=⊃⊃0⍴⊂⍵:     8⍴⊂⍵ (⍺⊃⍺⍺)
        ∧/⊃3 4∨.=⊂⍺⍺:       ⊂⍵ (⍺⊃⍺⍺)
        3=⍺⊃⍺⍺: ↓(⍺⊃⍺⍺),⍨⍪(⌽⍳8){'(1&(',⍵,'>>',(⍕⍺),'))'}¨⊂⍵
                ↓(⍺⊃⍺⍺),⍨⍪(⍳8){⍵,'_',⍕⍺}¨⊂⍵}
scal    ←{⊃⍺⍺ sstm ⍵⍵¨/1 2(⍺ sidx)¨⍵}
sgtbn   ←{⍺⍺,'|=((U8)(',⍵,'))<<',(⍕7-⍺),';',nl}
sgtnn   ←{⍺⍺,'_',(⍕⍺),'=',⍵,';',nl}
sgtbb   ←{⍺,'=',⍵,';',nl}
sget←{        nm      ←(⊃git⊃⍺⍺),⊃⍺
        ∧/⊃3 4∨.=⊂3↑⍺⍺:   ⊃,/nm∘sgtbb¨⍵
        3=⊃⍺⍺:    nm,'=0;',nl,⊃,/(⍳8)((⊃⍺)sgtbn)¨⍵
                ⊃,/(⍳8)(nm sgtnn)¨⍵}
scl←{cln ((≢⍵)↑,¨'⍵⍺')⎕R(scln∘⍕¨⍵) ⊃⍺⌷⍨((⊂⍺⍺)⍳⍨0⌷⍉⍺),≢⍵}

⍝   Scalar/Mixed Conversion
mxsm←{siz←'zr=rr;DO(i,zr){zc*=rs[i];zs[i]=rs[i];}'
  exe←(simd''),'DO(i,zc){zv[i]=',(,'⍵')⎕R'rv[i]'⊢⍺⍺,';}'
    '' siz exe mxfn 1 ⍺ ⍵}
mxsd←{chk←'if(lr==rr){DO(i,lr){if(rs[i]!=ls[i])error(5);}}',nl
  chk,←'else if(lr!=0&&rr!=0){error(4);}'
  siz←'if(rr==0){zr=lr;DO(i,lr){zc*=ls[i];lc*=ls[i];zs[i]=ls[i];}}',nl
  siz,←'else{zr=rr;DO(i,rr){zc*=rs[i];rc*=rs[i];zs[i]=rs[i];}DO(i,lr)lc*=ls[i];}',nl
  exe←simd 'pcopyin(lv[:lc],rv[:rc])'
  exe,←'DO(i,zc){zv[i]=',(,¨'⍺⍵')⎕R'lv[i\%lc]' 'rv[i\%rc]'⊢⍺⍺,';}'
    chk siz exe mxfn 1 ⍺ ⍵}
scmx←{(⊂⍺⍺)∊0⌷⍉sdb:(⊃⍵),'=',';',⍨sdb(⍺⍺ scl)1↓⍵ ⋄ ⍺(⍺⍺ fcl ⍵⍵)⍵,⍤0⊢⊂2⍴¯1}

⍝    Mixed Verb Database for Scalar Primitives
sdbm←(0⌷⍉sdb),'mxsm' 'mxsd' 'mxbm' 'mxbd' {'(''',⍵,'''',⍺,')'}¨⍤1⊢⍉1↓⍉sdb

⍝  Primitive Operators
ocl     ←{⍵∘(⍵⍵{'(',(opl ⍺),(opt ⍺⍺),⍵,' ⍵⍵)'})¨1↓⍺⌷⍨(0⌷⍉⍺)⍳⊂⍺⍺}
opl     ←{⊃,/{'(,''',⍵,''')'}¨⍵}
opt     ←{'(',(⍕⍴⍵),'⍴',(⍕,⍵),')'}
odb     ←0 5⍴⊂''
⍝[c]
⍝[c]Prim      Monadic Dyadic  Monadic Bool    Dyadic Bool
odb⍪←,¨'⍨'       'comm'  'comd'  ''      ''
odb⍪←,¨'¨'        'eacm'  'eacd'  ''      ''
odb⍪←,¨'/' 'redm'  'redd'  ''      ''
odb⍪←,¨'⌿'       'rd1m'  'rd1d'  ''      ''
odb⍪←,¨'\' 'scnm'  'err16' ''      ''
odb⍪←,¨'⍀'       'sc1m'  'err16' ''      ''
odb⍪←,¨'.' 'err99' 'inpd'  ''      ''
odb⍪←'∘.' 'err99' 'oupd'  ''      ''

err99←{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 99}
err16←{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 16}

⍝   Commute
comd←{((1↑⍺)⍪⊖1↓⍺)((⊃⍺⍺)fcl(⍵⍵⍪sdbm))(1↑⍵)⍪⊖1↓⍵}
comm←{((1↑⍺)⍪⍪⍨1↓⍺)((⊃⍺⍺)fcl(⍵⍵⍪sdbm))(1↑⍵)⍪⍪⍨1↓⍵}

⍝   Each
eacm←{        siz     ←'zr=rr;DO(i,zr){zc*=rs[i];zs[i]=rs[i];}'
        exe     ←pacc'update host(rv[:rgt->c])'
        exe     ,←'DO(i,zc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i]' 'rv[i]'),'}',nl
        exe     ,←pacc'update device(zv[:rslt->c])'
                '' siz exe mxfn 1 ⍺ ⍵}
eacd←{        chk     ←'if(lr==rr){DO(i,lr){if(rs[i]!=ls[i])error(5);}}',nl
        chk     ,←'else if(lr!=0&&rr!=0){error(4);}'
        siz     ←'if(rr==0){zr=lr;DO(i,lr){zc*=ls[i];lc*=ls[i];zs[i]=ls[i];}}',nl
        siz     ,←'else{zr=rr;DO(i,rr){zc*=rs[i];rc*=rs[i];zs[i]=rs[i];}DO(i,lr)lc*=ls[i];}'
        exe     ←pacc'update host(lv[:lft->c],rv[:rgt->c])'
        exe     ,←'DO(i,zc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i]' 'rv[i]' 'lv[i]'),'}',nl
        exe     ,←pacc'update device(zv[:rslt->c])'
                chk siz exe mxfn 1 ⍺ ⍵}

⍝   Reduce
redm←{        idf     ←(,¨'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'),⊂'⎕XOR'
        idv     ←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 0 ''
        hid     ←idf∊⍨0⌷⍺⍺
        gpf     ←(,¨'+×∧∨'),⊂'⎕XOR'
        gpv     ←⍕¨0 1 1 0 0 ''
        gid     ←gpf∊⍨0⌷⍺⍺
        chk     ←hid⊃('if(rr>0&&rs[rr-1]==0)error(11);')''
        siz     ←'if(rr==0){zr=0;}',nl
        siz     ,←'else{zr=rr-1;DO(i,zr){zc*=rs[i];zs[i]=rs[i];};rc=rs[zr];}'
        exe     ←'I zn=',((3=⊃0⌷⍺)⊃'zc' 'ceil(zc/8.0)'),';'
        exe     ,←'I rn=',((3=⊃1⌷⍺)⊃'rc' 'ceil(rc/8.0)'),';',nl
        exe     ,←'if(rc==0){'
        exe1a   ←'error(11);',nl
        exe1b   ←nl,simd'present(zv[:zc])'
        exe1b   ,←'DO(i,zc){zv[i]=',(idv⊃⍨idf⍳0⌷⍺⍺),';}',nl
        exe1c   ←nl,simd'present(zv[:zn])'
        exe1c   ,←'DO(i,zn){zv[i]=',('0' '-1' ''⊃⍨(,¨'01')⍳idv⌷⍨idf⍳0⌷⍺⍺),';}',nl
        exe     ,←(2⊥hid(3=⊃0⌷⍺))⊃exe1a exe1a exe1b exe1c
        exe     ,←'}else if(rc==1){'
        exe     ,←nl,simd'present(zv[:zn],rv[:zn])'
        exe     ,←'DO(i,zn){zv[i]=rv[i];}',nl
        exe     ,←'}else if(zc==1){'
        exe3a   ←nl,pacc gid⊃'update host(rv[:rc])' 'update host(rv[rc-1:1])'
        exe3a   ,←(⊃git⊃⍺),'val=rv[rc-1];I n=rc-1;',nl
        exe3a   ,←pacc gid⊃'enter data copyin(val)' 'kernels loop present(rv[:rc])'
        exe3a   ,←'DO(i,n){',nl
        exe3a   ,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[rc-(2+i)]'
        exe3a   ,←gid⊃(nl,pacc'update device(val)')''
        exe3a   ,←'}',nl,gid⊃(pacc'exit data delete(val)')''
        exe3a   ,←'zv[0]=val;',nl,pacc'update device(zv[:1])'
        exe3b   ←nl,pacc gid⊃'update host(rv[:rn])' 'update host(rv[rn-1:1])'
        exe3b   ,←(⊃git⊃⍺),'val=1&(rv[rn-1]>>(7-((rc-1)%8)));I n=rc-1;',nl
        exe3b   ,←pacc gid⊃'enter data copyin(val)' 'kernels loop present(rv[:rn])'
        exe3b   ,←'DO(i,n){I ri=rc-(2+i);I cr=1&(rv[ri/8]>>(7-(ri%8)));',nl
        exe3b   ,←gid⊃(pacc'data copyin(cr)')''
        exe3b   ,←((2⍴⊃⍺),1,2↓⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'cr'
        exe3b   ,←gid⊃(nl,pacc'update device(val)')''
        exe3b   ,←'}',nl,gid⊃(pacc'exit data delete(val)')''
        exe3b   ,←'zv[0]=',('val;' 'val<<7;'⊃⍨3=⊃0⌷⍺),nl
        exe3b   ,←pacc'update device(zv[:1])'
        exe     ,←(2⊥(3=2↑⍺))⊃exe3a exe3b exe3a exe3b
        exe     ,←'}else if(0==zc*rc){',nl
        exe     ,←'}else{'
        exe4lp  ←'kernels loop gang worker(32) present(zv[:zn],rv[:rn])'
        exe4a   ←nl,pacc gid⊃'update host(rv[:rc])' exe4lp
        exe4a   ,←'DO(i,zc){',(⊃git⊃⍺),'val=rv[(i*rc)+rc-1];L n=rc-1;',nl
        exe4a   ,←pacc gid⊃'enter data copyin(val)' 'loop vector(32)'
        exe4a   ,←'DO(j,n){',nl
        exe4a   ,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[(i*rc)+(rc-(2+j))]'
        exe4a   ,←gid⊃(nl,pacc'update device(val)')''
        exe4a   ,←'}',nl,gid⊃(pacc'exit data delete(val)')''
        exe4a   ,←'zv[i]=val;}',nl, gid⊃(pacc'update device(zv[:zc])')''
        exe4b   ←nl,(simd'present(zv[:zn])'),'DO(i,zn){zv[i]=0;};I n=rc-1;',nl
        exe4b   ,←pacc gid⊃'update host(rv[:rn])' exe4lp
        exe4b   ,←'DO(i,zc){I si=(i*rc)+rc-1;',nl
        exe4b   ,←(⊃git⊃⍺),'val=1&(rv[si/8]>>(7-(si%8)));',nl
        exe4b   ,←pacc gid⊃'enter data copyin(val)' 'loop vector(32)'
        exe4b   ,←'DO(j,n){I ri=(i*rc)+(rc-(2+j));I cr=1&(rv[ri/8]>>(7-(ri%8)));',nl
        exe4b   ,←((2⍴⊃⍺),1,2↓⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'cr'
        exe4b   ,←gid⊃(nl,pacc'update device(val)')''
        exe4b   ,←'}',nl,gid⊃(pacc'exit data delete(val)')''
        exe4b   ,←(3=⊃0⌷⍺)⊃'zv[i]=val;' 'zv[i/8]|=val<<(7-(i%8));'
        exe4b   ,←'}',nl,gid⊃(pacc'update device(zv[:zn])')''
        exe     ,←(2⊥(3=2↑⍺))⊃exe4a exe4b exe4a exe4b
        exe     ,←'}'
                chk siz exe mxfn 1 ⍺ ⍵}

⍝   Reduce N-wise
redd←{        idf     ←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
        hid     ←idf∊⍨⊃⊃⍺⍺ ⋄ a←0 1 1⊃¨⊂⍺
        idv     ←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
        chk     ←'if(lr!=0&&(lr!=1||ls[0]!=1))error(5);',nl
        chk     ,←'if(rr==0)error(4);',nl,hid⊃('if(lv[0]==0)error(11);',nl)''
        chk     ,←'if((rs[rr-1]+1)<lv[0])error(5);rc=(1+rs[rr-1])-lv[0];'
        siz     ←'zr=rr;I n=zr-1;DO(i,n){zc*=rs[i];zs[i]=rs[i];};zs[zr-1]=rc;lc=rs[rr-1];'
        exe     ←pacc'update host(rv[:rgt->c],lv[:lft->c])'
        exe     ,←'DO(i,zc){DO(j,rc){zv[(i*rc)+j]='
        exe     ,←hid⊃'rv[(i*lc)+j+lv[0]-1];'(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺)
        val     ←'zv[(i*rc)+j]' 'zv[(i*rc)+j]'('rv[(i*lc)+j+(lv[0]-(k+',(hid⌷'21'),'))]')
        exe     ,←nl,' L n=lv[0]',(hid⊃'-1' ''),';DO(k,n){'
        exe     ,←hid⊃(nl,pacc'update device(zv[(i*rc)+j:1])')''
        exe     ,←(a((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
        exe     ,←pacc'update device(zv[:rslt->c])'
                chk siz exe mxfn 1 ⍺ ⍵}

⍝   Reduce First Axis
rd1m←{        idf     ←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
        hid     ←idf∊⍨⊃⊃⍺⍺
        idv     ←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
        chk     ←hid⊃('if(rr>0&&rs[0]==0)error(11);')''
        siz     ←'if(rr==0){zr=0;}',nl
        siz     ,←'else{zr=rr-1;DO(i,zr){zc*=rs[i+1];zs[i]=rs[i+1];};rc=rs[0];}'
        exe     ←pacc 'update host(rv[:rgt->c])'
        exe     ,←'if(rc==1){DO(i,zc)zv[i]=rv[i];}',nl,'else '
        exe     ,←hid⊃''('if(rc==0){DO(i,zc)zv[i]=',(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺),'}',nl,'else ')
        exe     ,←'{DO(i,zc){zv[i]=rv[((rc-1)*zc)+i];',nl,' L n=rc-1;DO(j,n){'
        exe     ,←((⊂⊃⍺⍺)∊0⌷⍉sdb)⊃(nl,pacc'update device(zv[i:1])')''
        exe     ,←(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'zv[i]' 'zv[i]' 'rv[(zc*(rc-(j+2)))+i]'),'}}}',nl
        exe     ,←pacc 'update device(zv[:rslt->c])'
                chk siz exe mxfn 1 ⍺ ⍵}
rd1d←{        idf     ←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
        hid     ←idf∊⍨⊃⊃⍺⍺
        a       ←0 1 1⊃¨⊂⍺
        idv     ←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
        chk     ←'if(lr!=0&&(lr!=1||ls[0]!=1))error(5);',nl
        chk     ,←'if(rr==0)error(4);',nl,hid⊃('if(lv[0]==0)error(11);',nl)''
        chk     ,←'if((rs[0]+1)<lv[0])error(5);rc=(1+rs[0])-lv[0];'
        siz     ←'zr=rr;I n=zr-1;DO(i,n){zc*=rs[i+1];zs[i+1]=rs[i+1];};zs[0]=rc;'
        exe     ←pacc'update host(rv[:rgt->c],lv[:lft->c])'
        exe     ,←'DO(i,zc){DO(j,rc){zv[(j*zc)+i]='
        exe     ,←hid⊃'rv[((j+lv[0]-1)*zc)+i];'(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺)
        val     ←'zv[(j*zc)+i]' 'zv[(j*zc)+i]'('rv[((j+(lv[0]-(k+',(hid⌷'21'),')))*zc)+i]')
        exe     ,←nl,' L n=lv[0]',(hid⊃'-1' ''),';DO(k,n){'
        exe     ,←hid⊃(nl,pacc'update device(zv[(j*zc)+i:1])')''
        exe     ,←(a((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
        exe     ,←pacc'update device(zv[:rslt->c])'
                chk siz exe mxfn 1 ⍺ ⍵}
⍝   Scan
⍝    Vector GPU Scan
scngv←{z←'{',⍺,' b[513];I bc;B p,t,fp,ft,fpt;',nl
  z,←'if(rc<=131072){bc=(rc+255)/256;p=256;t=1;fp=rc-256*(bc-1);ft=fpt=256;}',nl
  z,←'else{bc=512;p=(rc+bc-1)/bc;t=(p+255)/256;',nl
  z,←' fp=rc-p*(bc-1);ft=p-256*(t-1);fpt=fp-256*(t-1);}',nl
  z,←(ackn'present(rv[:rc],zv[:rc]) create(b[:bc+1])'),'{',⍺,' ta[256];',nl
  z,←(aclp''),'DOI(i,bc-1){',⍺,' t=',⍵,';B p128=(p+127)/128;',nl
  z,←(pacc'loop vector'),' DO(j,p){I x=i*p+j;if(x<rc){',nl
  z,←'  ',(⍺⍺,¨'t' 't' 'rv[x]'),'}}',nl,' b[i+1]=t;}',nl
  z,←'DO(i,1){b[0]=',⍵,';}',nl,'DO(i,bc){',(⍺⍺'b[i+1]' 'b[i+1]' 'b[i]'),'}',nl
  z,←(aclp'private(ta)'),'DOI(i,bc){',⍺,' s=b[i];B pid=i*p;',nl
  z,←(pacc'cache(ta[:256])'),' DOI(j,t-1){B tid=pid+j*256;',nl
  z,←(aclp''),'  DOI(k,256){ta[k]=rv[tid+k];}',nl,'  ',(⍺⍺'ta[0]' 'ta[0]' 's'),nl
  z,←(aclp''),'  DOI(k,128){I x=k*2;',(⍺⍺'ta[x+1]' 'ta[x+1]' 'ta[x]'),'}',nl
  lp←{b←(aclp'collapse(2)'),'  DOI(g,',⍺,'){DOI(k,',⍵,'){I x=2*g*',⍵,'+',⍵,';'
    b,(⍺⍺'ta[x+k]' 'ta[x+k]' 'ta[x-1]'),'}}',nl}
  z,←⍺⍺{⊃,/(⌽⍵)⍺⍺ lp¨⍵}⍕¨2*1+⍳6
  z,←(aclp''),'  DOI(k,128){',(⍺⍺'ta[k+128]' 'ta[k+128]' 'ta[127]'),'}',nl
  z,←(aclp''),'  DOI(k,256){zv[tid+k]=ta[k];}',nl,'  s=ta[255];}',nl
  z,←' B sz=ft;if(i==bc-1)sz=fpt;B tid=pid+(t-1)*256;',nl
  z,←(aclp''),' DOI(k,256){ta[k]=',⍵,';if(k<sz)ta[k]=rv[tid+k];}',nl
  z,←' ',(⍺⍺'ta[0]' 'ta[0]' 's'),nl
  z,←' for(I d=1;d<256;d*=2){',nl
  z,←(aclp'collapse(2)'),'  for(I g=d;g<256;g+=d*2){',nl
  z,←'   for(I k=0;k<d;k++){',(⍺⍺'ta[g+k]' 'ta[g+k]' 'ta[g-1]'),'}}}',nl
  z,←(aclp''),' DOI(k,sz){zv[tid+k]=ta[k];}}',nl
  z,'}}',nl}

⍝     Scan Entry Point
scnm←{siz←'zr=rr;if(rr)rc=rs[rr-1];DO(i,zr)zs[i]=rs[i];',nl
  siz,←'I n;if(zr)n=zr-1;else n=0;DO(i,n)zc*=rs[i];'
  fil←(gid←(ass←'+×⌈⌊∨∧')⍳⊃⊃⍺⍺)⊃,¨'0' '1' '-DBL_MAX' 'DBL_MAX' '0' '1' '-1'
  gpu←(⊃git⊃⍺)(((⊃⍺),⍺)∘((⊃⍺⍺)scmx⍵⍵)scngv)fil
  exe←(('pg'≡2↑COMPILER)∧gid<≢ass)⊃''('if(rr==1&&rc!=0){',gpu,'}else ')
  exe,←'if(rc!=0){',nl,acup'host(zv[:rslt->c],rv[:rgt->c])'
  exe,←' DO(i,zc){zv[i*rc]=rv[i*rc];L n=rc-1;DO(j,n){'
  exe,←((⊂⊃⍺⍺)∊0⌷⍉sdb)⊃(nl,acup'device(zv[(i*rc)+j:1])')''
  exe,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'zv[i*rc+j+1]' 'zv[i*rc+j]' 'rv[i*rc+j+1]'
  exe,←'}}',nl,(acup'device(zv[:rslt->c],rv[:rgt->c])'),'}',nl
    '' siz exe mxfn 1 ⍺ ⍵}

⍝   Scan First Axis
sc1m←{        siz     ←'zr=rr;rc=rr==0?1:rs[0];DO(i,zr)zs[i]=rs[i];',nl
        siz     ,←'I n=zr==0?0:zr-1;DO(i,n)zc*=rs[i+1];'
        exe     ←pacc'update host(zv[:rslt->c],rv[:rgt->c])'
        exe     ,←'if(rc!=0){DO(i,zc){zv[i]=rv[i];}',nl
        val     ←'zv[((j+1)*zc)+i]' 'zv[(j*zc)+i]' 'rv[((j+1)*zc)+i]'
        exe     ,←' DO(i,zc){L n=rc-1;DO(j,n){'
        exe     ,←((⊂⊃⍺⍺)∊0⌷⍉sdb)⊃(nl,pacc'update device(zv[(j*zc)+i:1])')''
        exe     ,←(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
        exe     ,←pacc'update device(zv[:rslt->c],rv[:rgt->c])'
                '' siz exe mxfn 1 ⍺ ⍵}

⍝   Outer Product
oupd←{        siz     ←'zr=lr+rr;DO(i,lr)zs[i]=ls[i];DO(i,rr)zs[i+lr]=rs[i];'
        scl     ←(⊂⊃⍺⍺)∊0⌷⍉sdb
        cpu     ←pacc'update host(lv[:lft->c],rv[:rgt->c])'
        gpu     ←simd'present(rv[:rgt->c],lv[:lft->c])'
        exe     ←'DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
        exe     ,←scl⊃cpu gpu
        exe     ,←'DO(i,lc){DO(j,rc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[(i*rc)+j]' 'rv[j]' 'lv[i]'),'}}',nl
        exe     ,←scl⊃(pacc'update device(zv[:rslt->c])')''
                '' siz exe mxfn 1 ⍺ ⍵}

⍝   Inner Product
inpd←{hid←(idf←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖')∊⍨⊃0⊃⍺⍺ ⋄ isa←'+×⌈⌊∧∨'∊⍨⊃0⊃⍺⍺
  idv←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 '-7'
  typ←2⌷(4 5⊥2↑1↓⍺)⌷⍉2⊃⍺⍺
  chk←'if(rr!=0&&lr!=0){',nl
  chk,←'if(ls[lr-1]!=rs[0])error(5);',nl
  chk,←(hid⊃('if(rs[0]==0)error(11);',nl)''),'}'
  siz←'zr=0;if(lr>0){zr=lr-1;DO(i,zr)zs[i]=ls[i];}',nl
  siz,←'if(rr>0){I n=rr-1;DO(i,n){zs[i+zr]=rs[i+1];}zr+=rr-1;}'
  exe←'I n=lr==0?0:lr-1;DO(i,n)zc*=ls[i];n=rr==0?0:rr-1;DO(i,n)rc*=rs[i+1];',nl
  exe,←'if(lr!=0)lc=ls[lr-1];else if(rr!=0)lc=rs[0];',nl
  exe,←'BOUND lz,rz;lz=lr==0?1:zc*lc;rz=rr==0?1:rc*lc;L m=zc*rc;',nl
  exe,←'if(!lc){',nl
  exe,←hid⊃''(simd'present(zv[:m])')
  exe,←nl,⍨hid⊃'error(11);'('DO(i,m){zv[i]=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';}')
  exe,←'}else if(',(⍕isa),'&&lr==0){',nl
  exe,←' if(rc==1){',nl
  exe,←'  ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
  exe,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
  exe,←'  DO(i,lc){',(⊃git typ),'tmp;',nl
  exe,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[i]' 'lv[0]'),nl
  exe,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
  exe,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
  exe,←' }else{',nl
  exe,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
  exe,←(pacc'loop independent'),'  DO(i,rc){',nl
  exe,←'   ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
  exe,←(pacc'loop'),'   DO(j,lc){',(⊃git typ),'tmp;',nl
  exe,←'    ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j*rc+i]' 'lv[0]'),nl
  exe,←'    ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
  exe,←'   zv[i]=res;}}',nl
  exe,←'}}else if(',(⍕isa),'&&rr==0){',nl
  exe,←' if(zc==1){',nl
  exe,←'  ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
  exe,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
  exe,←'  DO(i,lc){',(⊃git typ),'tmp;',nl
  exe,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[0]' 'lv[i]'),nl
  exe,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
  exe,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
  exe,←' }else{',nl
  exe,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
  exe,←(pacc'loop independent'),'  DO(i,zc){',nl
  exe,←'   ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
  exe,←(pacc'loop'),'   DO(j,lc){',(⊃git typ),'tmp;',nl
  exe,←'    ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[0]' 'lv[i*lc+j]'),nl
  exe,←'    ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
  exe,←'   zv[i]=res;}}',nl
  exe,←'}}else if(',(⍕isa),'&&rc==1&&zc==1){',nl
  exe,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
  exe,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
  exe,←' DO(i,lc){',(⊃git typ),'tmp;',nl
  exe,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[i]' 'lv[i]'),nl
  exe,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
  exe,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
  exe,←'}else if(',(⍕isa),'&&zc==1){',nl
  exe,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
  exe,←(pacc'loop independent'),'DO(i,rc){',nl
  exe,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
  exe,←(pacc'loop'),' DO(j,lc){',(⊃git typ),'tmp;',nl
  exe,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j*rc+i]' 'lv[j]'),nl
  exe,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
  exe,←' zv[i]=res;}}',nl
  exe,←'}else if(',(⍕isa),'&&rc==1){',nl
  exe,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
  exe,←(pacc'loop independent'),'DO(i,zc){',nl
  exe,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
  exe,←(pacc'loop'),' DO(j,lc){',(⊃git typ),'tmp;',nl
  exe,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j]' 'lv[i*lc+j]'),nl
  exe,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
  exe,←' zv[i]=res;}}',nl
  exe,←'}else{',nl
  exe,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
  exe,←(pacc'loop independent'),'DO(i,zc){',nl
  exe,←(pacc'loop independent'),' DO(j,rc){',(⊃git typ),'res;L n=lc-1;',nl
  exe,←'  ',(⍺((1⊃⍺⍺)scmx ⍵⍵)'res' 'rv[((lc-1)*rc)+j]' 'lv[(i*lc)+lc-1]'),nl
  exe,←(pacc'loop'),'  DO(k,n){',nl
  exe,←'   ',(⊃git typ),'tmp;L ri=((lc-(k+2))*rc)+j,li=(i*lc)+lc-(k+2);',nl
  exe,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[ri]' 'lv[li]'),nl
  exe,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'res' 'tmp'),'}',nl
  exe,←'  zv[(i*rc)+j]=res;}}',nl,'}}',nl
  chk siz exe mxfn 1 ⍺ ⍵}

⍝  Horrible Hacks
sopid←{       siz     ←'zr=(lr-1)+rr;zs[0]=ls[0];DO(i,zr-1)zs[i+1]=rs[i];'
        exe     ←'zc=zs[0];rc=rs[0];lc=ls[rr-1];',nl
        exe     ,←'B szz=rslt->c,szr=rgt->c,szl=lft->c;',nl
        exe     ,←simd'independent collapse(3) present(zv[:szz],rv[:szr],lv[:szl])'
        exe     ,←'DO(i,zc){DO(j,rc){DO(k,lc){I li=(i*lc)+k;',nl
        exe     ,←'zv[(i*rc*lc)+(j*lc)+k]=lv[li]*rv[(j*lc)+k];',nl
        exe     ,←'}}}'
                '' siz exe mxfn 1 ⍺ ⍵}

⍝   Lamination (Hack)
  catdo←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ catdr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ catdl ⍵ ⋄ ⍺ catdv ⍵}

  catdv←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'A*',⍺,'=',⍵,';'}¨var/⍵),nl
   z,←'B s[]={rgt->s[0],2};'
   z,←'A*orz;A tp;tp.v=NULL;int tpused=0;',nl
   z,←'if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'ai(rslt,2,s,',(⍕⊃0⌷⍺),');',nl
   z,←(⊃,/(git ⍺){⍺,'*restrict ',⍵,';'}¨'zrl'),nl
   z,←⊃,/'zrl'{⍺,'=',⍵,'->v;',nl}¨'rslt' 'rgt' 'lft'
   z,←(simd'present(z,l,r)'),'DO(i,s[0]){z[i*2]=l[i];z[i*2+1]=r[i];}'
   z,←'if(tpused){cpaa(orz,rslt);}',nl
   z,'}',nl}

⍝  Runtime Header

⍝   Includes
rth←'#include <math.h>',nl,'#include <stdio.h>',nl,'#include <string.h>',nl
rth,←'#include <stdlib.h>',nl,'#include <time.h>',nl
rth,←'#include <stdint.h>',nl,'#include <inttypes.h>',nl
rth,←'#ifdef _OPENACC',nl,'#include <accelmath.h>',nl,'#endif',nl
rth,←'#ifdef __INTEL_COMPILER',nl,'#include <mkl_vsl.h>',nl,'#endif',nl
rth,←'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
rth,←'#ifdef _WIN32',nl
rth,←'#elif __linux__',nl,'#include <bsd/stdlib.h>',nl
rth,←'#else',nl,'#endif',nl

⍝   Globals
rth,←'int isinit=0;',nl
rth,←'#define PI 3.14159265358979323846',nl,'typedef BOUND B;'

⍝   Typedefs
rth,←'typedef long long int L;typedef aplint32 I;typedef double D;typedef void V;',nl
rth,←'typedef unsigned char U8;',nl

⍝   Structures
rth,←'struct array {I r; B s[15];I f;B c;B z;V*v;};',nl,'typedef struct array A;',nl

⍝   Helper Macros
rth,←'#define DO(i,n) for(L i=0;i<(n);i++)',nl,'#define R return',nl
rth,←'#define DOI(i,n) for(I i=0;i<(n);i++)',nl

⍝   Helper Functions
rth,←'#define R2(n)     n,     n + 2*64,     n + 1*64,     n + 3*64',nl
rth,←'#define R4(n) R2(n), R2(n + 2*16), R2(n + 1*16), R2(n + 3*16)',nl
rth,←'#define R6(n) R4(n), R4(n + 2*4 ), R4(n + 1*4 ), R4(n + 3*4 )',nl
rth,←'static const U8 bitrt[256]={R6(0), R6(2), R6(1), R6(3)};',nl
rth,←'U8 bitrev(U8 c){return bitrt[c];}',nl

⍝   Allocation
rth,←'V EXPORT frea(A*a){if (a->v!=NULL){char*v=a->v;B z=a->z;',nl
rth,←' if(a->f){',nl,'#ifdef _OPENACC',nl
rth,←'#pragma acc exit data delete(v[:z])',nl,'#endif',nl,'}',nl
rth,←' if(a->f>1){free(v);}}}',nl
rth,←'V aa(A*a,I tp){frea(a);B c=1;DO(i,a->r)c*=a->s[i];B z=0;',nl
rth,←' B pc=8*ceil(c/8.0);',nl
rth,←' switch(tp){',nl
rth,←'  case 1:z=sizeof(I)*pc;break;',nl
rth,←'  case 2:z=sizeof(D)*pc;break;',nl
rth,←'  case 3:z=ceil((sizeof(U8)*pc)/8.0);break;',nl
rth,←'  default: error(16);}',nl
rth,←' z=8*ceil(z/8.0);char*v=malloc(z);if(NULL==v)error(1);',nl
rth,←' #ifdef _OPENACC',nl,'  #pragma acc enter data create(v[:z])',nl,' #endif',nl
rth,←' a->v=v;a->z=z;a->c=c;a->f=2;}',nl
rth,←'V ai(A*a,I r,B *s,I tp){a->r=r;DO(i,r)a->s[i]=s[i];aa(a,tp);}',nl
rth,←'V fe(A*e,I c){DO(i,c){frea(&e[i]);}}',nl

⍝   Co-dfns ←→ Dyalog Conversion Helpers
rth,←'V cpad(LOCALP*d,A*a,I t){getarray(t,a->r,a->s,d);B z=0;',nl
rth,←' switch(t){',nl,'  case APLLONG:z=a->c*sizeof(I);break;',nl
rth,←'  case APLDOUB:z=a->c*sizeof(D);break;',nl
rth,←'  case APLBOOL:z=ceil(a->c/8.0)*sizeof(U8);break;',nl
rth,←'  default:error(11);}',nl
rth,←' #ifdef _OPENACC',nl,'  char *v=a->v;',nl
rth,←'  #pragma acc update host(v[:z])',nl,' #endif',nl
rth,←' if(t==APLBOOL){U8*t=ARRAYSTART(d->p);U8*s=a->v;DO(i,z)t[i]=bitrev(s[i]);}',nl
rth,←' else{memcpy(ARRAYSTART(d->p),a->v,z);}}',nl
rth,←'V cpda(A*a,LOCALP*d){if(TYPESIMPLE!=d->p->TYPE)error(16);frea(a);',nl
rth,←' I r=a->r=d->p->RANK;B c=1;DO(i,r){c*=a->s[i]=d->p->SHAPETC[i];};a->c=c;',nl
rth,←' switch(d->p->ELTYPE){',nl
rth,←'  case APLLONG:a->z=8*((c*sizeof(I)+7)/8);a->f=2;',nl
rth,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth,←'   {aplint32*s=ARRAYSTART(d->p);I*t=a->v;DO(i,c)t[i]=s[i];};break;',nl
rth,←'  case APLDOUB:a->z=8*((c*sizeof(D)+7)/8);a->f=2;',nl
rth,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth,←'   {D*s=ARRAYSTART(d->p);D*t=a->v;DO(i,c)t[i]=s[i];};break;',nl
rth,←'  case APLINTG:a->z=8*((c*sizeof(I)+7)/8);a->f=2;',nl
rth,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth,←'   {aplint16*s=ARRAYSTART(d->p);I*t=a->v;DO(i,c)t[i]=s[i];};break;',nl
rth,←'  case APLSINT:a->z=8*((c*sizeof(I)+7)/8);a->f=2;',nl
rth,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth,←'   {aplint8*s=ARRAYSTART(d->p);I*t=a->v;DO(i,c)t[i]=s[i];};break;',nl
rth,←'  case APLBOOL:a->z=8*((((c+7/8)*sizeof(U8))+7)/8);a->f=2;',nl
rth,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth,←'   {U8*s=ARRAYSTART(d->p);U8*t=a->v;DO(i,c)t[i]=bitrev(s[i]);};break;',nl
rth,←'  default:error(16);}',nl
rth,←' #ifdef _OPENACC',nl,' char *vc=a->v;B z=a->z;',nl
rth,←' #pragma acc enter data pcopyin(vc[:z])',nl,' #endif',nl,'}',nl
rth,←'V cpaa(A*t,A*s){frea(t);memcpy(t,s,sizeof(A));}',nl

⍝   External Makers & Extractors
rth,←'EXPORT V*mkarray(LOCALP*da){A*aa=malloc(sizeof(A));if(aa==NULL)error(1);',nl
rth,←' aa->v=NULL;cpda(aa,da);return aa;}',nl
rth,←'V EXPORT exarray(LOCALP*da,A*aa,I at){I tp=0;',nl
rth,←' switch(at){',nl
rth,←'  case 1:tp=APLLONG;break;',nl
rth,←'  case 2:tp=APLDOUB;break;',nl
rth,←'  case 3:tp=APLBOOL;break;',nl
rth,←'  default:error(11);}',nl
rth,←' cpad(da,aa,tp);frea(aa);}',nl

⍝   Scalar Helpers
rth,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth,←'D gcd(D an,D bn){D a=fabs(an);D b=fabs(bn);',nl
rth,←' for(;b>1e-10;){D n=fmod(a,b);a=b;b=n;};R a;}',nl
rth,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth,←'D lcm(D a,D b){D n=a*b;D z=fabs(n)/gcd(a,b);',nl
rth,←' if(a==0&&b==0)R 0;if(n<0)R -1*z;R z;}',nl
rth,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth,←'D circ(I a,D b){switch(a+8){',nl
rth,←'  case 7:return asin(b);break;',nl
rth,←'  case 6:return acos(b);break;',nl
rth,←'  case 5:return atan(b);break;',nl
rth,←'  case 4:return (b+1)*sqrt((b-1)/(b+1));break;',nl
rth,←'  case 3:return asinh(b);break;',nl
rth,←'  case 2:return acosh(b);break;',nl
rth,←'  case 1:return atanh(b);break;',nl
rth,←'  case 8:return sqrt(1-b*b);break;',nl
rth,←'  case 9:return sin(b);break;',nl
rth,←'  case 10:return cos(b);break;',nl
rth,←'  case 11:return tan(b);break;',nl
rth,←'  case 12:return sqrt(1+b*b);break;',nl
rth,←'  case 13:return sinh(b);break;',nl
rth,←'  case 14:return cosh(b);break;',nl
rth,←'  case 15:return tanh(b);break;',nl
rth,←' };return -1;}',nl
rth,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth,←'D fact(D n){if(n<0)R -1;if(n!=floor(n))R tgamma(n+1);',nl
rth,←' D z=1;DO(i,n){z*=i+1;};R z;}',nl
rth,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth,←'D binomial(D x,D y){if(x>=0&&y>=0&&x==floor(x)&&y==floor(y))',nl
rth,←' R fact(y)/(fact(x)*fact(y-x));',nl
rth,←' R -1;}',nl

⍝  Mixed Verbs

⍝   Mixed Verbs Dispatch Table
fdb←0 5⍴⊂''
⍝⍝     Prim  Monadic        Dyadic         MBool DBool
fdb⍪←,¨'⌷'   '{⎕SIGNAL 99}' 'idxd'         ''    ''
fdb⍪←,¨'['   '{⎕SIGNAL 99}' 'brid'         ''    ''
fdb⍪←,¨'⍳'   'iotm'         '{⎕SIGNAL 16}' ''    ''
fdb⍪←,¨'⍴'   'shpm'         'shpd'         ''    ''
fdb⍪←,¨','   'catm'         'catd'         ''    ''
fdb⍪←,¨'⍪'   'fctm'         'fctd'         ''    ''
fdb⍪←,¨'⌽'   'rotm'         'rotd'         ''    ''
fdb⍪←,¨'⊖'   'rtfm'         'rtfd'         ''    ''
fdb⍪←,¨'∊'   'memm'         'memd'         ''    ''
fdb⍪←,¨'⊃'   'dscm'         '{⎕SIGNAL 16}' ''    ''
fdb⍪←,¨'≡'   'eqvm'         'eqvd'         ''    ''
fdb⍪←,¨'≢'   'nqvm'         'nqvd'         ''    ''
fdb⍪←,¨'⊢'   'rgtm'         'rgtd'         ''    ''
fdb⍪←,¨'⊣'   'lftm'         'lftd'         ''    ''
fdb⍪←,¨'//'  '{⎕SIGNAL 99}' 'fltd'         ''    ''
fdb⍪←,¨'⍉'   'tspm'         '{⎕SIGNAL 16}' ''    ''
fdb⍪←,¨'↓'   '{⎕SIGNAL 16}' 'drpd'         ''    ''
fdb⍪←,¨'↑'   '{⎕SIGNAL 16}' 'tked'         ''    ''
fdb⍪←,¨'⊤'   '{⎕SIGNAL 99}' 'encd'         ''    ''
fdb⍪←,¨'⊥'   '{⎕SIGNAL 99}' 'decd'         ''    ''
fdb⍪←,¨'?'   'rolm'         '{⎕SIGNAL 16}' ''    ''
fdb⍪←,¨'⎕sp' '{⎕SIGNAL 99}' 'sopid'        ''    ''

⍝   Mixed Verb Dispatch/Calling
fcl←{cln ⍺(⍎⊃(((0⌷⍉⍵⍵)⍳⊂⍺⍺),¯1+≢⍵)⌷⍵⍵⍪fnc ⍺⍺)⍵}
fnc←{⍵('''',⍵,'''calm')('''',⍵,'''cald')'' ''}

⍝   Mixed Verb Helpers
calm←{        z r     ←var/⍵
        arr     ←⍺⍺,((1⌷⍺)⊃'iifb'),'n(',z,',NULL,',r,',env);',nl
        scl     ←'{A sz,sr;sz.v=NULL;ai(&sz,0,NULL,',(⍕⊃⍺),');',nl
        scl     ,←'sr.r=0;sr.v=&',r,';sr.f=0;sr.c=1;sr.z=sizeof(',(1⊃git ⍺),');',nl
        scl     ,←⍺⍺,((1⌷⍺)⊃'iifb'),'n(&sz,NULL,&sr,env);',nl
        scl     ,←(⊃git ⍺),'*restrict szv=sz.v;',nl,pacc'update host(szv[:1])'
        scl     ,←z,'=*szv;frea(&sz);}',nl
                (∧/¯1=,↑1⌷⍉⍵)⊃arr scl}
cald←{        z r l   ←var/⍵
        arr     ←⍺⍺,((¯2↑⍺)⊃¨⊂'iifb'),'(',z,',',l,',',r,',env);',nl
        scl     ←'{A sz,sr,sl;sz.v=NULL;ai(&sz,0,NULL,',(⍕⊃⍺),');',nl
        scl     ,←'sr.r=0;sr.f=0;sr.c=1;sr.v=&',r,';sr.z=sizeof(',(1⊃git ⍺),');',nl
        scl     ,←'sl.r=0;sl.f=0;sl.c=1;sl.v=&',l,';sl.z=sizeof(',(2⊃git ⍺),');',nl
        scl     ,←⍺⍺,((¯2↑⍺)⊃¨⊂'iifb'),'(&sz,&sl,&sr,env);',nl
        scl     ,←(⊃git⍺),'*szv=sz.v;',nl,pacc'update host(szv[:1])'
        scl     ,←z,'=*szv;frea(&sz);}',nl
                (∧/¯1=,↑1⌷⍉⍵)⊃arr scl}

decarr←{r s v c←⍺∘,¨'rsvc' ⋄ z←'I ',r,'=(',⍵,')->r;B*',s,'=(',⍵,')->s;'
  z,'B ',c,'=(',⍵,')->c;',⍺⍺,'*restrict ',v,'=(',⍵,')->v;',nl}
decarri←'I'decarr ⋄ decarrf←'D'decarr ⋄ decarrb←'U8'decarr
declit←{r s v c←⍺∘,¨'rsvc' ⋄ z←'I ',r,'=',(⍕≢⍴⍵),';'
  z,←'B ',s,'[15]={',(⊃{⍺,',',⍵}/⍕¨15↑⍴⍵),'};B ',c,'=',(⍕≢,⍵),';',nl
  z,⍺⍺,'*restrict ',v,'={',(cln ⊃{⍺,',',⍵}/⍕¨(8,⍨⌈8÷⍨≢,⍵)↑,⍵),'};',nl}
decliti←'I'declit ⋄ declitf←'D'declit
declitb←{r s v c←⍺∘,¨'rsvc' ⋄ z←'I ',r,'=',(⍕≢⍴⍵),';'
  z,←'B ',s,'[15]={',(⊃{⍺,',',⍵}/⍕¨15↑⍴⍵),'};B ',c,'=',(⍕≢,⍵),';',nl
  z,'U8*restrict ',v,'={',(⊃{⍺,',',⍵}/⍕¨2⊥⍉(8,⍨⌈8÷⍨≢,⍵)↑,⍵),'};',nl}
dectmp←{'A ',a,';',a,'.v=NULL;ai(&',a,',',⍺,');',nl,⍵(⍺⍺ decarr)'&',a←⍵,'a'}
dectmpi←'I'dectmp ⋄ dectmpf←'D'dectmp ⋄ dectmpb←'U8'dectmp

⍝    Prefix Sum Scan Utility
sumscan←{z←'{I*restrict a=',⍵,';B n=',⍺,';',nl
  z,←' I final;',nl,(simd'present(a[:n])'),'DO(i,1)final=a[n-1];',nl
  z,←' for(I d=2;d<=n;d<<=1){I r=n/d;',nl,simd'independent present(a[:n])'
  z,←'  DO(i,r){a[i*d+d-1]+=a[i*d+(d>>1)-1];}}',nl
  z,←(simd'present(a[:n])'),' DO(i,1)a[n-1]=0;',nl
  z,←' for(I d=n;d>=2;d>>=1){I r=n/d;',nl,simd'independent present(a[:n])'
  z,←'  DO(i,r){I t=a[i*d+(d>>1)-1];a[i*d+(d>>1)-1]=a[i*d+d-1];a[i*d+d-1]+=t;}}',nl
  z,←(simd'present(a[:n])'),' DO(i,n-1)a[i]=a[i+1];',nl
  z,(simd'present(a[:n])'),' DO(i,1)a[n-1]+=final;}',nl}

⍝    Mixed Verb Generator Skeleton
mxfn←{chk siz exe←⍺ ⋄ al tp el←⍵
  vr←(∧/¯1=↑1⌷⍉el)+0≠(⊃0⍴⊃)¨0⌷⍉el
  tpl tpv tps←(tp(/⍨)vr=⊢)¨⍳3
  nml nmv nms←(('zrl'↑⍨≢el)/⍨vr=⊢)¨⍳3
  elv ell els←1 0 2(⊢(/⍨)vr=⊣)¨(⊂(≢el)↑'rslt' 'rgt' 'lft'),2⍴⊂0⌷⍉el
  z←'{B zc=1,rc=1,lc=1;',nl
  z,←(⊃,/(⊂''),elv{'A *',⍺,'=',⍵,';'}¨var/(1=vr)⌿el),nl
  z,←⊃,/(⊂''),nml{'I ',⍺,'r=',(⍕≢⍴⍵),';B ',⍺,'s[]={',(⍕≢⍵),'};'}¨ell
  z,←⊃,/(⊂''),(git tpl),¨nml{⍺,'v[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl}¨ell
  z,←(0=≢nml)⊃(pacc')',⍨¯1↓⊃,/(⊂'enter data copyin('),nml,¨⊂'v,')''
  z,←(⊃,/(⊂''),(git tps),¨nms{'*s',⍺,'=&',⍵,';'}¨els),nl↑⍨≢els
  z,←(⊃,/(⊂''),{'I ',⍵,'r=0;B*',⍵,'s=NULL;'}¨nms),nl↑⍨≢nms
  z,←(⊃,/(⊂''),(git tps){⍺,⍵,'v[]={*s',⍵,'};'}¨nms),nl↑⍨≢nms
  iso←(⊂⊃1⌷⍉el)∨.≡n2f 1↓1⌷⍉el
  z,←iso⊃''('A*orz=rslt;A tz;tz.v=NULL;rslt=&tz;',nl)
  z,←(0≡≢elv)⊃'' 'A tp;tp.v=NULL;A*rslt=&tp;'
  tpv nmv elv,←(0≡≢elv)⊃(3⍴⊂⍬)((⊃tps)'z' 'rslt')
  z,←((1↓tpv)((1↓nmv)decl)1↓elv),'I zr;B zs[15];',nl
  z,←chk,(nl ''⊃⍨''≡chk),siz,nl
  alloc←'ai(rslt,zr,zs,',(⍕⊃0⌷tp),');',nl
  alloc,←(1↑tpv)((1↑nmv)declv)1↑elv
  z,←(al⊃'' alloc),exe,((0≡≢elv)⊃'' '*sz=zv[0];'),nl
  z,←(0=≢nml)⊃(pacc')',⍨¯1↓⊃,/(⊂'exit data delete('),nml,¨⊂'v,')''
  z,←iso⊃''('cpaa(orz,rslt);',nl)
  z,←'}',nl
    z}

decl←{        z       ←(⊃,/(⊂''),⍺⍺{'I ',⍺,'r=',⍵,'->r;'}¨⍵),nl
        z       ,←(⊃,/(⊂''),⍺⍺{'B*restrict ',⍺,'s=',⍵,'->s;'}¨⍵),nl
        z       ,←⍺(⍺⍺ declv) ⍵
                z}
declv   ←{(⊃,/(⊂''),(git ⍺),¨⍺⍺{'*restrict ',⍺,'v=(',⍵,')->v;'}¨⍵),nl}

⍝   Structural Primitive Verbs

⍝    Reshape
shpd←{chk←'if(lr==0){ls[0]=1;lr=1;}if(1!=lr)error(11);'
 siz←pacc'update host(lv[:ls[0]])'
 siz,←'zr=ls[0];DO(i,zr)zc*=zs[i]=lv[i];DO(i,rr)rc*=rs[i];'
 cpy←'ai(rslt,zr,zs,',(⍕⊃0⌷⍺),');',nl,(⊃0⌷⍺)((,'z')declv),⊂'rslt'
 cpy,←'if(rc==0){',nl,(simd'present(zv)'),'DO(i,zc)zv[i]=0;}',nl
 cpy,←'else{',nl
 cpyn←cpy,(simd'present(zv[:zc],rv[:rc])'),'DO(i,zc)zv[i]=rv[i%rc];}'
 cpyb←cpy,'I rcp=ceil(rc/8.0),zcp=ceil(zc/8.0);',nl
 cpyb,←(simd'present(zv[:zcp],rv[:rcp])'),'DO(i,zcp){U8 b=0;',nl
 cpyb,←' DO(j,8){I ri=(i*8+j)%rc;b|=(1&(rv[ri/8]>>(7-(ri%8))))<<(7-j);}',nl
 cpyb,←' zv[i]=b;}}'
 cpy←(3=0⌷⍺)⊃cpyn cpyb
 ref←'rslt->r=zr;DO(i,zr){rslt->s[i]=zs[i];};rslt->f=rgt->f;rgt->f=0;',nl
 zcp←(3=0⌷⍺)⊃'zc' 'ceil(zc/8.0)'
 ref,←'rslt->c=zc;rslt->z=',zcp,'*sizeof(',(⊃git ⊃0⌷⍺),');rslt->v=rgt->v;',nl
 exe←'if(zc<=rc){',nl,ref,'} else {',nl,cpy,nl,'}'
 chk siz (exe cpy⊃⍨0=⊃0⍴⊃⊃1 0⌷⍵) mxfn 0 ⍺ ⍵}

⍝    Ravel
catmfinaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e
  s←'(',rslt,')->r=1;(',rslt,')->s[0]=(',rgt,')->c;',nl ⋄ ≡/2↑e:s
  'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl,s}
catmffnaaa←catmfbnaaa←catmfinaaa

⍝    Catenate/Laminate
catd←{
  chk←'if(rr!=0&&lr!=0&&abs(rr-lr)>1)error(4);int minr=rr>lr?lr:rr;',nl
  chk,←'int sr=rr==lr&&lr!=0?lr-1:minr;DO(i,sr)if(rs[i]!=ls[i])error(5);'
  siz←'zs[0]=1;if(lr>rr){zr=lr;DO(i,lr)zs[i]=ls[i];}',nl
  siz,←'else{zr=rr;DO(i,rr)zs[i]=rs[i];}',nl
  siz,←'zr=zr==0?1:zr;zs[zr-1]+=minr==zr?ls[zr-1]:1;'
  exe←'DO(i,zr)zc*=zs[i];DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
  exe,←'B zm=zs[zr-1],zi=zc<=zm?1:zc/zm;',nl
  exe,←'B lm=(lr<rr||lr==0)?1:ls[lr-1],rm=(rr<lr||rr==0)?1:rs[rr-1];',nl
  exe,←'B lt=lc!=1,rt=rc!=1;',nl
  exe,←(3=0⌷⍺)⊃'I zcp=zc;' 'I zcp=ceil(zc/8.0);'
  exe,←(3=1⌷⍺)⊃'I rcp=rc;' 'I rcp=ceil(rc/8.0);'
  exe,←(3=2⌷⍺)⊃'I lcp=lc;' 'I lcp=ceil(lc/8.0);'
  exe,←(3=0⌷⍺)⊃''('DO(i,zcp)zv[i]=0;',nl)
  exe,←(3=0⌷⍺)⊃nl(pacc'update host(rv[:rcp],lv[:lcp])')
  exe,←(3=0⌷⍺)⊃(simd'independent collapse(2) present(zv[:zcp],lv[:lcp])')''
  exe,←'DO(i,zi){DO(j,lm){I zvi=i*zm+j,lvi=lt*(i*lm+j);',nl
  exe,←(3=0⌷⍺)⊃'zv[zvi]=' 'zv[zvi/8]|='
  exe,←(3=2⌷⍺)⊃'lv[lvi]' '(1&(lv[lvi/8]>>(7-(lvi%8))))'
  exe,←(3=0⌷⍺)⊃(';}}',nl)('<<(7-(zvi%8));}}',nl)
  exe,←(3=0⌷⍺)⊃(simd'independent collapse(2) present(zv[:zcp],rv[:rcp])')''
  exe,←'DO(i,zi){DO(j,rm){I zvi=i*zm+lm+j,rvi=rt*(i*rm+j);',nl
  exe,←(3=0⌷⍺)⊃'zv[zvi]=' 'zv[zvi/8]|='
  exe,←(3=1⌷⍺)⊃'rv[rvi]' '(1&(rv[rvi/8]>>(7-(rvi%8))))'
  exe,←(3=0⌷⍺)⊃(';}}',nl)('<<(7-(zvi%8));}}',nl)
  exe,←(3=0⌷⍺)⊃''(pacc'update device(zv[:zcp])')
    chk siz exe mxfn 1 ⍺ ⍵}


⍝    Table
ctfmfaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←'{B s[2];'
  z,←'if((',rgt,')->r)s[0]=(',rgt,')->s[0]; else s[0]=1;',nl
  z,←'if(s[0])s[1]=(',rgt,')->c/s[0]; else s[1]=1;',nl
  ≡/2↑e:z,'(',rgt,')->r=2;(',rgt,')->s[0]=s[0];(',rgt,')->s[1]=s[1];}',nl
  z,←'ai(',rslt,',2,s,',⍺,');U8*restrict v=(',rslt,')->v;',nl
  z,←'U8*restrict rv=(',rgt,')->v;B cnt=(',rgt,')->z;',nl
  z,(simd'present(v[:cnt],rv[:cnt])'),'DO(i,cnt)v[i]=rv[i];}',nl}
ctfmfinaaa←{'1' ctfmfaa ⍵} ⋄ ctfmffnaaa←{'2' ctfmfaa ⍵}
ctfmfbnaaa←{'3' ctfmfaa ⍵}

⍝    Catenate First/Laminate
fctd←{
  chk←'if(rr!=0&&lr!=0&&abs(rr-lr)>1)error(4);int minr=rr>lr?lr:rr;',nl
  chk,←'if(lr==rr&&rr>0){I n=rr-1;DO(i,n)if(rs[i+1]!=ls[i+1])error(5);}',nl
  chk,←'else if(lr<rr){DO(i,lr)if(ls[i]!=rs[i+1])error(5);}',nl
  chk,←'else{DO(i,rr)if(ls[i+1]!=rs[i])error(5);}'
  siz←'zs[0]=1;if(lr>rr){zr=lr;DO(i,lr)zs[i]=ls[i];}',nl
  siz,←'else{zr=rr;DO(i,rr)zs[i]=rs[i];}',nl
  siz,←'zr=zr==0?1:zr;zs[0]+=minr==zr?ls[0]:1;'
  exe←'DO(i,zr)zc*=zs[i];DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
  exe,←(3=0⌷⍺)⊃'I zcp=zc;' 'I zcp=ceil(zc/8.0);'
  exe,←(3=1⌷⍺)⊃'I rcp=rc;' 'I rcp=ceil(rc/8.0);'
  exe,←(3=2⌷⍺)⊃'I lcp=lc;' 'I lcp=ceil(lc/8.0);'
  exe,←nl,'I lt=lr!=0;I rt=rr!=0;'
  exe,←'if(zc)zc/=zs[0];if(!rr)rc=zc;if(!lr)lc=zc;',nl
  exe,←(3=0⌷⍺)⊃''((pacc'update host(rv[:rcp],lv[:lcp])'),'DO(i,zcp)zv[i]=0;',nl)
  exe,←(3=0⌷⍺)⊃(simd'present(zv[:zcp],lv[:lcp])')''
  exe,←'DO(i,lc){I lvi=lt*i;'
  exe,←(3=0⌷⍺)⊃'zv[i]=' 'zv[i/8]|='
  exe,←(3=2⌷⍺)⊃'lv[lvi]' '(1&(lv[lvi/8]>>(7-(lvi%8))))'
  exe,←(3=0⌷⍺)⊃(';}',nl)('<<(7-(i%8));}',nl)
  exe,←(3=0⌷⍺)⊃(simd'independent present(zv[:zcp],rv[:rcp])')''
  exe,←'DO(i,rc){I zvi=lc+i;I rvi=rt*i;'
  exe,←(3=0⌷⍺)⊃'zv[zvi]=' 'zv[zvi/8]|='
  exe,←(3=1⌷⍺)⊃'rv[rvi]' '(1&(rv[rvi/8]>>(7-(rvi%8))))'
  exe,←(3=0⌷⍺)⊃(';}')('<<(7-(zvi%8));}')
  exe,←(3=0⌷⍺)⊃''(nl,pacc'update device(zv[:zcp])')
    chk siz exe mxfn 1 ⍺ ⍵}

⍝    Reverse
rotmfinaaa←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'I'rotmne⊃vs ⋄ ⊃'1I'rotmnn/vs}
rotmffnaaa←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'D'rotmne⊃vs ⋄ ⊃'2D'rotmnn/vs}
rotmlp←{z←'{I n=0,rk;B oc=1,ic=1,tc,*s=(',⍵,')->s;',nl
  z,←⍺,'*restrict rv=(',⍵,')->v;',nl
  z,'if((rk=(',⍵,')->r)){n=rk-1;ic=s[rk-1];};DO(i,n)oc*=s[i];tc=oc*ic;',nl}
rotmne←{z←(⍺ rotmlp ⍵),'n=ic/2;',nl,simd'independent present(rv[:tc])'
  z,←'DO(i,oc){DO(j,n){',⍺,'*a,*b;a=&rv[i*ic+(ic-(j+1))];b=&rv[i*ic+j];',nl
  z,' ',⍺,' t=*a;*a=*b;*b=t;}}}',nl}
rotmnn←{tp td←⍺⍺ ⋄ z←(td rotmlp ⍵),'ai(',⍺,',rk,s,',tp,');',nl
  z,←td,'*restrict zv=(',⍺,')->v;',nl
  z,←simd'independent present(zv[:tc],rv[:tc])'
  z,'DO(i,oc){DO(j,ic){zv[i*ic+j]=rv[i*ic+(ic-(j+1))];}}}',nl}
rotmfbnaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←'U8'rotmlp rgt
  z,←'B tc8=ceil(tc/8.0);A ta;ta.v=NULL;ai(&ta,rk,s,3);',nl
  z,←'U8*restrict zv=(&ta)->v;',nl,simd'independent present(zv[:tc8],rv[:tc8])'
  z,←'DO(i,tc8){U8 t=0;',nl,pacc'loop reduction(|:t)'
  z,←' DO(j,8){B ti,tr,tc;ti=i*8+j;tr=ti/ic;tc=ti%ic;',nl
  z,←'  B ri=tr*ic+(ic-(tc+1));t|=(1&(rv[ri/8]>>(7-(ri%8))))<<(7-j);}',nl
  z,' zv[i]=t;}',nl,'cpaa(',rslt,',&ta);}',nl}

⍝    Rotate
rotdfiiaaa←{v e y←⍵ ⋄ '1I'rotdfxiaaa var/3↑v,⍪e}
rotdffiaaa←{v e y←⍵ ⋄ '2D'rotdfxiaaa var/3↑v,⍪e}
rotdfxiaaa←{d t←⍺ ⋄ a r l←⍵ ⋄ z←'{',('r'(t decarr)r),'l'decarri l
  z,←'if(lr!=0&&(lr!=1||ls[0]!=1))DOMAIN_ERROR;',nl,('rr,rs,',d)(t dectmp)'z'
  z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,rotdfxilp a}
rotdfiiaal←{v e y←⍵ ⋄ '1I'rotdfxiaal(var/2↑v,⍪e),2⌷v}
rotdffiaal←{v e y←⍵ ⋄ '2D'rotdfxiaal(var/2↑v,⍪e),2⌷v}
rotdfxiaal←{d t←⍺ ⋄ a r l←⍵ ⋄ lr←≢⍴l ⋄ (lr≠0)∧(lr≠1)∨(⊃⍴l)≠1:⎕SIGNAL 11
  z←'{',('r'(t decarr)r),('rr,rs,',d)(t dectmp)'z'
  z,'I lv0=',(cln⍕l),';',nl,rotdfxilp a}
rotdfshft←{z←'B ic=1,jc=1;I n=0;if(rr){jc=rs[rr-1];n=rr-1;}',nl
  z,'DOI(i,n)ic*=rs[i];B s=abs(lv0);if(jc)s%=jc;if(lv0<0)s=jc-s;',nl}
rotdfxilp←{z←(rotdfshft⍬),simd'present(zv[:zc],rv[:zc]) independent'
  z,←'DO(i,ic){DO(j,jc){zv[i*jc+j]=rv[i*jc+(j+s)%jc];}}',nl
  z,'cpaa(',⍵,',&za);}',nl}
rotdfbiaaa←{v e y←⍵ ⋄ a r l←var/3↑v,⍪e ⋄ z←'{',('l'decarri l),'r'decarrb r
  z,←'if(lr!=0&&(lr!=1||ls[0]!=1))DOMAIN_ERROR;',nl,'rr,rs,3'dectmpb'z'
  z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,rotdfbilp a}
rotdfbiaal←{v e y←⍵ ⋄ a r←var/2↑v,⍪e ⋄ lr←≢⍴l←2⊃v ⋄ (lr≠0)∧(lr≠1)∨(⊃⍴l)≠1:⎕SIGNAL 11
  '{',('r'decarrb r),('rr,rs,3'dectmpb'z'),'I lv0=',(cln⍕l),';',nl,rotdfbilp a}
rotdfbilp←{z←(rotdfshft⍬),'B*restrict zvB=(B*)zv;B*restrict rvB=(B*)rv;',nl
  z,←'{B ec=(zc+63)/64;',nl
  z,←(ackn'present(rvB[:ec],zvB[:ec])'),'{',nl
  z,←'DO(i,ec){B t=0;DOI(j,64){B zx=i*64+j;B zi=zx/jc,zj=zx%jc;',nl
  z,←'  B rj=(zj+s)%jc;B rx=zi*jc+rj;',nl
  z,←'  t|=(1&(rvB[rx/64]>>(rx%64)))<<j;}',nl
  z,←' zvB[i]=t;}',nl
  z,'}}',nl,'cpaa(',⍵,',&za);}',nl}
rotdfbbaaa←{'NONCE_ERROR;',nl}
rotdfbbaal←{'NONCE_ERROR;',nl}
rotdfibaaa←{'NONCE_ERROR;',nl}
rotdfibaal←{'NONCE_ERROR;',nl}
rotdffbaaa←{'NONCE_ERROR;',nl}
rotdffbaal←{'NONCE_ERROR;',nl}
rotd←{⍺('df'gluecl'⌽')⍵}

⍝    Reverse First
rtfmfinaaa←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'I'rtfmne⊃vs ⋄ ⊃'1I'rtfmnn/vs}
rtfmffnaaa←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'D'rtfmne⊃vs ⋄ ⊃'2D'rtfmnn/vs}
rtfmhd←{z←'{B*s=(',⍵,')->s;I rk=(',⍵,')->r;B rc=1,zc=1;',nl
  z,←'if(rk){rc=s[0];DO(i,rk-1)zc*=s[i+1];}',nl
  z,⍺,'*restrict rv=(',⍵,')->v;B cnt=zc*rc;',nl}
rtfmne←{z←(⍺ rtfmhd ⍵),'I n=rc/2;',nl
  z,←simd'collapse(2) independent present(rv[:cnt])'
  z,←'DO(i,n){DO(j,zc){I zvi=i*zc+j,rvi=(rc-(i+1))*zc+j;',nl
  z,⍺,' t=rv[zvi];rv[zvi]=rv[rvi];rv[rvi]=t;}}}',nl}
rtfmnn←{tp td←⍺⍺ ⋄ z←(td rtfmhd ⍵),'ai(',⍺,',rk,s,',tp,');',nl
  z,←td,'*restrict zv=(',⍺,')->v;',nl
  z,←simd'independent collapse(2) present(zv[:cnt],rv[:cnt])'
  z,'DO(i,rc){DO(j,zc){zv[i*zc+j]=rv[(rc-(i+1))*zc+j];}}}',nl}
rtfmfbnaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←'U8'rtfmhd rgt
  z,←'I c8=ceil(cnt/8.0);A t;t.v=NULL;ai(&t,rk,s,3);U8*restrict zv=t.v;',nl
  z,←simd'independent present(rv[:c8],zv[:c8])'
  z,←'DO(i8,c8){zv[i8]=0;',nl
  z,←' for(I bi=0;bi<8;){B ci=i8*8+bi;if(ci>=cnt)break;',nl
  z,←'  B i=rc-(ci/zc+1),j=ci%zc;',nl
  z,←'  B ti=i*zc+j;B ti8=ti/8;I t,sz=(i8*8+8)-ci;if(sz>(t=(ti8*8+8)-ti))sz=t;',nl
  z,←'  if(sz>(t=zc-j))sz=t;U8 msk=-1;msk<<=(8-sz);msk>>=(ti%8);',nl
  z,←'  if(bi>ti%8)zv[i8]|=(rv[ti8]&msk)>>(bi-(ti%8));',nl
  z,←'  else zv[i8]|=(rv[ti8]&msk)<<((ti%8)-bi);',nl
  z,←'  bi+=sz;}}',nl
  z,'cpaa(',rslt,',&t);}',nl}

⍝    Rotate First
rtfdfiiaaa←{v e y←⍵ ⋄ '1I'rtfdfxiaaa var/3↑v,⍪e}
rtfdffiaaa←{v e y←⍵ ⋄ '2D'rtfdfxiaaa var/3↑v,⍪e}
rtfdfxiaaa←{d t←⍺ ⋄ a r l←⍵ ⋄ z←'{',('r'(t decarr)r),'l'decarri l
  z,←'if(lr!=0&&(lr!=1||ls[0]!=1))DOMAIN_ERROR;',nl,('rr,rs,',d)(t dectmp)'z'
  z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,t rtfdfxilp a}
rtfdfiiaal←{v e y←⍵ ⋄ '1I'rtfdfxiaal(var/2↑v,⍪e),2⌷v}
rtfdffiaal←{v e y←⍵ ⋄ '2D'rtfdfxiaal(var/2↑v,⍪e),2⌷v}
rtfdfxiaal←{d t←⍺ ⋄ a r l←⍵ ⋄ lr←≢⍴l ⋄ (lr≠0)∧(lr≠1)∨(⊃⍴l)≠1:⎕SIGNAL 11
  z←'{',('r'(t decarr)r),('rr,rs,',d)(t dectmp)'z'
  z,'I lv0=',(cln⍕l),';',nl,t rtfdfxilp a}
rtfdfshft←{z←'B ic=1;if(rr)ic=rs[0];I n=0;if(rr)n=rr-1;',nl
  z,←'B jc=1;DOI(i,n)jc*=rs[i+1];B s=abs(lv0);if(ic)s%=ic;else s=0;',nl
  z,'if(lv0<0)s=(ic-s)*jc;else s*=jc;B zc_s=zc-s;',nl}
rtfdfxilp←{z←(rtfdfshft⍬),⍺,'*restrict rv2=rv+s;',⍺,'*restrict zv2=zv+zc_s;',nl
  z,←(acdt'present(zv[:zc],rv[:zc],zv2[:s],rv2[:zc_s])'),'{',nl
  z,←(simd'async(1) vector(256)'),'DO(i,zc_s){zv[i]=rv2[i];}',nl
  z,←(simd'async(2) vector(256)'),'DO(i,s){zv2[i]=rv[i];}',nl
  z,←pacc'wait'
  z,'}',nl,'cpaa(',⍵,',&za);}',nl}
rtfdfbiaaa←{v e y←⍵ ⋄ a r l←var/3↑v,⍪e ⋄ z←'{',('l'decarri l),'r'decarrb r
  z,←'if(lr!=0&&(lr!=1||ls[0]!=1))DOMAIN_ERROR;',nl,'rr,rs,3'dectmpb'z'
  z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,rtfdfbilp a}
rtfdfbiaal←{v e y←⍵ ⋄ a r←var/2↑v,⍪e ⋄ lr←≢⍴l←2⊃v ⋄ (lr≠0)∧(lr≠1)∨(⊃⍴l)≠1:⎕SIGNAL 11
  '{',('r'decarrb r),('rr,rs,3'dectmpb'z'),'I lv0=',(cln⍕l),';',nl,rtfdfbilp a}
rtfdfbilp←{z←(rtfdfshft⍬),'B ec=(zc+63)/64;',nl
  z,←'B*restrict zvB=(B*)zv;B*restrict rvB=(B*)rv;',nl
  z,←'if(zc<=1){}else if(zc<=64){',nl
  z,←simd'present(zvB[:ec],rvB[:ec])'
  z,←' DOI(i,1){B t=rvB[0]&((1<<zc)-1);zvB[0]=(t<<(zc-s))|(t>>s);}}',nl
  z,←'else{B ac=zc_s/64;B ao=s/64;I ar=s%64;I al=64-ar;',nl
  z,←' B bc=s/64;B bo=((zc_s)+63)/64;I bl=zc_s%64;I br=64-bl;',nl
  z,←(ackn'present(rvB[:ec],zvB[:ec])'),'{',nl
  z,←' DO(i,ac){zvB[i]=(rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al);}',nl
  z,←' if(zc_s%64){DOI(i,1){zvB[ac]=rvB[ac+ao]>>ar;',nl
  z,←'   zvB[bo-1]=(zvB[bo-1]&((1UL<<bl)-1))|(rvB[0]<<bl);}}',nl
  z,←' DO(i,bc){zvB[i+bo]=(rvB[i]>>br)|(rvB[i+1]<<bl);}',nl
  z,←'}}',nl
  z,'cpaa(',⍵,',&za);}',nl}
rtfdfbbaaa←{'NONCE_ERROR;',nl}
rtfdfbbaal←{'NONCE_ERROR;',nl}
rtfdfibaaa←{'NONCE_ERROR;',nl}
rtfdfibaal←{'NONCE_ERROR;',nl}
rtfdffbaaa←{'NONCE_ERROR;',nl}
rtfdffbaal←{'NONCE_ERROR;',nl}
rtfd←{⍺('df'gluecl'⊖')⍵}

⍝    Transpose
trnmfh←{z←'{I rk=(',⍵,')->r;B sp[15];DO(i,rk)sp[i]=(',⍵,')->s[rk-(1+i)];',nl
  z,←'if(rk<=1){',nl
  z,←(≡/2↑⍺⍺)⊃('memcpy(',⍺,',',⍵,',sizeof(A));(',⍵,')->f=0;',nl)''
  z,'}else if(rk==2){',nl}
trnmfn←{v e y←⍵ ⋄ tp tc←⍺ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←rslt(e trnmfh)rgt
  a←'A ta;ta.v=NULL;ai(&ta,rk,sp,',tc,');',tp,'*restrict zv=ta.v;',nl
  z,←a⊣a,←tp,'*restrict rv=(',rgt,')->v;B cnt=(',rgt,')->c;',nl
  z,←simd'independent present(zv[:cnt],rv[:cnt])'
  z,←'DO(i,sp[0]){DO(j,sp[1]){zv[(i*sp[1])+j]=rv[(j*sp[0])+i];}}',nl
  z,←'cpaa(',rslt,',&ta);',nl
  z,←'}else{',nl
  z,←a,'B*rs=(',rgt,')->s;',nl
  z,←simd'independent present(zv[:cnt],rv[:cnt]) copyin(rs[:rk])'
  z,←'DO(i,cnt){B ri=0,zi=i;',nl
  z,←' DO(j,rk){B k=zi%rs[j];ri*=rs[j];ri+=k;zi-=k;zi/=rs[j];}',nl
  z,←' zv[i]=rv[ri];}',nl
  z,←'cpaa(',rslt,',&ta);',nl
  z,'}}',nl}
trnmfinaaa←{'I1'trnmfn ⍵} ⋄ trnmffnaaa←{'D2'trnmfn ⍵}
trnmfbnaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←rslt(e trnmfh)rgt
  a←'A ta;ta.v=NULL;ai(&ta,rk,sp,3);U8*restrict zv=ta.v;',nl
  z,←a⊣a,←'U8*restrict rv=(',rgt,')->v;B cnt=(',rgt,')->z;',nl
  z,←simd'independent present(zv[:cnt],rv[:cnt])'
  z,←'DO(i,cnt){zv[i]=0;DO(j,8){B zi=i*8+j;B zr=zi/sp[1],zc=zi%sp[1];',nl
  z,←' B ri=zc*sp[0]+zr;zv[i]|=(1&(rv[ri/8]>>(7-(ri%8))))<<(7-j);}}',nl
  z,←'cpaa(',rslt,',&ta);',nl
  z,←'}else{',nl
  z,←a,'B*rs=(',rgt,')->s;',nl
  z,←simd'independent present(zv[:cnt],rv[:cnt]) copyin(rs[:rk])'
  z,←'DO(i,cnt){zv[i]=0;DO(j,8){B i8=i*8+j;B ri=0,zi=i8;',nl
  z,←'  DO(j,rk){B k=zi%rs[j];ri*=rs[j];ri+=k;zi-=k;zi/=rs[j];}',nl
  z,←'  zv[i]|=(1&(rv[ri/8]>>(7-(ri%8))))<<(7-j);}}',nl
  z,←'cpaa(',rslt,',&ta);',nl
  z,'}}',nl}

⍝    Mix
tkemfinaaa←{v e y←⍵ ⋄ ≡/2↑e:'' ⋄ rslt rgt←var/2↑v,⍪e
  'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl}
tkemffnaaa←tkemfbnaaa←tkemfinaaa

⍝    Enlist
memmfinaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e
  s←'(',rslt,')->r=1;(',rslt,')->s[0]=(',rgt,')->c;',nl ⋄ ≡/2↑e:s
  'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl,s}
memmfbnaaa←memmffnaaa←memmfinaaa

⍝   Selection Primitive Verbs

⍝    Disclose/First
dismfgnaaa←{v e y←⍵ ⋄ tc tn←⍺ ⋄ rslt rgt←var/2↑v,⍪e
  z←(≡/2↑e)⊃('{A*tgt=',rslt,';')('{A tgta;A*tgt;tgta.v=NULL;tgt=tgta;')
  z,←'ai(tgt,0,NULL,',tc,');',tn,'*zv=tgt->v;',nl
  z,←'if((',rgt,')->c){',tn,'*rv=(',rgt,')->v;',nl
  z,←(simd''),'DO(i,1)zv[0]=rv[0];}',nl
  z,←'else{',nl,(simd''),'DO(i,1)zv[0]=0;}',nl
  z,(≡/2↑e)⊃('}',nl)('cpaa(',rslt,',tgt);}',nl)}
dismfinaaa←{'1I'dismfgnaaa ⍵}
dismffnaaa←{'2D'dismfgnaaa ⍵}
dismfbnaaa←{'1' 'U8'dismfgnaaa ⍵}

drpd←{        chk     ←'if(lr!=0&&(lr!=1||ls[0]!=1))error(16);'
        siz     ←pacc'update host(lv[:1])'
        siz     ,←'zr=rr;DO(i,zr)zs[i]=rs[i];zs[0]-=(zs[0]==0?0:lv[0]);',nl
        siz     ,←'I n=zr-1;DO(i,n)zc*=zs[i+1];lc=lv[0];'
        cpy     ←'ai(rslt,zr,zs,',(⍕⊃0⌷⍺),');',nl
        cpy     ,←(⊃0⌷⍺)((,'z')declv),⊂'rslt'
        cpyn    ←simd'independent collapse(2) present(zv[:rslt->c],rv[:rgt->c])'
        cpyn    ,←'DO(i,zs[0]){DO(j,zc){zv[(i*zc)+j]=rv[((i+lc)*zc)+j];}}'
        cpyb    ←'I zcp=ceil(rslt->c/8.0);I rcp=ceil(rgt->c/8.0);',nl
        cpyb    ,←'I sti=(lc*zc)/8;I stp=(lc*zc)%8;n=(zcp==0?0:zcp-1);',nl
        cpyb    ,←simd'independent present(zv[:zcp],rv[:rcp])'
        cpyb    ,←'DO(i,n){U8 x=rv[i+sti]<<stp;',nl
        cpyb    ,←'x|=rv[i+1+sti]>>(8-stp);zv[i]=x;}',nl
        cpyb    ,←'if(zcp){',nl,(pacc'update host(rv[n+sti:1])')
        cpyb    ,←'zv[n]=rv[n+sti]<<stp;',nl,(pacc'update device(zv[n:1])'),'}'
        cpy     ,←(3=⊃0⌷⍺)⊃cpyn cpyb
        ref     ←'rslt->r=zr;DO(i,zr){rslt->s[i]=zs[i];};rslt->f=0;',nl
        ref     ,←'rslt->c=zs[0]*zc;rslt->z=rslt->c*sizeof(',(⊃git ⊃0⌷⍺),');',nl
        ref     ,←'rslt->v=rv+(lc*zc);'
        exe     ←cpy cpy⊃⍨1⌊(3=⊃0⌷⍺)+0=⊃0⍴⊃⊃1 0⌷⍵
                chk siz exe mxfn 0 ⍺ ⍵}
tked←{        chk     ←'if(lr!=0&&(lr!=1||ls[0]!=1))error(16);'
        siz     ←pacc'update host(lv[:1])'
        siz     ,←'zr=rr;DO(i,zr)zs[i]=rs[i];',nl
        siz     ,←'zs[0]=lv[0];I n=zr-1;DO(i,n)zc*=zs[i+1];'
        cpy     ←'ai(rslt,zr,zs,',(⍕⊃0⌷⍺),');',nl
        cpy     ,←(⊃0⌷⍺)((,'z')declv),⊂'rslt'
        cpy     ,←simd'independent collapse(2) present(zv[:rslt->c],rv[:rgt->c])'
        cpy     ,←'DO(i,zs[0]){DO(j,zc){zv[(i*zc)+j]=rv[(i*zc)+j];}}'
        ref     ←'rslt->r=zr;DO(i,zr){rslt->s[i]=zs[i];};rslt->f=0;',nl
        ref     ,←'rslt->c=zs[0]*zc;rslt->z=rslt->c*sizeof(',(⊃git ⊃0⌷⍺),');',nl
        ref     ,←'rslt->v=rv;'
        exe     ←cpy cpy⊃⍨0=⊃0⍴⊃⊃1 0⌷⍵
                chk siz exe mxfn 0 ⍺ ⍵}

⍝    Replicate/Filter
fltd←{chk←'if(lr>1)error(4);',nl
  chk,←'if(lr!=0&&ls[0]!=1&&rr!=0&&rs[rr-1]!=1&&ls[0]!=rs[rr-1])error(5);'
  siz←'zr=rr==0?1:rr;I n=zr-1;DO(i,n)zs[i]=rs[i];',nl
  siz,←'if(lr==1)lc=ls[0];if(rr!=0)rc=rs[rr-1];zs[zr-1]=0;B last=0;',nl
  szn←siz,pacc 'update host(lv[:lc],rv[:rgt->c])'
  szn,←'if(lc>=rc){DO(i,lc)last+=abs(lv[i]);}else{last+=rc*abs(lv[0]);}',nl
  szn,←'zs[zr-1]=last;DO(i,n)zc*=zs[i];'
  szb←siz,pacc 'update host(lv[:lft->z],rv[:rgt->c])'
  szb,←'if(lc>=rc){I n=ceil(lc/8.0);',nl
  szb,←' DO(i,n){DO(j,8){last+=1&(lv[i]>>(7-j));}}',nl
  szb,←'}else{last+=rc*(lv[0]>>7);}',nl
  szb,←'zs[zr-1]=last;DO(i,n)zc*=zs[i];'
  exe←'B a=0;if(rc==lc){',nl,'DO(i,lc){',nl
  exe,←' if(lv[i]==0)continue;',nl
  exe,←' else if(lv[i]>0){',nl
  exe,←'  DO(j,zc){DO(k,lv[i]){zv[(j*zs[zr-1])+a+k]=rv[(j*rc)+i];}}',nl
  exe,←'  a+=lv[i];',nl
  exe,←' }else{',nl
  exe,←'  DO(j,zc){L n=abs(lv[i]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}',nl
  exe,←'  a+=abs(lv[i]);}}}',nl
  exe,←'else if(rc>lc){',nl
  exe,←' if(lv[0]>0){'
  exe,←'DO(i,zc){DO(j,rc){DO(k,lv[0]){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}}',nl
  exe,←' else if(lv[0]<0){L n=zc*zs[zr-1];DO(i,n)zv[i]=0;}}',nl
  exe,←'else{DO(i,lc){',nl
  exe,←' if(lv[i]==0)continue;',nl
  exe,←' else if(lv[i]>0){',nl
  exe,←'  DO(j,zc){DO(k,lv[i]){zv[(j*zs[zr-1])+a+k]=rv[j*rc];}}',nl
  exe,←'  a+=lv[i];',nl
  exe,←' }else{',nl
  exe,←'  DO(j,zc){L n=abs(lv[i]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}',nl
  exe,←'  a+=abs(lv[i]);}}}',nl
  exe,←pacc 'update device(zv[:rslt->c])'
  exb←'B a=0;if(rr==1&&rc==lc){I n=ceil(lc/8.0);',nl
⍝⍝  exb,←' A t;t.v=NULL;ai(&t,1,&lc,1);I*restrict tv=t.v;',nl
⍝⍝  exb,←simd'collapse(2) independent present(tv[:lc],lv[:n])'
⍝⍝  exb,←' DO(i,n){DO(j,8){tv[i*8+j]=1&(lv[i]>>(7-j));}}',nl
⍝⍝  exb,←'lc'sumscan'tv'
⍝⍝  exb,←simd'independent present(zv[:zc],rv[:lc],lv[:n],tv[:lc])'
⍝⍝  exb,←' DO(i,lc){if(128&(lv[i/8]<<(i%8)))zv[tv[i]-1]=rv[i];}',nl
⍝⍝  exb,←' frea(&t);',nl
  exb,←' DO(i,n){DO(j,8){if(1&(lv[i]>>(7-j)))zv[a++]=rv[i*8+j];}}',nl
  exb,←'}else if(rc==lc){I n=ceil(lc/8.0);',nl,'DO(i,n){DO(m,8){',nl
  exb,←' if(1&(lv[i]>>(7-m))){',nl
  exb,←'  DO(j,zc){zv[(j*zs[zr-1])+a]=rv[(j*rc)+i*8+m];}',nl
  exb,←'  a++;}}}',nl
  exb,←'}else if(rc>lc){if(lv[0]>>7){',nl
  exb,←'  DO(i,zc){DO(j,rc){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}',nl
  exb,←'}else{I n=ceil(lc/8.0);DO(i,n){DO(m,8){',nl
  exb,←' if(1&(lv[i]>>(7-m))){',nl
  exb,←'  DO(j,zc){zv[(j*zs[zr-1])+a]=rv[j*rc];}',nl
  exb,←'  a++;}}}}',nl
⍝⍝  exb,←'if(rr!=1||rc!=lc){',nl
  exb,←pacc 'update device(zv[:rslt->c])'
⍝⍝  exb,←'}',nl
          ((3≡2⊃⍺)⊃(chk szn exe)(chk szb exb)) mxfn 1 ⍺ ⍵}

⍝    Same/Monadic Left
lftmfinaaa←{v e y←⍵ ⋄ ≡/2↑e:'' ⋄ rslt rgt←var/2↑v,⍪e
  'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl}
lftmfbnaaa←lftmffnaaa←lftmfinaaa

⍝    Identity/Right
rgtmfinaaa←{v e y←⍵ ⋄ ≡/2↑e:'' ⋄ rslt rgt←var/2↑v,⍪e
  'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl}
rgtmfbnaaa←rgtmffnaaa←rgtmfinaaa

lftd←{        chk siz ←''('zr=lr;DO(i,lr)zs[i]=ls[i];')
        exe     ←'DO(i,zr)zc*=zs[i];',nl,(simd'present(zv[:zc],lv[:zc])'),'DO(i,zc)zv[i]=lv[i];'
                chk siz exe mxfn 1 ⍺ ⍵}
rgtd←{        chk siz ←''('zr=rr;DO(i,rr)zs[i]=rs[i];')
        exe     ←'DO(i,zr)zc*=zs[i];',nl,(simd'present(zv[:zc],rv[:zc])'),'DO(i,zc)zv[i]=rv[i];'
                chk siz exe mxfn 1 ⍺ ⍵}
idxd←{        chk     ←'if(lr>1)error(4);if(lr==0)ls[0]=1;if(ls[0]>rr)error(5);'
        chk     ,←'DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
        chk     ,←pacc'update host(lv[:lc])'
        chk     ,←'DO(i,ls[0])if(lv[i]<0||lv[i]>=rs[i])error(3);'
        siz     ←'zr=rr-ls[0];DO(i,zr)zs[i]=rs[ls[0]+i];'
        exe     ←'B a,m,k=0;DO(i,zr)zc*=zs[i];m=zc;',nl
        exe     ,←'DO(i,ls[0]){a=ls[0]-(i+1);k+=m*lv[a];m*=rs[a];}',nl
        exe     ,←(simd'present(rv[:rc],zv[:zc])'),'DO(i,zc)zv[i]=rv[k+i];'
        ∧/,1≥≡¨⍵:      chk siz exe mxfn 1 ⍺ ⍵
        sep     ←{⊃⍺{⍺,⍺⍺,⍵}/⍵}
        ixv ixe ←2⌷⍵
        ixn     ←{'idx[',(⍕⍵),']'}¨⍳≢ixv
        idx     ←'{A *idx[]={',(','sep ixv var¨ixe),'};',nl
        idx     ,←(⊃,/(⍳≢ixv){'I ir',(⍕⍺),'=',⍵,'->r;'}¨ixn),nl
        idx     ,←(⊃,/(⍳≢ixv){'B*restrict is',(⍕⍺),'=',⍵,'->s;'}¨ixn),nl
        idx     ,←(⊃,/(⍳≢ixv){'I*restrict iv',(⍕⍺),'=',⍵,'->v;'}¨ixn),nl
        idx     ,←(⊃,/(⍳≢ixv){'B ic',(⍕⍺),'=',⍵,'->c;'}¨ixn),nl
        idx     ,←'A irz;irz.v=NULL;A*irzp=&irz;',nl
        iso     ←(0 1⌷⍵)∨.≡ixe
        idx     ,←iso⊃('irzp=',(irzv←⊃var/0⌷⍵),';',nl)''
        siz     ←'zr=',(⍕≢ixv),';',⊃,/{'zs[',(⍕⍵),']=ic',(⍕⍵),';'}¨⍳≢ixv
        gdx     ←{'+'sep (↑∘⍺¨-⌽⍳≢⍺){'(',('*'sep(⊂⍵),⍺),')'}¨⍵}
        idi     ←(≢ixv)↑'ijklmnopqrstuvw'
        zidx    ←({'ic',(⍕⍵),''}¨⍳≢ixv)gdx idi
        ridx    ←({'rs[',(⍕⍵),']'}¨⍳≢ixv)gdx(⍳≢ixv){'iv',(⍕⍺),'[',⍵,']'}¨idi
        stm     ←'zv[',zidx,']=rv[',(ridx),'];',nl
        mklp    ←{i s←⍺ ⋄ (⊂'DO(',i,',',s,'){',nl),(' ',¨⍵),(⊂'}')}
        pres    ←'present(zv[:rslt->c],rv[:rgt->c],',(','sep{'iv',(⍕⍵),'[:ic',(⍕⍵),']'}¨⍳≢ixv),') '
        exe     ←simd pres,'independent collapse(',(⍕≢ixv),')'
        exe     ,←⊃,/⊃mklp/(idi{⍺('ic',⍕⍵)}¨⍳≢ixv),⊂⊂stm
        idx     ,←'' siz exe mxfn 1(¯1↓⍺)('irzp'(¯2 0)⍪1↓¯1↓⍵)
        idx     ,←(iso⊃''('cpaa(',irzv,',irzp);')),'}',nl
                idx}

⍝    Index Generation
iotmck←{z←'if((',⍵,')->r>1)RANK_ERROR;if((',⍵,')->c>15)LIMIT_ERROR;',nl
  z,'if((',⍵,')->c!=1)NONCE_ERROR;',nl}
iotmfinaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←iotmck rgt
  z,←'{I*restrict v=(',rgt,')->v;B c=v[0];ai(',rslt,',1,&c,1);',nl
  z,'v=(',rslt,')->v;',nl,(simd'present(v[:c])'),'DO(i,c)v[i]=i;}',nl}
iotmfbnaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←iotmck rgt
  z,←'{U8*v=(',rgt,')->v;B c=v[0]>>7;ai(',rslt,',1,&c,1);',nl
  z,←'I*restrict zv=(',rslt,')->v;',nl
  z,(simd'present(zv[:c])'),'DO(i,c)zv[i]=i;}',nl}

⍝   Miscellaneous Mixed Primitive Verbs Generators

⍝    Roll
rolmfinaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←'{B c=(',rgt,')->c;',nl
  z,←'I*restrict rv=(',rgt,')->v;',nl,acup'host(rv[:c])'
  z,←'DO(i,c){if(rv[i]<0)DOMAIN_ERROR;}',nl
  z,←'A t;t.v=NULL;',nl
  z,←'ai(&t,(',rgt,')->r,(',rgt,')->s,2);D*restrict zv=t.v;',nl
  z,←'srand48(time(NULL));',nl
  z,←'DO(i,c){if(rv[i])zv[i]=arc4random_uniform(rv[i]);else zv[i]=drand48();}',nl
  z,(acup'device(zv[:c])'),'cpaa(',rslt,',&t);}',nl}
rolmfbnaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←'{B c=ceil((',rgt,')->c/8.0);',nl
  z,←'U8*restrict rv=(',rgt,')->v;',nl,acup'host(rv[:c])'
  z,←'A t;t.v=NULL;',nl
  z,←'ai(&t,(',rgt,')->r,(',rgt,')->s,2);D*restrict zv=t.v;',nl
  z,←'srand48(time(NULL));',nl
  z,←'DO(i,c){DO(j,8){B x=i*8+j;U8 t=1&(rv[i]>>(7-j));',nl
  z,←' if(t)zv[x]=0;else zv[x]=drand48();}}',nl
  z,'B zc=t.c;',nl,(acup'device(zv[:zc])'),'cpaa(',rslt,',&t);}',nl}

⍝    Shape
rhomfinaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←'{B sp[15],cnt;'
  z,←'cnt=(',rgt,')->r;DO(i,cnt)sp[i]=(',rgt,')->s[i];',nl
  z,←'ai(',rslt,',1,&cnt,1);I*restrict v=(',rslt,')->v;',nl
  z,'DO(i,cnt)v[i]=sp[i];',nl,(pacc'update device(v[:cnt])'),'}',nl}
rhomfbnaaa←rhomffnaaa←rhomfinaaa

⍝    Depth
eqvmfinaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e 
  z←'{ai(',rslt,',0,NULL,1);I*zv=(',rslt,')->v;',nl
  z,←'if((',rgt,')->r==0)zv[0]=0;else zv[0]=1;',nl
  z,(pacc'update device(zv[:1])'),'}',nl}
eqvmfbnaaa←eqvmffnaaa←eqvmfinaaa

eqvd←{        chk siz ←'' 'zr=0;'
        exe     ←pacc 'update host(lv[:lft->c],rv[:rgt->c])'
        exe     ,←'zv[0]=1;if(rr!=lr)zv[0]=0;',nl
        exe     ,←'DO(i,lr){if(!zv[0])break;if(rs[i]!=ls[i]){zv[0]=0;break;}}',nl
        exe     ,←'DO(i,lr)lc*=ls[i];',nl
        exe     ,←'DO(i,lc){if(!zv[0])break;if(lv[i]!=rv[i]){zv[0]=0;break;}}',nl
        exe     ,←pacc'update device(zv[:rslt->c])'
                chk siz exe mxfn 1 ⍺ ⍵}

⍝    Tally
nqvmfinaaa←{v e y←⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ z←'{I c=1;'
  z,←'if((',rgt,')->r)c=(',rgt,')->s[0];',nl
  z,←'ai(',rslt,',0,NULL,1);I*v=(',rslt,')->v;',nl
  z,(simd'present(v[:1])'),'DO(i,1)v[0]=c;}',nl}
nqvmfbnaaa←nqvmffnaaa←nqvmfinaaa

nqvd←{        chk siz ←'' 'zr=0;'
        exe     ←pacc'update host(lv[:lft->c],rv[:rgt->c])'
        exe     ,←'zv[0]=0;if(rr!=lr)zv[0]=1;',nl
        exe     ,←'DO(i,lr){if(zv[0])break;if(rs[i]!=ls[i]){zv[0]=1;break;}}',nl
        exe     ,←'DO(i,lr)lc*=ls[i];',nl
        exe     ,←'DO(i,lc){if(zv[0])break;if(lv[i]!=rv[i]){zv[0]=1;break;}}',nl
        exe     ,←pacc'update device(zv[:rslt->c])'
                chk siz exe mxfn 1 ⍺ ⍵}
decd←{        chk     ←'if(lr>1||lv[0]<0)error(16);'
        siz     ←'zr=rr==0?0:rr-1;DO(i,zr){zs[i]=rs[i+1];zc*=rs[i+1];}',nl
        siz     ,←'if(rr>0)rc=rs[0];'
        exen    ←pacc'update host(lv,rv[:rgt->c])'
        exen    ,←'DO(i,zc){zv[i]=0;DO(j,rc){zv[i]=rv[(j*zc)+i]+lv[0]*zv[i];}}',nl
        exen    ,←pacc'update device(zv[:rslt->c])'
        exeb    ←'I rcp=ceil(rgt->c/8.0);',nl
        exeb    ,←pacc'update host(lv,rv[:rcp])'
        exeb    ,←'DO(i,zc){zv[i]=0;DO(j,rc){I ri=(j*zc)+i;',nl
        exeb    ,←'zv[i]=(1&(rv[ri/8]>>(7-(ri%8))))+lv[0]*zv[i];}}',nl
        exeb    ,←pacc'update device(zv[:rslt->c])'
        exe     ←(3=⊃1⌷⍺)⊃exen exeb
                chk siz exe mxfn 1 ⍺ ⍵}

encd←{        chk     ←'if(lr>1)error(16);DO(i,lr)lc*=ls[i];',nl
        chk     ,←pacc'update host(lv[:lc])'
        chk     ,←'DO(i,lc){if(lv[i]<=0)error(16);}'
        siz     ←'zr=1+rr;zs[0]=lc;DO(i,rr)zs[i+1]=rs[i];DO(i,rr)rc*=rs[i];'
        exe     ←simd'collapse(2) present(zv[:rslt->c],rv[:rc],lv[:lc])'
        exe     ,←'DO(i,rc){DO(j,lc){zv[(j*rc)+i]=(rv[i]>>(lc-(j+1)))%2;}}'
                chk siz exe mxfn 1 ⍺ ⍵}

brid←{        chk     ←'if(lr!=1)error(16);DO(i,rr)rc*=rs[i];DO(i,lr)lc*=ls[i];',nl
        chkn    ←pacc'update host(rv[:rc],lv[:lc])'
        chkn    ,←'DO(i,rc)if(rv[i]<0||rv[i]>=ls[0])error(3);'
        chkb    ←'I n=ceil(rc/8.0);',nl
        chkb    ,←pacc'update host(rv[:n],lv[:lc])'
        chkb    ,←'DO(i,n){DO(j,8){if((1&(rv[i]>>(7-j)))>=ls[0])error(3);}}'
        chk     ,←(3≡1⊃⍺)⊃chkn chkb
        siz     ←'zr=rr;DO(i,zr)zs[i]=rs[i];'
        exen    ←(simd'present(zv[:rslt->c],lv[:lc],rv[:rc])'),'DO(i,rc)zv[i]=lv[rv[i]];'
        exeb    ←(simd'present(zv[:rslt->c],lv[:lc],rv[:n])')
        exeb    ,←'DO(i,n){DO(j,8){zv[i*8+j]=lv[1&(rv[i]>>(7-j))];}}'
        exe     ←(3≡1⊃⍺)⊃exen exeb
                chk siz exe mxfn 1 ⍺ ⍵}
:EndNamespace
