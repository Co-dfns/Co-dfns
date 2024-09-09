∇ {LIB}MK∆RTM path;src;vsbat;vsc;gcc;clang;codfns_h;CR;LF;data;header

  ⍎'LIB←'''''⌿⍨0=⎕NC'LIB'

  src←⊃⎕NGET path,'/rtm/prim.apln'
  echo←{⍺←⊢ ⋄ ⍺ ⍺⍺ ⍵⊣⍞←⍵⍵}
  data header←'prim'GC echo 'G' TT echo 'C' PS echo 'P' ⊢ src
  (path,'/rtm/prim.c')put data
  (path,'/rtm/prim.h')put header
  
  codfns_h←⊃⎕NGET path,'/rtm/codfns.h.template'
  codfns_h,←CR LF←⎕UCS 13 10
  codfns_h,←'/* Runtime primitives */',CR LF
  codfns_h,←'#ifndef BUILD_CODFNS',CR LF
  codfns_h,←header
  codfns_h,←CR LF
  codfns_h,←'DECLSPEC struct cdf_prim_loc cdf_prim;',CR LF
  codfns_h,←'#endif',CR LF
  codfns_h,←CR LF
  (path,'/rtm/codfns.h')put codfns_h
  
  →opsys WINDOWS LINUX MAC
  
  WINDOWS:
  	vsbat←VS∆PATH,'\VC\Auxiliary\Build\vcvarsall.bat'
  	
  	vsc←'%comspec% /C ""',vsbat,'" amd64'
  	vsc,←'  && cd "',path,'\rtm"'
  	vsc,←'  && cl /std:c17 /Zc:preprocessor /MP /W3 /wd4102 /wd4275'
  	vsc,←'    /DEBUG /O2 /Zc:inline /Zi /FS'
  	vsc,←'    /Fo".\\" /Fd"codfns.pdb"'
  	vsc,←'    /WX /MD /EHsc /nologo'
  	vsc,←'    /I"%AF_PATH%\include"'
  	vsc,←'    /D"NOMINMAX" /D"AF_DEBUG" /D"BUILD_CODFNS"'
	vsc,←'    /D"_CRT_SECURE_NO_WARNINGS"'
  	vsc,←'    "*.c" /link /DLL /OPT:REF'
  	vsc,←'    /INCREMENTAL:NO /SUBSYSTEM:WINDOWS'
  	vsc,←'    /LIBPATH:"%AF_PATH%\lib"'
  	vsc,←'    /DYNAMICBASE "af',LIB,'.lib"'
  	vsc,←'    /OPT:ICF /ERRORREPORT:PROMPT'
  	vsc,←'    /TLBID:1 /OUT:"codfns.dll""'
  	
  	⎕CMD ⎕←vsc
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.h" "',path,'\tests\"'
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.exp" "',path,'\tests\"'
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.lib" "',path,'\tests\"'
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.pdb" "',path,'\tests\"'
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.dll" "',path,'\tests\"'
  →0
  
  LINUX:
  	gcc ←'cd ''',path,'/rtm'''
  	gcc,←'  && gcc -std=c17 -O2 -g -Wall -fPIC -shared'
  	gcc,←'    -Wno-parentheses -Wno-misleading-indentation -Wno-unused-variable'
  	gcc,←'    -Wno-incompatible-pointer-types -Wno-missing-braces'
  	gcc,←'    -Wno-unused-but-set-variable'
  	gcc,←'    -DNOMINMAX -DAF_DEBUG -DBUILD_CODFNS'
  	gcc,←'    -I''',AF∆PREFIX,'/include'' -L''',AF∆PREFIX,'/lib64'''
  	gcc,←'    -o libcodfns.so *.c -lm -laf',LIB
  	
  	⎕CMD ⎕←gcc
  	⎕CMD ⎕←'cp "',path,'/rtm/codfns.h" "',path,'/tests/"'
  	⎕CMD ⎕←'cp "',path,'/rtm/libcodfns.so" "',path,'/tests/"'
  →0
  
  MAC:
  	clang ←'cd ''',path,'/rtm'''
  	clang,←'  && clang -std=c99 -O2 -g -Wall -fPIC -shared'
  	clang,←'    -Wno-parentheses -Wno-misleading-indentation -Wno-unused-variable'
  	clang,←'    -Wno-incompatible-pointer-types -Wno-missing-braces'
  	clang,←'    -Wno-unused-but-set-variable'
  	clang,←'    -DNOMINMAX -DAF_DEBUG -DBUILD_CODFNS'
  	clang,←'    -I''',AF∆PREFIX,'/include'' -L''',AF∆PREFIX,'/lib'''
  	clang,←'    -o libcodfns.dylib *.c -lm -laf',LIB
  	
  	⎕CMD ⎕←clang
  	⎕CMD ⎕←'cp "',path,'/rtm/codfns.h" "',path,'/tests/"'
  	⎕CMD ⎕←'cp "',path,'/rtm/libcodfns.dylib" "',path,'/tests/"'
  →0
∇