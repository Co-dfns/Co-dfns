:Namespace SR
  (⎕IO ⎕ML ⎕WX)←0 1 3
  addm←{⍺}                     ⋄ addd←{⍺,'+',⍵}
  subm←{'-1*',⍵}               ⋄ subd←{⍺,'-',⍵}
  mulm←{'(',⍵,'>0)-(',⍵,'<0)'} ⋄ muld←{⍺,'*',⍵}
  divm←{'1.0/',⍵}              ⋄ divd←{'(1.0*',⍺,')/(1.0*',⍵,')'}
  powm←{'exp(',dtp,⍵,')'}      ⋄ powd←{'pow(',dtp,⍺,',',dtp,⍵,')'}
  logm←{'log(',dtp,⍵,')'}      ⋄ logd←{'log(',dtp,⍵,',',dtp,⍺,')'}
  modm←{'fabs(',⍵,')'}         ⋄ modd←{'fmod(',dtp,⍵,',',dtp,⍺,')'}
  
  pitm←{'3.14159265358979323846*',⍵} 
  
  gted←{⍺,'>=',⍵}
  
  zck←{';if(',⍵,'==0)error(11)'}
  dtp←'(double)'
  
  sdb←,¨'+-×÷*⍟|○≥'
  sdn←'add' 'sub' 'mul' 'div' 'pow' 'log' 'mod' 'pit' 'gte'
  smt←↑(0 1)(0 1)(1 1)(0 0)(0 0)(0 0)(0 1)(0 0)(0 0)
  sdt←(0 0 0 1)(0 0 0 1)(0 0 0 1)(0 0 0 0)(0 0 0 1)(0 0 0 0)
  sdt,←(0 0 0 1)(0 0 0 0)(1 1 1 1)
  sdt←↑sdt
:EndNamespace 