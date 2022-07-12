######################################
### DAPC analysis for A. religiosa ###
######################################

# Required libraries
library(vcfR)
library(adegenet)
library(poppr)
library(viridis)

# 1.- Read a vcf file
rel <-read.vcfR("../out_religiosa/ParFiltered_1SNPreligiosa_mac2_mmiss0.50.recode.vcf")

# 2.- Preparing metadata file
# pop.data contains individual names and pop ID numbers
pop.data <- read.table("../out_religiosa/out.imiss", sep = "\t", header = TRUE)
# Check that all samples included in pop.data are in the VCF
all(colnames(rel@gt)[-1] == pop.data$INDV) # we expect TRUE
# Add complete metadata file
metadata<-read.csv("../meta/Placa_final_TMVB.csv", stringsAsFactors=F)
# And keep just individuals which are present in the VCF
metadata_cleaned<-metadata[metadata$key_comun %in% pop.data$INDV, ]
# Re-order metadata_cleaned according to individual names in pop.data
metadata_order<-metadata_cleaned[order(match(metadata_cleaned$key_comun, pop.data$INDV)), ]
rm(metadata, metadata_cleaned) 
# Make sure that the labels are not character data type
sapply(metadata_order, is.character) # We expect TRUE

# 3.- Convert the vcf to genlight object (or genind)
rel.genlight <- vcfR2genlight(rel)
rm(rel)

# 4.-  Assign individuals to:
pop(rel.genlight) <- metadata_order$Localidad

# 5.- Run a DAPC analysis by performing a cross validation test
pramx<-xvalDapc(tab(rel.genlight,NA.method="mean"), pop(rel.genlight))

# 6.- Check the plot created above and then, select a reduced PCA range (use n.pca). Run again the DAPC
pramx<-xvalDapc(tab(rel.genlight,NA.method="mean"),
                pop(rel.genlight), n.pca = 15:40,
                n.rep = 1000, parallel="multicore",
                ncpus= 3L)
pramx[-1] # Check the results

# 7.- Create a DAPC plot (Figure 3b)
colores<-c("#440154","#74add1","#4575b4","#ffd700","#9e0852","#ffeda0","#abd9e9","#00555e","#2e828b","#000000","#313695","#3288bd","#B6D000","#66c2a5","#95ee0dd6")
pdf("../out_religiosa/cvDAPC.pdf")
scatter(pramx$DAPC, mstree = T, clabel = F, lwd = 2,
  grid=T, legend = T, posi.leg = "topleft", cex=3,
  col = colores, cleg = 0.80, posi.da = "bottomleft")
dev.off()
