# POPULATION GENETICS, ABIES

# These command lines were used to estimate summary statistics, including observed heterozygosity
# inbreeding coefficients and FST

# The following libraries are needed
library(adegenet)
library(vcfR)
library(hierfstat)
library(dplyr)
library(plyr)
library(popkin)
library(BEDMatrix)
library(PopGenome)

############################
### 1.- Prepare metadata ###
############################

# Read a list of individual names (with individuals that follow the same order in the vcfs)
# pop.data also includes pop ID number, genomic group ID number and geographic situation (A, allopatric; W, or C contact zones)
pop.data <- read.table("../out_TMVB/IndvNamesTMVB.csv", sep = ",", header = TRUE)
# Add complete metadata file
metadata<-read.csv("../meta/Placa_final_TMVB.csv", stringsAsFactors=F)
# And keep just individuals which are present in pop.data
metadata_cleaned<-metadata[metadata$key_comun %in% pop.data$id, ]
# Re-order metadata_cleaned according to pop.data
metadata_order<-metadata_cleaned[order(match(metadata_cleaned$key_comun, pop.data$id)), ]
rm(metadata, metadata_cleaned) 

################################
### 2.- Prepare genomic data ###
################################

# Genomic data from three SNP data sets (each with different missing data threshold) are imported
# Hereafter, command lines work with each SNP data set. 
# However, only results from mmiss0.50 data set were included in the Article (see Supplementary material 2).  

# a.- Read vcfs and convert to genind
temp<-list.files("../out_TMVB", full.names = T, pattern = "ParFiltered_1SNPpop_mac2_mmiss0.[58][07].recode.vcf$|ParFiltered_1SNPpop_mac2_mmiss1.0.recode.vcf$")
vcf.files <- lapply(setNames(temp, make.names(gsub("*.recode.vcf$|../out_TMVB/ParFiltered_1SNPpop_mac2_", "", temp))), read.vcfR)
snps.genind <- lapply(vcf.files, vcfR2genind)
rm(vcf.files)

#  Add pop information and convert to hierfstat format
for (i in 1:length(snps.genind)){
  pop(snps.genind[[i]])<-metadata_order$Localidad
  } # Instead of "Localidad", you can add genomic group (k6 column, following ADMIXTURE results)
snps.hierfstat <- lapply(snps.genind, genind2hierfstat)

###########################################################
### 3.- Observed and expected Heterozygosity (hierfstat)###
###########################################################

# Compute basic population genetic statistics
x<-lapply(snps.hierfstat, basic.stats)

# Get observed and expected heterozygosities for each population 
for (i in 1:length(x)){
DivHs<-(x[[i]])$Hs
DivHo<-(x[[i]])$Ho
assign(paste("SS_abies", sep="", names(x[i])), data.frame(Pop= colnames(DivHs),
                       Ho=colMeans(DivHo, na.rm= T),
                       Ho_sd=apply(DivHo, 2, sd, na.rm=T),
                       Hs=colMeans(DivHs, na.rm = T), 
                       Hs_sd=apply(DivHs, 2, sd, na.rm=T)))}

##############################################
### 4.- Observed Heterozygosity (vcftools) ###
##############################################

# Read heterozygous counts for each SNP data set
# These counts were estimated using Vcftools (see bin/4_TMVB_postFilt.sh script)

temp<-list.files("../out_TMVB", full.names = T, pattern = "ObsHet_mmiss") 
Ho.vcftools<-lapply(setNames(temp, make.names(gsub("../out_TMVB/ObsHet_", "", temp))),
                    read.table, sep="\t", header = T)

# Compute observed heterozygosity for each population
for (i in 1:length(Ho.vcftools)){
  O.HET<-((Ho.vcftools[[i]])$N_SITES)-((Ho.vcftools[[i]])$O.HOM) # Number of heterozygous sites
  freq.HET<- data.frame(O.HET/((Ho.vcftools[[i]])$N_SITES)) # Frequency of heterozygous sites
  colnames(freq.HET)<-"freq.HET"
  freq.HET$Pop<-metadata_order$Localidad # "Localidad" = population
  assign(paste("Obs_het", sep="", names(Ho.vcftools[i])), 
         ddply(freq.HET, ~ Pop, summarise, 
               mean_HoVcftools=mean(freq.HET, na.rm = TRUE), # and just compute mean and sd
               sd_HoVcftools=sd(freq.HET, na.rm = TRUE)))}
