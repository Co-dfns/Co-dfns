⍝[c]The Co-dfns Compiler: High-performance, Parallel APL Compiler
⍝[c]Copyright (c) 2011-2016 Aaron W. Hsu <arcfide@sacrideo.us>
⍝[c]
⍝[c]This program is free software: you can redistribute it and/or modify
⍝[c]it under the terms of the GNU Affero General Public License as published by
⍝[c]the Free Software Foundation, either version 3 of the License, or
⍝[c](at your option) any later version.
⍝[c]
⍝[c]This program is distributed in the hope that it will be useful,
⍝[c]but WITHOUT ANY WARRANTY; without even the implied warranty of
⍝[c]MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
⍝[c]GNU Affero General Public License for more details.
⍝[c]
⍝[c]You should have received a copy of the GNU Affero General Public License
⍝[c]along with this program.  If not, see <http://www.gnu.org/licenses/>.
⍝[c]
:Namespace codfns

⍝[of]:Public API
⍝[of]:Global Settings
⎕IO ⎕ML ⎕WX	←0 1 3
COMPILER	←'vsc'
TEST∆COMPILERS	←⊂'vsc'
BUILD∆PATH	←'build'
VISUAL∆STUDIO∆PATH	←'C:\Program Files (x86)\Microsoft Visual Studio 14.0\'
INTEL∆C∆PATH	←'C:\Program Files (x86)\IntelSWTools\'
INTEL∆C∆PATH	,←'compilers_and_libraries_2016.0.110\windows\bin\'
PGI∆PATH	←'C:\Program Files\PGI\win64\16.9\'
VERSION	←2016 10 0
⍝[cf]
⍝[of]:Primary Interface
Cmp←{	_	←{22::⍬ ⋄ ⍵ ⎕NERASE ⍵ ⎕NTIE 0}so←BSO ⍺
	_	←(⍎COMPILER)⍺⊣(BUILD∆PATH,(dirc⍬),⍺,'_',COMPILER,'.c')put⍨gc tt⊃a n←ps ⍵
		22::'COMPILE ERROR'⎕SIGNAL 22
		n⊣⎕NUNTIE so ⎕NTIE 0}
MkNS	←{ns⊣⍺∘{ns.⍎⍺ mkf ⍵}¨(1=1⌷⍉⍵)⌿0⌷⍉⍵⊣ns←#.⎕NS⍬}
Fix	←{⍺ MkNS ⍺ Cmp ⍵}
Xml	←{⎕XML (0⌷⍉⍵),(,∘⍕⌿2↑1↓⍉⍵),(⊂''),⍪(⊂(¯3+≢⍉⍵)↑,¨'nrsvyel'),∘⍪¨↓⍕¨⍉3↓⍉⍵}
BSO	←{BUILD∆PATH,(dirc⍬),⍵,'_',COMPILER,(soext⍬)}
MKA	←{mka⊂⍵⊣'mka'⎕NA 'P ',(BSO ⍺),'|mkarray <PP'}
EXA	←{exa⍬(0⊃⍵)(1⊃⍵)⊣'exa'⎕NA (BSO ⍺),'|exarray >PP P I4'}
FREA	←{frea⍵⊣'frea'⎕NA (BSO ⍺),'|frea P'}
⍝[cf]
⍝[of]:Helpers
dirc	←{'\/'⊃⍨'gcc' 'icc' 'pgcc'∊⍨⊂COMPILER}
soext	←{'.dll' '.so'⊃⍨'gcc' 'icc' 'pgcc'∊⍨⊂COMPILER}
tie	←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
put	←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}
mkf←{	fn	←BUILD∆PATH,(dirc⍬),⍺,'_',COMPILER,(soext⍬),'|',⍵,' '
	f	←⍵,'←{'
	f	,←'_←''dya''⎕NA''',fn,'>PP <PP <PP'' ⋄ '
	f	,←'_←''mon''⎕NA''',fn,'>PP P <PP'' ⋄ '
		f,'0=⎕NC''⍺'':mon 0 0 ⍵ ⋄ dya 0 ⍺ ⍵} ⋄ 0'}
