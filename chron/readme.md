# Chron APL timing suite

Chron provides some basic tools for collecting times in bulk for APL,
and analyzing them.

## Installation

1. Copy the chron folder to the desired subdirectory of your project
2. Set the path names at the top of the chron.dyalog file.
   If the chron folder is placed in the working directory of your
   dyalog workspace, these paths can be left unchanged.
3. In your dyalog workspace run
    ]load {path to chron}/chron.dyalog
   then save the workspace.

## Timing functions

Chron provides two timing functions: cmpx and tmx.

cmpx is based on cmpx from the dfns library, but is specifically
designed to be practical for collecting tables of times. Its optional
left argument has the form ⍺←r m c where r is the number of rows,
m is a threshold, and c is the cpu setting (as in the original cmpx).
Just as with the original version, it is possible to specify only r m,
or just r. All other features of the original cmpx have been removed.

tmx is like cmpx in all respects excpt in the way the threshold works.
It is provided to make it easier to find an appropriate threshold
setting manually, while cmpx is adaptive. The adaptive approach of
cmpx introduces a considerable amount of overhead which has been
removed in tmx.

## Creating tests

All tests must be placed in the tests subdirectory.

1. Create a file in the tests subdirecty, such as mytests_chron.dyalog
2. The file must define a namespace called mytests_chron (matching
    the file name). All functions and variables to be used must
    be defined within the namespace.
3. Each test is defined within the namespace as an argument to be
    given to cmpx, and must be named in the following pattern:
    mytests_chron1, mytests_chron2, mytests_chron3, ...

## Running tests

On linux root privileges are required in order to append the
memory specs to the output data files. The commandline version of
dyalog allows the password to be entered. As of Ride 4.2, the only
approach seems to be to launch ride with root privileges.

1. To see what tests are available, run:

    chron.find 'tests'
    
2. To run all tests in a given file, say mytests_chron.dyalog, run

    chron.test 'mytests'
    
    To run just one test, say mytests_chron3, run
    
    chron.test 'mytests' 3
    
    In both cases an optional left argument can be specfied, which
    is provided as a left argument for cmpx. The output is saved to
    a file in the data subdirectory with a unique time stamp.

## Analyzing data

1. To see all data files available, run:

    chron.find 'data'
    
2. To load just the times from that file, run: 

    chron.load_data {path to file}
    
    If the data table of times is saved to a variable, it can then
    be analyzed with the statistical functions provided. To load
    the whole file as text, run: 
    
    chron.load {path to file}
