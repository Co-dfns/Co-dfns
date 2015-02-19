:Namespace U
  (⎕IO ⎕ML ⎕WX)←0 1 3
  var←{(,'⍺')≡⍺:'l' ⋄ (,'⍵')≡⍺:'r' ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
  nl←⎕UCS 13 10
  do←{'{BOUND i;for(i=0;i<',(⍕⍺),';i++){',⍵,'}}',nl}
  pdo←{'{BOUND i;',nl,'#pragma parallel',nl,'for(i=0;i<',(⍕⍺),';i++){',⍵,'}}',nl}
  tl←{('di'⍳⍵)⊃¨⊂('APLDOUB' 'double')('APLLONG' 'aplint32')}
:EndNamespace
