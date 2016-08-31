:Namespace util

display←{⎕IO ⎕ML←0 1                        ⍝ Boxed display of array.

    box←{                                   ⍝ box with type and axes
        vrt hrz←(¯1+⍴⍵)⍴¨'│─'               ⍝ vert. and horiz. lines
        top←'─⊖→'[¯1↑⍺],hrz                 ⍝ upper border with axis
        bot←(⊃⍺),hrz                        ⍝ lower border with type
        rgt←'┐│',vrt,'┘'                    ⍝ right side with corners
        lax←'│⌽↓'[¯1↓1↓⍺],¨⊂vrt             ⍝ left side(s) with axes,
        lft←⍉'┌',(↑lax),'└'                 ⍝ ... and corners
        lft,(top⍪⍵⍪bot),rgt                 ⍝ fully boxed array
    }

    deco←{⍺←type open ⍵ ⋄ ⍺,axes ⍵}         ⍝ type and axes vector
    axes←{(-2⌈⍴⍴⍵)↑1+×⍴⍵}                   ⍝ array axis types
    open←{16::(1⌈⍴⍵)⍴⊂'[ref]' ⋄ (1⌈⍴⍵)⍴⍵}   ⍝ exposure of null axes
    trim←{(~1 1⍷∧⌿⍵=' ')/⍵}                 ⍝ removal of extra blank cols
    type←{{(1=⍴⍵)⊃'+'⍵}∪,char¨⍵}            ⍝ simple array type
    char←{⍬≡⍴⍵:'─' ⋄ (⊃⍵∊'¯',⎕D)⊃'#~'}∘⍕    ⍝ simple scalar type
    line←{(6≠10|⎕DR' '⍵)⊃' -'}              ⍝ underline for atom

    {                                       ⍝ recursive boxing of arrays:
        0=≡⍵:' '⍪(open ⎕FMT ⍵)⍪line ⍵       ⍝ simple scalar
        1 ⍬≡(≡⍵)(⍴⍵):'∇' 0 0 box ⎕FMT ⍵     ⍝ object rep: ⎕OR
        1=≡⍵:(deco ⍵)box open ⎕FMT open ⍵   ⍝ simple array
        ('∊'deco ⍵)box trim ⎕FMT ∇¨open ⍵   ⍝ nested array
    }⍵
}

pp←{⍵⊣⎕←display ⍵⊣⍞←⍴⍵⊣⍞←'Shape: '}

utf8get←{                              ⍝ Char vector from UTF-8 file ⍵.
    0::⎕SIGNAL ⎕EN                     ⍝ signal error to caller.
    tie←⍵ ⎕NTIE 0                      ⍝ file handle.
    ints←⎕NREAD tie 83,⎕NSIZE tie      ⍝ all UTF-8 file bytes.
    ('UTF-8'⎕UCS 256|ints)⊣⎕NUNTIE tie ⍝ ⎕AV chars.
}

∇TEST
##.UT.print_passed←1
##.UT.print_summary←1
##.UT.run './tests'
∇

test←{##.UT.run './tests/',⍵,'_tests.dyalog'}

MK∆T1←{id cmp ns fn←⍺⍺ ⋄ r←⍵⍵
    ~(⊂cmp)∊##.codfns.TEST∆COMPILERS:0⊣##.UT.expect←0
    ##.codfns.COMPILER←cmp
    CS←id ##.codfns.Fix ns
    NS←⎕FIX ns
    ##.UT.expect←(⍎'NS.',fn)r ⋄ (⍎'CS.',fn)r}

MK∆T2←{id cmp ns fn←⍺⍺ ⋄ l r←⍵⍵
    ~(⊂cmp)∊##.codfns.TEST∆COMPILERS:0⊣##.UT.expect←0
    ##.codfns.COMPILER←cmp
    CS←id ##.codfns.Fix ns
    NS←⎕FIX ns
    ##.UT.expect←l(⍎'NS.',fn)r ⋄ l(⍎'CS.',fn)r}

MK∆T3←{id cmp ns fn tl←⍺⍺ ⋄ l r←⍵⍵
    ~(⊂cmp)∊##.codfns.TEST∆COMPILERS:0⊣##.UT.expect←0
    ##.codfns.COMPILER←cmp
    CS←id ##.codfns.Fix ns
    NS←⎕FIX ns
    nv←l(⍎'NS.',fn)r ⋄ cv←l(⍎'CS.',fn)r
    ##.UT.expect←(≢,nv)⍴1 ⋄ ,tl>|nv-cv}

∇Z←ID(NCF GEN∆T1 THIS)IN;NS;FN;CMP;TC;TMP
 NS TC FN←NCF
 :For CMP :In 'gcc' 'icc' 'vsc' 'pgcc' 'clang' 'pgi'
     TMP←(NS,ID)CMP TC FN MK∆T1 IN
     ⍎'THIS.',NS,'∆',ID,'∆',CMP,'_TEST←TMP'
 :EndFor
 Z←0 0⍴⍬
∇

∇Z←ID(NCF GEN∆T2 THIS)IN;NS;FN;CMP;TC;TMP
 NS TC FN←NCF
 :For CMP :In 'gcc' 'icc' 'vsc' 'pgcc' 'clang' 'pgi'
     TMP←(NS,ID)CMP TC FN MK∆T2 IN
     ⍎'THIS.',NS,'∆',ID,'∆',CMP,'_TEST←TMP'
 :EndFor
 Z←0 0⍴⍬
∇

∇Z←ID(NCFT GEN∆T3 THIS)IN;NS;FN;CMP;TC;TMP;TL
 NS TC FN TL←NCFT
 :For CMP :In 'gcc' 'icc' 'vsc' 'pgcc' 'clang' 'pgi'
     TMP←(NS,ID)CMP TC FN TL MK∆T3 IN
     ⍎'THIS.',NS,'∆',ID,'∆',CMP,'_TEST←TMP'
 :EndFor
 Z←0 0⍴⍬
∇

:EndNamespace
