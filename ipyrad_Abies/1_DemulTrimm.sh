#!/bin/bash

#SBATCH -p cluster
#SBATCH -w keri
#SBATCH --mem 120000
#SBATCH -n 6

#This script carries out ipyrad steps 1 and 2

# Run step 1
for i in *rawsAbies.txt;
do
ipyrad -p $i -s 1 -f;
done

# Merge all demultiplexed samples and create a new param files named params-All_Abies.txt
ipyrad -m All_Abies params-Plate1rawsAbies.txt params-Plate2rawsAbies.txt params-Plate3rawsAbies.txt
 params-Plate4rawsAbies.txt params-Plate5rawsAbies.txt -f

# Run step 2
ipyrad -p params-All_Abies.txt -s 2 -f

#Generate a new branch from All_Abies assemblage only with replicated samples
ipyrad -p params-All_Abies.txt -b Replicas_Abies ../meta/Abies_to_keep2.txt -f
