:Namespace C
  (⎕IO ⎕ML ⎕WX)←0 1 3

  COMPILER←'gcc'
  TEST∆COMPILERS←'gcc' 'icc' 'pgi'

  cfs←'-funsigned-bitfields -funsigned-char -fvisibility=hidden '
  cds←'-DxxBIT=64 -DHAS_UNICODE=1 -DUNIX=1 -DWANT_REFCOUNTS=1 -D_DEBUG=1 '
  cso←'-fPIC -shared -I./dwa '
  gop←'-Ofast -Wall -Wno-unused-function '
  iop←'-fast -fno-alias -static-intel -Wall -Wno-unused-function '
  fls←{'-o ''',⍵,'_',⍺,'.so'' dwa/dwa_fns.c ''',⍵,'_',⍺,'.c'' '}
  log←{'> ',⍵,'_',⍺,'.log 2>&1'}
  gcc←{⎕SH'gcc ',cfs,cds,cso,gop,('gcc'fls ⍵),'gcc'log ⍵}
  icc←{⎕SH'icc ',cfs,cds,cso,iop,('icc'fls ⍵),'icc'log ⍵}
  
  tie←{0::⎕SIGNAL ⎕EN ⋄ 22::⍵ ⎕NCREATE 0 ⋄ 0 ⎕NRESIZE ⍵ ⎕NTIE 0}
  put←{s←(¯128+256|128+'UTF-8'⎕UCS ⍺)⎕NAPPEND(t←tie ⍵)83 ⋄ 1:r←s⊣⎕NUNTIE t}

  Fix←{(⍎COMPILER)⍺⊣(⍺,'_',COMPILER,'.c')put⍨##.G.gc ##.T.tt⊃a n←##.P.ps ⍵}
  
:EndNamespace
