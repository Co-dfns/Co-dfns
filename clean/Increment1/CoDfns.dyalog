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
⍝ Const  ← integer | float

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
    ⍝ Parse a Global Constant
    ⍝
    ⍝ ⟨V2P⟩ Global ⍵ ⟨(pr 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(IsGlobal 1⊃𝜏⟩
    
      
    
    ⍝ Parse a Function Definition
    ⍝
    ⍝ ⟨V2P ⍵⟩ Func ⍵ ⟨(pr 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(IsFunc 1⊃𝜏)⟩
    
      
    
    ⍝ Parse a Definition
    ⍝ 
    ⍝ (IsDef ⍵)≡(IsGlobal ⍵)∨(IsFunc ⍵)
    ⍝ ⟨V2P ⍵⟩ Def ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(IsDef 1⊃𝜏)⟩
    ⍝ ⟨V2P ⍵⟩ Global OR Func ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(IsGlobal 1⊃𝜏)∨(IsFunc 1⊃𝜏)⟩

      Def←Global OR Func

    ⍝ Parse a Module from input
    ⍝
    ⍝ ⟨Valid ⍵⟩ Module ⍵ ⟨(0≠0⊃𝜏) ∨ (0=0⊃𝜏) ∧ IsModule 1⊃𝜏⟩
    ⍝ ⟨Valid ⍵⟩ MkModule WRP (ParseDef ANY) ⍵ ⟨(0≠0⊃𝜏) ∨ (0=0⊃𝜏) ∧ IsModule 1⊃𝜏⟩
    ⍝ ⟨V2P ⍵⟩ ParseDef ANY ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(1=⍴⍴1⊃𝜏)∧(∧/IsDef¨1⊃𝜏)⟩

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
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(Q 1⊃𝜏)⟩
  ⍝ → 
  ⍝ ⟨P ⍵⟩ F ANY ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(1=⍴⍴1⊃𝜏)∧(∧/Q¨1⊃𝜏)⟩

  ANY←{}
  
  ⍝ Parse one item or the other
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧Q ⍵⟩
  ⍝ ⟨P ⍵⟩ G ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧R ⍵⟩
  ⍝ →
  ⍝ ⟨P ⍵⟩ F OR G ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(Q ⍵)∨(R ⍵)⟩
  
  OR←{}

  ⍝ Wrap the returned object of a parser
  ⍝ 
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(Q 1⊃𝜏)⟩
  ⍝ ∧ ⟨Q ⍵⟩ C ⍵ ⟨Q1 𝜏⟩
  ⍝ → ⟨P ⍵⟩ C WRP F ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(Q1 𝜏)⟩

  WRP←{}

⍝ AST Constructors and Predicates

  ⍝ Make a module
  ⍝ 
  ⍝ ⟨(1=⍴⍴⍵)∧(∧/IsDef¨⍵)⟩ MkModule ⍵ ⟨IsModule 𝜏⟩

  MkModule←{}
