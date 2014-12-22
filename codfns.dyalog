⍝ Co-dfns Compiler: High-performance, Parallel APL Compiler
⍝ Copyright (C) 2012-2014 Aaron W. Hsu <arcfide@sacrideo.us>
⍝
⍝ This program is free software: you can redistribute it and/or modify
⍝ it under the terms of the GNU Affero General Public License as published by
⍝ the Free Software Foundation, either version 3 of the License, or
⍝ (at your option) any later version.
⍝
⍝ This program is distributed in the hope that it will be useful,
⍝ but WITHOUT ANY WARRANTY; without even the implied warranty of
⍝ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
⍝ GNU Affero General Public License for more details.
⍝
⍝ You should have received a copy of the GNU Affero General Public License
⍝ along with this program.  If not, see <http://www.gnu.org/licenses/>.

:Namespace codfns

⍝ === VARIABLES ===

  APLPrims←,¨'+-÷×|*⍟⌈⌊<≤=≠≥>⌷⍴,⍳' '⎕ptred' '⎕index' '⎕coeffred' '¨'

  APLRtOps←,⊂'codfns_each'

  _←⍬
  _,←'codfns_add' 'codfns_subtract' 'codfns_divide' 'codfns_multiply' 
  _,←'codfns_residue' 'codfns_power'
  _,←'codfns_log' 'codfns_max' 'codfns_min' 'codfns_less' 'codfns_lesseq' 
  _,←'codfns_equal' 'codfns_not_equal'
  _,←'codfns_greateq' 'codfns_greater' 'codfns_squad' 'codfns_reshape' 
  _,←'codfns_catenate' 'codfns_indexgen'
  _,←'codfns_ptred' 'codfns_index' 'codfns_coeffred'
  APLRunts←_

  CC←'nvcc -O3 -g -shared -Xcompiler -fPIC -Irt -Xlinker -L. -o '

  CodfnsRuntime←'./libcodfns.so'

  MtA←0 2⍴⊂''

  MtAST←0 4⍴0

  MtNTE←0 2⍴⊂''

  WithGPU←1

  ⎕ex '_'

⍝ === End of variables definition ===

  (⎕IO ⎕ML ⎕WX)←0 1 3

⍝ Primary entry point; replaces ⎕FIX
    Fix←{
      a n←ps tk vi ⍵
      a←av fe lf lc du df dl rd rn a
      (vf ⍺)wm gc a
    }

⍝ Verify filename syntax
  vf←{1≢≡⍵:err 11 ⋄ 1≢≢⍴⍵:err 11 ⋄ ~∧/∊' '=⊃0⍴⊂⍵:err 11 ⋄ ⍵}

⍝ Verify namespace script input
    vi←{
      ~1≡≢⍴⍵:err 11 ⋄ 2≠|≡⍵:err 11 ⋄ ~∧/1≥≢∘⍴¨⍵:err 11
      ~∧/∊' '=(⊃0⍴⊂)¨⍵:err 11 ⋄ ⍵
    }

