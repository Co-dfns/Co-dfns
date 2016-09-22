:Namespace drop

S←':Namespace' 'Run←{⍺↓⍵}' 'R2←{(1⌷⍺)↓⍵}' ':EndNamespace'
F←{⊃((⎕DR ⍵)645)⎕DR ⍵}

'01'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(5 5⍴⍳5)
'02'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	3	(⍳10)
'03'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(5 7)	(⍳35)
'04'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(0 1 0 1 0 0 1 1 1 1 0 0 0)
'05'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(0 1 0 1 0 0)
'06'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	⍬
'07'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(3 10⍴0 1 0 1 0 0 1 1 1 1 0 0 0)
'08'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	5	(5 5⍴⍳5)
'09'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	6	(5 5⍴⍳5)
'10'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(5 5⍴⍳5)
'11'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯5	(5 5⍴⍳5)
'12'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯20	(5 5⍴⍳5)
'13'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯20	(⍳10)
'14'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯3	(⍳10)
'15'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	⍬
'16'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	1	(÷1+5 5⍴⍳5)
'17'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	3	(÷1+⍳10)
'18'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(5 7)	(÷1+⍳35)
'19'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	5	(÷1+5 5⍴⍳5)
'20'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	6	(÷1+5 5⍴⍳5)
'21'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯1	(÷1+5 5⍴⍳5)
'22'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯5	(÷1+5 5⍴⍳5)
'23'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯20	(÷1+5 5⍴⍳5)
'24'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯20	(÷1+⍳10)
'25'('drop' S 'Run' #.util.GEN∆T2 ⎕THIS)	¯3	(÷1+⍳10)
'26'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 1)	(5 5⍴⍳5)
'27'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 3)	(⍳10)
'28'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 5)	(⍳35)
'29'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 5)	(5 5⍴⍳5)
'30'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 6)	(5 5⍴⍳5)
'31'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯1)	(5 5⍴⍳5)
'32'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯5)	(5 5⍴⍳5)
'33'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯20)	(5 5⍴⍳5)
'34'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯20)	(⍳10)
'35'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯3)	(⍳10)
'36'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯1)	⍬
'37'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 1)	⍬
'38'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 1)	(÷1+5 5⍴⍳5)
'39'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 3)	(÷1+⍳10)
'40'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 5)	(÷1+⍳35)
'41'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 5)	(÷1+5 5⍴⍳5)
'42'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 6)	(÷1+5 5⍴⍳5)
'43'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯1)	(÷1+5 5⍴⍳5)
'44'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯5)	(÷1+5 5⍴⍳5)
'45'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯20)	(÷1+5 5⍴⍳5)
'46'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯20)	(÷1+⍳10)
'47'('drop' S 'R2' #.util.GEN∆T2 ⎕THIS)	(F 7 ¯3)	(÷1+⍳10)



:EndNamespace
