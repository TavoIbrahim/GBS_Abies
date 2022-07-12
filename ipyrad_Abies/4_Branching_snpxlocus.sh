#!/bin/bash

#SBATCH -p keri
#SBATCH --mem 10000
#SBATCH -n 2

#These command lines generate new branches from params-TMVB_Abies to vary the number of SNPs/radLocus

ipyrad -p params-TMVB_Abies.txt -b TMVB_5SNPradlocus -f
ipyrad -p params-TMVB_Abies.txt -b TMVB_2SNPradlocus -f
ipyrad -p params-TMVB_Abies.txt -b TMVB_1SNPradlocus -f

# Then, change the resulted param files: [max_SNPs_locus]: Max # SNPs per locus