⍝ Tokenize input stream (Rewrite!)
    tk←{
      vc←'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'     ⍝ Upper case characters
      vc,←'abcdefghijklmnopqrstuvwxyz'     ⍝ Lower case characters
      vc,←'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß' ⍝ Accented upper case
      vc,←'àáâãäåæçèéêëìíîïðñòóôõöøùúûüþ'  ⍝ Accented lower case
      vc,←'∆⍙'                             ⍝ Deltas
      vc,←'ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ'     ⍝ Underscored alphabet
      vcn←vc,nc←'¯0123456789'              ⍝ Numbers
      tc←'←{}:⋄+-÷×|*⍟⌈⌊<≤=≠≥>⍺⍵⍴⍳,⌷¨'     ⍝ Single Token characters
      ac←vcn,'     ⍝⎕.',tc                 ⍝ All characters
      ~∧/ac∊⍨⊃,/⍵:E 2                      ⍝ Verify we have only good characters
      i←(,¨⍵)⍳¨'⍝' ⋄ t←i↑¨⍵ ⋄ c←i↓¨⍵       ⍝ Divide into comment and code
      t←((⌽∘(∨\)∘⌽¨t)∧∨\¨t←' '≠t)/¨t       ⍝ Strip leading/trailing whitespace
      nsb←t∊':Namespace' ':EndNamespace'   ⍝ Mask of Namespace tokens
      nsl←nsb/t ⋄ nsi←nsb/⍳⍴t              ⍝ Namespace lines and indices
      ti←(~nsb)/⍳⍴t ⋄ t←(~nsb)/t           ⍝ Token indices and non ns tokens
      at←{2 2⍴'name'⍵'class' 'delimiter'}  ⍝ Fn for namespace attributes
      nsl←{,⊂2 'Token' ''(at ⍵)}¨nsl       ⍝ Tokenize namespace elements
      t←{                                  ⍝ Tokenize other tokens
        0=≢t:⍬                             ⍝ Special empty case
        t←{(m/2</0,m)⊂(m←' '≠⍵)/⍵}¨t       ⍝ Split on and remove spaces
        t←{(b∨2≠/1,b←⍵∊tc)⊂⍵}¨¨t           ⍝ Split on token characters
        t←{⊃,/(⊂⍬),⍵}¨t                    ⍝ Recombine lines
        lc←+/l←≢¨t                         ⍝ Token count per line and total count
        t←⊃,/t                             ⍝ Convert to single token vector
        fc←⊃¨t                             ⍝ First character of each token
        iv←(sv←fc∊vc,'⍺⍵')/⍳lc             ⍝ Mask and indices of variables
        ii←(si←fc∊nc)/⍳lc                  ⍝ Mask and indices of numbers
        ia←(sa←fc∊'←⋄:')/⍳lc               ⍝ Mask and indices of separators
        id←(sd←fc∊'{}')/⍳lc                ⍝ Mask and indices of delimiters
        ipm←(spm←fc∊'+-÷×|*⍟⌈⌊,⍴⍳')/⍳lc    ⍝ Mask and indices of monadic primitives
        iom←(som←fc∊'¨')/⍳lc               ⍝ Mask and indices of monadic operators
        ipd←(spd←fc∊'<≤=≠≥>⎕⌷')/⍳lc        ⍝ Mask and indices of dyadic primitives
        tv←1 2∘⍴¨↓(⊂'name'),⍪sv/t          ⍝ Variable attributes
        tv←{1 4⍴2 'Variable' ''⍵}¨tv       ⍝ Variable tokens
        ncls←{('.'∊⍵)⊃'int' 'float'}       ⍝ Fn to determine Number class attr
        ti←{'value'⍵'class'(ncls ⍵)}¨si/t  ⍝ Number attributes
        ti←{1 4⍴2 'Number' ''(2 2⍴⍵)}¨ti   ⍝ Number tokens
        tpm←{1 2⍴'name'⍵}¨spm/t            ⍝ Monadic Primitive name attributes
        tpm←{⍵⍪'class' 'monadic axis'}¨tpm ⍝ Monadic Primtiive class
        tpm←{1 4⍴2 'Primitive' ''⍵}¨tpm    ⍝ Monadic Primitive tokens
        tom←{1 2⍴'name'⍵}¨som/t            ⍝ Monadic Operator name attributes
        tom←{⍵⍪'class' 'operator'}¨tom     ⍝ Monadic Operator class
        tom←{1 4⍴2 'Primitive' ''⍵}¨tom    ⍝ Monadic Operator tokens
        tpd←{1 2⍴'name'⍵}¨spd/t            ⍝ Dyadic primitive name attributes
        tpd←{⍵⍪'class' 'dyadic axis'}¨tpd  ⍝ Dyadic primitive class
        tpd←{1 4⍴2 'Primitive' ''⍵}¨tpd    ⍝ Dyadic primitive tokens
        ta←{1 2⍴'name'⍵}¨sa/t              ⍝ Separator name attributes
        ta←{⍵⍪'class' 'separator'}¨ta      ⍝ Separator class
        ta←{1 4⍴2 'Token' ''⍵}¨ta          ⍝ Separator tokens
        td←{1 2⍴'name'⍵}¨sd/t              ⍝ Delimiter name attributes
        td←{⍵⍪'class' 'delimiter'}¨td      ⍝ Delimiter class attributes
        td←{1 4⍴2 'Token' ''⍵}¨td          ⍝ Delimiter tokens
        t←tv,ti,tpm,tom,tpd,ta,td          ⍝ Reassemble tokens
        t←t[⍋iv,ii,ipm,iom,ipd,ia,id]      ⍝ In the right order
        t←(⊃,/l↑¨1)⊂t                      ⍝ As vector of non-empty lines of tokens
        t←t,(+/0=l)↑⊂⍬                     ⍝ Append empty lines
        t[⍋((0≠l)/⍳⍴l),(0=l)/⍳⍴l]          ⍝ Put empty lines where they belong
      }⍬
      t←(nsl,t)[⍋nsi,ti]                   ⍝ Add the Namespace lines back
      t←c{                                 ⍝ Wrap in Line nodes
        ha←1 2⍴'comment'⍺                  ⍝ Head comment
        h←1 4⍴1 'Line' ''ha                ⍝ Line node
        0=≢⍵:h ⋄ h⍪⊃⍪/⍵                    ⍝ Wrap it
      }¨t
      0 'Tokens' ''MtA⍪⊃⍪/t                ⍝ Create and return tokens tree
    }

⍝ Rewritten parsing code should go here     

⍝ AST Utilities

  D←{0⌷⍉⍵}
  ASTMSK←{(1⌷⍉⍵)∊⊂⍺⍺}
  FN←'FN'ASTMSK
  FE←'FE'ASTMSK
  EX←'EX'ASTMSK


