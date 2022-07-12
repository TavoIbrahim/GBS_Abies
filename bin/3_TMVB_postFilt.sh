#! /bin/sh

# 3.- These command lines create lists of common SNPs between population files and the Megagametophyte file
# We used bedtools v2.28.0

# All TMVB individuals
bedtools intersect -a ../out_TMVB/Filtered_1SNPtmvb.recode.vcf -b ../out_Megas/1SNP_MegagametophyteVar.recode.vcf | grep -oE "locus_\w+\s\w+" > ../out_TMVB/Paralogous1SNPTMVB.txt
# Only A. religiosa individuals (for DAPC analysis)
bedtools intersect -a ../out_religiosa/Filtered_1SNPreligiosa.recode.vcf -b ../out_Megas/1SNP_MegagametophyteVar.recode.vcf | grep -oE "locus_\w+\s\w+" > ../out_religiosa/Paralogous1SNPreligiosa.txt
# A. religiosa samples (without Pops 4 and 5; for Admixture analysis)
bedtools intersect -a ../out_religiosa_NoMan/Filtered_1SNPreligiosaNoMan.recode.vcf -b ../out_Megas/1SNP_MegagametophyteVar.recode.vcf | grep -oE "locus_\w+\s\w+" > ../out_religiosa_NoMan/Paralogous1SNPreligiosa2.txt

# These command lines create vcf files for fastimcoal analisis
bedtools intersect -a ../out_TMVB/Filtered_1SNP_Hc1.recode.vcf -b ../out_Megas/1SNP_MegagametophyteVar.recode.vcf | grep -oE "locus_\w+\s\w+" > ../out_TMVB/Paralogous1SNPHc1.txt
bedtools intersect -a ../out_TMVB/Filtered_1SNP_Hc2.recode.vcf -b ../out_Megas/1SNP_MegagametophyteVar.recode.vcf | grep -oE "locus_\w+\s\w+" > ../out_TMVB/Paralogous1SNPHc2.txt
