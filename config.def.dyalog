:Namespace config

⍝⍝ Linux PGI with Full Testing
⍝ ##.codfns.COMPILER←'pgcc'
⍝ ##.codfns.TEST∆COMPILERS←'gcc' 'icc' 'pgcc'

⍝⍝ Window PGI with Partial Testing
⍝ ##.codfns.COMPILER←'pgi'
⍝ ##.codfns.TEST∆COMPILERS←'vsc' 'pgi'

⍝⍝ Basic Windows Defaults
##.codfns.COMPILER←'vsc'
##.codfns.TEST∆COMPILERS←⊂'vsc'

:EndNamespace
