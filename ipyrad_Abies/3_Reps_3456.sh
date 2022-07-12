#!/bin/bash

#SBATCH -p keri
#SBATCH --mem 40000
#SBATCH -n 6

#This loop carries out steps 3 to 6 steps in ipyrad using flinRel subsets

for i in *flinRel.txt;
do
ipyrad -p $i -s 3456 -f;
done
