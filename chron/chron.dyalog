:Namespace chron

path←'./chron/'
datapath←'./chron/data/'
testpath←'./chron/tests/'

cmpx←{⍺←⍬ ⋄ r m c←1 50 0(⊢+⊣×0=⊢)3↑⍺
 f←{(2-c)∘⊃(⍎'{0<⍵:∇⍵-1⊣',⍵,'⋄⎕AI}⍺')-⎕AI}
 1{t←⍺f¨⍵ ⋄ m>(+/÷≢),t:(⍺×2)∇⍵
 ((⊢-0⌊⌊/∘,)t-⍺f'⍬')÷⍺×1000}(⊢⍴⍨r,⍴)⊆⍵}

tmx←{⍺←⍬ ⋄ r m c←1 5 0(⊢+⊣×0=⊢)3↑⍺
 f←{(2-c)∘⊃(⍎'{0<⍵:∇⍵-1⊣',⍵,'⋄⎕AI}⍺')-⎕AI}
 (2*m){((⊢-0⌊⌊/∘,)(⍺f¨⍵)-⍺f'⍬')÷⍺×1000}(⊢⍴⍨r,⍴)⊆⍵}

get←{
    ⍺←83                                ⍝ default: return 8-bit integers
	0::⎕SIGNAL ⎕EN	                    ⍝ signal error to caller.
	t←⍵ ⎕NTIE 0	                        ⍝ file handle.
	z←⎕NREAD t ⍺,⎕NSIZE t               ⍝ all bytes.
	z⊣⎕NUNTIE t	                        ⍝ ⎕AV chars.
}

putfile←{                               ⍝ Put rows to text-file.
    ⍺←2 ⋄ term←(-⍺)↑⎕UCS 13 10          ⍝ default: cr-lf terminated rows.
    fid rows←⍵                          ⍝ file-id and row values.
    ntie←{                              ⍝ handle on null file.
        0::⎕SIGNAL ⎕EN                  ⍝ signal error to caller.
        22::⍵ ⎕NCREATE 0                ⍝ ~exists: create.
        0 ⎕NRESIZE ⍵ ⎕NTIE 0            ⍝  exists: truncate.
    }fid
    cvec←term,⍤1⍨rows                   ⍝ collected, terminated lines.
    size←cvec ⎕NAPPEND ntie,⎕DR ⎕AV     ⍝ write lines to file.
    1:rslt←size⊣⎕NUNTIE ntie            ⍝ shy result: file size.
}

newname←{'.dyalog',⍨datapath,⍵,'_data_',⊃,∘('-'∘,)/⍕¨⎕TS}
OS←{'Mac' 'Linux'∨.≡3 5↑¨⊂⊃'.'⎕WG'APLVersion'}

specs←{
 z←'sudo dmidecode --type 17 | grep ''Speed\|Size\|Type'''
 z,←' && cat /proc/cpuinfo | grep processor -A 8'
 z,←' && lspci -vnn | grep VGA'
 OS⍬: ⍵,⍨⎕SH z
 ⍵
}

⍝Intended to mimic test_files_in_dir in ut.dyalog
find←{v←'tests' 'data'≡¨⊂⍵ ⋄ ~1∊v:⎕EM 11
 s←⊃v/'*_chron.dyalog' '*_data_*'
 OS⍬: ⎕SH 'find ',path,⍵,' -name ',s
 #.⎕CY'files' ⋄ Z←#.Files.Dir ⍵,'\',s ⋄ Z←(⍵,'\'∘,)¨Z
 #.⎕EX¨'CompFiles' 'Files' 'TestFiles'
}

ts0←{2>⍴⍴⍵: ⍕⍵ ⋄ (⍕⍴⍵),'⍴',⍕,⍵}
ts1←⊢(⌿⍨)(⊣≡↑⍨∘≢⍨)⍤1
test←{⍺←10
 n←⎕SE.SALT.Load testpath,'_chron.dyalog',⍨⊃⊆⍵
 z←'.',⍨'#.chron.cmpx' ⎕NS⍨⍕n
 m←' '⍪⍨'⍝',↑specs (~∘' ','←',∘ts0∘⍎ z∘,)¨↓n.⎕NL 2
 t←('_chron',⍨⊃⊆⍵) ts1 n.⎕NL 2
 f←⊢↑[1]⍨1⊃⌈∘⍴⍨∘⍴
 g←1 putfile (⊂∘newname⊢),∘⊂m(f⍨⍪f)∘⍕⊣n.cmpx∘⍎z,⊢
 ⍬≢⍴1⊃2↑⊆⍵:⍺g⍤1⊢t
 ⍺g⊢t⌷⍨¯1+1⊃⍵
}

load←'UTF-16'⎕UCS⍤1∘↑10~⍨¨∘(10∘=⊂⊢)163∘get
load_data←(⍎⍤1)1↓¯1↓(⊢(⌿⍨)'⍝'≠⊃⍤1)∘load

