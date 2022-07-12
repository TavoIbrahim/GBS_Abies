#! /bin/sh

#SBATCH -p keri
#SBATCH --mem 90000
#SBATCH -n 5

#Generate a new branch from All_Abies assemblage only with replicated samples
ipyrad -p params-All_Abies.txt -b TMVB_Abies ../meta/TMVB.txt -f

# Then, modify according params-TMVB_Abies.txt according to the parameter values defined in Supplementary 1
