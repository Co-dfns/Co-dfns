#!/bin/bash

echo "Tangling codfns.apln..."
notangle codfns.nw > src/codfns.apln
echo "Tangling src/TEST.aplf..."
notangle -R'[[TEST]]' codfns.nw > src/TEST.aplf
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
