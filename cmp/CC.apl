CC←{
	data←⍵
	ostype←opsys 'win' 'linux' 'mac'
	_←data ⎕NPUT (⍺,'.c')1
	'win'≡ostype:⍺{
		vsbat←VS∆PATH,'\VC\Auxiliary\Build\vcvarsall.bat'
		~⎕NEXISTS vsbat:'MISSING VISUAL C'⎕SIGNAL 99
		
		vsc←'%comspec% /C ""',vsbat,'" amd64'
		vsc,←'	&& cd "',(⊃⎕CMD'echo %CD%'),'"'
		vsc,←'  && cl /std:c17 /Zc:preprocessor /MP /W3 /wd4102 /wd4275'
		vsc,←'    /DEBUG /O2 /Zc:inline /Zi /FS'
		vsc,←'    /Fo".\\" /Fd"',⍺,'.pdb"'
		vsc,←'    /WX /MD /EHsc /nologo'
		vsc,←'    /D"_CRT_SECURE_NO_WARNINGS"'
		vsc,←'    "',⍺,'.c" /link /DLL /OPT:REF'
		vsc,←'    /INCREMENTAL:NO /SUBSYSTEM:WINDOWS'
		vsc,←'    /DYNAMICBASE "codfns.lib"'
		vsc,←'    /OPT:ICF /ERRORREPORT:PROMPT'
		vsc,←'    /TLBID:1 /OUT:"',⍺,'.dll" > "',⍺,'.log""'
		
		⎕←⍪⊃⎕NGET(⍺,'.log')1⊣⎕CMD vsc⊣1 ⎕NDELETE ⍺,'.dll'
		⎕NEXISTS f←⍺,'.dll':f
		'COMPILE ERROR' ⎕SIGNAL 22
	}⍵
	'linux'≡ostype:⍺{
		gcc ←'gcc -std=c17 -O2 -g -Wall -fPIC -shared'
		gcc,←' -Wno-parentheses -Wno-misleading-indentation -Wno-unused-variable'
		gcc,←' -Wno-incompatible-pointer-types -Wno-missing-braces'
		gcc,←' -Wno-unused-but-set-variable'
		gcc,←' -L. -o ''',⍺,'.so'' ''',⍺,'.c'' -lcodfns'
		gcc,←' > ''',⍺,'.log'' 2>&1'
		
		⎕←⍪⊃⎕NGET(⍺,'.log')1⊣⎕CMD gcc⊣1 ⎕NDELETE ⍺,'.so'
		⎕NEXISTS f←⍺,'.so':f
		'COMPILE ERROR' ⎕SIGNAL 22		
	}⍵
	'mac'≡ostype:⍺{
		clang ←'clang -arch x86_64 -std=c17 -O2 -g -Wall -fPIC -shared'
		clang,←' -Wno-parentheses -Wno-misleading-indentation -Wno-unused-variable'
		clang,←' -Wno-incompatible-pointer-types -Wno-missing-braces'
		clang,←' -Wno-unused-but-set-variable'
		clang,←' -o ''',⍺,'.dylib'' ''',⍺,'.c'''
		clang,←' -Wl,-rpath,. ./libcodfns.dylib'
		clang,←' > ''',⍺,'.log'' 2>&1'
		
		⎕←⍪⊃⎕NGET(⍺,'.log')1⊣⎕CMD clang⊣1 ⎕NDELETE ⍺,'.dylib'
		⎕NEXISTS f←⍺,'.dylib':f
		'COMPILE ERROR' ⎕SIGNAL 22		
	}⍵
}

CX←{
	data←⍵
	ostype←opsys 'win' 'linux' 'mac'
	_←data ⎕NPUT (⍺,'.c')1
	'win'≡ostype:⍺{
		vsbat←VS∆PATH,'\VC\Auxiliary\Build\vcvarsall.bat'
		~⎕NEXISTS vsbat:'MISSING VISUAL C'⎕SIGNAL 99
		
		vsc←'%comspec% /C ""',vsbat,'" amd64'
		vsc,←'	&& cd "',(⊃⎕CMD'echo %CD%'),'"'
		vsc,←'  && cl /Zc:preprocessor /MP /W3 /wd4102 /wd4275'
		vsc,←'    /DEBUG /Od /Zc:inline /Zi /FS'
		vsc,←'    /Fo".\\" /Fd"',⍺,'.pdb"'
		vsc,←'    /WX /MD /EHsc /nologo'
		vsc,←'    "',⍺,'.c" /link /OPT:REF'
		vsc,←'    /INCREMENTAL:NO '
		vsc,←'    /DYNAMICBASE "codfns.lib"'
		vsc,←'    /OPT:ICF /ERRORREPORT:PROMPT'
		vsc,←'    /OUT:"',⍺,'.exe" > "',⍺,'.log""'
		
		log←⍪⊃⎕NGET(⍺,'.log')1⊣⎕CMD vsc⊣1 ⎕NDELETE ⍺,'.exe'
		⎕NEXISTS f←⍺,'.exe':f log
		⎕←log
		'COMPILE ERROR' ⎕SIGNAL 22
	}⍵
	'linux'≡ostype:⍺{
		gcc,←' -Wno-parentheses -Wno-misleading-indentation -Wno-unused-variable'
		gcc,←' -Wno-incompatible-pointer-types -Wno-missing-braces'
		gcc ←'gcc -std=c17 -O2 -g -Wall -fPIC'
		gcc,←' -Wno-unused-but-set-variable'
		gcc,←' -L. -o ''',⍺,''' ''',⍺,'.c'' -lcodfns'
		gcc,←' > ''',⍺,'.log'' 2>&1'
		
		log←⍪⊃⎕NGET(⍺,'.log')1⊣⎕CMD gcc⊣1 ⎕NDELETE ⍺
		⎕NEXISTS f←⍺:f log
		⎕←log
		'COMPILE ERROR' ⎕SIGNAL 22		
	}⍵
	'mac'≡ostype:⍺{
		clang ←'clang -arch x86_64 -std=c17 -O2 -g -Wall -fPIC'
		clang,←' -Wno-parentheses -Wno-misleading-indentation -Wno-unused-variable'
		clang,←' -Wno-incompatible-pointer-types -Wno-missing-braces'
		clang,←' -Wno-unused-but-set-variable'
		clang,←' -o ''',⍺,''' ''',⍺,'.c'''
		clang,←' -Wl,-rpath,. ./libcodfns.dylib'
		clang,←' > ''',⍺,'.log'' 2>&1'
		
		log←⍪⊃⎕NGET(⍺,'.log')1⊣⎕CMD clang⊣1 ⎕NDELETE ⍺
		⎕NEXISTS f←⍺:f log
		⎕←log
		'COMPILE ERROR' ⎕SIGNAL 22		
	}⍵
}
