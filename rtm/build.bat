cl /W4 /WX /LD /std:c17 /Zi /O2 /Fd"codfns.pdb" /I"%AF_PATH%\include" /D"NOMINMAX" codfns.c /link /LIBPATH:"%AF_PATH%\lib" /DYNAMICBASE "af.lib"
for %%f in (codfns.dll codfns.lib codfns.pdb) do copy /Y %%f ..\tests\

