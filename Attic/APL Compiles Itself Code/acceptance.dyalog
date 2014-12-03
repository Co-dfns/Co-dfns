:Namespace acceptance
⍝ === VARIABLES ===

_←⍬
_,←':Namespace' '' 'r←0.02' 'v←0.03' 'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
_,←'' 'CNDP2←{' 'K←÷1+0.2316419×L←|⍵' 'a←L×L' 'a←*a÷¯2' 'R←a×{coeff ⎕ptred ⍵*1+⍳5}¨K' 'a←÷6.283185307*0.5'
_,←'R←a×R' 'B←⍵≥0' 'a←B ⎕index 0 ¯1' 'a←a+R' 'b←B ⎕index 1 ¯1' 'b×a' '}' '' 'bs←{S←0⌷⍺ ⋄ X←1⌷⍺ ⋄ T←⍵'
_,←'expRT←-r' 'expRT←*expRT×T' 'a←v*2' 'a←r+a÷2' 'b←⍟S÷X' 'a←b+a×T' 'D1←a÷vsqrtT←v×T*0.5' 'D2←D1-vsqrtT'
_,←'a←S×CD1←CNDP2 D1' 'R←a-X×expRT×CD2←CNDP2 D2' 'b←X×expRT×1-CD2' 's←⍴S' 's←2,s' 's⍴R,b-S×1-CD1' '}' ''
_,←,⊂':EndNamespace'
I5∆BS←_

_←⍬
_,←':Namespace' '' 'r←0.02' 'v←0.03' 'coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
_,←'' 'CNDP2←{' 'K←÷1+0.2316419×L←|⍵' 'a←L×L' 'a←*a÷¯2' 'R←a×⎕coeffred K' 'a←÷6.283185307*0.5' 'R←a×R'
_,←'B←⍵≥0' 'a←B ⎕index 0 ¯1' 'a←a+R' 'b←B ⎕index 1 ¯1' 'b×a' '}' '' 'bs←{S←0⌷⍺ ⋄ X←1⌷⍺ ⋄ T←⍵' 'expRT←-r'
_,←'expRT←*expRT×T' 'a←v*2' 'a←r+a÷2' 'b←⍟S÷X' 'a←b+a×T' 'D1←a÷vsqrtT←v×T*0.5' 'D2←D1-vsqrtT'
_,←'a←S×CD1←CNDP2 D1' 'R←a-X×expRT×CD2←CNDP2 D2' 'b←X×expRT×1-CD2' 's←⍴S' 's←2,s' 's⍴R,b-S×1-CD1' '}' ''
_,←,⊂':EndNamespace'
I5∆BS2←_

⎕ex '_'

⍝ === End of variables definition ===

(⎕IO ⎕ML ⎕WX)←0 1 3

