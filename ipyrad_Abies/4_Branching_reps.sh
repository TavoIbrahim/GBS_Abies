#!/bin/bash

#SBATCH -p keri
#SBATCH --mem 10000
#SBATCH -n 2

#This script generate new branches from step6 paramfiles to control for number of SNPs/radLocus allowed

# Firts, remove filenames.txt 
rm -rf filenames.txt

#Aflinckii and Areligiosa 5 and 1 SNP/radlocus

# Create names for the b parameter in ipyrad
for i in $(ls params*flinRel.txt)
do
	string=$i
	prefix="params-"
	string=${string#$prefix}
	suffix=".txt"
	string=${string%$suffix}

echo $string >> filenames.txt
done

# then,create a variable with saved names and with param file names
VAR1=$(ls params*flinRel.txt)
VAR2=$(<filenames.txt)

# And finally use both variables to create branches in ipyrad
fun()
{
    set $VAR2
    for i in $VAR1; do
        echo "ipyrad -p $i -b 5${1} -f"
        echo "ipyrad -p $i -b 1${1} -f"
        shift
    done
}
fun
