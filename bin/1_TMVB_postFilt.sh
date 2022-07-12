#!/bin/bash

# These command lines start filtering 1SNPradlocus file.

# 1.- For each assembly, we kept bi-allelic SNPs and removed indels 

# All TMVB individuals
vcftools --vcf ../out/TMVB_1SNPradlocus.vcf --keep ../meta/pop_TMVB1.txt --min-alleles 2 --max-alleles 2 --remove-indels --recode --recode-INFO-all --out ../out_TMVB/Filtered_1SNPtmvb
# Only A. religiosa individuals (for DAPC analysis)
vcftools --vcf ../out/TMVB_1SNPradlocus.vcf --keep ../meta/religiosa.txt --min-alleles 2 --max-alleles 2 --remove-indels --recode --recode-INFO-all --out ../out_religiosa/Filtered_1SNPreligiosa
# A. religiosa samples (without Pops 4 and 5; for Admixture analysis)
vcftools --vcf ../out/TMVB_1SNPradlocus.vcf --keep ../meta/religiosa_NoMan.txt --min-alleles 2 --max-alleles 2 --remove-indels --recode --recode-INFO-all --out ../out_religiosa_NoMan/Filtered_1SNPreligiosaNoMan
# In addition, we create vcf files for fastsimcoal2 simulations, which consider only C and E genomic groups to represent A. religiosa
vcftools --vcf ../out/TMVB_1SNPradlocus.vcf --keep ../meta/pop_Hc1model.txt --min-alleles 2 --max-alleles 2 --remove-indels --recode --recode-INFO-all --out ../out_TMVB/Filtered_1SNP_Hc1 # C genomic group
vcftools --vcf ../out/TMVB_1SNPradlocus.vcf --keep ../meta/pop_Hc2model.txt --min-alleles 2 --max-alleles 2 --remove-indels --recode --recode-INFO-all --out ../out_TMVB/Filtered_1SNP_Hc2 # E genomic group

# 2.- Then, we recover Megagametophyte samples to identify putative paralogs
vcftools --vcf ../out/TMVB_1SNPradlocus.vcf --keep ../meta/Gametophyte.txt --maf 0.05 --min-alleles 2 --max-missing 1.0 --minDP 10 --remove-indels --recode --recode-INFO-all --out ../out_Megas/1SNP_MegagametophyteVar
