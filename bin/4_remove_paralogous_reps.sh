#! /bin/sh

### 1 SNP/locus
### Step 4: Apply final filters, including the exclusion of putative paralogs

VAR1=$(ls ../ipyrad_Abies/1SNP_TMVBEqSam/*1stFilt.recode.vcf)
VAR2=$(ls ../ipyrad_Abies/1SNP_TMVBEqSam/*Par.txt)

fun()
{
    set $VAR2
    for i in $VAR1; do
        vcftools --vcf $i --exclude-positions $1 --remove ../meta/Gametophyte.txt --recode --recode-INFO-all --out ${i%_1stFilt.recode.vcf}_2ndFilt
        shift
    done
}

fun

### Extract SNP counts
RUTA="../ipyrad_Abies/1SNP_TMVBEqSam"

rm -rf $RUTA/1SNP_count.txt 
rm -rf $RUTA/AssemblyNames.txt
rm -rf $RUTA/1SNP_conteos.txt

VAR3="$(ls ../ipyrad_Abies/1SNP_TMVBEqSam/*2ndFilt.log)"
for i in $VAR3; do
    grep -oE "kept \w+" $i | sed -n 2p | awk '{print $2}' >> $RUTA/1SNP_count.txt
done

### Extract the assembly names
for i in $VAR3
do
    string=$i
    prefix="../ipyrad_Abies/1SNP_TMVBEqSam/1"
    string=${string#$prefix}
    suffix="_2ndFilt.log"
    string=${string%$suffix}

echo $string >> $RUTA/AssemblyNames.txt
done

# Merge names and counts
paste $RUTA/AssemblyNames.txt $RUTA/1SNP_count.txt >> $RUTA/1SNP_conteos.txt

### 5 SNPs/locus
### Step 4: Apply final filters, including the exclusion of putative paralogs

VAR1=$(ls ../ipyrad_Abies/5SNP_TMVBEqSam/*1stFilt.recode.vcf)
VAR2=$(ls ../ipyrad_Abies/5SNP_TMVBEqSam/*Par.txt)

fun()
{
    set $VAR2
    for i in $VAR1; do
        vcftools --vcf $i --exclude-positions $1 --remove ../meta/Gametophyte.txt --recode --recode-INFO-all --out ${i%_1stFilt.recode.vcf}_2ndFilt
        shift
    done
}

fun

### Extract SNP counts
RUTA="../ipyrad_Abies/5SNP_TMVBEqSam"

rm -rf $RUTA/5SNP_count.txt 
rm -rf $RUTA/AssemblyNames.txt
rm -rf $RUTA/5SNP_conteos.txt

VAR3="$(ls ../ipyrad_Abies/5SNP_TMVBEqSam/*2ndFilt.log)"
for i in $VAR3; do
    grep -oE "kept \w+" $i | sed -n 2p | awk '{print $2}' >> $RUTA/5SNP_count.txt
done

### Extract the assembly names
for i in $VAR3
do
    string=$i
    prefix="../ipyrad_Abies/5SNP_TMVBEqSam/5"
    string=${string#$prefix}
    suffix="_2ndFilt.log"
    string=${string%$suffix}

echo $string >> $RUTA/AssemblyNames.txt
done

# Merge names and counts
paste $RUTA/AssemblyNames.txt $RUTA/5SNP_count.txt >> $RUTA/5SNP_conteos.txt

