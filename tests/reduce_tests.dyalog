:Namespace reduce

S01←':Namespace' 'Run←{+/⍵}' ':EndNamespace'
S02←':Namespace' 'Run←{×/⍵}'  ':EndNamespace'
S03←':Namespace' 'Run←{{⍺+⍵}/⍵}' ':EndNamespace'
S04←':Namespace' 'Run←{≠/⍵}' ':EndNamespace'
S05←':Namespace' 'Run←{{⍺≠⍵}/⍵}' ':EndNamespace'
S06←':Namespace' 'Run←{∧/⍵}' ':EndNamespace'
S07←':Namespace' 'Run←{-/⍵}' ':EndNamespace'
S08←':Namespace' 'Run←{÷/⍵}' ':EndNamespace'
S09←':Namespace' 'Run←{|/⍵}' ':EndNamespace'
S10←':Namespace' 'Run←{⌊/⍵}' ':EndNamespace'
S11←':Namespace' 'Run←{⌈/⍵}' ':EndNamespace'
S12←':Namespace' 'Run←{*/⍵}' ':EndNamespace'
S13←':Namespace' 'Run←{!/⍵}' ':EndNamespace'
S14←':Namespace' 'Run←{∧/⍵}' ':EndNamespace'
S15←':Namespace' 'Run←{∨/⍵}' ':EndNamespace'
S16←':Namespace' 'Run←{</⍵}' ':EndNamespace'
S17←':Namespace' 'Run←{≤/⍵}' ':EndNamespace'
S18←':Namespace' 'Run←{=/⍵}' ':EndNamespace'
S19←':Namespace' 'Run←{≥/⍵}' ':EndNamespace'
S20←':Namespace' 'Run←{>/⍵}' ':EndNamespace'
S21←':Namespace' 'Run←{≠/⍵}' ':EndNamespace'
S22←':Namespace' 'Run←{⊤/⍵}' ':EndNamespace'
S23←':Namespace' 'Run←{∪/⍵}' ':EndNamespace'
S24←':Namespace' 'Run←{//⍵}' ':EndNamespace'
S25←':Namespace' 'Run←{⌿/⍵}' ':EndNamespace'
S26←':Namespace' 'Run←{\/⍵}' ':EndNamespace'
S27←':Namespace' 'Run←{⍀/⍵}' ':EndNamespace'
S28←':Namespace' 'Run←{⌽/⍵}' ':EndNamespace'
S29←':Namespace' 'Run←{⊖/⍵}' ':EndNamespace'
S30←':Namespace' 'Run←{X←0⌷⍵ ⋄ {⍺≠⍵}/X}' ':EndNamespace'


'01'('reduce' S01 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'02'('reduce' S01 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'03'('reduce' S01 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'04'('reduce' S02 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴3
'05'('reduce' S02 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'06'('reduce' S01 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'07'('reduce' S03 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'08'('reduce' S03 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'09'('reduce' S03 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'10'('reduce' S04 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'11'('reduce' S05 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9
'12'('reduce' S04 'Run' #.util.GEN∆T1 ⎕THIS) ⍬⍴1
'13'('reduce' S04 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'14'('reduce' S04 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'15'('reduce' S01 'Run' #.util.GEN∆T1 ⎕THIS) 10⍴0 1
'16'('reduce' S04 'Run' #.util.GEN∆T1 ⎕THIS) 10 5 0⍴0 1
'17'('reduce' S04 'Run' #.util.GEN∆T1 ⎕THIS) 10 0 5⍴0 1
'18'('reduce' S06 'Run' #.util.GEN∆T1 ⎕THIS) 10 5 0⍴0 1
'19'('reduce' S06 'Run' #.util.GEN∆T1 ⎕THIS) 10 0 5⍴0 1
'20'('reduce' S05 'Run' #.util.GEN∆T1 ⎕THIS) 10⍴0 1
'21'('reduce' S01 'Run' #.util.GEN∆T1 ⎕THIS) 10 15⍴0 1
'22'('reduce' S05 'Run' #.util.GEN∆T1 ⎕THIS) 5⍴⍳5
'23'('reduce' S06 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'24'('reduce' S07 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'25'('reduce' S08 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'26'('reduce' S09 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'27'('reduce' S10 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'28'('reduce' S11 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'29'('reduce' S12 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'30'('reduce' S13 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'31'('reduce' S14 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'32'('reduce' S15 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'33'('reduce' S16 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'34'('reduce' S17 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'35'('reduce' S18 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'36'('reduce' S19 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'37'('reduce' S20 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'38'('reduce' S21 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'39'('reduce' S22 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'40'('reduce' S23 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'41'('reduce' S24 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'42'('reduce' S25 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'43'('reduce' S26 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'44'('reduce' S27 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'45'('reduce' S28 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'46'('reduce' S29 'Run' #.util.GEN∆T1 ⎕THIS) ⍬
'47'('reduce' S30 'Run' #.util.GEN∆T1 ⎕THIS) 3 3⍴⍳9

:EndNamespace

