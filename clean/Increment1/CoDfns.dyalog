:Namespace CoDfns

  ⎕IO←0

⍝ Copyright (c) 2013 Aaron W. Hsu. All Rights Reserved.
⍝ CoDfns Version 1: Increment 1

⍝ We are compiling the following AST:
⍝ 
⍝ Module ← Def *
⍝ Def    ← Global | Func
⍝ Global ← Var Const
⍝ Func   ← Stmt * 
⍝ Stmt   ← Cond | Expr
⍝ Cond   ← Expr Expr
⍝ Expr   ← Mona | Dyad | Var | Const
⍝ Mona   ← Var Var Expr
⍝ Dyad   ← Var Var Expr Expr 
⍝ Var    ← string
⍝ Const  ← integer | float | char

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

  ⍝ Parsing Interface
  ⍝ 
  ⍝ ⟨Valid ⍵⟩ Z←Parse ⍵ ⟨IsModule Z⟩

  Parse←{
    ⍝ Parse a Variable
    ⍝
    ⍝ ⟨V2P ⍵⟩ Var ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsVar 1⊃τ)⟩
    
      Var←{}
      
    ⍝ Parse a Constant
    ⍝
    ⍝ ⟨V2P ⍵⟩ Const ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsConst 1⊃τ)⟩
    
      Const←{}
      
    ⍝ Parse a Dyadic Expression
    ⍝
    ⍝ ⟨V2P ⍵⟩ Dya ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsDya 1⊃τ)⟩
    
      Dya←{}
      
    ⍝ Parse a Monadic Expression
    ⍝
    ⍝ ⟨V2P ⍵⟩ Mon ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsMon 1⊃τ)⟩
    
      Mon←{}
    
    ⍝ Parse a Parenthesized Expression
    ⍝ 
    ⍝ ⟨V2P ⍵⟩ PExpr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ {1∘⊃WRP'('LIT SEQ Expr SEC (')'LIT) ⍵} ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ 1∘⊃WRP'('LIT SEQ Expr SEC (')'LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ '('LIT SEQ Expr SEC (')'LIT) ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1 1⊃τ)∧('('≡1 0⊃τ)∧(')'≡1 2⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ '('LIT SEQ Expr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1 1⊃τ)∧('('≡1 0⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ '('LIT ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧('('≡0⊃τ)⟩
    ⍝ ⟨(IsExpr 1⊃⍵)∧('('≡0⊃⍵)∧(')'≡2⊃⍵)⟩ 1∘⊃ ⍵ ⟨IsExpr τ⟩
 
      PExpr←{1∘⊃WRP'('LIT SEQ Expr SEC (')'LIT) ⍵}
      
    ⍝ Parse an Expression
    ⍝
    ⍝ IsExpr←{(IsDya ⍵)∨(IsMon ⍵)∨(IsVar ⍵)∨(IsConst ⍵)}
    ⍝ ⟨V2P ⍵⟩ Expr ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ PExpr OR Dya OR Mon OR Var OR Const ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ PExpr OR Dya OR Mon OR Var ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ PExpr OR Dya OR Mon ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Dya ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Mon ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Var ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Const ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsExpr 1⊃τ)⟩
     
      Expr←PExpr OR Dya OR Mon OR Var OR Const
      
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
    
      Cond←{MkCond 0 2⊃¨⊂⍵}WRP(Expr SEQ (':'LIT) SEC Expr)
      
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
    
      Stmt←Cond OR Expr
    
    ⍝ Parse a Function Definition
    ⍝
    ⍝ ⟨V2P ⍵⟩ Func ⍵ ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsFunc 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ MkFunc WRP Stmt ANY ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(IsFunc 1⊃τ)⟩
    ⍝ ⟨V2P ⍵⟩ Stmt ANY ⟨(PR τ)∧(¯1=0⊃τ)∨(¯1≠0⊃τ)∧(∧/IsStmt¨1⊃τ)⟩
    
      Func←MkFunc WRP (Stmt ANY)
    
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

      Module←MkModule WRP (Def ANY)

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
  ⍝ ⟨(1=⍴⍴⍵)∧(∧/IsStmt¨⍵)⟩ MkFunc ⍵ ⟨IsFunc τ⟩
  
  MkFunc←{}
  
  ⍝ Make a conditional statement
  ⍝
  ⍝ ⟨((,2)≡⍴⍵)∧(∧/IsExpr¨⍵)⟩ MkCond ⍵ ⟨IsCond τ⟩
  
  MkCond←{}
  
:EndNamespace

