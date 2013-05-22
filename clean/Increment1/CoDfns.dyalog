:Namespace CoDfns

⎕IO←0

⍝ Copyright (c) 2013 Aaron W. Hsu. All Rights Reserved.
⍝ CoDfns Version 1: Increment 1

⍝ Primary External Export Specification
⍝ 
⍝ ⟨P: (Valid R) ∧ (L≡(⎕NL-⍳10)~⊂'NS') ∧ DS≡⎕FIX R⟩
⍝ NS←Fix R
⍝ ⟨Q: P ∧ (9=⎕NC 'NS') ∧ (∀f. (f NS)≡f DS)⟩

Fix←{
  ⍝ ⟨P[⍵:R]⟩
  ⍝
  ast←Parse ⍵
  ⍝ 
  ⍝ ⟨P1: P ∧ ValidAst ast⟩
  ⍝ 
  exp mod←GenerateLlvm ast
  ⍝ 
  ⍝ ⟨P2: P1 ∧ (∧/3=DS.⎕NL exp) ∧ LlvmModule mod
  ⍝   ∧ (∀x,y. ∀f∊exp. ((DS.f X)≡LlvmExec mod f X)
  ⍝      ∧ (Y DS.f X)≡LlvmExec mod f Y X)⟩
  ⍝
  MakeNs mod
  ⍝ 
  ⍝ ⟨Q[⍥:NS]⟩
}



