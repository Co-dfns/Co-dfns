:Namespace CoDfns

  ⎕IO←0

⍝ Copyright (c) 2013 Aaron W. Hsu. All Rights Reserved.
⍝ CoDfns Version 1: Increment 1

⍝ We are compiling the following AST:
⍝
⍝ Module ← Def *
⍝ Def    ← Global | Func
⍝ Global ← Var Const
⍝ Func   ← Var Stmt *
⍝ Stmt   ← Cond | Expr
⍝ Cond   ← Expr Expr
⍝ Expr   ← Mona | Dyad | Var | Const
⍝ Mona   ← Var Var Expr
⍝ Dyad   ← Var Var Expr Expr
⍝ Var    ← string
⍝ Const  ← integer | float

⍝ Supported Scalar Datatypes: Integer, Float, character

⍝ Helper Predicates
⍝
⍝ PR←{((,2)≡⍴⍵)∧(⍬≡⍴0⊃⍵)∧(0≡∊0⊃⍵)∧(¯1≤0⊃⍵)}

⍝ Primary External Export Specification
⍝
⍝ ⟨(Valid ⍵) ∧ DS≡⎕FIX ⍵⟩
⍝ Fix ⍵
⍝ ⟨(9=⎕NC 'τ') ∧ (DS≡⎕FIX ⍵) ∧ (∀f. (f τ)≡f DS)⟩

  Fix←{
    ⍝ ⟨(Valid ⍵) ∧ DS≡⎕FIX ⍵⟩
    ⍝
      ast←Parse ⍵
    ⍝
    ⍝ ⟨(DS≡⎕FIX ⍵) ∧ IsModule ast⟩
    ⍝
      exp mod←GenerateLlvm ast
    ⍝
    ⍝ ⟨(DS≡⎕FIX ⍵) ∧ (∧/3=DS.⎕NC exp) ∧ (IsLlvmModule mod) ∧ (∀x,y: ∀f∊exp: ((DS.f X)≡LlvmExec mod f X) ∧ (Y DS.f X)≡LlvmExec mod f Y X)⟩
    ⍝
      MakeNs mod
    ⍝
    ⍝ ⟨(9=⎕NC 'τ' ∧ (DS≡⎕FIX ⍵) ∧ (∀f. (f τ)≡f DS)⟩
  }

⍝ AST Constructors and Predicates

  ⍝ Make a module
  ⍝
  ⍝ ⟨(1=⍴⍴⍵)∧(∧/IsDef¨⍵)⟩ MkModule ⍵ ⟨IsModule τ⟩

  MkModule←{}

  ⍝ Make a global
  ⍝
  ⍝ ⟨((,2)≡⍴⍵)∧(IsVar 0⊃⍵)∧(IsConst 1⊃⍵)⟩ MkGlobal ⍵ ⟨IsGlobal τ⟩

  MkGlobal←{}

  ⍝ Make a Function
  ⍝
  ⍝ ⟨((,2)≡⍴⍵)∧(IsVar 0⊃⍵)∧(1=⊃⍴⍴1⊃⍵)∧(∧/IsStmt¨1⊃⍵)⟩ MkFunc ⍵ ⟨IsFunc τ⟩

  MkFunc←{}

  ⍝ Make a conditional statement
  ⍝
  ⍝ ⟨((,2)≡⍴⍵)∧(∧/IsExpr¨⍵)⟩ MkCond ⍵ ⟨IsCond τ⟩

  MkCond←{}

  ⍝ Make a Monadic Expression
  ⍝
  ⍝ ⟨((,3)≡⍴⍵)∧((⍬≡0⊃⍵)∨IsVar 0⊃⍵)∧(IsVar 1⊃⍵)∧(IsExpr 2⊃⍵)⟩ MkMona ⍵ ⟨IsMona τ⟩

  MkMona←{}

  ⍝ Make a Dyadic Expression
  ⍝
  ⍝ ⟨((,4)≡⍴⍵)∧((⍬≡0⊃⍵)∨IsVar 0⊃⍵)∧(IsExpr 1⊃⍵)∧(IsVar 2⊃⍵)∧(IsExpr 3⊃⍵)⟩ MkDyad ⍵ ⟨IsDyad τ⟩

  MkDyad←{}
  
  ⍝ Make a Variable
  ⍝
  ⍝ ⟨((,1)≡⍴⍴1⊃τ)∧(∧/' '=∊1⊃τ)⟩ MkVar ⍵ ⟨IsVar ⍵⟩
  
  MkVar←{}

⍝ Parsing Combinators

  ⍝ Parse zero or more items
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q 1⊃τ)⟩
  ⍝ →
  ⍝ ⟨P ⍵⟩ F ANY ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(1=⍴⍴1⊃τ)∧(∧/Q¨1⊃τ)⟩

  ANY←{}

  ⍝ Parse one item or the other
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧Q ⍵⟩
  ⍝ ⟨P ⍵⟩ G ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧R ⍵⟩
  ⍝ →
  ⍝ ⟨P ⍵⟩ F OR G ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q ⍵)∨(R ⍵)⟩

  OR←{}

  ⍝ Wrap the returned object of a parser
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q 1⊃τ)⟩
  ⍝ ∧ ⟨Q ⍵⟩ C ⍵ ⟨Q1 τ⟩
  ⍝ → ⟨P ⍵⟩ C WRP F ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q1 τ)⟩

  WRP←{}

  ⍝ Sequencing
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q 1⊃τ)⟩
  ⍝ ⟨P ⍵⟩ G ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(R 1⊃τ)⟩
  ⍝ →
  ⍝ ⟨P ⍵⟩
  ⍝   F SEQ G ⍵
  ⍝ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,2)≡⍴1⊃τ)∧(Q 1 0⊃τ)∧(R 1 1⊃τ)⟩

  SEQ←{}

  ⍝ Sequencing with Catenation
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(1=⍴⍴1⊃τ)∧(Q 1⊃τ)⟩
  ⍝ ⟨P ⍵⟩ G ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(R 1⊃τ)⟩
  ⍝ →
  ⍝ ⟨P ⍵⟩ F SEC G ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(1=⍴⍴1⊃τ)∧(Q ¯1↓1⊃τ)∧(R ⊃¯1↑1⊃τ)⟩

  SEC←{}

  ⍝ Optional Parsing
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(1=⍴⍴1⊃τ)∧(Q 1⊃τ)⟩
  ⍝ →
  ⍝ ⟨P ⍵⟩ F OPT ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(1=⍴⍴1⊃τ)∧(⍬≡1⊃τ)∨(Q 1⊃τ)⟩

  OPT←{}
 
