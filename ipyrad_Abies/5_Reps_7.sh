#! /bin/sh

#SBATCH -p keri
#SBATCH --mem 200000
#SBATCH -n 8

#These command lines perform step 7 using 5 and 1 flinRel param files

for i in params-5*flinRel.txt;
do
ipyrad -p $i -s 7 -f;
done

# then

for i in params-1*flinRel.txt
do
ipyrad -p $i -s 7 -f;
done

# vcf files will be found in different directories, each one with the "outfiles" suffix.
# Save these vcf files in two directories for 5 and 1 SNP/locus datasets.

mkdir 5SNP_TMVBEqSam 1SNP_TMVBEqSam

for i in $(ls -d 5*outfiles)
do
	cd $i
	cp *.vcf ../5SNP_TMVBEqSam/
	cd ..;
done

for i in $(ls -d 1*outfiles)
do
	cd $i
	cp *.vcf ../1SNP_TMVBEqSam/
	cd ..;
done
