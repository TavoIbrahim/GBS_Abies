#!/bin/bash

#This script keep only megagametophyte samples from non filtered vcf

for i in *flinRel.vcf;
do
vcftools --vcf $i --keep Gametophyte.txt --maf 0.05 --min-alleles 2 --minDP 5 --max-missing 1.0 --recode --recode-INFO-all --out Megagametophyte_${i%.vcf};
done

#move .log file to a log file directory

mv *.log 1SNP_log/