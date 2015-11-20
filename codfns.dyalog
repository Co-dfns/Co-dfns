⍝[c]The Co-dfns Compiler: High-performance, Parallel APL Compiler
⍝[c]Copyright (c) 2015 Aaron W. Hsu <arcfide@sacrideo.us>
⍝[c]See LICENSE.txt and COPYING.txt for copyright information.
⍝[c]
⍝[c]This file is best viewed using code-browser and the associated language 
⍝[c]file. It is designed with explicitly marked code folding in mind. It makes 
⍝[c]use of elastic tabstops.
⍝[c]
:Namespace codfns
⍝[of]:Global Configuration
⎕IO ⎕ML ⎕WX←0 1 3
VERSION	←0 4 42 ⋄ COMPILER←'vsc'
DWA∆PATH	←'dwa'
BUILD∆PATH	←'Build'
TEST∆COMPILERS	←⊂'vsc'
VISUAL∆STUDIO∆PATH	←'C:\Program Files (x86)\Microsoft Visual Studio 14.0\'
INTEL∆C∆PATH	←'C:\Program Files (x86)\IntelSWTools\'
INTEL∆C∆PATH	,←'compilers_and_libraries_2016.0.110\windows\bin\'
PGI∆PATH	←'C:\Program Files\PGI\win64\15.7\'
⍝[cf]
⍝[of]:Backend Compilers
⍝[of]:UNIX Generic Flags/Options
cfs	←'-funsigned-bitfields -funsigned-char -fvisibility=hidden -std=c11 '
cds	←'-DxxBIT=64 -DHAS_UNICODE=1 -DUNIX=1 -DWANT_REFCOUNTS=1 -D_DEBUG=1 '
cio	←{'-I',DWA∆PATH,' -o ''',BUILD∆PATH,'/',⍵,'_',⍺,'.so'' '}
fls	←{'''',DWA∆PATH,'/dwa_fns.c'' ''',BUILD∆PATH,'/',⍵,'_',⍺,'.c'' '}
log	←{'> ',BUILD∆PATH,'/',⍵,'_',⍺,'.log 2>&1'}
⍝[cf]
⍝[of]:GCC (Linux Only)
gop	←'-Ofast -Wall -Wno-unused-function -Wno-unused-variable -fPIC -shared '
gcc	←{⎕SH'gcc ',cfs,cds,gop,'gcc'(cio,fls,log)⍵}
⍝[cf]
⍝[of]:Intel C Linux
iop	←'-fast -fno-alias -static-intel -Wall -Wno-unused-function -fPIC -shared '
icc	←{⎕SH'icc ',cfs,cds,iop,'icc'(cio,fls,log)⍵}
⍝[cf]
⍝[of]:PGI C Linux
pop	←' -fast -acc -ta=tesla:cuda7.5 -Minfo -Minfo=ccff -fPIC -shared '
pgcc	←{⎕SH'pgcc ',cds,pop,'pgcc'(cio,fls,log)⍵}
⍝[cf]
⍝[of]:VS/IC Windows Flags
vsco	←'/W3 /Gm- /Zc:inline ' ⍝ /Zi /Fd"Build\vc140.pdb" '
vsco	,←'/D "HAS_UNICODE=1" /D "xxBIT=64" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" '
vsco	,←'/D "_USRDLL" /D "DWA_EXPORTS" /D "_WINDLL" '
vsco	,←'/errorReport:prompt /WX- /MD /EHsc /nologo '
vslo	←'/link /DLL /OPT:REF /INCREMENTAL:NO /SUBSYSTEM:WINDOWS '
vslo	,←'/OPT:ICF /ERRORREPORT:PROMPT /TLBID:1 '
⍝[cf]
⍝[of]:Visual Studio C
vsc1	←{'""',VISUAL∆STUDIO∆PATH,'VC\vcvarsall.bat" amd64 && cl ',vsco,'/fast '}
vsc2	←{'/I"',DWA∆PATH,'\\" /Fo"',BUILD∆PATH,'\\" "',DWA∆PATH,'\dwa_fns.c" '}
vsc3	←{'"',BUILD∆PATH,'\',⍵,'_vsc.c" ',vslo,'/OUT:"',BUILD∆PATH,'\',⍵,'_vsc.dll" '}
vsc4	←{'> "',BUILD∆PATH,'\',⍵,'_vsc.log""'}
vsc	←⎕CMD '%comspec% /C ',vsc1,vsc2,vsc3,vsc4
⍝[cf]
⍝[of]:Intel C Windows
icl1	←{'""',INTEL∆C∆PATH,'\ipsxe-comp-vars.bat" intel64 vs2015 && icl ',vsco,'/Ofast '}
icl3	←{'"',BUILD∆PATH,'\',⍵,'_icl.c" ',vslo,'/OUT:"',BUILD∆PATH,'\',⍵,'_icl.dll" '}
icl4	←{'> "',BUILD∆PATH,'\',⍵,'_icl.log""'}
icl	←⎕CMD '%comspec% /E:ON /V:ON /C ',icl1,vsc2,icl3,icl4
⍝[cf]
⍝[of]:PGI C Windows
pgio	←'-D "HAS_UNICODE=1" -D "xxBIT=64" -D "WIN32" -D "NDEBUG" -D "_WINDOWS" '
pgio	,←'-D "_USRDLL" -D "DWA_EXPORTS" -D "_WINDLL" -D "HASACC" '
pgwc	←{z←'pgcc -fast -Bdynamic -acc -Minfo ',pgio,'-I "',DWA∆PATH,'\\" '
 	z,←'-c "',⍵,'.c" -o "',⍵,'.obj"' ⋄ z}
pglk	←{z←'pgcc -fast -Mmakedll -acc -Minfo -o "',BUILD∆PATH,'\',⍵,'_pgi.dll" "'
	z,←BUILD∆PATH,'\',⍵,'_pgi.obj" "',DWA∆PATH,'\dwa_fns.obj"' ⋄ z}
pgi1	←{'""',PGI∆PATH,'pgi_env.bat" && ',(pgcc BUILD∆PATH,'\',⍵,'_pgi'),' && '}
pgi2	←{(pgwc DWA∆PATH,'\dwa_fns'),' && ',pglk ⍵}
pgi3	←{' > "',BUILD∆PATH,'\',⍵,'_pgi.log""'}
pgi	←⎕CMD '%comspec% /C ',pgi1,pgi2,pgi3
⍝[cf]
⍝[cf]
⍝[of]:Primary Interface/API
dirc	←{'\/'⊃⍨'gcc' 'icc' 'pgcc'∊⍨⊂COMPILER}
soext	←{'.dll' '.so'⊃⍨'gcc' 'icc' 'pgcc'∊⍨⊂COMPILER}
tie	←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
put	←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}
Cmp	←{n⊣(⍎COMPILER)⍺⊣(BUILD∆PATH,(dirc⍬),⍺,'_',COMPILER,'.c')put⍨gc tt⊃a n←ps ⍵}
mkf	←{f←⍵,'←{' ⋄ fn←BUILD∆PATH,(dirc⍬),⍺,'_',COMPILER,(soext⍬),'|',⍵,' '
	f,←'_←''dya''⎕NA''',fn,'>PP <PP <PP'' ⋄ _←''mon''⎕NA''',fn,'>PP P <PP'' ⋄ '
	f,'0=⎕NC''⍺'':mon 0 0 ⍵ ⋄ dya 0 ⍺ ⍵} ⋄ 0'}
MkNS	←{ns←#.⎕NS⍬ ⋄ ns⊣⍺∘{ns.⍎⍺ mkf ⍵}¨(1=1⌷⍉⍵)⌿0⌷⍉⍵}
Fix	←{⍺ MkNS ⍺ Cmp ⍵}
Xml	←{⎕XML (0⌷⍉⍵),(,∘⍕⌿2↑1↓⍉⍵),(⊂''),⍪(⊂(¯3+≢⍉⍵)↑,¨'nrsvyel'),∘⍪¨↓⍉3↓⍉⍵}
⍝[cf]
⍝[of]:AST
get	←{⍺⍺⌷⍉⍵}
up	←⍉(1+1↑⍉)⍪1↓⍉
bind	←{n _ e←⍵ ⋄ (0 n_⌷e)←⊂n ⋄ e}
⍝[of]:Field Accessors
d_ t_ k_ n_	←⍳f∆←4	⋄ d←d_ get	⋄ t←t_ get	⋄ k←k_ get	⋄ n←n_ get	
r_ s_ v_ y_ e_	←f∆+⍳5	⋄ r←r_ get	⋄ s←s_ get	⋄ v←v_ get	⋄ y←y_ get	⋄ e←e_ get
l_	←f∆+5+⍳1	⋄ l←l_ get	
⍝[cf]
⍝[of]:Node Constructors
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
⍝[cf]
⍝[of]:Parser
⍝[of]:Parsing Combinators
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
⍝[cf]
⍝[of]:Terminals/Tokens
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
prim←(prims←'+-÷×|*⍟⌈⌊<≤=≠≥>∧∨⍲⍱⌷⍴,⍪⌽⊖⍉∊⊃⍳○~≡≢⊢⊣/⌿\⍀⊤⊥↑↓')_set
mop←'¨/⌿⍀\⍨'_set ⋄ dop←'.⍤⍣∘'_set
eot←aws _s {''≡⍵:0 ⍬ ⍺ '' ⋄ 2 ⍬ ⍺ ⍵} _ign
digs←digits _some ⋄ odigs←digits _any
int←aws _s (him _opt) _s digs _s aws
float←aws _s (int _s dot _s odigs _o (dot _s digs)) _s aws
name←aws _s alpha _s (alpha _o digits _any) _s aws
aw←aws _s ('⍺⍵'_set) _s aws
sep←aws _s (('⋄',⎕UCS 10 13)_set _ign) _s aws
⍝[cf]
⍝[of]:Productions
Sfn←aws _s (('⎕sp' _tk)_o('⎕XOR' _tk)) _s aws _as {P ∊⍵}
Prim←prim _as {P⍵⍴⍨1+⍵∊'/⌿⍀\'} _o Sfn
Fn←{0<⊃c a e r←p←⍺(lbrc _s (Stmt _aew rbrc) _as F)⍵:p ⋄ c a ⍺ r}
Fnp←Fn _o Prim
Mop←(jot _s dot _as P) _s Fnp _as (1 O∘⌽) _o (Fnp _s (mop _as P) _as (1 O))
Dop←Fnp _s (dop _as P) _s Fnp _as (2 O)
Bop←{⍺(Prim _s lbrk _s Ex _s rbrk _as ('i'O))⍵}
Bind←{⍺(name _enc _s gets _s ⍺⍺ _env (⍵⍵{(⊃⍵)⍺⍺⍪⍺}) _as bind)⍵}
Fex←{⍺(∇ Bind 1 _o Dop _o Mop _o Bop _o Fn _o (1 Var'f') _o Prim)⍵}
Vt←{((0⌷⍉⍺)⍳⊂⍵)1⌷⍺⍪'' ¯1}
Var←{⍺(aw _o (name _t (⍺⍺=Vt)) _as (⍵⍵ V))⍵}
Num←float _o int _as N
Atom←{⍺(Num _some _as ('n'A) _o (0 Var'a' _as ('v'A)) _o Pex)⍵}
Mon←{⍺(Fex _s Ex _as (1 E))⍵}
Dya←{⍺((Idx _o Atom) _s Fex _s Ex _as (2 E))⍵}
Idx←{⍺(Atom _s lbrk _s Ex _s rbrk _as ('i'E))⍵}
Ex←{⍺(∇ Bind 0 _o Dya _o Mon _o Idx _o Atom)⍵}
Pex←lpar _s Ex _s rpar
Stmt←sep _any _s (Ex _o Fex) _s (sep _any)
Ns←nss _s (Stmt _aew nse) _s eot _as M
⍝[cf]
ps←{0≠⊃c a e r←(0 2⍴⍬)Ns ∊⍵,¨⎕UCS 10:⎕SIGNAL c ⋄ (⊃a)e}
⍝[cf]
⍝[of]:Core Compiler
tt←{fd fz ff if ef td vc fs rl av va lt nv fv ce fc∘pc⍣≡ ca fe dn lf du df rd rn ⍵}
⍝[of]:Utilities
scp	←(1,1↓Fm)⊂[0]⊢
mnd	←{A⊣((⍺ ⍺⍺ ⍵)⌿A)←⍺⊣A←⍵⍵ ⍵}
sub	←{⍺←⊢ ⋄ A⊣(m⌿A)←⍺ ⍺⍺(m←⍺ ⍵⍵ ⍵)⌿A←⍵}
prf	←((≢↑¯1↓(0≠⊢)(/∘⊢)⊢)⍤1↑∘r)⊢
blg	←{⍺←⊢ ⋄ ⍺((prf(⌈/(⍳∘≢⊢)×⍤1(1↓⊣)∧.(=∨0=⊢)∘⍉⊢)⍺⍺(⌿∘↑)r)⌷⍤0 2 ⍺⍺(⌿∘⊢)⍵⍵)⍵}
enc	←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
veo	←∪((⊂'%u'),(,¨prims),⊣)~⍨¯1↓⊢(/⍨)0≠((⊃0⍴⊢)¨⊢)
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
dua	←(Fm∨↓∘prf∊r∘Fs)(⊣(⍀∘⊢)(⊣(⌿∘⊢)0∊⍨n)(0,1↓(¯1⌽⊣)∧⊢=¯1⌽⊢)⊣(⌿∘⊢)d)⊢
du	←(~dua∨(∨/(prf∧.(=∨0=⊢)∘⍉dua(⌿∘⊢)prf)∧↑∘r∧.≥∘⍉dua(⌿∘⊢)↑∘r×0=prf))(⌿∘⊢)⊢
⍝[cf]
⍝[of]:Lift Functions
lfv	←⍉∘⍪(1+⊣),'Vf',('fn'enc 4⊃⊢),4↓⊢
lfn	←('F'≡1⊃⊢)⌷(⊣-⍨∘⊃⊢)((⊂∘⍉∘⍪⊣,1↓⊢),∘⊂(⊣,'Of',3↓⊢)⍪lfv)⊢
lfh	←(1<(+/⊣))⊃(⊂0↑⊢),∘⊂∘⍉∘⍪1'F'1,('fn'enc⊣),(⊂⊣),5↓∘,1↑⊢
lf	←(1↑⊢)⍪∘⊃(⍪/(1,1↓Fm)blg(↑r)(⊂lfh⍪∘⊃(⍪/((¯2+1=(+/⊣))+∘⊃⊢)lfn⍤¯1⊢))⌸1↓⊢)
⍝[cf]
⍝[of]:Drop Redundant Nodes
dn←((0∊⍨n)∧(Am∧'v'∊⍨k)∨Om∧'f'∊⍨k)((~⊣)(⌿∘⊢)(d-¯1⌽⊣),1↓[1]⊢)⊢
⍝[cf]
⍝[of]:Flatten Expressions
fen	←((⊂'fe')(⊃enc)¨((0∊⍨n)∧Em∨Om∨Am)(⌿∘⊢)r)((0∊⍨n)∧Em∨Om∨Am)mnd n⊢
fet	←('V'0⍴⍨2,⍨(+/0,1↓Em∨Om∨Am))(0,1↓Em∨Om∨Am)mnd(t,∘⍪k)⊢
fee	←(⍪/⌽)(1,1↓Em∨Om∨Am)blg⊢((⊂(d-⊃-2⌊⊃),fet,fen,4↓⍤1⊢)⍪)⌸1↓⊢
fe	←(⊃⍪/)(+\Fm)(⍪/(⊂1↑⊢),∘((+\d=⊃)fee⌸⊢)1↓⊢)⌸⊢
⍝[cf]
⍝[of]:Compress Atomic Nodes
can	←(+\Am∨Om)((,1↑⊢),∘(⊂(¯1+2⌊≢)⊃(⊂∘⊂⊃),⊂)∘n 1↓⊢)⌸⊢
cam	←Om∧'f'∊⍨k ⋄ cas←Am∨Nm∨cam∨(¯1⌽Am)∨¯1⌽cam
ca	←(can cas(⌿∘⊢)⊢)(Am∨cam)mnd⊢⍬,∘⊂⍨(~Nm∨(¯1⌽Am)∨¯1⌽cam)(⌿∘⊢)⊢
⍝[cf]
⍝[of]:Propogate Constants
pcc	←(⊂⊢(⌿⍨)Am∨Om∧'f'∊⍨k)∘((⍳∘∪⍨n)⌷⍤0 2(1⌈≢)↑⊢)∘((1+⊃),1↓⍤1⊢)∘(⊃⍪⌿)∘⌽(⌿∘⊢)
pcs	←(d,'V','f',(⊃v),r,(⊂⍬),⍨∘⍪s)sub Om
pcv	←(d,'V','a',(⊃v),r,(⊂⍬),⍨∘⍪s)sub (Am∧'v'∊⍨k)
pcb	←((,∧.(=∨0=⊣)∘⍪)⍤2 1⍨∘↑∘r(1↑⊢)⍪Fs)pcc⍤1((⊢(⌿⍨)d=1+⊃)¨⊣)
pcd	←((~(Om∧('f'∊⍨k)∧1≠d)∨Am∧d=1+(∨\Fm))(⌿∘⊢)⊢)∘(⊃⍪/)
pc	←pcd scp(pcb(pcv∘pcs(((1⌈≢)↑⊢)⊣)⌷⍤0 2⍨(n⊣)⍳n)sub(Vm∧n∊∘n⊣)¨⊣)⊢
⍝[cf]
⍝[of]:Fold Constant Expressions
fce	←(⊃∘n Ps){⊂⍎' ⍵',⍨(≢⍵)⊃''(⍺,'⊃')('⊃',⍺,'/')⊣⍵}(v As)
fc	←((⊃⍪/)(((d,'An',3↓¯1↓,)1↑⊢),fce)¨sub((∧/Em∨Am∨Pm)¨))('MFOE'∊⍨t)⊂[0]⊢
⍝[cf]
⍝[of]:Compress Expressions
ce←(+\Fm∨Em∨Om)((¯1↓∘,1↑⊢),∘⊂(⊃∘v 1↑⊢),∘((v As)Am mnd n⊢)1↓⊢)⌸⊢
⍝[cf]
⍝[of]:Record Final Return Value
fv←(⊃⍪/)(((1↓⊢)⍪⍨(,1 6↑⊢),∘⊂∘n ¯1↑⊢)¨scp)
⍝[cf]
⍝[of]:Normalize Values Field
nvu	←⊂'%u' ⋄ nvi	←⊂'%i'
nvo	←((¯1↓⊢),({⍺'%b'⍵}/∘⊃v))⍤1sub(Om∧'i'∊⍨k)
nve	←((¯1↓⊢),({,¨⍺'['⍵}/∘⊃v))⍤1sub(Em∧'i'∊⍨k)
nvk	←((2↑⊢),2,(3↓⊢))⍤1sub(Em∧'i'∊⍨k)
nv	←nvk(⊢,⍨¯1↓⍤1⊣)Om((¯1⊖(¯1+≢)⊃(⊂nvu,nvi,⊢),(⊂nvu⍪⊢),∘⊂⊢){⌽⍣⍺⊢⍵})¨v∘nvo∘nve
⍝[cf]
⍝[of]:Lift Type-Checking
⍝[of]:Primitive Types
⍝[c]Type:	Index	Right	Left		Type Codes:	Value	Type
⍝[c]	0	Unknown	Unknown			Unknown	0
⍝[c]	1	Unknown	Integer			Integer	1
⍝[c]	2	Unknown	Float			Float	2
⍝[c]	3	Unknown	Not bound			Not bound	3
⍝[c]	4	Integer	Unknown		
⍝[c]	5	Integer	Integer		Operator Codes:	Meaning	Code
⍝[c]	6	Integer	Float			Left	0
⍝[c]	7	Integer	Not bound			Right	1
⍝[c]	8	Float	Unknown			Error	¯N
⍝[c]	9	Float	Integer
⍝[c]	10	Float	Float
⍝[c]	11	Float	Not bound
⍝[c]	
pft←(2↑⊢)((5⍴0),(2↑⊢),(0⌷⊣),0,(¯2↑⊢),1⌷⊣)(2↓⊢)
pn←⍬	⋄ pt←0 12⍴⍬
pn,←⊂'%b'	⋄ pt⍪←pft 1 2 1 1 2 2
pn,←⊂'%i'	⋄ pt⍪←pft 1 2 0 0 0 0
pn,←⊂'%u'	⋄ pt⍪←12⍴3
⍝[c]
⍝[c]Name	RL:	IN	FN	II	IF	FI	FF
pn,←⊂,'⍺'	⋄ pt⍪←pft	¯6	¯6	1	2	1	2
pn,←⊂,'⍵'	⋄ pt⍪←pft	1	2	1	1	2	2
pn,←⊂,'+'	⋄ pt⍪←pft	1	2	1	2	2	2
pn,←⊂,'-'	⋄ pt⍪←pft	1	2	1	2	2	2
pn,←⊂,'÷'	⋄ pt⍪←pft	2	2	2	2	2	2
pn,←⊂,'×'	⋄ pt⍪←pft	1	1	1	2	2	2
pn,←⊂,'|'	⋄ pt⍪←pft	1	2	1	2	2	2
pn,←⊂,'*'	⋄ pt⍪←pft	2	2	2	2	2	2
pn,←⊂,'⍟'	⋄ pt⍪←pft	2	2	2	2	2	2
pn,←⊂,'⌈'	⋄ pt⍪←pft	1	2	1	2	2	2
pn,←⊂,'⌊'	⋄ pt⍪←pft	1	2	1	2	2	2
pn,←⊂,'<'	⋄ pt⍪←pft	¯2	¯2	1	1	1	1
pn,←⊂,'≤'	⋄ pt⍪←pft	¯2	¯2	1	1	1	1
pn,←⊂,'='	⋄ pt⍪←pft	¯2	¯2	1	1	1	1
pn,←⊂,'≠'	⋄ pt⍪←pft	¯2	¯2	1	1	1	1
pn,←⊂,'≥'	⋄ pt⍪←pft	¯2	¯2	1	1	1	1
pn,←⊂,'>'	⋄ pt⍪←pft	¯2	¯2	1	1	1	1
pn,←⊂,'⌷'	⋄ pt⍪←pft	1	2	1	¯11	2	¯11
pn,←⊂,'⍴'	⋄ pt⍪←pft	1	1	1	¯11	1	¯11
pn,←⊂,','	⋄ pt⍪←pft	1	2	1	2	2	2
pn,←⊂,'⍳'	⋄ pt⍪←pft	1	¯11	1	1	1	1
pn,←⊂,'○'	⋄ pt⍪←pft	2	2	2	2	2	2
pn,←⊂,'~'	⋄ pt⍪←pft	1	1	1	2	1	2
pn,←⊂,'['	⋄ pt⍪←pft	¯2	¯2	1	2	1	2
pn,←⊂,'∧'	⋄ pt⍪←pft	¯2	¯2	1	2	2	2
pn,←⊂,'∨'	⋄ pt⍪←pft	¯2	¯2	1	2	2	2
pn,←⊂,'⍲'	⋄ pt⍪←pft	¯2	¯2	1	1	1	1
pn,←⊂,'⍱'	⋄ pt⍪←pft	¯2	¯2	1	1	1	1
pn,←⊂,'⍪'	⋄ pt⍪←pft	1	2	1	2	2	2
pn,←⊂,'⌽'	⋄ pt⍪←pft	1	2	1	1	2	2
pn,←⊂,'∊'	⋄ pt⍪←pft	1	2	1	1	1	1
pn,←⊂,'⊃'	⋄ pt⍪←pft	1	2	0	0	0	0
pn,←⊂,'⊖'	⋄ pt⍪←pft	1	2	1	1	2	2
pn,←⊂,'≡'	⋄ pt⍪←pft	1	1	1	1	1	1
pn,←⊂,'≢'	⋄ pt⍪←pft	1	1	1	1	1	1
pn,←⊂,'⊢'	⋄ pt⍪←pft	1	2	1	1	2	2
pn,←⊂,'⊣'	⋄ pt⍪←pft	1	2	1	2	1	2
pn,←⊂'//'	⋄ pt⍪←pft	¯2	¯2	1	¯11	2	¯11
pn,←⊂,'⍉'	⋄ pt⍪←pft	1	2	¯16	¯16	¯16	¯16
pn,←⊂,'↑'	⋄ pt⍪←pft	¯16	¯16	1	¯11	2	¯11
pn,←⊂,'↓'	⋄ pt⍪←pft	¯16	¯16	1	¯11	2	¯11
pn,←⊂,'⊤'	⋄ pt⍪←pft	¯2	¯2	1	¯16	¯16	¯16
pn,←⊂,'⊥'	⋄ pt⍪←pft	¯2	¯2	1	¯16	¯16	¯16
pn,←⊂,'¨'	⋄ pt⍪←pft	0	0	0	0	0	0
pn,←⊂,'⍨'	⋄ pt⍪←pft	0	0	0	0	0	0
pn,←⊂,'/'	⋄ pt⍪←pft	0	0	0	¯11	0	¯11
pn,←⊂,'⌿'	⋄ pt⍪←pft	0	0	0	¯11	0	¯11
pn,←⊂,'\'	⋄ pt⍪←pft	0	0	¯11	¯11	¯11	¯11
pn,←⊂,'⍀'	⋄ pt⍪←pft	0	0	¯11	¯11	¯11	¯11
pn,←⊂'∘.'	⋄ pt⍪←pft	¯2	¯2	0	0	0	0
pn,←⊂,'.'	⋄ pt⍪←pft	¯2	¯2	0	0	0	0
pn,←⊂'⎕sp'	⋄ pt⍪←pft	¯2	¯2	1	¯11	¯11	¯11
pn,←⊂'⎕XOR'	⋄ pt⍪←pft	¯2	¯2	1	¯16	¯16	¯16
⍝[c]Name	RL:	IN	FN	II	IF	FI	FF
⍝[c]
⍝[cf]
⍝[c]oti:	(0 Lop) (1 Rop) (2 Rarg) (3 Larg)
otn←⍬	⋄ oti←0 2 2⍴⍬
otn,←⊂,'.'	⋄ oti⍪←↑(1 1)	(2 3)	⋄ otn,←⊂,'/'	⋄ oti⍪←↑(2 2)	(2 3)
otn,←⊂,'⌿'	⋄ oti⍪←↑(2 2)	(2 3)	⋄ otn,←⊂,'\'	⋄ oti⍪←↑(2 2)	(2 3)
otn,←⊂,'⍀'	⋄ oti⍪←↑(2 2)	(2 3)	⋄ otn,←⊂'∘.'	⋄ oti⍪←↑(2 3)	(2 3)
otn,←⊂,'¨'	⋄ oti⍪←↑(2 3)	(2 3)	
	oti⍪←↑(2 3)	(2 3)

lte	←((12⌊1 3 4⊥((∨⌿¯1=×)⍪|))2↑⊢)⌷⍤0 1∘,(⌊/∘,2↑⊢),⍨¯1↑⊢
ltot	←((pft 1 2 1 1 2 2)⍪⍉⍪pft 3 3 1 2 1 2)⍪⍨(2↑1↓(⊃y))
ltoa	←lte⍤2(2↑⊣),[1]⍨(oti⌷⍨otn⍳¯1↑∘⊃v)⌷⍤0 2 ltot
lto	←(((0,⍨⊢)⌷⍨1+¯1⌈⊃)⍤1∘⍉⍪1⊖⊢)ltoa⍪⍨¯1↑⊣
ltv	←(1⊃⊣)⌷⍤0 2⍨(0⊃⊣)⍳∘⊃v
ltt	←(Om∧1 2∨.=∘⊃k)⊃⊣(((lte⍪⊢)ltv){⍺⍵}ltv lto ⊢)∘{(2=⊃k ⍵)∧Om ⍵: ⍵ ⋄ ⍵}(⍉∘⍪⊢)
lta	←(1↓¨(⊂⊢),∘⊂(12⍴1+(≢∘⌊⍨⊃∘⊃))⍤0)∘(0,∘∪(0≡∘⊃0⍴⊢)¨(⌿∘⊢)⊢)∘(⊃,/)∘v Es⍪Os
ltb	←⊣⍪¨(⊂n),∘⊂∘↑((,1↑⊢)¨y)
lt	←(pn pt⍪¨lta)(ltb((,¯1↓⊢),∘⊂ltt)⍤1⊢)⍣≡(⊂4 12⍴0),⍨⊢
⍝[cf]
⍝[of]:Allocate Value Slots
val	←(n⍳∘∪n),¨⊢(⊢+(≢⊣)×0=⊢)(⌈/(⍳≢)×⍤1(∪n)∘.((⊂⊣)∊⊢)v)
vag	←∧∘~∘(∘.=⍨∘⍳≢)⍨(∘.(((1⌷⊢)>0⌷⊣)∧(0⌷⊢)<1⌷⊣)⍨val)
vae	←(∪n)(⊣,⍤0⊣(⌷⍨⍤1 0)∘⊃((⊢,(⊃(⍳∘≢⊣)~((≢⊢)↑⊣)(/∘⊢)⊢))/∘⌽(⊂⍬),∘↓⊢))vag
vac	←(((0⌷∘⍉⊣)⍳⊢)⌷(1⌷∘⍉⊣),⊢)⍤2 0
va	←((⊃⍪/)(1↑⊢),(((vae Es)(d,t,k,(⊣vac n),r,s,y,∘⍪⍨(⊂⊣)vac¨v)⊢)¨1↓⊢))scp
⍝[cf]
⍝[of]:Anchor Variables to Values
avb	←{(((,¨'⍺⍵')↑⍨1↓⍴)⍪⊢)⍺⌷⍨⍤2 0⊢⍺⍺⍳⍺⍺∩⍨(↓(⌽1+∘⍳0⍳⍨⊢)((≢⊢)↑↑)⍤0 1⊢)⊃r ⍵}
avh	←{⊂⍵,(n⍵)((⍺⍺(⍵⍵ avb)⍵){¯1 0+[0](⍴⍺⍺)⊤(,⍺⍺)⍳(⊂⍺),⍵})¨v⍵}
av	←(⊃⍪/)(+\Fm){⍺((⍺((∪n)Es)⌸⍵)avh(r(1↑⍵)⍪Fs ⍵))⌸⍵}⊢
⍝[cf]
⍝[of]:Record Live Variables
rlf	←(⌽↓(((1⊃⊣)∪⊢~0⌷⊣)/∘⌽(⊂⍬),↑)⍤0 1⍨1+∘⍳≢)(⊖1⊖n,⍤0(⊂⊣)veo¨v)
rl	←⊢,∘(⊃,/)(⊂∘n Os⍪Fs)rlf¨scp
⍝[cf]
⍝[of]:Fuse Scalar Loops
fsf	←(∪∘⊃,/)(⊂⊂⍬ ⍬ ⍬),(⌽¯1↓⊢)¨~¨(⊂,⊂'%u'(12⍴3)(¯1 0))∪¨∘(⍳∘≢↑¨⊂)⊣
fsn	←↓n,((,1↑⊢)¨y),⍤0((,1↑⍉)¨e)
fsv	←v(↓,∘⊃⍤0)¨((↓1↓⊢)¨y)(↓,⍤0)¨((↓1↓⍉)¨e)
fsh	←(⍉⍪)2'S'0 ⍬ ⍬ 0,(((⊂0⌷⊢),(⊂∘↑1⌷⊢),(⊂2⌷⊢))∘⍉1↓∘↑fsn fsf fsv),∘l ¯1↑⊢
fsm	←Em∧(1∊⍨k)∧(,¨'~⌷')∊⍨(⊃∘⌽¨v)
fss	←fsm∨Em∧(1 2∊⍨k)∧(,¨'+-×÷|⌊⌈*⍟○!∧∨⍱⍲<≤=≥>≠')∊⍨(⊃∘⌽¨v)
fsx	←(⊣(/∘⊢)fss∧⊣)(⊣⊃(⊂⊢),(⊂fsh⍪(1+d),'E',0,3↓⍤1⊢))¨⊂[0]
fs	←(⊃⍪/)(((((⊃⍪/)(⊂0 10⍴⍬),((2≠/(~⊃),⊢)fss)fsx⊢)Es)⍪⍨(~Em)(⌿∘⊢)⊢)¨scp)
⍝[cf]
⍝[of]:Compress Scalar Expressions
vc←(⊃⍪/)(((1↓⊢)⍪⍨(1 6↑⊢),(≢∘∪∘n Es),1 ¯3↑⊢)¨scp)
⍝[cf]
⍝[of]:Type Dispatch/Specialization
tde	←((¯3↓⊢),(Om⌷y,⍨∘⊂(5 6 7 9 10 11⌷⍨⊣)⌷∘⍉∘⊃y),¯2↑⊢)⍤1
tdf	←(1↓⊢)⍪⍨(,1 3↑⊢),(⊂(⊃n),'ii' 'if' 'in' 'fi' 'ff' 'fn'⊃⍨⊣),(4↓∘,1↑⊢)
td	←((⊃⍪/)(1↑⊢),∘(⊃,/)(((⍳6)(⊣tdf tde)¨⊂)¨1↓⊢))scp
⍝[cf]
⍝[of]:Convert Error Functions
eff	←(⊃⍪/)⊢(((⊂∘⍉∘⍪d,'Fe',3↓,)1↑⊣),1↓⊢)(d=∘⊃d)⊂[0]⊢
ef	←(Fm∧¯1=∘×∘⊃¨y)((⊃⍪/)(⊂⊢(⌿⍨)∘~(∨\⊣)),(eff¨⊂[0]))⊢
⍝[cf]
⍝[of]:Create Initializer for Globals
ifn	←1 'F' 0 'Init' ⍬ 0,(4⍴0) ⍬ ⍬,⍨⊢
if	←(1↑⊢)⍪(⊢(⌿⍨)Om∧1=d)⍪((up⍪⍨∘ifn∘≢∘∪n)⊢(⌿⍨)Em∧1=d)⍪(∨\Fm)(⌿∘⊢)⊢
⍝[cf]
⍝[of]:Flatten Functions
fft	←(,1↑⊢)(1 'Z',(2↓¯5↓⊣),(v⊣),n,y,(⊂2↑∘,1↑∘⍉∘⊃e),l)(¯1↑⊢)
ff	←((⊃⍪/)(1↑⊢),(((1↑⊢)⍪(((¯1+d),1↓⍤1⊢)1↓⊢)⍪fft)¨1↓⊢))scp
⍝[cf]
⍝[of]:Flatten Scalar Groups
fzt	←((∪n)∩(⊃∘l⊣))((⊂⊣),((≢⊢)-1+(⌽n)⍳⊣)((⊂⊣),∘⊂⊣⊃¨∘⊂((,1↑⍉)¨e))⊢)⊢
fzh	←((∪n)∩(⊃∘l⊣))((⊂⊣),((≢⊢)-1+(⌽n)⍳⊣)((⊂⊣⊃¨∘⊂((,1↑⍉)¨e)),∘⊂⊣⊃¨∘⊂(⊃¨y))⊢)⊢
fzf	←0≠(≢∘⍴¨∘⊃∘v⊣)
fzb	←(((⊃∘v⊣)(⌿⍨)fzf),n),∘⍪('f'∘,∘⍕¨∘⍳(+/fzf)),('s'∘,∘⍕¨∘⍳∘≢⊢)
fzv	←((⊂⊣)(⊖↑)⍨¨(≢⊣)(-+∘⍳⊢)(≢⊢))((⊢,⍨1⌷∘⍉⊣)⌷⍨(0⌷∘⍉⊣)⍳⊢)⍤2 0¨v
fze	←(¯1+d),t,k,fzb((⊢/(-∘≢⊢)↑⊣),r,s,fzv,y,e,∘⍪l)⊢
fzs	←(,1↑⊢)(((3↑⊣),fzh,6↓⊣)⍪fze⍪(1 'Y',(2↓¯4↓⊣),(⊂⍬),⍨fzt))(⌿∘⊢)
fz	←((⊃⍪/)(1↑⊢),(((2=d)(fzs⍪(1↓∘~⊣)(⌿∘⊢)1↓⊢)⊢)¨1↓⊢))(1,1↓Sm)⊂[0]⊢
⍝[cf]
⍝[of]:Create Function Declarations
fd←(1↑⊢)⍪((1,'Fd',3↓⊢)⍤1 Fs)⍪1↓⊢
⍝[cf]
⍝[cf]
⍝[cf]
⍝[of]:Code Generator
dis	←{⍺←⊢ ⋄ 0=⊃t⍵:3⍴⍬ ⋄ ⍺(⍎(⊃t⍵),⍕⊃k⍵)⍵}
gc	←{((⊃,/)⊢((fdb⍪⍨∘(dis⍤1)(⌿⍨))(⊂dis)⍤2 1(⌿⍨∘~))(Om∧1 2 'i'∊⍨k))⍵}
E1	←{r u f←⊃v⍵ ⋄ (2↑⊃y⍵)(f fcl ⍺)(⊃n⍵)r,⍪2↑↓⍉⊃e⍵}
E2	←{r l f←⊃v⍵ ⋄ (¯1↓⊃y⍵)(f fcl ⍺)((⊃n⍵)r l),⍪¯1↓↓⍉⊃e⍵}
E0	←{r l f←⊃v⍵ ⋄ (⊃git 1↑⊃y⍵),(⊃n⍵),'=',(sdb(f scl)(1+'%u'≢l)↑r l),';',nl}
Oi	←{(⊃n⍵)('Fexim()i',nl)('catdo')}
O1	←{(n⍵),odb(o ocl(⊃y⍵))⊂f⊣f u o←⊃v⍵}
O2	←{(n⍵),odb(o ocl(⊃y⍵))2↑⊣r l o←⊃v⍵}
O0	←{'' '' ''}
Of	←{fre,(⊃n⍵),elp,'{',nl,foi,tps,(⊃,/(⍳6)case¨⊂⍵),'}',nl,fcln,'}',nl,nl}
Fd	←{frt,(⊃n⍵),flp,';',nl}
Fe	←{frt,(⊃n⍵),flp,'{',nl,'error(',(⍕|⊃⊃y⍵),');',nl}
F0	←{frt,(⊃n⍵),flp,'{',nl,'A*env[]={tenv};',nl,('tenv'reg ⍵),nl}
F1	←{frt,(⊃n⍵),flp,'{',nl,('env0'dnv ⍵),(fnv ⍵),('env0'reg ⍵),nl,''⊣fnacc⍵}
Z0	←{'}',nl,nl}
zap	←{'memcpy(z,',((⊃n⍵)var ⊃e⍵),',sizeof(A));'}
Z1	←{'cpaa(z,',((⊃n⍵)var⊃e⍵),');',nl,'fe(&env0[1],',(⍕¯1+⊃s⍵),');}',nl,nl}
Ze	←{'}',nl,nl}
M0	←{rth,('tenv'dnv ⍵),nl,'A*env[]={',((0≡⊃⍵)⊃'tenv' 'NULL'),'};',nl}
S0	←{(('{',rk0,srk,'DO(i,prk)cnt*=sp[i];',spp,sfv,slp)⍵)}
Y0	←{⊃,/((⍳≢⊃v⍵)((⊣sts¨∘⊃y),'}',nl,⊣ste¨(⊃v)var¨∘⊃e)⍵),'}',nl}
⍝[cf]
⍝[of]:Runtime Code
⍝[of]:Runtime Utilities
nl	←⎕UCS 13 10
enc	←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
fvs	←,⍤0(⌿⍨)0≠(≢∘⍴¨⊣)
cln	←'¯'⎕R'-'
var	←{(,'⍺')≡⍺:,'l' ⋄ (,'⍵')≡⍺:,'r' ⋄ ¯1=⊃⍵:,⍺ ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
dnv	←{(0≡z)⊃('A ',⍺,'[',(⍕z←⊃v⍵),'];')('A*',⍺,'=NULL;')}
reg	←{'DO(i,',(⍕⊃v⍵),')',⍺,'[i].v=NULL;'}
fnv	←{'A*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
git	←{⍵⊃¨⊂'/* XXX */ aplint32 ' 'aplint32 ' 'double ' '?type? '}
gie	←{⍵⊃¨⊂'/* XXX */ APLLONG' 'APLLONG' 'APLDOUB' 'APLNA'}
pacc	←{('pg'≡2↑COMPILER)⊃''('#pragma acc ',⍵,nl)}
simdc	←{('#pragma acc kernels loop ',⍵,nl)('#pragma simd',nl)('')}
simd	←{('pg' 'ic'⍳⊂2↑COMPILER)⊃simdc ⍵}
⍝[cf]
⍝[of]:Function Entry
frt	←'static void '
fre	←'void EXPORT '
foi	←'if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}',nl
flp	←'(A*z,A*l,A*r,A*penv[])'
elp	←'(LOCALP*z,LOCALP*l,LOCALP*r)'
tps	←'A cl,cr;cl.v=NULL;cr.v=NULL;cpda(&cr,r);if(l!=NULL)cpda(&cl,l);',nl
tps	,←'int tp=0;switch(r->p->ELTYPE){',nl
tps	,←'case APLINTG:case APLSINT:case APLLONG:break;',nl
tps	,←'case APLDOUB:tp=3;break;default:error(16);}',nl
tps	,←'if(l==NULL)tp+=2;else switch(l->p->ELTYPE){',nl
tps	,←'case APLINTG:case APLSINT:case APLLONG:break;',nl
tps	,←'case APLDOUB:tp+=1;break;default:error(16);}',nl
tps	,←'A za;za.v=NULL;',nl,'switch(tp){',nl
tpi	←'ii' 'if' 'in' 'fi' 'ff' 'fn'
fcln	←'frea(&cl);frea(&cr);frea(&za);',nl
did	←5 6 7 9 10 11
dcl	←{(0>e)⊃((⊃⊃v⍵),(⍺⊃tpi),'(&za,&cl,&cr,env);')('error(',(cln⍕e←⊃(⍺⌷did)⌷⍉⊃y⍵),');')}
dcp	←{(0>e)⊃('cpad(z,&za,',(⊃gie 0⌈e←⊃(⍺⌷did)⌷⍉⊃y ⍵),');')''}
case	←{'case ',(⍕⍺),':',(⍺ dcl ⍵),(⍺ dcp ⍵),'break;',nl}
fnacc	←{(pacc 'data copyin(env0[:',(⍕⊃v⍵),'])'),'{'}
⍝[cf]
⍝[of]:Scalar Primitives
⍝ respos←'⍵ % ⍺'
respos	←'fmod((double)⍵,(double)⍺)'
resneg	←'⍵-⍺*floor(((double)⍵)/(double)(⍺+(0==⍺)))'
residue	←'(0<=⍺&&0<=⍵)?',respos,':',resneg

sdb←0 3⍴⊂'' ⋄ scl←{cln ((≢⍵)↑,¨'⍵⍺')⎕R(('%'⎕R'\\\%')∘⍕¨⍵) ⊃⍺⌷⍨((⊂⍺⍺)⍳⍨0⌷⍉⍺),≢⍵}
⍝[c]
⍝[c]Prim	Monadic	Dyadic
sdb⍪←,¨'+'	'⍵'	'⍺+⍵'
sdb⍪←,¨'-'	'-1*⍵'	'⍺-⍵'
sdb⍪←,¨'×'	'(⍵>0)-(⍵<0)'	'⍺*⍵'
sdb⍪←,¨'÷'	'1.0/⍵'	'((double)⍺)/((double)⍵)'
sdb⍪←,¨'*'	'exp((double)⍵)'	'pow((double)⍺,(double)⍵)'
sdb⍪←,¨'⍟'	'log((double)⍵)'	'log((double)⍵)/log((double)⍺)'
sdb⍪←,¨'|'	'fabs(⍵)'	residue
sdb⍪←,¨'○'	'PI*⍵'	'error(16)'
sdb⍪←,¨'⌊'	'floor((double)⍵)'	'⍺ < ⍵ ? ⍺ : ⍵'
sdb⍪←,¨'⌈'	'ceil((double)⍵)'	'⍺ > ⍵ ? ⍺ : ⍵'
sdb⍪←,¨'<'	'error(99)'	'⍺<⍵'
sdb⍪←,¨'≤'	'error(99)'	'⍺<=⍵'
sdb⍪←,¨'='	'error(99)'	'⍺==⍵'
sdb⍪←,¨'≥'	'error(99)'	'⍺>=⍵'
sdb⍪←,¨'>'	'error(99)'	'⍺>⍵'
sdb⍪←,¨'≠'	'error(99)'	'⍺!=⍵'
sdb⍪←,¨'~'	'0==⍵'	'error(16)'
sdb⍪←,¨'∧'	'error(99)'	'⍺ && ⍵'
sdb⍪←,¨'∨'	'error(99)'	'⍺ || ⍵'
sdb⍪←,¨'⍲'	'error(99)'	'!(⍺ && ⍵)'
sdb⍪←,¨'⍱'	'error(99)'	'!(⍺ || ⍵)'
sdb⍪←,¨'⌷'	'⍵'	'error(99)'
sdb⍪←'⎕XOR'	'error(99)'	'⍺ ^ ⍵'

⍝[of]:Scalar Loop Generators
simc	←{'present(',(⊃{⍺,',',⍵}/⊃,/'dr',∘⍕¨∘⍳∘≢¨((⊃v⍵)fvs(⊃e⍵))(⊃n⍵)),')'}
slp	←{(simd simc ⍵),'DO(i,cnt){',nl,⊃,/(git 1⌷⍉(⊃v⍵)fvs(⊃y⍵))sip¨⍳≢(⊃v⍵)fvs(⊃e⍵)}
rk0	←'I prk=0;B sp[15];B cnt=1;',nl
rk1	←'if(prk!=(' ⋄ rk2←')->r){if(prk==0){',nl
rsp	←{'prk=(',⍵,')->r;',nl,'DO(i,prk) sp[i]=(',⍵,')->s[i];'}
rk3	←'}else if((' ⋄ rk4←')->r!=0)error(4);',nl
spt	←{'if(sp[i]!=(',⍵,')->s[i])error(4);'}
rkv	←{rk1,⍵,rk2,(rsp ⍵),rk3,⍵,rk4,'}else{',nl,'DO(i,prk){',(spt ⍵),'}}',nl}
rk5	←'if(prk!=1){if(prk==0){prk=1;sp[0]='
rka	←{rk5,l,';}else error(4);}else if(sp[0]!=',(l←⍕≢⍵),')error(4);',nl}
crk	←{⍵((⊃,/)((rkv¨var/)⊣(⌿⍨)(~⊢)),(rka¨0⌷∘⍉(⌿⍨)))0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵}
srk	←{crk(⊃v⍵)(,⍤0(⌿⍨)0≠(≢∘⍴¨⊣))(⊃e⍵)}
ste	←{'cpaa(',⍵,',&p',(⍕⍺),');',nl}
sts	←{'r',(⍕⍺),'[i]=s',(⍕⍵),';',nl}
rkp1	←{'I m',(⍕⍺),'=(',(⍕⍵),')->r==0?0:1;',nl}
rkp2	←{''('B mz',(⍕⍺),'=(',(⍕⍵),')->r==0?1:cnt;',nl)}
rkp	←{(⍺ rkp1 ⍵),('pg'≡2↑COMPILER)⊃⍺ rkp2 ⍵}
gdp	←{'*restrict d',(⍕⍺),'=(',⍵,')->v;',nl}
gda1	←{'d',(⍕⍺),'[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl}
gdm	←{'I m',(⍕⍺),'=',(⍕0≢≢⍵),';',nl}
gda2	←{''('B mz',(⍕⍺),'=cnt;',nl)}
gda	←{(⍺ gda1 ⍵),(⍺ gdm ⍵),('pg'≡2↑COMPILER)⊃⍺ gda2 ⍵}
sfa	←{(git m/⍺),¨{((+/~m)+⍳≢⍵)gda¨⍵}⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfp	←{(git m⌿⍺),¨{(⍳≢⍵)(gdp,rkp)¨⍵}var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfv	←(1⌷∘⍉(⊃v)fvs(⊃y))((⊃,/)sfp,sfa)(⊃v)fvs(⊃e)
ack	←{'AI(&p',(⍕⍺),',prk,sp,',(⊃git ⍺⌷⍺⍺),');',nl}
gpp	←{⊃,/{'A p',(⍕⍵),';p',(⍕⍵),'.v=NULL;',nl}¨⍳≢⍵}
grs	←{(⊃git ⍺),'*restrict r',(⍕⍵),'=p',(⍕⍵),'.v;',nl}
spp	←(⊃s){(gpp⍵),(⊃,/(⍳≢⍵)(⍺ ack)¨⍵),(⊃,/⍺ grs¨⍳≢⍵)}(⊃n)var¨(⊃r)
sip	←{⍺,'f',⍵,'=d',⍵,'[i*m',⍵,'];',nl}∘⍕
⍝[cf]
⍝[cf]
⍝[of]:Primitive Operators
ocl	←{⍵∘(⍵⍵{'(',(opl ⍺),(opt ⍺⍺),⍵,' ⍵⍵)'})¨1↓⍺⌷⍨(0⌷⍉⍺)⍳⊂⍺⍺}
opl	←{⊃,/{'(,''',⍵,''')'}¨⍵}
opt	←{'(',(⍕⍴⍵),'⍴',(⍕,⍵),')'}
odb	←0 3⍴⊂''
⍝[c]
⍝[c]Prim	Monadic	Dyadic
odb⍪←,¨'⍨'	'comm'	'comd'
odb⍪←,¨'¨'	'eacm'	'eacd'
odb⍪←,¨'/'	'redm'	'redd'
odb⍪←,¨'⌿'	'rd1m'	'rd1d'
odb⍪←,¨'\'	'scnm'	'{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 16}'
odb⍪←,¨'⍀'	'sc1m'	'{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 16}'
odb⍪←,¨'.'	'{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 99}'	'inpd'
odb⍪←'∘.'	'{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 99}'	'oupd'

⍝[of]:Scalar/Mixed Function Conversion
mxsm←{	siz	←'zr=rr;DO(i,zr){zc*=rs[i];zs[i]=rs[i];}'
	exe	←(simd''),'DO(i,zc){zv[i]=',(,'⍵')⎕R'rv[i]'⊢⍺⍺,';}'
		'' siz exe mxfn ⍺ ⍵}
mxsd←{	chk	←'if(lr==rr){DO(i,lr){if(rs[i]!=ls[i])error(5);}}',nl
	chk	,←'else if(lr!=0&&rr!=0){error(4);}'
	siz	←'if(rr==0){zr=lr;DO(i,lr){zc*=ls[i];lc*=ls[i];zs[i]=ls[i];}}',nl
	siz	,←'else{zr=rr;DO(i,rr){zc*=rs[i];rc*=rs[i];zs[i]=rs[i];}DO(i,lr)lc*=ls[i];}',nl
	exe	←simd 'pcopyin(lv[:lc],rv[:rc])'
	exe	,←'DO(i,zc){zv[i]=',(,¨'⍺⍵')⎕R'lv[i\%lc]' 'rv[i\%rc]'⊢⍺⍺,';}'
		chk siz exe mxfn ⍺ ⍵}
scmx←{	(⊂⍺⍺)∊0⌷⍉sdb:(⊃⍵),'=',';',⍨sdb(⍺⍺ scl)1↓⍵ ⋄ ⍺(⍺⍺ fcl ⍵⍵)⍵,⍤0⊢⊂2⍴¯1}
sdbm	←(0⌷⍉sdb),'mxsm' 'mxsd'{'(''',⍵,'''',⍺,')'}¨⍤1⊢⍉1↓⍉sdb
⍝[cf]
⍝[of]:Commute
comd	←{((1↑⍺)⍪⊖1↓⍺)((⊃⍺⍺)fcl(⍵⍵⍪sdbm))(1↑⍵)⍪⊖1↓⍵}
comm	←{((1↑⍺)⍪⍪⍨1↓⍺)((⊃⍺⍺)fcl(⍵⍵⍪sdbm))(1↑⍵)⍪⍪⍨1↓⍵}
⍝[cf]
⍝[of]:Each
eacm←{	siz	←'zr=rr;DO(i,zr){zc*=rs[i];zs[i]=rs[i];}'
	exe	←'DO(i,zc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i]' 'rv[i]'),'}'
		'' siz exe mxfn ⍺ ⍵}
eacd←{	chk	←'if(lr==rr){DO(i,lr){if(rs[i]!=ls[i])error(5);}}',nl
	chk	,←'else if(lr!=0&&rr!=0){error(4);}'
	siz	←'if(rr==0){zr=lr;DO(i,lr){zc*=ls[i];lc*=ls[i];zs[i]=ls[i];}}',nl
	siz	,←'else{zr=rr;DO(i,rr){zc*=rs[i];rc*=rs[i];zs[i]=rs[i];}DO(i,lr)lc*=ls[i];}'
	exe	←'DO(i,zc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[i]' 'rv[i]' 'lv[i]'),'}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce
redm←{	idf	←(,¨'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'),⊂'⎕XOR'
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 0 ''
	hid	←idf∊⍨0⌷⍺⍺
	gpf	←(,¨'+×∧∨'),⊂'⎕XOR'
	gpv	←⍕¨0 1 1 0 0 ''
	gid	←gpf∊⍨0⌷⍺⍺
	chk	←hid⊃('if(rr>0&&rs[rr-1]==0)error(11);')''
	siz	←'if(rr==0){zr=0;}',nl
	siz	,←'else{zr=rr-1;DO(i,zr){zc*=rs[i];zs[i]=rs[i];};rc=rs[zr];}'
	gxe	←'if(zc==1){',(⊃git⊃⍺),'val=',(gpv⊃⍨gpf⍳0⌷⍺⍺),';',nl
	gxe	,←pacc 'kernels loop present(rv[:rc])'
	gxe	,←'DO(i,rc){'
	gxe	,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[rc-(1+i)]'
	gxe	,←'}',nl,'zv[0]=val;',nl,pacc 'update device(zv[:1])'
	gxe	,←'}else{',nl,pacc'kernels loop gang worker(32) present(zv,rv[:rc])'
	gxe	,←'DO(i,zc){',(⊃git⊃⍺),'val=',(gpv⊃⍨gpf⍳0⌷⍺⍺),';',nl
	gxe	,←pacc'loop vector(32)'
	gxe	,←'DO(j,rc){'
	gxe	,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[(i*rc)+(rc-(1+j))]'
	gxe	,←'}',nl,'zv[i]=val;}}',nl
	ixe	←pacc 'update host(rv[:rgt->c])'
	ixe	,←'DO(i,zc){',(⊃git⊃⍺),'val=',(idv⊃⍨idf⍳0⌷⍺⍺),';',nl,'DO(j,rc){'
	ixe	,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[(i*rc)+(rc-(1+j))]'
	ixe	,←'}',nl,'zv[i]=val;}',nl,pacc'update device(zv[:rslt->c])'
	exe	←pacc'update host(rv[:rgt->c])'
	exe	,←'DO(i,zc){',(⊃git ⊃⍺),'val=rv[(i*rc)+rc-1];L n=rc-1;',nl,'DO(j,n){'
	exe	,←((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'val' 'val' 'rv[(i*rc)+(rc-(2+j))]'
	exe	,←'}',nl,'zv[i]=val;}',nl,pacc'update device(zv[:rslt->c])'
		chk siz (exe ixe gxe⊃⍨gid+hid) mxfn ⍺ ⍵}
redd←{	idf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
	hid	←idf∊⍨⊃⊃⍺⍺ ⋄ a←0 1 1⊃¨⊂⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))error(5);',nl
	chk	,←'if(rr==0)error(4);',nl,hid⊃('if(lv[0]==0)error(11);',nl)''
	chk	,←'if((rs[rr-1]+1)<lv[0])error(5);rc=(1+rs[rr-1])-lv[0];'
	siz	←'zr=rr;I n=zr-1;DO(i,n){zc*=rs[i];zs[i]=rs[i];};zs[zr-1]=rc;lc=rs[rr-1];'
	exe	←'DO(i,zc){DO(j,rc){zv[(i*rc)+j]='
	exe	,←hid⊃'rv[(i*lc)+j+lv[0]-1];'(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺)
	val	←'zv[(i*rc)+j]' 'zv[(i*rc)+j]'('rv[(i*lc)+j+(lv[0]-(k+',(hid⌷'21'),'))]')
	exe	,←nl,' L n=lv[0]',(hid⊃'-1' ''),';DO(k,n){',(a((⊃⍺⍺)scmx ⍵⍵)val),'}}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce First Axis
rd1m←{	idf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
	hid	←idf∊⍨⊃⊃⍺⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
	chk	←hid⊃('if(rr>0&&rs[0]==0)error(11);')''
	siz	←'if(rr==0){zr=0;}',nl
	siz	,←'else{zr=rr-1;DO(i,zr){zc*=rs[i+1];zs[i]=rs[i+1];};rc=rs[0];}'
	exe	←'if(rc==1){DO(i,zc)zv[i]=rv[i];}',nl,'else '
	exe	,←hid⊃''('if(rc==0){DO(i,zc)zv[i]=',(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺),'}',nl,'else ')
	exe	,←'{DO(i,zc){zv[i]=rv[((rc-1)*zc)+i];',nl,' L n=rc-1;DO(j,n){'
	exe	,←(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)'zv[i]' 'zv[i]' 'rv[(zc*(rc-(j+2)))+i]'),'}}}'
		chk siz exe mxfn ⍺ ⍵}
rd1d←{	idf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
	hid	←idf∊⍨⊃⊃⍺⍺
	a	←0 1 1⊃¨⊂⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))error(5);',nl
	chk	,←'if(rr==0)error(4);',nl,hid⊃('if(lv[0]==0)error(11);',nl)''
	chk	,←'if((rs[0]+1)<lv[0])error(5);rc=(1+rs[0])-lv[0];'
	siz	←'zr=rr;I n=zr-1;DO(i,n){zc*=rs[i+1];zs[i+1]=rs[i+1];};zs[0]=rc;'
	exe	←'DO(i,zc){DO(j,rc){zv[(j*zc)+i]='
	exe	,←hid⊃'rv[((j+lv[0]-1)*zc)+i];'(';',⍨idv⊃⍨idf⍳⊃⊃⍺⍺)
	val	←'zv[(j*zc)+i]' 'zv[(j*zc)+i]'('rv[((j+(lv[0]-(k+',(hid⌷'21'),')))*zc)+i]')
	exe	,←nl,' L n=lv[0]',(hid⊃'-1' ''),';DO(k,n){',(a((⊃⍺⍺)scmx ⍵⍵)val),'}}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Scan
scnm←{	siz	←'zr=rr;rc=rr==0?1:rs[rr-1];DO(i,zr)zs[i]=rs[i];',nl
	siz	,←'I n=zr==0?0:zr-1;DO(i,n)zc*=rs[i];'
	val	←'zv[(i*rc)+j+1]' 'zv[(i*rc)+j]' 'rv[(i*rc)+j+1]'
	exe	←pacc'update host(zv[:rslt->c],rv[:rgt->c])'
	exe	,←'if(rc!=0){DO(i,zc){zv[i*rc]=rv[i*rc];',nl
	exe	,←' L n=rc-1;DO(j,n){',(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
	exe	,←pacc'update device(zv[:rslt->c],rv[:rgt->c])'
		'' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Scan First Axis
sc1m←{	siz	←'zr=rr;rc=rr==0?1:rs[0];DO(i,zr)zs[i]=rs[i];',nl
	siz	,←'I n=zr==0?0:zr-1;DO(i,n)zc*=rs[i+1];'
	exe	←pacc'update host(zv[:rslt->c],rv[:rgt->c])'
	exe	,←'if(rc!=0){DO(i,zc){zv[i]=rv[i];}',nl
	val	←'zv[((j+1)*zc)+i]' 'zv[(j*zc)+i]' 'rv[((j+1)*zc)+i]'
	exe	,←' DO(i,zc){L n=rc-1;DO(j,n){',(((⊃⍺),⍺)((⊃⍺⍺)scmx ⍵⍵)val),'}}}',nl
	exe	,←pacc'update device(zv[:rslt->c],rv[:rgt->c])'
		'' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Outer Product
oupd←{	siz	←'zr=lr+rr;DO(i,lr)zs[i]=ls[i];DO(i,rr)zs[i+lr]=rs[i];'
	exe	←'DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
	exe	,←'DO(i,lc){DO(j,rc){',(⍺((⊃⍺⍺)scmx ⍵⍵)'zv[(i*rc)+j]' 'rv[j]' 'lv[i]'),'}}'
		'' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Inner Product
inpd←{	idf	←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖'
	hid	←idf∊⍨⊃0⊃⍺⍺
	idv	←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
	chk	←'if(rr!=0&&lr!=0){',nl
	chk	,←'if(ls[lr-1]!=rs[0])error(5);',nl
	chk	,←(hid⊃('if(rs[0]==0)error(11);',nl)''),'}'
	siz	←'zr=0;if(lr>0){zr=lr-1;DO(i,zr)zs[i]=ls[i];}',nl
	siz	,←'if(rr>0){I n=rr-1;DO(i,n){zs[i+zr]=rs[i+1];}zr+=rr-1;}'
	typ	←2⌷(3 4⊥2↑1↓⍺)⌷⍉2⊃⍺⍺
	exe	←'I n=lr==0?0:lr-1;DO(i,n)zc*=ls[i];n=rr==0?0:rr-1;DO(i,n)rc*=rs[i+1];',nl
	exe	,←'if(lr!=0)lc=ls[lr-1];else if(rr!=0)lc=rs[0];',nl,(⊃git typ),'tmp;',nl
	exe	,←'BOUND lz,rz;lz=lr==0?1:zc*lc;rz=rr==0?1:rc*lc;',nl
	exe	,←hid⊃''('L m=zc*rc;DO(i,m){zv[i]=',(⍕idv⊃⍨idf⍳⊃0⊃⍺⍺),';}')
	stp rng	←hid⊃('2' 'lc-1')('1' 'lc')
	arg1	←'tmp'('rv[(((lc-(j+',stp,'))*rc)+k)%rz]')('lv[((i*lc)+(lc-(j+',stp,')))%lz]')
	arg2	←'zv[(i*rc)+k]' 'zv[(i*rc)+k]' 'tmp'
	fil	←'zv[(i*rc)+j]' 'rv[(((lc-1)*rc)+j)%rz]' 'lv[((i*lc)+(lc-1))%lz]'
	exe	,←'DO(i,zc){',hid⊃('DO(j,rc){',(⍺((1⊃⍺⍺)scmx ⍵⍵)fil),'}',nl)''
	exe	,←' L n=',rng,';DO(j,n){DO(k,rc){',nl
	exe	,←((typ,1↓⍺)((1⊃⍺⍺)scmx ⍵⍵)arg1),nl
	exe	,←((typ,⍨2⍴1↑⍺)((0⊃⍺⍺)scmx ⍵⍵)arg2),'}}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[cf]
⍝[of]:Mixed Functions
fdb←0 3⍴⊂'' ⋄ fcl←{cln ⍺(⍎⊃(((0⌷⍉⍵⍵)⍳⊂⍺⍺),¯1+≢⍵)⌷⍵⍵⍪fnc ⍺⍺)⍵}
fnc←{⍵('''',⍵,'''calm')('''',⍵,'''cald')}
⍝[c]
⍝[c]Prim	Monadic	Dyadic
fdb⍪←,¨'⌷'	'{⎕SIGNAL 99}'	'idxd'
fdb⍪←,¨'['	'{⎕SIGNAL 99}'	'brid'
fdb⍪←,¨'⍳'	'iotm'	'{⎕SIGNAL 16}'
fdb⍪←,¨'⍴'	'shpm'	'shpd'
fdb⍪←,¨','	'catm'	'catd'
fdb⍪←,¨'⍪'	'fctm'	'fctd'
fdb⍪←,¨'⌽'	'rotm'	'{⎕SIGNAL 16}'
fdb⍪←,¨'⊖'	'rtfm'	'rtfd'
fdb⍪←,¨'∊'	'memm'	'memd'
fdb⍪←,¨'⊃'	'dscm'	'{⎕SIGNAL 16}'
fdb⍪←,¨'≡'	'eqvm'	'eqvd'
fdb⍪←,¨'≢'	'nqvm'	'nqvd'
fdb⍪←,¨'⊢'	'rgtm'	'rgtd'
fdb⍪←,¨'⊣'	'lftm'	'lftd'
fdb⍪←,¨'//'	'{⎕SIGNAL 99}'	'fltd'
fdb⍪←,¨'⍉'	'tspm'	'{⎕SIGNAL 16}'
fdb⍪←,¨'↓'	'{⎕SIGNAL 16}'	'drpd'
fdb⍪←,¨'↑'	'{⎕SIGNAL 16}'	'{⎕SIGNAL 16}'
fdb⍪←,¨'⊤'	'{⎕SIGNAL 99}'	'encd'
fdb⍪←,¨'⊥'	'{⎕SIGNAL 99}'	'decd'
fdb⍪←,¨'⎕sp'	'{⎕SIGNAL 99}'	'sopid'

⍝[of]:Function Utilities
calm←{	z r	←var/⍵
	arr	←⍺⍺,((1⌷⍺)⊃'iif'),'n(',z,',NULL,',r,',env);',nl
	scl	←'{A sz,sr;sz.v=NULL;sr.v=NULL;',nl
	scl	,←(⊃,/(git ⍺){'AI(&s',⍵,',0,NULL,',⍺,');'}¨'zr'),nl
	scl	,←(1⊃git ⍺),'*restrict srv=sr.v;*srv=',r,';',nl
	scl	,←⍺⍺,((1⌷⍺)⊃'iif'),'n(&sz,NULL,&sr,env);',nl
	scl	,←(⊃git ⍺),'*restrict szv=sz.v;',z,'=*szv;frea(&sz);frea(&sr);}',nl
		(∧/¯1=,↑1⌷⍉⍵)⊃arr scl}
cald←{	z r l	←var/⍵
	arr	←⍺⍺,((¯2↑⍺)⊃¨⊂'iif'),'(',z,',',l,',',r,',env);',nl
	scl	←'{A sz,sr,sl;sz.v=sr.v=sl.v=NULL;',nl
	scl	,←(⊃,/(gie ⍺){'AI(&s',⍵,',0,NULL,',⍺,');'}¨'zrl'),nl
	scl	,←(⊃,/(git ¯2↑⍺){⍺,'*restrict s',⍵,'v=s',⍵,'.v;'}¨'rl'),nl
	scl	,←(⊃,/'rl'{'*s',⍺,'v=',⍵,';'}¨r l),nl
	scl	,←pacc'update device(srv[:1],slv[:1])'
	scl	,←⍺⍺,((¯2↑⍺)⊃¨⊂'iif'),'(&sz,&sl,&sr,env);',nl
	scl	,←(⊃git⍺),'*szv=sz.v;',nl,pacc'update host(szv[:1])'
	scl	,←z,'=*szv;frea(&sz);frea(&sr);frea(&sl);}',nl
		(∧/¯1=,↑1⌷⍉⍵)⊃arr scl}
mxfn←{	chk siz exe	←⍺
	tp el	←⍵
	vr	←(∧/¯1=↑1⌷⍉el)+0≠(⊃0⍴⊃)¨0⌷⍉el
	tpl tpv tps	←(tp(/⍨)vr=⊢)¨⍳3
	nml nmv nms	←(('zrl'↑⍨≢el)/⍨vr=⊢)¨⍳3
	elv ell els	←1 0 2(⊢(/⍨)vr=⊣)¨(⊂(≢el)↑'rslt' 'rgt' 'lft'),2⍴⊂0⌷⍉el
	z	←'{B zc=1,rc=1,lc=1;A*orz;A tp;tp.v=NULL;int tpu=0;',nl
	z	,←(⊃,/(⊂''),elv{'A *',⍺,'=',⍵,';'}¨var/(1=vr)⌿el),nl
	z	,←⊃,/(⊂''),nml{'I ',⍺,'r=1;B ',⍺,'s[]={',(⍕≢⍵),'};'}¨ell
	z	,←⊃,/(⊂''),(git tpl),¨nml{⍺,'v[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl}¨ell
	z	,←pacc'enter data copyin(',(⊃{⍺,',',⍵}/(⊂'zc'),{⍵,'v'}¨nml),')'
	z	,←(⊃,/(⊂''),(git tps),¨nms{'*s',⍺,'=&',⍵,';'}¨els),nl↑⍨≢els
	z	,←(⊃,/(⊂''),{'I ',⍵,'r=0;B*',⍵,'s=NULL;'}¨nms),nl↑⍨≢nms
	z	,←(⊃,/(⊂''),(git tps){⍺,⍵,'v[]={*s',⍵,'};'}¨nms),nl↑⍨≢nms
	z	,←'if(',(⊃{⍺,'||',⍵}/(⊂'0'),'rslt=='∘,¨1↓elv),')'
	z	,←'{orz=rslt;rslt=&tp;tpu=1;}',nl
	z	,←(0≡≢elv)⊃'' 'A*rslt=&tp;'
	tpv nmv elv	,←(0≡≢elv)⊃(3⍴⊂⍬)((⊃tps)'z' 'rslt')
	z	,←((1↓tpv)((1↓nmv)decl)1↓elv),'I zr;B zs[15];',nl
	z	,←chk,(nl ''⊃⍨''≡chk),siz,nl,'AI(rslt,zr,zs,',(⊃git ⊃0⌷tp),');',nl
	z	,←((1↑tpv)((1↑nmv)declv)1↑elv),exe,((0≡≢elv)⊃'' '*sz=zv[0];'),nl
	z	,←pacc'exit data delete(',(⊃{⍺,',',⍵}/(⊂'zc'),{⍵,'v'}¨nml),')'
	z	,←'if(tpu){cpaa(orz,rslt);}}',nl
		z}
decl←{	z	←(⊃,/(⊂''),⍺⍺{'I ',⍺,'r=',⍵,'->r;'}¨⍵),nl
	z	,←(⊃,/(⊂''),⍺⍺{'B*restrict ',⍺,'s=',⍵,'->s;'}¨⍵),nl
	z	,←⍺(⍺⍺ declv) ⍵
		z}
declv←{		(⊃,/(⊂''),(git ⍺),¨⍺⍺{'*restrict ',⍺,'v=(',⍵,')->v;'}¨⍵),nl}
⍝[cf]
⍝[of]:Iota/Index Generation
iotm←{	chk	←'if(!(rr==0||(rr==1&&1==rs[0])))error(16);'
	siz	←'zr=1;zc=zs[0]=rv[0];'
	exe	←(simd 'present(zv[:zc])'),'DO(i,zs[0])zv[i]=i;'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Shape/Reshape
shpm←{	exe	←'DO(i,rr)zv[i]=rs[i];',nl,pacc'update device(zv[:rr])'
		'' 'zr=1;zs[0]=rr;' exe mxfn ⍺ ⍵}
shpd←{	chk	←'if(1!=lr)error(11);'
	siz	←'zr=ls[0];DO(i,zr)zs[i]=lv[i];'
	exe	←'DO(i,zr)zc*=zs[i];DO(i,rr)rc*=rs[i];',nl
	exe	,←'if(rc==0){',nl,(simd'present(zv)'),'DO(i,zc)zv[i]=0;}',nl
	exe	,←'else{',nl,(simd'present(zv,rv)'),'DO(i,zc)zv[i]=rv[i%rc];}',nl
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Squad Indexing
idxd←{	chk	←'if(lr>1)error(4);if(ls[0]>rr)error(5);'
	chk	,←'DO(i,ls[0])if(lv[i]<0||lv[i]>=rs[i])error(3);'
	siz	←'zr=rr-ls[0];DO(i,zr)zs[i]=rs[ls[0]+i];'
	exe	←'B a,m,k=0;DO(i,zr)zc*=zs[i];m=zc;',nl
	exe	,←'DO(i,ls[0]){a=ls[0]-(i+1);k+=m*lv[a];m*=rs[a];}',nl
	exe	,←(simd''),'DO(i,zc)zv[i]=rv[k+i];'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Bracket Indexing
brid←{	chk	←'if(lr>1)error(16);DO(i,rr)rc*=rs[i];'
	chk	,←'DO(i,rc)if(rv[i]<0||rv[i]>=ls[0])error(3);'
	siz	←'zr=rr;DO(i,zr)zs[i]=rs[i];'
	exe	←(simd''),'DO(i,rc)zv[i]=lv[rv[i]];'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Left/Right
lftm←{	chk siz	←''('zr=rr;DO(i,rr)zs[i]=rs[i];')
	exe	←'DO(i,zr)zc*=zs[i];',nl,(simd'present(zv[:zc],rv[:zc])'),'DO(i,zc)zv[i]=rv[i];'
		chk siz exe mxfn ⍺ ⍵}
rgtm←{	chk siz	←''('zr=rr;DO(i,rr)zs[i]=rs[i];')
	exe	←'DO(i,zr)zc*=zs[i];',nl,(simd'present(zv[:zc],rv[:zc])'),'DO(i,zc)zv[i]=rv[i];'
		chk siz exe mxfn ⍺ ⍵}
lftd←{	chk siz	←''('zr=lr;DO(i,lr)zs[i]=ls[i];')
	exe	←'DO(i,zr)zc*=zs[i];',nl,(simd'present(zv[:zc],lv[:zc])'),'DO(i,zc)zv[i]=lv[i];'
		chk siz exe mxfn ⍺ ⍵}
rgtd←{	chk siz	←''('zr=rr;DO(i,rr)zs[i]=rs[i];')
	exe	←'DO(i,zr)zc*=zs[i];',nl,(simd'present(zv[:zc],rv[:zc])'),'DO(i,zc)zv[i]=rv[i];'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Catenate/Ravel
catm←{	chk	←''
	siz	←'zr=1;DO(i,rr)rc*=rs[i];zs[0]=rc;'
	exe	←(simd''),'DO(i,rc)zv[i]=rv[i];'
		chk siz exe mxfn ⍺ ⍵}
catd←{	chk	←'if(rr!=0&&lr!=0&&abs(rr-lr)>1)error(4);int minr=rr>lr?lr:rr;',nl
	chk	,←'int sr=rr==lr&&lr!=0?lr-1:minr;DO(i,sr)if(rs[i]!=ls[i])error(5);'
	siz	←'zs[0]=1;if(lr>rr){zr=lr;DO(i,lr)zs[i]=ls[i];}',nl
	siz	,←'else{zr=rr;DO(i,rr)zs[i]=rs[i];}',nl
	siz	,←'zr=zr==0?1:zr;zs[zr-1]+=minr==zr?ls[zr-1]:1;'
	exe	←'DO(i,zr)zc*=zs[i];DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
	exe	,←'B li=0,ri=0,zm=zs[zr-1],lm=(lr<rr||lr==0)?1:ls[lr-1];',nl
	exe	,←pacc'update host(lv[:lc],rv[:rc])'
	exe	,←'DO(i,zc)zv[i]=i%zm<lm?lv[li++]:rv[ri++];',nl
	exe	,←pacc'update device(zv[:zc])'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Catenate First Axis/Table
fctm←{	siz	←'zr=2;if(rr==0){zs[0]=1;zs[1]=1;}else{zs[0]=rs[0];'
	siz	,←'I n=rr-1;DO(i,n)rc*=rs[i+1];zs[1]=rc;rc*=rs[0];}'
	exe	←(simd'present(zv[:rc],rv[:rc])'),'DO(i,rc)zv[i]=rv[i];'
		'' siz exe mxfn ⍺ ⍵}
fctd←{	chk	←'if(rr!=0&&lr!=0&&abs(rr-lr)>1)error(4);int minr=rr>lr?lr:rr;',nl
	chk	,←'if(lr==rr&&rr>0){I n=rr-1;DO(i,n)if(rs[i+1]!=ls[i+1])error(5);}',nl
	chk	,←'else if(lr<rr){DO(i,lr)if(ls[i]!=rs[i+1])error(5);}',nl
	chk	,←'else{DO(i,rr)if(ls[i+1]!=rs[i])error(5);}'
	siz	←'zs[0]=1;if(lr>rr){zr=lr;DO(i,lr)zs[i]=ls[i];}',nl
	siz	,←'else{zr=rr;DO(i,rr)zs[i]=rs[i];}',nl
	siz	,←'zr=zr==0?1:zr;zs[0]+=minr==zr?ls[0]:1;'
	exe	←'DO(i,lr)lc*=ls[i];DO(i,rr)rc*=rs[i];',nl
	exe	,←'if(abs(lr-rr)<=1){',nl
	exe	,←(simd''),' DO(i,lc)zv[i]=lv[i];',nl,(simd''),'DO(i,rc)zv[lc+i]=rv[i];'
	exe	,←'}else{I n=zr-1;DO(i,n)zc*=zs[i+1];',nl
	exe	,←' if(lr==0){',nl,(simd''),'DO(i,zc)zv[i]=lv[0];',nl
	exe	,←(simd''),' DO(i,rc)zv[zc+i]=rv[i];}',nl
	exe	,←' else{',nl,(simd''),'DO(i,lc)zv[i]=lv[i];',nl
	exe	,←(simd''),'DO(i,zc)zv[lc+i]=rv[0];}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Reverse/Rotate
rotm←{	exe	←'I n=zr==0?0:zr-1;DO(i,n)zc*=zs[i];rc=rr==0?1:rs[rr-1];lc=zc*rc;',nl
	acc	←'independent collapse(2) present(rv[:lc],zv[:lc])'
	exe	,←(simd acc),'DO(i,zc){DO(j,rc){zv[i*rc+j]=rv[i*rc+(rc-(j+1))];}}'
		''('zr=rr;DO(i,zr)zs[i]=rs[i];')exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Member/Enlist
memm←{	siz	←'DO(i,rr)rc*=rs[i];zr=1;zs[0]=rc;'
	exe	←(simd''),'DO(i,rc)zv[i]=rv[i];'
		'' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Disclose/Pick/First
dscm←{'' 'zr=0;'('DO(i,rr)rc*=rs[i];zv[0]=rc==0?0:rv[0];')mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Rotate First Axis/Reverse First Axis
rtfm←{	exe	←'I n=zr==0?0:zr-1;DO(i,n)zc*=zs[i+1];rc=rr==0?1:rs[0];',nl
	exe	,←simd 'collapse(2) independent present(rv[:rc*zc],zv[:rc*zc])'
	exe	,←'DO(i,rc){DO(j,zc){zv[i*zc+j]=rv[(rc-(i+1))*zc+j];}}'
		''('zr=rr;DO(i,zr)zs[i]=rs[i];')exe mxfn ⍺ ⍵}
rtfd←{	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))error(16);'
	siz	←'zr=rr;DO(i,zr)zs[i]=rs[i];'
	exe	←'zc=rr==0?1:rs[0];I n=rr==0?0:rr-1;DO(i,n)rc*=rs[i+1];',nl
	exe	,←simd'collapse(2) present(zv[:rslt->c],rv[:rgt->c],lv[:lft->c])'
	exe	,←'DO(i,zc){DO(j,rc){zv[(((i-lv[0])%zc)*rc)+j]=rv[(i*rc)+j];}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Equivalent/Match/Depth
eqvm←{	exe	←'zv[0]=rr==0?0:1;',nl,pacc'update device(zv[:1])'
		'' 'zr=0;' exe mxfn ⍺ ⍵}
eqvd←{	chk siz	←'' 'zr=0;'
	exe	←'zv[0]=1;if(rr!=lr)zv[0]=0;',nl
	exe	,←'DO(i,lr){if(!zv[0])break;if(rs[i]!=ls[i]){zv[0]=0;break;}}',nl
	exe	,←'DO(i,lr)lc*=ls[i];',nl
	exe	,←'DO(i,lc){if(!zv[0])break;if(lv[i]!=rv[i]){zv[0]=0;break;}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Not Match/Disequivalent/Tally
nqvm←{	exe	←'zv[0]=rr==0?1:rs[0];',nl,pacc'update device(zv[:1])'
		'' 'zr=0;' exe mxfn ⍺ ⍵}
nqvd←{	chk siz	←'' 'zr=0;'
	exe	←'zv[0]=0;if(rr!=lr)zv[0]=1;',nl
	exe	,←'DO(i,lr){if(zv[0])break;if(rs[i]!=ls[i]){zv[0]=1;break;}}',nl
	exe	,←'DO(i,lr)lc*=ls[i];',nl
	exe	,←'DO(i,lc){if(zv[0])break;if(lv[i]!=rv[i]){zv[0]=1;break;}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Replicate/Filter
fltd←{	chk	←'if(lr>1)error(4);',nl
	chk	,←'if(lr!=0&&ls[0]!=1&&rr!=0&&rs[rr-1]!=1&&ls[0]!=rs[rr-1])error(5);'
	siz	←'zr=rr==0?1:rr;I n=zr-1;DO(i,n)zs[i]=rs[i];',nl
	siz	,←'if(lr==1)lc=ls[0];if(rr!=0)rc=rs[rr-1];zs[zr-1]=0;B last=0;',nl
	siz	,←pacc 'update host(lv[:lc],rv[:rgt->c])'
	siz	,←'if(lc>=rc){DO(i,lc)last+=lv[i];zs[zr-1]=last;}',nl
	siz	,←'else{last+=rc*lv[0];zs[zr-1]=last;}',nl,'DO(i,n)zc*=zs[i];'
	exe	←'B a=0;if(rc==lc){',nl,'DO(i,lc){',nl
⍝[c]	exe	,←' if(lv[i])zv[a++]=rv[i];}}',nl
	exe	,←' if(lv[i]==0)continue;',nl
	exe	,←' else if(lv[i]>0){DO(j,zc){DO(k,lv[j]){zv[(j*zs[zr-1])+a+k]=rv[(j*rc)+i];}}}',nl
	exe	,←' else{DO(j,zc){L n=abs(lv[j]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}}',nl
	exe	,←' a+=lv[i];}}',nl
	exe	,←'else if(rc>lc){',nl
	exe	,←' if(lv[0]>0){'
	exe	,←'DO(i,zc){DO(j,rc){DO(k,lv[0]){zv[(i*zs[zr-1])+a++]=rv[(i*rc)+j];}}}}',nl
	exe	,←' else if(lv[0]<0){L n=zc*zs[zr-1];DO(i,n)zv[i]=0;}}',nl
	exe	,←'else{DO(i,lc){',nl
	exe	,←' if(lv[i]==0)continue;',nl
	exe	,←' else if(lv[i]>0){DO(j,zc){DO(k,lv[j]){zv[(j*zs[zr-1])+a+k]=rv[j*rc];}}}',nl
	exe	,←' else{DO(j,zc){L n=abs(lv[j]);DO(k,n){zv[(j*zs[zr-1])+a+k]=0;}}}',nl
	exe	,←' a+=lv[i];}}',nl,pacc 'update device(zv[:rslt->c])'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Decode/Encode
decd←{	chk	←'if(lr>1||lv[0]<0)error(16);'
	siz	←'zr=rr==0?0:rr-1;DO(i,zr){zs[i]=rs[i+1];zc*=rs[i+1];}',nl
	siz	,←'if(rr>0)rc=rs[0];'
	exe	←'DO(i,zc){zv[i]=0;DO(j,rc){zv[i]=rv[(j*zc)+i]+lv[0]*zv[i];}}'
		chk siz exe mxfn ⍺ ⍵}
encd←{	chk	←'if(lr>1)error(16);DO(i,lr)lc*=ls[i];'
	chk	,←'DO(i,lc){if(lv[i]<=0)error(16);}'
	siz	←'zr=1+rr;zs[0]=lc;DO(i,rr)zs[i+1]=rs[i];'
	exe	←'DO(i,rr)rc*=rs[i];DO(i,rc){DO(j,lc){zv[(j*rc)+i]=(rv[i]>>(lc-(j+1)))%2;}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[l]:Definition for sopid:codfns.dyalog?s=^sopid←
⍝[of]:Take/Drop
drpd←{	chk	←'if(lr!=0&&(lr!=1||ls[0]!=1))error(16);'
	siz	←'zr=rr;DO(i,zr)zs[i]=rs[i];zs[0]-=lv[0];I n=zr-1;DO(i,n)zc*=zs[i+1];'
	exe	←'DO(i,zs[0]){DO(j,zc){zv[(i*zc)+j]=rv[((i+1)*zc)+j];}}'
		chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Transpose
tspm←{	siz	←'zr=rr;DO(i,rr)zs[rr-(1+i)]=rs[i];'
	exe	←'DO(i,rs[0]){DO(j,rs[1]){zv[(j*zs[1])+i]=rv[(i*rs[1])+j];}}'
		'' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[cf]
⍝[of]:Horrible Hacks
sopid←{siz←'zr=(lr-1)+rr;zs[0]=ls[0];DO(i,zr-1)zs[i+1]=rs[i];'
 exe←'zc=zs[0];rc=rs[0];lc=ls[rr-1];B szz=rslt->c,szr=rgt->c,szl=lft->c;',nl
 exe,←simd'independent collapse(3) present(zv[:rslt->c],rv[:rgt->c],lv[:lft->c])'
 exe,←'DO(i,zc){DO(j,rc){DO(k,lc){zv[(i*rc*lc)+(j*lc)+k]=lv[(i*lc)+k]*rv[(j*lc)+k];}}}'
 '' siz exe mxfn ⍺ ⍵}
 
 ⍝ Lamination
  catdo←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ catdr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ catdl ⍵ ⋄ ⍺ catdv ⍵}
  
  catdv←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'A*',⍺,'=',⍵,';'}¨var/⍵),nl
   z,←'B s[]={rgt->s[0],2};'
   z,←'A*orz;A tp;tp.v=NULL;int tpused=0;',nl
   z,←'if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'AI(rslt,2,s,',(⊃git ⊃0⌷⍺),');',nl
   z,←(⊃,/(git ⍺){⍺,'*',⍵,';'}¨'zrl'),nl
   z,←⊃,/'zrl'{⍺,'=',⍵,'->v;',nl}¨'rslt' 'rgt' 'lft'
   z,←(''⊣simd''),'DO(i,s[0]){z[i*2]=l[i];z[i*2+1]=r[i];}'
   z,←'if(tpused){cpaa(orz,rslt);}',nl
   z,'}',nl}
⍝[cf]
rth	←'#include <math.h>',nl,'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
rth	,←'#include <stdio.h>',nl,'#include <string.h>',nl
rth	,←'#ifdef _OPENACC',nl,'#include <accelmath.h>',nl,'#endif',nl
rth	,←'int isinit=0;',nl
rth	,←'#define PI 3.14159265358979323846',nl,'typedef BOUND B;'
rth	,←'typedef long long int L;typedef aplint32 I;typedef double D;typedef void V;',nl
rth	,←'struct array {I r; B s[15];I f;B c;B z;V*v;};',nl,'typedef struct array A;',nl
rth	,←'#define DO(i,n) for(L i=0;i<(n);i++)',nl
rth	,←'V frea(A*a){if (a->v!=NULL){char*v=a->v;B z=a->z;',nl
rth	,←'#ifdef _OPENACC',nl,'#pragma acc exit data delete(v[:z])',nl,'#endif',nl
rth	,←' if(a->f)free(v);}}',nl
rth	,←'V aa(A*a,I s){frea(a);B c=1;DO(i,a->r)c*=a->s[i];B z=s*c;',nl
rth	,←' char*v=malloc(z);if(NULL==v)error(1);',nl
rth	,←'#ifdef _OPENACC',nl,'#pragma acc enter data create(v[:z])',nl,'#endif',nl
rth	,←' a->v=v;a->z=z;a->c=c;a->f=1;}',nl
rth	,←'#define AA(a,s) aa((a),sizeof(s))',nl
rth	,←'V ai(A*a,I r,B *s,I sz){a->r=r;DO(i,r)a->s[i]=s[i];aa(a,sz);}',nl
rth	,←'#define AI(a,r,s,sz) ai((a),(r),(s),sizeof(sz))',nl
rth	,←'V fe(A*e,I c){DO(i,c){frea(&e[i]);}}',nl
rth	,←'V cpad(LOCALP*d,A*a,I t){getarray(t,a->r,a->s,d);',nl
rth	,←'#ifdef _OPENACC',nl,'char *v=a->v;B z=a->z;',nl
rth	,←'#pragma acc update host(v[:z])',nl,'#endif',nl
rth	,←' memcpy(ARRAYSTART(d->p),a->v,a->z);}',nl
rth	,←'V cpda(A*a,LOCALP*d){frea(a);',nl
rth	,←' I r=a->r=d->p->RANK;B c=1;DO(i,r){c*=a->s[i]=d->p->SHAPETC[i];};a->c=c;',nl
rth	,←' switch(d->p->ELTYPE){',nl
rth	,←'  case APLLONG:a->z=c*sizeof(I);a->f=0;a->v=ARRAYSTART(d->p);break;',nl
rth	,←'  case APLDOUB:a->z=c*sizeof(D);a->f=0;a->v=ARRAYSTART(d->p);break;',nl
rth	,←'  case APLINTG:a->z=c*sizeof(I);a->f=1;',nl
rth	,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth	,←'   {aplint16 *restrict s=ARRAYSTART(d->p);I *restrict t=a->v;',nl
rth	,←'   DO(i,c)t[i]=s[i];};break;',nl
rth	,←'  case APLSINT:a->z=c*sizeof(I);a->f=1;',nl
rth	,←'   a->v=malloc(a->z);if(a->v==NULL)error(1);',nl
rth	,←'   {aplint8 *restrict s=ARRAYSTART(d->p);I *restrict t=a->v;',nl
rth	,←'   DO(i,c)t[i]=s[i];};break;',nl
rth	,←'  default:error(16);}',nl
rth	,←' #ifdef _OPENACC',nl,' char *vc=a->v;B z=a->z;',nl
rth	,←' #pragma acc enter data copyin(vc[:z])',nl,' #endif',nl,'}',nl
rth	,←'V cpaa(A*t,A*s){frea(t);memcpy(t,s,sizeof(A));}',nl
⍝[cf]
:EndNamespace
