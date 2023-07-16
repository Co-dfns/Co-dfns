:Namespace t0016

catenate←{⍺,⍵}

catfirst←{⍺⍪⍵}

depth←{≡⍵}

drop∆R1←{⍺↓⍵} ⋄ drop∆R2←{(1⌷⍺)↓⍵} ⋄ drop∆R3←{5↓⍵}

encode←{⍺⊤⍵} ⋄ encode∆Ovr←{⍺⊤0⌷⍵}

enlist←{∊⍵}

expand←{⍺\⍵}

expandfirst←{⍺⍀⍵}

find←{⍺⍷⍵}

first←{⊃⍵}

gradedown←{⍒⍵}

gradeup←{⍋⍵}

identity←{⊢⍵}

index∆R1←{⍺⌷⍵} ⋄ index∆R2←{1⌷⍵} ⋄ index∆R3←{0} ⋄ index∆R4←{0}
⍝ index∆R3←{X←⍳⍺ ⋄ Y←⍳⍺ ⋄ X Y⌷⍵}
⍝ index∆R4←{R←0⌷⍺ ⋄ C←1⌷⍺ ⋄ I←R↑2↓⍺ ⋄ J←C↑(2+R)↓⍺ ⋄ I J⌷⍵}

indexgen←{⍳⍵}

indexof←{⍺⍳⍵}

intersection←{⍺∩⍵}

left←{⍺⊣⍵}

match←{⍺≡⍵}

matinv←{⌹⍵}

matdiv←{⍺⌹⍵}

membership←{⍺∊⍵}

mix←{↑⍵}

notmatch←{⍺≢⍵}

pick←{⍺⊃⍵}

random←{?⍺⍴⍵}

ravel←{,⍵}

reverse∆R1←{⌽⍵} ⋄ reverse∆R2←{⌽⌽⌽⍵}

revfirst∆R1←{⊖⍵} ⋄ revfirst∆R2←{⊖⊖⊖⍵}

right←{⍺⊢⍵}

rotate∆S←{⍺⌽⍵} ⋄ rotate∆R←{7⌽⍵} ⋄ rotate∆T←{¯1⌽⍵}
rotate∆U←{X←0⌷⍺ ⋄ Y←0⌷⍵ ⋄ X⌽Y}

rotfirst∆S←{⍺⊖⍵} ⋄ rotfirst∆R←{7⊖⍵} ⋄ rotfirst∆T←{¯1⊖⍵}
rotfirst∆U←{X←0⌷⍺ ⋄ Y←0⌷⍵ ⋄ X⊖Y}

same←{⊣⍵}

shape←{⍴⍵} ⋄ shape∆R2←{⍴0⌷⍵}

split←{↓⍵}

table←{⍪⍵} ⋄ table∆R2←{⍪0⌷⍵}

take∆R1←{⍺↑⍵} ⋄ take∆R2←{(1⌷⍺)↑⍵}

tally←{≢⍵}

transpose∆R1←{⍉⍵} ⋄ transpose∆R2←{⍺⍉⍵}

union←{⍺∪⍵}

unique←{∪⍵}

:EndNamespace
