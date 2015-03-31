:Namespace C
  (⎕IO ⎕ML ⎕WX)←0 1 3
  
  tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
  put←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}

  Fix←{⍺ put⍨##.G.gc ##.T.tt⊃a n←##.P.ps ⍵}
  
:EndNamespace
