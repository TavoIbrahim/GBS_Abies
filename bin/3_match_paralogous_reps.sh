#! /bin/sh

#This functions search matches between vcf files and gametophyte vcf files to create putative paralogous lists
# We will use bedtools v2.28.0

### 1 SNP/locus datasets
### Step 3: Create paralogous lists

VAR1=$(ls ../ipyrad_Abies/1SNP_TMVBEqSam/*1stFilt.recode.vcf)
VAR2=$(ls ../ipyrad_Abies/1SNP_TMVBEqSam/*1stFiltG*.vcf)

# remove previous "_Par.txt" files
rm -rf ../ipyrad_Abies/1SNP_TMVBEqSam/*_Par.txt

# and then
fun()
{
    set $VAR2
    for i in $VAR1; do
        bedtools intersect -a $i -b $1 | grep -oE "locus_\w+\s\w+" > ${i%_1stFilt.recode.vcf}_Par.txt
        shift
    done
}

fun

### 5 SNPs/locus datasets
### Step 3: Create paralogous lists

VAR1=$(ls ../ipyrad_Abies/5SNP_TMVBEqSam/*1stFilt.recode.vcf)
VAR2=$(ls ../ipyrad_Abies/5SNP_TMVBEqSam/*1stFiltG*.vcf)

# remove previous "_Par.txt" files
rm -rf ../ipyrad_Abies/5SNP_TMVBEqSam/*_Par.txt

# and then
fun()
{
    set $VAR2
    for i in $VAR1; do
        bedtools intersect -a $i -b $1 | grep -oE "locus_\w+\s\w+" > ${i%_1stFilt.recode.vcf}_Par.txt
        shift
    done
}

fun
