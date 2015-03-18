:Namespace U
  (⎕IO ⎕ML ⎕WX)←0 1 3
  var←{(,'⍺')≡⍺:'l' ⋄ (,'⍵')≡⍺:'r' ⋄ '&env[',(⍕⊃⍵),'][',(⍕⊃⌽⍵),']'}
  nl←⎕UCS 13 10
  for←{'for(i=0;i<',(⍕⍵),';i++){'}
  do←{'{BOUND i;',(for ⍺),⍵,'}}',nl}
  pdo←{'{BOUND i;',nl,'#pragma parallel',nl,(for ⍺),⍵,'}}',nl}
  tl←{('di'⍳⍵)⊃¨⊂('APLDOUB' 'double')('APLLONG' 'aplint32')}
:EndNamespace