⍝ Useful utilities
  atrep←{(((~(0⌷⍉⍺)∊⊂⍺⍺)⌿⍺))⍪⍺⍺ ⍵}
  ren←'name'atrep
  opt←{⍵⍵⍀(⍵⍵⌿⍺)⍺⍺(⍵⍵⌿⍵)}
  err←{⍺←⊢ ⋄ ⍺ ⎕SIGNAL ⍵}
  with←↓(⊂⊣),∘⍪⊢

    put←{tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}⍵
      size←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND tie 83 ⋄ 1:rslt←size⊣⎕NUNTIE tie}

    Bind←{0=≢⍵:⍵ ⋄ (i←A⍳⊂'name')≥⍴A←0⌷⍉⊃0 3⌷Ast←⍵:Ast⊣(⊃0 3⌷Ast)⍪←'name'⍺
      Ast⊣((0 3)(i 1)⊃Ast){⍺,⍵,⍨' ' ''⊃⍨0=⍴⍺}←⍺}

    Kids←{((⍺+⊃⍵)=0⌷⍉⍵)⊂[0]⍵
    }

    Prop←{(¯1⌽P∊⊂⍺)/P←(⊂''),,↑⍵[;3]
    }

    Eachk←{(1↑⍵)⍪⊃⍪/(⊂MtAST),(+\(⊃=⊢)0⌷⍉k)(⊂⍺⍺)⌸k←1↓⍵
    }

⍝ Function node references
  rn←{w⊣(3⌷⍉w)⍪←'ref'with↓(1+d)↑⍤¯1+⍀d∘.=⍳1+⌈/0,d←0⌷⍉w←⍵}

⍝ Function depths
  rd←{w⊣(3⌷⍉fn⌿w)⍪←'depth'with ¯1++/∧.(=∨0=⊢)∘⍉⍨↑ref(fn←Function ⍵)⌿w←⍵}

⍝ Drop useless Line nodes
  dl←{(~⍵[;1]∊⊂'Line')⌿⍵}

⍝ Drop unnamed top-level functions
  df←{(~g∊(tl∧(FuncExpr ⍵)∧(name ⍵)∊⊂'')/g←+\tl←1=0⌷⍉⍵)⌿⍵}

⍝ Drop syntactically unreachable code
    du←{
      rf←(fn←Function ⍵)⌿r←↑ref ⍵ ⋄ rd←{1↓(0≠⍵)/⍵}⍤1⊢r
      adj←((name ⍵)∊⊂''){0,1↓(¯1⌽⍺)∧⍵=¯1⌽⍵}opt(fn∨(↓rd)∊↓rf)⊢0⌷⍉⍵
      in←rd∧.(=∨0=⊢)⍉drop⌿rd ⋄ below←r∧.≥⍉drop⌿r×0=rd
      (~adj∨∨/in∧below)⌿⍵
    }

⍝ Lift constants to top-level
    lc←{
      le←l∨e←(Expression ⍵)∧1⌽l←Number ⍵
      h←(1+Number h),1↓[1]h←le⌿w←⍵
      (3⌷⍉(Expression h)⌿h)ren←v←(⊂'lc'),¨⍳+/e
      (3⌷⌽fl⌿w)←v{3 2⍴'class' 'array' 'name'⍺'ref'⍵}¨ref(fl←¯1⌽e)⌿⍵
      (1⌷⍉fl⌿w)←⊂'Variable'
      (1↑w)⍪h⍪1↓w←(fl∨~l)⌿w
    }

⍝ Lift functions to top-level
    lf←{
      fnh←{⍝ Function handler
        at←2 2⍴'name'('fn',⍕rm⊥⍺)'class' 'ambivalent'
        at⍪←'ref'()
        h←⍉⍪1 'FuncExpr' ''at
        h⍪←2 'Function' ''(⍉⍪'ref'⍺)
        h⍪((-¯3+⊃)0⌷⍉⍵),1↓[1]⍵
      }
      ngh←{⍝ Node group handler
        rf←↑ref(fn←Function ⍵)⌿g←⍵
        (3⌷⍉fn⌿g)ren←(⊂'fn'),¨rm⊥⍉rf
        (1⌷⍉fn⌿g)←⊂'Variable'
        ⍺ fnh⍣ft⊢g
      }
      rm←1+⌈⌿r←↑ref ⍵
      sc←1↓{1↓(0≠⍵)/⍵}⍤1⊢r ⋄ rf←(1,1↓Function ⍵)⌿r
      c←(⌈/(⍳1↓⍴rf)×⍤1⊢sc∧.(=∨0=⊢)⍉rf)⌷⍤0 2⊢rf
      (1↓⍵)⍪c ngh⌸1↓⍵
    }

⍝ Flatten expressions (Need to handle condition nodes)
    fe←{
      feg←{⍝ Flatten expression statement
        ed←(Expression∧(⊂'dyadic')∊⍨class)⍵
        (3⌷⍉ed⌿w)⍪←'left'with name(v←¯2⌽ed)⌿w←⍵
        (3⌷⍉(1⌽fe)⌿w)⍪←'fn'with name(¯1⌽fe←FuncExpr w)⌿w←(~v∨1⌽v)⌿w
        (3⌷⍉¯1↓w)⍪←'right'with 1↓{(''≡⍵)⊃⍵ ⍺}\name w←(~fe∨v)⌿w
        3,⊖1↓[1]¯1↓w
      }
      fm←0≠fg←+\1⌽Function ⍵
      ((~fm)⌿⍵)⍪(fm⌿fg){(2↑⍵)⍪(+\(⊃e)=0⌷⍉e)feg⌸e←2↓⍵}⌸fm⌿⍵
    }

