NS←{
	MKA←{mka⊂⍵} ⋄ EXA←{exa ⍬ ⍵}
	Display←{⍺←'Co-dfns' ⋄ W←w_new⊂⍺ ⋄ 777::w_del W
	 w_del W⊣W ⍺⍺{w_close ⍺:⍎'⎕SIGNAL 777' ⋄ ⍺ ⍺⍺ ⍵}⍣⍵⍵⊢⍵}
	LoadImage←{⍺←1 ⋄ ~⎕NEXISTS ⍵:⎕SIGNAL 22 ⋄ loadimg ⍬ ⍵ ⍺}
	SaveImage←{⍺←'image.png' ⋄ saveimg ⍵ ⍺}
	Image←{~2 3∨.=≢⍴⍵:⎕SIGNAL 4 ⋄ (3≠⊃⍴⍵)∧3=≢⍴⍵:⎕SIGNAL 5 ⋄ ⍵⊣w_img ⍵ ⍺}
	Plot←{2≠≢⍴⍵:⎕SIGNAL 4 ⋄ ~2 3∨.=1⊃⍴⍵:⎕SIGNAL 5 ⋄ ⍵⊣w_plot (⍉⍵) ⍺}
	Histogram←{⍵⊣w_hist ⍵,⍺}
	Rtm∆Init←{
		_←'w_new'⎕NA'P ',⍵,'|w_new <C[]'
		_←'w_close'⎕NA'I ',⍵,'|w_close P'
		_←'w_del'⎕NA ⍵,'|w_del P'
		_←'w_img'⎕NA ⍵,'|w_img <PP P'
		_←'w_plot'⎕NA ⍵,'|w_plot <PP P'
		_←'w_hist'⎕NA ⍵,'|w_hist <PP F8 F8 P'
		_←'loadimg'⎕NA ⍵,'|loadimg >PP <C[] I'
		_←'saveimg'⎕NA ⍵,'|saveimg <PP <C[]'
		_←'exa'⎕NA ⍵,'|exarray >PP P'
		_←'mka'⎕NA'P ',⍵,'|mkarray <PP'
		_←'FREA'⎕NA ⍵,'|frea P'
		_←'Sync'⎕NA ⍵,'|cd_sync'
		0 0 ⍴ ⍬}
	mkna←{'I ',⍺,'|',((,¨'∆⍙')⎕R'_del_' '_delubar_'⊢⍵),' P P P'}
	mkf←{
		fn←⍺,'|cdf_',((,¨'∆⍙')⎕R'_del_' '_delubar_'⊢⍵),'_dwa '
		z←⊂'Z←{A}',⍵,' W;err;res'
		z,←⊂':If 0=⎕NC''⍙.',⍵,'_mon'''
		z,←⊂'       ''',⍵,'_mon''⍙.⎕NA''I ',fn,'>PP P <PP'''
		z,←⊂'       ''',⍵,'_dya''⍙.⎕NA''I ',fn,'>PP <PP <PP'''
		z,←⊂':EndIf'
		z,←⊂':If 0=⎕NC''A'''
		z,←⊂'       err res←⍙.',⍵,'_mon 0 0 W'
		z,←⊂':Else'
		z,←⊂'       err res←⍙.',⍵,'_dya 0 A W'
		z,←⊂':EndIf'
		z,←⊂'→0⌿⍨err<0'
		z,←⊂'→ret⌿⍨err=0'
		z,←⊂'(res,(⎕UCS 10),⎕EM err)⎕SIGNAL err'
		z,←⊂'ret:Z←res'
		z
	}
	ns←#.⎕NS⍬ ⋄ _←'∆⍙'ns.⎕NS¨⊂⍬ ⋄ ∆ ⍙←ns.(∆ ⍙)
	∆.names←(0⍴⊂''),(2=1⊃⍺)⌿0⊃⍺
	fns←'Rtm∆Init' 'MKA' 'EXA' 'Display'
	fns,←'LoadImage' 'SaveImage' 'Image' 'Plot' 'Histogram'
	fns,←'soext' 'opsys' 'mkna'
	_←∆.⎕FX∘⎕CR¨fns
	∆.(decls←⍵∘mkna¨names)
	_←ns.⎕FX¨(⊂''),⍵∘mkf¨∆.names
	_ ←⊂'Z←Init'
	_,←⊂'Z←Rtm∆Init ''',⍵,''''
	_,←⊂'→0⌿⍨0=≢names'
	_,←⊂'names ##.⍙.⎕NA¨decls'
	_←∆.⎕FX _
	ns
}
