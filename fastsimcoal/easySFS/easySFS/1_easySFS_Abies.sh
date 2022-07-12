#!/bin/bash

#SBATCH -p cluster
#SBATCH -w keri
#SBATCH --mem 250000
#SBATCH -n 8

### These command lines were used to create 5 multi SFSs, each considering:

# 3 species, missing data allowed= 0.50
./easySFS.py -i ../3_AbSpecies/ParFiltered_1SNPpop_mac2_mmiss0.50.recode.vcf  -p ../3_AbSpecies/popfileTMVB2.txt -a --proj=20,80,14 -o ../3_AbSpecies_out/ -f -v

### To account for missing data
# 3 species, missing data allowed= 0.13
./easySFS.py -i ../3_AbSpecies/ParFiltered_1SNPpop_mac2_mmiss0.87.recode.vcf  -p ../3_AbSpecies/popfileTMVB2.txt -a --proj=22,40,22 -o ../3_AbSpecies_87_out_c/ -f -v

### To account for STRUCTURE
# 3 species (A. religiosa= E Group, following ADMIXTURE results), missing data allowed= 0.50
./easySFS.py -i ../3_AbSpecies/ParFiltered_1SNPpop_mac2_mmiss0.50_minDP8_Hc1.recode.vcf -p ../3_AbSpecies/pop_Hc1model_fsc2.txt -a --proj=22,16,12 -o ../3_AbSpecies_Hc1_out/ -f -v
# 3 species (A. religiosa= C Group, following ADMIXTURE results), missing data allowed= 0.50
./easySFS.py -i ../3_AbSpecies/ParFiltered_1SNPpop_mac2_mmiss0.50_minDP8_Hc2.recode.vcf -p ../3_AbSpecies/pop_Hc2model_fsc2.txt -a --proj=24,16,30 -o ../3_AbSpecies_Hc2_out/ -f -v

# Multi-SFS used to simulate intraspecific divergence in A. religiosa
./easySFS.py -i Abies_TMVB_mac2_mmiss050/ParFiltered_1SNPpop_mac2_mmiss0.50.recode.vcf -p ../Abies_TMVB_mac2_mmiss050/popfileTMVB.txt -a --proj=6,6,6,8,8,6,6 -o Abies_TMVB_mac2_mmiss050_SFSless3_test/ -f -v

