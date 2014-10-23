 put←{tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}⍵
     size←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND tie 83 ⋄ 1:rslt←size⊣⎕NUNTIE tie}