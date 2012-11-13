header {* Axiomatic Semantics *}

theory OsmHoare
imports Main
begin

text {*
This section describes the intial elements that are sketchy and rough, 
but that will eventually become the axiomatic semantics of the Osmium language.

First up is a rough datatype of the language syntax of APL.
*}

datatype prog = Prog sig "stmt list"
      and sig = Mon string string "string list"
              | Dya string string string "string list"
              | MonMonOp string string string "string list"
              | MonDyaOp string string string string "string list"
              | DyaMonOp string string string string "string list"
              | DyaDyaOp string string string string string "string list"
     and stmt = EStmt exp | AStmt string exp | FStmt string func
              | OStmt string oper | SelStmt exp exp
              | IfEStmt exp exp | IfAStmt exp string exp | IfFStmt string func
              | IfOStmt string oper | IfSelStmt exp exp
      and exp = ValNat "nat list" | ValInt "int list" | Var string 
              | Zilde | Donut | Alpha | Omega | AlphaAlpha | OmegaOmega
              | MApp func exp | DApp func exp exp 
     and func = AnonF "stmt list" | FNam string | PrimF primf
              | DFFOp oper func func | DFEOp oper func exp 
              | DEFOp oper exp func | DEEOp oper exp exp
              | MFOp oper func | MEOp oper exp
     and oper = AnonO "stmt list" | ONam string | PrimO primo
    and primf = Rho | Iota | Drop | Take | Index | First | Plus | And 
              | Bang | Comma | Ceil | Floor | Circ | Hook | Decode | Encode 
              | Equiv | Times | Div | Enclose | Memb | Eq | Tilde
              | Expand | Exp | Find | GradeD | GradeU | GrThn | LsThn 
              | GrThnEq | LsThnEq | LTack | RTack | Intersect | Union
              | Log | Bar | Domino | Minus | Nand | Nor | NotEq 
              | Or | Power | Replicate | Rot | Transp
    and primo = Each | Reduce | Scan | Axis | Commute | Compose | InProd
              | OutProd | PowerOp | Spawn | Parallel

end
