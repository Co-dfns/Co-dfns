 Tokenize←{
     vc←'ABCDEFGHIJKLMNOPQRSTUVWXYZ_'     ⍝ Upper case characters
     vc,←'abcdefghijklmnopqrstuvwxyz'     ⍝ Lower case characters
     vc,←'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß' ⍝ Accented upper case
     vc,←'àáâãäåæçèéêëìíîïðñòóôõöøùúûüþ'  ⍝ Accented lower case
     vc,←'∆⍙'                             ⍝ Deltas
     vc,←'ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ'     ⍝ Underscored alphabet
     vcn←vc,nc←'¯0123456789'              ⍝ Numbers
     tc←'←{}:⋄+-÷×|*⍟⌈⌊<≤=≠≥>⍺⍵⍴⍳,⌷¨'     ⍝ Single Token characters
     ac←vcn,'     ⍝⎕.',tc                 ⍝ All characters
     ~∧/ac∊⍨⊃,/⍵:⎕SIGNAL 2                ⍝ Verify we have only good characters
     i←⍵⍳¨'⍝' ⋄ t←i↑¨⍵ ⋄ c←i↓¨⍵           ⍝ Divide into comment and code
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
         tv←{1 4⍴2 'Variable' ''⍵}¨tv      ⍝ Variable tokens
         ncls←{('.'∊⍵)⊃'int' 'float'}       ⍝ Fn to determine Number class attr
         ti←{'value'⍵'class'(ncls ⍵)}¨si/t  ⍝ Number attributes
         ti←{1 4⍴2 'Number' ''(2 2⍴⍵)}¨ti  ⍝ Number tokens
         tpm←{1 2⍴'name'⍵}¨spm/t           ⍝ Monadic Primitive name attributes
         tpm←{⍵⍪'class' 'monadic axis'}¨tpm ⍝ Monadic Primtiive class
         tpm←{1 4⍴2 'Primitive' ''⍵}¨tpm   ⍝ Monadic Primitive tokens
         tom←{1 2⍴'name'⍵}¨som/t           ⍝ Monadic Operator name attributes
         tom←{⍵⍪'class' 'operator'}¨tom     ⍝ Monadic Operator class
         tom←{1 4⍴2 'Primitive' ''⍵}¨tom   ⍝ Monadic Operator tokens
         tpd←{1 2⍴'name'⍵}¨spd/t           ⍝ Dyadic primitive name attributes
         tpd←{⍵⍪'class' 'dyadic axis'}¨tpd  ⍝ Dyadic primitive class
         tpd←{1 4⍴2 'Primitive' ''⍵}¨tpd   ⍝ Dyadic primitive tokens
         ta←{1 2⍴'name'⍵}¨sa/t             ⍝ Separator name attributes
         ta←{⍵⍪'class' 'separator'}¨ta      ⍝ Separator class
         ta←{1 4⍴2 'Token' ''⍵}¨ta         ⍝ Separator tokens
         td←{1 2⍴'name'⍵}¨sd/t             ⍝ Delimiter name attributes
         td←{⍵⍪'class' 'delimiter'}¨td      ⍝ Delimiter class attributes
         td←{1 4⍴2 'Token' ''⍵}¨td         ⍝ Delimiter tokens
         t←tv,ti,tpm,tom,tpd,ta,td          ⍝ Reassemble tokens
         t←t[⍋iv,ii,ipm,iom,ipd,ia,id]      ⍝ In the right order
         t←(⊃,/l↑¨1)⊂t                      ⍝ As vector of non-empty lines of tokens
         t←t,(+/0=l)↑⊂⍬                     ⍝ Append empty lines
         t[⍋((0≠l)/⍳⍴l),(0=l)/⍳⍴l]          ⍝ Put empty lines where they belong
     }⍬
     t←(nsl,t)[⍋nsi,ti]                   ⍝ Add the Namespace lines back
     t←c{                                 ⍝ Wrap in Line nodes
         ha←1 2⍴'comment'⍺                 ⍝ Head comment
         h←1 4⍴1 'Line' ''ha               ⍝ Line node
         0=≢⍵:h ⋄ h⍪⊃⍪/⍵                    ⍝ Wrap it
     }¨t
     0 'Tokens' ''MtA⍪⊃⍪/t               ⍝ Create and return tokens tree
 }