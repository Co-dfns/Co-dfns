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
cfs	←'-funsigned-bitfields -funsigned-char -fvisibility=hidden '
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
pop	←'-DHASACC -fastsse -acc -ta=tesla:cuda7.5 -Minfo=ccff -fPIC -shared '
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
⍝[of]:Primitive Type Definitions
⍝[of]:Basic Type Definitions
⍝[c]Type:	Index	Right	Left		Type Codes:	Value	Type
⍝[c]	0	Unknown	Unknown			Unknown	0
⍝[c]	1	Unknown	Integer			Integer	1
⍝[c]	2	Unknown	Float			Float	2
⍝[c]	3	Unknown	Not bound			Not bound	3
⍝[c]	4	Integer	Unknown
⍝[c]	5	Integer	Integer
⍝[c]	6	Integer	Float
⍝[c]	7	Integer	Not bound
⍝[c]	8	Float	Unknown
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
pn,←⊂,'¨'	⋄ pt⍪←pft	1	2	¯2	¯2	¯2	¯2
pn,←⊂,'.'	⋄ pt⍪←pft	¯2	¯2	1	1	2	2
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
pn,←⊂,'⍨'	⋄ pt⍪←pft	1	2	¯2	¯2	¯2	¯2
pn,←⊂,'/'	⋄ pt⍪←pft	1	2	1	¯11	2	¯11
pn,←⊂,'⌿'	⋄ pt⍪←pft	1	2	1	¯11	2	¯11
pn,←⊂,'\'	⋄ pt⍪←pft	1	2	¯11	¯11	¯11	¯11
pn,←⊂,'⍀'	⋄ pt⍪←pft	1	2	¯11	¯11	¯11	¯11
pn,←⊂'//'	⋄ pt⍪←pft	¯2	¯2	1	¯11	2	¯11
pn,←⊂,'⍉'	⋄ pt⍪←pft	1	2	¯16	¯16	¯16	¯16
pn,←⊂,'↑'	⋄ pt⍪←pft	¯16	¯16	1	¯11	2	¯11
pn,←⊂,'↓'	⋄ pt⍪←pft	¯16	¯16	1	¯11	2	¯11
pn,←⊂,'⊤'	⋄ pt⍪←pft	¯2	¯2	1	¯16	¯16	¯16
pn,←⊂,'⊥'	⋄ pt⍪←pft	¯2	¯2	1	¯16	¯16	¯16
pn,←⊂'∘.'	⋄ pt⍪←pft	¯2	¯2	1	1	2	2
pn,←⊂'.'	⋄ pt⍪←pft	¯2	¯2	1	2	1	2
pn,←⊂'⎕sp'	⋄ pt⍪←pft	¯2	¯2	1	11	11	¯11
pn,←⊂'⎕XOR'	⋄ pt⍪←pft	¯2	¯2	1	¯16	¯16	¯16
⍝[c]Name	RL:	IN	FN	II	IF	FI	FF
⍝[c]
⍝[cf]
⍝[of]:Operator Type Indirects
⍝[c]Convert Operand Types based on Calling Pattern of Operator
⍝[c]
⍝[c]Conversion Maps:	Operator called with X type → Operand type is found at Y
⍝[c]
otn←⍬      ⋄ oti←0 2 12⍴⍬
⍝[c]
⍝[c]Name	R:	IN	FN	II	IF	FI	FF
⍝[c]	L:	IN	FN	II	IF	FI	FF
otn,←⊂,'/'	⋄ _←pft	5	10	5	5	10	10
	oti⍪←⍉_,⍪pft	15	15	13	14	13	14
otn,←⊂,'⌿'	⋄ _←pft	5	10	5	5	10	10
	oti⍪←⍉_,⍪pft	15	15	13	14	13	14
otn,←⊂,'\'	⋄ _←pft	5	10	5	5	10	10
	oti⍪←⍉_,⍪pft	15	15	13	14	13	14
otn,←⊂,'⍀'	⋄ _←pft	5	10	5	5	10	10
	oti⍪←⍉_,⍪pft	15	15	13	14	13	14
otn,←⊂'∘.'	⋄ _←pft	5	10	5	6	9	10
	oti⍪←⍉_,⍪pft	15	15	13	14	13	14
⍝[c]otn,←⊂'.'	⋄ _←pft	
	_←pft	7	11	5	6	9	10
	oti⍪←⍉_,⍪pft	7	11	5	6	9	10
