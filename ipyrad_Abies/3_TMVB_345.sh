#! /bin/sh

#SBATCH -p keri
#SBATCH --mem 90000
#SBATCH -n 5

#This command line runs ipyrad steps 3 to 5, using TMVB samples
ipyrad -p params-TMVB_Abies.txt -s 345 -f
