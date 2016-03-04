⍝ The Co-dfns Compiler: High-performance, Parallel APL Compiler
⍝ Copyright (c) 2011-2016 Aaron W. Hsu <arcfide@sacrideo.us>
⍝
⍝ This program is free software: you can redistribute it and/or modify
⍝ it under the terms of the GNU Affero General Public License as published by
⍝ the Free Software Foundation, either version 3 of the License, or
⍝ (at your option) any later version.
⍝ 
⍝ This program is distributed in the hope that it will be useful,
⍝ but WITHOUT ANY WARRANTY; without even the implied warranty of
⍝ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
⍝ GNU Affero General Public License for more details.
⍝ 
⍝ You should have received a copy of the GNU Affero General Public License
⍝ along with this program.  If not, see <http://www.gnu.org/licenses/>.
⍝ 
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
Cmp ←{n⊣(⍎COMPILER)⍺⊣(BUILD∆PATH,(dirc⍬),⍺,'_',COMPILER,'.c')put⍨gc tt⊃a n←ps ⍵}
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
cfs←'-funsigned-bitfields -funsigned-char -fvisibility=hidden -std=c11 '
cds←'-DxxBIT=64 -DHAS_UNICODE=1 -DUNIX=1 -DWANT_REFCOUNTS=1 -D_DEBUG=1 '
cio←{'-I',DWA∆PATH,' -o ''',BUILD∆PATH,'/',⍵,'_',⍺,'.so'' '}
fls←{'''',DWA∆PATH,'/dwa_fns.c'' ''',BUILD∆PATH,'/',⍵,'_',⍺,'.c'' '}
log←{'> ',BUILD∆PATH,'/',⍵,'_',⍺,'.log 2>&1'}

⍝  GCC (Linux Only)
gop←'-Ofast -g -Wall -Wno-unused-function -Wno-unused-variable -fPIC -shared '
gcc←{⎕SH'gcc ',cfs,cds,gop,'gcc'(cio,fls,log)⍵}

⍝  Intel C Linux
iop←'-fast -g -fno-alias -static-intel -Wall -Wno-unused-function -fPIC -shared '
icc←{⎕SH'icc ',cfs,cds,iop,'icc'(cio,fls,log)⍵}

⍝  PGI C Linux
pop←' -fast -acc -ta=tesla:nollvm,nordc,cuda7.5 -Minfo -fPIC '
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
prim←(prims←'+-÷×|*⍟⌈⌊!<≤=≠≥>∧∨⍲⍱⌷⍴,⍪⌽⊖⍉∊⊃⍳○~≡≢⊢⊣/⌿\⍀⊤⊥↑↓')_set
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

⍝ Core Compiler
tt←{fd fz ff if ef td vc fs rl av va lt nv fv ce ur fc∘pc⍣≡ ca fe mr dn lf du df rd rn ⍵}
⍝[of]:Utilities
scp     ←(1,1↓Fm)⊂[0]⊢
mnd     ←{A⊣((⍺ ⍺⍺ ⍵)⌿A)←⍺⊣A←⍵⍵ ⍵}
sub     ←{⍺←⊢ ⋄ A⊣(m⌿A)←⍺ ⍺⍺(m←⍺ ⍵⍵ ⍵)⌿A←⍵}
prf     ←((≢↑¯1↓(0≠⊢)(/∘⊢)⊢)⍤1↑∘r)⊢
blg     ←{⍺←⊢ ⋄ ⍺((prf(⌈/(⍳∘≢⊢)×⍤1(1↓⊣)∧.(=∨0=⊢)∘⍉⊢)⍺⍺(⌿∘↑)r)⌷⍤0 2 ⍺⍺(⌿∘⊢)⍵⍵)⍵}
enc     ←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
veo     ←∪((⊂'%u'),(,¨prims),⊣)~⍨∘{⊃,/{⊂⍣(1≡≡⍵)⊢⍵}¨⍵}¯1↓⊢(/⍨)(∧/¨0≠((⊃0⍴⊢)¨⊢))
ndo     ←{⍺←⊢ ⋄ m⊃∘(⊂,⊢)¨⍺∘⍺⍺¨¨⍵⊃∘(,∘⊂⍨⊂)¨⍨m←1≥≡¨⍵}
n2f     ←(⊃,/)((1=≡)⊃,∘⊂⍨∘⊂)¨
⍝[cf]
⍝[of]:Passes
⍝[of]:Record Node Coordinates
rn←⊢,∘↓(1+d)↑⍤¯1(+⍀d∘.=∘⍳1+(⌈/0,d))
⍝[cf]
⍝[of]:Record Function Depths
rd←⊢,(+/↑∘r∧.(=∨0=⊢)∘⍉∘↑∘r Fs)
⍝[cf]
⍝[of]:Drop Unnamed Functions
df←(~(+\1=d)∊((1=d)∧(Om∨Fm)∧0∊⍨n)(/∘⊢)(+\1=d))(⌿∘⊢)⊢
⍝[cf]
⍝[of]:Drop Unreachable Code
dua     ←(Fm∨↓∘prf∊r∘Fs)(⊣(⍀∘⊢)(⊣(⌿∘⊢)0∊⍨n)(0,1↓(¯1⌽⊣)∧⊢=¯1⌽⊢)⊣(⌿∘⊢)d)⊢
du      ←(~dua∨(∨/(prf∧.(=∨0=⊢)∘⍉dua(⌿∘⊢)prf)∧↑∘r∧.≥∘⍉dua(⌿∘⊢)↑∘r×0=prf))(⌿∘⊢)⊢
⍝[cf]
⍝[of]:Lift Functions
lfv     ←⍉∘⍪(1+⊣),'Vf',('fn'enc 4⊃⊢),4↓⊢
lfn     ←('F'≡1⊃⊢)⌷(⊣-⍨∘⊃⊢)((⊂∘⍉∘⍪⊣,1↓⊢),∘⊂(⊣,'Of',3↓⊢)⍪lfv)⊢
lfh     ←(1<(+/⊣))⊃(⊂0↑⊢),∘⊂∘⍉∘⍪1'F'1,('fn'enc⊣),(⊂⊣),5↓∘,1↑⊢
lf      ←(1↑⊢)⍪∘⊃(⍪/(1,1↓Fm)blg(↑r)(⊂lfh⍪∘⊃(⍪/((¯2+1=(+/⊣))+∘⊃⊢)lfn⍤¯1⊢))⌸1↓⊢)
⍝[cf]
⍝[of]:Drop Redundant Nodes
dn←((0∊⍨n)∧(Am∧'v'∊⍨k)∨Om∧'f'∊⍨k)((~⊣)(⌿∘⊢)(d-¯1⌽⊣),1↓[1]⊢)⊢
⍝[cf]
⍝[of]:Mark/Unmark Unit Returns
mre     ←(⊢⍴⍨6,⍨≢×2<≢)(2 'E' 'u',3↓∘,1↑⊢)⍪(3'P'0(,'⊢'),4↓∘,1↑⊢)⍪(1+d),1↓⍤1⊢
mrm     ←∨\(Vm∨Am)∧((¯1+≢)-1⍳⍨∘⌽2=d)=(⍳≢)
mr      ←(⊃⍪/)((1↑⊢),((⊢(⌿⍨∘~⍪∘mre(⌿⍨))mrm)¨1↓⊢))∘scp
ur      ←((2↑⊢),1,('um'enc∘⊃r),4↓⊢)⍤1sub(Em∧'u'∊⍨k)
⍝[cf]
⍝[of]:Flatten Expressions
fen     ←((⊂'fe')(⊃enc)¨((0∊⍨n)∧Em∨Om∨Am)(⌿∘⊢)r)((0∊⍨n)∧Em∨Om∨Am)mnd n⊢
fet     ←('V'0⍴⍨2,⍨(+/0,1↓Em∨Om∨Am))(0,1↓Em∨Om∨Am)mnd(t,∘⍪k)⊢
fee     ←(⍪/⌽)(1,1↓Em∨Om∨Am)blg⊢((⊂(d-⊃-2⌊⊃),fet,fen,4↓⍤1⊢)⍪)⌸1↓⊢
fe      ←(⊃⍪/)(+\Fm)(⍪/(⊂1↑⊢),∘((+\d=⊃)fee⌸⊢)1↓⊢)⌸⊢
⍝[cf]
⍝[of]:Compress Atomic Nodes
can     ←(+\Am∨Om)((,1↑⊢),∘(⊂(¯1+2⌊≢)⊃(⊂∘⊂⊃),⊂)∘n 1↓⊢)⌸⊢
cam     ←Om∧'f'∊⍨k
cas     ←(Am(1↑⊢)⍪(Mm∨Am)blg⊢)∨¯1⌽cam
ca      ←(can (cam∨cas∨Am)(⌿∘⊢)⊢)(Am∨cam)mnd⊢⍬,∘⊂⍨(~cas)(⌿∘⊢)⊢
⍝[cf]
⍝[of]:Propogate Constants
pcc     ←(⊂⊢(⌿⍨)Am∨Om∧'f'∊⍨k)∘((⍳∘∪⍨n)⌷⍤0 2(1⌈≢)↑⊢)∘((1+⊃),1↓⍤1⊢)∘(⊃⍪⌿)∘⌽(⌿∘⊢)
pcs     ←(d,'V','f',(⊃v),r,(⊂⍬),⍨∘⍪s)sub Om
pcv     ←(d,'V','a',(⊃v),r,(⊂⍬),⍨∘⍪s)sub (Am∧'v'∊⍨k)
pcb     ←((,∧.(=∨0=⊣)∘⍪)⍤2 1⍨∘↑∘r(1↑⊢)⍪Fs)pcc⍤1((⊢(⌿⍨)d=1+⊃)¨⊣)
pcd     ←((~(Om∧('f'∊⍨k)∧1≠d)∨Am∧d=1+(∨\Fm))(⌿∘⊢)⊢)∘(⊃⍪/)
pc      ←pcd scp(pcb(pcv∘pcs(((1⌈≢)↑⊢)⊣)⌷⍤0 2⍨(n⊣)⍳n)sub(Vm∧n∊∘n⊣)¨⊣)⊢
⍝[cf]
⍝[of]:Fold Constant Expressions
fce     ←(⊃∘n Ps){⊂⍎' ⍵',⍨(≢⍵)⊃''(⍺,'⊃')('⊃',⍺,'/')⊣⍵}(v As)
fcm     ←(∧/Em∨Am∨Pm)∧'u'≢∘⊃∘⊃k
fc      ←((⊃⍪/)(((d,'An',3↓¯1↓,)1↑⊢),fce)¨sub(fcm¨))('MFOE'∊⍨t)⊂[0]⊢
⍝[cf]
⍝[of]:Compress Expressions
ce←(+\Fm∨Em∨Om)((¯1↓∘,1↑⊢),∘⊂(⊃∘v 1↑⊢),∘((v As)Am mnd n⊢)1↓⊢)⌸⊢
⍝[cf]
⍝[of]:Record Final Return Value
fv←(⊃⍪/)(((1↓⊢)⍪⍨(,1 6↑⊢),∘⊂∘n ¯1↑⊢)¨scp)
⍝[cf]
⍝[of]:Normalize Values Field
nvu     ←⊂'%u' ⋄ nvi      ←⊂'%i'
nvo     ←((¯1↓⊢),({⍺'%b'⍵}/∘⊃v))⍤1sub(Om∧'i'∊⍨k)
nve     ←((¯1↓⊢),({,¨⍺'['⍵}/∘⊃v))⍤1sub(Em∧'i'∊⍨k)
nvk     ←((2↑⊢),2,(3↓⊢))⍤1sub(Em∧'i'∊⍨k)
nv      ←nvk(⊢,⍨¯1↓⍤1⊣)Om((¯1⊖(¯1+≢)⊃(⊂nvu,nvi,⊢),(⊂nvu⍪⊢),∘⊂⊢){⌽⍣⍺⊢⍵})¨v∘nvo∘nve
⍝[cf]
⍝[of]:Lift Type-Checking
⍝[c]Type:     Index   Right   Left            Type Codes:     Value   Type
⍝[c]  0       Unknown Unknown                 Unknown 0
⍝[c]  1       Unknown Integer                 Integer 1
⍝[c]  2       Unknown Float                   Float   2
⍝[c]  3       Unknown Bitvector                       Bitvector       3
⍝[c]  4       Unknown Not bound                       Not bound       4
⍝[c]  5       Integer Unknown
⍝[c]  6       Integer Integer
⍝[c]  7       Integer Float           Operator Codes: Meaning Code
⍝[c]  8       Integer Bitvector                       Left    0
⍝[c]  9       Integer Not bound                       Right   1
⍝[c]  10      Float   Unknown                 Error   ¯N
⍝[c]  11      Float   Integer
⍝[c]  12      Float   Float
⍝[c]  13      Float   Bitvector
⍝[c]  14      Float   Not bound
⍝[c]  15      Bitvector       Unknown
⍝[c]  16      Bitvector       Integer
⍝[c]  17      Bitvector       Float
⍝[c]  18      Bitvector       Bitvector
⍝[c]  19      Bitvector       Not bound
⍝[c]
⍝[of]:Primitive Types
pf1←9 14 19 6 7 8 ⋄ pf2←11 12 13 16 17 18
pn←⍬        ⋄ pt←56 20⍴0
pn,←⊂'%b'   ⋄ pt[00;pf1,pf2]←1 2 3 1 1 1 2 2 2 3 3 3
pn,←⊂'%i'   ⋄ pt[01;pf1,pf2]←1 2 3 1 1 1 2 2 2 3 3 3
pn,←⊂'%u'   ⋄ pt[02;]←20⍴4
⍝[c]
⍝[c]Name      RL:     IN      FN      BN      II      IF      IB
⍝[c]          FI      FF      FB      BI      BF      BB
pn,←⊂,'⍺'
        pt[03;pf1]←   ¯6     ¯6     ¯6     1       2       3
        pt[03;pf2]←   1       2       3       1       2       3
