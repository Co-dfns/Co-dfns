:Namespace Help

 ⎕IO  ←0 ⍝ *** DO NOT change these system variables here, only after the variables definition 

⍝ === VARIABLES ===

L←⎕av[3+⎕io]
_←⍬
_,←'About HPAPL'
_,←L,11⍴⎕av[225]
_,←L,''
_,←L,'This is the HPAPL compiler.  It is designed to target the UPC runtime.  We '
_,←L,'have designed it with a nanopass style of compiler development in mind.  '
_,←L,'The system is composed of the following passes:'
_,←L,''
_,←L,'  Pass         Documentation'
_,←L,'  ',⎕av[225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225]
_,←L,'  Tokenizer    Help.Tokenizer'
_,←L,'  Parser       Help.Parser'
_,←L,'  EmitUPC      Help.EmitUPC'
_,←L,''
_,←L,'At the moment, the HPAPL compiler is still feature incomplete, but we are '
_,←L,'working on getting this fixed.'
_,←L,''
About←_

_←⍬
_,←'HPAPL Todo List'
_,←L,15⍴⎕av[225]
_,←L,''
_,←L,'∘ Basic data readings'
_,←L,'∘ Basic primitives'
_,←L,'∘ Variable assignment'
_,←L,'∘ Structured programming constructs'
_,←L,'∘ Function definition'
_,←L,'∘ Top-level definitions'
_,←L,'∘ Single-assignment matrices'
_,←L,'∘ Projection functions'
_,←L,''
Todo←_

_←⍬
_,←'Pass: Tokenizer'
_,←L,15⍴⎕av[225]
_,←L,''
_,←L,'Input: Vector of Characters'
_,←L,'Output: Matrix R where N 2≡⍴R where N is the number of tokens'
_,←L,''
_,←L,'Tokenizer is a basic tokenizer for the HPAPL Compiler.  It will accept the '
_,←L,'input file and return the tokenized version of that input.  At this time, '
_,←L,'that output is a two-column matrix of tokens where the first column is '
_,←L,'the token type, and the second column is the value. '
_,←L,''
_,←L,'  Type    Description'
_,←L,'  ',⎕av[225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225 225]
_,←L,'  1       Number'
_,←L,'  2       Character or String'
_,←L,'  3       Primitive'
_,←L,'  '
_,←L,'This is expected to be the first pass in the Compiler. The Parser function '
_,←L,'is expected to run after this.'
_,←L,''
_,←L,'See also: Compile, Parser.'
_,←L,''
Tokenizer←_

⎕ex¨ 'L' '_'

⍝ === End of variables definition ===

⎕IO ⎕ML ⎕WX←0 0 3

:EndNamespace 