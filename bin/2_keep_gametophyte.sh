#!/bin/bash

#This command line keeps only megagametophyte samples from non-filtered 1SNP vcf file

vcftools --vcf ../out/TMVB_1SNPradlocus.vcf --keep ../meta/Gametophyte.txt --maf 0.05 --min-alleles 2 --max-missing 1.0 --minDP 10 --remove-indels --recode --recode-INFO-all --out 1SNP_MegagametophyteVar

#move output files to Megagametophyet directory

mv 1SNP_MegagametophyteVar* ../out_Megas/

#This command line keeps only megagametophyte samples from non-filtered 5SNP vcf file

#vcftools --vcf ../out/TMVB_5SNPradlocus.vcf --keep ../meta/Gametophyte.txt --maf 0.05 --min-alleles 2 --max-missing 1.0 --minDP 10 --remove-indels --recode --recode-INFO-all --out 5SNP_MegagametophyteVar

#move output files to Megagametophyet directory

#mv 5SNP_MegagametophyteVar* ../out_Megas/

#This command line keeps only megagametophyte samples from non-filtered 5SNP vcf file
#cd vcftools/
#vcftools --vcf ../../out/TMVB_2SNPradlocus.vcf --keep ../../meta/Gametophyte.txt --maf 0.05 --min-alleles 2 --max-missing 1.0 --minDP 10 --remove-indels --recode --recode-INFO-all --out 2SNP_MegagametophyteVar
#cd ..
#move output files to Megagametophyet directory
#cd vcftools/
#mv 2SNP_MegagametophyteVar* ../../out_Megas/
#cd ..

# 2 SNPS radlocus
#vcftools --vcf ../out/TMVB_2SNPradlocus.vcf --keep ../meta/Gametophyte.txt --maf 0.05 --min-alleles 2 --max-missing 1.0 --minDP 10 --remove-indels --recode --recode-INFO-all --out 2SNP_MegagametophyteVar