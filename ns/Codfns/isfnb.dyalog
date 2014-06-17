 IsFnb←{
     ~(∧/∊' '=⊃0⍴⊂⍵)∧(1≡≢⍴⍵)∧(1≡≡⍵) ⍝ Is simple, character vector?
 }
