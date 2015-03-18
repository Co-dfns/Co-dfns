The Co-dfns compiler effort is, at its heart, an effort to support and drive the capabilities of information experts to develop large scale software efficiently and effectively. This leads to a specific set of particular goals:

1. To push the boundaries of what constitutes a suitable domain for array programming by "eating our own dogfood" and developing our applications using strict array programming practices. This leads to new developments of techniques and methods for solving problems traditionally solved using other programming paradigms.

2. To deliver turn-key performance to information experts through predictable, platform-independent performance behavior on modern, parallel hardware without requiring the information expert to tune their models using a lower level language. We do this by increasing the declarative nature of the array programming paradigm and leveraging its high-level nature in compiler design.

3. To close as much as possible the gap from prototype to production code on large scale software systems that rely heavily on APL by enabling performance experts to scale APL code across a wide variety of platforms without rewriting the code base.

These "principles" greatly affect our direction and design for the Co-dfns compiler and how we solve issues of performance and language evolution. For example, we choose not to develop a new language, but to create only small and minor extensions or changes to the existing Dyalog APL language. 
