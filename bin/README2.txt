# Run the following scripts to get filtered vcf files with different levels of missing data and samples,

1_TMVB_postFilts.sh
3_TMVB_postFilts.sh
4_TMVB_postFilts.sh

# Then, follow the command lines provided in:

1_SS_Abies.r (also, you are going to need SS_PopGenome.r)

# Output files are going to be used to run:

2_LMM_Abies.r
6_pairwiseFST_Abies.r

# On the other hand, to perform the genetic structure analyses, you should use the following scripts/command lines:

2_Admixture_Abies.sh (and then ../out_TMVB/admixture_TMVB/Qmatrix_plot/3_popHelper_Abies.R)
4_DAPC_Abies.r
5_SNPrelate_Abies.r

# After run ../fastsimcoal/GoodofFit/3_get_data.sh you have to run:

7_GoodFit_Abies.r
8_confidence_Abies.r



