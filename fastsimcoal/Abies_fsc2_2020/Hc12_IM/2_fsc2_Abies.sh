#!/bin/bash

#SBATCH -p cluster
#SBATCH -w keri
#SBATCH --mem 150000
#SBATCH -n 6

# These loop simulates 100 times the Hc12 IM scenario.

PREFIX="Hc12_IM" # Change the prefix according to the .tpl .est and .obs files

for i in {101..200}
 do
   mkdir run$i
   cp ${PREFIX}.tpl ${PREFIX}.est ${PREFIX}_MSFS.obs fsc26 run$i"/"
   cd run$i
   ./fsc26 -t ${PREFIX}.tpl -e ${PREFIX}.est -m -0 -C 10 -n 50000 -L 40 -s 0 -M -q -c 6 --multiSFS
   cd ..
 done
 
# Modified from Mark Ravinet & Joana Meier (2021) https://speciationgenomics.github.io/fastsimcoal2/

