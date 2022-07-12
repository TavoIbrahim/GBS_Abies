#! /bin/sh

#This function creates a list of matches between Filtered SNPs and Megagametophye polymorphisms (Paralagous)

VAR1="Filtered_1clust_070_flinRel.recode.vcf  Filtered_1maxHs_2_flinRel.recode.vcf  Filtered_1maxHs_9_flinRel.recode.vcf Filtered_1clust_075_flinRel.recode.vcf  Filtered_1maxHs_3_flinRel.recode.vcf  Filtered_1mindepth_10_flinRel.recode.vcf Filtered_1clust_080_flinRel.recode.vcf  Filtered_1maxHs_4_flinRel.recode.vcf  Filtered_1mindepth_5_flinRel.recode.vcf Filtered_1clust_085_flinRel.recode.vcf  Filtered_1maxHs_5_flinRel.recode.vcf  Filtered_1mindepth_6_flinRel.recode.vcf Filtered_1clust_090_flinRel.recode.vcf  Filtered_1maxHs_6_flinRel.recode.vcf  Filtered_1mindepth_7_flinRel.recode.vcf Filtered_1clust_095_flinRel.recode.vcf  Filtered_1maxHs_7_flinRel.recode.vcf  Filtered_1mindepth_8_flinRel.recode.vcf Filtered_1maxHs_10_flinRel.recode.vcf   Filtered_1maxHs_8_flinRel.recode.vcf  Filtered_1mindepth_9_flinRel.recode.vcf"
VAR2="Megagametophyte_1clust_070_flinRel.recode.vcf  Megagametophyte_1maxHs_2_flinRel.recode.vcf  Megagametophyte_1maxHs_9_flinRel.recode.vcf Megagametophyte_1clust_075_flinRel.recode.vcf  Megagametophyte_1maxHs_3_flinRel.recode.vcf  Megagametophyte_1mindepth_10_flinRel.recode.vcf Megagametophyte_1clust_080_flinRel.recode.vcf  Megagametophyte_1maxHs_4_flinRel.recode.vcf  Megagametophyte_1mindepth_5_flinRel.recode.vcf Megagametophyte_1clust_085_flinRel.recode.vcf  Megagametophyte_1maxHs_5_flinRel.recode.vcf  Megagametophyte_1mindepth_6_flinRel.recode.vcf Megagametophyte_1clust_090_flinRel.recode.vcf  Megagametophyte_1maxHs_6_flinRel.recode.vcf  Megagametophyte_1mindepth_7_flinRel.recode.vcf Megagametophyte_1clust_095_flinRel.recode.vcf  Megagametophyte_1maxHs_7_flinRel.recode.vcf  Megagametophyte_1mindepth_8_flinRel.recode.vcf Megagametophyte_1maxHs_10_flinRel.recode.vcf   Megagametophyte_1maxHs_8_flinRel.recode.vcf  Megagametophyte_1mindepth_9_flinRel.recode.vcf"

fun()
{
    set $VAR2
    for i in $VAR1; do
        bedtools intersect -a $i -b $1 | grep -oE "locus_\w+\s\w+" > Paralogous_${i%.recode.vcf}.txt
        shift
    done
}

fun


#Last command line creates a .txt files with putative paralogous
#-b may be followed with multiple databases and/or wildcard (*) character(s). 
# -v	Only report those entries in A that have no overlap in B. For instance: 
#bedtools intersect -a Filtered_1maxHs_3_Rel.recode.vcf -b Megas_paralogous.recode.vcf -v >> NOTputative_paralogous.txt