rm(freq.HET)

# Merge these estimations with those obtained in hierfstat
SS_abiesmmiss0.50<-merge(SS_abiesmmiss0.50, Obs_hetmmiss0.50, by="Pop", all.x=TRUE)
SS_abiesmmiss0.87<-merge(SS_abiesmmiss0.87, Obs_hetmmiss0.87, by="Pop", all.x=TRUE)
SS_abiesmmiss1.0<-merge(SS_abiesmmiss1.0, Obs_hetmmiss1.0, by="Pop", all.x=TRUE)

#########################################################
### 5.- Statistical analyses, Observed heterozygosity ###
#########################################################

# First, we create three data frames with observed heterozygosity for each individual
# Estimates come from Vcftools

freq.HET.list<-list()
for (i in 1:length(Ho.vcftools)){
  O.HET<-((Ho.vcftools[[i]])$N_SITES)-((Ho.vcftools[[i]])$O.HOM) # Number of heterocigous sites
  freq.HET.list[[i]]<-assign(paste("freq.HET", sep="", names(Ho.vcftools[i])), data.frame(O.HET/((Ho.vcftools[[i]])$N_SITES)))
}

# Change col names and add genomic group, geographic situation and species information
names(freq.HET.list)<-c("freq.HET0.50", "freq.HET0.87", "freq.HET1.0")
freq.HET.list<-lapply(freq.HET.list, function(x) {
  names(x)<- "freq.HET"
  x$Pop<-metadata_order$k6 # Change "k6" by "Localidad" to evaluate significant differences between populations
  x$SC<-pop.data$contact   # Add information regarding geographic situation (Allopatric, W or C contact zones)
  x$SP<-metadata_order$Especie # Add taxonomic information
  x})

# Finally, fit a lineal model for each SNP data set to test for significant differences between genomic groups
for (i in 1:length(freq.HET.list)){
  assign(paste("Lm", sep="_", names(freq.HET.list[i])),
         lm(freq.HET.list[[i]]$freq.HET ~ freq.HET.list[[i]]$Pop))
  }

# Use anova() and summary() functions over each lm object.
# Use check_model (see performance library) to study the model features

# Then, use a non-parametric test to ask for significant differences between contact zones and allopatric pops
for (i in 1:length(freq.HET.list)){
  assign(paste("WilcoxTest", sep="_", names(freq.HET.list[i])),
         pairwise.wilcox.test(freq.HET.list[[i]]$freq.HET, freq.HET.list[[i]]$SC, p.adjust.method = "BH"))
  }

###########################################
### 6.- Inbreeding: popkin and Vcftools ###
###########################################

# Read bed files (fam and bim files also should exist in the directory)
# Note: to get bed files, please check bin/2_Admixture_Abies.sh

temp<-list.files("../out_TMVB/popkin_results", full.names = T, pattern = ".bed")
SNPs.bed<-lapply(setNames(temp, make.names(gsub("*.bed$|../out_TMVB/popkin_results/ParFiltered_1SNPpop_mac2_", "", temp))), 
    BEDMatrix)

# Unlike other classic approximations, popkin suppose that populations have not evolved independently
# Therefore, we considered pop structure according to Admixture analysis
Subpop<-metadata_order$k6

# For each SNP data set, compute kinship: La probabilidad de que dos alelos muestreados al azar sean identicos por descendencia
kinship.list <- lapply(SNPs.bed, popkin, Subpop)

# Change col and row names
kinship.list<-lapply(kinship.list, function(x) {
  rownames(x)<-pop.data$id
  colnames(x)<-pop.data$id
  x})

# and reorder kinship matrix according to a longitudinal gradient
order<-(arrange(pop.data, pop.data$pop))$id # Order according to pop ID

