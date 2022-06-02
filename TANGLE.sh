#!/bin/bash
notangle codfns.nw > src/codfns.apln
notangle -R'[[DISPLAY]] Utility' codfns.nw > src/DISPLAY.aplf
notangle -R'[[MK∆RTM]] Command' codfns.nw > src/MK∆RTM.aplf
notangle -R'[[PP]] Utility' codfns.nw > src/PP.aplf
notangle -R'[[TANGLE]] Command' codfns.nw > src/TANGLE.aplf
notangle -R'[[TEST]] Function' codfns.nw > src/TEST.aplf
notangle -R'[[WEAVE]] Command' codfns.nw > src/WEAVE.aplf
notangle -R'Tangle Script' codfns.nw > TANGLE.sh
notangle -R'Weave Script' codfns.nw > WEAVE.sh
