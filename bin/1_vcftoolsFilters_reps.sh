#!/bin/bash

# These command lines perform initial filters for each vcf file and keep putative paralogs

### 1 SNP/locus datasets
### Step 1: Initial filters 
VAR1=$(ls ../ipyrad_Abies/1SNP_TMVBEqSam/1*_flinRel.vcf)

for i in $VAR1; do
	vcftools --vcf $i --keep ../meta/keep_TMVB.txt --maf 0.05 --min-alleles 2 --max-alleles 2 --minDP 5 --max-missing 0.8 --recode --recode-INFO-all --out ${i%_flinRel.vcf}_1stFilt;
	done

### Step 2: keep gametophyte samples with putative paralogs

VAR2=$(ls ../ipyrad_Abies/1SNP_TMVBEqSam/1*_flinRel.vcf)

for i in $VAR2; do
	vcftools --vcf $i --keep ../meta/Gametophyte.txt --maf 0.05 --min-alleles 2 --minDP 5 --max-missing 1.0 --recode --recode-INFO-all --out ${i%_flinRel.vcf}_1stFiltGam;
	done
# then 

### 5 SNPs/locus datasets
### Step 1: Initial filters 
VAR1=$(ls ../ipyrad_Abies/5SNP_TMVBEqSam/5*_flinRel.vcf)

for i in $VAR1; do
	vcftools --vcf $i --keep ../meta/keep_TMVB.txt --maf 0.05 --min-alleles 2 --max-alleles 2 --minDP 5 --max-missing 0.8 --recode --recode-INFO-all --out ${i%_flinRel.vcf}_1stFilt;
	done

### Step 2: keep gametophyte samples with putative paralogs

VAR2=$(ls ../ipyrad_Abies/5SNP_TMVBEqSam/5*_flinRel.vcf)

for i in $VAR2; do
	vcftools --vcf $i --keep ../meta/Gametophyte.txt --maf 0.05 --min-alleles 2 --minDP 5 --max-missing 1.0 --recode --recode-INFO-all --out ${i%_flinRel.vcf}_1stFiltGam;
	done

# Regarding the Megagametophyte sample, we required sites with 2 or more alleles, and no missing data. 