⍝ Anchor variables to environments
    av←{
      sh←{⍝ Handle scope
        b←↑(sk⍳sk∩⍨↓(⌽1+⍳r⍳0)↑⍤0 1⊢r←(0≠⍺)⊃ref ⍵)⌷¨⊂sb
        nm←(name e),(left e),⍪right(e←(1+0≠⍺)↓⍵)
        at←'env' 'slot' 'left_env' 'left_slot' 'right_env' 'right_slot'
        (3⌷⍉e)⍪←⊂⍤2⊢at,((≢nm),6 1)⍴⍉(⍴b)⊤(,b)⍳,nm
        ((1+0≠⍺)↑⍵)⍪e
      }
      sb←(k←+\1⌽Function ⍵){name(Expression ⍵)⌿⍵}⌸⍵
      sk←(1,1↓Function ⍵)/ref ⍵
      k sh⌸⍵
    }
     
⍝ Convert Primitives (Rewrite!)
    cp←{ast←⍵
      pm←(1⌷⍉⍵)∊⊂'Primitive'               ⍝ Mask of Primitive nodes
      pn←'name'Prop pm⌿⍵                   ⍝ Primitive names
      cn←(APLPrims⍳pn)⌷¨⊂APLRunts⍪APLRtOps ⍝ Converted names
      hd←⍉⍪'class' 'function'              ⍝ Class is function
      at←(⊂⊂'name')(hd⍪,)¨cn               ⍝ Name of the function
      vn←(⊂'Variable'),(⊂''),⍪at           ⍝ Build the basic node structure
      ast⊣(pm⌿ast)←(pm/0⌷⍉⍵),vn            ⍝ Replace Primitive nodes
    }

⍝ Generate C Code (Rewrite!)
    gc←{com←{⊃,/(⊂''),1↓,',',⍪⍵} ⋄ z←,⊂'#include "codfns.h"'
      di←¯1 ⋄ md←{'D',⍕di⊣(⊃di)+←1} ⋄ si←¯1 ⋄ ms←{'S',⍕si⊣(⊃si)+←1}
      li←¯1 ⋄ ml←{'L',⍕li⊣(⊃li)+←1}
      ce←(tm/1⌽(1⌷⍉⍵)∊⊂'Number')/t←(tm←1=0⌷⍉⍵)⊂[0]⍵
      ntyp←{('int' 'float'⍳⊂⊃'class'Prop 1↓⍵)⊃'type_i' 'type_d' 'type_na'}
      nenm←{'apl_',ntyp ⍵} ⋄ gshp←{'uint64_t ',⍺,'[]={',((1=z)⊃(⍕z←gsz ⍵)''),'};'}
      cnv←{w←⍵ ⋄ (('¯'=w)/w)←'-' ⋄ w}
      gdat←{(ntyp ⍵),' ',⍺,'[]={',(com cnv¨'value'Prop 1↓⍵),'};'}
      gnm←{⊃'name'Prop 1↑⍵} ⋄ gsz←{+/(1⌷⍉⍵)∊⊂'Number'}
      lit←{'struct codfns_array ',(⊃⍺),'={',(com(⊂⍕1≠gsz ⍵),(⍕¨2⍴gsz ⍵),(nenm ⍵)'0',1↓⍺),',NULL};'}
      ptr←{'struct codfns_array *',(gnm ⍵),'=&',⍺,';'}
      arr←{s←ms ⍬ ⋄ d←md ⍬ ⋄ l←ml ⍬ ⋄ (s gshp ⍵)(d gdat ⍵)(l s d lit ⍵)(l ptr ⍵)}
      z,←⊃,/(⊂0⍴⊂''),arr¨ce ⋄ ve←(tm/1⌽(1⌷⍉⍵)∊⊂'Variable')/t
      frm←{⊂'struct codfns_array env0[',(⍕⍵),'];'}
      gvd←{(⍳≢⍺){'struct codfns_array *',⍵,'=&env0[',(⍕⍺),'];'}¨⍺}
      gfh←{⊂'UDF(',⍵,'){'} ⋄ z,←(≢ve)frm⍨⍣(0≠≢ve)⊢⍬
      z,←(gnm¨ve)gvd⍣(0≠≢ve)⊢⍬ ⋄ z,←gfh'Init'
      z,←{' array_cp(',(gnm ⍵),',',(gnm 1↓⍵),');'}¨ve ⋄ z,←⊂' return 0;}'
      gt←{⊂' if(*(type_i*)',(gnm 2↓⍵),'->elements){'}
      gif←{(gt ⍵),(' ',¨ges 3↓⍵),⊂'  return 0;}'}
      gv←{⊂' array_cp(',(com cv¨⍵),');'} ⋄ cv←{'lft' 'rgt'⍵⊃⍨(,¨'⍺⍵')⍳⊂⍵}
      gd←{z l f r←⍵ ⋄ ⊂' ',f,'d(',(com cv¨z l r'env,gpu'),');'}
      gm←{z f r←⍵ ⋄ ⊂' ',f,'m(',(com cv¨z'NULL'r'env,gpu'),');'}
      gom←{z f o r←⍵ ⋄ ⊂' ',o,'m(',(com cv¨z'NULL'r f'env,gpu'),');'}
      god←{z l f o r←⍵ ⋄ ⊂' ',o,'d(',(com cv¨z'NULL'r f'env,gpu'),');'}
      ge←{'Condition'≡⊃0 1⌷⍵:gif ⍵ ⋄ ns←'name'Prop ⍵ ⋄ cl←⊃'class'Prop 1↑⍵
        2=≢ns:gv ns ⋄ 3=≢ns:gm ns ⋄ (4=≢ns)∧'monadic'≡cl:gom ns
        (4=≢ns)∧'dyadic'≡cl:gd ns ⋄ 5=≢ns:god ns ⋄ ⊂''}
      ges←{⍵{⊃,/ge¨((⊃⍺)=0⌷⍉⍺)⊂[0]⍺}⍣(0≠≢⍵)⊢⊂' array_free(res);'}
      ga←{(gfh n,⍵),(⊂' return ',(n←gnm ⍺),'(res,lft,rgt);}')}
      enm←{∪('name'Prop((1⌷⍉⍵)∊⊂'Expression')⌿⍵)~⊂'res'}
      ged←{⊂'struct codfns_array*env[]={env0',(com(⊂''),{'onv[',(⍕⍵),']'}¨⍳⍵),'};'}
      env←{' ',¨(frm≢⍺),(ged⍎'0',⊃'depth'Prop 1↑1↓⍵),⊂'init_env(env0,',(⍕≢⍺),');'}
      mvd←{' ',¨⍵ gvd⍣(0≠≢⍵)⊢⍬}
      gf←{(gfh gnm ⍵),(n env ⍵),(mvd⊢n←enm ⍵),(ges 2↓⍵),⊂' return 0;}'}
      z,←⊃,/(⊂0⍴⊂''),gf¨fn←(tm/1⌽(1⌷⍉⍵)∊⊂'Function')/t
      ⍪z}

