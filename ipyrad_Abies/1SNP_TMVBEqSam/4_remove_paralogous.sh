#! /bin/sh

#This function remove putative paralogous from the tested vcf files


VAR1="Filtered_1clust_070_flinRel.recode.vcf  Filtered_1maxHs_2_flinRel.recode.vcf  Filtered_1maxHs_9_flinRel.recode.vcf Filtered_1clust_075_flinRel.recode.vcf  Filtered_1maxHs_3_flinRel.recode.vcf  Filtered_1mindepth_10_flinRel.recode.vcf Filtered_1clust_080_flinRel.recode.vcf  Filtered_1maxHs_4_flinRel.recode.vcf  Filtered_1mindepth_5_flinRel.recode.vcf Filtered_1clust_085_flinRel.recode.vcf  Filtered_1maxHs_5_flinRel.recode.vcf  Filtered_1mindepth_6_flinRel.recode.vcf Filtered_1clust_090_flinRel.recode.vcf  Filtered_1maxHs_6_flinRel.recode.vcf  Filtered_1mindepth_7_flinRel.recode.vcf Filtered_1clust_095_flinRel.recode.vcf  Filtered_1maxHs_7_flinRel.recode.vcf  Filtered_1mindepth_8_flinRel.recode.vcf Filtered_1maxHs_10_flinRel.recode.vcf   Filtered_1maxHs_8_flinRel.recode.vcf  Filtered_1mindepth_9_flinRel.recode.vcf"
VAR2="Paralogous_Filtered_1clust_070_flinRel.txt  Paralogous_Filtered_1maxHs_2_flinRel.txt  Paralogous_Filtered_1maxHs_9_flinRel.txt  Paralogous_Filtered_1clust_075_flinRel.txt  Paralogous_Filtered_1maxHs_3_flinRel.txt  Paralogous_Filtered_1mindepth_10_flinRel.txt  Paralogous_Filtered_1clust_080_flinRel.txt  Paralogous_Filtered_1maxHs_4_flinRel.txt  Paralogous_Filtered_1mindepth_5_flinRel.txt  Paralogous_Filtered_1clust_085_flinRel.txt  Paralogous_Filtered_1maxHs_5_flinRel.txt  Paralogous_Filtered_1mindepth_6_flinRel.txt Paralogous_Filtered_1clust_090_flinRel.txt  Paralogous_Filtered_1maxHs_6_flinRel.txt  Paralogous_Filtered_1mindepth_7_flinRel.txt  Paralogous_Filtered_1clust_095_flinRel.txt  Paralogous_Filtered_1maxHs_7_flinRel.txt  Paralogous_Filtered_1mindepth_8_flinRel.txt  Paralogous_Filtered_1maxHs_10_flinRel.txt   Paralogous_Filtered_1maxHs_8_flinRel.txt  Paralogous_Filtered_1mindepth_9_flinRel.txt"

fun()
{
    set $VAR2
    for i in $VAR1; do
    	vcftools --vcf $i --exclude-positions $1 --remove Gametophyte.txt --recode --recode-INFO-all --out Par${i%.recode.vcf}
    	shift
    done
}

fun

#move .log file to a log file directory

mv *.log 1SNP_log/

#Then, compute missing data value per individual and site mean depth per SNP 

for i in ParFiltered*;
do
vcftools --vcf $i --missing-indv --out ${i%.recode.vcf};
done

for i in ParFiltered*;
do
vcftools --vcf $i --site-mean-depth --out ${i%.recode.vcf};
done


#And move the files to different directories

mv *.imiss ind_miss_data/
mv *.ldepth.mean site_depth/

#move .log file to a log file directory

mv *.log 1SNP_log/
