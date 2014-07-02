PS←{
  0=+/⍵[;1]∊⊂'Token':⎕SIGNAL 2         ⍝ Deal with Eot Stimuli, Table 233
  fl←⊃1 ¯1⍪.↑⊂⍵ ByDepth 2              ⍝ First and last leafs
  ~fl[;1]∧.≡⊂'Token':⎕SIGNAL 2         ⍝ Must be tokens
  nms←':Namespace' ':EndNamespace'     ⍝ Correct names of first and last
  ~nms∧.≡'name'Prop fl:⎕SIGNAL 2       ⍝ Verify correct first and last
  n←'name'Prop ⍵ ByElem'Token'         ⍝ Verify that the Nss and Nse
  2≠+/n∊nms:⎕SIGNAL 2                  ⍝ Tokens never appear more than once
  ns←0 'Namespace' ''(1 2⍴'name' '')   ⍝ New root node is Namespace
  ns⍪←⍵⌿⍨~(⍳≢⍵)∊(0,⊢,¯1+⊢)⍵⍳fl         ⍝ Drop Nse and Nss Tokens
  tm←(1⌷⍉ns)∊⊂'Token'                  ⍝ Mask of Tokens
  sm←tm\('name'Prop tm⌿ns)∊⊂,'⋄'       ⍝ Mask of Separators
  (sm⌿ns)←1 'Line' ''MtA⍴⍨4,⍨+/sm      ⍝ Replace separators by lines, Tbl 219
⍝ XXX: The above does not preserve commenting behavior
  tm←(1⌷⍉ns)∊⊂'Token'                  ⍝ Update token mask
  fm←(,¨'{}')⍳'name'Prop tm⌿ns         ⍝ Which tokens are braces?
  fm←fm⊃¨⊂1 ¯1 0                       ⍝ Convert } → ¯1; { → 1; else → 0
  0≠+/fm:⎕SIGNAL 2                     ⍝ Verify balance
  (0⌷⍉ns)+←2×+\0,¯1↓fm←tm\fm           ⍝ Push child nodes 2 for each depth
  ns fm←(⊂¯1≠fm)⌿¨ns fm                ⍝ Drop closing braces
  fa←1 2⍴'class' 'ambivalent'          ⍝ Function attributes
  fn←(d←fm/0⌷⍉ns),¨⊂'Function' ''fa    ⍝ New function nodes
  fn←fn,[¯0.5]¨(1+d),¨⊂'Line' ''MtA    ⍝ Line node for each function
  hd←(~∨\fm)⌿ns                        ⍝ Unaffected areas of ns
  ns←hd⍪⊃⍪/(⊂MtAST),fn(⊣⍪1↓⊢)¨fm⊂[0]ns ⍝ Replace { with fn nodes
  k←1 Kids ns                          ⍝ Children to examine
  env←⊃ParseFeBindings/k,⊂MtNTE        ⍝ Initial Fe bindings to feed in
  sd←MtAST env                         ⍝ Seed is an empty AST and the env
  ast env←⊃ParseTopLine/⌽(⊂sd),k       ⍝ Parse each child top down
  ((1↑ns)⍪ast)env                      ⍝ Return assembled AST and env
}