⍝[cf]
⍝[cf]
lta	←(1↓¨(⊂⊢),∘⊂(12⍴1+(≢∘⌊⍨⊃∘⊃))⍤0)∘(0,∘∪(0≡∘⊃0⍴⊢)¨(⌿∘⊢)⊢)∘(⊃,/)∘v Es⍪Os
ltd	←12⌊1 3 4⊥(((∨⌿¯1=×)⍪|)(oti⌷⍨otn⍳∘⊂⊣)(⊃¨∘⊂⍤1)(2 4⍴⍳4),⍨2↑⊢)
ltt	←(⊃∘⌽∘⊃v)(⊢⍪⍨ltd⌷⍤0 1∘,(⌊/∘,2↑⊢),⍨¯1↑⊢)(1⊃⊣)⌷⍤0 2⍨(0⊃⊣)⍳∘⊃v
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
tde	←((¯3↓⊢),(⊂(5 6 7 9 10 11⌷⍨⊣)⌷∘⍉∘⊃y),¯2↑⊢)⍤1
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
fft	←(,1↑⊢)(1 'Z',(2↓¯4↓⊣),n,y,(⊂2↑∘,1↑∘⍉∘⊃e),l)(¯1↑⊢)
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
O1	←{(n⍵),odb(o ocl)⊂f⊣f u o	←⊃v⍵}
O2	←{(⊃n⍵)('Fexdm();',nl)('ptrd')}
O0	←{'' '' ''}
Of	←{fre,(⊃n⍵),elp,'{',nl,foi,tps,(⊃,/(⍳6)case¨⊂⊃⊃v⍵),'}',nl,fcln,'}',nl,nl}
Fd	←{frt,(⊃n⍵),flp,';',nl}
Fe	←{frt,(⊃n⍵),flp,'{',nl,'error(',(⍕|⊃⊃y⍵),');',nl}
F0	←{frt,(⊃n⍵),flp,'{',nl,'LOCALP *env[]={tenv};',nl,'tenv'reg ⍵}
F1	←{frt,(⊃n⍵),flp,'{',nl,('env0'dnv ⍵),(fnv ⍵),'env0'reg ⍵}
Z0	←{'}',nl,nl}
Z1	←{'z->p=zap((',((⊃n⍵)var⊃e⍵),')->p);',cutp,nl,'}',nl,nl}
Ze	←{'}',nl,nl}
M0	←{rth,('tenv'dnv ⍵),nl,'LOCALP *env[]={',((0≡⊃⍵)⊃'tenv' 'NULL'),'};',nl}
S0	←{(('{',rk0,srk,('prk'do'cnt*=sp[i];'),spp,sfv,slp)⍵)}
Y0	←{⊃,/((⍳≢⊃v⍵)((⊣sts¨∘⊃y),'}',nl,⊣ste¨(⊃v)var¨∘⊃e)⍵),'gerp(&p0);}',nl}
⍝[cf]
⍝[of]:Runtime Code
⍝[of]:Runtime Utilities
var	←{(,'⍺')≡⍺:,'l' ⋄ (,'⍵')≡⍺:,'r' ⋄ ¯1=⊃⍵:,⍺ ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
nl	←⎕UCS 13 10
for	←{'for(i=0;i<',(⍕⍵),';i++){'}
do	←{'{BOUND i,_n=',(⍕⍺),';',(for'_n'),⍵,'}}',nl}
pdo	←{p←((⊂2↑COMPILER)∊'ic' 'pg')⊃''('#pragma simd',nl)
	'{BOUND i;',nl,p,(for ⍺),⍵,'}}',nl}
tl	←{('di'⍳⍵)⊃¨⊂('APLDOUB' 'double')('APLLONG' 'aplint32')}
enc	←⊂⊣,∘⊃((⊣,'_',⊢)/(⊂''),(⍕¨(0≠⊢)(/∘⊢)⊢))
fvs	←,⍤0(⌿⍨)0≠(≢∘⍴¨⊣)
cln	←'¯'⎕R'-'
dnv	←{(0≡z)⊃('LOCALP ',⍺,'[',(⍕z←⊃v⍵),'];')('LOCALP*',⍺,'=NULL;')}
reg	←{(⊃v⍵)do'regp(&',⍺,'[i]);'}
cutp	←'cutp(&env0[0]);'
frt	←'static void ' ⋄ fre←'void EXPORT '
flp	←'(LOCALP*z,LOCALP*l,LOCALP*r,LOCALP*penv[])'
elp	←'(LOCALP*z,LOCALP*l,LOCALP*r)'
foi	←'if(!isinit){Init(NULL,NULL,NULL,NULL);isinit=1;}',nl
fnv	←{'LOCALP*env[]={',(⊃,/(⊂'env0'),{',penv[',(⍕⍵),']'}¨⍳⊃s ⍵),'};',nl}
⍝[cf]
⍝[of]:Scalar Primitives
⍝ respos←'⍵ % ⍺'
respos	←'fmod((double)⍵,(double)⍺)'
resneg	←'⍵-⍺*floor(((double)⍵)/(double)(⍺+(0==⍺)))'
residue	←'(0<=⍺&&0<=⍵)?',respos,':',resneg

sdb←0 3⍴⊂'' ⋄ scl←{cln ((≢⍵)↑,¨'⍵⍺')⎕R(⍕¨⍵) ⊃⍺⌷⍨((⊂⍺⍺)⍳⍨0⌷⍉⍺),≢⍵}
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
smcd	←{'copyin(',(⊃{⍺,',',⍵}/{'d',(⍕⍵),'[0:mz',(⍕⍵),']'}¨⍳≢⍵),')'}
smcr	←{'copyout(',(⊃{⍺,',',⍵}/{'r',(⍕⍵),'[0:cnt]'}¨⍳≢⍵),')'}
simc	←{(smcd(⊃v⍵)fvs(⊃e⍵)),' ',(smcr⊃n⍵),nl}
prag	←{('#pragma acc parallel loop ',simc ⍵)('#pragma simd',nl)('')}
simd	←{('pg' 'ic'⍳⊂2↑COMPILER)⊃prag ⍵}
slp	←{(simd ⍵),(for'cnt'),nl,⊃,/(git 1⌷⍉(⊃v⍵)fvs(⊃y⍵))sip¨⍳≢(⊃v⍵)fvs(⊃e⍵)}
cnvc	←{cs st←⍺ ⋄ z←'case ',cs,':{PP p=getarray(APLLONG,0,NULL,NULL);',nl
	z,←st,'*ss=ARRAYSTART(',⍵,'.p);aplint32*bs=ARRAYSTART(p);*bs=*ss;',nl
	z,←'relp(&',⍵,');',⍵,'.p=p;};break;',nl ⋄ z}
cnvs	←{z←'if(',⍵,'.p->RANK==0){',nl
	z,←'switch(',⍵,'.p->ELTYPE){case APLLONG:case APLDOUB:break;',nl
	z,←⊃,/('APLINTG' 'aplint16')('APLSINT' 'aplint8')cnvc¨⊂⍵
	z,←'default:error(16);}}',nl ⋄ z}
tps	←'LOCALP cl,cr;regp(&cr);cr.p=ref(r->p);',(cnvs'cr')
tps	,←'if(l!=NULL){regp(&cl);cl.p=ref(l->p);',(cnvs'cl'),'}',nl
tps	,←'int tp=0;switch(cr.p->ELTYPE){case APLLONG:break;',nl
tps	,←'case APLDOUB:tp=3;break;',nl,'default:error(16);}',nl
tps	,←'if(l==NULL)tp+=2;',nl
tps	,←'else switch(cl.p->ELTYPE){case APLLONG:break;',nl
tps	,←'case APLDOUB:tp+=1;break;',nl,'default:error(16);}',nl
tps	,←'switch(tp){',nl
tpi	←'ii' 'if' 'in' 'fi' 'ff' 'fn'
fcln	←'cutp(&cr);',nl
case	←{'case ',(⍕⍺),':',⍵,(⍺⊃tpi),'(z,&cl,&cr,env);break;',nl}
rk0	←'unsigned prk=0;BOUND sp[15];BOUND cnt=1,i=0;',nl
rk1	←'if(prk!=(' ⋄ rk2←')->p->RANK){if(prk==0){',nl
rsp	←{'prk=(',⍵,')->p->RANK;',nl,'prk'do'sp[i]=(',⍵,')->p->SHAPETC[i];'}
rk3	←'}else if((' ⋄ rk4←')->p->RANK!=0)error(4);',nl
spt	←{'if(sp[i]!=(',⍵,')->p->SHAPETC[i])error(4);'}
rkv	←{rk1,⍵,rk2,(rsp ⍵),rk3,⍵,rk4,'}else{',nl,('prk'do spt ⍵),'}',nl}
rk5	←'if(prk!=1){if(prk==0){prk=1;sp[0]='
rka	←{rk5,l,';}else error(4);}else if(sp[0]!=',(l←⍕≢⍵),')error(4);',nl}
crk	←{⍵((⊃,/)((rkv¨var/)⊣(⌿⍨)(~⊢)),(rka¨0⌷∘⍉(⌿⍨)))0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵}
srk	←{crk(⊃v⍵)(,⍤0(⌿⍨)0≠(≢∘⍴¨⊣))(⊃e⍵)}
ste	←{'relp(',⍵,');(',⍵,')->p=zap(p',(⍕⍺),'.p);',nl}
sts	←{'r',(⍕⍺),'[i]=s',(⍕⍵),';',nl}
rkp1	←{'BOUND m',(⍕⍺),'=(',(⍕⍵),')->p->RANK==0?0:1;',nl}
rkp2	←{''('BOUND mz',(⍕⍺),'=(',(⍕⍵),')->p->RANK==0?1:cnt;',nl)}
rkp	←{(⍺ rkp1 ⍵),('pg'≡2↑COMPILER)⊃⍺ rkp2 ⍵}
git	←{⍵⊃¨⊂'/* XXX */ aplint32 ' 'aplint32 ' 'double ' '?type? '}
gie	←{⍵⊃¨⊂'/* XXX */ APLLONG' 'APLLONG' 'APLDOUB' 'APLNA'}
gdp	←{'*d',(⍕⍺),'=ARRAYSTART((',⍵,')->p);',nl}
gda1	←{'d',(⍕⍺),'[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl}
gdm	←{'BOUND m',(⍕⍺),'=',(⍕0≢≢⍵),';',nl}
gda2	←{''('BOUND mz',(⍕⍺),'=cnt;',nl)}
gda	←{(⍺ gda1 ⍵),(⍺ gdm ⍵),('pg'≡2↑COMPILER)⊃⍺ gda2 ⍵}
sfa	←{(git m/⍺),¨{((+/~m)+⍳≢⍵)gda¨⍵}⊣/(m←0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfp	←{(git m⌿⍺),¨{(⍳≢⍵)(gdp,rkp)¨⍵}var/(m←~0=(⊃0⍴∘⊂⊃)¨0⌷⍉⍵)⌿⍵}
sfv	←(1⌷∘⍉(⊃v)fvs(⊃y))((⊃,/)sfp,sfa)(⊃v)fvs(⊃e)
ack	←{'getarray(',(⊃gie ⍺⌷⍺⍺),',prk,sp,&p',(⍕⍺),');',nl}
gpp	←{⊃,/{'LOCALP p',(⍕⍵),';regp(&p',(⍕⍵),');',nl}¨⍳≢⍵}
grs	←{(⊃git ⍺),'*r',(⍕⍵),'=ARRAYSTART(p',(⍕⍵),'.p);',nl}
spp	←(⊃s){(gpp⍵),(⊃,/(⍳≢⍵)(⍺ ack)¨⍵),(⊃,/⍺ grs¨⍳≢⍵)}(⊃n)var¨(⊃r)
sip	←{⍺,'f',⍵,'=d',⍵,'[i*m',⍵,'];',nl}∘⍕
⍝[cf]
⍝[cf]
⍝[of]:Primitive Operators
odb←0 3⍴⊂'' ⋄ ocl←{⍵∘{'(',(opl ⍺),⍵,' ⍵⍵)'}¨1↓⍺⌷⍨(0⌷⍉⍺)⍳⊂⍺⍺}
opl←{⊃,/{'(,''',⍵,''')'}¨⍵}
⍝[c]
⍝[c]Prim	Monadic	Dyadic
odb⍪←,¨'⍨'	'comm'	'comd'
odb⍪←,¨'¨'	'eacm'	'eacd'
odb⍪←,¨'/'	'redm'	'redd'
odb⍪←,¨'⌿'	'rd1m'	'rd1d'
odb⍪←,¨'\'	'scnm'	'{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 16}'
odb⍪←,¨'⍀'	'sc1m'	'{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 16}'
odb⍪←'∘.'	'{_←⍺⍺ ⍵⍵ ⋄ ⎕SIGNAL 99}'	'oupd'

⍝[of]:Scalar/Mixed Function Conversion
mxsm←{siz←'zr=rr;','zr'do'zc*=rs[i];zs[i]=rs[i];'
 exe←'zc'pdo'zv[i]=',(,'⍵')⎕R'rv[i]'⊢⍺⍺,';' ⋄ '' siz exe mxfn ⍺ ⍵}
mxsd←{chk←'if(lr==rr){',('lr'do'if(rs[i]!=ls[i])error(5);'),'}'
 chk,←'else if(lr!=0&&rr!=0){error(4);}' ⋄ siz←'if(rr==0){zr=lr;'
 siz,←('lr'do'zc*=ls[i];lc*=ls[i];zs[i]=ls[i];'),'}else{zr=rr;'
 siz,←('rr'do'zc*=rs[i];rc*=rs[i];zs[i]=rs[i];'),('lr'do'lc*=ls[i];'),'}'
 exe←'zc'pdo'zv[i]=',(,¨'⍺⍵')⎕R'lv[i\%lc]' 'rv[i\%rc]'⊢⍺⍺,';'
 chk siz exe mxfn ⍺ ⍵}
scmx←{(⊂⍺⍺)∊0⌷⍉sdb:(⊃⍵),'=',';',⍨sdb(⍺⍺ scl)1↓⍵ ⋄ ⍺(⍺⍺ fcl ⍵⍵)⍵,⍤0⊢⊂2⍴¯1}
sdbm←(0⌷⍉sdb),'mxsm' 'mxsd'{'(''',⍵,'''',⍺,')'}¨⍤1⊢⍉1↓⍉sdb
⍝[cf]
⍝[of]:Commute
comd←{((1↑⍺)⍪⊖1↓⍺)(⍺⍺ fcl(⍵⍵⍪sdbm))(1↑⍵)⍪⊖1↓⍵}
comm←{((1↑⍺)⍪⍪⍨1↓⍺)(⍺⍺ fcl(⍵⍵⍪sdbm))(1↑⍵)⍪⍪⍨1↓⍵}
⍝[cf]
⍝[of]:Each
eacm←{siz←'zr=rr;','zr'do'zc*=rs[i];zs[i]=rs[i];'
 exe←'zc'do ⍺(⍺⍺ scmx ⍵⍵)'zv[i]' 'rv[i]' ⋄ '' siz exe mxfn ⍺ ⍵}
eacd←{chk←'if(lr==rr){',('lr'do'if(rs[i]!=ls[i])error(5);'),'}'
 chk,←'else if(lr!=0&&rr!=0){error(4);}' ⋄ siz←'if(rr==0){zr=lr;'
 siz,←('lr'do'zc*=ls[i];lc*=ls[i];zs[i]=ls[i];'),'}else{zr=rr;'
 siz,←('rr'do'zc*=rs[i];rc*=rs[i];zs[i]=rs[i];'),('lr'do'lc*=ls[i];'),'}'
 exe←'zc'do ⍺(⍺⍺ scmx ⍵⍵)'zv[i]' 'rv[i]' 'lv[i]' ⋄ chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce
redm←{idf←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖' ⋄ hid←idf∊⍨⊃⍺⍺
 idv←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
 chk←hid⊃('if(rr>0&&rs[rr-1]==0)error(11);')'' ⋄ siz←'if(rr==0){zr=0;}',nl
 siz,←'else{zr=rr-1;',('zr'do'zc*=rs[i];zs[i]=rs[i];'),'rc=rs[zr];}'
 exe←'if(rc==1){',('zc'do'zv[i]=rv[i];'),'}else '
 exe,←hid⊃''('if(rc==0){',('zc'do'zv[i]=',';',⍨idv⊃⍨idf⍳⊃⍺⍺),'}else ')
 bod←'rc-1'do ((⊃⍺),⍺)(⍺⍺ scmx ⍵⍵)'zv[j]' 'zv[j]' 'rv[(j*rc)+(rc-(2+i))]'
 exe,←'{',('zc'do'BOUND j=i;zv[j]=rv[(j*rc)+(rc-1)];',bod),'}'
 chk siz exe mxfn ⍺ ⍵}
redd←{idf←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖' ⋄ hid←idf∊⍨⊃⍺⍺ ⋄ a←0 1 1⊃¨⊂⍺
 idv←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
 chk←'if(lr!=0&&(lr!=1||ls[0]!=1))error(5);',nl
 chk,←'if(rr==0)error(4);',nl,hid⊃('if(lv[0]==0)error(11);',nl)''
 chk,←'if((rs[rr-1]+1)<lv[0])error(5);rc=(1+rs[rr-1])-lv[0];'
 siz←'zr=rr;',('zr-1'do'zc*=rs[i];zs[i]=rs[i];'),'zs[zr-1]=rc;lc=rs[rr-1];'
 vl1←'zv[(j*rc)+k]' 'zv[(j*rc)+k]' 'rv[(j*lc)+k+(lv[0]-(i+1))]' 
 xi1←'zv[(j*rc)+k]=',';',⍨idv⊃⍨idf⍳⊃⍺⍺
 ex1←'zc'do'BOUND j=i;','rc'do'BOUND k=i;',xi1,'lv[0]'do a(⍺⍺ scmx ⍵⍵)vl1
 vl2←'zv[(j*rc)+k]' 'zv[(j*rc)+k]' 'rv[(j*lc)+k+(lv[0]-(i+2))]'
 xi2←'zv[(j*rc)+k]=rv[(j*lc)+k+lv[0]-1];'
 ex2←'zc'do'BOUND j=i;','rc'do'BOUND k=i;',xi2,'lv[0]-1'do a(⍺⍺ scmx ⍵⍵)vl2
 chk siz (hid⊃ex2 ex1) mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Reduce First Axis
rd1m←{idf←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖' ⋄ hid←idf∊⍨⊃⍺⍺
 idv←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
 chk←hid⊃('if(rr>0&&rs[0]==0)error(11);')'' ⋄ siz←'if(rr==0){zr=0;}',nl
 siz,←'else{zr=rr-1;',('zr'do'zc*=rs[i+1];zs[i]=rs[i+1];'),'rc=rs[0];}'
 exe←'if(rc==1){',('zc'do'zv[i]=rv[i];'),'}else '
 exe,←hid⊃''('if(rc==0){',('zc'do'zv[i]=',';',⍨idv⊃⍨idf⍳⊃⍺⍺),'}else ')
 bod←'rc-1'do ((⊃⍺),⍺)(⍺⍺ scmx ⍵⍵)'zv[j]' 'zv[j]' 'rv[(zc*(rc-(i+2)))+j]'
 exe,←'{',('zc'do'BOUND j=i;zv[j]=rv[((rc-1)*zc)+j];',bod),'}'
 chk siz exe mxfn ⍺ ⍵}
rd1d←{idf←'+-×÷|⌊⌈*!∧∨<≤=>≥≠⊤∪/⌿\⍀⌽⊖' ⋄ hid←idf∊⍨⊃⍺⍺ ⋄ a←0 1 1⊃¨⊂⍺
 idv←⍕¨0 0 1 1 0 '1.7e308' '-1.7e308' 1 1 1 0 0 1 1 0 1 0 0 '-1' 1 1 1 1 0 0 ''
 chk←'if(lr!=0&&(lr!=1||ls[0]!=1))error(5);',nl
 chk,←'if(rr==0)error(4);',nl,hid⊃('if(lv[0]==0)error(11);',nl)''
 chk,←'if((rs[0]+1)<lv[0])error(5);rc=(1+rs[0])-lv[0];'
 siz←'zr=rr;',('zr-1'do'zc*=rs[i+1];zs[i+1]=rs[i+1];'),'zs[0]=rc;'
 vl1←'zv[(k*zc)+j]' 'zv[(k*zc)+j]' 'rv[((k+(lv[0]-(i+1)))*zc)+j]'
 xi1←'zv[(k*zc)+j]=',';',⍨idv⊃⍨idf⍳⊃⍺⍺
 ex1←'zc'do'BOUND j=i;','rc'do'BOUND k=i;',xi1,'lv[0]'do a(⍺⍺ scmx ⍵⍵)vl1
 vl2←'zv[(k*zc)+j]' 'zv[(k*zc)+j]' 'rv[((k+(lv[0]-(i+2)))*zc)+j]'
 xi2←'zv[(k*zc)+j]=rv[((k+lv[0]-1)*zc)+j];'
 ex2←'zc'do'BOUND j=i;','rc'do'BOUND k=i;',xi2,'lv[0]-1'do a(⍺⍺ scmx ⍵⍵)vl2
 chk siz (hid⊃ex2 ex1) mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Scan
scnm←{siz←'zr=rr;rc=rr==0?1:rs[rr-1];','zr'do'zs[i]=rs[i];'
 siz,←'zr==0?0:zr-1'do'zc*=rs[i];'
 val←'zv[(j*rc)+i+1]' 'zv[(j*rc)+i]' 'rv[(j*rc)+i+1]'
 lup←'rc-1'do((⊃⍺),⍺)(⍺⍺ scmx ⍵⍵)val
 exe←'if(rc!=0){',('zc'do'BOUND j=i;zv[j*rc]=rv[j*rc];',lup),'}'
 '' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Scan First Axis
sc1m←{siz←'zr=rr;rc=rr==0?1:rs[0];','zr'do'zs[i]=rs[i];'
 siz,←'zr==0?0:zr-1'do'zc*=rs[i+1];'
 exe←'if(rc!=0){','zc'do'zv[i]=rv[i];'
 val←'zv[((i+1)*zc)+j]' 'zv[(i*zc)+j]' 'rv[((i+1)*zc)+j]'
 exe,←('zc'do'BOUND j=i;','rc-1'do((⊃⍺),⍺)(⍺⍺ scmx ⍵⍵)val),'}'
 '' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Outer Product
oupd←{siz←'zr=lr+rr;',('lr'do'zs[i]=ls[i];'),'rr'do'zs[i+lr]=rs[i];'
 exe←('lr'do'lc*=ls[i];'),('rr'do'rc*=rs[i];')
 exe,←'lc'do'BOUND j=i;','rc'do ⍺(⍺⍺ scmx ⍵⍵)'zv[(j*rc)+i]' 'rv[i]' 'lv[j]'
 '' siz exe mxfn ⍺ ⍵}
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
calm←{z r←var/⍵ ⋄ arr←⍺⍺,((1⌷⍺)⊃'iif'),'n(',z,',NULL,',r,',env);',nl
 scl←'{LOCALP sz,sr;regp(&sz);regp(&sr);',nl
 scl,←(⊃,/(gie ⍺){'getarray(',⍺,',0,NULL,&s',⍵,');'}¨'zr'),nl
 scl,←(1⊃git ⍺),'*srv=ARRAYSTART(sr.p);*srv=',r,';',nl
 scl,←⍺⍺,((1⌷⍺)⊃'iif'),'n(&sz,NULL,&sr,env);',nl
 scl,←(⊃git ⍺),'*szv=ARRAYSTART(sz.p);',z,'=*szv;cutp(&sz);}',nl
 (∧/¯1=,↑1⌷⍉⍵)⊃arr scl}
cald←{z r l←var/⍵ ⋄ arr←⍺⍺,((¯2↑⍺)⊃¨⊂'iif'),'(',z,',',l,',',r,',env);',nl
 scl←'{LOCALP sz,sr,sl;regp(&sz);regp(&sr);regp(&sl);',nl
 scl,←(⊃,/(gie ⍺){'getarray(',⍺,',0,NULL,&s',⍵,');'}¨'zrl'),nl
 scl,←(⊃,/(git ¯2↑⍺){⍺,'*s',⍵,'v=ARRAYSTART(s',⍵,'.p);'}¨'rl'),nl
 scl,←(⊃,/'rl'{'*s',⍺,'v=',⍵,';'}¨r l),nl
 scl,←⍺⍺,((¯2↑⍺)⊃¨⊂'iif'),'(&sz,&sl,&sr,env);',nl
 scl,←(⊃git ⍺),'*szv=ARRAYSTART(sz.p);',z,'=*szv;cutp(&sz);}',nl
 (∧/¯1=,↑1⌷⍉⍵)⊃arr scl}
mxfn←{chk siz exe←⍺ ⋄ tp el←⍵ ⋄ vr←(∧/¯1=↑1⌷⍉el)+0≠(⊃0⍴⊃)¨0⌷⍉el
 tpv←(1=vr)/tp ⋄ tpl←(0=vr)/tp ⋄ tps←(2=vr)/tp
 elv←(1=vr)/(≢el)↑'rslt' 'rgt' 'lft' ⋄ ell←(0=vr)/0⌷⍉el ⋄ els←(2=vr)/0⌷⍉el
 nmv←(1=vr)/(≢el)↑'zrl' ⋄ nml←(0=vr)/(≢el)↑'zrl' ⋄ nms←(2=vr)/(≢el)↑'zrl'
 z←'{BOUND zc=1,rc=1,lc=1;LOCALP*orz;LOCALP tp;tp.p=NULL;int tpu=0;',nl
 z,←(⊃,/(⊂''),elv{'LOCALP *',⍺,'=',⍵,';'}¨var/(1=vr)⌿el),nl
 z,←⊃,/(⊂''),nml{'unsigned ',⍺,'r=1;BOUND ',⍺,'s[]={',(⍕≢⍵),'};'}¨ell
 z,←⊃,/(⊂''),(git tpl),¨nml{⍺,'v[]={',(⊃{⍺,',',⍵}/⍕¨⍵),'};',nl}¨ell
 z,←(⊃,/(⊂''),(git tps),¨nms{'*s',⍺,'=&',⍵,';'}¨els),nl
 z,←(⊃,/(⊂''),{'unsigned ',⍵,'r=0;BOUND*',⍵,'s=NULL;'}¨nms),nl
 z,←(⊃,/(⊂''),(git tps){⍺,⍵,'v[]={*s',⍵,'};'}¨nms),nl
 z,←'if(',(⊃{⍺,'||',⍵}/(⊂'0'),'rslt=='∘,¨1↓elv),')'
 z,←'{orz=rslt;rslt=&tp;regp(rslt);tpu=1;}',nl
 z,←(0≡≢elv)⊃'' 'LOCALP*rslt=&tp;'
 tpv nmv elv,←(0≡≢elv)⊃(3⍴⊂⍬)((⊃tps)'z' 'rslt')
 z,←'{',((1↓tpv)((1↓nmv)decl)1↓elv),'unsigned zr;BOUND zs[15];',nl
 z,←chk,nl,siz,nl,'relp(rslt);getarray(',(⊃gie ⊃0⌷tp),',zr,zs,rslt);}',nl
 z,←'{',(tpv(nmv decl)elv),exe,nl,((0≡≢elv)⊃'' '*sz=zv[0];relp(rslt);'),'}',nl
 z,←'if(tpu){relp(orz);orz->p=zap(rslt->p);gerp(rslt);}',nl,'}',nl
 z}
decl←{z←(⊃,/(⊂''),⍺⍺{'unsigned ',⍺,'r=',⍵,'->p->RANK;'}¨⍵),nl
 z,←(⊃,/(⊂''),⍺⍺{'BOUND*',⍺,'s=',⍵,'->p->SHAPETC;'}¨⍵),nl
 z,←(⊃,/(⊂''),(git ⍺),¨⍺⍺{'*',⍺,'v=ARRAYSTART(',⍵,'->p);'}¨⍵),nl
 z}
⍝[cf]
⍝[of]:Iota/Index Generation
iotm←{chk←'if(!(rr==0||(rr==1&&1==rs[0])))error(16);'
  siz←'zr=1;zs[0]=rv[0];' ⋄ exe←'zs[0]'do'zv[i]=i;' ⋄ chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Shape/Reshape
shpm←{'' 'zr=1;zs[0]=rr;'('rr'do'zv[i]=rs[i];')mxfn ⍺ ⍵}
shpd←{chk←'if(1!=lr)error(11);' ⋄ siz←'zr=ls[0];','zr'do'zs[i]=lv[i];'
 exe←('zr'do'zc*=zs[i];'),('rr'do'rc*=rs[i];')
 exe,←'if(rc==0){',('zc'pdo'zv[i]=0;'),'}',nl
 exe,←'else{',('zc'pdo'zv[i]=rv[i%rc];'),'}',nl
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Squad Indexing
idxd←{chk←'if(lr>1)error(4);if(ls[0]>rr)error(5);'
 chk,←'ls[0]'do'if(lv[i]<0||lv[i]>=rs[i])error(3);'
 siz←'zr=rr-ls[0];','zr'do'zs[i]=rs[ls[0]+i];'
 exe←'BOUND a,m,k=0;',('zr'do'zc*=zs[i];'),'m=zc;',nl
 exe,←('ls[0]'do'a=ls[0]-(i+1);k+=m*lv[a];m*=rs[a];'),'zc'pdo'zv[i]=rv[k+i];'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Bracket Indexing
brid←{chk←'if(lr>1)error(16);','rr'do'rc*=rs[i];'
 chk,←'rc'do'if(rv[i]<0||rv[i]>=ls[0])error(3);'
 siz←'zr=rr;','zr'do'zs[i]=rs[i];' ⋄ exe←'rc'pdo'zv[i]=lv[rv[i]];'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Left/Right
lftm←{chk siz←''('zr=rr;','rr'do'zs[i]=rs[i];')
 chk siz (('zr'do'zc*=zs[i];'),('zc'pdo'zv[i]=rv[i];'))mxfn ⍺ ⍵}
rgtm←{chk siz←''('zr=rr;','rr'do'zs[i]=rs[i];')
 chk siz (('zr'do'zc*=zs[i];'),('zc'pdo'zv[i]=rv[i];'))mxfn ⍺ ⍵}
lftd←{chk siz←''('zr=lr;','lr'do'zs[i]=ls[i];')
 chk siz (('zr'do'zc*=zs[i];'),('zc'pdo'zv[i]=lv[i];'))mxfn ⍺ ⍵}
rgtd←{chk siz←''('zr=rr;','rr'do'zs[i]=rs[i];')
 chk siz (('zr'do'zc*=zs[i];'),('zc'pdo'zv[i]=rv[i];'))mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Catenate/Ravel
catm←{chk←'' ⋄ siz←'zr=1;',('rr'do'rc*=rs[i];'),'zs[0]=rc;'
 exe←'rc'pdo'zv[i]=rv[i];' ⋄ chk siz exe mxfn ⍺ ⍵}
catd←{chk←'if(rr!=0&&lr!=0&&abs(rr-lr)>1)error(4);int minr=rr>lr?lr:rr;',nl
 chk,←'int sr=rr==lr&&lr!=0?lr-1:minr;','sr'do'if(rs[i]!=ls[i])error(5);'
 siz←'zs[0]=1;if(lr>rr){zr=lr;',('lr'do'zs[i]=ls[i];')
 siz,←'}else{zr=rr;',('rr'do'zs[i]=rs[i];'),'}',nl
 siz,←'zr=zr==0?1:zr;zs[zr-1]+=minr==zr?ls[zr-1]:1;'
 exe←('zr'do'zc*=zs[i];'),'BOUND li=0,ri=0,zm=zs[zr-1],'
 exe,←'lm=(lr<rr||lr==0)?1:ls[lr-1];','zc'do'zv[i]=i%zm<lm?lv[li++]:rv[ri++];'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Catenate First Axis/Table
fctm←{siz←'zr=2;if(rr==0){zs[0]=1;zs[1]=1;}else{zs[0]=rs[0];'
 siz,←('rr-1'do'rc*=rs[i+1];'),'zs[1]=rc;rc*=rs[0];}'
 '' siz ('rc'pdo'zv[i]=rv[i];') mxfn ⍺ ⍵}
fctd←{chk←'if(rr!=0&&lr!=0&&abs(rr-lr)>1)error(4);int minr=rr>lr?lr:rr;',nl
 chk,←'if(lr==rr&&rr>0){','rr-1'do'if(rs[i+1]!=ls[i+1])error(5);'
 chk,←'}else if(lr<rr){','lr'do'if(ls[i]!=rs[i+1])error(5);'
 chk,←'}else{','rr'do'if(ls[i+1]!=rs[i])error(5);}'
 siz←'zs[0]=1;if(lr>rr){zr=lr;',('lr'do'zs[i]=ls[i];')
 siz,←'}else{zr=rr;',('rr'do'zs[i]=rs[i];'),'}',nl
 siz,←'zr=zr==0?1:zr;zs[0]+=minr==zr?ls[0]:1;'
 exe←('lr'do'lc*=ls[i];'),('rr'do'rc*=rs[i];')
 exe,←'if(abs(lr-rr)<=1){',('lc'pdo'zv[i]=lv[i];'),('rc'pdo'zv[lc+i]=rv[i];')
 exe,←'}else{',('zr-1'do'zc*=zs[i+1];')
 exe,←'if(lr==0){',('zc'pdo'zv[i]=lv[0];'),('rc'pdo'zv[zc+i]=rv[i];')
 exe,←'}else{',('lc'pdo'zv[i]=lv[i];'),('zc'pdo'zv[lc+i]=rv[0];'),'}}'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Reverse/Rotate
rotm←{exe←('zr==0?0:zr-1'do'zc*=zs[i];'),'rc=rr==0?1:rs[rr-1];'
 exe,←'zc'pdo'BOUND j=i;','rc'pdo'zv[j*rc+i]=rv[j*rc+(rc-(i+1))];'
 ''('zr=rr;','zr'do'zs[i]=rs[i];')exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Member/Enlist
memm←{siz←('rr'do'rc*=rs[i];'),'zr=1;zs[0]=rc;' ⋄ exe←'rc'pdo'zv[i]=rv[i];'
 '' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Disclose/Pick/First
dscm←{'' 'zr=0;'(('rr'do'rc*=rs[i];'),'zv[0]=rc==0?0:rv[0];')mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Rotate First Axis/Reverse First Axis
rtfm←{exe←('zr==0?0:zr-1'do'zc*=zs[i+1];'),'rc=rr==0?1:rs[0];'
 exe,←'rc'pdo'BOUND j=i;','zc'pdo'zv[j*zc+i]=rv[(rc-(j+1))*zc+i];'
 ''('zr=rr;','zr'do'zs[i]=rs[i];')exe mxfn ⍺ ⍵}
rtfd←{chk←'if(lr!=0&&(lr!=1||ls[0]!=1))error(16);'
 siz←'zr=rr;','zr'do'zs[i]=rs[i];'
 exe←'zc=rr==0?1:rs[0];','rr==0?0:rr-1'do'rc*=rs[i+1];'
 exe,←'zc'do'BOUND j=i;','rc'do'zv[(((j-lv[0])%zc)*rc)+i]=rv[(j*rc)+i];'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Equivalent/Match/Depth
eqvm←{'' 'zr=0;' 'zv[0]=rr==0?0:1;' mxfn ⍺ ⍵}
eqvd←{chk siz←'' 'zr=0;' ⋄ exe←'zv[0]=1;if(rr!=lr)zv[0]=0;'
 exe,←'lr'do'if(!zv[0])break;if(rs[i]!=ls[i]){zv[0]=0;break;}'
 exe,←'lr'do'lc*=ls[i];'
 exe,←'lc'do'if(!zv[0])break;if(lv[i]!=rv[i]){zv[0]=0;break;}'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Not Match/Disequivalent/Tally
nqvm←{'' 'zr=0;' 'zv[0]=rr==0?1:rs[0];' mxfn ⍺ ⍵}
nqvd←{chk siz←'' 'zr=0;' ⋄ exe←'zv[0]=0;if(rr!=lr)zv[0]=1;'
 exe,←'lr'do'if(zv[0])break;if(rs[i]!=ls[i]){zv[0]=1;break;}'
 exe,←'lr'do'lc*=ls[i];'
 exe,←'lc'do'if(zv[0])break;if(lv[i]!=rv[i]){zv[0]=1;break;}'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Replicate/Filter
fltd←{chk←'if(lr>1)error(4);',nl
 chk,←'if(lr!=0&&ls[0]!=1&&rr!=0&&rs[rr-1]!=1&&ls[0]!=rs[rr-1])error(5);'
 siz←'zr=rr==0?1:rr;','zr-1'do'zs[i]=rs[i];'
 siz,←'if(lr==1)lc=ls[0];if(rr!=0)rc=rs[rr-1];zs[zr-1]=0;BOUND last=0;'
 siz,←'if(lc>=rc){',('lc'do'last+=lv[i];'),'zs[zr-1]=last;}',nl
 siz,←'else{',('rc'do'last+=lv[0];'),'zs[zr-1]=last;}',nl,'zr-1'do'zc*=zs[i];'
 inc←'a+=lv[i];' ⋄ zvi←'zv[(k*zs[zr-1])+a+i]=' ⋄ age←'rv[(k*rc)+j];'
 agt←'else if(lv[i]>0){BOUND j=i;',nl
 agt,←('zc'do'BOUND k=i;',nl,'lv[j]'do zvi,age),'}'
 alt←'else{BOUND j=i;',nl,('zc'do'BOUND k=i;',nl,'abs(lv[j])'do zvi,'0;'),'}'
 exe←'BOUND a=0;if(rc==lc){',nl
 ⍝ exe,←('lc'do'if(lv[i])zv[a++]=rv[i];'),'}'
 exe,←('lc'do'if(lv[i]==0)continue;',nl,agt,nl,alt,nl,inc),'}'
 bgt←'lv[0]'do'zv[(j*zs[zr-1])+a++]=rv[(j*rc)+k];'
 exe,←'else if(rc>lc){if(lv[0]>0){','zc'do'BOUND j=i;','rc'do'BOUND k=i;',bgt
 exe,←'}else if(lv[0]<0){',('zc*zs[zr-1]'do'zv[i]=0;'),'}}else{'
 cgt←'zc'do'BOUND k=i;','lv[j]'do'zv[(k*zs[zr-1])+a+i]=rv[k*rc];'
 cle←'zv[(k*zs[zr-1])+a+i]=0;'
 clt←'}else{BOUND j=i;',('zc'do'BOUND k=i;','abs(lv[j])'do cle),'}'
 exe,←'lc'do'if(lv[i]==0)continue;else if(lv[i]>0){BOUND j=i;',cgt,clt,inc,'}'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Decode/Encode
decd←{chk←'if(lr>1||lv[0]<0)error(16);'
 siz←'zr=rr==0?0:rr-1;','zr'do'zs[i]=rs[i+1];zc*=rs[i+1];'
 siz,←'if(rr>0)rc=rs[0];'
 exe←'zc'do'BOUND j=i;zv[j]=0;','rc'do'zv[j]=rv[(i*zc)+j]+lv[0]*zv[j];'
 chk siz exe mxfn ⍺ ⍵}
encd←{chk←'if(lr>1)error(16);','lr'do'lc*=ls[i];'
 chk,←'lc'do'if(lv[i]<=0)error(16);'
 siz←'zr=1+rr;zs[0]=lc;','rr'do'zs[i+1]=rs[i];'
 exe←('rr'do'rc*=rs[i];')
 cod←'zv[(i*rc)+j]=(rv[j]>>(lc-(i+1)))%2;'
 exe,←'rc'do'BOUND j=i;','lc'do cod
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[l]:Definition for sopid:codfns.dyalog?s=^sopid←
⍝[of]:Take/Drop
drpd←{chk←'if(lr!=0&&(lr!=1||ls[0]!=1))error(16);'
 siz←'zr=rr;',('zr'do'zs[i]=rs[i];'),'zs[0]-=lv[0];','zr-1'do'zc*=zs[i+1];'
 exe←'zs[0]'do'BOUND j=i;','zc'do'zv[(j*zc)+i]=rv[((j+1)*zc)+i];'
 chk siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[of]:Transpose
tspm←{siz←'zr=rr;','rr'do'zs[rr-(1+i)]=rs[i];'
 exe←'rs[0]'do'BOUND j=i;','rs[1]'do'zv[(i*zs[1])+j]=rv[(j*rs[1])+i];'
 '' siz exe mxfn ⍺ ⍵}
⍝[cf]
⍝[cf]
⍝[of]:Horrible Hacks
ptrd←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ ptrdr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ ptrdl ⍵ ⋄ ⍺ ptrdv ⍵}

ptrdl←{z←'{',(⊃,/'rslt' 'rgt'{'LOCALP *',⍺,'=',⍵,';'}¨var/2↑⍵)
 z,←(⊃git 2⌷⍺),'l[]={',(⊃{⍺,',',⍵}/⍕¨⊃2 0⌷⍵),'};',nl
 z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
 z,←'if(rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
 z,←'getarray(',(⊃gie ⊃⍺),',0,NULL,rslt);BOUND c=1;',nl
 z,←'rgt->p->RANK'do'c*=rgt->p->SHAPETC[i];'
 z,←(⊃,/(git ¯1↓⍺){⍺,'*',⍵,';'}¨'zr'),nl
 z,←(⊃,/'zr'{⍺,'=ARRAYSTART(',⍵,'->p);',nl}¨'rslt' 'rgt'),nl
 prag←((⊂2↑COMPILER)∊'pg' 'ic')⊃''('#pragma simd reduction(+:z)',nl)
 do←prag {'{BOUND i;',nl,⍺⍺,(for ⍺),⍵,'}}',nl}
 z,←'c'do'z[0]+=l[i]*r[i];'
 z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
 z,'}',nl}
 
sopid←{siz←'zr=(lr-1)+rr;zs[0]=ls[0];','zr-1'do'zs[i+1]=rs[i];'
 exe←'zc=zs[0];rc=rs[0];lc=ls[rr-1];'
 cod←'zv[(j*rc*lc)+(k*lc)+i]=lv[(j*lc)+i]*rv[(k*lc)+i];'
 exe,←'zc'do'BOUND j=i;','rc'do'BOUND k=i;','lc'do cod
 '' siz exe mxfn ⍺ ⍵}
 
 ⍝ Lamination
  catdo←{0≡⊃0⍴⊂⊃⊃1 0⌷⍵:⍺ catdr ⍵ ⋄ 0≡⊃0⍴⊂⊃⊃2 0⌷⍵:⍺ catdl ⍵ ⋄ ⍺ catdv ⍵}
  
  catdv←{z←'{',(⊃,/'rslt' 'rgt' 'lft'{'LOCALP *',⍺,'=',⍵,';'}¨var/⍵),nl
   z,←'BOUND s[]={rgt->p->SHAPETC[0],2};'
   z,←'LOCALP*orz;LOCALP tp;tp.p=NULL;int tpused=0;',nl
   z,←'if(rslt==lft||rslt==rgt){orz=rslt;rslt=&tp;tpused=1;}',nl
   z,←'relp(rslt);getarray(',(⊃gie ⊃0⌷⍺),',2,s,rslt);',nl
   z,←(⊃,/(git ⍺){⍺,'*',⍵,';'}¨'zrl'),nl
   z,←⊃,/'zrl'{⍺,'=ARRAYSTART(',⍵,'->p);',nl}¨'rslt' 'rgt' 'lft'
   z,←'s[0]'pdo'z[i*2]=l[i];z[i*2+1]=r[i];'
   z,←'if(tpused){relp(orz);orz->p=zap(rslt->p);}',nl
   z,'}',nl}
⍝[cf]
rth ←'#include <math.h>',nl,'#include <dwa.h>',nl,'#include <dwa_fns.h>',nl
rth,←'#include <stdio.h>',nl,'#ifdef HASACC',nl,'#include <accelmath.h>',nl
rth,←'#endif',nl
rth,←'int isinit=0;',nl
rth,←'#define PI 3.14159265358979323846',nl
⍝[cf]
:EndNamespace