pn,←⊂,'⍵'
        pt[04;pf1]←   1       2       3       1       1       1
        pt[04;pf2]←   2       2       2       3       3       3
pn,←⊂,'+'
        pt[05;pf1]←   1       2       3       1       2       1
        pt[05;pf2]←   2       2       2       1       2       1
pn,←⊂,'-'
        pt[06;pf1]←   1       2       1       1       2       1
        pt[06;pf2]←   2       2       2       1       2       1
pn,←⊂,'÷'
        pt[07;pf1]←   2       2       3       2       2       2
        pt[07;pf2]←   2       2       2       1       2       3
pn,←⊂,'×'
        pt[08;pf1]←   1       1       3       1       2       1
        pt[08;pf2]←   2       2       2       1       2       3
pn,←⊂,'|'
        pt[09;pf1]←   1       2       3       1       2       1
        pt[09;pf2]←   2       2       2       1       2       3
pn,←⊂,'*'
        pt[10;pf1]←   2       2       2       2       2       3
        pt[10;pf2]←   2       2       3       1       2       3
pn,←⊂,'⍟'
        pt[11;pf1]←   2       2       ¯11    2       2       ¯11
        pt[11;pf2]←   2       2       ¯11    ¯11    ¯11    ¯11
pn,←⊂,'⌈'
        pt[12;pf1]←   1       1       3       1       2       1
        pt[12;pf2]←   2       2       2       1       2       3
pn,←⊂,'⌊'
        pt[13;pf1]←   1       1       3       1       2       1
        pt[13;pf2]←   2       2       2       1       2       3
pn,←⊂,'<'
        pt[14;pf1]←   ¯2     ¯2     ¯2     3       3       3
        pt[14;pf2]←   3       3       3       3       3       3
pn,←⊂,'≤'
        pt[15;pf1]←   ¯2     ¯2     ¯2     3       3       3
        pt[15;pf2]←   3       3       3       3       3       3
⍝[c]
⍝[c]Name      RL:     IN      FN      BN      II      IF      IB
⍝[c]          FI      FF      FB      BI      BF      BB
pn,←⊂,'='
        pt[16;pf1]←   ¯2     ¯2     ¯2     3       3       3
        pt[16;pf2]←   3       3       3       3       3       3
pn,←⊂,'≠'
        pt[17;pf1]←   ¯2     ¯2     ¯2     3       3       3
        pt[17;pf2]←   3       3       3       3       3       3
pn,←⊂,'≥'
        pt[18;pf1]←   ¯2     ¯2     ¯2     3       3       3
        pt[18;pf2]←   3       3       3       3       3       3
pn,←⊂,'>'
        pt[19;pf1]←   ¯2     ¯2     ¯2     3       3       3
        pt[19;pf2]←   3       3       3       3       3       3
pn,←⊂,'⌷'
        pt[20;pf1]←   1       2       3       1       ¯11    1
        pt[20;pf2]←   2       ¯11    2       3       ¯11    3
pn,←⊂,'⍴'
        pt[21;pf1]←   1       1       1       1       ¯11    1
        pt[21;pf2]←   2       ¯11    2       3       ¯11    3
pn,←⊂,','
        pt[22;pf1]←   1       2       3       1       2       1
        pt[22;pf2]←   2       2       2       1       2       3
pn,←⊂,'⍳'
        pt[23;pf1]←   1       ¯11    3       1       1       1
        pt[23;pf2]←   1       1       1       1       1       1
pn,←⊂,'○'
        pt[24;pf1]←   2       2       2       2       ¯11    2
        pt[24;pf2]←   2       ¯11    2       2       ¯11    2
pn,←⊂,'~'
        pt[25;pf1]←   ¯11    ¯11    3       1       2       3
        pt[25;pf2]←   1       2       3       1       2       3
pn,←⊂,'['
        pt[26;pf1]←   ¯2     ¯2     ¯2     1       2       3
        pt[26;pf2]←   ¯11    ¯11    ¯11    1       2       3
