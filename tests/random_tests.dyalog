:Namespace random

S←':Namespace' 'Run←{?⍺⍴⍵}' ':EndNamespace'

MK∆TST←{id cmp ns fn←⍺⍺ ⋄ l r←⍵⍵
  ~(⊂cmp)∊##.codfns.TEST∆COMPILERS:0⊣##.UT.expect←0
  ##.codfns.COMPILER←cmp
  CS←id ##.codfns.Fix ns
  NS←⎕FIX ns
  nv←l(⍎'NS.',fn)r ⋄ cv←l(⍎'CS.',fn)r
  res←|1-(0.5⌈(⌈/r)÷2)÷(+/÷≢)cv
  _←{0.05≤⍵:⎕←⍵ ⋄ ⍬}res
  ##.UT.expect←(⍴nv)(1) ⋄ (⍴cv)(0.05>res)}

∇Z←ID(NCF GEN∆TST THIS)IN;NS;FN;CMP;TC;TMP
 NS TC FN←NCF
 :For CMP :In 'gcc' 'icc' 'vsc' 'pgcc' 'pgi'
    TMP←(NS,ID)CMP TC FN MK∆TST IN
    ⍎'THIS.',NS,'∆',ID,'∆',CMP,'_TEST←TMP'
 :EndFor
 Z←0 0⍴⍬
∇

'01'('random' S 'Run'       GEN∆TST ⎕THIS)	4096	32
'02'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	0	14
'03'('random' S 'Run'       GEN∆TST ⎕THIS)	512	0
'04'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	0	0
'05'('random' S 'Run'       GEN∆TST ⎕THIS)	12345	67890
'06'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	19	1
'07'('random' S 'Run'       GEN∆TST ⎕THIS)	512	(0 0 0 0)
'08'('random' S 'Run' #.util.GEN∆T2 ⎕THIS)	20	(1 1 1 1)

:EndNamespace