⍝ Probability functions
mean←+⌿÷≢
hmean←≢÷+⌿∘÷
var←×⍨∘mean-⍨∘mean×⍨
var2←mean∘(×⍨)⊢-⍤¯1 15mean
cov←×∘mean⍨∘mean-⍨∘mean×
cov2←{mean(⍺-mean⍺)×(⍵-mean ⍵)}
stdev←.5*⍨var
zscore←stdev÷⍤¯1 15⍨⊢-⍤¯1 15 mean
skew←mean 3*⍨zscore
kurt←mean 4*⍨zscore
entropy←(-⊢+.×⍟)(≢⊢)⌸÷≢
meancomp←∘.-⍨∘mean÷.5*⍨∘.+⍨∘var÷≢
sort←⍋⌷⍤0 15⊢
freqtab←sort,∘≢⌸

hyp←{1+(⊣×1+⊢)/⍵×⍤0 1⊢÷⌿×⌿(⍳⍺⍺)∘.+⍨(⊢⍴⍨2 2,1↓⍴)(0∘⌷⍪1⍪¯2∘↑)⍺}
Lbet←{(0∘⌷⍺)÷⍨(⍵*0∘⌷⍺)×⍵(200 hyp)⍨(0∘⌷⍪∘⊖1+1 ¯1×[0]⊢)⍺}
beta←1∘⌷×¯1!.++⍀
I←Lbet÷∘beta⊣
Lgam←{n←1+⍳100×⌈0.5*⍨⌈/,⍵÷⍺
 ⍺÷⍨(⍵*⍺)×⊃(⊣×1-⊢)/⊂⍤¯1⊢1⍪(n÷⍨⍤0 15⊢⍵)×⍤¯1⊢1-÷n+⍤0 15⊢⍺}
Ugam←Lgam-⍨∘!¯1+⊣
digam←{z←2*¯32 ⋄ (z÷⍨-⌿÷1∘⌷)!(z 0)+⍤0 15⊢¯1+⍵}
ddigam←{z←2*¯16 ⋄ (×⍨digam⍵)-⍨((×⍨z)÷⍨-⌿÷1∘⌷)!(,∘-⍨z 0)+⍤0 15⊢¯1+⍵}

erf←{((4×¯3○1)*-1÷2)×.5 Lgam ⍵*2}
normcdf←{2÷⍨1+(×⍵)×erf ⍵÷2*0.5}
chicdf←{(!1-⍨⍺÷2)÷⍨(2÷⍨⍺) Lgam 2÷⍨⍵}
Fcdf←(2÷⍨⊣)I∘÷1+(1⌷⊣)÷⊢×0⌷⊣
invgamcdf←((0⌷⊣)Ugam⍤15 ¯1⊢÷⍤15 ¯1⍨1⌷⊣)÷⍤¯1 15∘!¯1+0⌷⊣
sinvgamcdf←⊣invgamcdf⊢(+⍤¯1 15)2⌷⊣
gamcdf←{((0⌷⍺)Lgam⍤15 ¯1⊢⍵÷⍤¯1 15⊢1⌷⍺)÷⍤¯1 15⊢!¯1+0⌷⍺}
invgampdf←{((*⌿⊖⍺)÷!¯1+0⌷⍺)×⍤15 ¯1⊢(*-⍵÷⍤15 ¯1⍨1⌷⍺)×⍵*⍤¯1 15⊢-1+0⌷⍺}
gampdf←{((*⌿⊖⍺)×!¯1+0⌷⍺)÷⍤¯1 15⍨(*-⍵÷⍤¯1 15⊢1⌷⍺)×⍵*⍤¯1 15⊢¯1+0⌷⍺}

invgam_mom1←2+×⍨∘mean÷var
invgam_mom2←(⊢÷⍨3∘×+8+4×.5*⍨4∘+)×⍨∘skew
invgam_mom3←(2∘×÷⍨30+7∘×+0.5*⍨150∘+×6∘+)kurt
invgam_shift←⊣-∘mean⍨.5*⍨⊣×∘var⍨¯2+⊢
invgam_mlec←(-mean∘⍟+∘⍟+⌿∘÷)⊣+⍤¯1 15invgam_shift
invgam_mle1←⊢÷1+(invgam_mlec+×∘≢⍨-⍨∘⍟⍨∘digam⊢)÷1-⊢×∘ddigam⊢
fit←{1⌊0⌈-⌿⍺ ⍺⍺⍤15 ¯1⊢⍉(⊢(∘.+⍤1)0.5 ¯0.5∘.×⍨∘(|-⌿)2↑⍉)∪∘sort⍤1∘⍉⍵}
Evals←{(≢⍵)×⍺ ⍺⍺ fit ⍵}
Ovals←1⌷∘⍉sort∘freqtab⍤1∘⍉
good←{(Ovals ⍵)(+⌿⊢÷⍨2*⍨-)⍺ ⍺⍺ Evals ⍵}

:EndNamespace
