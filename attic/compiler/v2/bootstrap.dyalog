Bootstrap;N
#.⎕SE.SALT.Load './ConTeXtLP'
TangleLoad←{_←⍺ ConTeXtLP.Tangle './hpapl.tex' ('./',⍵,'.dyalog')
    N←#.⎕SE.SALT.Load './',⍵,' -Target=#'
    ⎕←'Loaded ',⍕N
}
'Bootstrap' TangleLoad 'bootstrap'
'TokVisitor Interface'TangleLoad'tokvisitor'
'NumTokVis Interface'TangleLoad'numtokvis'
'FactProto Interface'TangleLoad'factproto'
'ASTVis Interface' TangleLoad 'astvis'
'NumberVis Interface' TangleLoad 'numbervis'

'HPAPL Class'ConTeXtLP.Tangle'./hpapl.tex' './hpapl.dyalog'
N←#.⎕SE.SALT.Load './hpapl -Target=#'
⎕←'Loaded ',⍕N
