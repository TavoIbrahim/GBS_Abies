#!/bin/bash

#SBATCH -p cluster
#SBATCH -w nodo7
#SBATCH --mem 150000
#SBATCH -n 6

# Using each simulated Multi-SFS, now compute EstLhood and ObsLhood, assuming a demographic model
# We ran independently this loop assuming one of the three best-supported demographic scenarios at a time.

PREFIX="Hc12_IM_boot"

for i in {1..100}
do
cp ${PREFIX}.tpl ${PREFIX}.est fsc26 ${PREFIX}.pv Hc12_IM_boot_$i"/"
cd Hc12_IM_boot_$i
./fsc26 -t ${PREFIX}.tpl -e ${PREFIX}.est -n 50000 -0 -C 10 -m -M -L 30 --initValues ${PREFIX}.pv -c 6 -q  --multiSFS
cd ..
done