FX←((' Fix←{n LK⊃Init CL(VF ⍺)WM GC CP FD AV FE LF RF LC DF DU DL⊃a n←PS TK VI ⍵',(⎕ucs 8867 70 73)) ' }')

 I1∆01_TEST←{2 ST'' ':Namespace' '' ':Namespace'
 }

 I1∆02_TEST←{2 ST'' ':EndNamespace'
 }

 I1∆03_TEST←{2 ST'' ':EndNamespace' '' ':Namespace'
 }

 I1∆04_TEST←{2 ST'' '' '' '' ':Namespace'
 }

 I1∆05_TEST←{2 ST'' ':Namespace' '' ':Namespace' '' ':EndNamespace'
 }

 I1∆06_TEST←{2 ST'' '' '' ''
 }

 I1∆07_TEST←{2 ST'' '' ':Namespace' ''
 }

 I1∆08_TEST←{2 ST':EndNamespace' ':Namespace' ':Namespace' ':EndNamespace'
 }

 I1∆09_TEST←{2 ST 3⍴⊂':EndNamespace'
 }

 I1∆10_TEST←{_←X 0 0⍴'' ⋄ ('tmp/i1.10'FX'' ':Namespace' '' ':EndNamespace' '').⎕NL⍳10
 }

 I1∆11_TEST←{11 ST ⍬
 }

 I1∆12_TEST←{11 ST''
 }

 I1∆13_TEST←{2 ST'' ''
 }

 I1∆14_TEST←{11 ST 55
 }

 I1∆15_TEST←{11 ST 55 33
 }

 I2∆1_TEST←{p←':Namespace' 'V4←{1014238 652510 731722 363426}'
     p,←'V3 ← {808026 392384 317583}' 'V2 ← {36669 793720 68395}'
     p,←'V1 ← 395790808' ':EndNamespace' ':Namespace'
     2 ST p}

 I2∆2_TEST←{p←':Namespace' 'V6←747772600' 'V5←{541074 592928}'
     p,←':EndNamespace' ':Namespace' ⋄ 2 ST p}

 I2∆3_TEST←{2 ST':Namespace' 'V7←' ':Namespace'
 }

 I2∆4_TEST←{_←X(1 2⍴'V8')(,3)(846 481 771 169 343 130 462)
     p←':Namespace' 'V9←864' 'V8←{846 481 771 169 343 130 462}' ':EndNamespace'
     n←'tmp/i2.4'FX p ⋄ (n.⎕NL⍳10)(n.⎕NC'V8')(n.V8 ⍬)}

 I2∆5_TEST←{('tmp/i2.5'FX in⊂'F←{',(⍕X 59 59 60 10 76 11 53 46 49 57),'}').F ⍬
 }

 I2∆6_TEST←{_←X 0 0⍴'' ⋄ ('tmp/i2.6'FX in⊂'V←63 37').⎕NL⍳10
 }

 I2∆7_TEST←{_←X 95 ⋄ ('tmp/i2.7'FX in⊂'f←{95}').f ⍬
 }

 I2∆8_TEST←{_←X 26 42 ⋄ (n.f ⍬)(n.g ⍬)⊣n←'tmp/i2.8'FX in'f←{26}' 'g←{42}'
 }

 I2∆9_TEST←{_←X 26 42 ⋄ (n.f ⍬)(n.g ⍬)⊣n←'tmp/i2.8'FX in'f←{26}' 'g←{42}' 'v←69'
 }

 I3∆1_TEST←{2 ST(in⊂''),⊂'V1'
 }

 I3∆2_TEST←{_←X 99 52 ⋄ (n.f ⍬)(n.g ⍬)⊣n←'tmp/i3.2'FX in⊂'f←{99} ⋄ g←{52}'
 }

 I3∆3_TEST←{_←X 0 0⍴'' ⋄ ('tmp/i3.3'FX in⊂'⋄').⎕NL⍳10
 }

 I3∆4_TEST←{_←X 11 ⋄ ('tmp/i3.4'FX in⊂'v←45 ⋄ f←{11}').f ⍬
 }

 I3∆5_TEST←{_←X 0 0⍴'' ⋄ ('tmp/i3.5'FX in'⋄' '⋄').⎕NL⍳10
 }

 I3∆6_TEST←{_←X 0 0⍴'' ⋄ ('tmp/i3.6'FX in⊂'{55}').⎕NL⍳10
 }

 I4∆01_TEST←{2 ST in⊂'F←{ V ⋄'
 }

 I4∆02_TEST←{_←X 1 ⋄ 6::1 ⋄ ⍎'A←(''tmp/i4.2''FX in⊂''F←{}'').F⍬'
 }

 I4∆03_TEST←{_←X 1 ⋄ ('tmp/i4.3'FX in⊂'F←{1:1 ⋄ 0}').F ⍬
 }

 I4∆04_TEST←{_←X 0 ⋄ ('tmp/i4.4'FX in⊂'F←{0:1 ⋄ 0}').F ⍬
 }

 I4∆05_TEST←{_←X 0 ⋄ ('tmp/i4.5'FX in⊂'F←{X←0}').F ⍬
 }

 I4∆06_TEST←{_←X 1 ⋄ 6::1 ⋄ ⍎'A←(''tmp/i4.6''FX in⊂''F←{0:1⋄}'').F⍬'
 }

 I4∆07_TEST←{_←X 0 ⋄ ('tmp/i4.7'FX in⊂'F←{1:X←0}').F ⍬
 }

 I4∆08_TEST←{_←X 0 ⋄ ('tmp/i4.8'FX in⊂'F←{X←1:0 ⋄ 1}').F ⍬
 }

 I4∆09_TEST←{6 ST in⊂'F←{U}'
 }

 I4∆10_TEST←{6 ST in⊂'F←{V←U}'
 }

 I4∆11_TEST←{6 ST in⊂'F←{V←V}'
 }

 I4∆12_TEST←{_←X 1 ⋄ ('tmp/i4.12'FX in⊂'F←{⋄ 1}').F ⍬
 }

 I4∆13_TEST←{_←X↑,¨'fgh' ⋄ ('tmp/i4.13'FX in⊂'f←g←h←{}').⎕NL⍳10
 }

 I4∆14_TEST←{_←X 0 0⍴'' ⋄ ('tmp/i4.14'FX in⊂'9 9 9').⎕NL⍳10
 }

 I5∆1_TEST←{_←X⍎c←'⍟*5+3×4÷1×3-|¯1' ⋄ ('tmp/i5.1'FX in⊂'F←{',c,'}').F ⍬
 }

 I5∆2_TEST←{_←X⍎c←'1⌈⌈1.5' ⋄ ('tmp/i5.2'FX in⊂'F←{',c,'}').F ⍬
 }

 I5∆3_TEST←{_←X⍎c←'2⌊⌊1.5' ⋄ ('tmp/i5.3'FX in⊂'F←{',c,'}').F ⍬
 }

 I5∆4_TEST←{_←X⍎c←'1 2 3 4+5 6 7 8' ⋄ ('tmp/i5.4'FX in⊂'F←{',c,'}').F ⍬
 }

 I5∆5_TEST←{_←X 1 ⋄ x←I5∆AT⊢Z←I5∆GD 7 ⋄ y←⍉(⍉Z[;⍳2])((d'i5.5')FX I5∆BS).bs 2⌷⍉Z
     t←∧/,1E¯7>d←|x-y ⋄ t:t ⋄ ⎕←d ⋄ t}

 I5∆AT←{r←0.02 ⋄ v←0.03 ⋄ S X T←⊂[0]⍵
     coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442
     CNDP2←{R←(÷(○2)*0.5)×(*(L×L)÷¯2)×{coeff+.×⍵*1+⍳5}¨÷1+0.2316419×L←|⍵
         (1 ¯1)[B]×((0 ¯1)[B←⍵≥0])+R}
     D1←((⍟S÷X)+(r+2÷⍨v*2)×T)÷vsqrtT←v×T*0.5 ⋄ D2←D1-vsqrtT
     ((S×CD1)-X×e×CD2),[0.5](X×(e←*(-r)×T)×1-CD2←CNDP2 D2)-S×1-CD1←CNDP2 D1}

 I5∆GD←{⍉↑(5+?⍵⍴25)(1+?⍵⍴100)(0.25+100÷⍨?⍵⍴1000)
 }

 ST←{_←X 1 ⋄ ⍺::1 ⋄ ⍎'FX ⍵'
 }

 X←{1:#.UT.expect←⍵
 }

 b_TEST←{_←X 0 ⋄ n←(d'b')FX in ⍬ ⋄ ≢n.⎕NL 1 2 3 4 9
 }

 bs1_TEST←{c←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442
     nc←'c←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
     _←X{c+.×⍵*1+⍳5}v←0.1655480359
     ((d'bs1')FX in nc'f←{{c ⎕ptred ⍵*1+⍳5}⍵}').f v}

 bs2_TEST←{c←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442
     nc←'c←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
     _←X{c+.×⍵*1+⍳5}¨v←0.1655480359 0.6962985157 0.2433096213 0.1729847827
     ((d'bs2')FX in nc'f←{{c ⎕ptred ⍵*1+⍳5}¨⍵}').f v}

 bs3_TEST←{c←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442
     nc←'c←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
     v←¯21.76006509 1.882930658 ¯13.42585061 ¯20.63899197 ¯35.58969958 ¯24.77962952
     _←X{{c+.×⍵*1+⍳5}¨÷1+0.2316419×|⍵}v
     ((d'bs3')FX in nc'f←{{c ⎕ptred ⍵*1+⍳5}¨÷1+0.2316419×|⍵}').f v}

 bs4_TEST←{c←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442
     nc←'c←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442'
     v←¯21.76006509 1.882930658 ¯13.42585061 ¯20.63899197 ¯35.58969958 ¯24.77962952
     _←X{1×{c+.×⍵*1+⍳5}¨⍵}v
     ((d'bs4')FX in nc'f←{1×{c ⎕ptred ⍵*1+⍳5}¨⍵}').f v}

 bs5_TEST←{c←-(?5⍴100)÷10 ⋄ nc←('c←',(⍕c)) ⋄ _←X|c
     ((d'bs5')FX in nc'f←{|⍵}').f c}

 c_TEST←{_←X 5 ⋄ ((d'c')FX in⊂'f←{5}').f ⍬
 }

 d←{'./tmp/',⍵
 }

 e_TEST←{11 ST 0⍴⊂''
 }

 each1_TEST←{v←0.1655480359 0.6962985157 0.2433096213 0.1729847827 0.1081775098
     _←X{⍵}¨v ⋄ ((d'each1')FX in⊂'f←{{⍵}¨⍵}').f v}

 f_TEST←{_←X(d'f.')∘,¨'c' 'so' ⋄ _←⎕SH'rm -f ',d'f.{c,so}'
     _←(d'f')FX in ⍬ ⋄ ⎕SH'ls ',d'f.{c,so}'}

 in←{(⊂':Namespace'),(,⍵),⊂':EndNamespace'
 }

 iota_TEST←{_←X⍳5 ⋄ ((d'iota')FX in⊂'f←{⍳5}').f ⍬
 }

 w_TEST←{_←X 6 ⋄ ((d'w')FX in⊂'g←{5+⍵}').g 1
 }

:EndNamespace 