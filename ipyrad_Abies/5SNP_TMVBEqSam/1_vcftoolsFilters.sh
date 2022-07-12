#!/bin/bash

#This script filter vcf files. It selects only SNPs that 1) have two alleles, 2) have a maf of 0.05 and 3) only genotypes supportedt by more than 3 reads

for i in *.vcf;
do
vcftools --vcf $i --keep keep_TMVB.txt --maf 0.05 --min-alleles 2 --max-alleles 2 --minDP 5 --max-missing 0.8 --recode --recode-INFO-all --out Filtered_${i%.vcf};
done

#move .log file to a log file directory

mv *.log 1SNP_log/