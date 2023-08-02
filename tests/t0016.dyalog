:Namespace t0016

catfirst←{⍺⍪⍵}

find←{⍺⍷⍵}

gradedown←{⍒⍵}

gradeup←{⍋⍵}

indexof←{⍺⍳⍵}

intersection←{⍺∩⍵}

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

tally←{≢⍵}

transpose∆R1←{⍉⍵} ⋄ transpose∆R2←{⍺⍉⍵}

union←{⍺∪⍵}

unique←{∪⍵}

:EndNamespace
