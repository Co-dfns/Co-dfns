⍝ Essential State
:Namespace S
  ⎕IO ⎕ML ⎕WX ← 0 1 3
  A ← ##.A

⍝ Data types
  bit nat int flt str arr ← ⍳6

⍝ Field Names
  uid val nam fun rgt lft res←'uid' 'val' 'nam' 'fun' 'rgt' 'lft' 'res'

⍝ Relations
⍝     Long Name     Field Names       Field Types
⍝ ─────────────────────────────────────────────────────
  L ← 'Literals'    (uid val)         (nat arr)
  P ← 'Primitives'  (uid nam)         (nat str)
  M ← 'Monadics'    (uid fun rgt)     (nat nat nat)
  D ← 'Dyadics'     (uid fun rgt lft) (nat nat nat nat)
  U ← 'UserDefined' (uid res)         (nat nat)
  N ← 'Names'       (uid nam)         (nat str)

⍝ Primary Keys
⍝            Key Field          Unique amongst
⍝ ─────────────────────────────────────────────  
  node∆key ← uid         A.pkey L P M D U
  N∆key    ← uid         A.pkey N

⍝ Natural Keys
⍝            Natural Key        For Relation
⍝ ─────────────────────────────────────────────  
  L∆nkey   ← val         A.nkey L
  P∆nkey   ← nam         A.nkey P
  M∆nkey   ← fun rgt     A.nkey M
  D∆nkey   ← fun rgt lft A.nkey D
  U∆nkey   ← res         A.nkey U
  N∆nkey   ← nam         A.nkey N

⍝ Foreign Keys
⍝          Foreign Key          Referencing
⍝ ─────────────────────────────────────────────  
  M∆fkey ← fun rgt       A.fkey L P M D U
  D∆fkey ← fun rgt lft   A.fkey L P M D U
  U∆fkey ← res           A.fkey L P M D U
  N∆fkey ← uid           A.fkey L P M D U
  
:EndNamespace
