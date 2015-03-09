# Co-dfns Compiler Style Guide

This guide provides basic rules and structure for the design of the compiler. 
Some of the terms here come from Moseley's "Out of the Tar Pit" paper, and 
the reader can find their definitions in that paper. The style suggested in 
the paper has obviously been adapted to fit within a pure APL framework.

1. All data is modelled as a set of relations.
2. The relation definitions must appear in a file separate from any logic.
3. All essential data definitions should appear first and be marked clearly.
4. Derived relations must also have a corresponding definition.
5. Data constraints should appear in a separate, independent file.
6. All essential logic receives its own set of files
7. Essential logic may be written using only function trains and user-defined 
   operators.
8. Accidental state/control must appear fully separate from other elements.
9. It should be easy to run the compiler without the accidental state/control.
10. Feeders and observers must be as simple as possible and omit any logic.
11. Feeders and Observers, therefore, should not contain essential logic.
12. A file when printed must fit on a single sheet of paper in 12pt font.