pn,←⊂,'∧'
        pt[27;pf1]←   ¯2     ¯2     ¯2     1       1       1
        pt[27;pf2]←   1       2       2       1       2       3
pn,←⊂,'∨'
        pt[28;pf1]←   ¯2     ¯2     ¯2     1       2       1
        pt[28;pf2]←   2       2       2       1       2       3
⍝[c]
⍝[c]Name      RL:     IN      FN      BN      II      IF      IB
⍝[c]          FI      FF      FB      BI      BF      BB
pn,←⊂,'⍲'
        pt[29;pf1]←   ¯2     ¯2     ¯2     ¯11    ¯11    ¯11
        pt[29;pf2]←   ¯11    ¯11    ¯11    ¯11    ¯11    3
pn,←⊂,'⍱'
        pt[30;pf1]←   ¯2     ¯2     ¯2     ¯11    ¯11    ¯11
        pt[30;pf2]←   ¯11    ¯11    ¯11    ¯11    ¯11    3
pn,←⊂,'⍪'
        pt[31;pf1]←   1       2       3       1       2       1
        pt[31;pf2]←   2       2       2       1       2       3
pn,←⊂,'⌽'
        pt[32;pf1]←   1       2       3       1       ¯11    1
        pt[32;pf2]←   2       ¯11    2       3       ¯11    3
pn,←⊂,'∊'
        pt[33;pf1]←   1       2       3       3       3       3
        pt[33;pf2]←   3       3       3       3       3       3
pn,←⊂,'⊃'
        pt[34;pf1]←   1       2       3       1       1       1
        pt[34;pf2]←   2       2       2       3       3       3
pn,←⊂,'⊖'
        pt[35;pf1]←   1       2       3       1       1       1
        pt[35;pf2]←   2       2       2       3       3       3
pn,←⊂,'≡'
        pt[36;pf1]←   1       1       1       1       1       1
        pt[36;pf2]←   1       1       1       1       1       1
pn,←⊂,'≢'
        pt[37;pf1]←   1       1       1       1       1       1
        pt[37;pf2]←   1       1       1       1       1       1
pn,←⊂,'⊢'
        pt[38;pf1]←   1       2       3       1       1       1
        pt[38;pf2]←   2       2       2       3       3       3
pn,←⊂,'⊣'
        pt[39;pf1]←   1       2       3       1       2       3
        pt[39;pf2]←   1       2       3       1       2       3
pn,←⊂'//'
        pt[40;pf1]←   ¯2     ¯2     ¯2     1       ¯11    1
        pt[40;pf2]←   2       ¯11    2       3       ¯11    3
pn,←⊂,'⍉'
        pt[41;pf1]←   1       2       3       1       1       1
        pt[41;pf2]←   2       2       2       3       3       3
⍝[c]
⍝[c]Name      RL:     IN      FN      BN      II      IF      IB
⍝[c]          FI      FF      FB      BI      BF      BB
pn,←⊂,'↑'
        pt[42;pf1]←   1       2       3       1       1       1
        pt[42;pf2]←   2       2       2       3       3       3
pn,←⊂,'↓'
        pt[43;pf1]←   1       2       3       1       1       1
        pt[43;pf2]←   2       2       2       3       3       3
pn,←⊂,'⊤'
        pt[44;pf1]←   ¯2     ¯2     ¯2     1       ¯16    1
        pt[44;pf2]←   ¯16    ¯16    ¯16    3       3       3
pn,←⊂,'⊥'
        pt[45;pf1]←   ¯2     ¯2     ¯2     1       ¯16    1
        pt[45;pf2]←   ¯16    ¯16    ¯16    1       ¯16    1
pn,←⊂,'¨'
        pt[46;pf1]←   0       0       0       0       0       0
        pt[46;pf2]←   0       0       0       0       0       0
pn,←⊂,'⍨'
        pt[47;pf1]←   0       0       0       0       0       0
        pt[47;pf2]←   0       0       0       0       0       0
pn,←⊂,'/'
        pt[48;pf1]←   0       0       0       0       ¯11    0
        pt[48;pf2]←   0       ¯11    0       0       ¯11    0
pn,←⊂,'⌿'
        pt[49;pf1]←   0       0       0       0       ¯11    0
        pt[49;pf2]←   0       ¯11    0       0       ¯11    0
pn,←⊂,'\'
        pt[50;pf1]←   0       0       0       ¯11    ¯11    ¯11
        pt[50;pf2]←   ¯11    ¯11    ¯11    ¯11    ¯11    ¯11
pn,←⊂,'⍀'
        pt[51;pf1]←   0       0       0       ¯11    ¯11    ¯11
        pt[51;pf2]←   ¯11    ¯11    ¯11    ¯11    ¯11    ¯11
pn,←⊂'∘.'
        pt[52;pf1]←   ¯2     ¯2     ¯2     0       0       0
        pt[52;pf2]←   0       0       0       0       0       0
pn,←⊂,'.'
        pt[53;pf1]←   ¯2     ¯2     ¯2     0       0       0
        pt[53;pf2]←   0       0       0       0       0       0
pn,←⊂'⎕sp'
        pt[54;pf1]←   ¯2     ¯2     ¯2     ¯11    ¯11    1
        pt[54;pf2]←   ¯11    ¯11    ¯11    ¯11    ¯11    ¯11
⍝[c]
⍝[c]Name      RL:     IN      FN      BN      II      IF      IB
⍝[c]          FI      FF      FB      BI      BF      BB
pn,←⊂'⎕XOR'
        pt[55;pf1]←   ¯2     ¯2     ¯2     1       ¯16    ¯16
        pt[55;pf2]←   ¯16    ¯16    ¯16    ¯16    ¯16    ¯16
