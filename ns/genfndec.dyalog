 GenFnDec←{
     0=≢fn←Split⊃'name'Prop 1↑⍵:0         ⍝ Ignore functions without names
     vtst←'Variable'≡⊃1 1⌷⍵               ⍝ Child node type
     vn←⊃'name'Prop 1↑1↓⍵                 ⍝ Variable name if it exists
     vtst:⍺{                              ⍝ Named function reference
         t←('equiv'Prop 1↑⍵)∊,¨APLPrims     ⍝ Is function equivalent to a primitive?
         t:vn(⍺ GenPrimEquiv)fn             ⍝ Then generate the call
         fr←GetNamedFunction ⍺ vn           ⍝ Referenced function
         ft←GenFuncType(CountParams fr)-3   ⍝ Function Type based on depth
         ⍺{AddAlias ⍺ ft fr ⍵}¨fn           ⍝ Generate aliases for each name
     }⍵
     fnf←⊃fn ⋄ fnr←1↓fn                   ⍝ Canonical name; rest of names
     fd←⍎'0',⊃'depth'Prop 1↑1↓⍵           ⍝ Function depth
     ft←GenFuncType fd                    ⍝ Fn type based on depth
     fr←AddFunction ⍺ fnf ft              ⍝ Insert function into module
     0=≢fnr:fr                            ⍝ Return if no other names
     fr⊣⍺{AddAlias ⍺ ft fr ⍵}¨fnr         ⍝ Otherwise, alias the others
 }
