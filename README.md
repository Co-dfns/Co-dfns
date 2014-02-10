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
are in DocBook format and must be compiled. Pre-compiled versions
exist and are updated occassionally at the following URL. This URL is
password protected, so if you wish to have access to it, please send
an email to arcfide@sacrideo.us requesting access:

https://truck.it/p/1NwwblFJt0

If you prefer to compile the documents yourself, a sample fop.xconf
and fo.xsl extension have been included in the source as an aid to
generating the documents. They require that you have the right fonts
and a proper DocBook v5 installation. I use Apache FOP to generate the
documentation, and use the following command:

    fop -c fop.xconf -xsl fo.xsl -xml <filename>.xml -pdf <filename>.pdf

You can track the development of the project and the compiler through
the *Project Record* which will detail the status and various stages
of development under which the compiler exists. You can read through
the other documents to get an idea of how the development will
progress and how to keep track of things.

## Notes on DocBook

It seems that many people have trouble building the Docbook documents,
perhaps in part because of non-obvious installation practices for
Docbook. This project utilizes DocBook v5, documented at the following
URL: 

http://www.docbook.org

It is possible to compile and render these documents however you like,
into whatever format you like, provided that you provide the processor
to convert the XML into the format you prefer. For our purposes, the
PDF formats are quite nice, and we generate them using XSL-FO. The
included fop.xconf and fo.xsl configurations assume the use of Apache
FOP to process our docbook files through the DocBook XSL, which is a
set of stylesheets available publically for processing docbook into a
variety of formats:

http://docbook.sourceforge.net

Information on that site will provide all the general information
necessary to build the documents, for those who wish to dive into the
details. However, the provided `Makefile` should suffice to inform
anyone on how to repeat the rendering process that we use on the
documents. In order to use the Makefile, we recommend the following: 

1. Install the TTF version of the CMU Fonts:

   http://sourceforge.net/projects/cm-unicode/files/cm-unicode/0.7.0/cm-unicode-0.7.0-ttf.tar.xz/download 

2. Install Java

3. Install Xalan:

   http://www.eng.lsu.edu/mirrors/apache/xalan/xalan-j/binaries/xalan-j_2_7_1-bin.zip

4. Make sure that the Xalan JARs are included in your CLASSPATH.

5. Install the DocBook v5 XSL somewhere:

   http://sourceforge.net/projects/docbook/files/docbook-xsl-ns/1.78.1/docbook-xsl-ns-1.78.1.tar.bz2/download

6. Install Apache FOP:

   http://www.interior-dsgn.com/apache/xmlgraphics/fop/binaries/fop-1.1-bin.tar.gz

7. Make sure that the `fop` binary is somewhere in your path and that
   it runs properly.

8. Install the hyphenation files into the FOP lib/ directory:

   http://sourceforge.net/projects/offo/files/offo-hyphenation/2.1/offo-hyphenation-binary.zip/download

   Note: You only need to install the JAR file, not the rest of the
   contents into the lib/ directory.

9. Adapt the `Makefile` and `fo.xsl` file to point to the appropriate
   locations for the fo/docbook.xsl file in your Docbook v5 XSL
   installation.

At this point things should work. Many Linux distributions provide a
set of packages for installing FOP and Xalan, as well as for
installing the Docbook v5 stylesheets, though you should make sure
they correspond to the `ns` versions, which are based on the
namespaces, and not DTDs. 

A couple of people have successfully use the Mac OS X Homebrew
packages for Fop to build these documents, but they had to edit the
FOP script to increase the amount of heap space given to
Java. Otherwise, you might experience heap size limitations. 

If you install FOP via packages, it might not be necessary to install
the hyphenation files separately. Please check your distribution to
determine whether or not the packages include the hyphenation files. 

You may use whatever fonts you want provided that you adapt the fo.xsl
file to use those fonts. This can be done if you, for instance, do not
wish to install the CMU fonts.

