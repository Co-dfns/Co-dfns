 LookupExpr←{⍺←⊢ ⋄ nm vl←⍺⊣2⍴⊂0⍴⊂'' ⋄ mod fr bld _←⍺⍺ ⋄ node←⍵
     nam←⊃'name'Prop ⍵                    ⍝ Variable's name
     i←(,¨'⍺⍵')⍳⊂nam                      ⍝ Do we have a formal?
     2≠i:(GetParam fr(1+i)),nm vl        ⍝ Easy if we have formals
     (i←nm⍳⊂nam)<≢nm:(i⊃vl),nm vl         ⍝ Environment contains binding, use it
     eid←⍎⊃'env'Prop ⍵                    ⍝ Variable's Environment
     pos←⍎⊃'slot'Prop ⍵                   ⍝ Position in environment
     fnd←(CountParams fr)-3               ⍝ Get the function depth
     eid=0:'VALUE ERROR'⎕SIGNAL 99        ⍝ Variable should not be in local scope
     eid>fnd:{                            ⍝ Environment points to global space
         val←GetNamedGlobal mod nam         ⍝ Grab the value from the global space
         val,((⊂nam),nm)(val,vl)            ⍝ Add it to the bindings and return
     }⍬
     env←GetParam fr(2+eid)               ⍝ Pointer to environment frame
     idx←GEPI,pos                        ⍝ Convert pos to GEP index
     app←BuildGEP bld env idx 1 ''        ⍝ Pointer to Array Pointer for Variable
     apv←BuildLoad bld app nam            ⍝ Array Pointer for Variable
     apv,((⊂nam),nm)(apv,vl)              ⍝ Update the environment and return
 }