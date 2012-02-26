:Namespace Tests
⍝ === VARIABLES ===

Valid←,⊂,'5'

ValidExp←,⊂1 3⍴0 1 5

ValidSkip←,0


⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX←0 0 3

∇ R←Run;Test;Exp;Skip;Count;Act
 ⎕←'Running Valid Tests...'
 Count←0
 :For Test Exp Skip :InEach Valid ValidExp ValidSkip
     :If ~Skip
         :If ~Exp≡Act←#.HPAPL.Compile Test
             ⎕←'Failed test ',⍕Count
             R←2 1⍴Exp Act
             :Return
         :EndIf
     :EndIf
     Count+←1
 :EndFor
 ⎕←'Tests passed successfully.'
∇

:EndNamespace 