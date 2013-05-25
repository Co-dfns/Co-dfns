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
    ⍝ ⟨Valid ⍵⟩
    ⍝
      z o t←ParseModule ⍵
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

  ⍝ Parse a Module from input
  ⍝
  ⍝ ⟨Valid ⍵⟩ ParseModule ⍵ ⟨(0≠0⊃𝜏) ∨ (0=0⊃𝜏) ∧ IsModule 1⊃𝜏⟩
  ⍝ ⟨Valid ⍵⟩ MkModule WRP (ParseDef ANY) ⍵ ⟨(0≠0⊃𝜏) ∨ (0=0⊃𝜏) ∧ IsModule 1⊃𝜏⟩
  ⍝ ⟨V2P ⍵⟩ ParseDef ANY ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(1=⍴⍴1⊃𝜏)∧(∧/IsDef¨1⊃𝜏)⟩
  
  ParseModule←MkModule WRP (ParseDef ANY)

  ⍝ Parse a Definition
  ⍝ 
  ⍝ ⟨V2P ⍵⟩ ParseDef ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(IsDef 1⊃𝜏)⟩

  ParseDef←{}

⍝ Parsing Combinators

  ⍝ Parse zero or more items
  ⍝
  ⍝ ⟨P ⍵⟩ F ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(Q 1⊃𝜏)⟩
  ⍝ → 
  ⍝ ⟨P ⍵⟩ F ANY ⍵ ⟨(PR 𝜏)∧(0≠0⊃𝜏)∨(0=0⊃𝜏)∧(1=⍴⍴1⊃𝜏)∧(∧/Q¨1⊃𝜏)⟩

  ANY←{}

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
