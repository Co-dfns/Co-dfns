:Namespace

bitvector∆Run←{⍺∧0≠⍵}

r←0.02	⋄ v←0.03
coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442
CNDP2←{L←|⍵ ⋄ B←⍵≥0
 R←(÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L
 (1 ¯1)[B]×((0 ¯1)[B])+R
}
blackscholes∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT
 CD1←CNDP2 D1 ⋄ CD2←CNDP2 D2 ⋄ e←*(-r)×T
 ((S×CD1)-X×e×CD2),[0.5](X×e×1-CD2)-S×1-CD1
}

bracket∆Run←{⍺[⍵]} ⋄ bracket∆Lit←{(0 1 2 3 4 5)[⍵]}

bs1∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 ((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT}

bs2∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2 D1}

CNDP2∆1←{L←|⍵ ⋄ B←⍵≥0
 (÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L}
bs3∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2∆1 D1}

CNDP2∆2←{L←|⍵ ⋄ B←⍵≥0 ⋄ ÷1+0.2316419×L}
bs4∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2∆2 D1}

CNDP2∆3←{L←|⍵ ⋄ B←⍵≥0 ⋄ {1+⍵}¨÷1+0.2316419×L}
bs5∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2∆3 D1}

bs6∆Run←{coeff+.×⍵}

bs7∆Run←{{coeff+.×⍵*1 2 3 4 5}¨⍵}

CNDP2∆4←{L←|⍵ ⋄ B←⍵≥0 ⋄ {coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L}
bs8∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2∆4 D1}

