∇ INSTALL∆RTM path
  →opsys WINDOWS LINUX MAC

WINDOWS:
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.h" ".\"'
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.exp" ".\"'
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.lib" ".\"'
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.pdb" ".\"'
  	⎕CMD ⎕←'copy "',path,'\rtm\codfns.dll" ".\"'
  →0

LINUX:
  	⎕CMD ⎕←'cp "',path,'/rtm/codfns.h" "./"'
  	⎕CMD ⎕←'cp "',path,'/rtm/libcodfns.so" "./"'
  →0

MAC:
  	⎕CMD ⎕←'cp "',path,'/rtm/codfns.h" "./"'
  	⎕CMD ⎕←'cp "',path,'/rtm/libcodfns.dylib" "./"'
  →0
∇