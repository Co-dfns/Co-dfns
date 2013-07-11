:Namespace PARSE

    ⎕IO←0

    P←#.PEG

    ALPHA←P.ALPHA
    ALNUM←P.ALNUM
    BLANK←P.BLANK
    DIGIT←P.DIGIT
    LNBRK←P.LNBRK
    LOWER←P.LOWER
    UPPER←P.UPPER
    WHITE←P.WHITE

    Dot     ← '.'P.LIT
    Out     ← '∘.'P.LIT
    Jot     ← '∘'P.LIT
    Pow     ← '⍣'P.LIT
    Zil     ← '⍬'P.LIT
    Neg     ← '¯'P.LIT
    VarStr  ← ALPHA P.SEQ (ALNUM P.ANY) P.LEX
    OpArg   ← '⍺⍺'P.LIT P.OR ('⍵⍵'P.LIT)
    FnArg   ← '⍺'P.LIT P.OR ('⍵'P.LIT)
    Var     ← VarStr P.OR OpArg P.OR FnArg
    IntStr  ← DIGIT P.PLS
    IntPart ← (Neg P.OPT) P.SEQ IntStr
    DecPart ← Dot P.SEQ IntStr P.OPT
    ExpPart ← 'e'P.LIT P.SEQ IntPart P.OPT
    Num     ← ⍎∘⊃∘(,/)P.WRP(IntPart P.SEQ DecPart P.SEQ ExpPart)
    Split   ← '⋄'P.LIT P.OR LNBRK P.PLS
    
    ArrNum  ← Num P.PLS


:EndNamespace