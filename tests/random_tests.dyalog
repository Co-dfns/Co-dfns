:Namespace random

S←':Namespace' 'Run←{?⍺⍴⍵}' ':EndNamespace'

MK∆TST←{id ns fn←⍺⍺ ⋄ l r←⍵⍵ ⋄ CS←id ##.codfns.Fix ns ⋄ NS←⎕FIX ns
  nv←l(⍎'NS.',fn)r ⋄ cv←l(⍎'CS.',fn)r
  res←|1-(0.5⌈(⌈/r)÷2)÷(+/÷≢)cv
  _←{0.05≤⍵:⎕←⍵ ⋄ ⍬}res
  ##.UT.expect←(⍴nv)(1) ⋄ (⍴cv)(0.05>res)}

∇Z←ID(NCF GEN∆TST THIS)IN;NS;FN;TC;TMP
 NS TC FN←NCF
 TMP←(NS,ID)TC FN MK∆TST IN
 ⍎'THIS.',NS,'∆',ID,'_TEST←TMP'
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
