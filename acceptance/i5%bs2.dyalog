⌷I5∆BS2←
<array><shape>38</shape>
<array><shape>10</shape><string>:Namespace</string></array>
<array><shape>0</shape><string></string></array>
<array><shape>6</shape><string>r←0.02</string></array>
<array><shape>6</shape><string>v←0.03</string></array>
<array><shape>65</shape><string>coeff←0.31938153 ¯0.356563782 1.781477937 ¯1.821255978 1.33027442</string></array>
<array><shape>0</shape><string></string></array>
<array><shape>7</shape><string>CNDP2←{</string></array>
<array><shape>19</shape><string>K←÷1+0.2316419×L←|⍵</string></array>
<array><shape>5</shape><string>a←L×L</string></array>
<array><shape>7</shape><string>a←*a÷¯2</string></array>
<array><shape>15</shape><string>R←a×⎕coeffred K</string></array>
<array><shape>18</shape><string>a←÷6.283185307*0.5</string></array>
<array><shape>5</shape><string>R←a×R</string></array>
<array><shape>5</shape><string>B←⍵≥0</string></array>
<array><shape>15</shape><string>a←B ⎕index 0 ¯1</string></array>
<array><shape>5</shape><string>a←a+R</string></array>
<array><shape>15</shape><string>b←B ⎕index 1 ¯1</string></array>
<array><shape>3</shape><string>b×a</string></array><char>}</char>
<array><shape>0</shape><string></string></array>
<array><shape>23</shape><string>bs←{S←0⌷⍺ ⋄ X←1⌷⍺ ⋄ T←⍵</string></array>
<array><shape>8</shape><string>expRT←-r</string></array>
<array><shape>14</shape><string>expRT←*expRT×T</string></array>
<array><shape>5</shape><string>a←v*2</string></array>
<array><shape>7</shape><string>a←r+a÷2</string></array>
<array><shape>6</shape><string>b←⍟S÷X</string></array>
<array><shape>7</shape><string>a←b+a×T</string></array>
<array><shape>19</shape><string>D1←a÷vsqrtT←v×T*0.5</string></array>
<array><shape>12</shape><string>D2←D1-vsqrtT</string></array>
<array><shape>16</shape><string>a←S×CD1←CNDP2 D1</string></array>
<array><shape>24</shape><string>R←a-X×expRT×CD2←CNDP2 D2</string></array>
<array><shape>15</shape><string>b←X×expRT×1-CD2</string></array>
<array><shape>4</shape><string>s←⍴S</string></array>
<array><shape>5</shape><string>s←2,s</string></array>
<array><shape>13</shape><string>s⍴R,b-S×1-CD1</string></array><char>}</char>
<array><shape>0</shape><string></string></array>
<array><shape>13</shape><string>:EndNamespace</string></array></array>