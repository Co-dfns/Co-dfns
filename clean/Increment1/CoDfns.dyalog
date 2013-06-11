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
  ⍝ ⟨(9=⎕NC '𝜏') ∧ (DS≡⎕FIX ⍵) ∧ (∀f. (f 𝜏)≡f DS)⟩

  Fix←{
    ⍝ ⟨(Valid ⍵) ∧ DS≡⎕FIX ⍵⟩
    ⍝
      ast←Parse ⍵
    ⍝ 
    ⍝ ⟨(DS≡⎕FIX ⍵) ∧ IsModule ast⟩
    ⍝ 
      exp mod←GenerateLlvm ast
    ⍝ 
    ⍝ ⟨(DS≡⎕FIX ⍵) ∧ (∧/3=DS.⎕NC exp) ∧ (IsLlvmModule mod)
    ⍝   ∧ (∀x,y: ∀f∊exp: ((DS.f X)≡LlvmExec mod f X)
    ⍝      ∧ (Y DS.f X)≡LlvmExec mod f Y X)⟩
    ⍝
      MakeNs mod
    ⍝ 
    ⍝ ⟨(9=⎕NC '𝜏' ∧ (DS≡⎕FIX ⍵) ∧ (∀f. (f 𝜏)≡f DS)⟩
  }

  ⍝ Parsing Interface
  ⍝ 
  ⍝ ⟨Valid ⍵⟩ Z←Parse ⍵ ⟨IsModule Z⟩

  Parse←{
    ⍝ Parse a Variable
    ⍝
    ⍝ ⟨V2P ⍵⟩ Var ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsVar 1⊃𝜏)⟩
    
      Var←{}
      
    ⍝ Parse a Constant
    ⍝
    ⍝ ⟨V2P ⍵⟩ Const ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsConst 1⊃𝜏)⟩
    
      Const←{}
      
    ⍝ Parse an Expression
    ⍝
    ⍝ ⟨V2P ⍵⟩ Expr ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsExpr 1⊃𝜏)⟩
    
      Expr←{}
      
    ⍝ Parse a Conditional Statement
    ⍝ 
    ⍝ ⟨V2P ⍵⟩ Cond ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsCond 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ 
    ⍝   {MkCond 0 2⊃¨⊂⍵}WRP(Expr SEQ (':'LIT) SEC Expr) ⍵
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsCond 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ 
    ⍝   Expr SEQ (':'LIT) SEC Expr ⍵ 
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧((,3)≡⍴𝜏)∧(∧/IsExpr¨1(0 2)⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩
    ⍝   Expr SEQ (':' LIT) ⍵
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧((,2)≡⍴𝜏)∧(IsExpr 1 0⊃𝜏)∧(':'≡1 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ ':' LIT ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(':'≡1⊃𝜏)⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(∧/IsExpr¨(⊂0 2)⊃⍵)⟩ 
    ⍝   {MkCond 0 2⊃¨⊂⍵} ⍵ 
    ⍝ ⟨IsCond 𝜏⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(∧/IsExpr¨(⊂0 2)⊃⍵)⟩ MkCond 0 2⊃¨⊂⍵ ⟨IsCond 𝜏⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(∧/IsExpr¨(⊂0 2)⊃⍵)⟩ 
    ⍝   0 2⊃¨⊂⍵ 
    ⍝ ⟨((,2)≡⍴𝜏)∧(∧/IsExpr¨𝜏)⟩
    
      Cond←{MkCond 0 2⊃¨⊂⍵}WRP(Expr SEQ (':'LIT) SEC Expr)
      
    ⍝ Parse a Global Constant
    ⍝
    ⍝ ⟨V2P ⍵⟩ Global ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsGlobal 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ 
    ⍝   {MkGlobal 0 2⊃¨⊂⍵}WRP(Var SEQ ('←' LIT) SEC Const) ⍵
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsGlobal 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ 
    ⍝   Var SEQ ('←' LIT) SEC Const ⍵ 
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧((,3)≡⍴𝜏)∧(IsVar 1 0⊃𝜏)∧(IsConst 1 2⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩
    ⍝   Var SEQ ('←' LIT) ⍵
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧((,2)≡⍴𝜏)∧(IsVar 1 0⊃𝜏)∧('←'≡1 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ '←' LIT ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧('←'≡1⊃𝜏)⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(IsVar 0⊃⍵)∧(IsConst 2⊃⍵)⟩ 
    ⍝   {MkGlobal 0 2⊃¨⊂⍵} ⍵ 
    ⍝ ⟨IsGlobal 𝜏⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(IsVar 0⊃⍵)∧(IsConst 2⊃⍵)⟩ MkGlobal 0 2⊃¨⊂⍵ ⟨IsGlobal 𝜏⟩
    ⍝ ⟨((,3)≡⍴⍵)∧(IsVar 0⊃⍵)∧(IsConst 2⊃⍵)⟩ 
    ⍝   0 2⊃¨⊂⍵ 
    ⍝ ⟨((,2)≡⍴𝜏)∧(IsVar 0⊃𝜏)∧(IsConst 1⊃𝜏)⟩
    
      Global←{MkGlobal 0 2⊃¨⊂⍵}WRP(Var SEQ ('←' LIT) SEC Const)
      
    ⍝ Parse a Statement
    ⍝
    ⍝ IsStmt←{(IsCond ⍵)∨(IsExpr ⍵)}
    ⍝ ⟨V2P ⍵⟩ Stmt ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsStmt 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ 
    ⍝   Cond OR Expr ⍵ 
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsCond 1⊃𝜏)∨(IsExpr 1⊃𝜏)⟩
    
      Stmt←Cond OR Expr
    
    ⍝ Parse a Function Definition
    ⍝
    ⍝ ⟨V2P ⍵⟩ Func ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsFunc 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ MkFunc WRP Stmt ANY ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsFunc 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ Stmt ANY ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(∧/IsStmt¨1⊃𝜏)⟩
    
      Func←MkFunc WRP (Stmt ANY)
    
    ⍝ Parse a Definition
    ⍝ 
    ⍝ (IsDef ⍵)≡(IsGlobal ⍵)∨(IsFunc ⍵)
    ⍝ ⟨V2P ⍵⟩ Def ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsDef 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ 
    ⍝   Global OR Func ⍵ 
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(IsGlobal 1⊃𝜏)∨(IsFunc 1⊃𝜏)⟩

      Def←Global OR Func

    ⍝ Parse a Module from input
    ⍝
    ⍝ ⟨Valid ⍵⟩ Module ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧IsModule 1⊃𝜏⟩
    ⍝ ⟨Valid ⍵⟩
    ⍝   MkModule WRP (ParseDef ANY) ⍵ 
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧IsModule 1⊃𝜏⟩
    ⍝ ⟨V2P ⍵⟩ 
    ⍝   ParseDef ANY ⍵ 
    ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(1=⍴⍴1⊃𝜏)∧(∧/IsDef¨1⊃𝜏)⟩

      Module←MkModule WRP (Def ANY)

    ⍝ ⟨Valid ⍵⟩
    ⍝
      z o t←Module ⍵
    ⍝
    ⍝ ⟨(0≠z) ∨ (0=z) ∧ IsModule o⟩
    ⍝
      0=z: o ⍝ ⟨IsModule 𝜏⟩
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
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(Q 1⊃𝜏)⟩
  ⍝ → 
  ⍝ ⟨P ⍵⟩ F ANY ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(1=⍴⍴1⊃𝜏)∧(∧/Q¨1⊃𝜏)⟩

  ANY←{}
  
  ⍝ Parse one item or the other
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧Q ⍵⟩
  ⍝ ⟨P ⍵⟩ G ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧R ⍵⟩
  ⍝ →
  ⍝ ⟨P ⍵⟩ F OR G ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(Q ⍵)∨(R ⍵)⟩
  
  OR←{}

  ⍝ Wrap the returned object of a parser
  ⍝ 
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(Q 1⊃𝜏)⟩
  ⍝ ∧ ⟨Q ⍵⟩ C ⍵ ⟨Q1 𝜏⟩
  ⍝ → ⟨P ⍵⟩ C WRP F ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(Q1 𝜏)⟩

  WRP←{}
  
  ⍝ Sequencing
  ⍝ 
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(Q 1⊃𝜏)⟩
  ⍝ ⟨P ⍵⟩ G ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(R 1⊃𝜏)⟩
  ⍝ → 
  ⍝ ⟨P ⍵⟩ 
  ⍝   F SEQ G ⍵ 
  ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧((,2)≡⍴1⊃𝜏)∧(Q 1 0⊃𝜏)∧(R 1 1⊃𝜏)⟩
  
  SEQ←{}
  
  ⍝ Sequencing with Catenation
  ⍝ 
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(1=⍴⍴1⊃𝜏)∧(Q 1⊃𝜏)⟩
  ⍝ ⟨P ⍵⟩ G ⍵ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(R 1⊃𝜏)⟩
  ⍝ →
  ⍝ ⟨P ⍵⟩
  ⍝   F SEC G ⍵
  ⍝ ⟨(PR 𝜏)∧(¯1=0⊃𝜏)∨(¯1≠0⊃𝜏)∧(1=⍴⍴1⊃𝜏)∧(Q ¯1↓1⊃𝜏)∧(R ⊃¯1↑1⊃𝜏)⟩
  
  SEC←{}

⍝ AST Constructors and Predicates

  ⍝ Make a module
  ⍝ 
  ⍝ ⟨(1=⍴⍴⍵)∧(∧/IsDef¨⍵)⟩ MkModule ⍵ ⟨IsModule 𝜏⟩

  MkModule←{}
  
  ⍝ Make a global
  ⍝ 
  ⍝ ⟨((,2)≡⍴⍵)∧(IsVar 0⊃⍵)∧(IsConst 1⊃⍵)⟩ MkGlobal ⍵ ⟨IsGlobal 𝜏⟩
  
  MkGlobal←{}
  
  ⍝ Make a Function
  ⍝ 
  ⍝ ⟨(1=⍴⍴⍵)∧(∧/IsStmt¨⍵)⟩ MkFunc ⍵ ⟨IsFunc 𝜏⟩
  
  MkFunc←{}
  
  ⍝ Make a conditional statement
  ⍝
  ⍝ ⟨((,2)≡⍴⍵)∧(∧/IsExpr¨⍵)⟩ MkCond ⍵ ⟨IsCond 𝜏⟩
  
  MkCond←{}
  
:EndNamespace

