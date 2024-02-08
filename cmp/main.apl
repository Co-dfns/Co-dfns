(⎕IO ⎕ML ⎕WX ⎕CT)←0 1 3 0
VERSION←5 4 0
AF∆PREFIX←'/opt/arrayfire'
VS∆PATH←'\Program Files\Microsoft Visual Studio\2022\Community'
f∆←'ptknfsrdx'
N∆←' ABCEFGHKLMNOPSTVZ'
(A B C E F G H K L M N O P S T V Z)←1+⍳17

Fix←{
	_←          TK ⍵⊣⍞←'T'
	_←a n s src←PS _⊣⍞←'P'
	_←          TT _⊣⍞←'C'
	_←        ⍺ GC _⊣⍞←'G'
	_←        ⍺ CC _⊣⍞←'B'
		  n NS _⊣⍞←'L'
}

∇Z←Help _
 Z←'Usage: <object> <target>'
∇

∇r←List
 r←⎕NS¨1⍴⊂⍬ ⋄ r.Name←,¨⊂'Compile' ⋄ r.Group←⊂'CODFNS'
 r[0].Desc←'Compile an object using Co-dfns'
 r.Parse←⊂'2S '
∇

∇ Run(cmd input);Convert;in;out;src
 ⍝ Parameters
 ⍝      AF∆LIB        ArrayFire backend to use
  Convert←{⍺(⎕SE.SALT.Load'[SALT]/lib/NStoScript -noname').ntgennscode ⍵}
  in out←input.Arguments
  src←(⊂':Namespace ',out),2↓0 0 0 out Convert ##.THIS.⍎in
  →0⌿⍨'Compile'≢cmd
  {##.THIS.⍎out,'←⍵'}out Fix src⊣⎕EX'##.THIS.',out
∇

