# Co-Dfns Compiler

This is the developer's repository for the Co-dfns compiler project.
The Co-dfns project aims to provide a high-performance,
high-reliability compiler for a super-set of the Dyalog dfns
programming language.  The dfns language is a functionally oriented,
lexically scoped dialect of APL. The Co-dfns language extends the
dfns language to include explicit task parallelism with implicit
structures for synchronization and determinism. The language is
designed to enable rigorous formal analysis of programs to aid in
compiler optimization and programmer productivity, as well as in the
general reliability of the code itself.

## Documentation

The primary documentation right now is a set of development documents
used to develop the compiler. If you want to use these documents, they
are in DocBook format and must be compiled. A sample fop.xconf and
fo.xsl extension have been included in the source as an aid to
generating the documents. They require that you have the right fonts
and a proper DocBook v5 installation. I use Apache FOP to generate the
documentation, and use the following command:

    fop -c fop.xconf -xsl fo.xsl -xml <filename>.xml -pdf <filename>.pdf

You can track the development of the project and the compiler through
the *Project Record* which will detail the status and various stages
of development under which the compiler exists. You can read through
the other documents to get an idea of how the development will
progress and how to keep track of things.
