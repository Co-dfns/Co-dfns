⍝ Output State
:Namespace O
  ⎕IO ⎕ML ⎕WX ← 0 1 3
  A ← ##.A ⋄ S ← ##.S

⍝ Field Names
  nam val ari pos stm typ itp ← 'nam' 'val' 'ari' 'pos' 'stm' 'typ' 'itp'
  inp out fun rgt lft ker itr ← 'inp' 'out' 'fun' 'rgt' 'lft' 'ker' 'itr'

⍝ Relation ← Long Name      Field Names       Field Types
⍝ ───────────────────────────────────────────────────────────────
  C        ← 'Constants'    (nam val        ) A.(str arr        )
  F        ← 'Functions'    (nam ari        ) A.(str nat        )
  B        ← 'Blocks'       (nam pos stm    ) A.(str nat str    )
  K        ← 'Kernels'      (nam itr        ) A.(str nat        )
  Kio      ← 'KernelInOuts' (ker nam inp out) A.(str str bit bit)
  Dc       ← 'DyadicCalls'  (nam fun rgt lft) A.(str str str str)
  Mc       ← 'MonadicCalls' (nam fun rgt    ) A.(str str str    )
  T        ← 'Types'        (nam itp typ    ) A.(str nat nat    )

⍝ Primary Key ← Key Field         Unique amongst
⍝ ───────────────────────────────────────────────
  top∆key     ← nam        A.pkey C F K
  B∆key       ← uid pos    A.pkey B
  Kio∆key     ← ker nam    A.pkey Kio
  Dc∆key      ←            A.pkey Dc
  Mc∆key      ←            A.pkey Mc
  T∆key       ← nam itp    A.pkey T

⍝ Natural Key ← Natural Key        For Relation
⍝ ──────────────────────────────────────────────
  C∆nkey      ← val         A.nkey C

⍝ Foreign Key ← Relations  Fields           Foreign Reference
⍝ ─────────────────────────────────────────────────────────────
  B∆fkey1     ← (B    )    (nam    ) A.fkey (F K        ) (nam)
  B∆fkey2     ← (B    )    (stm    ) A.fkey (B K Dc Mc  ) (nam)
  Kio∆fkey1   ← (Kio  )    (ker    ) A.fkey (K          ) (nam)
  Kio∆fkey2   ← (Kio  )    (nam    ) A.fkey (C Dc Mc S.P) (nam)
  DcMc∆fkey   ← (Dc Mc)    (fun    ) A.fkey (S.P F      ) (nam)
  Dc∆fkey     ← (Dc   )    (rgt lft) A.fkey (C Dc Mc S.P) (nam)
  Mc∆fkey     ← (Mc   )    (rgt    ) A.fkey (C Dc Mc S.P) (nam)
  T∆fkey      ← (T    )    (nam    ) A.fkey (Mc Dc      ) (nam)

⍝ State Descriptor
  _      ← top∆key B∆key Kio∆key Dc∆key Mc∆key T∆key C∆nkey B∆fkey1 B∆fkey2
  _     ,← Kio∆fkey1 Kio∆fkey2 DcMc∆fkey Dc∆fkey Mc∆fkey T∆fkey
  descr  ← (C F B K Kio Dc Mc T) _ 

:EndNamespace

