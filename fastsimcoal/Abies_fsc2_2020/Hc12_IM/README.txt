This directory contains all you need to simulate the Hc12 (with ancient migration) scenario: .tpl .est .obs and 2_fsc_Abies.sh. Likewise, fsc26 executable should exist in this directory.

After run 2_fsc_Abies.sh, use 3_choice_Abies.sh to select the best simulation based on a likelihood criterium (This is going to be saved in "bestrun" directory).

Within bestrun directory, run 4_AIC_Abies.sh to compute AIC.
