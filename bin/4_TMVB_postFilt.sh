#! /bin/sh

# These command lines remove putative paralogous and filter according to Minor Allele Count, Max Missing Data and mean depth

VAR2="1.0 0.87 0.50" # Missing data thrsholds

for i in $VAR2; do
	vcftools --vcf ../out_TMVB/Filtered_1SNPtmvb.recode.vcf --remove ../meta/AbiesIndv_exclu.txt --exclude-positions ../out_TMVB/Paralogous1SNPTMVB.txt --mac 2 --max-missing $i --minDP 10 --recode --out ../out_TMVB/ParFiltered_1SNPpop_mac2_mmiss${i}
done

# These vcf files were used to 1) asses potential bias in the population genetic statistics (see Supplementary material 2) and in the demographic inferences (see Table S6)
# We computed observed heterozygosity and F for each vcf

VAR1="$(ls -t ../out_TMVB/ParFiltered_1SNPpop_mac2_mmiss*.vcf | grep -v "minDP")"

fun()
{
    set $VAR2
for i in $VAR1; do
	vcftools --vcf $i --het
	cat out.het > ObsHet_mmiss${1}
	shift 
	done
}
fun
mv ObsHet_mmiss* ../out_TMVB/

# Additional vcfs were created for further pop structure/ demographic analyses. All considered 0.50 max missing data

# Only A. religiosa individuals (for DAPC analysis)
vcftools --vcf ../out_religiosa/Filtered_1SNPreligiosa.recode.vcf --exclude-positions ../out_religiosa/Paralogous1SNPreligiosa.txt --mac 2 --max-missing 0.50 --minDP 8 --recode --recode-INFO-all --out ../out_religiosa/ParFiltered_1SNPreligiosa_mac2_mmiss0.50
# A. religiosa samples (without Pops 4 and 5; for Admixture analysis)
vcftools --vcf ../out_religiosa_NoMan/Filtered_1SNPreligiosaNoMan.recode.vcf --exclude-positions ../out_religiosa_NoMan/Paralogous1SNPreligiosa2.txt --mac 2 --max-missing 0.50 --minDP 8 --recode --recode-INFO-all --out ../out_religiosa_NoMan/ParFiltered_1SNPreligiosaNoMan_mac2_mmiss0.50
# Fastsimcoal2 analyses
vcftools --vcf ../out_TMVB/Filtered_1SNP_Hc1.recode.vcf --exclude-positions ../out_TMVB/Paralogous1SNPHc1.txt --mac 2 --max-missing 0.50 --minDP 8 --recode --recode-INFO-all --out ../out_TMVB/ParFiltered_1SNPpop_mac2_mmiss0.50_minDP8_Hc1
vcftools --vcf ../out_TMVB/Filtered_1SNP_Hc2.recode.vcf --exclude-positions ../out_TMVB/Paralogous1SNPHc2.txt --mac 2 --max-missing 0.50 --minDP 8 --recode --recode-INFO-all --out ../out_TMVB/ParFiltered_1SNPpop_mac2_mmiss0.50_minDP8_Hc2
