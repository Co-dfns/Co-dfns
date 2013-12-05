:Namespace PEG

    ⎕IO←0 ⋄ NL←⎕UCS 10

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ What is a Parser?
⍝
⍝ A parser is an ambivalent function taking a character vector on the right and
⍝ an optional index on the left. It attempts to parse from the 0th character
⍝ or the given index. It returns a triple of the following form:
⍝
⍝     0 index of character after parsed characters
⍝     1 object that was parsed
⍝     2 type of parser that returned the object
⍝
⍝ If it is unable to parse the object, it will return a negative number
⍝ indicating the point of failure, a short snippet of the error position
⍝ as the object, and the error name in the third position.

⍝ Legend
⍝
⍝     cv    character vector
⍝     p     parser
⍝     n     number
⍝     i     index
⍝     ⍬     No return/no value/empty value

⍝ Reporting errors: cv ERR i cv → ⍬
⍝
⍝ The following function is used to report errors. It takes the index and
⍝ character vector on the right and optionally the name of the parser
⍝ that was trying to parse on the left.

    ERR←{⍺←⊢ ⋄ i c←⍵ ⋄ (¯1⌊-i)((7⌊⍴s)↑s←i↓c)(⍺⊣'')}

⍝ Parser Combinator: cv LIT → p
⍝
⍝ Recognizes a literal string and returns that string as its object.

      LIT←{⍺←⊢ ⋄ i←⍺⊣0 ⋄ t←,⍺⍺
          i←i Skipper ⍵
          i≥⊃⍴⍵:'EOF'ERR i ⍵
          t≡(⍴t)↑i↓⍵:(i+⊃⍴t)t'LIT'
          ('LIT[',t,']')ERR i ⍵
      }

⍝ Parser Combinator: cv CHR → p
⍝
⍝ Recognize a character out of a set of characters.

      CHR←{⍺←⊢ ⋄ i←⍺⊣0
          i←i Skipper ⍵
          i≥⊃⍴⍵:'EOF'ERR i ⍵
          ⍵[i]∊⍺⍺:(i+1)(⍵[i])'CHR'
          ('CHR[''',⍺⍺,''']')ERR i ⍵
      }

⍝ Common Character Classes
⍝
⍝ The following are some parsers for common character classes.

    UPPER←'ABCDEFGHIJKLMNOPQRSTUVWXYZ'CHR
    LOWER←'abcdefghijklmnopqrstuvwxyz'CHR
    ALPHA←'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'CHR
    DIGIT←'0123456789'CHR
    ALNUM←'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'CHR
    WHITE←('     ',NL,(⎕UCS 13))CHR
    BLANK←'     'CHR
    LNBRK←NL (⎕UCS 13)CHR

⍝ Repetition Parser Combinators
⍝
⍝     p PLS → p   ⍝ + (Plus) One or more
⍝     p ANY → p   ⍝ * (Star) Zero or more
⍝
⍝ These parser combinators do what their regular expression equivalents do.
⍝ They are pretty straight forward, but return a vector of their parsed
⍝ elements.

      PLS←{⍺←⊢ ⋄ i←⍺⊣0 ⋄ c←⍵
          i←i Skipper ⍵
          do←{⍺←⊢ ⋄ n←⍺⊣0 ⋄ i r←⍵
              i←i Skipper ⍵
              i e t←i ⍺⍺ c
              ¯1≡×i:n,⍵
              (n+1)∇ i(r,⊂e)
          }
          n i r←⍺⍺ do i ⍬
          n≠0:i r'SEQ'
          'PLS'ERR i c
      }

      ANY←{⍺←⊢ ⋄ i←⍺⊣0
          i r t←⍺ ⍺⍺ PLS ⍵
          ¯1≡×i:i ⍬'SEQ'
          i r'SEQ'
      }

⍝ Sequencing Parser Combinator: p SEQ p → p
⍝
⍝ This parser recognizes a sequence of parsers chained together. It
⍝ returns a vector of the parsed objects, but with the caveat that if the
⍝ objects returned were themselves created by SEQ parsers, then their
⍝ vectors are spliced into the resulting vector. This helps to ease the
⍝ creation of sequences of objects without worrying about nesting.

      SEQ←{⍺←⊢ ⋄ i←⍺⊣0
          i←i Skipper ⍵
          ni r1 t1←⍺ ⍺⍺ ⍵
          ¯1≡×ni:'SEQ'ERR ni ⍵
          ni←ni Skipper ⍵
          ni r2 t2←ni ⍵⍵ ⍵
          ¯1≡×ni:'SEQ'ERR ni ⍵
          ∧/t1 t2∊⊂'SEQ':ni(r1,r2)'SEQ'
          t1≡'SEQ':ni(r1,⊂r2)'SEQ'
          t2≡'SEQ':ni((⊂r1),r2)'SEQ'
          ni(r1 r2)'SEQ'
      }

⍝ Choice Parser Combinator: p OR p → p
⍝
⍝ The choice combinator tries to use the left parser first, and if that
⍝ fails, will try to use the right parser. This is an ordered, deterministic
⍝ choice by design. It returns the value that was returned by the successful
⍝ parsing.

      OR←{⍺←⊢ ⋄ i←⍺⊣0
          i←i Skipper ⍵
          i r t←⍺ ⍺⍺ ⍵
          ¯1≡×i:⍺ ⍵⍵ ⍵
          i r t
      }

⍝ Post-processing/Wrapping Parser Combinator: f WRP p → p
⍝
⍝ If a successful parse occurs, wrap the returned object
⍝ using f; that is, replace the return object with the result
⍝ of apply f on that object.

      WRP←{⍺←⊢ ⋄ i←⍺⊣0
          i←i Skipper ⍵
          ni r t←⍺ ⍵⍵ ⍵
          ¯1≡×ni:ni r t
          ni(⍺⍺ r)'WRP'
      }

⍝ Optional Parser Combinator: p OPT → p
⍝
⍝ Tries the given parser, and returns parser result if successful,
⍝ but otherwise returns and empty result if not, does not fail.

      OPT←{⍺←⊢ ⋄ i←⍺⊣0
          i←i Skipper ⍵
          ni r t←⍺ ⍺⍺ ⍵
          ¯1≡×ni:i ⍬'OPT'
          ni r t
      }

⍝ Skippers
⍝
⍝ The default behavior of parsers is to skip spaces and tabs. This
⍝ behavior can be changed by assigning the Skipper variable to a
⍝ new skipper. A skipper takes the same inputs as a parser, but 
⍝ returns only an index to the first character that is not to be 
⍝ skipped.

      SkipperBlank←{⍺←⊢ ⋄ i←⍺⊣0
          ⎕←'Skipper on ',i,' ',10↑⍵
          i≥⊃⍴⍵:i
          ~⍵[i]∊'  ':i
          ⍵ ∇⍨i+1
      }
    
    Skipper←SkipperBlank

⍝ Lexing Parser Combinator: p LEX → p
⍝
⍝ Lexing turns off the skipping behavior for the duration of the
⍝ parser given to it.

      LEX←{⍺←⊢ ⋄ i←⍺⊣0
          Old←Skipper
          i←i Skipper ⍵
          ##.PEG.Skipper←{⍺←⊢ ⋄ ⍺⊣0}
          i r t←⍺ ⍺⍺ ⍵
          ##.PEG.Skipper←Old
          i r t
      }


:EndNamespace