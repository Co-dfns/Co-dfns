# Reviewer Comments

----------------------- REVIEW 1 ---------------------
PAPER: 18
TITLE: Co-dfns: Ancient Language, Modern Compiler
AUTHORS: Aaron Hsu

OVERALL EVALUATION: 2 (Good paper. I will CHAMPION it.)
REVIEWER'S CONFIDENCE: 2 (low)

----------- REVIEW -----------
This paper presents initial work on building a modern APL implementation
intended to scale to the large data sizes that users face today. It
extends existing threading and SIMD parallelism in APL (particularly the
DYALOG interpreter) with explicit task parallelism. The intention is to
do this in a way that makes it easy for current APL users to embrace the
extension without too much disruption to their ways of working. This is
part of what makes the paper interesting. (The work is supported by
DYALOG.)

The compiler itself seems to be written in APL!  (Is this really so?) It
uses the dfns language from the APL interpreter to compose nanopasses.


minor:

represent a critical business tool domain experts.      ?  missing "for"  ?

abstractions, [26]    swap comma and ref
also on p 5 . [3]


----------------------- REVIEW 2 ---------------------
PAPER: 18
TITLE: Co-dfns: Ancient Language, Modern Compiler
AUTHORS: Aaron Hsu

OVERALL EVALUATION: 1 (OK paper, but I will not champion it.)
REVIEWER'S CONFIDENCE: 2 (low)

----------- REVIEW -----------
The paper describes an effort to extend APL with support for task
parallelism, as well as to develop a compiler that supports these
features for Dyalog APL.

The paper is definitely relevant to the workshop topic. I found the
language extension part more interesting than the compiler description,
as the compiler implementation is work in progress with so far few
details to distinguish it from other compiler efforts.

I wish the paper would provide more discussion on how its programming
simplifies task-parallel programming compared to more traditional
approaches. It's also hard to understand if the compiler supports
parallelism at this stage and if not, what novelty it brings compared to
other APL compilers.


----------------------- REVIEW 3 ---------------------
PAPER: 18
TITLE: Co-dfns: Ancient Language, Modern Compiler
AUTHORS: Aaron Hsu

OVERALL EVALUATION: 1 (OK paper, but I will not champion it.)
REVIEWER'S CONFIDENCE: 3 (medium)

----------- REVIEW -----------
(no review)