⍝[cf]
⍝[of]:Operator Indirections
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
⍝[cf]
⍝[of]:Allocate Value Slots
val     ←(n⍳∘∪n),¨⊢(⊢+(≢⊣)×0=⊢)(⌈/(⍳≢)×⍤1(∪n)∘.((⊂⊣)∊⊢)(n2f¨v))
vag     ←∧∘~∘(∘.=⍨∘⍳≢)⍨(∘.(((1⌷⊢)>0⌷⊣)∧(0⌷⊢)<1⌷⊣)⍨val)
vae     ←(∪n)(⊣,⍤0⊣(⌷⍨⍤1 0)∘⊃((⊢,(⊃(⍳∘≢⊣)~((≢⊢)↑⊣)(/∘⊢)⊢))/∘⌽(⊂⍬),∘↓⊢))vag
vac     ←(((0⌷∘⍉⊣)⍳∘⊂⊢)⊃(1⌷∘⍉⊣),∘⊂⊢)ndo
va      ←((⊃⍪/)(1↑⊢),(((vae Es)(d,t,k,(⊣vac n),r,s,y,∘⍪⍨(⊂⊣)vac¨v)⊢)¨1↓⊢))scp
⍝[cf]
⍝[of]:Anchor Variables to Values
avb     ←{(((,¨'⍺⍵')↑⍨1↓⍴)⍪⊢)⍺⌷⍨⍤2 0⊢⍺⍺⍳⍺⍺∩⍨(↓(⌽1+∘⍳0⍳⍨⊢)((≢⊢)↑↑)⍤0 1⊢)⊃r ⍵}
avi     ←¯1 0+(⍴⊣)⊤(,⊣)⍳(⊂⊢)
avh     ←{⊂⍵,(n⍵)((⍺⍺(⍵⍵ avb)⍵){⍺⍺ avi ndo(⊂⍺),⍵})¨v⍵}
av      ←(⊃⍪/)(+\Fm){⍺((⍺((∪∘⌽n)Es)⌸⍵)avh(r(1↑⍵)⍪Fs ⍵))⌸⍵}⊢
⍝[cf]
⍝[of]:Record Live Variables
rlf     ←(⌽↓(((1⊃⊣)∪⊢~0⌷⊣)/∘⌽(⊂⍬),↑)⍤0 1⍨1+∘⍳≢)(⊖1⊖n,⍤0(⊂⊣)veo¨v)
rl      ←⊢,∘(⊃,/)(⊂∘n Os⍪Fs)rlf¨scp
⍝[cf]
⍝[of]:Fuse Scalar Loops
fsf     ←(∪∘⊃,/)(⊂⊂⍬ ⍬ ⍬),(⌽¯1↓⊢)¨~¨(⊂,⊂'%u'(4⍴⍨≢⍉pt)(¯1 0))∪¨∘(⍳∘≢↑¨⊂)⊣
fsn     ←↓n,((,1↑⊢)¨y),⍤0(⊃¨e)
fsv     ←v(↓,∘⊃⍤0)¨((↓1↓⊢)¨y)(↓,⍤0)¨1↓¨e
fsh     ←(⍉⍪)2'S'0 ⍬ ⍬ 0,(((⊂0⌷⊢),(⊂∘↑1⌷⊢),(⊂2⌷⊢))∘⍉1↓∘↑fsn fsf fsv),∘l ¯1↑⊢
fsm     ←Em∧(1∊⍨k)∧(,¨'~⌷')∊⍨(⊃∘⌽¨v)
fss     ←fsm∨Em∧(1 2∊⍨k)∧((⊂'⎕XOR'),⍨,¨'+-×÷|⌊⌈*⍟○!∧∨⍱⍲<≤=≥>≠')∊⍨(⊃∘⌽¨v)
fsx     ←(⊣(/∘⊢)fss∧⊣)(⊣⊃(⊂⊢),(⊂fsh⍪(1+d),'E',0,3↓⍤1⊢))¨⊂[0]
fs      ←(⊃⍪/)(((((⊃⍪/)(⊂0 10⍴⍬),((2≠/(~⊃),⊢)fss)fsx⊢)Es)⍪⍨(~Em)(⌿∘⊢)⊢)¨scp)
⍝[cf]
⍝[of]:Compress Scalar Expressions
vc←(⊃⍪/)(((1↓⊢)⍪⍨(1 6↑⊢),(≢∘∪∘n Es),1 ¯3↑⊢)¨scp)
⍝[cf]
⍝[of]:Type Dispatch/Specialization
tdn     ←'ii' 'if' 'ib' 'in' 'fi' 'ff' 'fb' 'fn' 'bi' 'bf' 'bb' 'bn'
tdi     ←6 7 8 9 11 12 13 14 16 17 18 19
tde     ←((¯3↓⊢),(Om⌷y,⍨∘⊂(tdi⌷⍨⊣)⌷∘⍉∘⊃y),¯2↑⊢)⍤1
tdf     ←(1↓⊢)⍪⍨(,1 3↑⊢),(⊂(⊃n),tdn⊃⍨⊣),(4↓∘,1↑⊢)
td      ←((⊃⍪/)(1↑⊢),∘(⊃,/)(((⍳12)(⊣tdf tde)¨⊂)¨1↓⊢))scp
⍝[cf]
⍝[of]:Convert Error Functions
eff     ←(⊃⍪/)⊢(((⊂∘⍉∘⍪d,'Fe',3↓,)1↑⊣),1↓⊢)(d=∘⊃d)⊂[0]⊢
ef      ←(Fm∧¯1=∘×∘⊃¨y)((⊃⍪/)(⊂⊢(⌿⍨)∘~(∨\⊣)),(eff¨⊂[0]))⊢
⍝[cf]
⍝[of]:Create Initializer for Globals
ifn     ←1 'F' 0 'Init' ⍬ 0,(4⍴0) ⍬ ⍬,⍨⊢
if      ←(1↑⊢)⍪(⊢(⌿⍨)Om∧1=d)⍪((up⍪⍨∘ifn∘≢∘∪n)⊢(⌿⍨)Em∧1=d)⍪(∨\Fm)(⌿∘⊢)⊢
⍝[cf]
⍝[of]:Flatten Functions
fft     ←(,1↑⊢)(1 'Z',(2↓¯5↓⊣),(v⊣),n,y,(⊂2↑∘,∘⊃∘⊃e),l)(¯1↑⊢)
ff      ←((⊃⍪/)(1↑⊢),(((1↑⊢)⍪(((¯1+d),1↓⍤1⊢)1↓⊢)⍪fft)¨1↓⊢))scp
⍝[cf]
⍝[of]:Flatten Scalar Groups
fzh     ←((∪n)∩(⊃∘l⊣))(¯1⌽(⊂⊣),((≢⊢)-1+(⌽n)⍳⊣)((⊂⊣⊃¨∘⊂(⊃¨e)),(⊂⊣⊃¨∘⊂(⊃¨y)),∘⊂⊣)⊢)⊢
fzf     ←0≠(≢∘⍴¨∘⊃∘v⊣)
fzb     ←(((⊃∘v⊣)(⌿⍨)fzf),n),∘⍪('f'∘,∘⍕¨∘⍳(+/fzf)),('s'∘,∘⍕¨∘⍳∘≢⊢)
fzv     ←((⊂⊣)(⊖↑)⍨¨(≢⊣)(-+∘⍳⊢)(≢⊢))((⊢,⍨1⌷∘⍉⊣)⌷⍨(0⌷∘⍉⊣)⍳⊢)⍤2 0¨v
fze     ←(¯1+d),t,k,fzb((⊢/(-∘≢⊢)↑⊣),r,s,fzv,y,e,∘⍪l)⊢
fzs     ←(,1↑⊢)(1⊖(⊣((1 'Y',(2⌷⊣),⊢)⍪∘⍉∘⍪(3↑⊣),⊢)1⌽fzh,¯1↓6↓⊣)⍪fze)(⌿∘⊢)
fz      ←((⊃⍪/)(1↑⊢),(((2=d)(fzs⍪(1↓∘~⊣)(⌿∘⊢)1↓⊢)⊢)¨1↓⊢))(1,1↓Sm)⊂[0]⊢
⍝[cf]
⍝[of]:Create Function Declarations
fd←(1↑⊢)⍪((1,'Fd',3↓⊢)⍤1 Fs)⍪1↓⊢
⍝[cf]
⍝[cf]
⍝[cf]
⍝[of]:Code Generator
dis     ←{⍺←⊢ ⋄ 0=⊃t⍵:5⍴⍬ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}
gc      ←{((⊃,/)⊢((fdb⍪⍨∘(dis⍤1)(⌿⍨))(⊂dis)⍤2 1(⌿⍨∘~))(Om∧1 2 'i'∊⍨k))⍵}
E1      ←{r u f←⊃v⍵ ⋄ (2↑⊃y⍵)(f fcl ⍺)(⊃n⍵)r,⍪2↑⊃e⍵}
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
⍝[cf]

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝ Runtime Code

⍝  Runtime Utilities
nl   ←⎕UCS 13 10
enc  ←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
fvs  ←,⍤0(⌿⍨)0≠(≢∘⍴¨⊣)
cln  ←'¯'⎕R'-'
var  ←{⍺≡,'⍺':,'l' ⋄ ⍺≡,'⍵':,'r' ⋄ ¯1≥⊃⍵:,⍺ ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
dnv  ←{(0≡z)⊃('A ',⍺,'[',(⍕z←⊃v⍵),'];')('A*',⍺,'=NULL;')}
reg  ←{'DO(i,',(⍕⊃v⍵),')',⍺,'[i].v=NULL;'}
fnv  ←{'A*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
git  ←{⍵⊃¨⊂'/* XXX */ aplint32 ' 'aplint32 ' 'double ' 'U8 ' '?type? '}
gie  ←{⍵⊃¨⊂'/* XXX */ APLLONG' 'APLLONG' 'APLDOUB' 'APLBOOL' 'APLNA'}
pacc ←{('pg'≡2↑COMPILER)⊃''('#pragma acc ',⍵,nl)}
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
⍝[cf]
⍝[of]:Scalar Primitives
⍝respos←'⍵ % ⍺'
respos  ←'fmod((D)⍵,(D)⍺)'
resneg  ←'⍵-⍺*floor(((D)⍵)/(D)(⍺+(0==⍺)))'
residue ←'(0==⍺)?⍵:((0<=⍺&&0<=⍵)?',respos,':',resneg,')'

sdb←0 5⍴⊂'' ⋄ scl←{cln ((≢⍵)↑,¨'⍵⍺')⎕R(scln∘⍕¨⍵) ⊃⍺⌷⍨((⊂⍺⍺)⍳⍨0⌷⍉⍺),≢⍵}
⍝[c]
⍝[c]Prim      Monadic Dyadic  Monadic Bool    Dyadic Bool
sdb⍪←,¨'+' '⍵'   '⍺+⍵'       '⍵'   '⍺+⍵'
sdb⍪←,¨'-' '-1*⍵'        '⍺-⍵'       '-1*⍵'        '⍺-⍵'
sdb⍪←,¨'×'        '(⍵>0)-(⍵<0)'       '⍺*⍵'       '⍵'   '⍺&⍵'
sdb⍪←,¨'÷'        '1.0/⍵'       '((D)⍺)/((D)⍵)'     '⍵'   '⍺&⍵'
sdb⍪←,¨'*' 'exp((D)⍵)'   'pow((D)⍺,(D)⍵)'    'exp((double)⍵)'      '⍺|~⍵'
sdb⍪←,¨'⍟'       'log((D)⍵)'   'log((D)⍵)/log((D)⍺)'       ''      ''
sdb⍪←,¨'|' 'fabs(⍵)'     residue '⍵'   '⍵&(⍺^⍵)'
sdb⍪←,¨'○'       'PI*⍵'        'error(16)'     'PI*⍵'        'error(16)'
sdb⍪←,¨'⌊'       'floor((double)⍵)'    '⍺ < ⍵ ? ⍺ : ⍵' '⍵'   '⍺&⍵'
sdb⍪←,¨'⌈'       'ceil((double)⍵)'     '⍺ > ⍵ ? ⍺ : ⍵' '⍵'   '⍺|⍵'
sdb⍪←,¨'<' 'error(99)'     '⍺<⍵'       'error(99)'     '(~⍺)&⍵'
sdb⍪←,¨'≤'       'error(99)'     '⍺<=⍵'      'error(99)'     '(~⍺)|⍵'
sdb⍪←,¨'=' 'error(99)'     '⍺==⍵'      'error(99)'     '(⍺&⍵)|((~⍺)&(~⍵))'
sdb⍪←,¨'≥'       'error(99)'     '⍺>=⍵'      'error(99)'     '⍺|(~⍵)'
sdb⍪←,¨'>' 'error(99)'     '⍺>⍵'       'error(99)'     '⍺&(~⍵)'
sdb⍪←,¨'≠'       'error(99)'     '⍺!=⍵'      'error(99)'     '⍺^⍵'
sdb⍪←,¨'~' '0==⍵'        'error(16)'     '~⍵'  'error(16)'
sdb⍪←,¨'∧'       'error(99)'     'lcm(⍺,⍵)'  'error(99)'     '⍺&⍵'
sdb⍪←,¨'∨'       'error(99)'     'gcd(⍺,⍵)'  'error(99)'     '⍺|⍵'
sdb⍪←,¨'⍲'       'error(99)'     '!(⍺ && ⍵)' 'error(99)'     '~(⍺&⍵)'
sdb⍪←,¨'⍱'       'error(99)'     '!(⍺ || ⍵)' 'error(99)'     '~(⍺|⍵)'
sdb⍪←,¨'⌷'       '⍵'   'error(99)'     '⍵'   'error(99)'
sdb⍪←'⎕XOR'       'error(99)'     '⍺ ^ ⍵'     'error(99)'     '⍺ ^ ⍵'
⍝[cf]
⍝[of]:Scalar Loop Generators
simp    ←{' present(',(⊃{⍺,',',⍵}/'d',∘⍕¨⍳≢var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵),')'}
sima    ←{{' copyin(',(⊃{⍺,',',⍵}/⍵),')'}⍣(0<a)⊢'d',∘⍕¨(+/~m)+⍳a←≢⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
simr    ←{' present(',(⊃{⍺,',',⍵}/'r',∘⍕¨⍳≢⊃n⍵),')'}
simc    ←{fv←(⊃v⍵)fvs(⊃e⍵) ⋄ ' independent ',(simp fv),(sima fv),simr ⍵}
slpd    ←'I n=ceil(cnt/8.0);',nl
slp     ←{slpd,(simd simc ⍵),'DO(i,n){',nl,⊃,/(1⌷⍉(⊃v⍵)fvs(⊃y⍵))sip¨⍳≢(⊃v⍵)fvs(⊃e⍵)}
rk0     ←'I prk=0;B sp[15];B cnt=1;',nl
rk1     ←'if(prk!=(' ⋄ rk2←')->r){if(prk==0){',nl
rsp     ←{'prk=(',⍵,')->r;',nl,'DO(i,prk) sp[i]=(',⍵,')->s[i];'}
rk3     ←'}else if((' ⋄ rk4←')->r!=0)error(4);',nl
spt     ←{'if(sp[i]!=(',⍵,')->s[i])error(4);'}
rkv     ←{rk1,⍵,rk2,(rsp ⍵),rk3,⍵,rk4,'}else{',nl,'DO(i,prk){',(spt ⍵),'}}',nl}
rk5     ←'if(prk!=1){if(prk==0){prk=1;sp[0]='
rka     ←{rk5,l,';}else error(4);}else if(sp[0]!=',(l←⍕≢⍵),')error(4);',nl}
crk     ←{⍵((⊃,/)((rkv¨var/)⊣(⌿⍨)(~⊢)),(rka¨0⌷∘⍉(⌿⍨)))0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵}
srk     ←{crk(⊃v⍵)(,⍤0(⌿⍨)0≠(≢∘⍴¨⊣))(⊃e⍵)}
ste     ←{'cpaa(',⍵,',&p',(⍕⍺),');',nl}
stsn    ←{⊃,/((⍳8){'r',(⍕⍵),'[i*8+',(⍕⍺),']='}¨⍺),¨(⍳8){'s',(⍕⍵),'_',(⍕⍺),';',nl}¨⍵}
sts     ←{i t←⍵ ⋄ 3≡t:'r',(⍕⍺),'[i]=s',(⍕i),';',nl ⋄ ⍺ stsn i}
rkp     ←{'I m',(⍕⊃⌽⍺),'=(',(⍕⍵),')->r==0?0:1;',nl}
gdp     ←{(⊃git ⊃⍺),'*restrict d',(⍕⊃⌽⍺),'=(',⍵,')->v;',nl}
gda     ←{'d',(⍕⍺),'[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl,'B m',(⍕⍺),'=1;',nl}
sfa     ←{(git m/⍺),¨{((+/~m)+⍳≢⍵)gda¨⍵}⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfp     ←{(m⌿⍺){(⍺,¨⍳≢⍵)(gdp,rkp)¨⍵}var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfv     ←(1⌷∘⍉(⊃v)fvs(⊃y))((⊃,/)sfp,sfa)(⊃v)fvs(⊃e)
ack     ←{'ai(&p',(⍕⍺),',prk,sp,',(⍕⍺⌷⍺⍺),');',nl}
gpp     ←{⊃,/{'A p',(⍕⍵),';p',(⍕⍵),'.v=NULL;',nl}¨⍳≢⍵}
grs     ←{(⊃git ⍺),'*restrict r',(⍕⍵),'=p',(⍕⍵),'.v;',nl}
spp     ←(⊃s){(gpp⍵),(⊃,/(⍳≢⍵)(⍺ ack)¨⍵),(⊃,/⍺ grs¨⍳≢⍵)}(⊃n)var¨(⊃r)
sip←{ w←⍕⍵
        3≡⍺:        (⊃git ⍺),'f',w,'=d',w,'[i*m',w,'];',nl
                ⊃,/(⍕¨⍳8)((⊃git ⍺){⍺⍺,'f',⍵,'_',⍺,'=d',⍵,'[(i*8+',⍺,')*m',⍵,'];',nl})¨⊂w}
⍝[cf]
⍝[of]:Scalar Expression Generators
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
⍝[cf]
⍝[of]:Scalar/Mixed Conversion
mxsm←{        siz     ←'zr=rr;DO(i,zr){zc*=rs[i];zs[i]=rs[i];}'
        exe     ←(simd''),'DO(i,zc){zv[i]=',(,'⍵')⎕R'rv[i]'⊢⍺⍺,';}'
                '' siz exe mxfn 1 ⍺ ⍵}
mxsd←{        chk     ←'if(lr==rr){DO(i,lr){if(rs[i]!=ls[i])error(5);}}',nl
        chk     ,←'else if(lr!=0&&rr!=0){error(4);}'
        siz     ←'if(rr==0){zr=lr;DO(i,lr){zc*=ls[i];lc*=ls[i];zs[i]=ls[i];}}',nl
        siz     ,←'else{zr=rr;DO(i,rr){zc*=rs[i];rc*=rs[i];zs[i]=rs[i];}DO(i,lr)lc*=ls[i];}',nl
        exe     ←simd 'pcopyin(lv[:lc],rv[:rc])'
        exe     ,←'DO(i,zc){zv[i]=',(,¨'⍺⍵')⎕R'lv[i\%lc]' 'rv[i\%rc]'⊢⍺⍺,';}'
                chk siz exe mxfn 1 ⍺ ⍵}
scmx←{        (⊂⍺⍺)∊0⌷⍉sdb:(⊃⍵),'=',';',⍨sdb(⍺⍺ scl)1↓⍵ ⋄ ⍺(⍺⍺ fcl ⍵⍵)⍵,⍤0⊢⊂2⍴¯1}
sdbm    ←(0⌷⍉sdb),'mxsm' 'mxsd' 'mxbm' 'mxbd' {'(''',⍵,'''',⍺,')'}¨⍤1⊢⍉1↓⍉sdb
⍝[cf]
⍝[of]:Primitive Operators
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

⍝[of]:Commute
comd    ←{((1↑⍺)⍪⊖1↓⍺)((⊃⍺⍺)fcl(⍵⍵⍪sdbm))(1↑⍵)⍪⊖1↓⍵}
comm    ←{((1↑⍺)⍪⍪⍨1↓⍺)((⊃⍺⍺)fcl(⍵⍵⍪sdbm))(1↑⍵)⍪⍪⍨1↓⍵}
⍝[cf]
⍝[of]:Each
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
⍝[cf]
⍝[of]:Reduce
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
⍝[cf]
⍝[of]:Reduce N-wise
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
⍝[cf]
⍝[of]:Reduce First Axis
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
⍝[cf]
⍝[of]:Scan
scnm←{        siz     ←'zr=rr;rc=rr==0?1:rs[rr-1];DO(i,zr)zs[i]=rs[i];',nl
        siz     ,←'I n=zr==0?0:zr-1;DO(i,n)zc*=rs[i];'
        val     ←'zv[(i*rc)+j+1]' 'zv[(i*rc)+j]' 'rv[(i*rc)+j+1]'
        exe     ←pacc'update host(zv[:rslt->c],rv[:rgt->c])'
        exe     ,←'if(rc!=0){DO(i,zc){zv[i*rc]=rv[i*rc];',nl
        exe     ,←' L n=rc-1;DO(j,n){'
        exe     ,←((⊂⊃⍺⍺)∊0⌷⍉sdb)⊃(nl,pacc'update device(zv[(i*rc)+j:1])')''
        exe     ,←(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
        exe     ,←pacc'update device(zv[:rslt->c],rv[:rgt->c])'
                '' siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Scan First Axis
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
⍝[cf]
⍝[of]:Outer Product
oupd←{        siz     ←'zr=lr+rr;DO(i,lr)zs[i]=ls[i];DO(i,rr)zs[i+lr]=rs[i];'
        scl     ←(⊂⊃⍺⍺)∊0⌷⍉sdb
        cpu     ←pacc'update host(lv[:lft->c],rv[:rgt->c])'
        gpu     ←simd'present(rv[:rgt->c],lv[:lft->c])'
        exe     ←'DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
        exe     ,←scl⊃cpu gpu
        exe     ,←'DO(i,lc){DO(j,rc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[(i*rc)+j]' 'rv[j]' 'lv[i]'),'}}',nl
        exe     ,←scl⊃(pacc'update device(zv[:rslt->c])')''
                '' siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Inner Product
inpd←{        idf     ←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
        hid     ←idf∊⍨⊃0⊃⍺⍺
        idv     ←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
        chk     ←'if(rr!=0&&lr!=0){',nl
        chk     ,←'if(ls[lr-1]!=rs[0])error(5);',nl
        chk     ,←(hid⊃('if(rs[0]==0)error(11);',nl)''),'}'
        siz     ←'zr=0;if(lr>0){zr=lr-1;DO(i,zr)zs[i]=ls[i];}',nl
        siz     ,←'if(rr>0){I n=rr-1;DO(i,n){zs[i+zr]=rs[i+1];}zr+=rr-1;}'
        typ     ←2⌷(4 5⊥2↑1↓⍺)⌷⍉2⊃⍺⍺
        exe     ←'I n=lr==0?0:lr-1;DO(i,n)zc*=ls[i];n=rr==0?0:rr-1;DO(i,n)rc*=rs[i+1];',nl
        exe     ,←'if(lr!=0)lc=ls[lr-1];else if(rr!=0)lc=rs[0];',nl,(⊃git typ),'tmp[1];',nl
        exe     ,←hid⊃(pacc'enter data create(tmp[:1])')''
        exe     ,←'BOUND lz,rz;lz=lr==0?1:zc*lc;rz=rr==0?1:rc*lc;',nl
        exe     ,←pacc'update host(lv[:lz],rv[:rz])'
        exe     ,←hid⊃''('L m=zc*rc;DO(i,m){zv[i]=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';}')
        stp rng ←hid⊃('2' 'lc-1')('1' 'lc')
        arg1    ←'tmp[0]'('rv[(((lc-(j+',stp,'))*rc)+k)%rz]')('lv[((i*lc)+(lc-(j+',stp,')))%lz]')
        arg2    ←'zv[(i*rc)+k]' 'zv[(i*rc)+k]' 'tmp[0]'
        fil     ←'zv[(i*rc)+j]' 'rv[(((lc-1)*rc)+j)%rz]' 'lv[((i*lc)+(lc-1))%lz]'
        exe     ,←'DO(i,zc){',hid⊃('DO(j,rc){',(⍺((1⊃⍺⍺)scmx ⍵⍵)fil),'}',nl)''
        exe     ,←hid⊃(pacc'update device(zv[:rslt->c])')''
        exe     ,←' L n=',rng,';DO(j,n){DO(k,rc){',nl
        exe     ,←((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)arg1),nl
        exe     ,←hid⊃(pacc'update device(tmp[:1])')''
        exe     ,←((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)arg2)
        exe     ,←(hid⊃(pacc'update device(zv[(i*rc)+k:1])')''),'}}}',nl
        exe     ,←hid⊃(pacc'exit data delete(tmp[:1])')''
        exe     ,←pacc'update device(zv[:rslt->c])'
                chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[cf]
⍝[of]:Horrible Hacks
sopid←{       siz     ←'zr=(lr-1)+rr;zs[0]=ls[0];DO(i,zr-1)zs[i+1]=rs[i];'
        exe     ←'zc=zs[0];rc=rs[0];lc=ls[rr-1];',nl
        exe     ,←'B szz=rslt->c,szr=rgt->c,szl=ceil(lft->c/8.0);',nl
        exe     ,←simd'independent collapse(3) present(zv[:szz],rv[:szr],lv[:szl])'
        exe     ,←'DO(i,zc){DO(j,rc){DO(k,lc){I li=(i*lc)+k;',nl
        exe     ,←'zv[(i*rc*lc)+(j*lc)+k]=(1&(lv[li/8]>>(7-(li%8))))*rv[(j*lc)+k];',nl
        exe     ,←'}}}'
                '' siz exe mxfn 1 ⍺ ⍵}

 ⍝ Lamination
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
⍝[cf]
⍝[of]:Runtime Header
⍝[of]:Includes, Structures, Allocation
rth     ←'#include <math.h>',nl,'#include <stdio.h>',nl,'#include <string.h>',nl
rth     ,←'#ifdef _OPENACC',nl
rth     ,←'#include <accelmath.h>',nl,'extern unsigned int __popcnt (unsigned int);',nl
rth     ,←'#endif',nl
rth     ,←'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
rth     ,←'int isinit=0;',nl
rth     ,←'#define PI 3.14159265358979323846',nl,'typedef BOUND B;'
rth     ,←'typedef long long int L;typedef aplint32 I;typedef double D;typedef void V;',nl
rth     ,←'typedef unsigned char U8;',nl
rth     ,←'struct array {I r; B s[15];I f;B c;B z;V*v;};',nl,'typedef struct array A;',nl
rth     ,←'#define DO(i,n) for(L i=0;i<(n);i++)',nl,'#define R return',nl
rth     ,←'V EXPORT frea(A*a){if (a->v!=NULL){char*v=a->v;B z=a->z;',nl
rth     ,←' if(a->f){',nl,'#ifdef _OPENACC',nl
rth     ,←'#pragma acc exit data delete(v[:z])',nl,'#endif',nl,'}',nl
rth     ,←' if(a->f>1){free(v);}}}',nl
rth     ,←'V aa(A*a,I tp){frea(a);B c=1;DO(i,a->r)c*=a->s[i];B z=0;',nl
rth     ,←' B pc=8*ceil(c/8.0);',nl
rth     ,←' switch(tp){',nl
rth     ,←'  case 1:z=sizeof(I)*pc;break;',nl
rth     ,←'  case 2:z=sizeof(D)*pc;break;',nl
rth     ,←'  case 3:z=ceil((sizeof(U8)*pc)/8.0);break;',nl
rth     ,←'  default: error(16);}',nl
rth     ,←' z=4*ceil(z/4.0);char*v=malloc(z);if(NULL==v)error(1);',nl
rth     ,←' #ifdef _OPENACC',nl,'  #pragma acc enter data create(v[:z])',nl,' #endif',nl
rth     ,←' a->v=v;a->z=z;a->c=c;a->f=2;}',nl
rth     ,←'V ai(A*a,I r,B *s,I tp){a->r=r;DO(i,r)a->s[i]=s[i];aa(a,tp);}',nl
rth     ,←'V fe(A*e,I c){DO(i,c){frea(&e[i]);}}',nl
⍝[cf]
⍝[of]:Co-dfns/Dyalog Conversion
rth     ,←'V cpad(LOCALP*d,A*a,I t){getarray(t,a->r,a->s,d);B z=0;',nl
rth     ,←' switch(t){',nl,'  case APLLONG:z=a->c*sizeof(I);break;',nl
rth     ,←'  case APLDOUB:z=a->c*sizeof(D);break;',nl
rth     ,←'  case APLBOOL:z=ceil(a->c/8.0)*sizeof(U8);break;',nl
rth     ,←'  default:error(11);}',nl
rth     ,←' #ifdef _OPENACC',nl,'  char *v=a->v;',nl
rth     ,←'  #pragma acc update host(v[:z])',nl,' #endif',nl
rth     ,←' memcpy(ARRAYSTART(d->p),a->v,z);}',nl
rth     ,←'V cpda(A*a,LOCALP*d){if(TYPESIMPLE!=d->p->TYPE)error(16);frea(a);',nl
rth     ,←' I r=a->r=d->p->RANK;B c=1;DO(i,r){c*=a->s[i]=d->p->SHAPETC[i];};a->c=c;',nl
rth     ,←' switch(d->p->ELTYPE){',nl
rth     ,←'  case APLLONG:a->z=c*sizeof(I);a->f=1;a->v=ARRAYSTART(d->p);break;',nl
rth     ,←'  case APLDOUB:a->z=c*sizeof(D);a->f=1;a->v=ARRAYSTART(d->p);break;',nl
rth     ,←'  case APLINTG:a->z=c*sizeof(I);a->f=2;',nl
rth     ,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth     ,←'   {aplint16 *restrict s=ARRAYSTART(d->p);I *restrict t=a->v;',nl
rth     ,←'   DO(i,c)t[i]=s[i];};break;',nl
rth     ,←'  case APLSINT:a->z=c*sizeof(I);a->f=2;',nl
rth     ,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth     ,←'   {aplint8 *restrict s=ARRAYSTART(d->p);I *restrict t=a->v;',nl
rth     ,←'   DO(i,c)t[i]=s[i];};break;',nl
rth     ,←'  case APLBOOL:a->z=ceil(c/8.0)*sizeof(U8);a->f=1;',nl
rth     ,←'   a->v=ARRAYSTART(d->p);break;',nl
rth     ,←'  default:error(16);}',nl
rth     ,←' #ifdef _OPENACC',nl,' char *vc=a->v;B z=a->z;',nl
rth     ,←' #pragma acc enter data pcopyin(vc[:z])',nl,' #endif',nl,'}',nl
rth     ,←'V cpaa(A*t,A*s){frea(t);memcpy(t,s,sizeof(A));}',nl
⍝[cf]
⍝[of]:External Makers, Extractors
rth     ,←'EXPORT V*mkarray(LOCALP*da){A*aa=malloc(sizeof(A));if(aa==NULL)error(1);',nl
rth     ,←' aa->v=NULL;cpda(aa,da);return aa;}',nl
rth     ,←'V EXPORT exarray(LOCALP*da,A*aa,I at){I tp=0;',nl
rth     ,←' switch(at){',nl
rth     ,←'  case 1:tp=APLLONG;break;',nl
rth     ,←'  case 2:tp=APLDOUB;break;',nl
rth     ,←'  case 3:tp=APLBOOL;break;',nl
rth     ,←'  default:error(11);}',nl
rth     ,←' cpad(da,aa,tp);frea(aa);}',nl
⍝[cf]
⍝[of]:Scalar Helpers
rth     ,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth     ,←'D gcd(D an,D bn){D a=fabs(an);D b=fabs(bn);',nl
rth     ,←' for(;b>1e-10;){D n=fmod(a,b);a=b;b=n;};R a;}',nl
rth     ,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth     ,←'D lcm(D a,D b){D n=a*b;D z=fabs(n)/gcd(a,b);',nl
rth     ,←' if(a==0&&b==0)R 0;if(n<0)R -1*z;R z;}',nl

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
 ref←'rslt->r=zr;DO(i,zr){rslt->s[i]=zs[i];};rslt->f=0;rslt->c=zc;',nl
 ref,←nl,⍨(3=0⌷⍺)⊃'I zcp=zc;' 'I zcp=ceil(zc/8.0);'
 ref,←'rslt->z=zcp*sizeof(',(⊃git ⊃0⌷⍺),');rslt->v=rgt->v;',nl
 exe←'if(zc<=rc){',nl,ref,'} else {',nl,cpy,nl,'}'
 chk siz (exe cpy⊃⍨0=⊃0⍴⊃⊃1 0⌷⍵) mxfn 0 ⍺ ⍵}
catm←{chk←'' ⋄ siz←'zr=1;DO(i,rr)rc*=rs[i];zs[0]=rc;'
 exe←(3=0⌷⍺)⊃'I pc=rc;' 'I pc=ceil(rc/8.0);'
 exe,←nl,(simd'present(zv[:pc],rv[:pc])'),'DO(i,pc)zv[i]=rv[i];'
 chk siz exe mxfn 1 ⍺ ⍵}

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
fctm←{
  siz←'zr=2;if(rr==0){zs[0]=1;zs[1]=1;}else{zs[0]=rs[0];'
  siz,←'I n=rr-1;DO(i,n)rc*=rs[i+1];zs[1]=rc;rc*=rs[0];}'
  exe←(3=0⌷⍺)⊃'I rcp=rc;' 'I rcp=ceil(rc/8.0);'
  exe,←nl,(simd'present(zv[:rcp],rv[:rcp])'),'DO(i,rcp)zv[i]=rv[i];'
    '' siz exe mxfn 1 ⍺ ⍵}

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
  exe,←'zc/=zc==0?1:zs[0];rc=rr==0?zc:rc;lc=lr==0?zc:lc;',nl
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

rotm←{        siz     ←'zr=rr;DO(i,zr)zs[i]=rs[i];'
        exe     ←'I n=zr==0?0:zr-1;DO(i,n)zc*=zs[i];rc=rr==0?1:rs[rr-1];lc=zc*rc;',nl
        exen    ←simd 'independent collapse(2) present(rv[:lc],zv[:lc])'
        exen    ,←'DO(i,zc){DO(j,rc){zv[i*rc+j]=rv[i*rc+(rc-(j+1))];}}'
        exeb    ←'I zcp=ceil(lc/8.0);',nl
        exeb    ,←simd'present(zv[:zcp])'
        exeb    ,←'DO(i,zcp){zv[i]=0;}',nl
        exeb    ,←simd'collapse(2) present(zv[:zcp],rv[:zcp])'
        exeb    ,←'DO(i,zc){DO(j,rc){I zi=i*rc+j;I ri=i*rc+(rc-(j+1));',nl
        exeb    ,←' zv[zi/8]|=(1&(rv[ri/8]>>(7-(ri%8))))<<(7-(zi%8));',nl
        exeb    ,←'}}'
        exe     ,←(3=⊃0⌷⍺)⊃exen exeb
                ''('zr=rr;DO(i,zr)zs[i]=rs[i];')exe mxfn 1 ⍺ ⍵}

⍝    Rotate
rotd←{
  chk←'if(lr!=0&&(lr!=1||ls[0]!=1))error(16);'
  siz←'zr=rr;DO(i,zr)zs[i]=rs[i];'
  exe←'zc=rr==0?1:rs[rr-1];I n=rr==0?0:rr-1;DO(i,n)rc*=rs[i];',nl
  exe,←'DO(i,lr)lc*=ls[i];I s=(lv[0]<0)?abs(lv[0]):zc-lv[0];',nl
  exen←simd'collapse(2) present(zv[:rslt->c],rv[:rslt->c],lv[:lc])'
  exen,←'DO(i,rc){DO(j,zc){zv[i*zc+((j+s)%zc)]=rv[(i*zc)+j];}}'
  exeb←'I zcp=ceil(rslt->c/8.0);',nl
  exeb,←simd'present(zv[:zcp])'
  exeb,←'DO(i,zcp){zv[i]=0;}',nl
  exeb,←simd'collapse(2) present(zv[:zcp],rv[:zcp],lv[:lc])'
  exeb,←'DO(i,rc){DO(j,zc){',nl
  exeb,←' I zi=i*zc+((j+s)%zc);',nl
  exeb,←' I ri=(i*zc)+j;',nl
  exeb,←' zv[zi/8]|=(1&(rv[ri/8]>>(7-(ri%8))))<<(7-(zi%8));',nl
  exeb,←'}}'
  exe,←(3=⊃0⌷⍺)⊃exen exeb
    chk siz exe mxfn 1 ⍺ ⍵}

⍝    Rotate First
rtfm←{
  exe←'I n=zr==0?0:zr-1;DO(i,n)zc*=zs[i+1];rc=rr==0?1:rs[0];',nl
  exe,←(3=0⌷⍺)⊃'I zcp=rc*zc;' 'I zcp=ceil((rc*zc)/8.0);'
  exe,←(3=0⌷⍺)⊃nl(nl,(pacc'update host(rv[:zcp])'),'DO(i,zcp)zv[i]=0;',nl)
  exe,←(3=0⌷⍺)⊃(simd'collapse(2) independent present(rv[:zcp],zv[:zcp])')''
  exe,←'DO(i,rc){DO(j,zc){I zvi=i*zc+j;I rvi=(rc-(i+1))*zc+j;',nl
  exe,←(3=0⌷⍺)⊃('zv[zvi]=rv[rvi];}}')''
  exe,←(3=0⌷⍺)⊃''('zv[zvi/8]|=(1&(rv[rvi/8]>>(7-(rvi%8))))<<(7-(zvi%8));}}')
  exe,←(3=0⌷⍺)⊃''(nl,pacc'update device(zv[:zcp])')
    ''('zr=rr;DO(i,zr)zs[i]=rs[i];')exe mxfn 1 ⍺ ⍵}

rtfd←{        chk     ←'if(lr!=0&&(lr!=1||ls[0]!=1))error(16);'
        siz     ←'zr=rr;DO(i,zr)zs[i]=rs[i];'
        exe     ←'zc=rr==0?1:rs[0];I n=rr==0?0:rr-1;DO(i,n)rc*=rs[i+1];',nl
        exe     ,←'DO(i,lr)lc*=ls[i];',nl
        exe     ,←simd'collapse(2) present(zv[:rslt->c],rv[:rslt->c],lv[:lc])'
        exe     ,←'DO(i,zc){DO(j,rc){zv[(((i-lv[0])%zc)*rc)+j]=rv[(i*rc)+j];}}'
                chk siz exe mxfn 1 ⍺ ⍵}
tspm←{        siz     ←'zr=rr;DO(i,rr)zs[rr-(1+i)]=rs[i];'
        exe     ←simd'independent collapse(2) present(zv[:rslt->c],rv[:rgt->c])'
        exe     ,←'DO(i,rs[0]){DO(j,rs[1]){zv[(j*zs[1])+i]=rv[(i*rs[1])+j];}}'
                '' siz exe mxfn 1 ⍺ ⍵}

⍝    Enlist
memm←{
  siz←'DO(i,rr)rc*=rs[i];zr=1;zs[0]=rc;'
  exe←(3=0⌷⍺)⊃'I rcp=rc;' 'I rcp=ceil(rc/8.0);'
  exe,←nl,(simd'present(rv[:rcp],zv[:rcp])'),'DO(i,rcp)zv[i]=rv[i];'
    '' siz exe mxfn 1 ⍺ ⍵}

dscm←{        exe     ←pacc'update host(rv[:rgt->c])'
        exe     ,←'DO(i,rr)rc*=rs[i];zv[0]=rc==0?0:rv[0];',nl
        exe     ,←pacc'update device(zv[:rslt->c])'
                '' 'zr=0;' exe mxfn 1 ⍺ ⍵}
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
        exe     ←ref cpy⊃⍨1⌊(3=⊃0⌷⍺)+0=⊃0⍴⊃⊃1 0⌷⍵
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
        exe     ←ref cpy⊃⍨0=⊃0⍴⊃⊃1 0⌷⍵
                chk siz exe mxfn 0 ⍺ ⍵}
fltd←{        chk     ←'if(lr>1)error(4);',nl
        chk     ,←'if(lr!=0&&ls[0]!=1&&rr!=0&&rs[rr-1]!=1&&ls[0]!=rs[rr-1])error(5);'
        popcnt  ←'__builtin_popcount' '_popcnt32' '__popcnt'
        pcnt    ←popcnt⊃⍨'gc' 'ic' 'pg'⍳⊂2↑COMPILER
        siz     ←'zr=rr==0?1:rr;I n=zr-1;DO(i,n)zs[i]=rs[i];',nl
        siz     ,←'if(lr==1)lc=ls[0];if(rr!=0)rc=rs[rr-1];zs[zr-1]=0;B last=0;',nl
        szn     ←siz,pacc 'update host(lv[:lc],rv[:rgt->c])'
        szn     ,←'if(lc>=rc){DO(i,lc)last+=abs(lv[i]);}else{last+=rc*abs(lv[0]);}',nl
        szn     ,←'zs[zr-1]=last;DO(i,n)zc*=zs[i];'
        szb     ←siz,pacc 'update host(lv[:lft->z],rv[:rgt->c])'
        szb     ,←'if(lc>=rc){I n=ceil(lc/32.0);I*lv32=(I*)lv;',nl
        szb     ,←'DO(i,n)last+=',pcnt,'(lv32[i]);',nl
        szb     ,←'}else{last+=rc*(lv[0]>>7);}',nl
        szb     ,←'zs[zr-1]=last;DO(i,n)zc*=zs[i];'
        exe     ←'B a=0;if(rc==lc){',nl,'DO(i,lc){',nl
        exe     ,←' if(lv[i]==0)continue;',nl
        exe     ,←' else if(lv[i]>0){',nl
        exe     ,←'  DO(j,zc){DO(k,lv[i]){zv[(j*zs[zr-1])+a+k]=rv[(j*rc)+i];}}',nl
        exe     ,←'  a+=lv[i];',nl
        exe     ,←' }else{',nl
        exe     ,←'  DO(j,zc){L n=abs(lv[i]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}',nl
        exe     ,←'  a+=abs(lv[i]);}}}',nl
        exe     ,←'else if(rc>lc){',nl
        exe     ,←' if(lv[0]>0){'
        exe     ,←'DO(i,zc){DO(j,rc){DO(k,lv[0]){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}}',nl
        exe     ,←' else if(lv[0]<0){L n=zc*zs[zr-1];DO(i,n)zv[i]=0;}}',nl
        exe     ,←'else{DO(i,lc){',nl
        exe     ,←' if(lv[i]==0)continue;',nl
        exe     ,←' else if(lv[i]>0){',nl
        exe     ,←'  DO(j,zc){DO(k,lv[i]){zv[(j*zs[zr-1])+a+k]=rv[j*rc];}}',nl
        exe     ,←'  a+=lv[i];',nl
        exe     ,←' }else{',nl
        exe     ,←'  DO(j,zc){L n=abs(lv[i]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}',nl
        exe     ,←'  a+=abs(lv[i]);}}}',nl
        exe     ,←pacc 'update device(zv[:rslt->c])'
        exb     ←'B a=0;if(rr==1&&rc==lc){I n=ceil(lc/8.0);;',nl
        exb     ,←' DO(i,n){DO(j,8){if(1&(lv[i]>>(7-j)))zv[a++]=rv[i*8+j];}}',nl
        exb     ,←'}else if(rc==lc){I n=ceil(lc/8.0);',nl,'DO(i,n){DO(m,8){',nl
        exb     ,←' if(1&(lv[i]>>(7-m))){',nl
        exb     ,←'  DO(j,zc){zv[(j*zs[zr-1])+a]=rv[(j*rc)+i*8+m];}',nl
        exb     ,←'  a++;}}}',nl
        exb     ,←'}else if(rc>lc){if(lv[0]>>7){',nl
        exb     ,←'  DO(i,zc){DO(j,rc){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}',nl
        exb     ,←'}else{I n=ceil(lc/8.0);DO(i,n){DO(m,8){',nl
        exb     ,←' if(1&(lv[i]>>(7-m))){',nl
        exb     ,←'  DO(j,zc){zv[(j*zs[zr-1])+a]=rv[j*rc];}',nl
        exb     ,←'  a++;}}}}',nl
        exb     ,←pacc 'update device(zv[:rslt->c])'
                ((3≡2⊃⍺)⊃(chk szn exe)(chk szb exb)) mxfn 1 ⍺ ⍵}
lftm←{        chk siz ←''('zr=rr;DO(i,rr)zs[i]=rs[i];')
        exe     ←'DO(i,zr)zc*=zs[i];',nl,(simd'present(zv[:zc],rv[:zc])'),'DO(i,zc)zv[i]=rv[i];'
                chk siz exe mxfn 1 ⍺ ⍵}
rgtm←{        chk siz ←''('zr=rr;DO(i,rr)zs[i]=rs[i];')
        exe     ←'DO(i,zr)zc*=zs[i];',nl,(simd'present(zv[:zc],rv[:zc])'),'DO(i,zc)zv[i]=rv[i];'
                chk siz exe mxfn 1 ⍺ ⍵}
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
iotm←{        chk     ←'if(!(rr==0||(rr==1&&1==rs[0])))error(16);'
        siz     ←'zr=1;zc=zs[0]=rv[0];'
        exe     ←(simd 'present(zv[:zc])'),'DO(i,zs[0])zv[i]=i;'
                chk siz exe mxfn 1 ⍺ ⍵}
shpm←{exe←'DO(i,rr)zv[i]=rs[i];',nl,pacc'update device(zv[:rr])'
 '' 'zr=1;zs[0]=rr;' exe mxfn 1 ⍺ ⍵}
eqvm←{        exe     ←'zv[0]=rr==0?0:1;',nl,pacc'update device(zv[:1])'
                '' 'zr=0;' exe mxfn 1 ⍺ ⍵}
eqvd←{        chk siz ←'' 'zr=0;'
        exe     ←pacc 'update host(lv[:lft->c],rv[:rgt->c])'
        exe     ,←'zv[0]=1;if(rr!=lr)zv[0]=0;',nl
        exe     ,←'DO(i,lr){if(!zv[0])break;if(rs[i]!=ls[i]){zv[0]=0;break;}}',nl
        exe     ,←'DO(i,lr)lc*=ls[i];',nl
        exe     ,←'DO(i,lc){if(!zv[0])break;if(lv[i]!=rv[i]){zv[0]=0;break;}}',nl
        exe     ,←pacc'update device(zv[:rslt->c])'
                chk siz exe mxfn 1 ⍺ ⍵}
nqvm←{        exe     ←'zv[0]=rr==0?1:rs[0];',nl,pacc'update device(zv[:1])'
                '' 'zr=0;' exe mxfn 1 ⍺ ⍵}
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