kinship.sorted<-lapply(kinship.list, function(x) {
    kinshipOrd <-x[,order]
    x <-kinshipOrd[order,]
    x})

# Plot kinship for each SNP data set. Save in pdf formar
Poporder<-(arrange(pop.data, pop.data$pop))$pop # Order according to pop ID

for (i in 1:length(kinship.sorted)){
    pdf(paste("../out_TMVB/popkin_results/kinship", names(kinship.sorted[i]), ".pdf", sep = ""))
    plot_popkin(inbr_diag(kinship.sorted[i]), labs = Poporder, diag_line= TRUE, labs_las = 2, labs_line = 0.3, labs_cex= 0.8)
    dev.off()
}

# Extract inbreeding coefficients: La probabilidad de que dos alelos homologos (en el mismo individuo), sean identicos por descendencia.
inbreeding.list<-lapply(kinship.list, inbr) # We used kinship.list because we want to keep row match between inbreeding and observed heterozygosity

# Save inbreeding (from popkin) and observed heterozygosity (from Vcftools) data
for (i in 1:3){
    write.table(cbind(freq.HET.list[i], data.frame(inbreeding.list[i])),
        paste("../out_TMVB/Inbr_Ho", sep="", names(freq.HET.list[i]), ".txt"),
        sep="\t", quote = F, row.names=T)
}
    
# NOTE: These data frames will be used to fit LMMs (see Supplementary material 2)
# and to create Figure 2a

#####################################
### 7.- Inbreeding coeff (popikin)###
#####################################

# Convert from numeric to data frame using popkin estimates
inbr.popkin.list<-lapply(inbreeding.list, data.frame)

# Then, change colnames and add pop information
inbr.popkin.list<-lapply(inbr.popkin.list, function(x) {
  names(x)<- "Inbr.popkin"
  x$Pop<-metadata_order$Localidad # "Localidad" = Population
  x$K6<-metadata_order$k6 # Change "k6" by "Localidad" to evaluate significant differences between populations
  x$SC<-pop.data$contact   # Add information regarding geographic situation (Allopatric, W or C contact zones)
  x$SP<-metadata_order$Especie # Add taxonomic information
  x})

# Compute mean inbreeding (from popkin) for each population
for (i in 1:length(inbr.popkin.list)){
assign(paste("Inbr_popkin_POP", sep="", names(inbr.popkin.list[i])), 
         ddply(inbr.popkin.list[[i]], ~ Pop, summarise, 
               mean_InbrPopkin=mean(Inbr.popkin, na.rm = TRUE), 
               sd_InbrPopkin=sd(Inbr.popkin, na.rm = TRUE)))
  }

# Mean inbreeding estimates using Vcftools outputs
Ho.vcftools<-lapply(Ho.vcftools, function(x){
    x$Pop<-metadata_order$Localidad # "Localidad" = Population
  x})

# Compute mean inbreeding (from Vcftools) for each population
for (i in 1:length(Ho.vcftools)){
assign(paste("Inbr_Vcftools_POP", sep="", names(Ho.vcftools[i])), 
         ddply(Ho.vcftools[[i]], ~ Pop, summarise, 
               mean_InbrVcftools=mean(F, na.rm = TRUE), 
               sd_InbrVcftools=sd(F, na.rm = TRUE)))
  }

# Merge these mean inbreeding estimates
Inbr0.50<-merge(Inbr_popkin_POPmmiss0.50, Inbr_Vcftools_POPmmiss0.50, by="Pop", all.x=TRUE)
Inbr0.87<-merge(Inbr_popkin_POPmmiss0.87, Inbr_Vcftools_POPmmiss0.87, by="Pop", all.x=TRUE)
Inbr1.0<-merge(Inbr_popkin_POPmmiss1.0, Inbr_Vcftools_POPmmiss1.0, by="Pop", all.x=TRUE)

########################################################
### 8.- Significant differences, inbreeding (popkin) ###
########################################################

# Test for significant inbreeding differences between genomic groups, using lineal models

