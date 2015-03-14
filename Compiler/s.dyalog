⍝ Essential State
:Namespace S
  ⎕IO ⎕ML ⎕WX ← 0 1 3
  A ← ##.A

⍝ Field Names
  uid val nam fun rgt lft res←'uid' 'val' 'nam' 'fun' 'rgt' 'lft' 'res'

⍝ Relations
⍝     Long Name     Field Names       Field Types
⍝ ───────────────────────────────────────────────────────
  L ← 'Literals'    (uid val)         A.(nat arr)
  P ← 'Primitives'  (uid nam)         A.(nat str)
  M ← 'Monadics'    (uid fun rgt)     A.(nat nat nat)
  D ← 'Dyadics'     (uid fun rgt lft) A.(nat nat nat nat)
  U ← 'UserDefined' (uid res)         A.(nat nat)
  N ← 'Names'       (uid nam)         A.(nat str)

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
⍝            Foreign Key        Referencing
⍝ ─────────────────────────────────────────────  
  M∆fkey   ← fun rgt     A.fkey L P M D U
  D∆fkey   ← fun rgt lft A.fkey L P M D U
  U∆fkey   ← res         A.fkey L P M D U
  N∆fkey   ← uid         A.fkey L P M D U

⍝ State Descriptor
  _ ← node∆key N∆key L∆nkey P∆nkey M∆nkey D∆nkey U∆nkey N∆nkey
  descr ← (L P M D U N) (_ , M∆fkey D∆fkey U∆fkey N∆fkey)
  
:EndNamespace
