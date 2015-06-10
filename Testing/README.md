# Co-dfns Tests

The `Testing/` directory contains all of the tests for the Co-dfns compiler 
in a single, unified format. Nothing should go into this directory that is not 
an explicit Co-dfns compiler test.

## Testing Format

Each test is stored inside of a `*_tests.dyalog` file and contains at least 
one `*_TEST` function. A comment should describe the purpose of the test. One 
may include more than one test in a single file provided that they are very 
closely related and fit on roughly a single screen.

The namespace of each file should correspond to the root of the filename.