# Inbreeding estimates that come from popkin
for (i in 1:length(inbr.popkin.list)){
  assign(paste("Lm_Inbr", sep="_", names(inbr.popkin.list[i])),
         lm(inbr.popkin.list[[i]]$Inbr.popkin ~ inbr.popkin.list[[i]]$K6))
  }

# Use anova() and summary() functions over each lm object.
# Use check_model to check model features

# Then, use a non-parametric test to ask for significant differences between contact zones and allopatric pops
for (i in 1:length(inbr.popkin.list)){
  assign(paste("WilcoxTest", sep="_", names(inbr.popkin.list[i])),
         pairwise.wilcox.test(inbr.popkin.list[[i]]$Inbr.popkin, inbr.popkin.list[[i]]$SC, p.adjust.method = "BH"))
  }

########################################################################
### 9.- Significant differences between methods (popkin vs vcftools) ###
########################################################################

# Significant differences between Inbreeding coefficients (Vcftools vs. popkin) using t-student
Endogamia <- list()
for(i in 1:3){
    Endogamia[[i]]<-cbind(inbr.popkin.list[[i]], Ho.vcftools[[i]]$F, pop.data$pop)
}

# Change the object and column names
names(Endogamia)<-c("mmiss0.50", "mmiss0.87", "mmiss1.0")
Endogamia<-lapply(Endogamia, function(x) {
  names(x)<-c("popkin", "Pop", "K6", "SC", "SP", "vcftools", "Pop_num")
  x})

# Use Shapiro test to test for normality and then, t-student to test for significant differences between mean inbreeding estimates
Pops<-unique(Endogamia$mmiss0.50$Pop_num)

tStudent<-list()
for (i in 1:length(Endogamia)){
    tStudent[[i]]<-assign(paste("t-student_inbr_", sep="", names(Endogamia[i])), matrix(nrow=23, ncol=4))
    colnames(tStudent[[i]])<-c("st_pop", "st_vcf", "t", "pop")
    tStudent[[i]][,4]<-Pops # Set population names
    for (n in Pops){
        a<-Endogamia[[i]][Endogamia[[i]]$Pop_num == n,]
        tStudent[[i]][n,1]<-shapiro.test(a$popkin)$p.value
        tStudent[[i]][n,2]<-shapiro.test(a$vcftools)$p.value
        tStudent[[i]][n,3]<-t.test(a$popkin, a$vcftools, paired = TRUE)$p.value}
}

# Shapiro test: a p-value > 0.05 suggests that the distribution of the differences are not significantly different from normal distribution. 
# t test: If p-value < 0.05, We can reject null hypothesis and conclude that means are significantly different

# Use Wilcoxon test when normality is not satisfied
# First, we identified those pops where normality was not satisfied

NonNormal<-list()
for (i in 1:length(tStudent)){
    NonNormal[[i]]<- data.frame(tStudent[[i]])[data.frame(tStudent[[i]])$st_vcf < 0.05,]
}

# Then, we created a list with Wilcox test results
Wilcox<-list()
for(i in 1:length(NonNormal)){
    Wilcox[[i]]<-matrix(nrow=max(NonNormal[[i]]$pop), ncol=2) # Create matrices
    colnames(Wilcox[[i]])<-c("W", "pop")
    Wilcox[[i]][,2]<-c(1:max(NonNormal[[i]]$pop))
    for (w in NonNormal[[i]]$pop) # For each pop that did not fit to a normal distribution
    a<-Endogamia[[i]][Endogamia[[i]]$Pop_num == w,]
    Wilcox[[i]][w,1]<-wilcox.test(a$popkin, a$vcftools, paired = TRUE)$p.value
}
# If p < 0.05, Inbreeding (the median instead of the mean) were non significantly different

# Create a vector with pop data and then, merge it with tStudent data frames
Datos<-cbind(unique(Endogamia$mmiss0.50$Pop_num), unique(Endogamia$mmiss0.50$Pop))
colnames(Datos)<-c("pop", "Pop")

tStudent<-lapply(tStudent, function(x) {
  x<-merge(x, Datos, by = "pop", all= T)
  x})

