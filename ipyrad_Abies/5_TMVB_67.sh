#! /bin/sh

#SBATCH -p keri
#SBATCH --mem 200000
#SBATCH -n 8

# This loop perform steps 6 and 7 for each SNPradlocus.txt paramfile

for i in params-TMVB*SNPradlocus.txt;
do
ipyrad -p $i -s 67 -f;
done

# TMVB_1SNPradlocus_outfiles/ contains the vcf analysed in the survey.
# All resulted vcfs were moved to ../out/ directory