CNDP2∆5←{L←|⍵ ⋄ B←⍵≥0 ⋄ 5×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L}
bs9∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 D1←((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT ⋄ D2←D1-vsqrtT ⋄ CNDP2 D1}

catenate∆Run←{⍺,⍵}

catfirst∆Run←{⍺⍪⍵}

circumference∆Run←{○⍵×2}

commute∆Run←{⍺-⍨⍵} ⋄ commute∆Rm←{-⍨⍵}

compose∆Rm←{×∘-⍵} ⋄ compose∆Rd←{⍺×∘-⍵}
compose∆Rl←{5∘×⍵} ⋄ compose∆Rr←{(-∘5)⍵}

cp0∆R1←{X←5 ⋄ FN←{X×⍺+⍵} ⋄ FN/5 FN 3 FN 7}
cp0∆R2←{X←5 ⋄ FN←{X×⍵} ⋄ FN FN 7}
cp0∆R3←{X←5 ⋄ FN←{X×X} ⋄ FN FN 7}

deal∆Run←{⍺?⍵}

decode∆Run←{⍺⊥⍵}

depth∆Run←{≡⍵}

drop∆R1←{⍺↓⍵} ⋄ drop∆R2←{(1⌷⍺)↓⍵} ⋄ drop∆R3←{5↓⍵}

dupnames∆Run←{y←⍵ ⋄ x←⍵+y ⋄ y←⍵×⍵ ⋄ y+y}

each∆R1←{⍺-¨⍵} ⋄ each∆R2←{⍺{⍺-⍵}¨⍵} ⋄ each∆R3←{{÷⍵}¨⍵} ⋄ each∆R4←{÷¨⍵}
each∆R5←{×¨⍵} ⋄ each∆R6←{{×⍵}¨⍵} ⋄ each∆R7←{X←0⌷⍵ ⋄ ⍺{⍺-⍵}¨X}

encode∆Run←{⍺⊤⍵} ⋄ encode∆Ovr←{⍺⊤0⌷⍵}

enlist∆Run←{∊⍵}

expand∆Run←{⍺\⍵}

expandfirst∆Run←{⍺⍀⍵}

find∆Run←{⍺⍷⍵}

first∆Run←{⊃⍵}

fft∆fft←{⎕FFT ⍵} ⋄ fft∆ifft←{⎕IFFT ⍵}

gofo∆Run←{go←{⍵+⍺} ⋄ fo←{⍺=⍵} ⋄ ao←{⍺ go ⍺ fo ⍵} ⋄ ⍺ ao ⍵}

gradedown∆Run←{⍒⍵}

gradeup∆Run←{⍋⍵}

guards∆R1←{⍵: 0 ⋄ 1} ⋄ guards∆R2←{~⍵: 0 ⋄ 1} ⋄ guards∆R3←{~⍵∨⍵: 0 ⋄ 1}

identity∆Run←{⊢⍵}

index∆R1←{⍺⌷⍵} ⋄ index∆R2←{1⌷⍵}
⍝ index∆R3←{X←⍳⍺ ⋄ Y←⍳⍺ ⋄ X Y⌷⍵}
⍝ index∆R4←{R←0⌷⍺ ⋄ C←1⌷⍺ ⋄ I←R↑2↓⍺ ⋄ J←C↑(2+R)↓⍺ ⋄ I J⌷⍵}

indexgen∆Run←{⍳⍵}

indexof∆Run←{⍺⍳⍵}

innerproduct∆R1←{⍺+.×⍵} ⋄ innerproduct∆R2←{⍺{⍺+⍵}.{⍺×⍵}⍵}
innerproduct∆R3←{⍺=.+⍵} ⋄ innerproduct∆R4←{X←0⌷⍺ ⋄ Y←0⌷⍵ ⋄ X{⍺+⍵}.{⍺×⍵}Y}
innerproduct∆R5←{⍺∧.=⍵} ⋄ innerproduct∆R6←{X←0⌷⍵ ⋄ X+.×X}

internalbindings∆Run←{X←A+A←⍳⍵ ⋄ X+X}

intersection∆Run←{⍺∩⍵}

laminate∆R1←{⍺,[0.5]⍵} ⋄ laminate∆R2←{⍺,[0]⍵} ⋄ laminate∆R3←{⍺,[1]⍵}
laminate∆R4←{⍺,[2]⍵} ⋄ laminate∆R5←{⍺,[¯0.5]⍵}

left∆Run←{⍺⊣⍵}

literalscalar∆R1←{X←1 ⋄ ⍵⊢X} ⋄ literalscalar∆R2←{X←1 2 ⋄ ⍵⊢X}

match∆Run←{⍺≡⍵}

matinv∆Run←{⌹⍵}

matdiv∆Run←{⍺⌹⍵}

membership∆Run←{⍺∊⍵}

mix∆Run←{↑⍵}

notmatch∆Run←{⍺≢⍵}

outerproduct∆R1←{⍺∘.×⍵} ⋄ outerproduct∆R2←{⍺∘.{⍺×⍵}⍵}
outerproduct∆R3←{⍺∘.=⍵} ⋄ outerproduct∆R4←{⍺∘.+⍵}
outerproduct∆R5←{X←0⌷⍵ ⋄ ⍺∘.×X}

pick∆Run←{⍺⊃⍵}

power∆R01←{(×⍣⍺)⍵} ⋄ power∆R02←{×⍣⍺⊢⍵} ⋄ power∆R03←{⍺×⍣5⊢⍵}
power∆R04←{⍺(×⍣5)⍵} ⋄ power∆R05←{({×⍵}⍣⍺)⍵} ⋄ power∆R06←{{×⍵}⍣⍺⊢⍵}
power∆R07←{⍺{⍺×⍵}⍣5⊢⍵} ⋄ power∆R08←{⍺({⍺×⍵}⍣5)⍵} ⋄ power∆R09←{○⍣{∨/,100<⍺}⍵}
power∆R10←{○⍣{∨/,100<⍵}⍵} ⋄ power∆R11←{⍺×⍣{∨/,100<⍵}⍵}
power∆R12←{⍺×⍣{∨/,100<⍺}⍵} ⋄ power∆R13←{{○⍵}⍣{∨/,100<⍵}⍵}
power∆R14←{{○⍵}⍣{∨/,100<⍺}⍵} ⋄ power∆R15←{⍺{⍺×⍵}⍣{∨/,100<⍵}⍵}
power∆R16←{⍺{⍺×⍵}⍣{∨/,100<⍺}⍵}

pytha∆Run←{((⍺*2)+⍵*2)*÷2}

quadratic∆Run←{A←0⌷⍵ ⋄ B←1⌷⍵ ⋄ C←2⌷⍵ ⋄ ((-B)+((B×B)-4×A×C)*0.5)÷2×A}

random∆Run←{?⍺⍴⍵}

rank∆R1←{(×⍤⍺)⍵} ⋄ rank∆R2←{(≢⍤⍺)⍵} ⋄ rank∆R3←{⍺×⍤1⍤1 2⊢⍵}

ravel∆Run←{,⍵}

recursion∆R1←{⍵≤0: 1 ⋄ ⍵×recursion∆R1 ⍵-1}
recursion∆R2←{⍵≤0: 1 ⋄ ⍵×∇ ⍵-1}

redfirst∆R1←{+⌿⍵} ⋄ redfirst∆R2←{×⌿⍵}
redfirst∆R3←{{⍺+⍵}⌿⍵} ⋄ redfirst∆R4←{X←0⌷⍵ ⋄ {⍺+⍵}⌿⍵}

reduce∆R01←{+/⍵} ⋄ reduce∆R02←{×/⍵} ⋄ reduce∆R03←{{⍺+⍵}/⍵}
reduce∆R04←{≠/⍵} ⋄ reduce∆R05←{{⍺≠⍵}/⍵} ⋄ reduce∆R06←{∧/⍵}
reduce∆R07←{-/⍵} ⋄ reduce∆R08←{÷/⍵} ⋄ reduce∆R09←{|/⍵}
reduce∆R10←{⌊/⍵} ⋄ reduce∆R11←{⌈/⍵} ⋄ reduce∆R12←{*/⍵}
reduce∆R13←{!/⍵} ⋄ reduce∆R14←{∧/⍵} ⋄ reduce∆R15←{∨/⍵}
reduce∆R16←{</⍵} ⋄ reduce∆R17←{≤/⍵} ⋄ reduce∆R18←{=/⍵}
reduce∆R19←{≥/⍵} ⋄ reduce∆R20←{>/⍵} ⋄ reduce∆R21←{≠/⍵}
reduce∆R22←{⊤/⍵} ⋄ reduce∆R23←{∪/⍵} ⋄ reduce∆R24←{//⍵}
reduce∆R25←{⌿/⍵} ⋄ reduce∆R26←{\/⍵} ⋄ reduce∆R27←{⍀/⍵}
reduce∆R28←{⌽/⍵} ⋄ reduce∆R29←{⊖/⍵} ⋄ reduce∆R30←{X←0⌷⍵ ⋄ {⍺≠⍵}/X}

reducenwise∆R1←{⍺+/⍵} ⋄ reducenwise∆R2←{⍺×/⍵} ⋄ reducenwise∆R3←{⍺{⍺+⍵}/⍵}

reducenwisefirst∆R1←{⍺+⌿⍵}
reducenwisefirst∆R2←{⍺×⌿⍵}
reducenwisefirst∆R3←{⍺{⍺+⍵}⌿⍵}

replicate∆Run←{⍺/⍵}

replicatefirst∆Run←{⍺⌿⍵}

reshape∆Rv←{⍺⍴⍵} ⋄ reshape∆Rl←{2 2⍴⍵} ⋄ reshape∆Rr←{⍺⍴5}
reshape∆Rs←{10⍴⍵}

reverse∆R1←{⌽⍵} ⋄ reverse∆R2←{⌽⌽⌽⍵}

revfirst∆R1←{⊖⍵} ⋄ revfirst∆R2←{⊖⊖⊖⍵}

right∆Run←{⍺⊢⍵}

romilly∆spin←{z←(¯2⊖⍵)⍪(¯1⊖⍵)⍪⍵⍪(1⊖⍵)⍪2⊖⍵ ⋄ (25,⍴⍵)⍴(¯2⌽z)⍪(¯1⌽z)⍪z⍪(1⌽z)⍪2⌽z}
romilly∆Run←{s←romilly∆spin ⍵ ⋄ (4×+⌿⍺×s)>+⌿s}

rotate∆S←{⍺⌽⍵} ⋄ rotate∆R←{7⌽⍵} ⋄ rotate∆T←{¯1⌽⍵}
rotate∆U←{X←0⌷⍺ ⋄ Y←0⌷⍵ ⋄ X⌽Y}

rotfirst∆S←{⍺⊖⍵} ⋄ rotfirst∆R←{7⊖⍵} ⋄ rotfirst∆T←{¯1⊖⍵}
rotfirst∆U←{X←0⌷⍺ ⋄ Y←0⌷⍵ ⋄ X⊖Y}

same∆Run←{⊣⍵}

scl∆add←{⍺+⍵} ⋄ scl∆sub←{⍺-⍵} ⋄ scl∆mul←{⍺×⍵} ⋄ scl∆div←{⍺÷⍵}
scl∆pow←{⍺*⍵} ⋄ scl∆log←{⍺⍟⍵} ⋄ scl∆res←{⍺|⍵} ⋄ scl∆min←{⍺⌊⍵}
scl∆max←{⍺⌈⍵} ⋄ scl∆leq←{⍺≤⍵} ⋄ scl∆let←{⍺<⍵} ⋄ scl∆eql←{⍺=⍵}
scl∆geq←{⍺≥⍵} ⋄ scl∆get←{⍺>⍵} ⋄ scl∆neq←{⍺≠⍵} ⋄ scl∆and←{⍺∧⍵}
scl∆lor←{⍺∨⍵} ⋄ scl∆nor←{⍺⍱⍵} ⋄ scl∆nan←{⍺⍲⍵} ⋄ scl∆cir←{⍺○⍵}
scl∆bin←{⍺!⍵} ⋄ scl∆con←{+⍵} ⋄ scl∆neg←{-⍵} ⋄ scl∆dir←{×⍵}
scl∆rec←{÷⍵} ⋄ scl∆exp←{*⍵} ⋄ scl∆nlg←{⍟⍵} ⋄ scl∆mag←{|⍵}
scl∆pit←{○⍵} ⋄ scl∆flr←{⌊⍵} ⋄ scl∆cel←{⌈⍵} ⋄ scl∆not←{~⍵}
scl∆mat←{⌷⍵} ⋄ scl∆fac←{!⍵}

scl∆Run←{S←0⌷⍵ ⋄ X←1⌷⍵ ⋄ T←⍺ ⋄ vsqrtT←v×T*0.5
 L←|(((⍟S÷X)+(r+(v*2)÷2)×T)÷vsqrtT)-vsqrtT
 (÷(○2)*0.5)×(*(L×L)÷¯2)×÷1+0.2316419×L}

sclmix∆add←{⍵+⍨⍺} ⋄ sclmix∆sub←{⍵-⍨⍺} ⋄ sclmix∆mul←{⍵×⍨⍺} ⋄ sclmix∆div←{⍵÷⍨⍺}
sclmix∆pow←{⍵*⍨⍺} ⋄ sclmix∆log←{⍵⍟⍨⍺} ⋄ sclmix∆res←{⍵|⍨⍺} ⋄ sclmix∆min←{⍵⌊⍨⍺}
sclmix∆max←{⍵⌈⍨⍺} ⋄ sclmix∆leq←{⍵≤⍨⍺} ⋄ sclmix∆let←{⍵<⍨⍺} ⋄ sclmix∆eql←{⍵=⍨⍺}
sclmix∆geq←{⍵≥⍨⍺} ⋄ sclmix∆get←{⍵>⍨⍺} ⋄ sclmix∆neq←{⍵≠⍨⍺} ⋄ sclmix∆and←{⍵∧⍨⍺}
sclmix∆lor←{⍵∨⍨⍺} ⋄ sclmix∆nor←{⍵⍱⍨⍺} ⋄ sclmix∆nan←{⍵⍲⍨⍺} ⋄ sclmix∆cir←{⍵○⍨⍺}
sclmix∆bin←{⍵!⍨⍺} ⋄ sclmix∆con←{+¨⍵} ⋄ sclmix∆neg←{-¨⍵} ⋄ sclmix∆dir←{×¨⍵}
sclmix∆rec←{÷¨⍵} ⋄ sclmix∆exp←{*¨⍵} ⋄ sclmix∆nlg←{⍟¨⍵} ⋄ sclmix∆mag←{|¨⍵}
sclmix∆pit←{○¨⍵} ⋄ sclmix∆flr←{⌊¨⍵} ⋄ sclmix∆cel←{⌈¨⍵} ⋄ sclmix∆not←{~¨⍵}
sclmix∆mat←{⌷¨⍵} ⋄ sclmix∆fac←{!¨⍵}

scan∆R1←{+\⍵} ⋄ scan∆R2←{×\⍵} ⋄ scan∆R3←{{⍺+⍵}\⍵} ⋄ scan∆R4←{<\⍵}

scanfirst∆R1←{+⍀⍵} ⋄ scanfirst∆R2←{×⍀⍵}
scanfirst∆R3←{{⍺+⍵}⍀⍵} ⋄ scanfirst∆R4←{<⍀⍵}

scanoverrun∆fRun←{(⍺=⍺)/⍵}

shape∆Run←{⍴⍵} ⋄ shape∆R2←{⍴0⌷⍵}

singlevalue∆R1←{⍵} ⋄ singlevalue∆R2←{5} ⋄ singlevalue∆R3←{⊢⍵}
singlevalue∆R4←{A←5 3 2 1 ⋄ A} ⋄ singlevalue∆R5←{4 3}
singlevalue∆R6←{1 0 1} ⋄ singlevalue∆R7←{⍳5}

sobelpi∆Run←{gc←⌽⍉{1↓⍵≠¯1⊖⍵}(31⍴2)⊤1+⍳⍵
 s←(2⊥≠/(32⍴2)⊤gc×⍤1⍤1 2⊢2 30⍴⍺)÷2*30
 4×(+/1>(+/s×s)*÷2)÷⍵}

split∆Run←{↓⍵}

sum35∆Run←{+/((0=3|a)∨0=5|a)/a←⍳⍵}

table∆Run←{⍪⍵} ⋄ table∆R2←{⍪0⌷⍵}

take∆R1←{⍺↑⍵} ⋄ take∆R2←{(1⌷⍺)↑⍵}

tally∆Run←{≢⍵}

transpose∆R1←{⍉⍵} ⋄ transpose∆R2←{⍺⍉⍵}

twostatements∆Run←{x←⍳⍵ ⋄ ⊢⍵}

union∆Run←{⍺∪⍵}

uniqop∆Run←{(∪⍵)∘.=⍵}

unique∆Run←{∪⍵}

:EndNamespace