:Namespace T
  (⎕IO ⎕ML ⎕WX)←0 1 3 ⋄ A←##.A ⋄ TC←##.TC ⋄ H←##.H
  Am←A.Am ⋄ Em←A.Em ⋄ Fm←A.Fm ⋄ Nm←A.Nm ⋄ Om←A.Om ⋄ Pm←A.Pm ⋄ Sm←A.Sm ⋄ Vm←A.Vm
  As←A.As ⋄ Es←A.Es ⋄ Fs←A.Fs ⋄ Os←A.Os ⋄ Ps←A.Ps ⋄ Vs←A.Vs
  d←A.d ⋄ t←A.t ⋄ k←A.k ⋄ n←A.n ⋄ r←A.r ⋄ s←A.s ⋄ v←A.v ⋄ y←A.y ⋄ e←A.e

  ⍝ Core Compiler
  tt ←{fd fz ff if td vc fs av va lt fv ce fc∘pc⍣≡ ca fe dn lf du df rd rn ⍵}

  ⍝ Utilities
  scp←(1,1↓Fm)⊂[0]⊢
  mnd←{A⊣((⍺ ⍺⍺ ⍵)⌿A)←⍺⊣A←⍵⍵ ⍵}
  sub←{⍺←⊢ ⋄ A⊣(m⌿A)←⍺ ⍺⍺(m←⍺ ⍵⍵ ⍵)⌿A←⍵}
  prf←((≢↑¯1↓(0≠⊢)(/∘⊢)⊢)⍤1↑∘r)⊢
  blg←{⍺←⊢ ⋄ ⍺((prf(⌈/(⍳∘≢⊢)×⍤1(1↓⊣)∧.(=∨0=⊢)∘⍉⊢)⍺⍺(⌿∘↑)r)⌷⍤0 2 ⍺⍺(⌿∘⊢)⍵⍵)⍵}

  ⍝ Record Node Cooridinates
  rn ←⊢,∘↓(1+d)↑⍤¯1(+⍀d∘.=∘⍳1+(⌈/0,d))

  ⍝ Record Scope Depths
  rd ←⊢,(+/↑∘r∧.(=∨0=⊢)∘⍉∘↑∘r Fs)

  ⍝ Drop Unnamed Top-level Functions
  df ←(~(+\1=d)∊((1=d)∧(Om∨Fm)∧0∊⍨n)(/∘⊢)(+\1=d))(⌿∘⊢)⊢

  ⍝ Drop dead code after function exit
  dua←(Fm∨↓∘prf∊r∘Fs)(⊣(⍀∘⊢)(⊣(⌿∘⊢)0∊⍨n)(0,1↓(¯1⌽⊣)∧⊢=¯1⌽⊢)⊣(⌿∘⊢)d)⊢
  du ←(~dua∨(∨/(prf∧.(=∨0=⊢)∘⍉dua(⌿∘⊢)prf)∧↑∘r∧.≥∘⍉dua(⌿∘⊢)↑∘r×0=prf))(⌿∘⊢)⊢

  ⍝ Lift Functions
  lfv←⍉∘⍪(1+⊣),'Vf',('fn'H.enc 4⊃⊢),4↓⊢
  lfn←('F'≡1⊃⊢)⌷(⊣-⍨∘⊃⊢)((⊂∘⍉∘⍪⊣,1↓⊢),∘⊂(⊣,'Of',3↓⊢)⍪lfv)⊢
  lfh←(1<(+/⊣))⊃(⊂0↑⊢),∘⊂∘⍉∘⍪1'F'1,('fn'H.enc⊣),(⊂⊣),5↓∘,1↑⊢
  lf ←(1↑⊢)⍪∘⊃(⍪/(1,1↓Fm)blg(↑r)(⊂lfh⍪∘⊃(⍪/((¯2+1=(+/⊣))+∘⊃⊢)lfn⍤¯1⊢))⌸1↓⊢)

  ⍝ Drop useless nodes in the AST
  dn ←((0∊⍨n)∧(Am∧'v'∊⍨k)∨Om∧'f'∊⍨k)((~⊣)(⌿∘⊢)(d-¯1⌽⊣),1↓[1]⊢)⊢

  ⍝ Flatten Expressions
  fen←((⊂'fe')(⊃H.enc)¨((0∊⍨n)∧Em∨Om∨Am)(⌿∘⊢)r)((0∊⍨n)∧Em∨Om∨Am)mnd n⊢
  fet←('V'0⍴⍨2,⍨(+/0,1↓Em∨Om∨Am))(0,1↓Em∨Om∨Am)mnd(t,∘⍪k)⊢
  fee←(⍪/⌽)(1,1↓Em∨Om∨Am)blg⊢((⊂(d-⊃-2⌊⊃),fet,fen,4↓⍤1⊢)⍪)⌸1↓⊢
  fe ←(⊃⍪/)(+\Fm)(⍪/(⊂1↑⊢),∘((+\d=⊃)fee⌸⊢)1↓⊢)⌸⊢

  ⍝ Compress Atomic (Literal/Function) sub-trees into single atomic nodes
  can←(+\Am∨Om)((,1↑⊢),∘(⊂(¯1+2⌊≢)⊃(⊂∘⊂⊃),⊂)∘n 1↓⊢)⌸⊢
  cam←Om∧'f'∊⍨k
  ca ←(can(Am∨Nm∨cam∨¯1⌽cam)(⌿∘⊢)⊢)(Am∨cam)mnd⊢⍬,∘⊂⍨(~Nm∨¯1⌽cam)(⌿∘⊢)⊢

  ⍝ Propagate Literal and Function Constants
  pcc←(⊂⊢(⌿⍨)Am∨Om∧'f'∊⍨k)∘((⍳∘∪⍨n)⌷⍤0 2(1⌈≢)↑⊢)∘((1+⊃),1↓⍤1⊢)∘(⊃⍪⌿)∘⌽(⌿∘⊢)
  pcs←(d,'V','f',(⊃v),r,(⊂⍬),⍨∘⍪s)sub Om
  pcb←((,∧.(=∨0=⊣)∘⍪)⍤2 1⍨∘↑∘r(1↑⊢)⍪Fs)pcc⍤1((⊢(⌿⍨)d=1+⊃)¨⊣)
  pcd←((~(Om∧('f'∊⍨k)∧1≠d)∨Am∧d=1+(∨\Fm))(⌿∘⊢)⊢)∘(⊃⍪/)
  pc ←pcd scp(pcb(pcs(((1⌈≢)↑⊢)⊣)⌷⍤0 2⍨(n⊣)⍳n)sub(Vm∧n∊∘n⊣)¨⊣)⊢

  ⍝ Fold Constant Expressions
  fce←(⊃∘n Ps){⊂⍎' ⍵',⍨(≢⍵)⊃''(⍺,'⊃')('⊃',⍺,'/')}(v As)
  fc ←((⊃⍪/)(((d,'An',3↓¯1↓,)1↑⊢),fce)¨sub((∧/Em∨Am∨Pm)¨))('MFOE'∊⍨t)⊂[0]⊢

  ⍝ Compress Expression sub-trees into single expression nodes
  ce ←(+\Fm∨Em∨Om)((¯1↓∘,1↑⊢),∘⊂(⊃∘v 1↑⊢),∘((v As)Am mnd n⊢)1↓⊢)⌸⊢

  ⍝ Track return variable for functions
  fv ←(⊃⍪/)(((1↓⊢)⍪⍨(,1 6↑⊢),∘⊂∘n ¯1↑⊢)¨scp)
  
  ⍝ Lift type checking (annotate all nodes with type)
  lta←((⊂⊢),∘⊂(12⍴1+(≢∘⌊⍨⊃∘⊃))⍤0)∘(∪(0≡∘⊃0⍴⊢)¨(⌿∘⊢)⊢)∘(⊃,/)∘v Es⍪Os
  ltc←(¯1⊖(¯1+≢)⊃(⊂(12⍴3)⍪TC.id⍪⊢),(⊂(12⍴3)⍪⊢),∘⊂⊢)(⊃Om){⊖⍣⍺⊢⍵}⊢
  ltt←(⊢⍪⍨(,¯1↑⊢)⌷⍤0 1⍨3 4⊥2↑⊢)(ltc(1⊃⊣)⌷⍤0 2⍨(0⊃⊣)⍳∘⊃v)
  ltb←⊣⍪¨(⊂n),∘⊂∘↑((,1↑⊢)¨y)
  lt ←(TC.(pn pt)⍪¨lta)(ltb((,¯1↓⊢),∘⊂ltt)⍤1⊢)⍣≡(⊂4 12⍴0),⍨⊢

  ⍝ Allocate variables
  val←(n⍳∘∪n),¨⊢(⊢+(≢⊣)×0=⊢)(⌈/(⍳≢)×⍤1(∪n)∘.((⊂⊣)∊⊢)v)
  vag←∧∘~∘(∘.=⍨∘⍳≢)⍨(∘.(((1⌷⊢)>0⌷⊣)∧(0⌷⊢)<1⌷⊣)⍨val)
  vae←(∪n)(⊣,⍤0⊣(⌷⍨⍤1 0)∘⊃((⊢,(⊃(⍳∘≢⊣)~((≢⊢)↑⊣)(/∘⊢)⊢))/∘⌽(⊂⍬),∘↓⊢))vag
  var←(((0⌷∘⍉⊣)⍳⊢)⌷(1⌷∘⍉⊣),⊢)⍤2 0
  va ←((⊃⍪/)(1↑⊢),(((vae Es)(d,t,k,(⊣var n),r,s,y,∘⍪⍨(⊂⊣)var¨v)⊢)¨1↓⊢))scp

  ⍝ Anchor variables to environment slots
  avb←{(((,¨'⍺⍵')↑⍨1↓⍴)⍪⊢)⍺⌷⍨⍤2 0⊢⍺⍺⍳⍺⍺∩⍨(↓(⌽1+∘⍳0⍳⍨⊢)((≢⊢)↑↑)⍤0 1⊢)⊃r ⍵}
  avh←{⊂⍵,(n⍵)((⍺⍺(⍵⍵ avb)⍵){¯1 0+[0](⍴⍺⍺)⊤(,⍺⍺)⍳(⊂⍺),⍵})¨v⍵}
  av ←(⊃⍪/)(+\Fm){⍺((⍺((∪n)Es)⌸⍵)avh(r(1↑⍵)⍪Fs ⍵))⌸⍵}⊢

  ⍝ Fuse Scalar Expressions
  fsf←(∪∘⊃,/)(⊂⊂⍬ ⍬),(⌽¯1↓¯1⌽⊢)¨~∘∪¨∘(⍳∘≢↑¨⊂)⊣
  fsv←↓∘⍉1↓∘↑(↓((,1↑⍉)¨e),⍤0n)fsf((↓1↓⍉)¨e)(↓,⍤0)¨v
  fsh←(⍉⍪)2'S'0 ⍬ ⍬ 0,∘#.pp ¯1⌽(⊂4 12⍴0),fsv
  fss←Em∧('md'∊⍨k)∧(,¨'+-×÷|⌊⌈*⍟○!∧∨⍱⍲<≤=≥>≠')∊⍨(↑v)⌷∘,⍤¯1⍨'md'⍳k
  fse←(⊣(/∘⊢)fss∧⊣)(⊣⊃(⊂⊢),(⊂fsh⍪(1+d),'E','s',3↓⍤1⊢))¨⊂[0]
  fs ←(⊃⍪/)(((((⊃⍪/)(⊂0 9⍴⍬),((2≠/(~⊃),⊢)fss)fse⊢)Es)⍪⍨(~Em)(⌿∘⊢)⊢)¨scp)

  ⍝ Track frame size of functions
  vc ←(⊃⍪/)(((1↓⊢)⍪⍨(1 6↑⊢),(≢∘∪∘n Es),1 ¯2↑⊢)¨scp)

  ⍝ Split functions into type specialized variants
  tde←((¯2↓⊢),(⊂(5 6 7 9 10 11⌷⍨⊣)⌷∘⍉∘⊃y),¯1↑⊢)⍤1
  tdf←(1↓⊢)⍪⍨(,1 3↑⊢),(⊂(⊃n),'ii' 'if' 'in' 'fi' 'ff' 'fn'⊃⍨⊣),(4↓∘,1↑⊢)
  td ←((⊃⍪/)(1↑⊢),∘(⊃,/)(((⍳6)(⊣tdf tde)¨⊂)¨1↓⊢))scp

  ⍝ Wrap top-level Expressions as Init function
  ifn←1 'F' 0 'Init' ⍬ 0,(4 12⍴0)⍬,⍨⊢
  if ←(1↑⊢)⍪(⊢(⌿⍨)Om∧1=d)⍪((A.up⍪⍨∘ifn∘≢∘∪n)⊢(⌿⍨)Em∧1=d)⍪(∨\Fm)(⌿∘⊢)⊢

  ⍝ Flatten Function sub-trees
  fft←(,1↑⊢)(1 'Z',(2↓¯3↓⊣),(n⊢),(y⊢),(⊂2↑∘,1↑∘⍉∘⊃∘e⊢))(¯1↑⊢)
  ff ←((⊃⍪/)(1↑⊢),(((1↑⊢)⍪(((¯1+d),1↓⍤1⊢)1↓⊢)⍪fft)¨1↓⊢))scp

  ⍝ Flatten Scalar sub-trees
  fzt←1 'Y',(2↓¯3↓⊣),(⊂∘∪∘n⊢),(y⊣),∘⊂∘∪((,1↑⍉)¨∘e⊢)
  fzs←(,1↑⊢)(((¯1+d),1↓⍤1⊢)⍪fzt)(⌿∘⊢)
  fz ←((⊃⍪/)(1↑⊢),(((1↑⊢)⍪(2=d)(fzs⍪(1↓∘~⊣)(⌿∘⊢)1↓⊢)⊢)¨1↓⊢))(1,1↓Sm)⊂[0]⊢

  ⍝ Insert function declarations
  fd ←(1↑⊢)⍪((1,'Fd',3↓⊢)⍤1 Fs)⍪1↓⊢
:EndNamespace

