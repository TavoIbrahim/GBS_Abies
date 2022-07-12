#!/bin/bash

# Once you ran 2_boot_comp.sh, run this loop to recover 1) the distribution of pop parameters (if Hc12_IM was assumed)
# and 2) EstLhood and ObsLhood from each simulated Multi-SFS, assuming each of the best three scenarios.

for i in {1..100};
do
cd Hc12_IM_boot_${i}/Hc12_IM_boot
cat *.bestlhoods | awk "NR ==2"
cd ../../
done

# Save this information in GBS_Abies/out_TMVB/GoodnessOfFit_2022/ 