⍝[cf]
⍝[cf]
⍝[of]:Backend Compilers
⍝[of]:UNIX Generic Flags
cfs	←'-funsigned-bitfields -funsigned-char -fvisibility=hidden '
cds	←'-L/usr/local/lib64 -lcrypto '
cio	←{' -o ''',BUILD∆PATH,'/',⍵,'_',⍺,'.',⍺⍺,''' '}
fls	←{'''',BUILD∆PATH,'/',⍵,'_',⍺,'.c'' '}
log	←{'> ',BUILD∆PATH,'/',⍵,'_',⍺,'.log 2>&1'}
⍝[cf]
⍝[of]:VS/IC Windows Flags
vsco	←'/W3 /Gm- /O2 /Zc:inline /Zi /Fd"build\vc140.pdb" '
vsco	,←'/errorReport:prompt /WX- /MD /EHsc /nologo '
vsco	,←'/I"%AF_PATH%\include" '
vslo	←'/link /DLL /OPT:REF /INCREMENTAL:NO /SUBSYSTEM:WINDOWS '
vslo	,←'/LIBPATH:"%AF_PATH%\lib" /DYNAMICBASE "af.lib" '
vslo	,←'/OPT:ICF /ERRORREPORT:PROMPT /TLBID:1 '
⍝[cf]
⍝[of]:Linux
⍝[of]:GCC
gop	←'-Ofast -g -Wall -Wno-unused-function -Wno-unused-variable -fPIC -shared '
gcc	←{⎕SH'gcc ',cfs,cds,gop,'gcc'('so'cio,fls,log)⍵}
⍝[cf]
⍝[of]:Intel
iop	←'-fast -g -fno-alias -static-intel -mkl -Wall -Wno-unused-function -fPIC -shared '
icc	←{⎕SH'icc ',cfs,cds,iop,'icc'('so'cio,fls,log)⍵}
⍝[cf]
⍝[of]:PGI
pop	←' -fast -acc -ta=tesla:maxregcount:32,nollvm,nordc,cuda8 -Minfo -fPIC '
plb	←'-L/usr/local/lib64 -lcrypto '
pgcco←{	cmd	←'pgcc -c ',cds,pop,' -o ''',⍵,'.o'' ''',⍵,'.c'''
		⎕SH cmd,' >> ''',BUILD∆PATH,'/',⍺,'_pgcc.log'' 2>&1'}
pgccld←{	cmd	←'pgcc -shared ',cds,pop,'-o ''',BUILD∆PATH,'/',⍺,'_pgcc.so'' ',plb
		⎕SH cmd,⍵,' >> ''',BUILD∆PATH,'/',⍺,'_pgcc.log'' 2>&1'}
pgcc←{	_	←⎕SH'echo "" > ''',BUILD∆PATH,'/',⍵,'_pgcc.log'''
	_	←⍵ pgcco BUILD∆PATH,'/',⍵,'_pgcc'
		⍵ pgccld '''',BUILD∆PATH,'/',⍵,'_pgcc.o'''}
⍝[cf]
⍝[cf]
⍝[of]:Mac
⍝[of]:Clang
cop	←'-Ofast -g -Wall -Wno-unused-function -Wno-unused-variable -fPIC -shared '
clang	←{⎕SH'clang ',cfs,cds,gop,'gcc'('dylib'cio,fls,log)⍵}
⍝[cf]
⍝[cf]
⍝[of]:Windows
⍝[of]:Visual Studio
vsc1	←{'""',VISUAL∆STUDIO∆PATH,'VC\vcvarsall.bat" amd64 && cl ',vsco,'/fast '}
vsc2	←{'/Fo"',BUILD∆PATH,'\\" "',BUILD∆PATH,'\',⍵,'_vsc.c" "libcrypto-38.lib" '}
vsc3	←{vslo,'/OUT:"',BUILD∆PATH,'\',⍵,'_vsc.dll" '}
vsc4	←{'> "',BUILD∆PATH,'\',⍵,'_vsc.log""'}
vsc	←{⎕CMD ('%comspec% /C ',vsc1,vsc2,vsc3,vsc4)⍵}
⍝[cf]
⍝[of]:Intel
icl1	←{'""',INTEL∆C∆PATH,'\ipsxe-comp-vars.bat" intel64 vs2015 && icl ',vsco,'/Ofast '}
icl3	←{'"',BUILD∆PATH,'\',⍵,'_icl.c" ',vslo,'/OUT:"',BUILD∆PATH,'\',⍵,'_icl.dll" '}
icl4	←{'> "',BUILD∆PATH,'\',⍵,'_icl.log""'}
icl	←⎕CMD '%comspec% /E:ON /V:ON /C ',icl1,vsc2,icl3,icl4
⍝[cf]
⍝[of]:PGI
pgio	←'-fast -acc -ta=tesla:maxregcount:32,nollvm,nordc -Minfo -Minline '
pgilibs	←'-laccapi -laccg -laccn -laccg2 -lcrypto-38 '
pgwc	←{'pgcc ',pgio,'-Bdynamic -c "',⍵,'.c" -o "',⍵,'.obj"'}
pglk	←{'pgcc ',pgio,'-Mmakedll -o "',⍵,'.dll" "',⍵,'.obj" ',pgilibs}
pgienv	←{'"',PGI∆PATH,'pgi_env.bat"',('>'pgilog ⍵)}
pgicmp	←{(pgwc BUILD∆PATH,'\',⍵,'_pgi'),('>>'pgilog ⍵)}
pgilnk	←{(pglk BUILD∆PATH,'\',⍵,'_pgi'),('>>'pgilog ⍵)}
pgilog	←{' ',⍺,' "',BUILD∆PATH,'\',⍵,'_pgi.log" 2>&1'}
pgi	←{⎕CMD'%comspec% /C "',(pgienv⍵),' && ',(pgicmp⍵),' && ',(pgilnk⍵),'"'}
⍝[cf]
⍝[cf]
⍝[cf]
⍝[of]:AST
get	←{⍺⍺⌷⍉⍵}
up	←⍉(1+1↑⍉)⍪1↓⍉
bind	←{n _ e←⍵ ⋄ (0 n_⌷e)←⊂n ⋄ e}

⍝[c]Field Descriptors/Accessors
d_ t_ k_ n_ r_ s_ v_ y_ e_ l_←⍳6+f∆←4
d←d_ get	⋄ t←t_ get	⋄ k←k_ get	⋄ n←n_ get	⋄ r←r_ get
s←s_ get	⋄ v←v_ get	⋄ y←y_ get	⋄ e←e_ get	⋄ l←l_ get

⍝[c]Node Constructors, Masks, and Selectors
new	←{⍉⍪f∆↑0 ⍺,⍵}	⋄ msk	←{(t ⍵)∊⊂⍺⍺}	⋄ sel	←{(⍺⍺ msk ⍵)⌿⍵}
A	←{('A'new ⍺⍺)⍪up⊃⍪/⍵}	⋄ Am	←'A'msk	⋄ As	←'A'sel
E	←{('E'new ⍺⍺)⍪up⊃⍪/⍵}	⋄ Em	←'E'msk	⋄ Es	←'E'sel
F	←{('F'new 1)⍪up⊃⍪/(⊂0 f∆⍴⍬),⍵}	⋄ Fm	←'F'msk	⋄ Fs	←'F'sel
M	←{('M'new⍬)⍪up⊃⍪/(⊂0 f∆⍴⍬),⍵}	⋄ Mm	←'M'msk	⋄ Ms	←'M'sel
N	←{'N'new 0 (⍎⍵)}	⋄ Nm	←'N'msk	⋄ Ns	←'N'sel
O	←{('O'new ⍺⍺)⍪up⊃⍪/⍵}	⋄ Om	←'O'msk	⋄ Os	←'O'sel
P	←{'P'new 0 ⍵}	⋄ Pm	←'P'msk	⋄ Ps	←'P'sel
S	←{'S'new 0 ⍵}	⋄ Sm	←'S'msk	⋄ Ss	←'S'sel
V	←{'V'new ⍺⍺ ⍵}	⋄ Vm	←'V'msk	⋄ Vs	←'V'sel
Y	←{'Y'new 0 ⍵}	⋄ Ym	←'Y'msk	⋄ Ys	←'Y'sel
Z	←{'Z'new 1 ⍵}	⋄ Zm	←'Z'msk	⋄ Zs	←'Z'sel
⍝[cf]
⍝[of]:Parser
⍝[of]:Parsing Combinators
_s	←{0<⊃c a e r←z←⍺ ⍺⍺ ⍵:z ⋄ 0<⊃c2 a2 e r←z←e ⍵⍵ r:z ⋄ (c⌈c2)(a,a2) e r}
_o	←{0≥⊃c a e r←z←⍺ ⍺⍺ ⍵:z ⋄ 0≥⊃c a e r2←z←⍺ ⍵⍵ ⍵:z ⋄ c a e(r↑⍨-⌊/≢¨r r2)}
_any	←{⍺(⍺⍺ _s ∇ _o _yes)⍵}
_some	←{⍺(⍺⍺ _s (⍺⍺ _any))⍵}
_opt	←{⍺(⍺⍺ _o _yes)⍵}
_yes	←{0 ⍬ ⍺ ⍵}
_t	←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ e ⍵⍵ a:c a e r ⋄ 2 ⍬ ⍺ ⍵}
_set	←{(0≠≢⍵)∧(⊃⍵)∊⍺⍺:0(,⊃⍵)⍺(1↓⍵) ⋄ 2 ⍬ ⍺ ⍵}
_tk	←{((≢,⍺⍺)↑⍵)≡,⍺⍺:0(⊂,⍺⍺)⍺((≢,⍺⍺)↓⍵) ⋄ 2 ⍬ ⍺ ⍵}
_as	←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ c (,⊂⍵⍵ a) e r} ⋄ _enc←{⍺(⍺⍺ _as {⍵})⍵}
_ign	←{c a e r←⍺ ⍺⍺ ⍵ ⋄ c ⍬ e r}
_env	←{0<⊃c a e r←p←⍺ ⍺⍺ ⍵:p ⋄ c a (e ⍵⍵ a) r}
_aew	←{⍺(⍵⍵ _o (⍺⍺ _s ∇))⍵}
⍝[cf]
⍝[of]:Terminals/Tokens
ws	←(' ',⎕UCS 9)_set
aws	←ws _any _ign
awslf	←(⎕UCS 10 13)_set _o ws _any _ign
nss	←awslf _s(':Namespace'_tk)_s awslf _ign
nse	←awslf _s(':EndNamespace'_tk)_s awslf _ign
gets	←aws _s('←'_tk)_s aws
him	←'¯'_set
dot	←'.'_set
jot	←'∘'_set
lbrc	←aws _s('{'_tk)_s aws _ign
rbrc	←aws _s('}'_tk)_s aws _ign
lpar	←aws _s('('_tk)_s aws _ign
rpar	←aws _s(')'_tk)_s aws _ign
lbrk	←aws _s('['_tk)_s aws _ign
rbrk	←aws _s(']'_tk)_s aws _ign
alpha	←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'_set
digits	←'0123456789'_set
prim	←(prims←'+-÷×|*⍟⌈⌊!<≤=≠≥>∧∨⍲⍱⌷?⍴,⍪⌽⊖⍉∊⊃⍳○~≡≢⊢⊣/⌿\⍀⊤⊥↑↓∪∩⍋⍒')_set
mop	←'¨/⌿⍀\⍨'_set ⋄ dop←'.⍤⍣∘'_set
eot	←aws _s {''≡⍵:0 ⍬ ⍺ '' ⋄ 2 ⍬ ⍺ ⍵} _ign
digs	←digits _some ⋄ odigs←digits _any
int	←aws _s (him _opt) _s digs _s aws
float	←aws _s (int _s dot _s odigs _o (dot _s digs)) _s aws
name	←aws _s alpha _s (alpha _o digits _any) _s aws
aw	←aws _s ('⍺⍵'_set) _s aws
sep	←aws _s (('⋄',⎕UCS 10 13)_set _ign) _s aws
⍝[cf]
⍝[of]:Productions
Sfn	←aws _s (('⎕sp' _tk)_o('⎕XOR' _tk)) _s aws _as {P ∊⍵}
Prim	←prim _as {P⍵⍴⍨1+⍵∊'/⌿⍀\'} _o Sfn
Fn	←{0<⊃c a e r←p←⍺(lbrc _s (Stmt _aew rbrc) _as F)⍵:p ⋄ c a ⍺ r}
Fnp	←Fn _o Prim
Mop	←(jot _s dot _as P) _s Fnp _as (1 O∘⌽) _o (Fnp _s (mop _as P) _as (1 O))
Dop	←Fnp _s (dop _as P) _s Fnp _as (2 O)
Bop	←{⍺(Prim _s lbrk _s Ex _s rbrk _as ('i'O))⍵}
Bind	←{⍺(name _enc _s gets _s ⍺⍺ _env (⍵⍵{(⊃⍵)⍺⍺⍪⍺}) _as bind)⍵}
Fex	←{⍺(∇ Bind 1 _o Dop _o Mop _o Bop _o Fn _o (1 Var'f') _o Prim)⍵}
Vt	←{((0⌷⍉⍺)⍳⊂⍵)1⌷⍺⍪'' ¯1}
Var	←{⍺(aw _o (name _t (⍺⍺=Vt)) _as (⍵⍵ V))⍵}
Num	←float _o int _as N
Strand	←0 Var 'a'  _s (0 Var 'a' _some) _as ('s'A)
Atom	←{⍺(Num _some _as ('n'A) _o Strand _o (0 Var'a' _as ('v'A)) _o Pex)⍵}
Mon	←{⍺(Fex _s Ex _as (1 E))⍵}
Dya	←{⍺((Idx _o Atom) _s Fex _s Ex _as (2 E))⍵}
Idx	←{⍺(Atom _s lbrk _s Ex _s rbrk _as ('i'E))⍵}
Ex	←{⍺(∇ Bind 0 _o Dya _o Mon _o Idx _o Atom)⍵}
Pex	←lpar _s Ex _s rpar
Stmt	←sep _any _s (Ex _o Fex) _s (sep _any)
Ns	←nss _s (Stmt _aew nse) _s eot _as M
⍝[cf]

ps←{0≠⊃c a e r←(0 2⍴⍬)Ns ∊⍵,¨⎕UCS 10:⎕SIGNAL c ⋄ (⊃a)e}
⍝[cf]
⍝[of]:Core Compiler
⍝[of]:Utilities
scp	←(1,1↓Fm)⊂[0]⊢
mnd	←{A⊣((⍺ ⍺⍺ ⍵)⌿A)←⍺⊣A←⍵⍵ ⍵}
sub	←{⍺←⊢ ⋄ A⊣(m⌿A)←⍺ ⍺⍺(m←⍺ ⍵⍵ ⍵)⌿A←⍵}
at	←{⍺←⊢ ⋄ A⊣((,B)⌿(r A)⍴A)←⍺ ⍺⍺(,B)⌿((r←(≢⍴B←⍵⍵ ⍵)((×/↑),↓)⍴)A)⍴(A←⍵)}
prf	←((≢↑¯1↓(0≠⊢)(/∘⊢)⊢)⍤1↑∘r)⊢
blg	←{⍺←⊢ ⋄ ⍺((prf(⌈/(⍳∘≢⊢)×⍤1(1↓⊣)∧.(=∨0=⊢)∘⍉⊢)⍺⍺(⌿∘↑)r)⌷⍤0 2 ⍺⍺(⌿∘⊢)⍵⍵)⍵}
enc	←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
veo	←∪((⊂'%u'),(,¨prims),⊣)~⍨∘{⊃,/{⊂⍣(1≡≡⍵)⊢⍵}¨⍵}¯1↓⊢(/⍨)(∧/¨0≠((⊃0⍴⊢)¨⊢))
ndo	←{⍺←⊢ ⋄ m⊃∘(⊂,⊢)¨⍺∘⍺⍺¨¨⍵⊃∘(,∘⊂⍨⊂)¨⍨m←1≥≡¨⍵}
n2f	←(⊃,/)((1=≡)⊃,∘⊂⍨∘⊂)¨
⍝[cf]

⍝[of]:rn\:	Record Node Coordinates
rn←⊢,∘↓(1+d)↑⍤¯1(+⍀d∘.=∘⍳1+(⌈/0,d))
⍝[cf]
⍝[of]:rd\:	Record Function Depths
rd←⊢,(+/↑∘r∧.(=∨0=⊢)∘⍉∘↑∘r Fs)
⍝[cf]
⍝[of]:df\:	Drop Unnamed Functions
df←(~(+\1=d)∊((1=d)∧(Om∨Fm)∧0∊⍨n)(/∘⊢)(+\1=d))(⌿∘⊢)⊢
⍝[cf]
⍝[of]:du\:	Drop Unreachable Code
dua	←(Fm∨↓∘prf∊r∘Fs)(⊣(⍀∘⊢)(⊣(⌿∘⊢)0∊⍨n)(0,1↓(¯1⌽⊣)∧⊢=¯1⌽⊢)⊣(⌿∘⊢)d)⊢
du	←(~dua∨(∨/(prf∧.(=∨0=⊢)∘⍉dua(⌿∘⊢)prf)∧↑∘r∧.≥∘⍉dua(⌿∘⊢)↑∘r×0=prf))(⌿∘⊢)⊢
⍝[cf]
⍝[of]:lf\:	Lift Functions
lfv	←⍉∘⍪(1+⊣),'Vf',('fn'enc 4⊃⊢),4↓⊢
lfn	←('F'≡1⊃⊢)⌷(⊣-⍨∘⊃⊢)((⊂∘⍉∘⍪⊣,1↓⊢),∘⊂(⊣,'Of',3↓⊢)⍪lfv)⊢
lfh	←(1<(+/⊣))⊃(⊂0↑⊢),∘⊂∘⍉∘⍪1'F'1,('fn'enc⊣),(⊂⊣),5↓∘,1↑⊢
lf	←(1↑⊢)⍪∘⊃(⍪/(1,1↓Fm)blg(↑r)(⊂lfh⍪∘⊃(⍪/((¯2+1=(+/⊣))+∘⊃⊢)lfn⍤¯1⊢))⌸1↓⊢)
⍝[cf]
⍝[of]:dn\:	Drop Redundant Nodes
dn←((0∊⍨n)∧(Am∧'v'∊⍨k)∨Om∧'f'∊⍨k)((~⊣)(⌿∘⊢)(d-¯1⌽⊣),1↓[1]⊢)⊢
⍝[cf]
⍝[of]:mr\:	Mark Unit Returns
mrep	←3'P'0(,'⊢'),(⊂''),⍨¯1↓4↓∘,1↑⊢
mreu	←2 'E' 'u',(⊂''),⍨¯1↓3↓∘,1↑⊢
mre	←(⊢⍴⍨(≢⍉),⍨≢×2<≢)mreu⍪mrep⍪(1+d),1↓⍤1⊢
mrm	←∨\(Vm∨Am)∧((¯1+≢)-1⍳⍨∘⌽2=d)=(⍳≢)
mr	←(⊃⍪/)((1↑⊢),((⊢(⌿⍨∘~⍪∘mre(⌿⍨))mrm)¨1↓⊢))∘scp
⍝[cf]
⍝[of]:ur\:	Unmark Unit Returns
ur←((2↑⊢),1,('um'enc∘⊃r),4↓⊢)⍤1sub(Em∧'u'∊⍨k)
⍝[cf]
⍝[of]:fe\:	Flatten Expressions
fen	←n((3↑⊢),('fe'enc∘⊃r),4↓⊢)⍤1 at((0∊⍨n)∧Em∨Om∨Am)
fet	←('V'0⍴⍨2,⍨(+/0,1↓Em∨Om∨Am))(0,1↓Em∨Om∨Am)mnd(t,∘⍪k)⊢
fee	←(⍪/⌽)(1,1↓Em∨Om∨Am)blg⊢((⊂(d-⊃-2⌊⊃),fet,fen,4↓⍤1⊢)⍪)⌸1↓⊢
fe	←(⊃⍪/)(+\Fm)(⍪/(⊂1↑⊢),∘((+\d=⊃)fee⌸⊢)1↓⊢)⌸⊢
⍝[cf]
⍝[of]:ca\:	Compress Atomic Nodes
can	←(+\Am∨Om)((,1↑⊢),∘(⊂(¯1+2⌊≢)⊃(⊂∘⊂⊃),⊂)∘n 1↓⊢)⌸⊢
cam	←Om∧'f'∊⍨k
cas	←(Am(1↑⊢)⍪(Mm∨Am)blg⊢)∨¯1⌽cam
ca	←(can (cam∨cas∨Am)(⌿∘⊢)⊢)(Am∨cam)mnd⊢⍬,∘⊂⍨(~cas)(⌿∘⊢)⊢
⍝[cf]
⍝[of]:pc\:	Propogate Constants
pcc	←(⊂⊢(⌿⍨)Am∨Om∧'f'∊⍨k)∘((⍳∘∪⍨n)⌷⍤0 2(1⌈≢)↑⊢)∘((1+⊃),1↓⍤1⊢)∘(⊃⍪⌿)∘⌽(⌿∘⊢)
pcs	←(d,'V','f',(⊃¨v),r,(⊂⍬),⍨∘⍪s)sub Om
pcv	←(d,'V','a',(⊃v),r,(⊂⍬),⍨∘⍪s)sub (Am∧'v'∊⍨k)
pcb	←((,∧.(=∨0=⊣)∘⍪)⍤2 1⍨∘↑∘r(1↑⊢)⍪Fs)pcc⍤1((⊢(⌿⍨)d=1+⊃)¨⊣)
pcd	←((~(Om∧('f'∊⍨k)∧1≠d)∨Am∧d=1+(∨\Fm))(⌿∘⊢)⊢)∘(⊃⍪/)
pc	←pcd scp(pcb(pcv∘pcs(((1⌈≢)↑⊢)⊣)⌷⍤0 2⍨(n⊣)⍳n)sub(Vm∧n∊∘n⊣)¨⊣)⊢
⍝[cf]
⍝[of]:fc\:	Fold Constant Expressions
fce	←(⊃∘n Ps){⊂⍎' ⍵',⍨(≢⍵)⊃''(⍺,'⊃')('⊃',⍺,'/')⊣⍵}(v As)
fcm	←(∧/Em∨Am∨Pm)∧'u'≢∘⊃∘⊃k
fc	←((⊃⍪/)(((d,'An',3↓¯1↓,)1↑⊢),fce)¨sub(fcm¨))('MFOE'∊⍨t)⊂[0]⊢
⍝[cf]
⍝[of]:ce\:	Compress Expressions
ce←(+\Fm∨Em∨Om)((¯1↓∘,1↑⊢),∘⊂(⊃∘v 1↑⊢),∘((v As)Am mnd n⊢)1↓⊢)⌸⊢
⍝[cf]
⍝[of]:fv\:	Record Final Return Value
fv←(⊃⍪/)(((1↓⊢)⍪⍨(,1 6↑⊢),∘⊂∘n ¯1↑⊢)¨scp)
⍝[cf]
⍝[of]:nv\:	Normalize Values Field
nvu	←⊂'%u' ⋄ nvi      ←⊂'%i'
nvo	←((¯1↓⊢),({⍺'%b'⍵}/∘⊃v))⍤1sub(Om∧'i'∊⍨k)
nve	←((¯1↓⊢),({,¨⍺'['⍵}/∘⊃v))⍤1sub(Em∧'i'∊⍨k)
nvk	←((2↑⊢),2,(3↓⊢))⍤1sub(Em∧'i'∊⍨k)
nv	←nvk(⊢,⍨¯1↓⍤1⊣)Om((¯1⊖(¯1+≢)⊃(⊂nvu,nvi,⊢),(⊂nvu⍪⊢),∘⊂⊢){⌽⍣⍺⊢⍵})¨v∘nvo∘nve
⍝[cf]
⍝[of]:lt\:	Lift Type-checking
⍝[c]Index	Right	Left		Value	Type
⍝[c]0	Unknown	Unknown		Unknown	0
⍝[c]1	Unknown	Integer		Integer	1
⍝[c]2	Unknown	Float		Float	2
⍝[c]3	Unknown	Bitvector		Bitvector	3
⍝[c]4	Unknown	Not bound		Not bound	4
⍝[c]5	Integer	Unknown			
⍝[c]6	Integer	Integer			
⍝[c]7	Integer	Float		Ops. Code	Meaning
⍝[c]8	Integer	Bitvector		Left	0
⍝[c]9	Integer	Not bound		Right	1
⍝[c]10	Float	Unknown		Error	¯N
⍝[c]11	Float	Integer
⍝[c]12	Float	Float
⍝[c]13	Float	Bitvector
⍝[c]14	Float	Not bound
⍝[c]15	Bitvector	Unknown
⍝[c]16	Bitvector	Integer
⍝[c]17	Bitvector	Float
⍝[c]18	Bitvector	Bitvector
⍝[c]19	Bitvector	Not bound

⍝[of]:Primitive Types
pfs	←{⍺←0 ⋄ A	⊣A[9 14 19 6 7 8 11 12 13 16 17 18]←⍵	⊣A←20⍴⍺}
pn	←⍬	,⊂'%u'
pt	←(0 20⍴0)	⍪4 pfs 4

⍝[c]RL:	IN	FN	BN	II	IF	IB	FI	FF	FB	BI	BF	BB
pt⍪←pfs	1	2	3	1	1	1	2	2	2	3	3	3	⊣pn,←⊂'%b'
pt⍪←pfs	1	2	3	1	1	1	2	2	2	3	3	3	⊣pn,←⊂'%i'
pt⍪←pfs	¯6	¯6	¯6	1	2	3	1	2	3	1	2	3	⊣pn,←⊂,'⍺'
pt⍪←pfs	1	2	3	1	1	1	2	2	2	3	3	3	⊣pn,←⊂,'⍵'
pt⍪←pfs	1	2	3	1	2	1	2	2	2	1	2	1	⊣pn,←⊂,'+'
pt⍪←pfs	1	2	1	1	2	1	2	2	2	1	2	1	⊣pn,←⊂,'-'
pt⍪←pfs	2	2	3	2	2	2	2	2	2	1	2	3	⊣pn,←⊂,'÷'
pt⍪←pfs	1	1	3	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'×'
pt⍪←pfs	1	2	3	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'|'
pt⍪←pfs	2	2	2	2	2	2	2	2	3	1	2	3	⊣pn,←⊂,'*'
pt⍪←pfs	2	2	¯11	2	2	¯11	2	2	¯11	¯11	¯11	¯11	⊣pn,←⊂,'⍟'
pt⍪←pfs	1	1	3	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'⌈'
pt⍪←pfs	1	1	3	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'⌊'
pt⍪←pfs	¯2	¯2	¯2	3	3	3	3	3	3	3	3	3	⊣pn,←⊂,'<'
pt⍪←pfs	¯2	¯2	¯2	3	3	3	3	3	3	3	3	3	⊣pn,←⊂,'≤'
pt⍪←pfs	¯2	¯2	¯2	3	3	3	3	3	3	3	3	3	⊣pn,←⊂,'='
pt⍪←pfs	¯2	¯2	¯2	3	3	3	3	3	3	3	3	3	⊣pn,←⊂,'≠'
pt⍪←pfs	¯2	¯2	¯2	3	3	3	3	3	3	3	3	3	⊣pn,←⊂,'≥'
pt⍪←pfs	¯2	¯2	¯2	3	3	3	3	3	3	3	3	3	⊣pn,←⊂,'>'
pt⍪←pfs	1	2	3	1	¯11	1	2	¯11	2	3	¯11	3	⊣pn,←⊂,'⌷'
pt⍪←pfs	1	1	1	1	¯11	1	2	¯11	2	3	¯11	3	⊣pn,←⊂,'⍴'
pt⍪←pfs	1	2	3	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,','
pt⍪←pfs	1	1	3	1	1	1	1	1	1	1	1	1	⊣pn,←⊂,'⍳'
pt⍪←pfs	2	2	2	2	¯11	2	2	¯11	2	2	¯11	2	⊣pn,←⊂,'○'
pt⍪←pfs	3	3	3	1	2	3	1	2	3	1	2	3	⊣pn,←⊂,'~'
pt⍪←pfs	¯2	¯2	¯2	1	2	3	¯11	¯11	¯11	1	2	3	⊣pn,←⊂,'['
pt⍪←pfs	¯2	¯2	¯2	1	1	1	1	2	1	1	1	3	⊣pn,←⊂,'∧'
pt⍪←pfs	¯2	¯2	¯2	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'∨'
pt⍪←pfs	¯2	¯2	¯2	¯11	¯11	¯11	¯11	¯11	¯11	¯11	¯11	3	⊣pn,←⊂,'⍲'
pt⍪←pfs	¯2	¯2	¯2	¯11	¯11	¯11	¯11	¯11	¯11	¯11	¯11	3	⊣pn,←⊂,'⍱'
pt⍪←pfs	1	2	3	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'⍪'
pt⍪←pfs	1	2	3	1	¯11	1	2	¯11	2	3	¯11	3	⊣pn,←⊂,'⌽'
pt⍪←pfs	1	2	3	3	3	3	3	3	3	3	3	3	⊣pn,←⊂,'∊'
pt⍪←pfs	1	2	3	1	1	1	2	2	2	3	3	3	⊣pn,←⊂,'⊃'
pt⍪←pfs	1	2	3	1	¯11	1	2	¯11	2	3	¯11	3	⊣pn,←⊂,'⊖'
pt⍪←pfs	1	1	1	1	1	1	1	1	1	1	1	1	⊣pn,←⊂,'≡'
pt⍪←pfs	1	1	1	1	1	1	1	1	1	1	1	1	⊣pn,←⊂,'≢'
pt⍪←pfs	1	2	3	1	1	1	2	2	2	3	3	3	⊣pn,←⊂,'⊢'
pt⍪←pfs	1	2	3	1	2	3	1	2	3	1	2	3	⊣pn,←⊂,'⊣'
pt⍪←pfs	¯2	¯2	¯2	1	¯11	1	2	¯11	2	3	¯11	3	⊣pn,←⊂'//'
pt⍪←pfs	1	2	3	1	1	1	2	2	2	3	3	3	⊣pn,←⊂,'⍉'
pt⍪←pfs	1	2	3	1	1	1	2	2	2	3	3	3	⊣pn,←⊂,'↑'
pt⍪←pfs	1	2	3	1	1	1	2	2	2	3	3	3	⊣pn,←⊂,'↓'
pt⍪←pfs	¯2	¯2	¯2	1	¯16	1	¯16	¯16	¯16	3	3	3	⊣pn,←⊂,'⊤'
pt⍪←pfs	¯2	¯2	¯2	1	¯16	1	¯16	¯16	¯16	1	¯16	1	⊣pn,←⊂,'⊥'
pt⍪←pfs	2	2	3	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'!'
pt⍪←pfs	2	¯11	2	1	1	1	1	1	1	1	1	1	⊣pn,←⊂,'?'
pt⍪←pfs	1	2	3	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'∪'
pt⍪←pfs	¯2	¯2	¯2	1	2	1	2	2	2	1	2	3	⊣pn,←⊂,'∩'
pt⍪←pfs	1	1	1	¯16	¯16	¯16	¯16	¯16	¯16	¯16	¯16	¯16	⊣pn,←⊂,'⍋'
pt⍪←pfs	1	1	1	¯16	¯16	¯16	¯16	¯16	¯16	¯16	¯16	¯16	⊣pn,←⊂,'⍒'
pt⍪←pfs	0	0	0	0	0	0	0	0	0	0	0	0	⊣pn,←⊂,'¨'
pt⍪←pfs	0	0	0	0	0	0	0	0	0	0	0	0	⊣pn,←⊂,'⍨'
pt⍪←pfs	0	0	0	0	¯11	0	0	¯11	0	0	¯11	0	⊣pn,←⊂,'/'
pt⍪←pfs	0	0	0	0	¯11	0	0	¯11	0	0	¯11	0	⊣pn,←⊂,'⌿'
pt⍪←pfs	0	0	0	¯11	¯11	¯11	¯11	¯11	¯11	¯11	¯11	¯11	⊣pn,←⊂,'\'
pt⍪←pfs	0	0	0	¯11	¯11	¯11	¯11	¯11	¯11	¯11	¯11	¯11	⊣pn,←⊂,'⍀'
pt⍪←pfs	¯2	¯2	¯2	0	0	0	0	0	0	0	0	0	⊣pn,←⊂'∘.'
pt⍪←pfs	¯2	¯2	¯2	0	0	0	0	0	0	0	0	0	⊣pn,←⊂,'.'
pt⍪←pfs	¯2	¯2	¯2	1	¯11	¯11	¯11	¯11	¯11	¯11	¯11	¯11	⊣pn,←⊂'⎕sp'
pt⍪←pfs	¯2	¯2	¯2	1	¯16	¯16	¯16	¯16	¯16	¯16	¯16	¯16	⊣pn,←⊂'⎕XOR'
⍝[cf]
⍝[of]:Operator Indirections
⍝[c]oti: (0 Lop) (1 Rop) (2 Rarg) (3 Larg)
otn←⍬	⋄	oti←0 2 2⍴⍬
otn,←⊂,'.'	⋄	oti⍪←↑(1 1) (2 3)	⋄ otn,←⊂,'/'	⋄ oti⍪←↑(2 2) (2 3)
otn,←⊂,'⌿'	⋄	oti⍪←↑(2 2) (2 3)	⋄ otn,←⊂,'\'	⋄ oti⍪←↑(2 2) (2 3)
otn,←⊂,'⍀'	⋄	oti⍪←↑(2 2) (2 3)	⋄ otn,←⊂'∘.'	⋄ oti⍪←↑(2 3) (2 3)
otn,←⊂,'¨'	⋄	oti⍪←↑(2 3) (2 3)	⋄ otn,←⊂,'⍨'	⋄ oti⍪←↑(3 2) (3 2)
             		oti⍪←↑(2 3) (2 3)
⍝[cf]

lte	←((20⌊1 4 5⊥((∨⌿¯1=×)⍪|))2↑⊢)⌷⍤0 1∘,(⌊/∘,2↑⊢),⍨¯1↑⊢
ltoa	←lte⍤2(2↑⊣),[1]⍨(oti⌷⍨otn⍳¯1↑∘⊃v)(⌷⍤0 2)(4 5⊤⍳20)⍪⍨(2↑1↓(⊃y))
ltob	←(⍴⊣)⍴(,(⌈/⊢))(⌷⍤0 1)0 4 3 1 2,⍤1 0∘,⊣
ltoc	←ltoa(⊣ltob 5 0 3 4 2 1⌷⍤0 1⍨1+¯1⌈,∘⍪⍤1)(4 5⊤⍳20)×(,¨'/⌿\⍀')∊⍨¯1↑∘⊃v
lto	←(((1+¯1⌈⊃)⌷0 0,⍨⊢)⍤1∘⍉⍪1⊖⊢)(¯1↑⊣)⍪ltoc
ltv	←(1⊃⊣)⌷⍤0 2⍨(⊃¨(0⊃⊣)⍳∘⊂ndo(⊃v))
ltt	←(Om∧1 2∨.=∘⊃k)⊃⊣(((lte⍪⊢)ltv){⍺⍵}ltv lto ⊢)(⍉∘⍪⊢)
lta	←(1↓¨(⊂⊢),∘⊂(20⍴1+(≢∘⌊⍨⊃∘⊃))⍤0)∘(0,∘∪(0≡∘⊃0⍴⊢)¨(⌿∘⊢)⊢)∘(⊃,/)∘v Es⍪Os
ltb	←⊣⍪¨(⊂n),∘⊂∘↑((,1↑⊢)¨y)
lt	←(pn pt⍪¨lta)(ltb((,¯1↓⊢),∘⊂ltt)⍤1⊢)⍣≡(⊂4 20⍴0),⍨⊢
⍝[cf]
⍝[of]:va\:	Allocate Value Slots
val	←(n⍳∘∪n),¨⊢(⊢+(≢⊣)×0=⊢)(⌈/(⍳≢)×⍤1(∪n)∘.((⊂⊣)∊⊢)(n2f¨v))
vag	←∧∘~∘(∘.=⍨∘⍳≢)⍨(∘.(((1⌷⊢)>0⌷⊣)∧(0⌷⊢)<1⌷⊣)⍨val)
vae	←(∪n)(⊣,⍤0⊣(⌷⍨⍤1 0)∘⊃((⊢,(⊃(⍳∘≢⊣)~((≢⊢)↑⊣)(/∘⊢)⊢))/∘⌽(⊂⍬),∘↓⊢))vag
vac	←(((0⌷∘⍉⊣)⍳∘⊂⊢)⊃(1⌷∘⍉⊣),∘⊂⊢)ndo
va	←((⊃⍪/)(1↑⊢),(((vae Es)(d,t,k,(⊣vac n),r,s,y,∘⍪⍨(⊂⊣)vac¨v)⊢)¨1↓⊢))scp
⍝[cf]
⍝[of]:av\:	Anchor Variables to Values
avb	←{(((,¨'⍺⍵')↑⍨1↓⍴)⍪⊢)⍺⌷⍨⍤2 0⊢⍺⍺⍳⍺⍺∩⍨(↓(⌽1+∘⍳0⍳⍨⊢)((≢⊢)↑↑)⍤0 1⊢)⊃r ⍵}
avi	←¯1 0+(⍴⊣)⊤(,⊣)⍳(⊂⊢)
avh	←{⊂⍵,(n⍵)((⍺⍺(⍵⍵ avb)⍵){⍺⍺ avi ndo(⊂⍺),⍵})¨v⍵}
av	←(⊃⍪/)(+\Fm){⍺((⍺((∪∘⌽n)Es)⌸⍵)avh(r(1↑⍵)⍪Fs ⍵))⌸⍵}⊢
⍝[cf]
⍝[of]:rl\:	Record Live Variables
rlf	←(⌽↓(((1⊃⊣)∪⊢~0⌷⊣)/∘⌽(⊂⍬),↑)⍤0 1⍨1+∘⍳≢)(⊖1⊖n,⍤0(⊂⊣)veo¨v)
rl	←⊢,∘(⊃,/)(⊂∘n Os⍪Fs)rlf¨scp
⍝[cf]
⍝[of]:fs\:	Fuse Scalar Loops
fsf	←(∪∘⊃,/)(⊂⊂⍬ ⍬ ⍬),(⌽¯1↓⊢)¨~¨(⊂,⊂'%u'(4⍴⍨≢⍉pt)(¯1 0))∪¨∘(⍳∘≢↑¨⊂)⊣
fsn	←↓n,((,1↑⊢)¨y),⍤0(⊃¨e)
fsv	←v(↓,∘⊃⍤0)¨((↓1↓⊢)¨y)(↓,⍤0)¨1↓¨e
fsh	←(⍉⍪)2'S'0 ⍬ ⍬ 0,(((⊂0⌷⊢),(⊂∘↑1⌷⊢),(⊂2⌷⊢))∘⍉1↓∘↑fsn fsf fsv),∘l ¯1↑⊢
fsm	←Em∧(1∊⍨k)∧(,¨'~⌷')∊⍨(⊃∘⌽¨v)
fss	←fsm∨Em∧(1 2∊⍨k)∧((⊂'⎕XOR'),⍨,¨'+-×÷|⌊⌈*⍟○!∧∨⍱⍲<≤=≥>≠')∊⍨(⊃∘⌽¨v)
fsx	←(⊣(/∘⊢)fss∧⊣)(⊣⊃(⊂⊢),(⊂fsh⍪(1+d),'E',0,3↓⍤1⊢))¨⊂[0]
fs	←(⊃⍪/)(((((⊃⍪/)(⊂0 10⍴⍬),((2≠/(~⊃),⊢)fss)fsx⊢)Es)⍪⍨(~Em)(⌿∘⊢)⊢)¨scp)
⍝[cf]
⍝[of]:vc\:	Compress Scalar Expressions
vc←(⊃⍪/)(((1↓⊢)⍪⍨(1 6↑⊢),(≢∘∪∘n Es),1 ¯3↑⊢)¨scp)
⍝[cf]
⍝[of]:td\:	Type Dispatch/Specialization
tdn	←'ii' 'if' 'ib' 'in' 'fi' 'ff' 'fb' 'fn' 'bi' 'bf' 'bb' 'bn'
tdi	←6 7 8 9 11 12 13 14 16 17 18 19
tde	←((¯3↓⊢),(Om⌷y,⍨∘⊂(tdi⌷⍨⊣)⌷∘⍉∘⊃y),¯2↑⊢)⍤1
tdf	←(1↓⊢)⍪⍨(,1 3↑⊢),(⊂(⊃n),tdn⊃⍨⊣),(4↓∘,1↑⊢)
td	←((⊃⍪/)(1↑⊢),∘(⊃,/)(((⍳12)(⊣tdf tde)¨⊂)¨1↓⊢))scp
⍝[cf]
⍝[of]:ef\:	Convert Error Functions
eff	←(⊃⍪/)⊢(((⊂∘⍉∘⍪d,'Fe',3↓,)1↑⊣),1↓⊢)(d=∘⊃d)⊂[0]⊢
ef	←(Fm∧¯1=∘×∘⊃¨y)((⊃⍪/)(⊂⊢(⌿⍨)∘~(∨\⊣)),(eff¨⊂[0]))⊢
⍝[cf]
⍝[of]:if\:	Create Initializer for Globals
ifn	←1 'F' 0 'Init' ⍬ 0,(4⍴0) ⍬ ⍬,⍨⊢
if	←(1↑⊢)⍪(⊢(⌿⍨)Om∧1=d)⍪((up⍪⍨∘ifn∘≢∘∪n)⊢(⌿⍨)Em∧1=d)⍪(∨\Fm)(⌿∘⊢)⊢
⍝[cf]
⍝[of]:ff\:	Flatten Functions
fft	←(,1↑⊢)(1 'Z',(2↓¯5↓⊣),(v⊣),n,y,(⊂2↑∘,∘⊃∘⊃e),l)(¯1↑⊢)
ff	←((⊃⍪/)(1↑⊢),(((1↑⊢)⍪(((¯1+d),1↓⍤1⊢)1↓⊢)⍪fft)¨1↓⊢))scp
⍝[cf]
⍝[of]:fz\:	Flatten Scalar Groups
fzh	←((∪n)∩(⊃∘l⊣))(¯1⌽(⊂⊣),((≢⊢)-1+(⌽n)⍳⊣)((⊂⊣⊃¨∘⊂(⊃¨e)),(⊂⊣⊃¨∘⊂(⊃¨y)),∘⊂⊣)⊢)⊢
fzf	←0≠(≢∘⍴¨∘⊃∘v⊣)
fzb	←(((⊃∘v⊣)(⌿⍨)fzf),n),∘⍪('f'∘,∘⍕¨∘⍳(+/fzf)),('s'∘,∘⍕¨∘⍳∘≢⊢)
fzv	←((⊂⊣)(⊖↑)⍨¨(≢⊣)(-+∘⍳⊢)(≢⊢))((⊢,⍨1⌷∘⍉⊣)⌷⍨(0⌷∘⍉⊣)⍳⊢)⍤2 0¨v
fze	←(¯1+d),t,k,fzb((⊢/(-∘≢⊢)↑⊣),r,s,fzv,y,e,∘⍪l)⊢
fzs	←(,1↑⊢)(1⊖(⊣((1 'Y',(2⌷⊣),⊢)⍪∘⍉∘⍪(3↑⊣),⊢)1⌽fzh,¯1↓6↓⊣)⍪fze)(⌿∘⊢)
fz	←((⊃⍪/)(1↑⊢),(((2=d)(fzs⍪(1↓∘~⊣)(⌿∘⊢)1↓⊢)⊢)¨1↓⊢))(1,1↓Sm)⊂[0]⊢
⍝[cf]
⍝[of]:fd\:	Create Function Declarations
fd←(1↑⊢)⍪((1,'Fd',3↓⊢)⍤1 Fs)⍪1↓⊢
⍝[cf]

tt←{fd fz ff if ef td vc fs rl av va lt nv fv ce ur fc∘pc∘mr⍣≡ ca fe mr dn lf du df rd rn ⍵}
⍝[cf]
⍝[of]:Code Generator
E1	←{('mf'gcl ⍺)((⊂n,∘⊃v),e,y)⍵}
E2	←{r l f←⊃v⍵ ⋄ (¯1↓⊃y⍵)(f fcl ⍺)((⊃n⍵)r l),⍪¯1↓⊃e⍵}
E0	←{r l f←⊃v⍵ ⋄ (n⍵)((⊃y⍵)sget)(¯1↓⊃y⍵)(f scal sdb)r l}
Oi	←{(⊃n⍵)('Fexim()i',nl)('catdo')'' ''}
O1	←{(n⍵),odb(o ocl(⊃y⍵))⊂f⊣f u o←⊃v⍵}
O2	←{(n⍵),odb(o ocl(⊃y⍵))2↑⊣r l o←⊃v⍵}
O0	←{'' '' '' '' ''}
Of	←{(fndy ⍵),nl,nl,(⊃,/(⍳12)fncd¨⊂⍵),nl}
Fd	←{frt,(⊃n⍵),flp,';',nl}
Fe	←{frt,(⊃n⍵),flp,'{',nl,'dwaerr(',(⍕|⊃⊃y⍵),');',nl}
F0	←{frt,(⊃n⍵),flp,'{',nl,'A*env[]={tenv};',nl,('tenv'reg ⍵),nl}
F1	←{frt,(⊃n⍵),flp,'{',nl,('env0'dnv ⍵),(fnv ⍵),('env0'reg ⍵),nl,''⊣fnacc⍵}
Z0	←{'}',nl,nl}
Z1	←{'cpaa(z,',((⊃n⍵)var⊃e⍵),');',nl,'fe(&env0[1],',(⍕¯1+⊃s⍵),');}',nl,nl}
Ze	←{'}',nl,nl}
M0	←{rth,('tenv'dnv ⍵),nl,'A*env[]={',((0≡⊃⍵)⊃'tenv' 'NULL'),'};',nl}
S0	←{(('{',rk0,srk,'DO(i,prk)cnt*=sp[i];',spp,sfv,slp)⍵)}
Y0	←{⊃,/((⍳≢⊃n⍵)((⊣sts¨(⊃l),¨∘⊃s),'}',nl,⊣ste¨(⊃n)var¨∘⊃r)⍵),'}',nl}
dis	←{⍺←⊢ ⋄ 0=⊃t⍵:5⍴⍬ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}
gc	←{((⊃,/)⊢((fdb⍪⍨∘(dis⍤1)(⌿⍨))(⊂dis)⍤2 1(⌿⍨∘~))(Om∧1 2 'i'∊⍨k))⍵}
⍝[cf]
⍝[of]:Runtime Code
⍝[of]:Utilities
nl	←⎕UCS 13 10
fvs	←,⍤0(⌿⍨)0≠(≢∘⍴¨⊣)
cln	←'¯'⎕R'-'
var	←{⍺≡,'⍺':,'l' ⋄ ⍺≡,'⍵':,'r' ⋄ ¯1≥⊃⍵:,⍺ ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
dnv	←{(0≡z)⊃('A ',⍺,'[',(⍕z←⊃v⍵),'];')('A*',⍺,'=NULL;')}
reg	←{'DO(i,',(⍕⊃v⍵),')',⍺,'[i].v=NULL;'}
fnv	←{'A*env[',(⍕1+⊃s⍵),']={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
git	←{⍵⊃¨⊂'/* XXX */ I ' 'I ' 'D ' 'U8 ' '?NA? '}
gie	←{⍵⊃¨⊂'/* XXX */ APLI' 'APLI' 'APLD' 'APLU8' 'APLNA'}
pacc	←{('pg'≡2↑COMPILER)⊃''('#pragma acc ',⍵,nl)}
aclp	←{('pg'≡2↑COMPILER)⊃''('#pragma acc loop independent ',⍵,nl)}
ackn	←{('pg'≡2↑COMPILER)⊃''('#pragma acc kernels ',⍵,nl)}
acup	←{('pg'≡2↑COMPILER)⊃''('#pragma acc update ',⍵,nl)}
acdt	←{('pg'≡2↑COMPILER)⊃''('#pragma acc data ',⍵,nl)}
simdc	←{('#pragma acc kernels loop ',⍵,nl)('')('')}
simd	←{('pg' 'ic'⍳⊂2↑COMPILER)⊃simdc ⍵}
⍝[cf]
⍝[of]:Header
⍝[of]:Includes
rth	←'#include <stdio.h>',nl,'#include <string.h>',nl
rth	,←'#include <stdlib.h>',nl,'#include <time.h>',nl
rth	,←'#include <stdint.h>',nl,'#include <inttypes.h>',nl
rth	,←'#include <limits.h>',nl,'#include <float.h>',nl
rth	,←'#ifdef _OPENACC',nl,'#include <accelmath.h>',nl
rth	,←'#else',nl,'#include <math.h>',nl,'#endif',nl
rth	,←'#ifdef __INTEL_COMPILER',nl,'#include <mkl_vsl.h>',nl,'#endif',nl,nl
⍝[cf]
⍝[of]:Globals
rth	,←'int isinit=0;',nl
rth	,←'typedef enum{APLNC=0,APLU8,APLTI,APLSI,APLI,APLD}APLTYPE;',nl
rth	,←'#define PI 3.14159265358979323846',nl,nl
⍝[cf]
⍝[of]:Helper Macros
rth	,←'#define RANK(lp) ((lp)->p->r)',nl
rth	,←'#define TYPE(lp) ((lp)->p->t)',nl
rth	,←'#define SHAPE(lp) ((lp)->p->s)',nl
rth	,←'#define ETYPE(lp) ((lp)->p->e)',nl
rth	,←'#define DATA(lp) ((V*)&SHAPE(lp)[RANK(lp)])',nl
rth	,←'#define DO(i,n) for(B i=0;i<(n);i++)',nl,'#define R return',nl
rth	,←'#define DOI(i,n) for(I i=0;i<(n);i++)',nl
rth	,←'#ifdef _WIN32',nl,'#define EXPORT __declspec(dllexport)',nl
rth	,←'#elif defined(__GNUC__)',nl
rth	,←'#define EXPORT __attribute__ ((visibility ("default")))',nl
rth	,←'#else',nl,'#define EXPORT',nl,'#endif',nl
rth	,←'#ifdef _MSC_VER',nl,'#define RSTCT __restrict',nl
rth	,←'#else',nl,'#define RSTCT restrict',nl,'#endif',nl
rth	,←'#define S struct',nl,nl
⍝[cf]
⍝[of]:Typedefs
rth	,←'typedef int64_t L;typedef int32_t I;typedef double D;typedef void V;',nl
rth	,←'typedef unsigned char U8;typedef uint64_t B;typedef uint32_t U;',nl,nl
⍝[cf]
⍝[of]:Structures
rth	,←'typedef S array{I r; B s[15];I f;B c;B z;V*v;} A;',nl
rth	,←'S lp{S{L l;B c;U t:4;U r:4;U e:4;U _:13;U _1:16;U _2:16;B s[];}*p;};',nl
rth	,←'S dwa{B sz;S{B sz;V*(*ga)(U,U,B*,S lp*);V(*na[5])(V);V(*er)(U);}*ws;V*na[4];};',nl
rth	,←'S dwa*dwafns;',nl,nl
⍝[cf]
⍝[of]:DWA Functions
rth	,←'I EXPORT DyalogGetInterpreterFunctions(V*p){if(p)dwafns=p;else R 0;',nl
rth	,←' if(dwafns->sz<sizeof(S dwa))R 16;R 0;}',nl
rth	,←'static V dwaerr(U n){dwafns->ws->er(n);}',nl,nl
⍝[cf]
⍝[of]:Helpers
rth	,←'#define CD_R2(n)     n,     n + 2*64,     n + 1*64,     n + 3*64',nl
rth	,←'#define CD_R4(n) CD_R2(n), CD_R2(n + 2*16), CD_R2(n + 1*16), CD_R2(n + 3*16)',nl
rth	,←'#define CD_R6(n) CD_R4(n), CD_R4(n + 2*4 ), CD_R4(n + 1*4 ), CD_R4(n + 3*4 )',nl
rth	,←'static const U8 bitrt[256]={CD_R6(0), CD_R6(2), CD_R6(1), CD_R6(3)};',nl
rth	,←'U8 bitrev(U8 c){R bitrt[c];}',nl,nl
⍝[cf]
⍝[of]:Allocation
rth	,←'V EXPORT frea(A*a){if (a->v!=NULL){char*v=a->v;B z=a->z;',nl
rth	,←' if(a->f){',nl,'#ifdef _OPENACC',nl
rth	,←'#pragma acc exit data delete(v[:z])',nl,'#endif',nl,'}',nl
rth	,←' if(a->f>1){free(v);}}}',nl
rth	,←'V aa(A*a,I tp){frea(a);B c=1;DO(i,a->r)c*=a->s[i];B z=0;',nl
rth	,←' B pc=8*((c+7)/8);',nl
rth	,←' switch(tp){',nl
rth	,←'  case 1:z=sizeof(I)*pc;break;',nl
rth	,←'  case 2:z=sizeof(D)*pc;break;',nl
rth	,←'  case 3:z=(sizeof(U8)*pc+7)/8;break;',nl
rth	,←'  default: dwaerr(16);}',nl
rth	,←' z=8*((z+7)/8);char*v=malloc(z);if(NULL==v)dwaerr(1);',nl
rth	,←' #ifdef _OPENACC',nl,'  #pragma acc enter data create(v[:z])',nl,' #endif',nl
rth	,←' a->v=v;a->z=z;a->c=c;a->f=2;}',nl
rth	,←'V ai(A*a,I r,B *s,I tp){a->r=r;DO(i,r)a->s[i]=s[i];aa(a,tp);}',nl
rth	,←'V fe(A*e,I c){DO(i,c){frea(&e[i]);}}',nl,nl
⍝[cf]
⍝[of]:Co-dfns/Dyalog Converters
rth	,←'V cpad(S lp*d,A*a,I t){dwafns->ws->ga(t,a->r,a->s,d);B z=0;',nl
rth	,←' switch(t){',nl,'  case APLI:z=a->c*sizeof(I);break;',nl
rth	,←'  case APLD:z=a->c*sizeof(D);break;',nl
rth	,←'  case APLU8:z=(a->c+7)/8;break;',nl
rth	,←'  default:dwaerr(11);}',nl
rth	,←' #ifdef _OPENACC',nl,'  char *v=a->v;',nl
rth	,←'  #pragma acc update host(v[:z])',nl,' #endif',nl
rth	,←' if(t==APLU8){U8*t=DATA(d);U8*s=a->v;DO(i,z)t[i]=bitrev(s[i]);}',nl
rth	,←' else{memcpy(DATA(d),a->v,z);}}',nl
rth	,←'V cpda(A*a,S lp*d){if(15!=TYPE(d))dwaerr(16);frea(a);',nl
rth	,←' I r=a->r=RANK(d);B c=1;DO(i,r){c*=a->s[i]=SHAPE(d)[i];};a->c=c;',nl
rth	,←' switch(ETYPE(d)){',nl
rth	,←'  case APLI:a->z=8*((c*sizeof(I)+7)/8);a->f=2;',nl
rth	,←'   a->v=malloc(a->z);if(a->v==NULL)dwaerr(1);',nl
rth	,←'   {I*s=DATA(d);I*t=a->v;DO(i,c)t[i]=s[i];};break;',nl
rth	,←'  case APLD:a->z=8*((c*sizeof(D)+7)/8);a->f=2;',nl
rth	,←'   a->v=malloc(a->z);if(a->v==NULL)dwaerr(1);',nl
rth	,←'   {D*s=DATA(d);D*t=a->v;DO(i,c)t[i]=s[i];};break;',nl
rth	,←'  case APLSI:a->z=8*((c*sizeof(I)+7)/8);a->f=2;',nl
rth	,←'   a->v=malloc(a->z);if(a->v==NULL)dwaerr(1);',nl
rth	,←'   {int16_t*s=DATA(d);I*t=a->v;DO(i,c)t[i]=s[i];};break;',nl
rth	,←'  case APLTI:a->z=8*((c*sizeof(I)+7)/8);a->f=2;',nl
rth	,←'   a->v=malloc(a->z);if(a->v==NULL)dwaerr(1);',nl
rth	,←'   {int8_t*s=DATA(d);I*t=a->v;DO(i,c)t[i]=s[i];};break;',nl
rth	,←'  case APLU8:c=(c+7)/8;a->z=8*((c+7)/8);a->f=2;',nl
rth	,←'   a->v=malloc(a->z);if(a->v==NULL)dwaerr(1);',nl
rth	,←'   {U8*s=DATA(d);U8*t=a->v;DO(i,c)t[i]=bitrev(s[i]);};break;',nl
rth	,←'  default:dwaerr(16);}',nl
rth	,←' #ifdef _OPENACC',nl,' char *vc=a->v;B z=a->z;',nl
rth	,←' #pragma acc enter data pcopyin(vc[:z])',nl,' #endif',nl,'}',nl
rth	,←'V cpaa(A*t,A*s){frea(t);memcpy(t,s,sizeof(A));}',nl,nl
⍝[cf]
⍝[of]:External Makers & Extractors
rth	,←'EXPORT V*mkarray(S lp*da){A*aa=malloc(sizeof(A));if(aa==NULL)dwaerr(1);',nl
rth	,←' aa->v=NULL;cpda(aa,da);R aa;}',nl
rth	,←'V EXPORT exarray(S lp*da,A*aa,I at){I tp=0;',nl
rth	,←' switch(at){',nl
rth	,←'  case 1:tp=APLI;break;',nl
rth	,←'  case 2:tp=APLD;break;',nl
rth	,←'  case 3:tp=APLU8;break;',nl
rth	,←'  default:dwaerr(11);}',nl
rth	,←' cpad(da,aa,tp);frea(aa);}',nl,nl
rth	,←'EXPORT V*cmka(I r,B*s,I tp,V*buf){A*a=malloc(sizeof(A));if(!a)dwaerr(1);',nl
rth	,←' a->v=NULL;ai(a,r,s,tp);',nl
rth	,←' switch(tp){',nl
rth	,←'  case 1:{I*src=buf;I*tgt=a->v;DO(i,a->c)tgt[i]=src[i];};break;',nl
rth	,←'  case 2:{D*src=buf;D*tgt=a->v;DO(i,a->c)tgt[i]=src[i];}break;',nl
rth	,←'  case 3:{U8*src=buf;U8*tgt=a->v;DO(i,(a->c+7)/8)tgt[i]=src[i];}break;',nl
rth	,←'  default:dwaerr(11);};R a;}',nl
rth	,←'EXPORT V cexa(A*a,I tp,I*r,B*s,U8**b){*r=a->r;DO(i,*r)s[i]=a->s[i];',nl
rth	,←' *b=malloc(a->z);if(!*b)dwaerr(1);U8*src=a->v;DO(i,a->z)(*b)[i]=src[i];}',nl
⍝[cf]
⍝[of]:Scalar Helpers
rth	,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth	,←'D gcd(D an,D bn){D a=fabs(an);D b=fabs(bn);',nl
rth	,←' for(;b>1e-10;){D n=fmod(a,b);a=b;b=n;};R a;}',nl
rth	,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth	,←'D lcm(D a,D b){D n=a*b;D z=fabs(n)/gcd(a,b);',nl
rth	,←' if(a==0&&b==0)R 0;if(n<0)R -1*z;R z;}',nl
rth	,←'#ifdef _OPENACC',nl,'#pragma acc routine seq',nl,'#endif',nl
rth	,←'D circ(I a,D b){switch(a+8){',nl
rth	,←'  case 7:R asin(b);break;',nl
rth	,←'  case 6:R acos(b);break;',nl
rth	,←'  case 5:R atan(b);break;',nl
rth	,←'  case 4:R (b+1)*sqrt((b-1)/(b+1));break;',nl
rth	,←'  case 3:R asinh(b);break;',nl
rth	,←'  case 2:R acosh(b);break;',nl
rth	,←'  case 1:R atanh(b);break;',nl
rth	,←'  case 8:R sqrt(1-b*b);break;',nl
rth	,←'  case 9:R sin(b);break;',nl
rth	,←'  case 10:R cos(b);break;',nl
rth	,←'  case 11:R tan(b);break;',nl
rth	,←'  case 12:R sqrt(1+b*b);break;',nl
rth	,←'  case 13:R sinh(b);break;',nl
rth	,←'  case 14:R cosh(b);break;',nl
rth	,←'  case 15:R tanh(b);break;',nl
rth	,←' };R -1;}',nl
rth	,←'extern U arc4random_uniform(U);',nl
⍝[cf]
⍝[of]:Miscellaneous Helpers
rth	,←'V*grdv;I grdc;',nl
rth	,←'I gucmpi(const V*xp,const V*yp){I*v=grdv;',nl
rth	,←' I x=*(I*)xp;I y=*(I*)yp;I z=0;',nl
rth	,←' DO(i,grdc){z=v[x*grdc+i]-v[y*grdc+i];if(z)break;}',nl
rth	,←' if(z)R z;R x-y;}',nl
rth	,←'I gucmpf(const V*xp,const V*yp){D*v=grdv;',nl
rth	,←' I x=*(I*)xp;I y=*(I*)yp;I z=0;',nl
rth	,←' DO(i,grdc){z=v[x*grdc+i]-v[y*grdc+i];if(z)break;}',nl
rth	,←' if(z)R z;R x-y;}',nl
rth	,←'I gdcmpi(const V*xp,const V*yp){I*v=grdv;',nl
rth	,←' I x=*(I*)xp;I y=*(I*)yp;I z=0;',nl
rth	,←' DO(i,grdc){z=v[y*grdc+i]-v[x*grdc+i];if(z)break;}',nl
rth	,←' if(z)R z;R x-y;}',nl
rth	,←'I gdcmpf(const V*xp,const V*yp){D*v=grdv;',nl
rth	,←' I x=*(I*)xp;I y=*(I*)yp;I z=0;',nl
rth	,←' DO(i,grdc){z=v[y*grdc+i]-v[x*grdc+i];if(z)break;}',nl
rth	,←' if(z)R z;R x-y;}',nl
⍝[cf]
⍝[cf]
⍝[of]:Function Entry
frt	←'static V '
fre	←' EXPORT '
foi	←'if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}',nl
flp	←'(A*z,A*l,A*r,A*penv[])'
elp	←'(S lp*z,S lp*l,S lp*r)'
tps	←'A cl,cr;cl.v=NULL;cr.v=NULL;cpda(&cr,r);if(l!=NULL)cpda(&cl,l);',nl
tps	,←'int tp=0;switch(ETYPE(r)){',nl
tps	,←'case APLSI:case APLTI:case APLI:break;',nl
tps	,←'case APLD:tp=4;break;case APLU8:tp=8;break;',nl
tps	,←'default:dwaerr(16);}',nl
tps	,←'if(l==NULL)tp+=3;else switch(ETYPE(l)){',nl
tps	,←'case APLSI:case APLTI:case APLI:break;',nl
tps	,←'case APLD:tp+=1;break;case APLU8:tp+=2;break;',nl
tps	,←'default:dwaerr(16);}',nl
tps	,←'A za;za.v=NULL;',nl,'switch(tp){',nl
fcln	←'frea(&cl);',nl,'frea(&cr);',nl,'frea(&za);',nl
dcl	←{(0>e)⊃((⊃⊃v⍵),(⍺⊃tdn),'(',⍺⍺,',env);')('dwaerr(',(cln⍕|e←⊃(⍺⌷tdi)⌷⍉⊃y⍵),');')}
dcp	←{(0>e)⊃('cpad(z,&za,',(⊃gie 0⌈e←⊃(⍺⌷tdi)⌷⍉⊃y⍵),');')''}
case	←{'case ',(⍕⍺),':',(⍺('&za,&cl,&cr'dcl)⍵),(⍺ dcp ⍵),'break;',nl}
fnacc	←{(pacc 'data copyin(env0[:',(⍕⊃v⍵),'])'),'{'}
fndy	←{'V',fre,(⊃n⍵),elp,'{',nl,foi,tps,(⊃,/(⍳12)case¨⊂⍵),'}',nl,fcln,'}'}
fncd	←{'I',fre,(⊃n⍵),(⍺⊃tdn),'(A*z,A*l,A*r){',(⍺('z,l,r'dcl)⍵),'R ',(cln⍕⊃(⍺⌷tdi)⌷⍉⊃y⍵),';}',nl}
⍝[cf]
⍝[of]:Symbol → Name Table
syms	←,¨	'+'	'-'	'×'	'÷'	'*'	'⍟'	'|'	'○'	'⌊'	'⌈'	'!'	'<'
nams	←	'add'	'sub'	'mul'	'div'	'exp'	'log'	'res'	'cir'	'min'	'max'	'fac'	'lth'
syms	,←,¨	'≤'	'='	'≥'	'>'	'≠'	'~'	'∧'	'∨'	'⍲'	'⍱'	'⌷'	'['
nams	,←	'lte'	'eql'	'gte'	'gth'	'neq'	'not'	'and'	'lor'	'nan'	'nor'	'sqd'	'brk'
syms	,←,¨	'⍳'	'⍴'	','	'⍪'	'⌽'	'⍉'	'⊖'	'∊'	'⊃'	'≡'	'≢'	'⊢'
nams	,←	'iot'	'rho'	'cat'	'ctf'	'rot'	'trn'	'rtf'	'mem'	'dis'	'eqv'	'nqv'	'rgt'
syms	,←,¨	'⊣'	'⊤'	'⊥'	'/'	'⌿'	'\'	'⍀'	'?'	'↑'	'↓'	'¨'	'⍨'
nams	,←	'lft'	'enc'	'dec'	'red'	'rdf'	'scn'	'scf'	'rol'	'tke'	'drp'	'map'	'com'
syms	,←,¨	'.'	'⍤'	'⍣'	'∘'	'∪'	'∩'	'⍋'	'⍒'
nams	,←	'dot'	'rnk'	'pow'	'jot'	'unq'	'int'	'gdu'	'gdd'
⍝[cf]
⍝[of]:Generator Dispatch
gcl←{	⍺	←⍬ ⍬ ⍬
	v e y	←⍵
	id	←(syms⍳¯1↑v)⊃nams,⊂''
	tp	←(2↑1↓y)⊃¨⊂'xifbn'
	sla	←((∧/¯1=↑3↑e)+0≠(⊃0⍴⊃)¨3↑v)⊃¨⊂'las'
	''≢id:	(⍺,⊂⍵⍵)(⍎id,⍺⍺,tp,sla)⍵
  		(2↑y)((⊃⌽v)fcl ⍵⍵)(2↑v),⍪2↑e
		⎕SIGNAL 16}
⍝[cf]
⍝[of]:Scalar Primitives
⍝[of]:Old Scalar Database Tables
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
sdb⍪←,¨'!'  'tgamma(1+⍵)'  '⍵<⍺?0:⍺==1?⍵:tgamma(1+⍵)/(tgamma(1+⍺)*tgamma(1+⍵-⍺))' '255' '(~⍺)|⍵'
sdb⍪←,¨'<'  'dwaerr(99)'   '⍺<⍵'                 'dwaerr(99)' '(~⍺)&⍵'
sdb⍪←,¨'≤'  'dwaerr(99)'   '⍺<=⍵'                'dwaerr(99)' '(~⍺)|⍵'
sdb⍪←,¨'='  'dwaerr(99)'   '⍺==⍵'                'dwaerr(99)' '(⍺&⍵)|((~⍺)&(~⍵))'
sdb⍪←,¨'≥'  'dwaerr(99)'   '⍺>=⍵'                'dwaerr(99)' '⍺|(~⍵)'
sdb⍪←,¨'>'  'dwaerr(99)'   '⍺>⍵'                 'dwaerr(99)' '⍺&(~⍵)'
sdb⍪←,¨'≠'  'dwaerr(99)'   '⍺!=⍵'                'dwaerr(99)' '⍺^⍵'
sdb⍪←,¨'~'  '0==⍵'        'dwaerr(16)'           '~⍵'        'dwaerr(16)'
sdb⍪←,¨'∧'  'dwaerr(99)'   'lcm(⍺,⍵)'            'dwaerr(99)' '⍺&⍵'
sdb⍪←,¨'∨'  'dwaerr(99)'   'gcd(⍺,⍵)'            'dwaerr(99)' '⍺|⍵'
sdb⍪←,¨'⍲'  'dwaerr(99)'   '!(⍺ && ⍵)'           'dwaerr(99)' '~(⍺&⍵)'
sdb⍪←,¨'⍱'  'dwaerr(99)'   '!(⍺ || ⍵)'           'dwaerr(99)' '~(⍺|⍵)'
sdb⍪←,¨'⌷'  '⍵'           'dwaerr(99)'           '⍵'         'dwaerr(99)'
sdb⍪←'⎕XOR' 'dwaerr(99)'   '⍺^⍵'                 'dwaerr(99)' '⍺ ^ ⍵'
⍝[cf]
⍝[of]:Utilities
⍝[of]:Header
scldfhd←{((tz dz tr dr tl dl)(rgt lft))←⍺ ⍵
	z	←'{I rk;B sp[15];',('r'(tr decarr)rgt),'l'(tl decarr)lft
	z	,←'if(lr==rr){DOI(i,lr){if(rs[i]!=ls[i])dwaerr(5);}',nl
	z	,←'}else if(lr&&rr){dwaerr(4);}',nl
	z	,←'if(rr){rk=rr;DOI(i,rr){sp[i]=rs[i];}}',nl
	z	,←'else{rk=lr;DOI(i,lr){sp[i]=ls[i];}}',nl
	pres	←⊃{⍺,',',⍵}/'zrl'{⍺,'v[:',⍺,('cz'⊃⍨3=⍵),']'}¨dz dr dl
		z,(('rk,sp,',⍕dz)(tz dectmp)'z'),(acdt'present(',pres,')'),'{',nl}
sclmfhd←{((tz dz tr dr)rgt)←⍺ ⍵
	z	←'{',('r'(tr decarr)rgt),(('rr,rs,',⍕dz)(tz dectmp)'z')
	pres	←⊃{⍺,',',⍵}/'zr'{⍺,'v[:',⍺,('cz'⊃⍨3=⍵),']'}¨dz dr
		z,(acdt'present(',pres,')'),'{',nl}
⍝[cf]
⍝[of]:Loops
⍝[of]:N ← N N
scldfnnn←{	z	←'if(rr&&lr){',nl,simd'independent'
	z	,←' DO(i,zc){',nl
	z	,←'  ',('df'gcl ⍵⍵)('zv[i]' 'rv[i]' 'lv[i]' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←' }',nl
	z	,←'}else if(rr){',nl,simd'independent'
	z	,←' DO(i,zc){',nl
	z	,←'  ',('df'gcl ⍵⍵)('zv[i]' 'rv[i]' 'lv[0]' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←' }',nl
	z	,←'}else{',nl,simd'independent'
	z	,←' DO(i,zc){',nl
	z	,←'  ',('df'gcl ⍵⍵)('zv[i]' 'rv[0]' 'lv[i]' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←' }',nl
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:B ← N N
scldfbnn←{	z	←'B zc8=(zc+7)/8;if(rr&&lr){',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' 'rv[i*8+j]' 'lv[i*8+j]' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
	z	,←'}else if(rr){',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' 'rv[i*8+j]' 'lv[0]' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
	z	,←'}else{',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' 'rv[0]' 'lv[i*8+j]' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:B ← B N
scldfbbn←{e←4⍴⊂¯1 ¯1 ⋄ t←3 1(2⌷⍵)0
	z	←'B zc8=(zc+7)/8;if(rr&&lr){',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' '(1&(rv[i]>>j))' 'lv[i*8+j]' ⍺⍺)e t
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
	z	,←'}else if(rr){',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' '(1&(rv[i]>>j))' 'lv[0]' ⍺⍺)e t
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
	z	,←'}else{',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' '(1&rv[0])' 'lv[i*8+j]' ⍺⍺)e t
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:N ← B N
scldfnbn←{e←4⍴⊂¯1 ¯1 ⋄ t←(⊃⍵)1(2⊃⍵)0
	z	←'B zc8=(zc+7)/8;if(rr&&lr){',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' '(1&(rv[i]>>j))' 'lv[i*8+j]' ⍺⍺)e t
	z	,←'  }}',nl
	z	,←'}else if(rr){',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' '(1&(rv[i]>>j))' 'lv[0]' ⍺⍺)e t
	z	,←'  }}',nl
	z	,←'}else{',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' '(1&rv[0])' 'lv[i*8+j]' ⍺⍺)e t
	z	,←'  }}',nl
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:B ← N B
scldfbnb←{e←4⍴⊂¯1 ¯1 ⋄ t←(2↑⍵),1 0
	z	←'B zc8=(zc+7)/8;if(rr&&lr){',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' 'rv[i*8+j]' '(1&(lv[i]>>j))' ⍺⍺)e t
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
	z	,←'}else if(rr){',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' 'rv[i*8+j]' '(1&lv[0])' ⍺⍺)e t
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
	z	,←'}else{',nl,simd'independent'
	z	,←' DO(i,zc8){U8 val=0;',nl
	z	,←'  DOI(j,8){U8 tmp;',nl
	z	,←'   ',('df'gcl ⍵⍵)('tmp' 'rv[0]' '(1&(lv[i]>>j))' ⍺⍺)e t
	z	,←'   val|=tmp<<j;',nl
	z	,←'  }',nl,'  zv[i]=val;}',nl
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:N ← N B
scldfnnb←{e←4⍴⊂¯1 ¯1 ⋄ t←(2↑⍵),1 0
	z	←'B zc8=(zc+7)/8;if(rr&&lr){',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' 'rv[i*8+j]' '(1&(lv[i]>>j))' ⍺⍺)e t
	z	,←'  }}',nl
	z	,←'}else if(rr){',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' 'rv[i*8+j]' '(1&lv[0])' ⍺⍺)e t
	z	,←'  }}',nl
	z	,←'}else{',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' 'rv[0]' '(1&(lv[i]>>j))' ⍺⍺)e t
	z	,←'  }}',nl
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:N ← B B
scldfnbb←{e←4⍴⊂¯1 ¯1 ⋄ t←(⊃⍵),1 1 0
	z	←'B zc8=(zc+7)/8;if(rr&&lr){',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' '(1&(rv[i]>>j))' '(1&(lv[i]>>j))' ⍺⍺)e t
	z	,←'  }}',nl
	z	,←'}else if(rr){',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' '(1&(rv[i]>>j))' '(1&lv[0])' ⍺⍺)e t
	z	,←'  }}',nl
	z	,←'}else{',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  DOI(j,8){',nl
	z	,←'   ',('df'gcl ⍵⍵)('zv[i*8+j]' '(1&rv[0])' '(1&(lv[i]>>j))' ⍺⍺)e t
	z	,←'  }}',nl
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:B ← B B
scldfbbb←{	z	←'B zc8=(zc+7)/8;if(rr&&lr){',nl,simd'independent'
	z	,←' DO(i,zc8){',nl
	z	,←'  ',('df'gcl ⍵⍵)('zv[i]' 'rv[i]' 'lv[i]' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←' }',nl
	z	,←'}else if(rr){',nl,simd'independent'
	z	,←' DO(i,zc8){U8 tmp=255*(1&lv[0]);',nl
	z	,←'  ',('df'gcl ⍵⍵)('zv[i]' 'rv[i]' 'tmp' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←' }',nl
	z	,←'}else{',nl,simd'independent'
	z	,←' DO(i,zc8){U8 tmp=255*(1&rv[0]);',nl
	z	,←'  ',('df'gcl ⍵⍵)('zv[i]' 'tmp' 'lv[i]' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←' }',nl
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:N ← N
sclmfnn←{	z	←((⊂⍺⍺)∊syms)⊃(acup'host(rv[:rc])')(simd'independent')
	z	,←'DO(i,zc){',nl
	z	,←('mf'gcl ⍵⍵)('zv[i]' 'rv[i]' '_' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←'}',((⊂⍺⍺)∊syms)⊃(nl,acup'device(zv[:zc])')''
		z,'}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:N ← B
sclmfnb←{	z	←'B zc8=(zc+7)/8;',nl
	z	,←((⊂⍺⍺)∊syms)⊃(acup'host(rv[:rz])')(simd'independent')
	z	,←'DO(i,zc8){',nl
	z	,←' DOI(j,8){',nl
	z	,←('mf'gcl ⍵⍵)('zv[i*8+j]' '(1&(rv[i]>>j))' '_' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←'}}',((⊂⍺⍺)∊syms)⊃(nl,acup'device(zv[:zc])')''
		z,'}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:B ← N
sclmfbn←{	z	←'B zc8=(zc+7)/8;',nl
	z	,←((⊂⍺⍺)∊syms)⊃(acup'host(rv[:rc])')(simd'independent')
	z	,←'DO(i,zc8){U8 val=0;',nl
	z	,←' DOI(j,8){U8 tmp=0;',nl
	z	,←('mf'gcl ⍵⍵)('tmp' 'rv[i*8+j]' '_' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←'  val|=tmp<<j;}',nl
	z	,←' zv[i]=val;}',nl,((⊂⍺⍺)∊syms)⊃(acup'device(zv[:zz])')''
		z,'}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[of]:B ← B
sclmfbb←{(⊂⍺⍺)∊syms:⍺(⍺⍺ sclmfbbp ⍵⍵)⍵ ⋄ ⍺(⍺⍺ sclmfbbu ⍵⍵)⍵}
sclmfbbp←{	z	←'B zc8=(zc+7)/8;',nl,simd'independent'
	z	,←'DO(i,zc8){',nl
	z	,←('mf'gcl ⍵⍵)('zv[i]' 'rv[i]' '_' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
		z,'}}',nl,'cpaa(',⍺,',&za);}',nl}
sclmfbbu←{	z	←'B zc8=(zc+7)/8;',nl,acup'host(rv[:rz])'
	z	,←'DO(i,zc8){zv[i]=0;',nl
	z	,←' DOI(j,8){U8 tmp=0;',nl
	z	,←('mf'gcl ⍵⍵)('tmp' '(1&(rv[i]>>j))' '_' ⍺⍺)(4⍴⊂¯1 ¯1)⍵
	z	,←'  zv[i]|=tmp<<j;}}',nl,acup'device(zv[:zz])'
		z,'}',nl,'cpaa(',⍺,',&za);}',nl}
⍝[cf]
⍝[cf]

scldfnnaaa←{((f t d)(tr dr tl dl)(v e y))←⍺⍺ ⍵⍵ ⍵ ⋄ rslt rgt lft←var/3↑v,⍪e
	z	←t d tr dr tl dl scldfhd rgt lft
	3=d:	z,rslt((,f)scldfbnn sdb)y
		z,rslt((,f)scldfnnn sdb)y}
scldfbbaaa←{((f t d)(tr dr tl dl)(v e y))←⍺⍺ ⍵⍵ ⍵ ⋄ rslt rgt lft←var/3↑v,⍪e
	z	←t d tr dr tl dl scldfhd rgt lft
	3=d:	z,rslt((,f)scldfbbb sdb)y
		z,rslt((,f)scldfnbb sdb)y}
scldfbnaaa←{((f t d)(tr dr tl dl)(v e y))←⍺⍺ ⍵⍵ ⍵ ⋄ rslt rgt lft←var/3↑v,⍪e
	z	←t d tr dr tl dl scldfhd rgt lft
	3=d:	z,rslt((,f)scldfbbn sdb)y
		z,rslt((,f)scldfnbn sdb)y}
scldfnbaaa←{((f t d)(tr dr tl dl)(v e y))←⍺⍺ ⍵⍵ ⍵ ⋄ rslt rgt lft←var/3↑v,⍪e
	z	←t d tr dr tl dl scldfhd rgt lft
	3=d:	z,rslt((,f)scldfbnb sdb)y
		z,rslt((,f)scldfnnb sdb)y}
sclmfnaaa←{((f t d)(tr dr)(v e y))←⍺⍺ ⍵⍵ ⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ ⍺←sdb
	z	←t d tr dr sclmfhd rgt
	3=d:	z,rslt((,f)sclmfbn ⍺)y
		z,rslt((,f)sclmfnn ⍺)y}
sclmfbaaa←{((f t d)(tr dr)(v e y))←⍺⍺ ⍵⍵ ⍵ ⋄ rslt rgt←var/2↑v,⍪e ⋄ ⍺←sdb
	z	←t d tr dr sclmfhd rgt
	3=d:	z,rslt((,f)sclmfbb ⍺)y
		z,rslt((,f)sclmfnb ⍺)y}
⍝[cf]
⍝[of]:Generators
⍝[of]:+	Addition
addmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
addmfbnsss	←addmffnsss←addmfinsss
adddfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'+',r,';',nl}
adddfbbsss	←adddfffsss←adddffisss←adddfifsss←adddfiisss
adddfiiaaa	←'+' 'I'	1 scldfnnaaa 'I'	1	'I'	1
adddfifaaa	←'+' 'D'	2 scldfnnaaa 'I'	1	'D'	2
adddffiaaa	←'+' 'D'	2 scldfnnaaa 'D'	2	'I'	1
adddfffaaa	←'+' 'D'	2 scldfnnaaa 'D'	2	'D'	2
adddfbbaaa	←'+' 'I'	1 scldfbbaaa 'U8'	3	'U8'	3
adddfbiaaa	←'+' 'I'	1 scldfbnaaa 'U8'	3	'I'	1
adddfbfaaa	←'+' 'D'	2 scldfbnaaa 'U8'	3	'D'	2
adddfibaaa	←'+' 'I'	1 scldfnbaaa 'I'	1	'U8'	3
adddffbaaa	←'+' 'D'	2 scldfnbaaa 'D'	2	'U8'	3
⍝[cf]
⍝[of]:-	Subtraction
submfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=-1*',r,';',nl}
submffnsss	←submfbnsss←submfinsss
subdfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'-',r,';',nl}
subdfbbsss	←subdfffsss←subdffisss←subdfifsss←subdfiisss
subdfiiaaa	←'-' 'I'	1 scldfnnaaa	'I'	1	'I'	1
subdfifaaa	←'-' 'D'	2 scldfnnaaa	'I'	1	'D'	2
subdffiaaa	←'-' 'D'	2 scldfnnaaa	'D'	2	'I'	1
subdfffaaa	←'-' 'D'	2 scldfnnaaa	'D'	2	'D'	2
subdfbbaaa	←'-' 'I'	1 scldfbbaaa	'U8'	3	'U8'	3
subdfbiaaa	←'-' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
subdfbfaaa	←'-' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
subdfibaaa	←'-' 'I'	1 scldfnbaaa	'I'	1	'U8'	3
subdffbaaa	←'-' 'D'	2 scldfnbaaa	'D'	2	'U8'	3
⍝[cf]
⍝[of]:×	Multiplication
mulmfbnsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
mulmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=(',r,'>0)-(',r,'<0);',nl}
mulmffnsss	←mulmfinsss
muldfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'&',r,';',nl}
muldfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'*',r,';',nl}
muldfffsss	←muldffisss←muldfifsss←muldfiisss
muldfiiaaa	←'×' 'I'	1 scldfnnaaa	'I'	1	'I'	1
muldfifaaa	←'×' 'D'	2 scldfnnaaa	'I'	1	'D'	2
muldffiaaa	←'×' 'D'	2 scldfnnaaa	'D'	2	'I'	1
muldfffaaa	←'×' 'D'	2 scldfnnaaa	'D'	2	'D'	2
muldfbbaaa	←'×' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
muldfbiaaa	←'×' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
muldfbfaaa	←'×' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
muldfibaaa	←'×' 'I'	1 scldfnbaaa	'I'	1	'U8'	3
muldffbaaa	←'×' 'D'	2 scldfnbaaa	'D'	2	'U8'	3
⍝[cf]
⍝[of]:÷	Division
divmfbnsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
divmfinsss	←{((z r l f) e y)←⍵  ⋄ z,'=1.0/',r,';',nl}
divmffnsss	←divmfinsss
divdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'&',r,';',nl}
divdfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=((D)',l,')/((D)',r,');',nl}
divdfffsss	←divdffisss←divdfifsss←divdfiisss
divdfiiaaa	←'÷' 'D'	2 scldfnnaaa	'I'	1	'I'	1
divdfifaaa	←'÷' 'D'	2 scldfnnaaa	'I'	1	'D'	2
divdfibaaa	←'÷' 'D'	2 scldfnbaaa	'I'	1	'U8'	3
divdffiaaa	←'÷' 'D'	2 scldfnnaaa	'D'	2	'I'	1
divdfffaaa	←'÷' 'D'	2 scldfnnaaa	'D'	2	'D'	2
divdffbaaa	←'÷' 'D'	2 scldfnbaaa	'D'	2	'U8'	3
divdfbiaaa	←'÷' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
divdfbfaaa	←'÷' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
divdfbbaaa	←'÷' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:*	Exponentiation
expmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=exp((D)',r,');',nl}
expmffnsss	←expmfbnsss←expmfinsss
expdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'|~',r,';',nl}
expdfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=pow((D)',l,',(D)',r,');',nl}
expdfffsss	←expdffisss←expdfifsss←expdfiisss
expdfiiaaa	←'*' 'D'	2 scldfnnaaa	'I'	1	'I'	1
expdfifaaa	←'*' 'D'	2 scldfnnaaa	'I'	1	'D'	2
expdfibaaa	←'*' 'D'	2 scldfnbaaa	'I'	1	'U8'	3
expdffiaaa	←'*' 'D'	2 scldfnnaaa	'D'	2	'I'	1
expdfffaaa	←'*' 'D'	2 scldfnnaaa	'D'	2	'D'	2
expdffbaaa	←'*' 'U8'	3 scldfnbaaa	'D'	2	'U8'	3
expdfbiaaa	←'*' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
expdfbfaaa	←'*' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
expdfbbaaa	←'*' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:⍟	Logarithm
logmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=log((D)',r,');',nl}
logmffnsss	←logmfbnsss←logmfinsss
logdfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=log((D)',r,')/log((D)',l,');',nl}
logdfffsss	←logdffisss←logdfifsss←logdfiisss
logdfiiaaa	←'⍟' 'D' 2 scldfnnaaa	'I'	1	'I'	1
logdfifaaa	←'⍟' 'D' 2 scldfnnaaa	'I'	1	'D'	2
logdffiaaa	←'⍟' 'D' 2 scldfnnaaa	'D'	2	'I'	1
logdfffaaa	←'⍟' 'D' 2 scldfnnaaa	'D'	2	'D'	2
⍝[cf]
⍝[of]:|	Residue
resmfbnsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
resmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=fabs(',r,');',nl}
resmffnsss	←resmfinsss
resdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,'&(',l,'^',r,');',nl}
resdfiisss←{	((z r l f) e y)←⍵
	x	←'if(',l,'){',nl
	x	,←' if(0<=',l,'&&0<=',r,'){',z,'=',r,'%',l,';}',nl
	x	,←' else{',z,'=',r,'-',l,'*floor((D)',r,'/(D)(',l,'+(0==',l,')));}}',nl
		x,'else{',z,'=',r,';}',nl}
resdfffsss←{	((z r l f) e y)←⍵
	x	←'if(',l,'){',nl
	x	,←' if(0<=',l,'&&0<=',r,'){',z,'=fmod((D)',r,',(D)',l,');}',nl
	x	,←' else{',z,'=',r,'-',l,'*floor((D)',r,'/(D)(',l,'+(0==',l,')));}}',nl
		x,'else{',z,'=',r,';}',nl}
resdffisss	←resdfifsss←resdfffsss
resdfiiaaa	←'|' 'I'	1 scldfnnaaa	'I'	1	'I'	1
resdfifaaa	←'|' 'D'	2 scldfnnaaa	'I'	1	'D'	2
resdfibaaa	←'|' 'I'	1 scldfnbaaa	'I'	1	'U8'	3
resdffiaaa	←'|' 'D'	2 scldfnnaaa	'D'	2	'I'	1
resdfffaaa	←'|' 'D'	2 scldfnnaaa	'D'	2	'D'	2
resdffbaaa	←'|' 'D'	2 scldfnbaaa	'D'	2	'U8'	3
resdfbiaaa	←'|' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
resdfbfaaa	←'|' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
resdfbbaaa	←'|' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:⌊	Floor
minmffnsss	←{((z r l f) e y)←⍵ ⋄ z,'=floor(',r,');',nl}
minmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
minmfbnsss	←minmfinsss
mindfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'&',r,';',nl}
mindfiisss	←{((z r l f) e y)←⍵ ⋄ 'if(',l,'<',r,')',z,'=',l,';else ',z,'=',r,';',nl}
mindfffsss	←mindffisss←mindfifsss←mindfiisss
mindfiiaaa	←'⌊' 'I'	1 scldfnnaaa	'I'	1	'I'	1
mindfifaaa	←'⌊' 'D'	2 scldfnnaaa	'I'	1	'D'	2
mindfibaaa	←'⌊' 'I'	1 scldfnbaaa	'I'	1	'U8'	3
mindffiaaa	←'⌊' 'D'	2 scldfnnaaa	'D'	2	'I'	1
mindfffaaa	←'⌊' 'D'	2 scldfnnaaa	'D'	2	'D'	2
mindffbaaa	←'⌊' 'D'	2 scldfnbaaa	'D'	2	'U8'	3
mindfbiaaa	←'⌊' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
mindfbfaaa	←'⌊' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
mindfbbaaa	←'⌊' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:⌈	Ceiling
maxmffnsss	←{((z r l f) e y)←⍵ ⋄ z,'=ceil(',r,');',nl}
maxmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
maxmfbnsss	←maxmfinsss
maxdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'|',r,';',nl}
maxdfiisss	←{((z r l f) e y)←⍵ ⋄ 'if(',l,'>',r,')',z,'=',l,';else ',z,'=',r,';',nl}
maxdfffsss	←maxdffisss←maxdfifsss←maxdfiisss
maxdfiiaaa	←'⌈' 'I'	1 scldfnnaaa	'I'	1	'I'	1
maxdfifaaa	←'⌈' 'D'	2 scldfnnaaa	'I'	1	'D'	2
maxdfibaaa	←'⌈' 'I'	1 scldfnbaaa	'I'	1	'U8'	3
maxdffiaaa	←'⌈' 'D'	2 scldfnnaaa	'D'	2	'I'	1
maxdfffaaa	←'⌈' 'D'	2 scldfnnaaa	'D'	2	'D'	2
maxdffbaaa	←'⌈' 'D'	2 scldfnbaaa	'D'	2	'U8'	3
maxdfbiaaa	←'⌈' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
maxdfbfaaa	←'⌈' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
maxdfbbaaa	←'⌈' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:~	Not
notmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=(0==',r,');',nl}
notmffnsss	←notmfinsss
notmfbnsss	←{((z r l f) e y)←⍵ ⋄ z,'=~',r,';',nl}
⍝[cf]
⍝[of]:<	Less Than
lthdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=(~',l,')&',r,';',nl}
lthdfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'<',r,';',nl}
lthdfffsss	←lthdffisss←lthdfifsss←lthdfiisss
lthdfiiaaa	←'<' 'U8'3 scldfnnaaa	'I'	1	'I'	1
lthdfifaaa	←'<' 'U8'3 scldfnnaaa	'I'	1	'D'	2
lthdfibaaa	←'<' 'U8'3 scldfnbaaa	'I'	1	'U8'	3
lthdffiaaa	←'<' 'U8'3 scldfnnaaa	'D'	2	'I'	1
lthdfffaaa	←'<' 'U8'3 scldfnnaaa	'D'	2	'D'	2
lthdffbaaa	←'<' 'U8'3 scldfnbaaa	'D'	2	'U8'	3
lthdfbiaaa	←'<' 'U8'3 scldfbnaaa	'U8'	3	'I'	1
lthdfbfaaa	←'<' 'U8'3 scldfbnaaa	'U8'	3	'D'	2
lthdfbbaaa	←'<' 'U8'3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:≤	Less Than or Equal
ltedfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=(~',l,')|',r,';',nl}
ltedfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'<=',r,';',nl}
ltedfffsss	←ltedffisss←ltedfifsss←ltedfiisss
ltedfiiaaa	←'≤' 'U8'3 scldfnnaaa	'I'	1	'I'	1
ltedfifaaa	←'≤' 'U8'3 scldfnnaaa	'I'	1	'D'	2
ltedfibaaa	←'≤' 'U8'3 scldfnbaaa	'I'	1	'U8'	3
ltedffiaaa	←'≤' 'U8'3 scldfnnaaa	'D'	2	'I'	1
ltedfffaaa	←'≤' 'U8'3 scldfnnaaa	'D'	2	'D'	2
ltedffbaaa	←'≤' 'U8'3 scldfnbaaa	'D'	2	'U8'	3
ltedfbiaaa	←'≤' 'U8'3 scldfbnaaa	'U8'	3	'I'	1
ltedfbfaaa	←'≤' 'U8'3 scldfbnaaa	'U8'	3	'D'	2
ltedfbbaaa	←'≤' 'U8'3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:=	Equal
eqldfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=(',l,'&',r,')|((~',l,')&(~',r,'));',nl}
eqldfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'==',r,';',nl}
eqldfffsss	←eqldffisss←eqldfifsss←eqldfiisss
eqldfiiaaa	←'=' 'U8'3 scldfnnaaa	'I'	1	'I'	1
eqldfifaaa	←'=' 'U8'3 scldfnnaaa	'I'	1	'D'	2
eqldfibaaa	←'=' 'U8'3 scldfnbaaa	'I'	1	'U8'	3
eqldffiaaa	←'=' 'U8'3 scldfnnaaa	'D'	2	'I'	1
eqldfffaaa	←'=' 'U8'3 scldfnnaaa	'D'	2	'D'	2
eqldffbaaa	←'=' 'U8'3 scldfnbaaa	'D'	2	'U8'	3
eqldfbiaaa	←'=' 'U8'3 scldfbnaaa	'U8'	3	'I'	1
eqldfbfaaa	←'=' 'U8'3 scldfbnaaa	'U8'	3	'D'	2
eqldfbbaaa	←'=' 'U8'3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:≥	Greater Than or Equal
gtedfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'|(~',r,');',nl}
gtedfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'>=',r,';',nl}
gtedfffsss	←gtedffisss←gtedfifsss←gtedfiisss
gtedfiiaaa	←'≥' 'U8'3 scldfnnaaa	'I'	1	'I'	1
gtedfifaaa	←'≥' 'U8'3 scldfnnaaa	'I'	1	'D'	2
gtedfibaaa	←'≥' 'U8'3 scldfnbaaa	'I'	1	'U8'	3
gtedffiaaa	←'≥' 'U8'3 scldfnnaaa	'D'	2	'I'	1
gtedfffaaa	←'≥' 'U8'3 scldfnnaaa	'D'	2	'D'	2
gtedffbaaa	←'≥' 'U8'3 scldfnbaaa	'D'	2	'U8'	3
gtedfbiaaa	←'≥' 'U8'3 scldfbnaaa	'U8'	3	'I'	1
gtedfbfaaa	←'≥' 'U8'3 scldfbnaaa	'U8'	3	'D'	2
gtedfbbaaa	←'≥' 'U8'3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:>	Greater Than
gthdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'&(~',r,');',nl}
gthdfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'>',r,';',nl}
gthdfffsss	←gthdffisss←gthdfifsss←gthdfiisss
gthdfiiaaa	←'>' 'U8'3 scldfnnaaa	'I'	1	'I'	1
gthdfifaaa	←'>' 'U8'3 scldfnnaaa	'I'	1	'D'	2
gthdfibaaa	←'>' 'U8'3 scldfnbaaa	'I'	1	'U8'	3
gthdffiaaa	←'>' 'U8'3 scldfnnaaa	'D'	2	'I'	1
gthdfffaaa	←'>' 'U8'3 scldfnnaaa	'D'	2	'D'	2
gthdffbaaa	←'>' 'U8'3 scldfnbaaa	'D'	2	'U8'	3
gthdfbiaaa	←'>' 'U8'3 scldfbnaaa	'U8'	3	'I'	1
gthdfbfaaa	←'>' 'U8'3 scldfbnaaa	'U8'	3	'D'	2
gthdfbbaaa	←'>' 'U8'3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:≠	Not Equal
neqdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'^',r,';',nl}
neqdfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'!=',r,';',nl}
neqdfffsss	←neqdffisss←neqdfifsss←neqdfiisss
neqdfiiaaa	←'≠' 'U8'3 scldfnnaaa	'I'	1	'I'	1
neqdfifaaa	←'≠' 'U8'3 scldfnnaaa	'I'	1	'D'	2
neqdfibaaa	←'≠' 'U8'3 scldfnbaaa	'I'	1	'U8'	3
neqdffiaaa	←'≠' 'U8'3 scldfnnaaa	'D'	2	'I'	1
neqdfffaaa	←'≠' 'U8'3 scldfnnaaa	'D'	2	'D'	2
neqdffbaaa	←'≠' 'U8'3 scldfnbaaa	'D'	2	'U8'	3
neqdfbiaaa	←'≠' 'U8'3 scldfbnaaa	'U8'	3	'I'	1
neqdfbfaaa	←'≠' 'U8'3 scldfbnaaa	'U8'	3	'D'	2
neqdfbbaaa	←'≠' 'U8'3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:∧	And
anddfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'&',r,';',nl}
anddfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=lcm(',l,',',r,');',nl}
anddfffsss	←anddffisss←anddfifsss←anddfiisss
anddfiiaaa	←'∧' 'I'	1 scldfnnaaa	'I'	1	'I'	1
anddfifaaa	←'∧' 'I'	1 scldfnnaaa	'I'	1	'D'	2
anddfibaaa	←'∧' 'I'	1 scldfnbaaa	'I'	1	'U8'	3
anddffiaaa	←'∧' 'I'	1 scldfnnaaa	'D'	2	'I'	1
anddfffaaa	←'∧' 'D'	2 scldfnnaaa	'D'	2	'D'	2
anddffbaaa	←'∧' 'I'	1 scldfnbaaa	'D'	2	'U8'	3
anddfbiaaa	←'∧' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
anddfbfaaa	←'∧' 'I'	1 scldfbnaaa	'U8'	3	'D'	2
anddfbbaaa	←'∧' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:∨	Or
lordfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=',l,'|',r,';',nl}
lordfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=gcd(',l,',',r,');',nl}
lordfffsss	←lordffisss←lordfifsss←lordfiisss
lordfiiaaa	←'∨' 'I'	1 scldfnnaaa	'I'	1	'I'	1
lordfifaaa	←'∨' 'D'	2 scldfnnaaa	'I'	1	'D'	2
lordfibaaa	←'∨' 'I'	1 scldfnbaaa	'I'	1	'U8'	3
lordffiaaa	←'∨' 'D'	2 scldfnnaaa	'D'	2	'I'	1
lordfffaaa	←'∨' 'D'	2 scldfnnaaa	'D'	2	'D'	2
lordffbaaa	←'∨' 'D'	2 scldfnbaaa	'D'	2	'U8'	3
lordfbiaaa	←'∨' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
lordfbfaaa	←'∨' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
lordfbbaaa	←'∨' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:⍲	Not And
nandfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=~(',l,'&',r,');',nl}
nandfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=!(',l,'&&',r,');',nl}
nandfffsss	←nandffisss←nandfifsss←nandfiisss
nandfiiaaa	←'⍲' 'U8'3 scldfnnaaa	'I'	1	'I'	1
nandfifaaa	←'⍲' 'U8'3 scldfnnaaa	'I'	1	'D'	2
nandfibaaa	←'⍲' 'U8'3 scldfnbaaa	'I'	1	'U8'	3
nandffiaaa	←'⍲' 'U8'3 scldfnnaaa	'D'	2	'I'	1
nandfffaaa	←'⍲' 'U8'3 scldfnnaaa	'D'	2	'D'	2
nandffbaaa	←'⍲' 'U8'3 scldfnbaaa	'D'	2	'U8'	3
nandfbiaaa	←'⍲' 'U8'3 scldfbnaaa	'U8'	3	'I'	1
nandfbfaaa	←'⍲' 'U8'3 scldfbnaaa	'U8'	3	'D'	2
nandfbbaaa	←'⍲' 'U8'3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:⍱	Not Or
nordfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=~(',l,'|',r,');',nl}
nordfiisss	←{((z r l f) e y)←⍵ ⋄ z,'=!(',l,'||',r,');',nl}
nordfffsss	←nordffisss←nordfifsss←nordfiisss
nordfiiaaa	←'⍱' 'U8'3 scldfnnaaa	'I'	1	'I'	1
nordfifaaa	←'⍱' 'U8'3 scldfnnaaa	'I'	1	'D'	2
nordfibaaa	←'⍱' 'U8'3 scldfnbaaa	'I'	1	'U8'	3
nordffiaaa	←'⍱' 'U8'3 scldfnnaaa	'D'	2	'I'	1
nordfffaaa	←'⍱' 'U8'3 scldfnnaaa	'D'	2	'D'	2
nordffbaaa	←'⍱' 'U8'3 scldfnbaaa	'D'	2	'U8'	3
nordfbiaaa	←'⍱' 'U8'3 scldfbnaaa	'U8'	3	'I'	1
nordfbfaaa	←'⍱' 'U8'3 scldfbnaaa	'U8'	3	'D'	2
nordfbbaaa	←'⍱' 'U8'3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:○	Circle Functions
cirmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=PI*',r,';',nl}
cirmffnsss	←cirmfbnsss←cirmfinsss
cirdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=circ(',l,',',r,');',nl}
cirdfffsss	←cirdffisss←cirdfifsss←cirdfiisss←cirdfbbsss
cirdfiiaaa	←'○' 'D' 2 scldfnnaaa	'I'	1	'I'	1
cirdfifaaa	←'○' 'D' 2 scldfnnaaa	'I'	1	'D'	2
cirdfibaaa	←'○' 'D' 2 scldfnbaaa	'I'	1	'U8'	3
cirdffiaaa	←'○' 'D' 2 scldfnnaaa	'D'	2	'I'	1
cirdfffaaa	←'○' 'D' 2 scldfnnaaa	'D'	2	'D'	2
cirdffbaaa	←'○' 'D' 2 scldfnbaaa	'D'	2	'U8'	3
cirdfbiaaa	←'○' 'D' 2 scldfbnaaa	'U8'	3	'I'	1
cirdfbfaaa	←'○' 'D' 2 scldfbnaaa	'U8'	3	'D'	2
cirdfbbaaa	←'○' 'D' 2 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:!	Binomial
facmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=tgamma(1+',r,');',nl}
facmffnsss	←facmfinsss
facmfbnsss	←{((z r l f) e y)←⍵ ⋄ z,'=255;',nl}
facdfbbsss	←{((z r l f) e y)←⍵ ⋄ z,'=(~',l,')|',r,';',nl}
facdfiisss←{	((z r l f) e y)←⍵
	x	←'if(',l,'>',r,')',z,'=0;',nl
		x,'else ',z,'=tgamma(1+',r,')/(tgamma(1+',l,')*tgamma(1+',r,'-',l,'));',nl}
facdfffsss	←facdffisss←facdfifsss←facdfiisss
facdfiiaaa	←'!' 'I'	1 scldfnnaaa	'I'	1	'I'	1
facdfifaaa	←'!' 'D'	2 scldfnnaaa	'I'	1	'D'	2
facdfibaaa	←'!' 'I'	1 scldfnbaaa	'I'	1	'U8'	3
facdffiaaa	←'!' 'D'	2 scldfnnaaa	'D'	2	'I'	1
facdfffaaa	←'!' 'D'	2 scldfnnaaa	'D'	2	'D'	2
facdffbaaa	←'!' 'D'	2 scldfnbaaa	'D'	2	'U8'	3
facdfbiaaa	←'!' 'I'	1 scldfbnaaa	'U8'	3	'I'	1
facdfbfaaa	←'!' 'D'	2 scldfbnaaa	'U8'	3	'D'	2
facdfbbaaa	←'!' 'U8'	3 scldfbbaaa	'U8'	3	'U8'	3
⍝[cf]
⍝[of]:⌷	Materialize
sqdmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
sqdmffnsss	←sqdmfbnsss←sqdmfinsss
⍝[cf]
⍝[cf]
⍝[of]:Loop Generators
simp	←{' present(',(⊃{⍺,',',⍵}/'d',∘⍕¨⍳≢var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵),')'}
sima	←{{' copyin(',(⊃{⍺,',',⍵}/⍵),')'}⍣(0<a)⊢'d',∘⍕¨(+/~m)+⍳a←≢⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
simr	←{' present(',(⊃{⍺,',',⍵}/'r',∘⍕¨⍳≢⊃n⍵),')'}
simc	←{fv←(⊃v⍵)fvs(⊃e⍵) ⋄ ' independent ',(simp fv),(sima fv),simr ⍵}
slpd	←'B n=(cnt+7)/8;',nl
slp	←{slpd,(simd simc ⍵),'DO(i,n){',nl,⊃,/(1⌷⍉(⊃v⍵)fvs(⊃y⍵))sip¨⍳≢(⊃v⍵)fvs(⊃e⍵)}
rk0	←'I prk=0;B sp[15];B cnt=1;',nl
rk1	←'if(prk!=(' ⋄ rk2←')->r){if(prk==0){',nl
rsp	←{'prk=(',⍵,')->r;',nl,'DO(i,prk) sp[i]=(',⍵,')->s[i];'}
rk3	←'}else if((' ⋄ rk4←')->r!=0)dwaerr(4);',nl
spt	←{'if(sp[i]!=(',⍵,')->s[i])dwaerr(4);'}
rkv	←{rk1,⍵,rk2,(rsp ⍵),rk3,⍵,rk4,'}else{',nl,'DO(i,prk){',(spt ⍵),'}}',nl}
rk5	←'if(prk!=1){if(prk==0){prk=1;sp[0]='
rka	←{rk5,l,';}else dwaerr(4);}else if(sp[0]!=',(l←⍕≢⍵),')dwaerr(4);',nl}
crk	←{⍵((⊃,/)((rkv¨var/)⊣(⌿⍨)(~⊢)),(rka¨0⌷∘⍉(⌿⍨)))0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵}
srk	←{crk(⊃v⍵)(,⍤0(⌿⍨)0≠(≢∘⍴¨⊣))(⊃e⍵)}
ste	←{'cpaa(',⍵,',&p',(⍕⍺),');',nl}
stsn	←{⊃,/((⍳8){'r',(⍕⍵),'[i*8+',(⍕⍺),']='}¨⍺),¨(⍳8){'s',(⍕⍵),'_',(⍕⍺),';',nl}¨⍵}
sts	←{i t←⍵ ⋄ 3≡t:'r',(⍕⍺),'[i]=s',(⍕i),';',nl ⋄ ⍺ stsn i}
rkp	←{'I m',(⍕⊃⌽⍺),'=(',(⍕⍵),')->r!=0;',nl}
gdp	←{(⊃git ⊃⍺),'*RSTCT d',(⍕⊃⌽⍺),'=(',⍵,')->v;',nl}
gda	←{'d',(⍕⍺),'[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl,'B m',(⍕⍺),'=1;',nl}
sfa	←{(git m/⍺),¨{((+/~m)+⍳≢⍵)gda¨⍵}⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfp	←{(m⌿⍺){(⍺,¨⍳≢⍵)(gdp,rkp)¨⍵}var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfv	←(1⌷∘⍉(⊃v)fvs(⊃y))((⊃,/)sfp,sfa)(⊃v)fvs(⊃e)
ack	←{'ai(&p',(⍕⍺),',prk,sp,',(⍕⍺⌷⍺⍺),');',nl}
gpp	←{⊃,/{'A p',(⍕⍵),';p',(⍕⍵),'.v=NULL;',nl}¨⍳≢⍵}
grs	←{(⊃git ⍺),'*RSTCT r',(⍕⍵),'=p',(⍕⍵),'.v;',nl}
spp	←(⊃s){(gpp⍵),(⊃,/(⍳≢⍵)(⍺ ack)¨⍵),(⊃,/⍺ grs¨⍳≢⍵)}(⊃n)var¨(⊃r)
sip←{	w	←⍕⍵ ⋄ 3≡⍺:(⊃git ⍺),'f',w,'=d',w,'[i*m',w,'];',nl
		⊃,/(⍕¨⍳8)((⊃git ⍺){⍺⍺,'f',⍵,'_',⍺,'=d',⍵,'[(i*8+',⍺,')*m',⍵,'];',nl})¨⊂w}
⍝[cf]
⍝[of]:Expression Generators
sfnl	←{⊃⍺⍺⌷⍨((⊂⍺)⍳⍨0⌷⍉⍺⍺),(2×∧/∨⌿3 4∘.=⍵)+4+.≠⍵}
scln	←(,¨'%&')⎕R'\\\%' '\\\&'
sstm	←{cln (,¨'⍵⍺')⎕R(scln∘⍕∘⊃¨⍺ ⍵)⊢⍺⍺(⍵⍵ sfnl)⊃∘⌽¨⍺ ⍵}
sidx←{	0=⊃⊃0⍴⊂⍵:	8⍴⊂⍵ (⍺⊃⍺⍺)
	∧/⊃3 4∨.=⊂⍺⍺:	⊂⍵ (⍺⊃⍺⍺)
	3=⍺⊃⍺⍺:	↓(⍺⊃⍺⍺),⍨⍪(⍳8){'(1&(',⍵,'>>',(⍕⍺),'))'}¨⊂⍵
		↓(⍺⊃⍺⍺),⍨⍪(⍳8){⍵,'_',⍕⍺}¨⊂⍵}
scal	←{⊃⍺⍺ sstm ⍵⍵¨/1 2(⍺ sidx)¨⍵}
sgtbn	←{⍺⍺,'|=((U8)(',⍵,'))<<',(⍕⍺),';',nl}
sgtnn	←{⍺⍺,'_',(⍕⍺),'=',⍵,';',nl}
sgtbb	←{⍺,'=',⍵,';',nl}
sget←{	nm	←(⊃git⊃⍺⍺),⊃⍺
	∧/⊃3 4∨.=⊂3↑⍺⍺:	⊃,/nm∘sgtbb¨⍵
	3=⊃⍺⍺:	nm,'=0;',nl,⊃,/(⍳8)((⊃⍺)sgtbn)¨⍵
		⊃,/(⍳8)(nm sgtnn)¨⍵}
scl	←{cln ((≢⍵)↑,¨'⍵⍺')⎕R(scln∘⍕¨⍵) ⊃⍺⌷⍨((⊂⍺⍺)⍳⍨0⌷⍉⍺),≢⍵}
⍝[cf]
⍝[of]:Scalar/Mixed Conversion
scmx	←{(⊂⍺⍺)∊0⌷⍉sdb:(⊃⍵),'=',';',⍨sdb(⍺⍺ scl)1↓⍵ ⋄ ⍺(⍺⍺ fcl ⍵⍵)⍵,⍤0⊢⊂2⍴¯1}
⍝[cf]
⍝[cf]
⍝[of]:Primitive Operators
ocl	←{⍵∘(⍵⍵{'(',(opl ⍺),(opt ⍺⍺),⍵,' ⍵⍵)'})¨1↓⍺⌷⍨(0⌷⍉⍺)⍳⊂⍺⍺}
opl	←{⊃,/{'(,''',⍵,''')'}¨⍵}
opt	←{'(',(⍕⍴⍵),'⍴',(⍕,⍵),')'}
odb	←0 5⍴⊂''

⍝[c]		Prim	Monadic	Dyadic	Monadic Bool	Dyadic Bool
odb	⍪←,¨	'⍨'	'comm'	'comd'	''	''
odb	⍪←,¨	'¨'	'eacm'	'eacd'	''	''
odb	⍪←,¨	'/'	'redm'	'redd'	''	''
odb	⍪←,¨	'⌿'	'rd1m'	'rd1d'	''	''
odb	⍪←,¨	'\'	'scnm'	'err16'	''	''
odb	⍪←,¨	'⍀'	'sc1m'	'err16'	''	''
odb	⍪←,¨	'.'	'err99'	'inpd'	''	''
odb	⍪←	'∘.'	'err99'	'oupd'	''	''

err99	←{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 99}
err16	←{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 16}

⍝[of]:Commute
comd	←{('df'gcl ⍵⍵)((1↑n),(⌽1↓n),⊂⊃⍺⍺)((1↑e),(⌽1↓e),⊂¯1 0)((1↑⍺),(⌽1↓⍺),0)⊣n e←↓⍉⍵}
comm	←{('df'gcl ⍵⍵)((1↑n),(2⍴1↑1↓n),⊂⊃⍺⍺)((1↑e),(3⍴1↑1↓e))((1↑⍺),3⍴1↑1↓⍺)⊣n e←↓⍉⍵}
⍝[cf]
⍝[of]:Each
mapmoinaaa	←{(3⊃⍺)(((0⌷⍺),(2 0⊃⍵)⊃('' '')('I' 1)('D' 2)('U8' 3))sclmfnaaa'I' 1)⍵}
mapmofnaaa	←{(3⊃⍺)(((0⌷⍺),(2 0⊃⍵)⊃('' '')('I' 1)('D' 2)('U8' 3))sclmfnaaa'D' 2)⍵}
mapmobnaaa	←{(3⊃⍺)(((0⌷⍺),(2 0⊃⍵)⊃('' '')('I' 1)('D' 2)('U8' 3))sclmfbaaa'U8' 3)⍵}
eacm	←{(⊃⍺⍺)(4⍴⊂¯1 0)(1⊃⍺⍺)('mo'gcl ⍵⍵)((0⌷⍉⍵),,¨'%u' '¨')((1⌷⍉⍵),2⍴⊂¯1 0)(⍺,4 0)}
eacd←{	chk	←'if(lr==rr){DO(i,lr){if(rs[i]!=ls[i])dwaerr(5);}}',nl
	chk	,←'else if(lr!=0&&rr!=0){dwaerr(4);}'
	siz	←'if(rr==0){zr=lr;DO(i,lr){zc*=ls[i];lc*=ls[i];zs[i]=ls[i];}}',nl
	siz	,←'else{zr=rr;DO(i,rr){zc*=rs[i];rc*=rs[i];zs[i]=rs[i];}DO(i,lr)lc*=ls[i];}'
	exe	←pacc'update host(lv[:lft->c],rv[:rgt->c])'
	exe	,←'DO(i,zc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i]' 'rv[i]' 'lv[i]'),'}',nl
	exe	,←pacc'update device(zv[:rslt->c])'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce
redm←{	idf←(,¨'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'),⊂'⎕XOR'
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 0 ''
	hid	←idf∊⍨0⌷⍺⍺
	gpf	←(,¨'+×∧∨'),⊂'⎕XOR'
	gpv	←⍕¨0 1 1 0 0 ''
	gid	←gpf∊⍨0⌷⍺⍺
	chk	←hid⊃('if(rr>0&&rs[rr-1]==0)dwaerr(11);')''
	siz	←'if(rr==0){zr=0;}',nl
	siz	,←'else{zr=rr-1;DO(i,zr){zc*=rs[i];zs[i]=rs[i];};rc=rs[zr];}'
	exe	←'I zn=',((3=⊃0⌷⍺)⊃'zc' '((zc+7)/8)'),';'
	exe	,←'I rn=',((3=⊃1⌷⍺)⊃'rc' '((rc+7)/8)'),';',nl
	exe	,←'if(rc==0){'
	exe1a	←'dwaerr(11);',nl
	exe1b	←nl,simd'present(zv[:zc])'
	exe1b	,←'DO(i,zc){zv[i]=',(idv⊃⍨idf⍳0⌷⍺⍺),';}',nl
	exe1c	←nl,simd'present(zv[:zn])'
	exe1c	,←'DO(i,zn){zv[i]=',('0' '-1' ''⊃⍨(,¨'01')⍳idv⌷⍨idf⍳0⌷⍺⍺),';}',nl
	exe	,←(2⊥hid(3=⊃0⌷⍺))⊃exe1a exe1a exe1b exe1c
	exe	,←'}else if(rc==1){'
	exe	,←nl,simd'present(zv[:zn],rv[:zn])'
	exe	,←'DO(i,zn){zv[i]=rv[i];}',nl
	exe	,←'}else if(zc==1){'
	exe3a	←nl,pacc gid⊃'update host(rv[:rc])' 'update host(rv[rc-1:1])'
	exe3a	,←(⊃git⊃⍺),'val=rv[rc-1];B n=rc-1;',nl
	exe3a	,←pacc gid⊃'enter data copyin(val)' 'kernels loop present(rv[:rc])'
	exe3a	,←'DO(i,n){',nl
	exe3a	,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[rc-(2+i)]'
	exe3a	,←gid⊃(nl,pacc'update device(val)')''
	exe3a	,←'}',nl,gid⊃(pacc'exit data delete(val)')''
	exe3a	,←'zv[0]=val;',nl,pacc'update device(zv[:1])'
	exe3b	←nl,pacc gid⊃'update host(rv[:rn])' 'update host(rv[rn-1:1])'
	exe3b	,←(⊃git⊃⍺),'val=1&(rv[rn-1]>>((rc-1)%8));B n=rc-1;',nl
	exe3b	,←pacc gid⊃'enter data copyin(val)' 'kernels loop present(rv[:rn])'
	exe3b	,←'DO(i,n){I ri=rc-(2+i);I cr=1&(rv[ri/8]>>(ri%8));',nl
	exe3b	,←gid⊃(pacc'data copyin(cr)')''
	exe3b	,←((2⍴⊃⍺),1,2↓⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'cr'
	exe3b	,←gid⊃(nl,pacc'update device(val)')''
	exe3b	,←'}',nl,gid⊃(pacc'exit data delete(val)')''
	exe3b	,←'zv[0]=',('val;' 'val<<7;'⊃⍨3=⊃0⌷⍺),nl
	exe3b	,←pacc'update device(zv[:1])'
	exe	,←(2⊥(3=2↑⍺))⊃exe3a exe3b exe3a exe3b
	exe	,←'}else if(0==zc*rc){',nl
	exe	,←'}else{'
	exe4lp  ←'kernels loop gang worker(32) present(zv[:zn],rv[:rn])'
	exe4a	←nl,pacc gid⊃'update host(rv[:rc])' exe4lp
	exe4a	,←'DO(i,zc){',(⊃git⊃⍺),'val=rv[(i*rc)+rc-1];L n=rc-1;',nl
	exe4a	,←pacc gid⊃'enter data copyin(val)' 'loop vector(32)'
	exe4a	,←'DO(j,n){',nl
	exe4a	,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[(i*rc)+(rc-(2+j))]'
	exe4a	,←gid⊃(nl,pacc'update device(val)')''
	exe4a	,←'}',nl,gid⊃(pacc'exit data delete(val)')''
	exe4a	,←'zv[i]=val;}',nl, gid⊃(pacc'update device(zv[:zc])')''
	exe4b	←nl,(simd'present(zv[:zn])'),'DO(i,zn){zv[i]=0;};B n=rc-1;',nl
	exe4b	,←pacc gid⊃'update host(rv[:rn])' exe4lp
	exe4b	,←'DO(i,zc){I si=(i*rc)+rc-1;',nl
	exe4b	,←(⊃git⊃⍺),'val=1&(rv[si/8]>>(si%8));',nl
	exe4b	,←pacc gid⊃'enter data copyin(val)' 'loop vector(32)'
	exe4b	,←'DO(j,n){I ri=(i*rc)+(rc-(2+j));I cr=1&(rv[ri/8]>>(ri%8));',nl
	exe4b	,←((2⍴⊃⍺),1,2↓⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'cr'
	exe4b	,←gid⊃(nl,pacc'update device(val)')''
	exe4b	,←'}',nl,gid⊃(pacc'exit data delete(val)')''
	exe4b	,←(3=⊃0⌷⍺)⊃'zv[i]=val;' 'zv[i/8]|=val<<(i%8);'
	exe4b	,←'}',nl,gid⊃(pacc'update device(zv[:zn])')''
	exe	,←(2⊥(3=2↑⍺))⊃exe4a exe4b exe4a exe4b
	exe	,←'}'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce N-wise
redd←{	idf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
	hid	←idf∊⍨⊃⊃⍺⍺ ⋄ a←0 1 1⊃¨⊂⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(5);',nl
	chk	,←'if(rr==0)dwaerr(4);',nl,hid⊃('if(lv[0]==0)dwaerr(11);',nl)''
	chk	,←'if((rs[rr-1]+1)<lv[0])dwaerr(5);rc=(1+rs[rr-1])-lv[0];'
	siz	←'zr=rr;I n=zr-1;DOI(i,n){zc*=rs[i];zs[i]=rs[i];};zs[zr-1]=rc;lc=rs[rr-1];'
	exe	←pacc'update host(rv[:rgt->c],lv[:lft->c])'
	exe	,←'DO(i,zc){DO(j,rc){zv[(i*rc)+j]='
	exe	,←hid⊃'rv[(i*lc)+j+lv[0]-1];'(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺)
	val	←'zv[(i*rc)+j]' 'zv[(i*rc)+j]'('rv[(i*lc)+j+(lv[0]-(k+',(hid⌷'21'),'))]')
	exe	,←nl,' L n=lv[0]',(hid⊃'-1' ''),';DO(k,n){'
	exe	,←hid⊃(nl,pacc'update device(zv[(i*rc)+j:1])')''
	exe	,←(a((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
	exe	,←pacc'update device(zv[:rslt->c])'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce First Axis
rdfidf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
rdfidv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
rdfmochk	←{⍵∊rdfidf:'' ⋄ 'if(rr>0&&!rs[0])dwaerr(11);',nl}
rdfmohid←{	lp	←'else if(!jc){',nl
	lp	,←(simd''),'DO(i,zc)zv[i]=',(rdfidv⊃⍨rdfidf⍳⍵),';}',nl
	⍵∊rdfidf:	lp
		''}
rdfmoinaaa←{	fv fe fy db	←⍺
	v e y	←⍵
	fy	←¯1+⊃(4 5⊥1 4)⌷⍉fy
		(1'I',fy⊃(1'I')(2'D')(1'I'))(fv rdfmolpx db)v,⍪e}
rdfmofnaaa←{	fv fe fy db	←⍺
	v e y	←⍵
	fy	←⊃(4 5⊥2 4)⌷⍉fy
		2'D'2'D'(fv rdfmolpx db)v,⍪e}
rdfmolpx←{	rd rt d t	←⍺
	rslt rgt	←var/2↑⍵
	z	←'{',('r'(rt decarr)rgt),rdfmochk⊃⍺⍺
	z	,←'I jc=1;if(rr)jc=rs[0];',('rr?rr-1:0,rs+1,',⍕d)(t dectmp)'z'
	z	,←(acdt'present(rv[:rc],zv[:zc])'),'{',nl
	z	,←'if(jc==1){',nl,(simd''),'DO(i,zc)zv[i]=rv[i];}',nl
	z	,←(rdfmohid⊃⍺⍺),'else if(zc==1){',t,' t;',nl
	z	,←(simd''),'DO(i,1){t=rv[jc-1];}',nl,(simd''),'DO(j,jc-1){',nl
	z	,←('df'gcl ⍵⍵)(,¨'t' 't' 'rv[jc-(j+2)]' ⍺⍺)(4⍴⊂¯1 ¯1)(d d rd 0)
	z	,←'}',nl,(simd''),'DO(i,1){zv[0]=t;}}',nl,'else {',nl
	z	,←(simd''),'DO(i,zc){',t,' t=rv[(jc-1)*zc+i];',nl
	z	,←' DO(j,jc-1){',nl
	z	,←('df'gcl ⍵⍵)(,¨'t' 't' 'rv[zc*(jc-(j+2))+i]' ⍺⍺)(4⍴⊂¯1 ¯1)(d d rd 0)
	z	,←'}',nl,' zv[i]=t;}}',nl
		z,'}',nl,'cpaa(',rslt,',&za);}',nl}
rdfmobnaaa←{	fv fe fy db	←⍺
	v e y	←⍵
	1 2∨.=⊃y:	((¯1+⊃y)⊃(1'I')(2'D'))(fv rdfmolpxb db)v,⍪e
		'dwaerr(16);',nl}
rdfmolpxb←{	d t	←⍺
	rslt rgt	←var/2↑⍵
	z	←'{',('r'decarrb rgt),rdfmochk⊃⍺⍺
	z	,←'I jc=1;if(rr)jc=rs[0];',('rr?rr-1:0,rs+1,',⍕d)(t dectmp)'z'
	z	,←(acdt'present(rv[:rz],zv[:zc])'),'{',nl
	z	,←'if(jc==1){',nl,simd''
	z	,←' DO(i,zc)zv[i]=1&(rv[i/8]>>(i%8));}',nl
	z	,←rdfmohid⊃⍺⍺
	red	←'reduction(',(('+×⌈⌊∨∧'⍳⊃⍺⍺)⊃'+' '*' 'max' 'min' '||' '&&' ''),':t)'
	cal	←('df'gcl ⍵⍵)(,¨'t' 't' '(1&(rv[x/8]>>(x%8)))' ⍺⍺)(4⍴⊂¯1 ¯1)(d d 1 0)
	z	,←'else if(zc==1){',t,' t;',nl,simd''
	z	,←' DO(i,1){t=1&rv[0];}',nl,simd''
	z	,←' DO(i,jc-1){B x=i+1;',nl,cal,'}',nl,simd''
	z	,←' DOI(i,1){zv[0]=t;}',nl
	z	,←'}else{',nl,simd''
	z	,←' DO(i,zc){',t,' t=1&(rv[i/8]>>(i%8));',nl
	z	,←'  DO(j,jc-1){B x=(j+1)*zc+i;',nl,cal,'}',nl
	z	,←'  zv[i]=t;}',nl
		z,'}}',nl,'cpaa(',rslt,',&za);}',nl}
rd1m←{	fn fy	←⍺⍺
	y	←⍺
	v e	←↓⍉⍵
	fv	←,¨'_' fn '%u' '⌿'
	fe	←4⍴⊂¯1 0
		fn fe fy('mo'gcl ⍵⍵)(v,,¨'%u' '⌿')(e,2⍴⊂¯1 0)(y,4 0)}
⍝[cf]
⍝[of]:Reduce N-wise First Axis
rd1d←{	idf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
	hid	←idf∊⍨⊃⊃⍺⍺
	a	←0 1 1⊃¨⊂⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(5);',nl
	chk	,←'if(rr==0)dwaerr(4);',nl,hid⊃('if(lv[0]==0)dwaerr(11);',nl)''
	chk	,←'if((rs[0]+1)<lv[0])dwaerr(5);rc=(1+rs[0])-lv[0];'
	siz	←'zr=rr;I n=zr-1;DOI(i,n){zc*=rs[i+1];zs[i+1]=rs[i+1];};zs[0]=rc;'
	exe	←pacc'update host(rv[:rgt->c],lv[:lft->c])'
	exe	,←'DO(i,zc){DO(j,rc){zv[(j*zc)+i]='
	exe	,←hid⊃'rv[((j+lv[0]-1)*zc)+i];'(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺)
	val	←'zv[(j*zc)+i]' 'zv[(j*zc)+i]'('rv[((j+(lv[0]-(k+',(hid⌷'21'),')))*zc)+i]')
	exe	,←nl,' L n=lv[0]',(hid⊃'-1' ''),';DO(k,n){'
	exe	,←hid⊃(nl,pacc'update device(zv[(j*zc)+i:1])')''
	exe	,←(a((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
	exe	,←pacc'update device(zv[:rslt->c])'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Scan
⍝[c]Vector GPU Scan
scngv←{
	z	←'{',⍺,' b[513];I bc;B p,t,fp,ft,fpt;',nl
	z	,←'if(rc<=131072){bc=(rc+255)/256;p=256;t=1;fp=rc-256*(bc-1);ft=fpt=256;}',nl
	z	,←'else{bc=512;p=(rc+bc-1)/bc;t=(p+255)/256;',nl
	z	,←' fp=rc-p*(bc-1);ft=p-256*(t-1);fpt=fp-256*(t-1);}',nl
	z	,←(ackn'present(rv[:rc],zv[:rc]) create(b[:bc+1])'),'{',⍺,' ta[256];',nl
	z	,←(aclp''),'DOI(i,bc-1){',⍺,' t=',⍵,';B p128=(p+127)/128;',nl
	z	,←(pacc'loop vector'),' DO(j,p){I x=i*p+j;if(x<rc){',nl
	z	,←'  ',(⍺⍺,¨'t' 't' 'rv[x]'),'}}',nl,' b[i+1]=t;}',nl
	z	,←'DO(i,1){b[0]=',⍵,';}',nl,'DO(i,bc){',(⍺⍺'b[i+1]' 'b[i+1]' 'b[i]'),'}',nl
	z	,←(aclp'private(ta)'),'DOI(i,bc){',⍺,' s=b[i];B pid=i*p;',nl
	z	,←(pacc'cache(ta[:256])'),' DOI(j,t-1){B tid=pid+j*256;',nl
	z	,←(aclp''),'  DOI(k,256){ta[k]=rv[tid+k];}',nl,'  ',(⍺⍺'ta[0]' 'ta[0]' 's'),nl
	z	,←(aclp''),'  DOI(k,128){I x=k*2;',(⍺⍺'ta[x+1]' 'ta[x+1]' 'ta[x]'),'}',nl
	lp←{	b	←(aclp'collapse(2)'),'  DOI(g,',⍺,'){DOI(k,',⍵,'){I x=2*g*',⍵,'+',⍵,';'
			b,(⍺⍺'ta[x+k]' 'ta[x+k]' 'ta[x-1]'),'}}',nl}
	z	,←⍺⍺{⊃,/(⌽⍵)⍺⍺ lp¨⍵}⍕¨2*1+⍳6
	z	,←(aclp''),'  DOI(k,128){',(⍺⍺'ta[k+128]' 'ta[k+128]' 'ta[127]'),'}',nl
	z	,←(aclp''),'  DOI(k,256){zv[tid+k]=ta[k];}',nl,'  s=ta[255];}',nl
	z	,←' B sz=ft;if(i==bc-1)sz=fpt;B tid=pid+(t-1)*256;',nl
	z	,←(aclp''),' DOI(k,256){ta[k]=',⍵,';if(k<sz)ta[k]=rv[tid+k];}',nl
	z	,←' ',(⍺⍺'ta[0]' 'ta[0]' 's'),nl
	z	,←' for(I d=1;d<256;d*=2){',nl
	z	,←(aclp'collapse(2)'),'  for(I g=d;g<256;g+=d*2){',nl
	z	,←'   for(I k=0;k<d;k++){',(⍺⍺'ta[g+k]' 'ta[g+k]' 'ta[g-1]'),'}}}',nl
	z	,←(aclp''),' DOI(k,sz){zv[tid+k]=ta[k];}}',nl
		z,'}}',nl}

scnm←{	siz	←'zr=rr;if(rr)rc=rs[rr-1];DO(i,zr)zs[i]=rs[i];',nl
	siz	,←'I n;if(zr)n=zr-1;else n=0;DO(i,n)zc*=rs[i];'
	fil	←(gid←(ass←'+×⌈⌊∨∧')⍳⊃⊃⍺⍺)⊃,¨'0' '1' '-DBL_MAX' 'DBL_MAX' '0' '1' '-1'
	gpu	←(⊃git⊃⍺)(((⊃⍺),⍺)∘((⊃⍺⍺)scmx⍵⍵)scngv)fil
	exenn	←(('pg'≡2↑COMPILER)∧gid<≢ass)⊃''('if(rr==1&&rc!=0){',gpu,'}else ')
	exenn	,←'if(rc!=0){',nl,acup'host(zv[:rslt->c],rv[:rgt->c])'
	exenn	,←' DO(i,zc){B n=rc-1;B irc=i*rc;zv[irc]=rv[irc];',nl
	exenn	,←'  DO(j,n){B k=irc+j+1;zv[irc+j+1]=rv[k];',nl
	exenn	,←'   for(;k>irc;k--){',nl
	exenn	,←((⊂⊃⍺⍺)∊0⌷⍉sdb)⊃(acup'device(zv[irc+j+1:1])')''
	exenn	,←'    ',(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'zv[irc+j+1]' 'zv[irc+j+1]' 'rv[k-1]'),'}',nl
	exenn	,←'}}',nl,(acup'device(zv[:rslt->c],rv[:rgt->c])'),'}',nl
	exebb	←'if(rc!=0){B z8=(rslt->c+7)/8;B r8=(rgt->c+7)/8;',nl
	exebb	,←acup'host(zv[:z8],rv[:r8])'
	exebb	,←' DO(i,z8){zv[i]=0;}',nl
	exebb	,←' DO(i,zc){B irc=i*rc;B n=rc-1;',nl
	exebb	,←'  zv[irc/8]|=(1&(rv[irc/8]>>(irc%8)))<<(irc%8);',nl
	exebb	,←'  DO(j,n){B k=irc+j+1;U8 tmp=1&(rv[k/8]>>(k%8));',nl
	exebb	,←'   for(;k>irc;k--){U8 tmp2=1&(rv[(k-1)/8]>>((k-1)%8));',nl
	exebb	,←'    ',(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'tmp' 'tmp' 'tmp2'),'}',nl
	exebb	,←'   zv[(irc+j+1)/8]|=tmp<<((irc+j+1)%8);}}',nl
	exebb	,←(acup'device(zv[:z8],rv[:r8])'),'}',nl
	exenb	←'if(rc!=0){B r8=(rgt->c+7)/8;',nl
	exenb	,←acup'host(zv[:rslt->c],rv[:r8])'
	exenb	,←' DO(i,zc){B irc=i*rc;B n=rc-1;zv[irc]=1&(rv[irc/8]>>(irc%8));',nl
	exenb	,←'  DO(j,n){B k=irc+j+1;',(⊃git ⍺),'tmp=1&(rv[k/8]>>(k%8));',nl
	exenb	,←'   for(;k>irc;k--){U8 tmp2=1&(rv[(k-1)/8]>>((k-1)%8));',nl
	exenb	,←'    ',(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'tmp' 'tmp' 'tmp2'),'}',nl
	exenb	,←'   zv[irc+j+1]=tmp;}}',nl
	exenb	,←(acup'device(zv[:rslt->c],rv[:r8])'),'}',nl
		'' siz ((2⊥3=2↑⍺)⊃exenn exenb ('dwaerr(16);',nl) exebb) mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Scan First Axis
sc1m←{	siz	←'zr=rr;rc=rr==0?1:rs[0];DO(i,zr)zs[i]=rs[i];',nl
	siz	,←'I n=zr==0?0:zr-1;DOI(i,n)zc*=rs[i+1];'
	exe	←pacc'update host(zv[:rslt->c],rv[:rgt->c])'
	exe	,←'if(rc!=0){DO(i,zc){zv[i]=rv[i];}',nl
	val	←'zv[((j+1)*zc)+i]' 'zv[(j*zc)+i]' 'rv[((j+1)*zc)+i]'
	exe	,←' DO(i,zc){L n=rc-1;DO(j,n){'
	exe	,←((⊂⊃⍺⍺)∊0⌷⍉sdb)⊃(nl,pacc'update device(zv[(j*zc)+i:1])')''
	exe	,←(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
	exe	,←pacc'update device(zv[:rslt->c],rv[:rgt->c])'
		'' siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Outer Product
oupd←{	siz	←'zr=lr+rr;DO(i,lr)zs[i]=ls[i];DO(i,rr)zs[i+lr]=rs[i];'
	siz	,←'DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
	siz	,←nl,(3=⊃⍺)⊃'B zz=rc*lc;' 'B zz=(rc*lc+7)/8;'
	siz	,←nl,(3=1⊃⍺)⊃'B rz=rc;' 'B rz=(rc+7)/8;'
	siz	,←nl,(3=2⊃⍺)⊃'B lz=lc;' 'B lz=(lc+7)/8;'
	scl	←(⊂⊃⍺⍺)∊0⌷⍉sdb
	cpu	←pacc'update host(lv[:lz],rv[:rz])'
	gpu	←simd'present(rv[:rz],lv[:lz],zv[:zz])'
	exe	←(3=⊃⍺)⊃''(gpu,nl,'DO(i,zz){zv[i]=0;}',nl)
	exe	,←scl⊃cpu gpu
	exe	,←'DO(i,lc){DO(j,rc){',nl
	exennn	←⍺((⊃⍺⍺)scmx ⍵⍵)'zv[(i*rc)+j]' 'rv[j]' 'lv[i]'
	exennb	←'U8 tmp=1&(lv[i/8]>>(i%8));',⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i*rc+j]' 'rv[j]' 'tmp'
	exenbn	←'U8 tmp=1&(rv[j/8]>>(j%8));',⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i*rc+j]' 'tmp' 'lv[i]'
	exenbb	←'U8 t1=1&(rv[j/8]>>(j%8));U8 t2=1&(lv[i/8]>>(i%8));',nl
	exenbb	,←⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i*rc+j]' 't1' 't2'
	exebnn	←'U8 tmp=0;',⍺((⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j]' 'lv[i]'
	exebnn	,←'B x=i*rc+j;zv[x/8]|=tmp<<(x%8);',nl
	exebnb	←'U8 tmp=0;U8 lt=1&(lv[i/8]>>(i%8));',nl
	exebnb	,←⍺((⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j]' 'lt'
	exebnb	,←'B x=i*rc+j;zv[x/8]|=tmp<<(x%8);',nl
	exebbn	←'U8 tmp=0;U8 rt=1&(rv[j/8]>>(j%8));',nl
	exebbn	,←⍺((⊃⍺⍺)scmx ⍵⍵)'tmp' 'rt' 'lv[i]'
	exebbn	,←'B x=i*rc+j;zv[x/8]|=tmp<<(x%8);',nl
	exebbb	←'U8 tmp=0;U8 rt=1&(rv[j/8]>>(j%8));U8 lt=1&(lv[i/8]>>(i%8));',nl
	exebbb	,←⍺((⊃⍺⍺)scmx ⍵⍵)'tmp' 'rt' 'lt'
	exebbb	,←'B x=i*rc+j;zv[x/8]|=tmp<<(x%8);',nl
	exe	,←(2⊥3=3↑⍺)⊃exennn exennb exenbn exenbb exebnn exebnb exebbn exebbb
	exe	,←'}}',nl
	exe	,←scl⊃(pacc'update device(zv[:zz])')''
		'' siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:Inner Product
inpd←{	hid	←(idf←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖')∊⍨⊃0⊃⍺⍺ ⋄ isa←'+×⌈⌊∧∨'∊⍨⊃0⊃⍺⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 '-7'
	typ	←2⌷(4 5⊥2↑1↓⍺)⌷⍉2⊃⍺⍺
	chk	←'if(rr!=0&&lr!=0){',nl
	chk	,←'if(ls[lr-1]!=rs[0])dwaerr(5);',nl
	chk	,←(hid⊃('if(rs[0]==0)dwaerr(11);',nl)''),'}'
	siz	←'zr=0;if(lr>0){zr=lr-1;DO(i,zr)zs[i]=ls[i];}',nl
	siz	,←'if(rr>0){I n=rr-1;DOI(i,n){zs[i+zr]=rs[i+1];}zr+=rr-1;}'
	exe	←'I n=lr==0?0:lr-1;DOI(i,n)zc*=ls[i];n=rr==0?0:rr-1;DO(i,n)rc*=rs[i+1];',nl
	exe	,←'if(lr!=0)lc=ls[lr-1];else if(rr!=0)lc=rs[0];',nl
	exe	,←'B lz,rz;lz=lr==0?1:zc*lc;rz=rr==0?1:rc*lc;B m=zc*rc;',nl
	exe	,←'if(!lc){',nl
	exe	,←hid⊃''(simd'present(zv[:m])')
	exe	,←nl,⍨hid⊃'dwaerr(11);'('DO(i,m){zv[i]=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';}')
	exe	,←'}else if(',(⍕isa),'&&lr==0){',nl
	exe	,←' if(rc==1){',nl
	exe	,←'  ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←'  DO(i,lc){',(⊃git typ),'tmp;',nl
	exe	,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[i]' 'lv[0]'),nl
	exe	,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
	exe	,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
	exe	,←' }else{',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←(pacc'loop independent'),'  DO(i,rc){',nl
	exe	,←'   ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'loop'),'   DO(j,lc){',(⊃git typ),'tmp;',nl
	exe	,←'    ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j*rc+i]' 'lv[0]'),nl
	exe	,←'    ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
	exe	,←'   zv[i]=res;}}',nl
	exe	,←'}}else if(',(⍕isa),'&&rr==0){',nl
	exe	,←' if(zc==1){',nl
	exe	,←'  ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←'  DO(i,lc){',(⊃git typ),'tmp;',nl
	exe	,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[0]' 'lv[i]'),nl
	exe	,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
	exe	,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
	exe	,←' }else{',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←(pacc'loop independent'),'  DO(i,zc){',nl
	exe	,←'   ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'loop'),'   DO(j,lc){',(⊃git typ),'tmp;',nl
	exe	,←'    ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[0]' 'lv[i*lc+j]'),nl
	exe	,←'    ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
	exe	,←'   zv[i]=res;}}',nl
	exe	,←'}}else if(',(⍕isa),'&&rc==1&&zc==1){',nl
	exe	,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←' DO(i,lc){',(⊃git typ),'tmp;',nl
	exe	,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[i]' 'lv[i]'),nl
	exe	,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}}',nl
	exe	,←(pacc'parallel present(zv[:1])'),'  {zv[0]=res;}',nl
	exe	,←'}else if(',(⍕isa),'&&zc==1){',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←(pacc'loop independent'),'DO(i,rc){',nl
	exe	,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'loop'),' DO(j,lc){',(⊃git typ),'tmp;',nl
	exe	,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j*rc+i]' 'lv[j]'),nl
	exe	,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
	exe	,←' zv[i]=res;}}',nl
	exe	,←'}else if(',(⍕isa),'&&rc==1){',nl
	exe	,←(pacc'kernels present(zv[:m],lv[:lz],rv[:rz])'),'{',nl
	exe	,←(pacc'loop independent'),'DO(i,zc){',nl
	exe	,←' ',(⊃git typ),'res=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';',nl
	exe	,←(pacc'loop'),' DO(j,lc){',(⊃git typ),'tmp;',nl
	exe	,←'  ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[j]' 'lv[i*lc+j]'),nl
	exe	,←'  ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'tmp' 'res'),'}',nl
	exe	,←' zv[i]=res;}}',nl
	exe	,←'}else{',((typ=3)⊃'B m8=m;' 'B m8=(m+7)/8;'),nl
	exe	,←(pacc'kernels present(zv[:m8],lv[:lz],rv[:rz])'),'{',nl
	exe	,←((typ=3)⊃'' 'DO(i,m8){zv[i]=0;}'),nl
	exe	,←(pacc'loop independent'),'DO(i,zc){',nl
	exe	,←(pacc'loop independent'),' DO(j,rc){',(⊃git typ),'res;B n=lc-1;',nl
	exe	,←'  ',(⍺((1⊃⍺⍺)scmx ⍵⍵)'res' 'rv[((lc-1)*rc)+j]' 'lv[(i*lc)+lc-1]'),nl
	exe	,←(pacc'loop'),'  DO(k,n){',nl
	exe	,←'   ',(⊃git typ),'tmp;L ri=((lc-(k+2))*rc)+j,li=(i*lc)+lc-(k+2);',nl
	exe	,←'   ',((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)'tmp' 'rv[ri]' 'lv[li]'),nl
	exe	,←'   ',((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)'res' 'res' 'tmp'),'}',nl
	bzv	←'B x=i*rc+j;zv[x/8]|=res<<(x%8)'
	exe	,←'  ',((typ=3)⊃'zv[(i*rc)+j]=res' bzv),';}}',nl,'}}',nl
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[cf]
⍝[of]:Mixed Verbs
⍝[of]:Old Mixed Verbs Dispatch
fdb←0 5⍴⊂''
⍝⍝     Prim  Monadic        Dyadic         MBool DBool
fdb⍪←,¨'⌷'   '{⎕SIGNAL 99}' 'idxd'         ''    ''
fdb⍪←,¨'['   '{⎕SIGNAL 99}' 'brid'         ''    ''
fdb⍪←,¨'⍳'   'iotm'         'iotd' ''    ''
fdb⍪←,¨'⍴'   'shpm'         'shpd'         ''    ''
fdb⍪←,¨','   'catm'         'catd'         ''    ''
fdb⍪←,¨'⍪'   'fctm'         'fctd'         ''    ''
fdb⍪←,¨'⌽'   'rotm'         'rotd'         ''    ''
fdb⍪←,¨'⊖'   'rtfm'         'rtfd'         ''    ''
fdb⍪←,¨'∊'   'memm'         'memd'         ''    ''
fdb⍪←,¨'⊃'   'dscm'         'dscd'         ''    ''
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
fdb⍪←,¨'?'   'rolm'         'rold' ''    ''
fdb⍪←,¨'∪'   'unqm'         'unqd' ''    ''
fdb⍪←,¨'∩'   '{⎕SIGNAL 2}'         'intd' ''    ''
fdb⍪←,¨'⎕sp' '{⎕SIGNAL 99}' 'sopid'        ''    ''

⍝   Mixed Verb Dispatch/Calling
fcl←{cln ⍺(⍎⊃(((0⌷⍉⍵⍵)⍳⊂⍺⍺),¯1+≢⍵)⌷⍵⍵⍪fnc ⍺⍺)⍵}
fnc←{⍵('''',⍵,'''calm')('''',⍵,'''cald')'' ''}
⍝[cf]
⍝[of]:Old Mixed Verb Helpers
calm←{	z r     ←var/⍵
        arr     ←⍺⍺,((1⌷⍺)⊃'iifb'),'n(',z,',NULL,',r,',env);',nl
        scl     ←'{A sz,sr;sz.v=NULL;ai(&sz,0,NULL,',(⍕⊃⍺),');',nl
        scl     ,←(1⊃git ⍺⊃¨⊂0 1 2 1),'clmtmp=',r,';sr.v=&clmtmp;',nl
        scl     ,←'sr.r=0;sr.f=0;sr.c=1;sr.z=sizeof(',(1⊃git ⍺⊃¨⊂0 1 2 1),');',nl
        scl     ,←(acdt'copyin(sr.v[:sr.z])'),'{',nl
        scl     ,←⍺⍺,((1⌷⍺)⊃'iifi'),'n(&sz,NULL,&sr,env);',nl,'}',nl
        scl     ,←nl,(⊃git ⍺),'*RSTCT szv=sz.v;',nl,pacc'update host(szv[:1])'
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
        z       ,←(⊃,/(⊂''),⍺⍺{'B*RSTCT ',⍺,'s=',⍵,'->s;'}¨⍵),nl
        z       ,←⍺(⍺⍺ declv) ⍵
                z}
declv   ←{(⊃,/(⊂''),(git ⍺),¨⍺⍺{'*RSTCT ',⍺,'v=(',⍵,')->v;'}¨⍵),nl}
⍝[cf]
⍝[of]:Helpers
decarr←{	r s v c z	←⍺∘,¨'rsvcz'
	x	←'I ',r,'=(',⍵,')->r;B*',s,'=(',⍵,')->s;'
	x	,←'B ',z,'=(',⍵,')->z;B ',c,'=(',⍵,')->c;'
		x,⍺⍺,'*RSTCT ',v,'=(',⍵,')->v;',nl}
decarri	←'I'decarr
decarrf	←'D'decarr
decarrb	←'U8'decarr
declit←{	r s v c z	←⍺∘,¨'rsvcz'
	d	←(8×⌈8÷⍨≢,⍵)↑,⍵
	a	←'I ',r,'=',(⍕(1≠≢,⍵)×≢⍴⍵),';B ',z,'=',(⍕≢d),'*sizeof(',⍺⍺,');',nl
	a	,←'B ',s,'[15]={',(⊃{⍺,',',⍵}/⍕¨15↑⍴⍵),'};B ',c,'=',(⍕≢,⍵),';',nl
	a	,←⍺⍺,' ',v,'[]={',(cln ⊃{⍺,',',⍵}/⍕¨(8×⌈8÷⍨≢,⍵)↑,⍵),'};',nl
		a,pacc'enter data copyin(',v,'[:',c,'])'}
decliti	←'I'declit
declitf	←'D'declit
declitb←{	r s v c z	←⍺∘,¨'rsvcz'
	d	←2⊥⍉((8,⍨8÷⍨≢)⍴⊢)(64×⌈64÷⍨≢,⍵)↑,⍵
	a	←'I ',r,'=',(⍕(1≠≢,⍵)×≢⍴⍵),';B ',z,'=',(⍕≢d),';',nl
	a	,←'B ',s,'[15]={',(⊃{⍺,',',⍵}/⍕¨15↑⍴⍵),'};B ',c,'=',(⍕≢,⍵),';',nl
	d	←2⊥⍉((8,⍨8÷⍨≢)⍴⊢)(64×⌈64÷⍨≢,⍵)↑,⍵
	a	,←'U8 ',v,'[]={',(⊃{⍺,',',⍵}/⍕¨d),'};',nl
		a,pacc'enter data copyin(',v,'[:',z,'])'}
freelit	←{pacc'exit data delete(',⍵,'v[:',⍵,⍺,'])'}
dectmp	←{'A ',a,';',a,'.v=NULL;ai(&',a,',',⍺,');',nl,⍵(⍺⍺ decarr)'&',a←⍵,'a'}
dectmpi	←'I'dectmp
dectmpf	←'D'dectmp
dectmpb	←'U8'dectmp
rgt	←{v e y←⍵ ⋄ 1⊃var/v,⍪e}
lft	←{v e y←⍵ ⋄ 2⊃var/v,⍪e}
rslt	←{v e y←⍵ ⋄ 0⊃var/v,⍪e}
⍝[cf]
⍝[of]:Generators
⍝[of]:[]	Bracket
brid←{	chk	←'if(lr!=1)dwaerr(16);DO(i,rr)rc*=rs[i];DO(i,lr)lc*=ls[i];',nl
	chkn	←pacc'update host(rv[:rc],lv[:lc])'
	chkn	,←'DO(i,rc)if(rv[i]<0||rv[i]>=ls[0])dwaerr(3);'
	chkb	←'B n=(rc+7)/8;',nl
	chkb	,←pacc'update host(rv[:n],lv[:lc])'
	chkb	,←'DO(i,n){DO(j,8){if((1&(rv[i]>>j))>=ls[0])dwaerr(3);}}'
	chk	,←(3≡1⊃⍺)⊃chkn chkb
	siz	←'zr=rr;DOI(i,zr)zs[i]=rs[i];'
	exen	←(simd'present(zv[:rslt->c],lv[:lc],rv[:rc])'),'DO(i,rc)zv[i]=lv[rv[i]];'
	exeb	←(simd'present(zv[:rslt->c],lv[:lc],rv[:n])')
	exeb	,←'DO(i,n){DO(j,8){zv[i*8+j]=lv[1&(rv[i]>>j)];}}'
	exe	←(3≡1⊃⍺)⊃exen exeb
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:≡	Depth/Equiv
eqvmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=0;',nl}
eqvmfbnsss	←eqvmffnsss←eqvmfinsss
eqvmfinaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e 
	z	←'{ai(',rslt,',0,NULL,1);I*zv=(',rslt,')->v;',nl
	z	,←'if((',rgt,')->r==0)zv[0]=0;else zv[0]=1;',nl
		z,(pacc'update device(zv[:1])'),'}',nl}
eqvd←{	chk siz	←'' 'zr=0;'
	exe	←pacc 'update host(lv[:lft->c],rv[:rgt->c])'
	exe	,←'zv[0]=1;if(rr!=lr)zv[0]=0;',nl
	exe	,←'DO(i,lr){if(!zv[0])break;if(rs[i]!=ls[i]){zv[0]=0;break;}}',nl
	exe	,←'DO(i,lr)lc*=ls[i];',nl
	exe	,←'DO(i,lc){if(!zv[0])break;if(lv[i]!=rv[i]){zv[0]=0;break;}}',nl
	exe	,←pacc'update device(zv[:rslt->c])'
		chk siz exe mxfn 1 ⍺ ⍵}
eqvmfbnaaa←eqvmffnaaa←eqvmfinaaa
⍝[cf]
⍝[of]:⊃	First/Pick
dismfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
dismfbnsss	←dismffnsss←dismfinsss
dismfgnaaa←{	v e y	←⍵
	tc tn	←⍺
	rslt rgt	←var/2↑v,⍪e
	z	←(≡/2↑e)⊃('{A*tgt=',rslt,';')('{A tgta;A*tgt;tgta.v=NULL;tgt=tgta;')
	z	,←'ai(tgt,0,NULL,',tc,');',tn,'*zv=tgt->v;',nl
	z	,←'if((',rgt,')->c){',tn,'*rv=(',rgt,')->v;',nl
	z	,←(simd''),'DO(i,1)zv[0]=rv[0];}',nl
	z	,←'else{',nl,(simd''),'DO(i,1)zv[0]=0;}',nl
		z,(≡/2↑e)⊃('}',nl)('cpaa(',rslt,',tgt);}',nl)}
dismfinaaa	←{'1I'dismfgnaaa ⍵}
dismffnaaa	←{'2D'dismfgnaaa ⍵}
dismfbnaaa	←{'1' 'U8'dismfgnaaa ⍵}
disdfiiaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarri lft ⍵),'1'dectmpi disdfnnlp ⍵}
disdfifaaa←{		'dwaerr(16);',nl}
disdfibaaa←{		'dwaerr(16);',nl}
disdffiaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵),'2'dectmpf disdfnnlp ⍵}
disdfffaaa←{		'dwaerr(16);',nl}
disdffbaaa←{		'dwaerr(16);',nl}
disdfbiaaa←{		'dwaerr(16);',nl}
disdfbfaaa←{		'dwaerr(16);',nl}
disdfbbaaa←{		'dwaerr(16);',nl}
disdfiiala←{		'dwaerr(16);',nl}
disdfifala←{		'dwaerr(16);',nl}
disdfibala←{		'dwaerr(16);',nl}
disdffiala←{		'dwaerr(16);',nl}
disdfffala←{		'dwaerr(16);',nl}
disdffbala←{		'dwaerr(16);',nl}
disdfbiala←{		'dwaerr(16);',nl}
disdfbfala←{		'dwaerr(16);',nl}
disdfbbala←{		'dwaerr(16);',nl}
disdfiiaal←{		'dwaerr(16);',nl}
disdfifaal←{		'dwaerr(16);',nl}
disdfibaal←{		'dwaerr(16);',nl}
disdffiaal←{		'dwaerr(16);',nl}
disdfffaal←{		'dwaerr(16);',nl}
disdffbaal←{		'dwaerr(16);',nl}
disdfbiaal←{		'dwaerr(16);',nl}
disdfbfaal←{		'dwaerr(16);',nl}
disdfbbaal←{		'dwaerr(16);',nl}
disdfnnlp←{	z	←'if(lr>1)dwaerr(4);',nl
	z	,←'if(!lc){',nl,('rr,rs,',⍺)⍺⍺'z'
	z	,←(simd'present(zv[:zc],rv[:rc])'),'DO(i,zc)zv[i]=rv[i];',nl
	z	,←'cpaa(',(rslt ⍵),',&za);',nl
	z	,←'}else{if(lc!=1||rr!=1)dwaerr(4);',nl
	z	,←'I f=0;',nl,(simd''),'DOI(i,1)f=lv[0]>=rc;',nl
	z	,←'if(f)dwaerr(3);',nl
	z	,←(('0,0,',⍺)⍺⍺'z'),simd'present(zv[:zc],rv[:rc])'
	z	,←'DOI(i,1)zv[0]=rv[lv[0]];',nl
		z,'cpaa(',(rslt ⍵),',&za);}}',nl}
dscd←{		('df'gcl fdb)((0⌷⍉⍵),⊂,'⊃')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:⊤	Encode
encd←{	chk	←'if(lr>1)dwaerr(16);DO(i,lr)lc*=ls[i];',nl
	chk	,←pacc'update host(lv[:lc])'
	chk	,←'DO(i,lc){if(lv[i]<=0)dwaerr(16);}'
	siz	←'zr=1+rr;zs[0]=lc;DO(i,rr)zs[i+1]=rs[i];DO(i,rr)rc*=rs[i];'
	exe	←simd'collapse(2) present(zv[:rslt->c],rv[:rc],lv[:lc])'
	exe	,←'DO(i,rc){DO(j,lc){zv[(j*rc)+i]=(rv[i]>>(lc-(j+1)))%2;}}'
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:∊	Enlist/Membership
memmfinaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	s	←'(',rslt,')->r=1;(',rslt,')->s[0]=(',rgt,')->c;',nl
	≡/2↑e:	s
		'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl,s}
memmfbnaaa←memmffnaaa←memmfinaaa
memdfiiaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarri lft ⍵)
		z,('gucmpi'memdfnnlp'gucmpi')⍵}
memdfifaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrf lft ⍵)
		z,('gucmpf'memdfnnlp'gucmpi')⍵}
memdffiaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵)
		z,('gucmpi'memdfnnlp'gucmpf')⍵}
memdfffaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrf lft ⍵)
		z,('gucmpf'memdfnnlp'gucmpf')⍵}
memdfibaaa←{		'dwaerr(16);',nl}
memdffbaaa←{		'dwaerr(16);',nl}
memdfbbaaa←{		'dwaerr(16);',nl}
memdfbiaaa←{		'dwaerr(16);',nl}
memdfbfaaa←{		'dwaerr(16);',nl}
memdfiiaal←{		'dwaerr(16);',nl}
memdfifaal←{		'dwaerr(16);',nl}
memdffiaal←{		'dwaerr(16);',nl}
memdfffaal←{		'dwaerr(16);',nl}
memdfibaal←{		'dwaerr(16);',nl}
memdffbaal←{		'dwaerr(16);',nl}
memdfbbaal←{		'dwaerr(16);',nl}
memdfbiaal←{		'dwaerr(16);',nl}
memdfbfaal←{		'dwaerr(16);',nl}
memdfiiala←{		'dwaerr(16);',nl}
memdfifala←{		'dwaerr(16);',nl}
memdffiala←{		'dwaerr(16);',nl}
memdfffala←{		'dwaerr(16);',nl}
memdfibala←{		'dwaerr(16);',nl}
memdffbala←{		'dwaerr(16);',nl}
memdfbbala←{		'dwaerr(16);',nl}
memdfbiala←{		'dwaerr(16);',nl}
memdfbfala←{		'dwaerr(16);',nl}
memdfnnlp←{	z	←'B lx=0;B rx=0;',nl,'lr,ls,3'dectmpb'z'
	z	,←'I*li=malloc(lc*sizeof(I));if(!li)dwaerr(1);',nl
	z	,←'I*ri=malloc(rc*sizeof(I));if(!ri)dwaerr(1);',nl
	z	,←'DO(i,rc)ri[i]=i;DO(i,lc)li[i]=i;DO(i,zz)zv[i]=0;',nl
	z	,←acup'host(rv[:rc],lv[:lc])'
	z	,←'grdv=lv;grdc=1;qsort(li,lc,sizeof(I),',⍺⍺,');',nl
	z	,←'grdv=rv;grdc=1;qsort(ri,rc,sizeof(I),',⍵⍵,');',nl
	z	,←'while(rx<rc&&lx<lc){if(lv[li[lx]]<rv[ri[rx]])lx++;',nl
	z	,←' else if(lv[li[lx]]==rv[ri[rx]]){zv[li[lx]/8]|=1<<li[lx]%8;lx++;}',nl
	z	,←' else rx++;}',nl,acup'device(zv[:zz])'
		z,'free(li);free(ri);cpaa(',(rslt ⍵),',&za);}',nl}
memd←{		('df'gcl fdb)((0⌷⍉⍵),⊂,'∊')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:⍒	Grade Down
gddmfinaaa←{	z	←'{',('r'decarri rgt ⍵),'if(rr<1)dwaerr(4);',nl
	z	,←('1,rs,1'dectmpi'z'),acup'host(rv[:rc])'
	z	,←'grdc=1;DOI(i,rr-1){grdc*=rs[i+1];}',nl
	z	,←'grdv=rv;DO(i,zc){zv[i]=i;}',nl
	z	,←'qsort(zv,zc,sizeof(I),gdcmpi);',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
gddmffnaaa←{	z	←'{',('r'decarrf rgt ⍵),'if(rr<1)dwaerr(4);',nl
	z	,←('1,rs,1'dectmpi'z'),acup'host(rv[:rc])'
	z	,←'grdc=1;DOI(i,rr-1){grdc*=rs[i+1];}',nl
	z	,←'grdv=rv;DO(i,zc){zv[i]=i;}',nl
	z	,←'qsort(zv,zc,sizeof(I),gdcmpf);',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
gddmfbnaaa←{		'dwaerr(16);',nl}
⍝[cf]
⍝[of]:⍋	Grade Up
gdumfinaaa←{	z	←'{',('r'decarri rgt ⍵),'if(rr<1)dwaerr(4);',nl
	z	,←('1,rs,1'dectmpi'z'),acup'host(rv[:rc])'
	z	,←'grdc=1;DOI(i,rr-1){grdc*=rs[i+1];}',nl
	z	,←'grdv=rv;DO(i,zc){zv[i]=i;}',nl
	z	,←'qsort(zv,zc,sizeof(I),gucmpi);',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
gdumffnaaa←{	z	←'{',('r'decarrf rgt ⍵),'if(rr<1)dwaerr(4);',nl
	z	,←('1,rs,1'dectmpi'z'),acup'host(rv[:rc])'
	z	,←'grdc=1;DOI(i,rr-1){grdc*=rs[i+1];}',nl
	z	,←'grdv=rv;DO(i,zc){zv[i]=i;}',nl
	z	,←'qsort(zv,zc,sizeof(I),gucmpf);',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
gdumfbnaaa←{		'dwaerr(16);',nl}
⍝[cf]
⍝[of]:⊢	Identity/Right
rgtmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
rgtmfbnsss	←rgtmffnsss←rgtmfinsss
rgtmfinaaa	←{≡/2↑1⊃⍵:'' ⋄ 'memcpy(',(rslt⍵),',',(rgt⍵),',sizeof(A));(',(rgt⍵),')->f=0;',nl}
rgtmfinala←{	z	←'{',('r'decliti rgt⍵),'rr,rs,1'dectmpi'z'
	z	,←(simd'present(rv[:rc],zv[:zc])'),'DO(i,zc)zv[i]=rv[i];',nl
		z,'cpaa(',(rslt⍵),',&za);}',nl}
rgtmffnala←{	z	←'{',('r'declitf rgt⍵),'rr,rs,1'dectmpf'z'
	z	,←(simd'present(rv[:rc],zv[:zc])'),'DO(i,zc)zv[i]=rv[i];',nl
		z,'cpaa(',(rslt⍵),',&za);}',nl}
rgtmfbnala←{	z	←'{',('r'declitb rgt⍵),'rr,rs,1'dectmpb'z'
	z	,←(simd'present(rv[:rz],zv[:zz])'),'DO(i,zc)zv[i]=rv[i];',nl
		z,'cpaa(',(rslt⍵),',&za);}',nl}
rgtd←{	chk siz	←''('zr=rr;DO(i,rr)zs[i]=rs[i];')
	exe	←'DOI(i,zr)zc*=zs[i];',nl
	exe	,←(simd'present(zv[:zc],rv[:zc])'),'DO(i,zc)zv[i]=rv[i];'
		chk siz exe mxfn 1 ⍺ ⍵}
rgtmfbnaaa←rgtmffnaaa←rgtmfinaaa
⍝[cf]
⍝[of]:⌷	Index
idxd←{	chk	←'if(lr>1)dwaerr(4);if(lr==0)ls[0]=1;if(ls[0]>rr)dwaerr(5);'
	chk	,←'DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
	chk	,←pacc'update host(lv[:lc])'
	chk	,←'DO(i,ls[0])if(lv[i]<0||lv[i]>=rs[i])dwaerr(3);'
	siz	←'zr=rr-ls[0];DOI(i,zr)zs[i]=rs[ls[0]+i];'
	exe	←'B a,m,k=0;DOI(i,zr)zc*=zs[i];m=zc;',nl
	exe	,←'DO(i,ls[0]){a=ls[0]-(i+1);k+=m*lv[a];m*=rs[a];}',nl
	exe	,←(simd'present(rv[:rc],zv[:zc])'),'DO(i,zc)zv[i]=rv[k+i];'
	∧/,1≥≡¨⍵:	chk siz exe mxfn 1 ⍺ ⍵
	sep	←{⊃⍺{⍺,⍺⍺,⍵}/⍵}
	ixv ixe	←2⌷⍵
	ixn	←{'idx[',(⍕⍵),']'}¨⍳≢ixv
	idx	←'{A *idx[]={',(','sep ixv var¨ixe),'};',nl
	idx	,←(⊃,/(⍳≢ixv){'I ir',(⍕⍺),'=',⍵,'->r;'}¨ixn),nl
	idx	,←(⊃,/(⍳≢ixv){'B*RSTCT is',(⍕⍺),'=',⍵,'->s;'}¨ixn),nl
	idx	,←(⊃,/(⍳≢ixv){'I*RSTCT iv',(⍕⍺),'=',⍵,'->v;'}¨ixn),nl
	idx	,←(⊃,/(⍳≢ixv){'B ic',(⍕⍺),'=',⍵,'->c;'}¨ixn),nl
	idx	,←'A irz;irz.v=NULL;A*irzp=&irz;',nl
	iso	←(0 1⌷⍵)∨.≡ixe
	idx	,←iso⊃('irzp=',(irzv←⊃var/0⌷⍵),';',nl)''
	siz	←'zr=',(⍕≢ixv),';',⊃,/{'zs[',(⍕⍵),']=ic',(⍕⍵),';'}¨⍳≢ixv
	gdx	←{'+'sep (↑∘⍺¨-⌽⍳≢⍺){'(',('*'sep(⊂⍵),⍺),')'}¨⍵}
	idi	←(≢ixv)↑'ijklmnopqrstuvw'
	zidx	←({'ic',(⍕⍵),''}¨⍳≢ixv)gdx idi
	ridx	←({'rs[',(⍕⍵),']'}¨⍳≢ixv)gdx(⍳≢ixv){'iv',(⍕⍺),'[',⍵,']'}¨idi
	stm	←'zv[',zidx,']=rv[',(ridx),'];',nl
	mklp	←{i s←⍺ ⋄ (⊂'DO(',i,',',s,'){',nl),(' ',¨⍵),(⊂'}')}
	pres	←'present(zv[:rslt->c],rv[:rgt->c],'
	pres	,←(','sep{'iv',(⍕⍵),'[:ic',(⍕⍵),']'}¨⍳≢ixv),') '
	exe	←simd pres,'independent collapse(',(⍕≢ixv),')'
	exe	,←⊃,/⊃mklp/(idi{⍺('ic',⍕⍵)}¨⍳≢ixv),⊂⊂stm
	idx	,←'' siz exe mxfn 1(¯1↓⍺)('irzp'(¯2 0)⍪1↓¯1↓⍵)
	idx	,←(iso⊃''('cpaa(',irzv,',irzp);')),'}',nl
		idx}
⍝[cf]
⍝[of]:⍳	Index Gen./Index Of
iotmfinaaa←{	z	←'{',('r'decarri rgt ⍵)
	z	,←'if(rr>1)dwaerr(4);if(rc>15)dwaerr(10);if(rc!=1)dwaerr(16);',nl
	z	,←'B c=0;',nl,(simd'present(rv[:rc]) copyout(c)'),'DOI(i,1){c=rv[0];}',nl
	z	,←('1,&c,1'dectmpi 'z'),simd'present(zv[:zc])'
		z,'DOI(i,zc){zv[i]=i;}',nl,'cpaa(',(rslt⍵),',&za);}',nl}
iotmffnaaa←{	z	←'{',('r'decarrf rgt ⍵)
	z	,←'if(rr>1)dwaerr(4);if(rc>15)dwaerr(10);if(rc!=1)dwaerr(16);',nl
	z	,←'B c=0;',nl,simd'present(rv[:rc]) copyout(c)'
	z	,←'DOI(i,1){if(rv[0]!=floor(rv[0]))c=1;else c=0;}',nl
	z	,←'if(c){dwaerr(11);}',nl
	z	,←(simd'present(rv[:rc]) copyout(c)'),'DOI(i,1){c=rv[0];}',nl
	z	,←('1,&c,1'dectmpi 'z'),simd'present(zv[:zc])'
		z,'DOI(i,zc){zv[i]=i;}',nl,'cpaa(',(rslt⍵),',&za);}',nl}
iotmfbnaaa←{	z	←'{',('r'decarrb rgt ⍵)
	z	,←'if(rr>1)dwaerr(4);if(rc>15)dwaerr(10);if(rc!=1)dwaerr(16);',nl
	z	,←'B c=0;',nl,(simd'present(rv[:rc]) copyout(c)'),'DOI(i,1){c=1&rv[0];}',nl
	z	,←('1,&c,1'dectmpi 'z'),simd'present(zv[:zc])'
		z,'DO(i,zc){zv[i]=i;}',nl,'cpaa(',(rslt⍵),',&za);}',nl}
iotdfiiaaa←{		'{',('r'decarri rgt ⍵),('l'decarri lft ⍵),iotdfnnlp ⍵}
iotdfifaaa←{		'{',('r'decarri rgt ⍵),('l'decarrf lft ⍵),iotdfnnlp ⍵}
iotdfibaaa←{		'{dwaerr(16);}',nl}
iotdffiaaa←{		'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵),iotdfnnlp ⍵}
iotdfffaaa←{		'{',('r'decarrf rgt ⍵),('l'decarrf lft ⍵),iotdfnnlp ⍵}
iotdffbaaa←{		'{dwaerr(16);}',nl}
iotdfbbaaa←{		'{dwaerr(16);}',nl}
iotdfbiaaa←{		'{dwaerr(16);}',nl}
iotdfbfaaa←{		'{dwaerr(16);}',nl}
iotdfnnlp←{	z	←('rr,rs,1'dectmpi'z'),'if(zc){',nl
	z	,←simd'present(zv[:zc],rv[:rc],lv[:lc])'
	z	,←'DO(i,zc){zv[i]=lc;DO(j,lc){if(rv[i]==lv[j]){zv[i]=j;break;}}}}',nl
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
iotd	←{('df'gcl fdb)((0⌷⍉⍵),⊂,'⍳')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:∩	Intersection
intdfiiaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarri lft ⍵)
		z,('1,&uc,1'dectmpi'z')('gucmpi'intdfnnlp'gucmpi')⍵}
intdfifaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrf lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpf'intdfnnlp'gucmpi')⍵}
intdffiaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpi'intdfnnlp'gucmpf')⍵}
intdfffaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrf lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpf'intdfnnlp'gucmpf')⍵}
intdfibaaa←{		'dwaerr(16);',nl}
intdffbaaa←{		'dwaerr(16);',nl}
intdfbbaaa←{		'dwaerr(16);',nl}
intdfbiaaa←{		'dwaerr(16);',nl}
intdfbfaaa←{		'dwaerr(16);',nl}
intdfiiaal←{		'dwaerr(16);',nl}
intdfifaal←{		'dwaerr(16);',nl}
intdffiaal←{		'dwaerr(16);',nl}
intdfffaal←{		'dwaerr(16);',nl}
intdfibaal←{		'dwaerr(16);',nl}
intdffbaal←{		'dwaerr(16);',nl}
intdfbbaal←{		'dwaerr(16);',nl}
intdfbiaal←{		'dwaerr(16);',nl}
intdfbfaal←{		'dwaerr(16);',nl}
intdfiiala←{		'dwaerr(16);',nl}
intdfifala←{		'dwaerr(16);',nl}
intdffiala←{		'dwaerr(16);',nl}
intdfffala←{		'dwaerr(16);',nl}
intdfibala←{		'dwaerr(16);',nl}
intdffbala←{		'dwaerr(16);',nl}
intdfbbala←{		'dwaerr(16);',nl}
intdfbiala←{		'dwaerr(16);',nl}
intdfbfala←{		'dwaerr(16);',nl}
intdfnnlp←{	z	←'if(rr>1||lr>1)dwaerr(4);B uc=0;B lx=0;B rx=0;',nl
	z	,←'I*li=malloc(lc*sizeof(I));if(!li)dwaerr(1);',nl
	z	,←'I*ri=malloc(rc*sizeof(I));if(!ri)dwaerr(1);',nl
	z	,←'U8*f=malloc(lc*sizeof(U8));if(!f)dwaerr(1);',nl
	z	,←'DO(i,rc){ri[i]=i;};DO(i,lc){li[i]=i;f[i]=0;};',nl
	z	,←acup'host(rv[:rc],lv[:lc])'
	z	,←'grdv=lv;grdc=1;qsort(li,lc,sizeof(I),',⍺⍺,');',nl
	z	,←'grdv=rv;grdc=1;qsort(ri,rc,sizeof(I),',⍵⍵,');',nl
	z	,←'while(rx<rc&&lx<lc){if(lv[li[lx]]<rv[ri[rx]])lx++;',nl
	z	,←' else if(lv[li[lx]]==rv[ri[rx]]){uc++;f[li[lx++]]=1;}',nl
	z	,←' else rx++;}',nl
	z	,←⍺,'uc=0;DO(i,lc){if(f[i])zv[uc++]=lv[i];}',nl,acup'device(zv[:zc])'
		z,'free(li);free(ri);free(f);cpaa(',(rslt ⍵),',&za);}',nl}
intd←{		('df'gcl fdb)((0⌷⍉⍵),⊂,'∩')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:↑	Mix/Take
tkemfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
tkemfbnsss	←tkemffnsss←tkemfinsss
tkemfinaaa←{	v e y	←⍵
	≡/2↑e:	''
	rslt rgt	←var/2↑v,⍪e
		'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl}
tked←{	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(16);'
	siz	←pacc'update host(lv[:1])'
	siz	,←'zr=rr;DOI(i,zr)zs[i]=rs[i];',nl
	siz	,←'zs[0]=lv[0];I n=zr-1;DOI(i,n)zc*=zs[i+1];'
	cpy	←'ai(rslt,zr,zs,',(⍕⊃0⌷⍺),');',nl
	cpy	,←(⊃0⌷⍺)((,'z')declv),⊂'rslt'
	cpy	,←simd'independent collapse(2) present(zv[:rslt->c],rv[:rgt->c])'
	cpy	,←'DO(i,zs[0]){DO(j,zc){zv[(i*zc)+j]=rv[(i*zc)+j];}}'
	ref	←'rslt->r=zr;DOI(i,zr){rslt->s[i]=zs[i];};rslt->f=0;',nl
	ref	,←'rslt->c=zs[0]*zc;rslt->z=rslt->c*sizeof(',(⊃git ⊃0⌷⍺),');',nl
	ref	,←'rslt->v=rv;'
	exe	←cpy cpy⊃⍨0=⊃0⍴⊃⊃1 0⌷⍵
		chk siz exe mxfn 0 ⍺ ⍵}
tkemffnaaa←tkemfbnaaa←tkemfinaaa
⍝[cf]
⍝[of]:,	Ravel/Catenate
catmfinaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	s	←'(',rslt,')->r=1;(',rslt,')->s[0]=(',rgt,')->c;',nl
	≡/2↑e:	s
		'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl,s}
catmffnaaa←catmfbnaaa←catmfinaaa
catd←{	chk	←'if(rr!=0&&lr!=0&&abs(rr-lr)>1)dwaerr(4);int minr=rr>lr?lr:rr;',nl
	chk	,←'int sr=rr==lr&&lr!=0?lr-1:minr;DO(i,sr)if(rs[i]!=ls[i])dwaerr(5);'
	siz	←'zs[0]=1;if(lr>rr){zr=lr;DO(i,lr)zs[i]=ls[i];}',nl
	siz	,←'else{zr=rr;DO(i,rr)zs[i]=rs[i];}',nl
	siz	,←'zr=zr==0?1:zr;zs[zr-1]+=minr==zr?ls[zr-1]:1;'
	exe	←'DOI(i,zr)zc*=zs[i];DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
	exe	,←'B zm=zs[zr-1],zi=zc<=zm?1:zc/zm;',nl
	exe	,←'B lm=(lr<rr||lr==0)?1:ls[lr-1],rm=(rr<lr||rr==0)?1:rs[rr-1];',nl
	exe	,←'B lt=lc!=1,rt=rc!=1;',nl
	exe	,←(3=0⌷⍺)⊃'I zcp=zc;' 'I zcp=((zc+7)/8);'
	exe	,←(3=1⌷⍺)⊃'I rcp=rc;' 'I rcp=((rc+7)/8);'
	exe	,←(3=2⌷⍺)⊃'I lcp=lc;' 'I lcp=((lc+7)/8);'
	exe	,←(3=0⌷⍺)⊃''('DO(i,zcp)zv[i]=0;',nl)
	exe	,←(3=0⌷⍺)⊃nl(pacc'update host(rv[:rcp],lv[:lcp])')
	exe	,←(3=0⌷⍺)⊃(simd'independent collapse(2) present(zv[:zcp],lv[:lcp])')''
	exe	,←'DO(i,zi){DO(j,lm){I zvi=i*zm+j,lvi=lt*(i*lm+j);',nl
	exe	,←(3=0⌷⍺)⊃'zv[zvi]=' 'zv[zvi/8]|='
	exe	,←(3=2⌷⍺)⊃'lv[lvi]' '(1&(lv[lvi/8]>>(lvi%8)))'
	exe	,←(3=0⌷⍺)⊃(';}}',nl)('<<(zvi%8);}}',nl)
	exe	,←(3=0⌷⍺)⊃(simd'independent collapse(2) present(zv[:zcp],rv[:rcp])')''
	exe	,←'DO(i,zi){DO(j,rm){I zvi=i*zm+lm+j,rvi=rt*(i*rm+j);',nl
	exe	,←(3=0⌷⍺)⊃'zv[zvi]=' 'zv[zvi/8]|='
	exe	,←(3=1⌷⍺)⊃'rv[rvi]' '(1&(rv[rvi/8]>>(rvi%8)))'
	exe	,←(3=0⌷⍺)⊃(';}}',nl)('<<(zvi%8);}}',nl)
	exe	,←(3=0⌷⍺)⊃''(pacc'update device(zv[:zcp])')
		chk siz exe mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:/	Replicate/Filter
fltd←{	chk	←'if(lr>1)dwaerr(4);',nl
	chk	,←'if(lr!=0&&ls[0]!=1&&rr!=0&&rs[rr-1]!=1&&ls[0]!=rs[rr-1])dwaerr(5);'
	siz	←'zr=rr==0?1:rr;I n=zr-1;DOI(i,n)zs[i]=rs[i];',nl
	siz	,←'if(lr==1)lc=ls[0];if(rr!=0)rc=rs[rr-1];zs[zr-1]=0;B last=0;',nl
	szn	←siz,pacc 'update host(lv[:lc],rv[:rgt->c])'
	szn	,←'if(lc>=rc){DO(i,lc)last+=abs(lv[i]);}else{last+=rc*abs(lv[0]);}',nl
	szn	,←'zs[zr-1]=last;DO(i,n)zc*=zs[i];'
	szb	←siz,pacc 'update host(lv[:lft->z],rv[:rgt->c])'
	szb	,←'if(lc>=rc){B n=(lc+7)/8;',nl
	szb	,←' DO(i,n){DO(j,8){if(lc>i*8+j)last+=1&(lv[i]>>j);}}',nl
	szb	,←'}else{last+=rc*(lv[0]>>7);}',nl
	szb	,←'zs[zr-1]=last;DO(i,n)zc*=zs[i];'
	exe	←'B a=0;if(rc==lc){',nl,'DO(i,lc){',nl
	exe	,←' if(lv[i]==0)continue;',nl
	exe	,←' else if(lv[i]>0){',nl
	exe	,←'  DO(j,zc){DO(k,lv[i]){zv[(j*zs[zr-1])+a+k]=rv[(j*rc)+i];}}',nl
	exe	,←'  a+=lv[i];',nl
	exe	,←' }else{',nl
	exe	,←'  DO(j,zc){L n=abs(lv[i]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}',nl
	exe	,←'  a+=abs(lv[i]);}}}',nl
	exe	,←'else if(rc>lc){',nl
	exe	,←' if(lv[0]>0){'
	exe	,←'DO(i,zc){DO(j,rc){DO(k,lv[0]){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}}',nl
	exe	,←' else if(lv[0]<0){L n=zc*zs[zr-1];DO(i,n)zv[i]=0;}}',nl
	exe	,←'else{DO(i,lc){',nl
	exe	,←' if(lv[i]==0)continue;',nl
	exe	,←' else if(lv[i]>0){',nl
	exe	,←'  DO(j,zc){DO(k,lv[i]){zv[(j*zs[zr-1])+a+k]=rv[j*rc];}}',nl
	exe	,←'  a+=lv[i];',nl
	exe	,←' }else{',nl
	exe	,←'  DO(j,zc){L n=abs(lv[i]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}',nl
	exe	,←'  a+=abs(lv[i]);}}}',nl
	exe	,←pacc 'update device(zv[:rslt->c])'
	exb	←'B a=0;if(rr==1&&rc==lc){B n=(lc+7)/8;',nl
	exb	,←' DO(i,n){DO(j,8){if(1&(lv[i]>>j))zv[a++]=rv[i*8+j];}}',nl
	exb	,←'}else if(rc==lc){B n=(lc+7)/8;',nl,'DO(i,n){DO(m,8){',nl
	exb	,←' if(1&(lv[i]>>m)){',nl
	exb	,←'  DO(j,zc){zv[(j*zs[zr-1])+a]=rv[(j*rc)+i*8+m];}',nl
	exb	,←'  a++;}}}',nl
	exb	,←'}else if(rc>lc){if(lv[0]>>7){',nl
	exb	,←'  DO(i,zc){DO(j,rc){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}',nl
	exb	,←'}else{B n=(lc+7)/8;DO(i,n){DO(m,8){',nl
	exb	,←' if(1&(lv[i]>>m)){',nl
	exb	,←'  DO(j,zc){zv[(j*zs[zr-1])+a]=rv[j*rc];}',nl
	exb	,←'  a++;}}}}',nl
	exb	,←pacc 'update device(zv[:rslt->c])'
		((3≡2⊃⍺)⊃(chk szn exe)(chk szb exb)) mxfn 1 ⍺ ⍵}
⍝[cf]
⍝[of]:⍴	Reshape/Shape
shpd←{	chk	←'if(lr==0){ls[0]=1;lr=1;}if(1!=lr)dwaerr(11);'
	siz	←pacc'update host(lv[:ls[0]])'
	siz	,←'zr=ls[0];DOI(i,zr)zc*=zs[i]=lv[i];DO(i,rr)rc*=rs[i];'
	cpy	←'ai(rslt,zr,zs,',(⍕⊃0⌷⍺),');',nl,(⊃0⌷⍺)((,'z')declv),⊂'rslt'
	cpy	,←'if(rc==0){',nl,(simd'present(zv)'),'DO(i,zc)zv[i]=0;}',nl
	cpy	,←'else{',nl
	cpyn	←cpy,(simd'present(zv[:zc],rv[:rc])'),'DO(i,zc)zv[i]=rv[i%rc];}'
	cpyb	←cpy,'I rcp=(rc+7)/8,zcp=(zc+7)/8;',nl
	cpyb	,←(simd'present(zv[:zcp],rv[:rcp])'),'DO(i,zcp){U8 b=0;',nl
	cpyb	,←' DO(j,8){I ri=(i*8+j)%rc;b|=(1&(rv[ri/8]>>(ri%8)))<<j;}',nl
	cpyb	,←' zv[i]=b;}}'
	cpy	←(3=0⌷⍺)⊃cpyn cpyb
	ref	←'rslt->r=zr;DOI(i,zr){rslt->s[i]=zs[i];};rslt->f=rgt->f;rgt->f=0;',nl
	zcp	←(3=0⌷⍺)⊃'zc' '((zc+7)/8)'
	ref	,←'rslt->c=zc;rslt->z=',zcp,'*sizeof(',(⊃git ⊃0⌷⍺),');rslt->v=rgt->v;',nl
	exe	←'if(zc<=rc){',nl,ref,'} else {',nl,cpy,nl,'}'
		chk siz (exe cpy⊃⍨0=⊃0⍴⊃⊃1 0⌷⍵) mxfn 0 ⍺ ⍵}
rhomfinaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'{B sp[15],cnt;'
	z	,←'cnt=(',rgt,')->r;DO(i,cnt)sp[i]=(',rgt,')->s[i];',nl
	z	,←'ai(',rslt,',1,&cnt,1);I*RSTCT v=(',rslt,')->v;',nl
		z,'DO(i,cnt)v[i]=sp[i];',nl,(pacc'update device(v[:cnt])'),'}',nl}
rhomfbnaaa←rhomffnaaa←rhomfinaaa
⍝[cf]
⍝[of]:⌽	Reverse/Rotate
rotmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
rotmfbnsss	←rotmffnsss←rotmfinsss
rotmfinaaa	←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'I'rotmne⊃vs ⋄ ⊃'1I'rotmnn/vs}
rotmffnaaa	←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'D'rotmne⊃vs ⋄ ⊃'2D'rotmnn/vs}
rotmlp←{	z	←'{I n=0,rk;B oc=1,ic=1,tc,*s=(',⍵,')->s;',nl
	z	,←⍺,'*RSTCT rv=(',⍵,')->v;',nl
		z,'if((rk=(',⍵,')->r)){n=rk-1;ic=s[rk-1];};DOI(i,n)oc*=s[i];tc=oc*ic;',nl}
rotmne←{	z	←(⍺ rotmlp ⍵),'n=ic/2;',nl,simd'independent present(rv[:tc])'
	z	,←'DO(i,oc){DO(j,n){',⍺,'*a,*b;a=&rv[i*ic+(ic-(j+1))];b=&rv[i*ic+j];',nl
		z,' ',⍺,' t=*a;*a=*b;*b=t;}}}',nl}
rotmnn←{	tp td	←⍺⍺
	z	←(td rotmlp ⍵),'ai(',⍺,',rk,s,',tp,');',nl
	z	,←td,'*RSTCT zv=(',⍺,')->v;',nl
	z	,←simd'independent present(zv[:tc],rv[:tc])'
		z,'DO(i,oc){DO(j,ic){zv[i*ic+j]=rv[i*ic+(ic-(j+1))];}}}',nl}
rotmfbnaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'U8'rotmlp rgt
	z	,←'B tc8=(tc+7)/8;A ta;ta.v=NULL;ai(&ta,rk,s,3);',nl
	z	,←'U8*RSTCT zv=(&ta)->v;',nl
	z	,←simd'independent present(zv[:tc8],rv[:tc8])'
	z	,←'DO(i,tc8){U8 t=0;',nl,pacc'loop reduction(|:t)'
	z	,←' DO(j,8){B ti,tr,tc;ti=i*8+j;tr=ti/ic;tc=ti%ic;',nl
	z	,←'  B ri=tr*ic+(ic-(tc+1));t|=(1&(rv[ri/8]>>(ri%8)))<<j;}',nl
		z,' zv[i]=t;}',nl,'cpaa(',rslt,',&ta);}',nl}
rotdfiiaaa	←{v e y←⍵ ⋄ '1I'rotdfxiaaa var/3↑v,⍪e}
rotdffiaaa	←{v e y←⍵ ⋄ '2D'rotdfxiaaa var/3↑v,⍪e}
rotdfiiaal	←{v e y←⍵ ⋄ '1I'rotdfxiaal(var/2↑v,⍪e),2⌷v}
rotdffiaal	←{v e y←⍵ ⋄ '2D'rotdfxiaal(var/2↑v,⍪e),2⌷v}
rotdfxiaaa←{	d t	←⍺
	a r l	←⍵
	z	←'{',('r'(t decarr)r),'l'decarri l
	z	,←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(11);',nl,('rr,rs,',d)(t dectmp)'z'
		z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,rotdfxilp a}
rotdfxiaal←{	d t	←⍺
	a r l	←⍵
	lr	←≢⍴l
	derr	←(lr≠0)∧(lr≠1)∨(⊃⍴l)≠1
	derr:	⎕SIGNAL 11
	z	←'{',('r'(t decarr)r),('rr,rs,',d)(t dectmp)'z'
		z,'I lv0=',(cln⍕l),';',nl,rotdfxilp a}
rotdfshft←{	z	←'B ic=1,jc=1;I n=0;if(rr){jc=rs[rr-1];n=rr-1;}',nl
		z,'DOI(i,n)ic*=rs[i];B s=abs(lv0);if(jc)s%=jc;if(lv0<0)s=jc-s;',nl}
rotdfxilp←{	z	←(rotdfshft⍬),simd'present(zv[:zc],rv[:zc]) independent'
	z	,←'DO(i,ic){DO(j,jc){zv[i*jc+j]=rv[i*jc+(j+s)%jc];}}',nl
		z,'cpaa(',⍵,',&za);}',nl}
rotdfbiaaa←{	v e y	←⍵
	a r l	←var/3↑v,⍪e
	z	←'{',('l'decarri l),'r'decarrb r
	z	,←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(11);',nl,'rr,rs,3'dectmpb'z'
		z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,rotdfbilp a}
rotdfbiaal←{	v e y	←⍵
	a r	←var/2↑v,⍪e
	l	←2⊃v
	lr	←≢⍴l
	derr	←(lr≠0)∧(lr≠1)∨(⊃⍴l)≠1
	derr:	⎕SIGNAL 11
		'{',('r'decarrb r),('rr,rs,3'dectmpb'z'),'I lv0=',(cln⍕l),';',nl,rotdfbilp a}
rotdfbilp←{	z	←(rotdfshft⍬),'B*RSTCT zvB=(B*)zv;B*RSTCT rvB=(B*)rv;',nl
	z	,←'{B ec=(zc+63)/64;',nl
	z	,←(ackn'present(rvB[:ec],zvB[:ec])'),'{',nl
	z	,←'DO(i,ec){B t=0;B xs=i*64;B xe=xs+64;',nl
	z	,←' while(xs<xe){B yi=xs/jc;B yj=(xs+s)%jc;B y=yi*jc+yj;I ym=y%64;',nl
	z	,←'  I cnt=64-ym;if(cnt>jc-yj)cnt=jc-yj;if(cnt>jc-xs%jc)cnt=jc-xs%jc;',nl
	z	,←'  I ts=xs%64;I sl=64-(cnt+ym);I sr=sl+ym;',nl
	z	,←'  xs+=cnt;t|=((rvB[y/64]<<sl)>>sr)<<ts;}',nl
	z	,←' zvB[i]=t;}',nl
		z,'}}',nl,'cpaa(',⍵,',&za);}',nl}
rotdfbbaaa	←{'dwaerr(16);',nl}
rotdfbbaal	←{'dwaerr(16);',nl}
rotdfibaaa	←{'dwaerr(16);',nl}
rotdfibaal	←{'dwaerr(16);',nl}
rotdffbaaa	←{'dwaerr(16);',nl}
rotdffbaal	←{'dwaerr(16);',nl}
rotd	←{('df'gcl fdb)((0⌷⍉⍵),⊂,'⌽')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:⊖	Reverse/Rotate First
rtfmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
rtfmfbnsss	←rtfmffnsss←rtfmfinsss
rtfmfinaaa	←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'I'rtfmne⊃vs ⋄ ⊃'1I'rtfmnn/vs}
rtfmffnaaa	←{v e y←⍵ ⋄ vs←var/2↑v,⍪e ⋄ ≡/2↑e:'D'rtfmne⊃vs ⋄ ⊃'2D'rtfmnn/vs}
rtfmne←{	z	←'{B cr=1,cc=1;',('r'(⍺ decarr)⍵)
	z	,←'if(rr){cr=rs[0];DOI(i,rr-1)cc*=rs[i+1];};B n=cr/2;',nl
	z	,←simd'collapse(2) independent present(rv[:rc])'
	z	,←'DO(i,n){DO(j,cc){B zvi=i*cc+j,rvi=(cr-(i+1))*cc+j;',nl
		z,⍺,' t=rv[zvi];rv[zvi]=rv[rvi];rv[rvi]=t;}}}',nl}
rtfmnn←{	tp td	←⍺⍺
	z	←'{B cr=1,cc=1;',('r'(td decarr)⍵),('rr,rs,',tp)(td dectmp)'z'
	z	,←'if(rr){cr=rs[0];DOI(i,rr-1)cc*=rs[i+1];};B n=cr/2;',nl
	z	,←simd'independent collapse(2) present(zv[:zc],rv[:rc])'
	z	,←'DO(i,cr){DO(j,cc){zv[i*cc+j]=rv[(cr-(i+1))*cc+j];}}',nl
		z,'cpaa(',⍺,',&za);}',nl}
rtfmfbnaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'{B cr=1,cc=1;',('r'decarrb rgt),'rr,rs,3'dectmpb'z'
	z	,←'if(rr){cr=rs[0];DOI(i,rr-1)cc*=rs[i+1];};',nl
	z	,←'B zBc=(zc+63)/64;B*RSTCT zBv=(B*)zv;B*RSTCT rBv=(B*)rv;',nl
	z	,←simd'independent present(rBv[:zBc],zBv[:zBc])'
	z	,←'DO(i64,zBc){zBv[i64]=0;',nl
	z	,←' for(I bi=0;bi<64;){B ci=i64*64+bi;B j=ci%cc;if(ci>=zc)break;',nl
	z	,←'  B ti=(cr-(ci/cc+1))*cc+j;B t,ti64=ti/64;B sz=64-bi;B tim=ti%64;',nl
	z	,←'  if(sz>(t=64-tim))sz=t;if(sz>(t=cc-j))sz=t;',nl
	z	,←'  B msk=UINT64_MAX>>(64-sz);msk<<=tim;',nl
	z	,←'  if(bi>tim)zBv[i64]|=(rBv[ti64]&msk)<<(bi-tim);',nl
	z	,←'  else zBv[i64]|=(rBv[ti64]&msk)>>(tim-bi);',nl
	z	,←'  bi+=sz;}}',nl
		z,'cpaa(',rslt,',&za);}',nl}
rtfdfiiaaa	←{v e y←⍵ ⋄ '1I'rtfdfxiaaa var/3↑v,⍪e}
rtfdffiaaa	←{v e y←⍵ ⋄ '2D'rtfdfxiaaa var/3↑v,⍪e}
rtfdfiiaal	←{v e y←⍵ ⋄ '1I'rtfdfxiaal(var/2↑v,⍪e),2⌷v}
rtfdffiaal	←{v e y←⍵ ⋄ '2D'rtfdfxiaal(var/2↑v,⍪e),2⌷v}
rtfdfxiaaa←{	d t	←⍺
	a r l	←⍵
	z	←'{',('r'(t decarr)r),'l'decarri l
	z	,←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(11);',nl,('rr,rs,',d)(t dectmp)'z'
		z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,t rtfdfxilp a}
rtfdfxiaal←{	d t	←⍺
	a r l	←⍵
	lr	←≢⍴l
	derr	←(lr≠0)∧(lr≠1)∨(⊃⍴l)≠1
	derr:	⎕SIGNAL 11
	z	←'{',('r'(t decarr)r),('rr,rs,',d)(t dectmp)'z'
		z,'I lv0=',(cln⍕l),';',nl,t rtfdfxilp a}
rtfdfshft←{	z	←'B ic=1;if(rr)ic=rs[0];I n=0;if(rr)n=rr-1;',nl
	z	,←'B jc=1;DOI(i,n)jc*=rs[i+1];B s=abs(lv0);if(ic)s%=ic;else s=0;',nl
		z,'if(lv0<0)s=(ic-s)*jc;else s*=jc;B zc_s=zc-s;',nl}
rtfdfxilp←{	z	←(rtfdfshft⍬),⍺,'*RSTCT rv2=rv+s;',⍺,'*RSTCT zv2=zv+zc_s;',nl
	z	,←(acdt'present(zv[:zc],rv[:zc],zv2[:s],rv2[:zc_s])'),'{',nl
	z	,←(simd'async(1) vector(256)'),'DO(i,zc_s){zv[i]=rv2[i];}',nl
	z	,←(simd'async(2) vector(256)'),'DO(i,s){zv2[i]=rv[i];}',nl
	z	,←pacc'wait'
		z,'}',nl,'cpaa(',⍵,',&za);}',nl}
rtfdfbiaaa←{	v e y	←⍵
	a r l	←var/3↑v,⍪e
	z	←'{',('l'decarri l),'r'decarrb r
	z	,←'if(lr!=0&&(lr!=1||ls[0]!=1))dwaerr(11);',nl,'rr,rs,3'dectmpb'z'
		z,'I lv0;',nl,(simd'present(lv[:1])'),'DOI(i,1)lv0=lv[0];',nl,rtfdfbilp a}
rtfdfbiaal←{	v e y	←⍵
	a r	←var/2↑v,⍪e
	l	←2⊃v
	lr	←≢⍴l
	derr	←(lr≠0)∧(lr≠1)∨(⊃⍴l)≠1
	derr:	⎕SIGNAL 11
		'{',('r'decarrb r),('rr,rs,3'dectmpb'z'),'I lv0=',(cln⍕l),';',nl,rtfdfbilp a}
rtfdfbilp←{	z	←(rtfdfshft⍬),'B ec=(zc+63)/64;',nl
	z	,←'B*RSTCT zvB=(B*)zv;B*RSTCT rvB=(B*)rv;',nl
	z	,←(acdt'present(zvB[:ec],rvB[:ec])'),'{',nl
	z	,←'if(zc){if(zc<=64){',nl,simd''
	z	,←' DOI(i,1){B t=rvB[0]&((1<<zc)-1);zvB[0]=(t<<(zc-s))|(t>>s);}',nl
	z	,←'}else{I ar=s%64;I al=64-ar;B ac=(zc_s+(ar-zc%64))/64;B ao=s/64;',nl
	z	,←' I bl=zc_s%64;I br=64-bl;B bc=(s+bl)/64;B bo=zc_s/64;',nl
	z	,←' if(ar&&bl){B m=UINT64_MAX>>br;',nl
	z	,←'  if(bl>al){',nl,simd''
	z	,←'   DO(i,ec){if(i<bo){zvB[i]=(rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al);}',nl
	z	,←'    else if(i==bo){B t=m&((rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al));',nl
	z	,←'     zvB[i]=t|(rvB[0]<<bl);}',nl
	z	,←'    else{zvB[i]=(rvB[i-(bo+1)]>>br)|(rvB[i-bo]<<bl);}}',nl
	z	,←'  }else{',nl,simd''
	z	,←'   DO(i,ec){if(i<bo){zvB[i]=(rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al);}',nl
	z	,←'    else if(i==bo){zvB[i]=(m&(rvB[i+ao]>>ar))|(rvB[0]<<bl);}',nl
	z	,←'    else{zvB[i]=(rvB[i-(bo+1)]>>br)|(rvB[i-bo]<<bl);}}}',nl	
	z	,←' }else if(ar){',nl,simd''
	z	,←'  DO(i,ec){if(i<bo){zvB[i]=(rvB[i+ao]>>ar)|(rvB[i+ao+1]<<al);}',nl
	z	,←'   else{zvB[i]=rvB[i-bo];}}',nl
	z	,←' }else if(bl){B m=UINT64_MAX>>br;',nl,simd''
	z	,←'  DO(i,ec){if(i<bo){zvB[i]=rvB[i+ao];}',nl
	z	,←'   else if(i==bo){zvB[i]=(rvB[i+ao]&m)|(rvB[0]<<bl);}',nl
	z	,←'   else{zvB[i]=(rvB[i-(bo+1)]>>br)|(rvB[i-bo]<<bl);}}',nl
	z	,←' }else{',nl,simd''
	z	,←'  DO(i,ec){if(i<bo){zvB[i]=rvB[i+ao];}else{zvB[i]=rvB[i-bo];}}}}',nl
		z,'}}',nl,'cpaa(',⍵,',&za);}',nl}
rtfdfbbaaa	←{'dwaerr(16);',nl}
rtfdfbbaal	←{'dwaerr(16);',nl}
rtfdfibaaa	←{'dwaerr(16);',nl}
rtfdfibaal	←{'dwaerr(16);',nl}
rtfdffbaaa	←{'dwaerr(16);',nl}
rtfdffbaal	←{'dwaerr(16);',nl}
rtfd	←{('df'gcl fdb)((0⌷⍉⍵),⊂,'⊖')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:⍪	Table/Catenate First
ctfmfaa←{	v e y	←⍵
	z r	←var/2↑v,⍪e
	d t	←⍺
	a	←'{B s[2];',('r'(t decarr)r),'if(rr)s[0]=rs[0];else s[0]=1;',nl
	a	,←'if(s[0])s[1]=rc/s[0];else s[1]=1;',nl
	≡/2↑e:	a,'(',z,')->r=2;(',z,')->s[0]=s[0];(',z,')->s[1]=s[1];}',nl
	cnt	←('3'≡d)⊃'zc' 'zz'
	a	,←(('2,s,',d)(t dectmp)'z'),simd'present(zv[:',cnt,'],rv[:',cnt,'])'
		a,'DO(i,',cnt,')zv[i]=rv[i];',nl,'cpaa(',z,',&za);}',nl}
ctfmfinaaa	←{'1I'ctfmfaa ⍵}
ctfmffnaaa	←{'2D'ctfmfaa ⍵}
ctfmfbnaaa	←{'3' 'U8'ctfmfaa ⍵}
ctfdpre←{	v e y	←⍵
	zd zt rt lt	←⍺
	z r l	←var/3↑v,⍪e
	a	←'{',('l'(lt decarr)l),('r'(rt decarr)r)
	a	,←'if(rr&&lr&&abs(rr-lr)>1)dwaerr(4);',nl
	a	,←'if(lr==rr&&rr){DOI(i,rr-1){if(rs[i+1]!=ls[i+1])dwaerr(5);}}',nl
	a	,←'else if(lr<rr){DOI(i,lr){if(ls[i]!=rs[i+1])dwaerr(5);}}',nl
	a	,←'else{DOI(i,rr){if(ls[i+1]!=rs[i])dwaerr(5);}}',nl
	a	,←'I rk;B sp[15];if(lr>rr){rk=lr;DOI(i,lr)sp[i]=ls[i];sp[0]++;}',nl
	a	,←'else if(rr>lr){rk=rr;DOI(i,rr)sp[i]=rs[i];sp[0]++;}',nl
	a	,←'else if(rr){rk=rr;DOI(i,rr)sp[i]=rs[i];sp[0]+=ls[0];}',nl
		a,'else{rk=1;sp[0]=2;}',nl,('rk,sp,',⍕zd)(zt dectmp)'z'}
ctfdfiiaaa←{	a d	←('lv[i]' 'lv[0]' 'rv[i]' 'rv[0]')('rv[:rc],lv[:lc],zv[:zc]')
		(1 'I' 'I' 'I'ctfdpre ⍵),d ⍵ ctfdflpx a}
ctfdfifaaa←{	a d	←('lv[i]' 'lv[0]' 'rv[i]' 'rv[0]')('rv[:rc],lv[:lc],zv[:zc]')
		(2 'D' 'I' 'D'ctfdpre ⍵),d ⍵ ctfdflpx a}
ctfdffiaaa←{	a d	←('lv[i]' 'lv[0]' 'rv[i]' 'rv[0]')('rv[:rc],lv[:lc],zv[:zc]')
		(2 'D' 'D' 'I'ctfdpre ⍵),d ⍵ ctfdflpx a}
ctfdfffaaa←{	a d	←('lv[i]' 'lv[0]' 'rv[i]' 'rv[0]')('rv[:rc],lv[:lc],zv[:zc]')
		(2 'D' 'D' 'D'ctfdpre ⍵),d ⍵ ctfdflpx a}
ctfdfibaaa←{	a d	←('1&(lv[i/8]>>(i%8))' '1&lv[0]' 'rv[i]' 'rv[0]')('rv[:rc],lv[:lz],zv[:zc]')
		(1 'I' 'I' 'U8'ctfdpre ⍵),d ⍵ ctfdflpx a}
ctfdfbiaaa←{	a d	←('lv[i]' 'lv[0]' '1&(rv[i/8]>>(i%8))' '1&rv[0]')('rv[:rz],lv[:lc],zv[:zc]')
		(1 'I' 'U8' 'I'ctfdpre ⍵),d ⍵ ctfdflpx a}
ctfdffbaaa←{	a d	←('1&(lv[i/8]>>(i%8))' '1&lv[0]' 'rv[i]' 'rv[0]')('rv[:rc],lv[:lz],zv[:zc]')
		(2 'D' 'D' 'U8'ctfdpre ⍵),d ⍵ ctfdflpx a}
ctfdfbfaaa←{	a d	←('lv[i]' 'lv[0]' '1&(rv[i/8]>>(i%8))' '1&rv[0]')('rv[:rz],lv[:lc],zv[:zc]')
		(2 'D' 'U8' 'D'ctfdpre ⍵),d ⍵ ctfdflpx a}
ctfdflpx←{	(p(v e y))	←⍺
	l ls r rs	←⍵
	rslt	←(⊃v)var⊃e
	z	←(acdt'present(',p,')'),'{',nl
	z	,←'if(!rr&&!lr){',nl,simd''
	z	,←' DO(i,1){zv[0]=',ls,';zv[1]=',rs,';}',nl
	z	,←'}else if(!rr){B zc_lc=zc-lc;',nl,(ackn''),'{',nl
	z	,←' DO(i,lc){zv[i]=',l,';};DO(i,zc_lc){zv[i+lc]=',rs,';}}',nl
	z	,←'}else if(!lr){B zc_rc=zc-rc;',nl,(ackn''),'{',nl
	z	,←' DO(i,zc_rc){zv[i]=',ls,';};DO(i,rc){zv[i+zc_rc]=',r,';}}',nl
	z	,←'}else{',nl,(ackn''),'{',nl
	z	,←' DO(i,lc){zv[i]=',l,';};DO(i,rc){zv[i+lc]=',r,';}}',nl
		z,'}}',nl,'cpaa(',rslt,',&za);}',nl}
ctfdfbbaaa←{	v e y	←⍵
	z r l	←var/3↑v,⍪e 
	a	←(3 'U8' 'U8' 'U8'ctfdpre ⍵),'B lcd=lc/64;B lcm=lc%64;',nl
	a	,←'B*RSTCT zvB=(B*)zv;B*RSTCT rvB=(B*)rv;B*RSTCT lvB=(B*)lv;',nl
	a	,←'B zBc=(zc+63)/64;B rBc=(rc+63)/64;B lBc=(lc+63)/64;',nl
	a	,←(acdt'present(rvB[:rBc],lvB[:lBc],zvB[:zBc])'),'{',nl
	a	,←'if(!rr&&!lr){',nl,simd''
	a	,←' DO(i,1){zvB[0]=(1&lvB[0])|((1&rvB[0])<<1);}',nl
	a	,←'}else if(!rr){if(lcm){B sr=64-lcm;',nl,simd''
	a	,←'  DO(i,zBc){B v=0;if(1&rvB[0])v=-1;',nl
	a	,←'   if(i<lcd){zvB[i]=lvB[i];}',nl
	a	,←'   else if(i==lcd){zvB[i]=(lvB[i]&(UINT64_MAX>>sr))|(v<<lcm);}',nl
	a	,←'   else{zvB[i]=v;}}',nl
	a	,←' }else{',nl,simd''
	a	,←'  DO(i,zBc){B v=0;if(1&rvB[0])v=-1;',nl
	a	,←'   if(i<lcd){zvB[i]=lvB[i];}else{zvB[i]=v;}}}',nl
	a	,←'}else if(!lr){B lcd=(zc-rc)/64;B lcm=(zc-rc)%64;',nl
	a	,←' if(lcm){B sl=lcm;B sr=64-sl;B rcd=rc/64;B rcm=rc%64;',nl
	a	,←'  if(rcm>sr){',nl,simd''
	a	,←'   DO(i,zBc){B v=0;if(1&lvB[0])v=-1;',nl
	a	,←'    if(i<lcd){zvB[i]=v;}',nl
	a	,←'    else if(i==lcd){zvB[i]=(v&(UINT64_MAX>>sr))|(rvB[0]<<sl);}',nl
	a	,←'    else if(i==zBc-1){zvB[i]=rvB[rBc-1]>>sr;}',nl
	a	,←'    else{zvB[i]=(rvB[i-(lcd+1)]>>sr)|(rvB[i-lcd]<<sl);}}',nl
	a	,←'  }else{',nl,simd''
	a	,←'   DO(i,zBc){B v=0;if(1&lvB[0])v=-1;',nl
	a	,←'    if(i<lcd){zvB[i]=v;}',nl
	a	,←'    else if(i==lcd){zvB[i]=(v&(UINT64_MAX>>sr))|(rvB[0]<<sl);}',nl
	a	,←'    else{zvB[i]=(rvB[i-(lcd+1)]>>sr)|(rvB[i-lcd]<<sl);}}}',nl
	a	,←' }else{',nl,simd''
	a	,←'  DO(i,zBc){B v=0;if(1&lvB[0])v=-1;',nl
	a	,←'   if(i<lcd){zvB[i]=v;}else{zvB[i]=rvB[i-lcd];}}}',nl
	a	,←'}else{',nl
	a	,←' if(lcm){B sl=lcm;B sr=64-sl;B rcd=rc/64;B rcm=rc%64;',nl
	a	,←'  if(rcm>sr){',nl,simd''
	a	,←'   DO(i,zBc){if(i<lcd){zvB[i]=lvB[i];}',nl
	a	,←'    else if(i==lcd){zvB[i]=(lvB[i]&(UINT64_MAX>>sr))|(rvB[0]<<sl);}',nl
	a	,←'    else if(i==zBc-1){zvB[i]=rvB[rBc-1]>>sr;}',nl
	a	,←'    else{zvB[i]=(rvB[i-(lcd+1)]>>sr)|(rvB[i-lcd]<<sl);}}',nl
	a	,←'  }else{',nl,simd''
	a	,←'   DO(i,zBc){if(i<lcd){zvB[i]=lvB[i];}',nl
	a	,←'    else if(i==lcd){zvB[i]=(lvB[i]&(UINT64_MAX>>sr))|(rvB[0]<<sl);}',nl
	a	,←'    else{zvB[i]=(rvB[i-(lcd+1)]>>sr)|(rvB[i-lcd]<<sl);}}}',nl
	a	,←' }else{',nl,simd''
	a	,←'  DO(i,zBc){if(i<lcd)zvB[i]=lvB[i];else zvB[i]=rvB[i-lcd];}}',nl
		a,'}}',nl,'cpaa(',z,',&za);}',nl}
fctd	←{('df'gcl fdb)((0⌷⍉⍵),⊂,'⍪')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:≢	Tally/Not Equiv
nqvmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=1;',nl}
nqvmfbnsss	←nqvmffnsss←nqvmfinsss
nqvmfinaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'{I c=1;'
	z	,←'if((',rgt,')->r)c=(',rgt,')->s[0];',nl
	z	,←'ai(',rslt,',0,NULL,1);I*v=(',rslt,')->v;',nl
		z,(simd'present(v[:1])'),'DO(i,1)v[0]=c;}',nl}
nqvd←{	chk siz	←'' 'zr=0;'
	exe	←pacc'update host(lv[:lft->c],rv[:rgt->c])'
	exe	,←'zv[0]=0;if(rr!=lr)zv[0]=1;',nl
	exe	,←'DO(i,lr){if(zv[0])break;if(rs[i]!=ls[i]){zv[0]=1;break;}}',nl
	exe	,←'DO(i,lr)lc*=ls[i];',nl
	exe	,←'DO(i,lc){if(zv[0])break;if(lv[i]!=rv[i]){zv[0]=1;break;}}',nl
	exe	,←pacc'update device(zv[:rslt->c])'
		chk siz exe mxfn 1 ⍺ ⍵}
decd←{	chk	←'if(lr>1||lv[0]<0)dwaerr(16);'
	siz	←'zr=rr==0?0:rr-1;DOI(i,zr){zs[i]=rs[i+1];zc*=rs[i+1];}',nl
	siz	,←'if(rr>0)rc=rs[0];'
	exen	←pacc'update host(lv,rv[:rgt->c])'
	exen	,←'DO(i,zc){zv[i]=0;DO(j,rc){zv[i]=rv[(j*zc)+i]+lv[0]*zv[i];}}',nl
	exen	,←pacc'update device(zv[:rslt->c])'
	exeb	←'I rcp=(rgt->c+7)/8;',nl
	exeb	,←pacc'update host(lv,rv[:rcp])'
	exeb	,←'DO(i,zc){zv[i]=0;DO(j,rc){I ri=(j*zc)+i;',nl
	exeb	,←'zv[i]=(1&(rv[ri/8]>>(ri%8)))+lv[0]*zv[i];}}',nl
	exeb	,←pacc'update device(zv[:rslt->c])'
	exe	←(3=⊃1⌷⍺)⊃exen exeb
		chk siz exe mxfn 1 ⍺ ⍵}
nqvmfbnaaa←nqvmffnaaa←nqvmfinaaa
⍝[cf]
⍝[of]:⍉	Transpose
trnmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
trnmfbnsss	←trnmffnsss←trnmfinsss
trnmfinaaa	←{'I1'trnmfn ⍵}
trnmffnaaa	←{'D2'trnmfn ⍵}
trnmfh←{	z	←'{I rk=(',⍵,')->r;B sp[15];DO(i,rk)sp[i]=(',⍵,')->s[rk-(1+i)];',nl
	z	,←'if(rk<=1){',nl
	z	,←(≡/2↑⍺⍺)⊃('memcpy(',⍺,',',⍵,',sizeof(A));(',⍵,')->f=0;',nl)''
		z,'}else if(rk==2){',nl}
trnmfn←{	v e y	←⍵
	tp tc	←⍺
	rslt rgt	←var/2↑v,⍪e
	z	←rslt(e trnmfh)rgt
	a	←'A ta;ta.v=NULL;ai(&ta,rk,sp,',tc,');',tp,'*RSTCT zv=ta.v;',nl
	z	,←a⊣a,←tp,'*RSTCT rv=(',rgt,')->v;B cnt=(',rgt,')->c;',nl
	z	,←simd'independent present(zv[:cnt],rv[:cnt])'
	z	,←'DO(i,sp[0]){DO(j,sp[1]){zv[(i*sp[1])+j]=rv[(j*sp[0])+i];}}',nl
	z	,←'cpaa(',rslt,',&ta);',nl
	z	,←'}else{',nl
	z	,←a,'B*rs=(',rgt,')->s;',nl
	z	,←simd'independent present(zv[:cnt],rv[:cnt]) copyin(rs[:rk])'
	z	,←'DO(i,cnt){B ri=0,zi=i;',nl
	z	,←' DO(j,rk){B k=zi%rs[j];ri*=rs[j];ri+=k;zi-=k;zi/=rs[j];}',nl
	z	,←' zv[i]=rv[ri];}',nl
	z	,←'cpaa(',rslt,',&ta);',nl
		z,'}}',nl}
trnmfbnaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←rslt(e trnmfh)rgt
	a	←' A ta;ta.v=NULL;ai(&ta,rk,sp,3);U8*RSTCT zv=ta.v;',nl
	z	,←a⊣a,←' U8*RSTCT rv=(',rgt,')->v;B cnt=((',rgt,')->c+7)/8;',nl
	z	,←simd'independent present(zv[:cnt],rv[:cnt])'
	z	,←' DO(i,cnt){zv[i]=0;',nl
	z	,←'  DOI(j,8){B zi=i*8+j;B zr=zi/sp[1],zc=zi%sp[1];',nl
	z	,←'   B ri=zc*sp[0]+zr;zv[i]|=(1&(rv[ri/8]>>(ri%8)))<<j;}}',nl
	z	,←' cpaa(',rslt,',&ta);',nl
	z	,←'}else{B*rs=(',rgt,')->s;',nl,a
	z	,←simd'independent present(zv[:cnt],rv[:cnt]) copyin(rs[:rk])'
	z	,←' DO(i,cnt){zv[i]=0;DO(j,8){B i8=i*8+j;B ri=0,zi=i8;',nl
	z	,←'   DO(j,rk){B k=zi%rs[j];ri*=rs[j];ri+=k;zi-=k;zi/=rs[j];}',nl
	z	,←'   zv[i]|=(1&(rv[ri/8]>>(ri%8)))<<j;}}',nl
	z	,←' cpaa(',rslt,',&ta);',nl
		z,'}}',nl}
⍝[cf]
⍝[of]:⊣	Same/Monadic Left
lftmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
lftmfbnsss	←lftmffnsss←lftmfinsss
lftmfinaaa←{	v e y	←⍵
	≡/2↑e:	''
	rslt rgt	←var/2↑v,⍪e
		'memcpy(',rslt,',',rgt,',sizeof(A));(',rgt,')->f=0;',nl}
lftd←{	chk siz	←''('zr=lr;DO(i,lr)zs[i]=ls[i];')
	exe	←'DOI(i,zr)zc*=zs[i];',nl
	exe	,←(simd'present(zv[:zc],lv[:zc])'),'DO(i,zc)zv[i]=lv[i];'
		chk siz exe mxfn 1 ⍺ ⍵}
lftmfbnaaa←lftmffnaaa←lftmfinaaa
⍝[cf]
⍝[of]:↓	Split/Drop
drpmfinsss	←{((z r l f) e y)←⍵ ⋄ z,'=',r,';',nl}
drpmfbnsss	←drpmffnsss←drpmfinsss
drpdfbbaaa←{	h	←'{',('r'decarrb rgt ⍵),'l'decarrb lft ⍵
		h,(3 'U8'((drpdfblp'(1&*lv)')drpdflp2)⍵),'}',nl}
drpdfbiaaa←{	h	←'{',('r'decarrb rgt ⍵),'l'decarri lft ⍵
		h,(3 'U8'(''drpdflp(drpdfblp'*lv'))⍵),'}',nl}
drpdfbfaaa←{	h	←'{',('r'decarrb rgt ⍵),'l'decarrf lft ⍵
		h,(3 'U8'((drpdffchk⍬)drpdflp(drpdfblp'*lv'))⍵),'}',nl}
drpdfibaaa←{	h	←'{',('r'decarri rgt ⍵),'l'decarrb lft ⍵
		h,(1 'I'((drpdfnlp'(1&*lv)')drpdflp2)⍵),'}',nl}
drpdffbaaa←{	h	←'{',('r'decarrf rgt ⍵),'l'decarrb lft ⍵
		h,(2 'D'((drpdfnlp'(1&*lv)')drpdflp2)⍵),'}',nl}
drpdfifaaa←{	h	←'{',('r'decarri rgt ⍵),'l'decarrf lft ⍵
		h,(1 'I'((drpdffchk⍬)drpdflp(drpdfnlp'*lv'))⍵),'}',nl}
drpdfffaaa←{	h	←'{',('r'decarrf rgt ⍵),'l'decarrf lft ⍵
		h,(2 'D'((drpdffchk⍬)drpdflp(drpdfnlp'*lv'))⍵),'}',nl}
drpdfiiaaa←{	h	←'{',('r'decarri rgt ⍵),'l'decarri lft ⍵
		h,(1 'I'(''drpdflp(drpdfnlp'*lv'))⍵),'}',nl}
drpdffiaaa←{	h	←'{',('r'decarrf rgt ⍵),'l'decarri lft ⍵
		h,(2 'D'(''drpdflp(drpdfnlp'*lv'))⍵),'}',nl}
drpdfbbaal←{	h	←'{',('r'decarrb rgt ⍵),'l'declitb lft ⍵
		h,(3 'U8'((drpdfblp'(1&*lv)')drpdflp2)⍵),('z'freelit'l'),'}',nl}
drpdfbiaal←{	h	←'{',('r'decarrb rgt ⍵),'l'decliti lft ⍵
		h,(3 'U8'(''drpdflp(drpdfblp'*lv'))⍵),('c'freelit'l'),'}',nl}
drpdfbfaal←{	h	←'{',('r'decarrb rgt ⍵),'l'declitf lft ⍵
		h,(3 'U8'((drpdffchk⍬)drpdflp(drpdfblp'*lv'))⍵),('c'freelit'l'),'}',nl}
drpdfibaal←{	h	←'{',('r'decarri rgt ⍵),'l'declitb lft ⍵
		h,(1 'I'((drpdfnlp'(1&*lv)')drpdflp2)⍵),('z'freelit'l'),'}',nl}
drpdffbaal←{	h	←'{',('r'decarrf rgt ⍵),'l'declitb lft ⍵
		h,(2 'D'((drpdfnlp'(1&*lv)')drpdflp2)⍵),('z'freelit'l'),'}',nl}
drpdfifaal←{	h	←'{',('r'decarri rgt ⍵),'l'declitf lft ⍵
		h,(1 'I'((drpdffchk⍬)drpdflp(drpdfnlp'*lv'))⍵),('c'freelit'l'),'}',nl}
drpdfffaal←{	h	←'{',('r'decarrf rgt ⍵),'l'declitf lft ⍵
		h,(2 'D'((drpdffchk⍬)drpdflp(drpdfnlp'*lv'))⍵),('c'freelit'l'),'}',nl}
drpdfiiaal←{	h	←'{',('r'decarri rgt ⍵),'l'decliti lft ⍵
		h,(1 'I'(''drpdflp(drpdfnlp'*lv'))⍵),('c'freelit'l'),'}',nl}
drpdffiaal←{	h	←'{',('r'decarrf rgt ⍵),'l'decliti lft ⍵
		h,(2 'D'(''drpdflp(drpdfnlp'*lv'))⍵),('c'freelit'l'),'}',nl}
drpdfbbala←{	h	←'{',('r'declitb rgt ⍵),'l'decarrb lft ⍵
		h,(3 'U8'((drpdfblp'(1&*lv)')drpdflp2)⍵),('z'freelit'r'),'}',nl}
drpdfbiala←{	h	←'{',('r'declitb rgt ⍵),'l'decarri lft ⍵
		h,(3 'U8'(''drpdflp(drpdfblp'*lv'))⍵),('z'freelit'r'),'}',nl}
drpdfbfala←{	h	←'{',('r'declitb rgt ⍵),'l'decarrf lft ⍵
		h,(3 'U8'((drpdffchk⍬)drpdflp(drpdfblp'*lv'))⍵),('z'freelit'r'),'}',nl}
drpdfibala←{	h	←'{',('r'decliti rgt ⍵),'l'decarrb lft ⍵
		h,(1 'I'((drpdfnlp'(1&*lv)')drpdflp2)⍵),('c'freelit'r'),'}',nl}
drpdffbala←{	h	←'{',('r'declitf rgt ⍵),'l'decarrb lft ⍵
		h,(2 'D'((drpdfnlp'(1&*lv)')drpdflp2)⍵),('c'freelit'r'),'}',nl}
drpdfifala←{	h	←'{',('r'decliti rgt ⍵),'l'decarrf lft ⍵
		h,(1 'I'((drpdffchk⍬)drpdflp(drpdfnlp'*lv'))⍵),('c'freelit'r'),'}',nl}
drpdfffala←{	h	←'{',('r'declitf rgt ⍵),'l'decarrf lft ⍵
		h,(2 'D'((drpdffchk⍬)drpdflp(drpdfnlp'*lv'))⍵),('c'freelit'r'),'}',nl}
drpdfiiala←{	h	←'{',('r'decliti rgt ⍵),'l'decarri lft ⍵
		h,(1 'I'(''drpdflp(drpdfnlp'*lv'))⍵),('c'freelit'r'),'}',nl}
drpdffiala←{	h	←'{',('r'declitf rgt ⍵),'l'decarri lft ⍵
		h,(2 'D'(''drpdflp(drpdfnlp'*lv'))⍵),('c'freelit'r'),'}',nl}
drpdffchk←{	a	←'I tst=0;',nl,simd'present(lv[:lc]) reduction(max:tst)'
	a	,←'DO(i,lc){if(lv[i]!=floor(lv[i]))tst=1;}',nl
		a,'if(tst)dwaerr(11);',nl}
drpdfnlp←{	a	←'if(',⍵,'>0){B s=',⍵,';DOI(i,zr-1)s*=zs[i+1];rv+=s;}',nl
		a,(simd'present(zv[:zc],rv[:zc])'),'DO(i,zc)zv[i]=rv[i];',nl}
drpdfblp←{	a	←'B*RSTCT zv64=(B*)zv;B zc64=(zc+63)/64;',nl
	a	,←'B*RSTCT rv64=(B*)rv;B rc64=(rc+63)/64;',nl
	a	,←'if(',⍵,'>0){B s=',⍵,';DOI(i,zr-1)s*=zs[i+1];',nl
	a	,←' I sr=s%64;I sl=64-sr;rv64+=s/64;rc64-=s/64;',nl
	a	,←(acdt'present(zv64[:zc64],rv64[:rc64])'),'{',nl
	a	,←' if(sr){if(sr>rc%64){',nl,simd''
	a	,←'   DO(i,zc64){zv64[i]=(rv64[i]>>sr)|(rv64[i+1]<<sl);}',nl
	a	,←'  }else{',nl,simd''
	a	,←'   DO(i,zc64){if(i==zc64-1){zv64[i]=rv64[i]>>sr;',nl
	a	,←'    }else{zv64[i]=(rv64[i]>>sr)|(rv64[i+1]<<sl);}}}',nl
	a	,←' }else{',nl,(simd''),'DO(i,zc64){zv64[i]=rv64[i];}}',nl
	a	,←'}}else{',nl,simd'present(zv64[:zc64],rv64[:rc64])'
		a,' DO(i,zc64){zv64[i]=rv64[i];}}',nl}
drpdflp←{	a	←'I rk;B sp[15];',nl,'if(lr&&(lr!=1||ls[0]!=1))dwaerr(16);',nl,⍺⍺
	a	,←'rk=rr;DOI(i,rk)sp[i]=rs[i];',nl,acup'host(lv[:lc])'
	a	,←'if(abs(*lv)>*sp)*sp=0;else if(*sp)*sp-=abs(*lv);',nl
	a	,←(('rk,sp,',⍕⊃⍺)((1⊃⍺)dectmp)'z'),'if(zc){',nl,⍵⍵
		a,'}',nl,'cpaa(',(rslt ⍵),',&za);',nl}
drpdflp2←{	a	←'I rk;B sp[15];',nl,'if(lr&&(lr!=1||ls[0]!=1))dwaerr(16);',nl
	a	,←'rk=rr;DOI(i,rk)sp[i]=rs[i];',nl,acup'host(lv[:lz])'
	a	,←'if((1&*lv)>*sp)*sp=0;else if(*sp)*sp-=(1&*lv);',nl
	a	,←(('rk,sp,',⍕⊃⍺)((1⊃⍺)dectmp)'z'),'if(zc){',nl,⍺⍺
		a,'}',nl,'cpaa(',(rslt ⍵),',&za);',nl}
drpd←{('df'gcl fdb)((0⌷⍉⍵),⊂,'↓')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:?	Roll/Deal
rolmfinaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'{B c=(',rgt,')->c;',nl
	z	,←'I*RSTCT rv=(',rgt,')->v;',nl,acup'host(rv[:c])'
	z	,←'DO(i,c){if(rv[i]<0)dwaerr(11);}',nl
	z	,←'A t;t.v=NULL;',nl
	z	,←'ai(&t,(',rgt,')->r,(',rgt,')->s,2);D*RSTCT zv=t.v;',nl
	z	,←'DO(i,c){if(rv[i])zv[i]=arc4random_uniform(rv[i]);',nl
	z	,←'  else zv[i]=(D)arc4random_uniform(UINT_MAX)/UINT_MAX;}',nl
		z,(acup'device(zv[:c])'),'cpaa(',rslt,',&t);}',nl}
rolmfbnaaa←{	v e y	←⍵
	rslt rgt	←var/2↑v,⍪e
	z	←'{B c=((',rgt,')->c+7)/8;',nl
	z	,←'U8*RSTCT rv=(',rgt,')->v;',nl,acup'host(rv[:c])'
	z	,←'A t;t.v=NULL;',nl
	z	,←'ai(&t,(',rgt,')->r,(',rgt,')->s,2);D*RSTCT zv=t.v;',nl
	z	,←'DO(i,c){DO(j,8){B x=i*8+j;U8 t=1&(rv[i]>>j);',nl
	z	,←' if(t)zv[x]=0;',nl
	z	,←' else zv[x]=(D)arc4random_uniform(UINT_MAX)/UINT_MAX;}}',nl
		z,'B zc=t.c;',nl,(acup'device(zv[:zc])'),'cpaa(',rslt,',&t);}',nl}
roldfiiaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarri lft ⍵),roldfnnlp ⍵}
roldfifaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrf lft ⍵),roldfnnlp ⍵}
roldfibaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrb lft ⍵),roldfnblp ⍵}
roldffiaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵),roldfnnlp ⍵}
roldfffaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrf lft ⍵),roldfnnlp ⍵}
roldffbaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrb lft ⍵),roldfnblp ⍵}
roldfbbaaa←{	z	←'{',('r'decarrb rgt ⍵),('l'decarrb lft ⍵),roldfbblp ⍵}
roldfbiaaa←{	z	←'{',('r'decarrb rgt ⍵),('l'decarri lft ⍵),roldfbnlp ⍵}
roldfbfaaa←{	z	←'{',('r'decarrb rgt ⍵),('l'decarrf lft ⍵),roldfbnlp ⍵}
roldfiiaal←{	z	←'{',('r'decarri rgt ⍵),('l'decliti lft ⍵),roldfnnlp ⍵}
roldfifaal←{	z	←'{',('r'decarri rgt ⍵),('l'declitf lft ⍵),roldfnnlp ⍵}
roldfibaal←{	z	←'{',('r'decarri rgt ⍵),('l'declitb lft ⍵),roldfnblp ⍵}
roldffiaal←{	z	←'{',('r'decarrf rgt ⍵),('l'decliti lft ⍵),roldfnnlp ⍵}
roldfffaal←{	z	←'{',('r'decarrf rgt ⍵),('l'declitf lft ⍵),roldfnnlp ⍵}
roldffbaal←{	z	←'{',('r'decarrf rgt ⍵),('l'declitb lft ⍵),roldfnblp ⍵}
roldfbbaal←{	z	←'{',('r'decarrb rgt ⍵),('l'declitb lft ⍵),roldfbblp ⍵}
roldfbiaal←{	z	←'{',('r'decarrb rgt ⍵),('l'decliti lft ⍵),roldfbnlp ⍵}
roldfbfaal←{	z	←'{',('r'decarrb rgt ⍵),('l'declitf lft ⍵),roldfbnlp ⍵}
roldfiiala←{	z	←'{',('r'decliti rgt ⍵),('l'decarri lft ⍵),roldfnnlp ⍵}
roldfifala←{	z	←'{',('r'decliti rgt ⍵),('l'decarrf lft ⍵),roldfnnlp ⍵}
roldfibala←{	z	←'{',('r'decliti rgt ⍵),('l'decarrb lft ⍵),roldfnblp ⍵}
roldffiala←{	z	←'{',('r'declitf rgt ⍵),('l'decarri lft ⍵),roldfnnlp ⍵}
roldfffala←{	z	←'{',('r'declitf rgt ⍵),('l'decarrf lft ⍵),roldfnnlp ⍵}
roldffbala←{	z	←'{',('r'declitf rgt ⍵),('l'decarrb lft ⍵),roldfnblp ⍵}
roldfbbala←{	z	←'{',('r'declitb rgt ⍵),('l'decarrb lft ⍵),roldfbblp ⍵}
roldfbiala←{	z	←'{',('r'declitb rgt ⍵),('l'decarri lft ⍵),roldfbnlp ⍵}
roldfbfala←{	z	←'{',('r'declitb rgt ⍵),('l'decarrf lft ⍵),roldfbnlp ⍵}
roldfnnlp←{	z	←'if(rc!=1||lc!=1)dwaerr(5);',nl,acup'host(rv[:rc],lv[:lc])'
	z	,←'if(*lv>*rv||*lv!=floor(*lv)||*rv!=floor(*rv)||*lv<0||*rv<0)dwaerr(11);',nl
	z	,←'B s=*lv;B t=*rv;','1,&s,1'dectmpi'z'
	z	,←'if(s){I*d=malloc(t*sizeof(I));if(!d)dwaerr(1);',nl
	z	,←'DO(i,t){B j=arc4random_uniform(i+1);if(i!=j)d[i]=d[j];d[j]=i;}',nl
	z	,←'DO(i,s){zv[i]=d[i];};free(d);}',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
roldfbnlp←{	z	←'if(rc!=1||lc!=1)dwaerr(5);',nl,acup'host(rv[:rc],lv[:lc])'
	z	,←'B s=*lv;s=1&s;if(s>*rv||*rv!=floor(*rv)||*rv<0)dwaerr(11);',nl
	z	,←'B t=*rv;','1,&s,1'dectmpi'z'
	z	,←'if(s){zv[0]=arc4random_uniform(t);}',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
roldfnblp←{	z	←'if(rc!=1||lc!=1)dwaerr(5);',nl,acup'host(rv[:rc],lv[:lc])'
	z	,←'B t=*rv;t=1&t;if(*lv>t||*lv!=floor(*lv)||*lv<0)dwaerr(11);',nl
	z	,←'B s=*lv;','1,&s,1'dectmpi'z'
	z	,←'if(s){zv[0]=0;}',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
roldfbblp←{	z	←'if(rc!=1||lc!=1)dwaerr(5);',nl,acup'host(rv[:rc],lv[:lc])'
	z	,←'B s=1&*lv;B t=1&*rv;if(s>t)dwaerr(11);',nl
	z	,←'1,&s,1'dectmpi'z'
	z	,←'if(s){zv[0]=0;}',nl,acup'device(zv[:zc])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
rold←{		('df'gcl fdb)((0⌷⍉⍵),⊂,'?')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[of]:∪	Unique/Union
unqmfinaaa←{	z	←'{',('r'decarri rgt ⍵),'if(rr>1)dwaerr(4);',nl
		z,('1,&uc,1'dectmpi'z')('gucmpi'unqmfnlp)⍵}
unqmffnaaa←{	z	←'{',('r'decarrf rgt ⍵),'if(rr>1)dwaerr(4);',nl
		z,('1,&uc,2'dectmpf'z')('gucmpf'unqmfnlp)⍵}
unqmfbnaaa←{	z	←'{',('r'decarrb rgt ⍵),'if(rr>1)dwaerr(4);',nl
	z	,←'B rc8=(rc+7)/8;B uc=2;','1,&uc,3'dectmpb'z'
	z	,←acup'host(rv[:rz])'
	z	,←'if(!rc){zs[0]=0;}',nl
	z	,←'else if(rc==1){zv[0]=rv[0];zs[0]=1;}',nl
	z	,←'else{',nl
	z	,←'DO(i,rc8){U8 m=(i==rc8-1&&rc%8)?~(255<<(rc%8)):255;U8 v=m&rv[i];',nl
	z	,←' if((i==rc8-1)&&!v){zv[0]=0;zs[0]=1;break;}',nl
	z	,←' if((i==rc8-1)&&(v==m)){zv[0]=1;zs[0]=1;break;}',nl
	z	,←' if((rv[i]%2)&&(v<m)){zv[0]=1;zs[0]=2;break;}',nl
	z	,←' if((!(rv[i]%2))&&v){zv[0]=2;zs[0]=2;break;}}',nl
	z	,←'}',nl,acup'device(zv[:1])'
		z,'cpaa(',(rslt ⍵),',&za);}',nl}
unqmfnlp←{	z	←'if(rc){I*v=malloc(rc*sizeof(I));if(!v)dwaerr(1);',nl
	z	,←'U8*f=malloc(rc*sizeof(U8));if(!f)dwaerr(1);',nl
	z	,←(acup'host(rv[:rc])'),'B uc=1;grdv=rv;grdc=1;',nl
	z	,←'DO(i,rc){v[i]=i;f[i]=0;};qsort(v,rc,sizeof(I),',⍺⍺,');',nl
	z	,←'f[v[0]]=1;DO(i,rc-1){if(rv[v[i]]!=rv[v[i+1]]){f[v[i+1]]=1;uc++;}}',nl
	z	,←⍺,'uc=0;DO(i,rc){if(f[i])zv[uc++]=rv[i];}',nl
	z	,←(acup'device(zv[:zc])'),'free(v);free(f);',nl
	z	,←'cpaa(',(rslt ⍵),',&za);',nl
		z,'}else{',('1,&rc,1'dectmpi'z'),'cpaa(',(rslt ⍵),',&za);}}',nl}
unqdfiiaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarri lft ⍵)
		z,('1,&uc,1'dectmpi'z')('gucmpi'unqdfnnlp'gucmpi')⍵}
unqdfifaaa←{	z	←'{',('r'decarri rgt ⍵),('l'decarrf lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpf'unqdfnnlp'gucmpi')⍵}
unqdffiaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarri lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpi'unqdfnnlp'gucmpf')⍵}
unqdfffaaa←{	z	←'{',('r'decarrf rgt ⍵),('l'decarrf lft ⍵)
		z,('1,&uc,2'dectmpf'z')('gucmpf'unqdfnnlp'gucmpf')⍵}
unqdfibaaa←{		'dwaerr(16);',nl}
unqdffbaaa←{		'dwaerr(16);',nl}
unqdfbbaaa←{		'dwaerr(16);',nl}
unqdfbiaaa←{		'dwaerr(16);',nl}
unqdfbfaaa←{		'dwaerr(16);',nl}
unqdfiiaal←{		'dwaerr(16);',nl}
unqdfifaal←{		'dwaerr(16);',nl}
unqdffiaal←{		'dwaerr(16);',nl}
unqdfffaal←{		'dwaerr(16);',nl}
unqdfibaal←{		'dwaerr(16);',nl}
unqdffbaal←{		'dwaerr(16);',nl}
unqdfbbaal←{		'dwaerr(16);',nl}
unqdfbiaal←{		'dwaerr(16);',nl}
unqdfbfaal←{		'dwaerr(16);',nl}
unqdfiiala←{		'dwaerr(16);',nl}
unqdfifala←{		'dwaerr(16);',nl}
unqdffiala←{		'dwaerr(16);',nl}
unqdfffala←{		'dwaerr(16);',nl}
unqdfibala←{		'dwaerr(16);',nl}
unqdffbala←{		'dwaerr(16);',nl}
unqdfbbala←{		'dwaerr(16);',nl}
unqdfbiala←{		'dwaerr(16);',nl}
unqdfbfala←{		'dwaerr(16);',nl}
unqdfnnlp←{	z	←'if(rr>1||lr>1)dwaerr(4);B uc=lc;B lx=0;B rx=0;',nl
	z	,←'I*li=malloc(lc*sizeof(I));if(!li)dwaerr(1);',nl
	z	,←'I*ri=malloc(rc*sizeof(I));if(!ri)dwaerr(1);',nl
	z	,←'U8*f=malloc(rc*sizeof(U8));if(!f)dwaerr(1);',nl
	z	,←'DO(i,rc){ri[i]=i;f[i]=0;};DO(i,lc){li[i]=i;};',nl
	z	,←acup'host(rv[:rc],lv[:lc])'
	z	,←'grdv=lv;grdc=1;qsort(li,lc,sizeof(I),',⍺⍺,');',nl
	z	,←'grdv=rv;grdc=1;qsort(ri,rc,sizeof(I),',⍵⍵,');',nl
	z	,←'while(rx<rc){if(lx>=lc){uc++;f[ri[rx++]]=1;}',nl
	z	,←' else if(lv[li[lx]]<rv[ri[rx]])lx++;',nl
	z	,←' else if(lv[li[lx]]==rv[ri[rx]])rx++;',nl
	z	,←' else{uc++;f[ri[rx++]]=1;}}',nl
	z	,←⍺,'DO(i,lc){zv[i]=lv[i];}',nl
	z	,←'uc=lc;DO(i,rc){if(f[i])zv[uc++]=rv[i];}',nl,acup'device(zv[:zc])'
		z,'free(li);free(ri);free(f);cpaa(',(rslt ⍵),',&za);}',nl}
unqd←{		('df'gcl fdb)((0⌷⍉⍵),⊂,'∪')((1⌷⍉⍵),⊂¯1 0)(⍺,0)}
⍝[cf]
⍝[cf]
⍝[cf]
⍝[of]:Horrible Hacks
⍝[c]Sobel Pi Hack
sopid←{	siz	←'zr=(lr-1)+rr;zs[0]=ls[0];DO(i,zr-1)zs[i+1]=rs[i];'
	exe	←'zc=zs[0];rc=rs[0];lc=ls[rr-1];',nl
	exe	,←'B szz=rslt->c,szr=rgt->c,szl=lft->c;',nl
	exe	,←simd'independent collapse(3) present(zv[:szz],rv[:szr],lv[:szl])'
	exe	,←'DO(i,zc){DO(j,rc){DO(k,lc){I li=(i*lc)+k;',nl
	exe	,←'zv[(i*rc*lc)+(j*lc)+k]=lv[li]*rv[(j*lc)+k];',nl
	exe	,←'}}}'
		'' siz exe mxfn 1 ⍺ ⍵}

⍝[c]Lamination (Hack)
catdo←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ catdr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ catdl ⍵ ⋄ ⍺ catdv ⍵}

catdv←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'A*',⍺,'=',⍵,';'}¨var/⍵),nl
	 z,←'B s[]={rgt->s[0],2};'
	 z,←'A*orz;A tp;tp.v=NULL;int tpused=0;',nl
	 z,←'if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
	 z,←'ai(rslt,2,s,',(⍕⊃0⌷⍺),');',nl
	 z,←(⊃,/(git ⍺){⍺,'*RSTCT ',⍵,';'}¨'zrl'),nl
	 z,←⊃,/'zrl'{⍺,'=',⍵,'->v;',nl}¨'rslt' 'rgt' 'lft'
	 z,←(simd'present(z,l,r)'),'DO(i,s[0]){z[i*2]=l[i];z[i*2+1]=r[i];}'
	 z,←'if(tpused){cpaa(orz,rslt);}',nl
	 z,'}',nl}
⍝[cf]
⍝[cf]

:EndNamespace
