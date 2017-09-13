:Namespace namedns_tests

BS←':Namespace thisisaname123' 'Run←{⍵}' ':EndNamespace'

namedns_TEST←{#.UT.expect←⍳10 ⋄ ns←'namedns'#.codfns.Fix BS
 ns.Run ⍳10}

:EndNamespace
