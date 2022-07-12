########################################################
# Estimation of SNP error rate and Euclidean distances #
########################################################

library(adegenet)
library(vcfR)
library(lattice)

# Read filtered vcf files
temp = list.files(pattern="*2ndFilt.recode.vcf")
vcf.files = lapply(setNames(temp, make.names(gsub("*_2ndFilt.recode.vcf$", "", temp))), read.vcfR)
genlight.objects <- lapply(vcf.files, vcfR2genlight)

# Then, call for function
source("../../bin/SNP_error_EuclDist/Distancia_euclideana.r")
source("../../bin/SNP_error_EuclDist/snp_errorT.r")
source("../../bin/SNP_error_EuclDist/LociAllele_errorT.r")

# Compute SNP error rates and save them  

ErrorRates <- vector(mode = "list", length = length(genlight.objects))
for (i in 1:length(genlight.objects)){
  ErrorRates[[i]]<-SNP_error(genlight.objects[[i]], names(genlight.objects)[i])
}

write.table((do.call(rbind, ErrorRates)),"SNPerrorRates.txt", sep ="\t", quote = F, row.names = F)

# perform the same for Euclidean distances

EuclDist <- vector(mode = "list", length = length(genlight.objects))
for (i in 1:length(genlight.objects)){
  EuclDist[[i]]<-Distancia_euclideana(genlight.objects[[i]], names(genlight.objects)[i])
}

write.table((do.call(rbind, EuclDist)),"EuclDist.txt", sep ="\t", quote = F, row.names = F)

# and finally for allele error rate

LocAllError <- vector(mode = "list", length = length(genlight.objects))
for (i in 1:length(genlight.objects)){
  LocAllError[[i]]<-LociAllele_error(genlight.objects[[i]], names(genlight.objects)[i])
}

write.table((do.call(rbind, LocAllError)),"LocAllError.txt", sep ="\t", quote = F, row.names = F)