⍝ Write module to file
  wm←{⍺⊣(⊃,/,⍵,⎕UCS 10)put ⍺,'.c'}

⍝ Parser (Rewrite!); totally messed up
    ps←{
      0=+/⍵[;1]∊⊂'Token':E 2               ⍝ Deal with Eot Stimuli, Table 233
      fl←⊃1 ¯1⍪.↑⊂(2=⍵[;0])⌿⍵              ⍝ First and last leafs
      ~fl[;1]∧.≡⊂'Token':E 2               ⍝ Must be tokens
      nms←':Namespace' ':EndNamespace'     ⍝ Correct names of first and last
      ~nms∧.≡'name'Prop fl:E 2             ⍝ Verify correct first and last
      n←'name'Prop(⍵[;1]∊⊂'Token')⌿⍵       ⍝ Verify that the Nss and Nse
      2≠+/n∊nms:E 2                        ⍝ Tokens never appear more than once
      ns←0 'Namespace' ''(1 2⍴'name' '')   ⍝ New root node is Namespace
      ns⍪←⍵⌿⍨~(⍳≢⍵)∊(0,⊢,¯1+⊢)⍵⍳fl         ⍝ Drop Nse and Nss Tokens
      tm←(1⌷⍉ns)∊⊂'Token'                  ⍝ Mask of Tokens
      sm←tm\('name'Prop tm⌿ns)∊⊂,'⋄'       ⍝ Mask of Separators
      (sm⌿ns)←1 'Line' ''MtA⍴⍨4,⍨+/sm      ⍝ Replace separators by lines, Tbl 219
     ⍝ XXX: The above does not preserve commenting behavior
      tm←(1⌷⍉ns)∊⊂'Token'                  ⍝ Update token mask
      fm←(,¨'{}')⍳'name'Prop tm⌿ns         ⍝ Which tokens are braces?
      fm←fm⊃¨⊂1 ¯1 0                       ⍝ Convert } → ¯1; { → 1; else → 0
      0≠+/fm:E 2                           ⍝ Verify balance
      (0⌷⍉ns)+←2×+\0,¯1↓fm←tm\fm           ⍝ Push child nodes 2 for each depth
      ns fm←(⊂¯1≠fm)⌿¨ns fm                ⍝ Drop closing braces
      fa←1 2⍴'class' 'ambivalent'          ⍝ Function attributes
      fn←(d←fm/0⌷⍉ns),¨⊂'Function' ''fa    ⍝ New function nodes
      fn←fn,[¯0.5]¨(1+d),¨⊂'Line' ''MtA    ⍝ Line node for each function
      hd←(~∨\fm)⌿ns                        ⍝ Unaffected areas of ns
      ns←hd⍪⊃⍪/(⊂MtAST),fn(⊣⍪1↓⊢)¨fm⊂[0]ns ⍝ Replace { with fn nodes
      k←1 Kids ns                          ⍝ Children to examine
      env←⊃ParseFeBindings/k,⊂MtNTE        ⍝ Initial Fe bindings to feed in
      sd←MtAST env                         ⍝ Seed is an empty AST and the env
      ast env←⊃ParseTopLine/⌽(⊂sd),k       ⍝ Parse each child top down
      ((1↑ns)⍪ast)env                      ⍝ Return assembled AST and env
    }

    ParseExpr←{
      0=⊃⍴⍵:2 MtAST ⍺                      ⍝ Empty expressions are errors
      2::2 MtAST ⍺                         ⍝ Allow instant exit while parsing
      6::6 MtAST ⍺
      11::11 MtAST ⍺
      at←1 2⍴'class' 'atomic'              ⍝ Literals become atomic expressions
      n←(d←⊃⍵)'Expression' ''at            ⍝ One node per group of literals
      p←2</0,m←(d=0⌷⍉⍵)∧(1⌷⍉⍵)∊⊂'Number'   ⍝ Mask and partition of literals
      (0⌷⍉m⌿e)+←1⊣e←⍵                      ⍝ Bump the depths of each literal
      e←⊃⍪/(⊂MtAST),(⊂n)⍪¨p⊂[0]e           ⍝ Add expr node to each literal group
      e←((~∨\p)⌿⍵)⍪e                       ⍝ Attach anything before first literal
      dwn←{a⊣(0⌷⍉a)+←1⊣a←⍵}                ⍝ Fn to push nodes down the tree
      at←1 2⍴'class' 'monadic'             ⍝ Attributes for monadic expr node
      em←d'Expression' ''at                ⍝ Monadic expression node
      at←1 2⍴'class' 'dyadic'              ⍝ Attributes for dyadic expr node
      ed←d'Expression' ''at                ⍝ Dyadic expression node
      at←1 2⍴'class' 'ambivalent'          ⍝ Attributes for operator-derived Fns
      feo←d'FuncExpr' ''at                 ⍝ Operator-derived Functions
      e ne _←⊃{ast env knd←⍵               ⍝ Process tokens from bottom up
        e fe rst←env ParseFuncExpr ⍺       ⍝ Try to parse as a FuncExpr node first
        (0⌷⍉fe)+←1                         ⍝ Bump up the FuncExpr depth to match
        k←(e=0)⊃⍺ fe                       ⍝ Kid is Fe if parsed, else existing kid
        tps←'Expression' 'FuncExpr'        ⍝ Types of nodes
        tps,←'Token' 'Variable'
        4=typ←tps⍳0 1⌷k:⍎'⎕SIGNAL e'       ⍝ Type of node we're dealing with
        nm←⊃'name'Prop 1↑k                 ⍝ Name of the kid, if any
        k←(typ=3)⊃k(n⍪dwn k)               ⍝ Wrap the variable if necessary
        c←knd typ                          ⍝ Our case
        c≡0 0:(k⍪ast)env 1                 ⍝ Nothing seen, Expression
        c≡0 1:⍎'⎕SIGNAL 2'                 ⍝ Nothing seen, FuncExpr
        c≡0 2:⍎'⎕SIGNAL 2'                 ⍝ Nothing seen, Assignment
        c≡0 3:(k⍪dwn ast)env 1             ⍝ Nothing seen, Variable
        c≡1 0:⍎'⎕SIGNAL 2'                 ⍝ Expression seen, Expression
        c≡1 1:(em⍪dwn k⍪ast)env 2          ⍝ Expression seen, FuncExpr
        c≡1 2:ast env 3                    ⍝ Expression seen, Assignment
        c≡1 3:⍎'⎕SIGNAL 2'                 ⍝ Expression seen, Variable
        op←'operator'≡⊃'class'Prop 1↑1↓ast ⍝ Is class of kid ≡ operator?
        mko←{dwn feo⍪(dwn k)⍪2↑1↓ast}      ⍝ Fn to make the FuncExpr node
        op∧c≡2 0:(em⍪(mko ⍬)⍪3↓ast)env 2   ⍝ FuncExpr seen, Operator, Expression
        c≡2 0:(ed⍪(dwn k)⍪1↓ast)env 2      ⍝ FuncExpr seen, Expression
        op∧c≡2 1:(em⍪(mko ⍬)⍪3↓ast)env 2   ⍝ FuncExpr seen, Operator, FuncExpr
        c≡2 1:(em⍪dwn k⍪ast)env 2          ⍝ FuncExpr seen, FuncExpr
        op∧c≡2 2:⍎'⎕SIGNAL 2'              ⍝ FuncExpr seen, Operator, Assignment
        c≡2 2:ast env 3                    ⍝ FuncExpr seen, Assignment
        op∧c≡2 3:(em⍪(mko ⍬)⍪3↓ast)env 2   ⍝ FuncExpr seen, Operator, Variable
        c≡2 3:(ed⍪(dwn k)⍪1↓ast)env 1      ⍝ FuncExpr seen, Variable
        c≡3 0:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, Expression
        c≡3 1:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, FuncExpr
        c≡3 2:⍎'⎕SIGNAL 2'                 ⍝ Assignment seen, Assignment
        c≡3 3:(nm Bind ast)((nm 1)⍪env)1   ⍝ Assignment seen, Variable
        ⎕SIGNAL 99                         ⍝ Unreachable
      }/(0 Kids e),⊂MtAST ⍺ 0
      (0⌷⍉e)-←1                            ⍝ Push the node up to right final depth
      0 e ne                               ⍝ Return the expression and new env
    }

    ParseFeBindings←{
      1=≢⍺:⍵                      ⍝ Nothing on the line, done
      fp←'Function' 'Primitive'   ⍝ Looking for Functions and Prims
      ~fp∨.≡⊂0(0 1)⊃⌽k←1 Kids ⍺:⍵ ⍝ Not a function line, done
      ok←⊃⍪/(⊂MtAST),¯1↓k         ⍝ Other children
      tm←(1⌷⍉ok)∊⊂'Token'         ⍝ Mask of all Tokens
      tn←'name'Prop tm⌿ok         ⍝ Token names
      ~∧/tn∊⊂,'←':⎕SIGNAL 2       ⍝ Are all tokens assignments?
      ∨/0=2|tm/⍳≢ok:⎕SIGNAL 2     ⍝ Are all tokens separated correctly?
      vm←(1⌷⍉ok)∊⊂'Variable'      ⍝ Mask of all variables
      vn←'name'Prop vm⌿ok         ⍝ Variable names
      ∨/0≠2|vm/⍳≢ok:⎕SIGNAL 2     ⍝ Are all variables before assignments?
      ~∧/vm∨tm:⎕SIGNAL 2          ⍝ Are there only variables, assignments?
      ⍵⍪⍨2,⍨⍪vn                   ⍝ We're good, return new environment
    }

    ParseFnLine←{cod env←⍵
      1=⊃⍴⍺:(cod⍪⍺)env                     ⍝ Do nothing for empty lines
      cmt←⊃'comment'Prop 1↑⍺               ⍝ Preserve the comment for attachment
      cm←{(,':')≡⊃'name'Prop 1↑⍵}¨1 Kids ⍺ ⍝ Mask of : stimuli, to check for branch
      1<cnd←+/cm:⎕SIGNAL 2                 ⍝ Too many : tokens
      1=0⌷cm:⎕SIGNAL 2                     ⍝ Empty test clause
      splt←{1↓¨(1,cm)⊂[0]⍵}                ⍝ Fn to split on : token, drop excess
      1=cnd:⊃cod env ParseCond/splt ⍺      ⍝ Condition found, parse it
      err ast ne←env ParseExpr 1↓⍺         ⍝ Expr is the last non-error option
      0=err:(cod⍪ast)ne                    ⍝ Return if it worked
      ⎕SIGNAL err                          ⍝ Otherwise error the expr error
    }

    ParseFunc←{
      'Function'≢⊃0 1⌷⍵:2 MtAST ⍵          ⍝ Must have a Function node first
      fn←(fm←1=+\(fd←⊃⍵)=d←0⌷⍉⍵)⌿⍵         ⍝ Get the Function node, mask, depths
      en←⍺⍪⍨1,⍨⍪,¨'⍺⍵'                     ⍝ Extend current environment with ⍺ & ⍵
      sd←MtAST en                          ⍝ Seed value
      cn←1 Kids fn                         ⍝ Lines of Function node
      2::2 MtAST ⍵                       ⍝ Handle parse errors
      11::11 MtAST ⍵                       ⍝ by passing them up
      tr en←⊃ParseFnLine/⌽(⊂sd),cn         ⍝ Parse down each line
      0((1↑fn)⍪tr)((~fm)⌿⍵)                ⍝ Newly parsed function, rest of tokens
    }

    ParseFuncExpr←{
      at←{2 2⍴'class'⍵'equiv'⍺}         ⍝ Fn to build fn attributes
      fn←(¯1+⊃⍵)∘{⍺'FuncExpr' ''⍵}        ⍝ Fn to build FuncExpr node
      pcls←{(~∨\' '=C)/C←⊃'class'Prop 1↑⍵} ⍝ Fn to get class of Primitive node
      nm←⊃'name'Prop 1↑⍵                   ⍝ Name of first node
      isp←'Primitive'≡⊃0 1⌷⍵               ⍝ Is the node a primitive?
      isp:0((fn nm at pcls ⍵)⍪1↑⍵)(1↓⍵)    ⍝ Yes? Use that node.
      isfn←'Variable'≡⊃0 1⌷⍵               ⍝ Do we have a variable
      isfn∧←2=⍺ VarType nm                 ⍝ that refers to a function?
      fnat←''at'ambivalent'              ⍝ Fn attributes for a variable
      isfn:0((fn fnat)⍪1↑⍵)(1↓⍵)           ⍝ If function variable, return
      err ast rst←⍺ ParseFunc ⍵            ⍝ Try to parse as a function
      0=err:0(ast⍪⍨fn at⍨'ambivalent')rst  ⍝ Use ambivalent class if it works
      2 MtAST ⍵                            ⍝ Otherwise, return error
    }

    ParseLineVar←{env cls←⍺
      '←'≡⊃'name'Prop 1↑⍵:2 MtAST          ⍝ No variable named, syntax error
      3>⊃⍴⍵:¯1 MtAST                       ⍝ Valid cases have at least three nodes
      tk←'Variable' 'Token'                ⍝ First two tokens should be Var and Tok
      ~tk∧.≡(0 1)1⌷⍵:¯1 MtAST              ⍝ If not, bad things
      (,'←')≢⊃'name'Prop 1↑1↓⍵:¯1 MtAST    ⍝ 2nd node is assignment?
      vn←⊃'name'Prop 1↑⍵                   ⍝ Name of the variable
      tp←env VarType vn                    ⍝ Type of the variable: Vfo or Vu?
      t←(0=tp)∧(cls=0)                     ⍝ Class zero with Vu?
      t:0,⊂vn env ParseNamedUnB 2↓⍵        ⍝ Then parse as unbound
      t←(2 3 4∨.=tp)∨(0=tp)∧(cls=1)        ⍝ Vfo or unbound with previous Vfo seen?
      t:0,⊂vn 2 env ParseNamedBnd 2↓⍵      ⍝ Then parse as bound to Fn
     ⍝ XXX: Right now we assume that we have only types of 2, or Fns.
     ⍝ In the future, change this to adjust for other nameclasses.
      ¯1 MtAST                             ⍝ Not a Vfo or Vu; something is wrong
    }

    ParseNamedBnd←{vn tp env←⍺
      0=⊃env ParseExpr ⍵:⎕SIGNAL 2         ⍝ Should not be an Expression
      tp≠t←2:⎕SIGNAL 2                     ⍝ The types must match to continue
      err ast←env 1 ParseLineVar ⍵         ⍝ Try to parse as a variable line
      0=err:vn Bind ast                    ⍝ If it succeeds, Bind and return
      ferr ast rst←env ParseFuncExpr ⍵     ⍝ Try to parse as a FuncExpr
      (0=ferr)∧tp=t:vn Bind ast            ⍝ If it works, bind it and return
      t←(1=≢⍵)∧('Variable'≡⊃0 1⌷⍵)         ⍝ Do we have only a single var node?
      t∧←0=env VarType⊃'name'Prop 1↑⍵      ⍝ And is it unbound?
      t:⎕SIGNAL 6                          ⍝ Then signal a value error for unbound
      ¯1=×err:⎕SIGNAL ferr                 ⍝ Signal FuncExpr error if suggested
      ⎕SIGNAL err                          ⍝ Else signal variable line error
    }

    ParseNamedUnB←{vn env←⍺
      err ast←env 0 ParseLineVar ⍵         ⍝ Else try to parse as a variable line
      0=err:vn Bind ast                    ⍝ that worked, so bind it
      ferr ast rst←env ParseFuncExpr ⍵     ⍝ Try to parse as a FuncExpr
      0=ferr:vn Bind ast                   ⍝ It worked, bind it to vn
      ¯1=×err:⎕SIGNAL ferr                 ⍝ Signal FuncExpr error if suggested
      ⎕SIGNAL err                          ⍝ Otherwise signal Variable line error
    }

    ParseTopLine←{cod env←⍵ ⋄ line←⍺
      1=≢⍺:(cod⍪⍺)env                    ⍝ Empty lines, do nothing
      cmt←⊃'comment'Prop 1↑⍺             ⍝ We need the comment for later
      eerr ast ne←env ParseExpr 1↓⍺      ⍝ Try to parse as expression first
      0=eerr:(cod⍪ast Comment cmt)ne     ⍝ If it works, extend and replace
      err ast←env 0 ParseLineVar 1↓⍺     ⍝ Try to parse as variable prefixed line
      0=⊃err:(cod⍪ast Comment cmt)env    ⍝ It worked, good
      ferr ast rst←env ParseFuncExpr 1↓⍺ ⍝ Try to parse as a function expression
      0=⊃ferr:(cod⍪ast Comment cmt)env   ⍝ It worked, extend and replace
      ¯1=×err:⎕SIGNAL eerr               ⍝ Signal expr error if it seems good
      ⎕SIGNAL err                        ⍝ Otherwise signal err from ParseLineVar
    }

    ParseCond←{cod env←⍺⍺
      err ast ne←env ParseExpr ⍺           ⍝ Try to parse the test expression 1st
      0≠err:⎕SIGNAL err                    ⍝ Parsing test expression failed
      (0⌷⍉ast)+←1                          ⍝ Bump test depth to fit in condition
      m←(¯1+⊃⍺)'Condition' ''MtA          ⍝ We're returning a condition node
      0=≢⍵:(cod⍪m⍪ast)ne                   ⍝ Emtpy consequent expression
      err con ne←ne ParseExpr ⍵            ⍝ Try to parse consequent
      0≠err:⎕SIGNAL err                    ⍝ Failed to parse consequent
      (0⌷⍉con)+←1                          ⍝ Consequent depth jumps as well
      (cod⍪m⍪ast⍪con)ne                    ⍝ Condition with conseuqent and test
    }

    Comment←{⍺
    }

  VarType←{(⍺[;1],0)[⍺[;0]⍳⊂⍵]}

:EndNamespace