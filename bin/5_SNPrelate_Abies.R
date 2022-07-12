####################
### PCA analysis ###
####################

# Required libraries
library(gdsfmt)
library(SNPRelate)
library(ggplot2)
library(RColorBrewer)

# 1.- Import the vcf file
vcf.fn <- "../out_TMVB/ParFiltered_1SNPpop_mac2_mmiss0.50SNPrelate.recode.vcf"
# create a gds file
snpgdsVCF2GDS(vcf.fn, "../out_TMVB/TMVB_SNPrelate_0.50/test.gds", method="biallelic.only", verbose = TRUE)
# Check a summary of the gds file
snpgdsSummary("test.gds")
# Open the gds file
genofile <- snpgdsOpen("../out_TMVB/TMVB_SNPrelate_0.50/test.gds")

# 2.- Run a PCA analysis
pca <- snpgdsPCA(genofile, num.thread=2)

# 3.- Check the amount of variance explained by each PC
pc.percent <- pca$varprop*100
head(round(pc.percent, 2))

# 4.- Again, use metadata_order
# Read a list of individual names (with individuals that follow the same order in the vcfs)
pop.data <- read.table("../out_TMVB/IndvNamesTMVB.csv", sep = ",", header = TRUE)
# Add complete metadata file
metadata<-read.csv("../meta/Placa_final_TMVB.csv", stringsAsFactors=F)
# And keep just individuals which are present in pop.data
metadata_cleaned<-metadata[metadata$key_comun %in% pop.data$id, ]
# Re-order metadata_cleaned according to pop.data
metadata_order<-metadata_cleaned[order(match(metadata_cleaned$key_comun, pop.data$id)), ]
rm(metadata, metadata_cleaned)
# Keep individual name, pop name and genomic group information
pop_code<-metadata_order[,c(3,5,8)] 

# 5.- Make a data.frame with all information to generate PCA plots 
tab <- data.frame(sample.id = pca$sample.id,
                  pop = factor(pop_code$k6),
                  sp= factor(pop_code$Especie),
                  EV1 = pca$eigenvect[,1],
                  EV2 = pca$eigenvect[,2],
                  EV3 = pca$eigenvect[,3],
                  stringsAsFactors = FALSE)

# 6.- PCA plot where point are coloured according to a taxonomic separation (Figure Sn)
Guspalette =c("#dd974a","#273253","#21c0cc")
pdf("../out_TMVB/TMVB_SNPrelate_0.50/PCA_ParFilt_mac2_mmiss50_TMVB.pdf")
plot(tab$EV2, tab$EV1, col="black", 
     xlab="PC2 (6.3%)", ylab="PC1 (7.7.%)", 
     pch = 21, cex=2,
     bg=Guspalette[as.integer(tab$sp)])
grid()
legend("topright", legend=levels(tab$sp), 
       pch=21, col="black", bty = "n",
       pt.bg =Guspalette)
dev.off()

# 7.- PCA plot where point are coloured according to ADMIXTURE inference (Figure Sn)
Guspalette<-c("#d7db54","#ffffb2","#dd974a","#273253","#21c0cc","#440154","#21c0cc","#2e828b")
pdf("../out_TMVB/TMVB_SNPrelate_0.50/PCA_ParFilt_mac2_mmiss50_TMVBggroup.pdf")
plot(tab$EV3, tab$EV1, col="black", 
     xlab="PC3 (3.08%)", ylab="PC1 (7.74.%)", 
     pch = 21, cex=2,
     bg=Guspalette[as.integer(tab$pop)])
grid()
legend("bottomright", legend=levels(tab$pop), 
       pch=21, col="black", pt.bg=Guspalette, bty = "n")
dev.off()