⍝ Parsing Classes

  ALPHA←{}
  ALNUM←{}

⍝ Parsing Interface
⍝
⍝ ⟨Valid ⍵⟩ Z←Parse ⍵ ⟨IsModule Z⟩

  Parse←{
    ⍝ Parse a Variable
    ⍝
    ⍝ ⟨V2P ⍵⟩ Var ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsVar 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ MkVar WRP (ALPHA SEC (ALNUM ANY)) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsVar 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ ALPHA SEC (ALNUM ANY) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,1)≡⍴⍴1⊃τ)∧(∧/' '=∊1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ ALNUM ANY ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,1)≡⍴⍴1⊃τ)∧(∧/' '=∊1⊃τ)∨(⍬≡1⊃τ)⟩

      Var←MkVar WRP (ALPHA SEC (ALNUM ANY))
      
    ⍝ Parse an Integer
    ⍝ 
    ⍝ ⟨V2P ⍵⟩ Int ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(83=⎕DR 1⊃τ)⟩
    
      Int←{}
    
    ⍝ Parse a Float
    ⍝
    ⍝ ⟨V2P ⍵⟩ Float ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(645=⎕DR 1⊃τ)⟩
    
      Float←{}

    ⍝ Parse a Constant
    ⍝
    ⍝ IsConst←{(IsInt ⍵)∨(IsFloat ⍵)}
    ⍝ ⟨V2P ⍵⟩ Const ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsConst 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Int OR Float ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsConst 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Int ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsConst 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Float ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsConst 1⊃τ)⟩

      Const←Int OR Float

    ⍝ Parse a Parenthesized Expression
    ⍝
    ⍝ ⟨V2P ⍵⟩ PExpr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ {1∘⊃WRP'('LIT SEQ Expr SEC (')'LIT) ⍵} ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ 1∘⊃WRP'('LIT SEQ Expr SEC (')'LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ '('LIT SEQ Expr SEC (')'LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1 1⊃τ)∧('('≡1 0⊃τ)∧(')'≡1 2⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ '('LIT SEQ Expr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1 1⊃τ)∧('('≡1 0⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ '('LIT ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧('('≡0⊃τ)⟩
    ⍝ ⟨(IsExpr 1⊃⍵)∧('('≡0⊃⍵)∧(')'≡2⊃⍵)⟩ 1∘⊃ ⍵ ⟨IsExpr τ⟩

      PExpr←{1∘⊃WRP'('LIT SEQ Expr SEC(')'LIT)⍵}

    ⍝ Parse an Atom Expression
    ⍝
    ⍝ ⟨V2P ⍵⟩ Atom ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Var OR Const OR PExpr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Var OR Const ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ See Expr for other Assertions

      Atom←Var OR Const OR PExpr

    ⍝ Parse an Assignment Prefix
    ⍝
    ⍝ ⟨V2P ⍵⟩ Assgn ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsVar 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ 0∘⊃WRP (Var SEQ ('←'LIT)) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsVar 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Var SEQ ('←'LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,2)≡⍴1⊃τ)∧(IsVar 1 0⊃τ)∧('←'≡1 1⊃τ)⟩
    ⍝ ⟨((,2)≡⍴⍵)∧(IsVar 0⊃⍵)∧('←'≡1⊃⍵)⟩ 0∘⊃ ⍵ ⟨IsVar τ⟩

      Assgn←0∘⊃WRP(Var SEQ('←'LIT))

    ⍝ Parse a Dyadic Expression
    ⍝
    ⍝ ⟨V2P ⍵⟩ Dyad ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsDyad 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ {MkDyad WRP (Assgn OPT SEQ Atom SEC Var SEC Expr) ⍵} ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsDyad 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ MkDyad WRP (Assgn OPT SEQ Atom SEC Var SEC Expr) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsDyad 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Assgn OPT SEQ Atom SEC Var SEC Expr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,4)≡⍴1⊃τ)∧((⍬≡1 0⊃τ)∨IsVar 1 0⊃τ)∧(IsExpr 1 1⊃τ)∧(IsVar 1 2⊃τ)∧(IsExpr 1 3⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Assgn OPT SEQ Atom SEC Var ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,4)≡⍴1⊃τ)∧((⍬≡1 0⊃τ)∨IsVar 1 0⊃τ)∧(IsExpr 1 1⊃τ)∧(IsVar 1 2⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Assgn OPT SEQ Atom ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,4)≡⍴1⊃τ)∧((⍬≡1 0⊃τ)∨IsVar 1 0⊃τ)∧(IsExpr 1 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Assgn OPT ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,4)≡⍴1⊃τ)∧(⍬≡1 0⊃τ)∨(IsVar 1 0⊃τ)⟩

      Dyad←{MkDyad WRP(Assgn OPT SEQ Atom SEC Var SEC Expr)⍵}

    ⍝ Parse a Monadic Expression
    ⍝
    ⍝ ⟨V2P ⍵⟩ Mona ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsMona 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ {MkMona WRP (Assgn OPT SEQ Var SEC Expr) ⍵} ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsMona 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ MkMona WRP (Assgn OPT SEQ Var SEC Expr) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsMona 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Assgn OPT SEQ Var SEC Expr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,3)≡⍴1⊃τ)∧((⍬≡1 0⊃τ)∨IsVar 1 0⊃τ)∧(IsVar 1 1⊃τ)∧(IsExpr 1 2⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Assgn OPT SEQ Var ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,2)≡⍴1⊃τ)∧((⍬≡1 0⊃τ)∨IsVar 1 0⊃τ)∧(IsVar 1 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Assgn OPT ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((⍬≡1 0⊃τ)∨IsVar 1 0⊃τ)⟩

      Mona←{MkMona WRP(Assgn OPT SEQ Var SEC Expr)⍵}

    ⍝ Parse an Expression
    ⍝
    ⍝ IsExpr←{(IsDyad ⍵)∨(IsMona ⍵)∨(IsVar ⍵)∨(IsConst ⍵)}
    ⍝ ⟨V2P ⍵⟩ Expr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Dyad OR Mona OR Atom ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Dyad OR Mona ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Dyad ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Mona ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Var ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Const ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩

      Expr←Dyad OR Mona OR Atom

    ⍝ Parse a Conditional Statement
    ⍝
    ⍝ ⟨V2P ⍵⟩ Cond ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsCond 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ {MkCond 0 2⊃¨⊂⍵}WRP(Expr SEQ (':'LIT) SEC Expr) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsCond 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Expr SEQ (':'LIT) SEC Expr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,3)≡⍴τ)∧(∧/IsExpr¨1(0 2)⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Expr SEQ (':' LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,2)≡⍴τ)∧(IsExpr 1 0⊃τ)∧(':'≡1 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ ':' LIT ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(':'≡1⊃τ)⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(∧/IsExpr¨(⊂0 2)⊃⍵)⟩ {MkCond 0 2⊃¨⊂⍵} ⍵ ⟨IsCond τ⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(∧/IsExpr¨(⊂0 2)⊃⍵)⟩ MkCond 0 2⊃¨⊂⍵ ⟨IsCond τ⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(∧/IsExpr¨(⊂0 2)⊃⍵)⟩ 0 2⊃¨⊂⍵ ⟨((,2)≡⍴τ)∧(∧/IsExpr¨τ)⟩

      Cond←{MkCond 0 2⊃¨⊂⍵}WRP(Expr SEQ (':'LIT)SEC Expr)

    ⍝ Parse a Global Constant
    ⍝
    ⍝ ⟨V2P ⍵⟩ Global ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsGlobal 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ {MkGlobal 0 2⊃¨⊂⍵}WRP(Var SEQ ('←' LIT) SEC Const) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsGlobal 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Var SEQ ('←' LIT) SEC Const ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,3)≡⍴τ)∧(IsVar 1 0⊃τ)∧(IsConst 1 2⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Var SEQ ('←' LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧((,2)≡⍴τ)∧(IsVar 1 0⊃τ)∧('←'≡1 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ '←' LIT ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧('←'≡1⊃τ)⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(IsVar 0⊃⍵)∧(IsConst 2⊃⍵)⟩ {MkGlobal 0 2⊃¨⊂⍵} ⍵ ⟨IsGlobal τ⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(IsVar 0⊃⍵)∧(IsConst 2⊃⍵)⟩ MkGlobal 0 2⊃¨⊂⍵ ⟨IsGlobal τ⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(IsVar 0⊃⍵)∧(IsConst 2⊃⍵)⟩ 0 2⊃¨⊂⍵ ⟨((,2)≡⍴τ)∧(IsVar 0⊃τ)∧(IsConst 1⊃τ)⟩

      Global←{MkGlobal 0 2⊃¨⊂⍵}WRP(Var SEQ ('←' LIT) SEC Const)

    ⍝ Parse a Statement
    ⍝
    ⍝ IsStmt←{(IsCond ⍵)∨(IsExpr ⍵)}
    ⍝ ⟨V2P ⍵⟩ Stmt ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsStmt 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Cond OR Expr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsCond 1⊃τ)∨(IsExpr 1⊃τ)⟩

      Stmt←Cond OR Expr DLM WSNL

    ⍝ Parse a Function Definition
    ⍝
    ⍝ ⟨V2P ⍵⟩ Func ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsFunc 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ {MkFunc ⍵[0 3]}WRP(Var SEQ ('←'LIT) SEC ('{'LIT) SEC (Stmt ANY) SEC ('}'LIT)) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsFunc 1⊃τ)⟩
    ⍝ Q←{((,5)≡⍴⍵)∧(IsVar 0⊃⍵)∧('←'≡1⊃⍵)∧('{'≡2⊃⍵)∧(1=⊃⍴⍴3⊃⍵)∧(∧/IsStmt¨3⊃⍵)∧('}'≡4⊃⍵)}
    ⍝ ⟨V2P ⍵⟩ Var SEQ ('←'LIT) SEC ('{'LIT) SEC (Stmt ANY) SEC ('}'LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q 1⊃τ)⟩
    ⍝ Q1←{((,4)≡⍴⍵)∧(IsVar 0⊃⍵)∧('←'≡1⊃⍵)∧('{'≡2⊃⍵)∧(1=⊃⍴⍴3⊃⍵)∧(∧/IsStmt¨3⊃⍵)}
    ⍝ ⟨V2P ⍵⟩ Var SEQ ('←'LIT) SEC ('{'LIT) SEC (Stmt ANY) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q1 1⊃τ)⟩
    ⍝ Q2←{((,3)≡⍴⍵)∧(IsVar 0⊃⍵)∧('←'≡1⊃⍵)∧('{'≡2⊃⍵)}
    ⍝ ⟨V2P ⍵⟩ Var SEQ ('←'LIT) SEC ('{'LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q2 1⊃τ)⟩
    ⍝ Q3←{((,2)≡⍴⍵)∧(IsVar 0⊃⍵)∧('←'≡1⊃⍵)}
    ⍝ ⟨V2P ⍵⟩ Var SEQ ('←'LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(Q3 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Stmt ANY ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(1=⊃⍴⍴1⊃τ)∧(∧/IsStmt¨1⊃τ)⟩
    ⍝ ⟨Q ⍵⟩ {MkFunc ⍵[0 3]} ⍵ ⟨IsFunc τ⟩
    ⍝ ⟨Q ⍵⟩ MkFunc ⍵[0 3] ⟨IsFunc τ⟩
    ⍝ ⟨Q ⍵⟩ ⍵[0 3] ⟨((,2)≡⍴τ)∧(IsVar 0⊃τ)∧(1=⊃⍴⍴1⊃τ)∧(∧/IsStmt¨1⊃τ)⟩
 
      Func←{MkFunc ⍵[0 3]}WRP(Var SEQ ('←'LIT) SEC ('{'LIT) SEC (Stmt ANY) SEC ('}'LIT))

    ⍝ Parse a Definition
    ⍝
    ⍝ (IsDef ⍵)≡(IsGlobal ⍵)∨(IsFunc ⍵)
    ⍝ ⟨V2P ⍵⟩ Def ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsDef 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Global OR Func ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsGlobal 1⊃τ)∨(IsFunc 1⊃τ)⟩

      Def←Global OR Func

    ⍝ Parse a Module from input
    ⍝
    ⍝ ⟨Valid ⍵⟩ Module ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧IsModule 1⊃τ⟩
    ⍝ ⟨Valid ⍵⟩ MkModule WRP (ParseDef ANY) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧IsModule 1⊃τ⟩
    ⍝ ⟨V2P ⍵⟩ ParseDef ANY ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(1=⍴⍴1⊃τ)∧(∧/IsDef¨1⊃τ)⟩

      Module←MkModule WRP(Def ANY)

    ⍝ ⟨Valid ⍵⟩
    ⍝
      z o t←Module ⍵
    ⍝
    ⍝ ⟨(0≠z) ∨ (0=z) ∧ IsModule o⟩
    ⍝
      0=z: o ⍝ ⟨IsModule τ⟩
    ⍝
    ⍝ ⟨0≠z⟩
    ⍝
      ⎕SIGNAL 2
    ⍝
    ⍝ ⟨0⟩
  }

:EndNamespace

