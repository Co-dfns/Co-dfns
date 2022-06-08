#!/bin/bash
echo "Tangling src/codfns.apln..."
notangle codfns.nw > src/codfns.apln

echo "Tangling src/DISPLAY.aplf..."
notangle -R'[[DISPLAY]] Utility' codfns.nw > src/DISPLAY.aplf

echo "Tangling src/MK∆RTM.aplf..."
notangle -R'[[MK∆RTM]] Command' codfns.nw > src/MK∆RTM.aplf

echo "Tangling src/PP.aplf..."
notangle -R'[[PP]] Utility' codfns.nw > src/PP.aplf

echo "Tangling src/TANGLE.aplf..."
notangle -R'[[TANGLE]] Command' codfns.nw > src/TANGLE.aplf

echo "Tangling src/TEST.aplf..."
notangle -R'[[TEST]] Function' codfns.nw > src/TEST.aplf

echo "Tangling src/WEAVE.aplf..."
notangle -R'[[WEAVE]] Command' codfns.nw > src/WEAVE.aplf

echo "Tangling TANGLE.sh..."
notangle -R'Tangle Script' codfns.nw > TANGLE.sh

echo "Tangling WEAVE.sh..."
notangle -R'Weave Script' codfns.nw > WEAVE.sh
