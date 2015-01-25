:Namespace P
  (⎕IO ⎕ML ⎕WX)←0 1 3
  _s←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ 0<⊃c2 a2 e r←e ⍵⍵ r:c2 a2 e r ⋄ (c⌈c2)(a,a2) e r}
  _o←{0≥⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ 0≥⊃c a e r2←⍺ ⍵⍵ ⍵:c a e r2 ⋄ c a e(r↑⍨-⌊/≢¨r r2)}
  _any←{⍺(⍺⍺ _s ∇ _o _yes)⍵} ⋄ _some←{⍺(⍺⍺ _s (⍺⍺ _any))⍵} ⋄ _opt←{⍺(⍺⍺ _o _yes)⍵}
  _yes←{0 ⍬ ⍺ ⍵} ⋄ _t←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ e ⍵⍵ a:c a e r ⋄ 2 ⍬ ⍺ ⍵} 
  _set←{(0≠≢⍵)∧(⊃⍵)∊⍺⍺:0(,⊃⍵)⍺(1↓⍵) ⋄ 2 ⍬ ⍺ ⍵}  
  _tk←{((≢,⍺⍺)↑⍵)≡,⍺⍺:0(⊂,⍺⍺)⍺((≢,⍺⍺)↓⍵) ⋄ 2 ⍬ ⍺ ⍵}
  _as←{0<⊃c a e r←⍺ ⍺⍺ ⍵:c a e r ⋄ c (,⊂⍵⍵ a) e r} ⋄ _enc←{⍺(⍺⍺ _as {⍵})⍵}
  _ign←{c a e r←⍺ ⍺⍺ ⍵ ⋄ c ⍬ e r} ⋄ _env←{0<⊃c a e r←p←⍺ ⍺⍺ ⍵:p ⋄ c a (e ⍵⍵ a) r}
  _aew←{⍺(⍵⍵ _o (⍺⍺ _s ∇))⍵}

  ws←(' ',⎕UCS 9)_set ⋄ aws←ws _any _ign ⋄ awslf←(⎕UCS 10 13)_set _o ws _any _ign
  nss←awslf _s(':Namespace'_tk)_s awslf _ign
  nse←awslf _s(':EndNamespace'_tk)_s awslf _ign
  gets←aws _s('←'_tk)_s aws ⋄ him←'¯'_set ⋄ dot←'.'_set
  lbrc←aws _s('{'_tk)_s aws _ign ⋄ rbrc←aws _s('}'_tk)_s aws _ign
  lpar←aws _s('('_tk)_s aws _ign ⋄ rpar←aws _s(')'_tk)_s aws _ign
  lbrk←aws _s('['_tk)_s aws _ign ⋄ rbrk←aws _s(']'_tk)_s aws _ign
  alpha←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'_set
  digits←'0123456789'_set ⋄ prim←'+-÷×|*⍟⌈⌊<≤=≠≥>⌷⍴,⍳○'_set
  mop←'¨/⌿⍀\⍨'_set ⋄ dop←'.⍤⍣∘'_set

  eot←aws _s {''≡⍵:0 ⍬ ⍺ '' ⋄ 2 ⍬ ⍺ ⍵} _ign
  digs←digits _some ⋄ odigs←digits _any
  int←aws _s (him _opt) _s digs _s aws
  float←aws _s (int _s dot _s odigs _o (dot _s digs)) _s aws
  var←aws _s alpha _s (alpha _o digits _any) _s aws ⋄ aw←aws _s ('⍺⍵'_set) _s aws
  sep←aws _s (('⋄',⎕UCS 10 13)_set _ign) _s aws
  
  A←##.A                         
  Prim←prim _as A.Prm
  Fn←{0<⊃c a e r←p←⍺(lbrc _s (Stmt _aew rbrc) _as A.Fun)⍵:p ⋄ c a ⍺ r}
  Mop←Fn _o Prim _s (mop _as A.Prm) _as ('m'A.Fex)
  Dop←Prim _s (dop _as A.Prm) _s Prim _as ('d'A.Fex)
  Bop←{⍺(Prim _s lbrk _s Ex _s rbrk _as ('i'A.Fex))⍵}
  Bind←{⍺(var _enc _s gets _s ⍺⍺ _env (⍵⍵{(⊃⍵)⍺⍺⍪⍺}) _as A.Bind)⍵}
  Fe←{⍺(∇ Bind 1 _o Dop _o Mop _o Bop _o Fn _o (1 Var'f') _o Prim)⍵}
  Vt←{((0⌷⍉⍺)⍳⊂⍵)1⌷⍺⍪'' ¯1}
  Var←{⍺(aw _o (var _t (⍺⍺=Vt)) _as (⍵⍵ A.Var))⍵}
  Num←float _o int _as A.Num
  Atom←{⍺(Num _some _as A.Atm _o (0 Var'a' _as A.Atm) _o Pex)⍵}
  Mon←{⍺(Fe _s Ex _as ('m'A.Exp))⍵}
  Dya←{⍺((Idx _o Atom) _s Fe _s Ex _as ('d'A.Exp))⍵}  
  Idx←{⍺(Atom _s lbrk _s Ex _s rbrk _as ('i'A.Exp))⍵}
  Ex←{⍺(∇ Bind 0 _o Dya _o Mon _o Idx _o Atom)⍵}      
  Pex←lpar _s Ex _s rpar
  Stmt←sep _any _s (Ex _o Fe) _s (sep _any)
  Ns←nss _s (Stmt _aew nse) _s eot _as A.Nms
  
  Ps←{0≠⊃c a e r←(0 2⍴⍬)Ns ∊⍵,¨⎕UCS 10:⎕SIGNAL c ⋄ (⊃a)e}
:EndNamespace 