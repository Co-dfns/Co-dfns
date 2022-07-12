#!/bin/bash

echo "Tangling codfns.apln..."
notangle codfns.nw > src/codfns.apln
echo "Tangling src/TEST.aplf..."
notangle -R'[[TEST]]' codfns.nw > src/TEST.aplf
echo "Tangling rtm/prim.apln..."
notangle -R'prim.apln' codfns.nw > rtm/prim.apln
echo "Tangling rtm/codfns.h..."
notangle -R'codfns.h' codfns.nw > rtm/codfns.h
echo "Tangling rtm/cell.c..."
notangle -R'cell.c' codfns.nw > rtm/cell.c
echo "Tangling rtm/dwa.c..."
notangle -R'dwa.c' codfns.nw > rtm/dwa.c
echo "Tangling rtm/array.c..."
notangle -R'array.c' codfns.nw > rtm/array.c
echo "Tangling rtm/box.c..."
notangle -R'box.c' codfns.nw > rtm/box.c
echo "Tangling rtm/closure.c..."
notangle -R'closure.c' codfns.nw > rtm/closure.c
echo "Tangling rtm/init.c..."
notangle -R'init.c' codfns.nw > rtm/init.c
echo "Tangling src/DISPLAY.aplf..."
notangle -R'[[DISPLAY]] Utility' codfns.nw > src/DISPLAY.aplf

echo "Tangling src/PP.aplf..."
notangle -R'[[PP]] Utility' codfns.nw > src/PP.aplf
echo "Tangling TANGLE.bat..."
notangle -R'[[TANGLE.bat]]' codfns.nw > TANGLE.bat
echo "Tangling TANGLE.aplf..."
notangle -R'[[TANGLE]]' codfns.nw > src/TANGLE.aplf
echo "Tangling WEAVE.sh..."
notangle -R'[[WEAVE.sh]]' codfns.nw > WEAVE.sh
echo "Tangling WEAVE.bat..."
notangle -R'[[WEAVE.bat]]' codfns.nw > WEAVE.bat
echo "Tangling src/WEAVE.aplf..."
notangle -R'[[WEAVE]]' codfns.nw > src/WEAVE.aplf
echo "Tangling src/MK∆RTM.aplf..."
notangle -R'[[MK∆RTM]]' codfns.nw > src/MK∆RTM.aplf

echo "Tangling TANGLE.sh..."
notangle -R'[[TANGLE.sh]]' codfns.nw > TANGLE.sh