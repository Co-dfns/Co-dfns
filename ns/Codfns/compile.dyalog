 Compile←{
     tks←Tokenize ⍵
     ast names←Parse tks
     ast←KillLines ast
     ast←DropUnreached ast
     ast←LiftConsts ast
     ast←FlattenExprs ast
     ast←AnchorVars ast
     ast←LiftFuncs ast
     ast←ConvPrims ast
     mod←GenLLVM ast
     mod names
 }