# Merge t Student with inbreeding data
Inbr0.50<-merge(Inbr0.50, data.frame(tStudent[[1]]), by="Pop", all.x=TRUE)
Inbr0.87<-merge(Inbr0.87, data.frame(tStudent[[2]]), by="Pop", all.x=TRUE)
Inbr1.0<-merge(Inbr1.0, data.frame(tStudent[[3]]), by="Pop", all.x=TRUE)

# And finally merge with SS_abies data frames

SS_abiesmmiss0.50<-merge(SS_abiesmmiss0.50, Inbr0.50, by="Pop", all.x=TRUE)[,c(1:12,15)]
SS_abiesmmiss0.87<-merge(SS_abiesmmiss0.87, Inbr0.87, by="Pop", all.x=TRUE)[,c(1:12,15)]
SS_abiesmmiss1.0<-merge(SS_abiesmmiss1.0, Inbr1.0, by="Pop", all.x=TRUE)[,c(1:12,15)]

################################################################
### 10.- Nucleotide diversity, Global and pairwise FST, PopGenome ###
################################################################

# Each analysed vcf is saved in an independent directory so, we first have to list these directories.
files<-list.files("../out_TMVB", full.names = T, pattern = "TMVB_popGenome")
# Then, we're going to call a function that uses PopGenome package
source("SS_PopGenome.r")

# Apply SS_PopGenome function to compute nucleotide diversity, Tajimas D, FST (Hudson et al., 1992)
NucDiv_FST <- lapply(files, SS_PopGenome, pop.data)

# Add location data to pop.data
pop.data$location<-metadata_order$Localidad

# Change the order of the levels for "location" and then ... 
pop.data$location <- reorder(pop.data$location, pop.data$pop)

# add to data frames  
NucDiv_FST<-lapply(NucDiv_FST, function(x) {
  x[[1]]$Pop<-levels(factor(pop.data$location))
  x})

# Merge NucDiv with SS_abies objects

SS_abiesmmiss0.50<-merge(SS_abiesmmiss0.50, NucDiv_FST[[1]][[1]], by="Pop", all.x=TRUE)[,c(1:16,18,20)]
SS_abiesmmiss0.87<-merge(SS_abiesmmiss0.87, NucDiv_FST[[2]][[1]], by="Pop", all.x=TRUE)[,c(1:16,18,20)]
SS_abiesmmiss1.0<-merge(SS_abiesmmiss1.0, NucDiv_FST[[3]][[1]], by="Pop", all.x=TRUE)[,c(1:16,18,20)]

# Get information regarding the geographic situation of pops 
SC_info<-matrix(NA,23,3)
for(i in 1:23){
    SC_info[i,1]<- i # Fill the column with Pop id numbers
    SC_info[i,2]<-sort((pop.data[pop.data$pop== i,])$contact, decreasing = TRUE)[1]
    SC_info[i,3]<-sort((pop.data[pop.data$pop== i,])$group, decreasing = TRUE)[1]
}
colnames(SC_info)<-c("pop", "SC", "gg")

# And finally, include it in the final tables
SS_abiesmmiss0.50<-merge(SS_abiesmmiss0.50, SC_info, by="pop", all.x=TRUE) # Table S5
SS_abiesmmiss0.87<-merge(SS_abiesmmiss0.87, SC_info, by="pop", all.x=TRUE)
SS_abiesmmiss1.0<-merge(SS_abiesmmiss1.0, SC_info, by="pop", all.x=TRUE)

# Write these tables for further analyses and for Supplementary material 2
write.table(SS_abiesmmiss0.50, "../out_TMVB/SS_abiesmmiss0.50.txt", sep="\t", quote=F, row.names=F)
write.table(SS_abiesmmiss0.87, "../out_TMVB/SS_abiesmmiss0.87.txt", sep="\t", quote=F, row.names=F)
write.table(SS_abiesmmiss1.0, "../out_TMVB/SS_abiesmmiss1.0.txt", sep="\t", quote=F, row.names=F)