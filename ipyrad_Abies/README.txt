
### This directory contains all scripts and input files used to:
 # 1) Asses how SNP error varied according to different param values
 # 2) Create a VCF file, which was further filtered and analyzed in a pop gen background


## Scripts are used in the following order:

# To create vcf files that include only replicated samples, use the following scripts (stay in ipyrad_Abies directory):

# ipyrad 0.9.33
1_DemulTrimm.sh
2_Branching_reps.sh
3_Reps_3456.sh
4_Branching_reps.sh
5_Reps_7.sh

# Depending on the number of SNPs/locus, vcf files are going to be saved in 1SNP_TMVBEqSam and 5SNP_TMVBEqSam directories.
# Use the following scripts to further filter these vcfs using VCFtools 0.1.16 (go to ../bin):

1_vcftoolsFilters_reps.sh
2_keep_gametophyte.sh
3_match_paralogous_reps.sh
4_remove_paralogous_reps.sh

# Filtered vcf files will use "2ndFilt" suffix
# Each dataset is analysed independently using the command lines in:

Error_EuclDist_reps.r (which is included in both 1SNP_TMVBEqSam and 5SNP_TMVBEqSam directories)

# We're going to obtain the following tables:

LocAllError.txt
EuclDist.txt
SNPerrorRates.txt

# Return to ipyrad_Abies directory and use the command lines written in:

GLMM_reps.r # Table S1
Boxplot_reps.r # Figure S1

# After we have found the the optimal parameter values, we ran ipyrad using all TMVB samples (stay at ipyrad_Abies/ directory)

2_Branching_TMVB.sh
3_TMVB_345.sh
4_Branching_snpxlocus.sh
5_TMVB_67.sh

# Final outputs (vcf files) were moved to ../out

# Then, we filtered these vcf files using VCFtools 0.1.16 (go to ../bin directory). Check ../bin/README2.txt

1_TMVB_postFilts.sh
3_TMVB_postFilts.sh
4_TMVB_postFilts.sh


