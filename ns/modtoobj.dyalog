 ModToObj←{
     r err←PrintModuleToFile ⍵ ⍺ 1        ⍝ Print to the file given
     1=r:(ErrorMessage⊃err)⎕SIGNAL 99    ⍝ And error out with LLVM errr on failure
     0 0⍴⍬                                ⍝ Best to return something that isn't seen
 }