#!/bin/bash

##########################
### ADMIXTURE ANALYSES ###
##########################

# These command lines were used to perform ADMIXTURE analyses (A. religiosa samples)

# 1.- We created .ped and .map files using PLINK v1.90b6.11 64-bit
./plink --vcf ../out_religiosa_NoMan/ParFiltered_1SNPreligiosaNoMan_mac2_mmiss0.50.recode.vcf --recode12 --allow-extra-chr --out ../out_religiosa_NoMan/admixture_noMan/ParFiltered_1SNPreligiosaNoMan_mac2_mmiss0.50
# Because ADMIXTURE outputs will always be put in the current working directory (bin), we moved to ../out_TMVB/admixture_TMVB/ 
cd ../out_religiosa_NoMan/admixture_noMan/


# 2.- Run ADMIXTURE Version 1.3.0
prefix=ParFiltered_1SNPreligiosaNoMan_mac2_mmiss0.50
for K in {1..8}; do
	for r in {1..10}; do
		./admixture -s ${RANDOM} --cv ParFiltered_1SNPreligiosaNoMan_mac2_mmiss0.50.ped $K | tee log.$prefix.K${K}r${r}.out
		mv ${prefix}.${K}.Q ${prefix}.K${K}r${r}.Q;
		done
	done

# Save CV values for each run
for i in log*.out; do
	grep -E "CV error" $i | sed 's/CV error (K=//' | sed 's/): /,/' >> CV.csv;
done

# Plot the cross validation values 
Rscript CV_plot.r # Plot Figure S7 a

# 3.- Run Pong
# For each K value, Pong aids to choose which of the .Q files was the most frequent. 

# Create a pong parameter file
for K in {2..3}; do
	for r in {1..10}; do
		awk -v K=$K -v r=$r -v file=${prefix}.K${K}r${r} 'BEGIN{ \
			printf("K%dr%d\t%d\t%s.Q\n", K,r,K,file)}' >> ${prefix}.k${K}multiplerun.Qfilemap;
			done
		done

# Then, for each K value, open results in a browser
for K in {2..3}; do 
	pong -m ${prefix}.k${K}multiplerun.Qfilemap --greedy -s .95 -i ind2pop.txt -v;
done

# Save chosen .Q files in the directory ../out_TMVB/admixture_TMVB/Qmatrix_plot
# After run the above command lines, ../out_TMVB/admixture_TMVB/Qmatrix_plot/run 3_plotAdmixture_Abies.r to create Figure 3 c