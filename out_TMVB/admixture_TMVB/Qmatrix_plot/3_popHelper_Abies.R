###############################################
### Ancestry plot using pophelper R package ###
###############################################

# These command lines create the Figure 3 c and uses .Q files previously selected after run 2_Admixture_Abies.sh
library(ggplot2)
library(gridExtra)
library(gtable)
library(tidyr)
library(pophelper)

# 1.- Read all Q files
afiles<- list.files(pattern= ".Q", full.names=T)
alist <- readQ(files=afiles)

# 2.- Add individual names
pop.data <- read.table("../../IndvNamesTMVB.csv", sep = ",", header = TRUE)
# Set names to all individuals
if(length(unique(sapply(alist,nrow)))==1) alist <- lapply(alist,"rownames<-",pop.data$id)

# Read a second file with individual ordered according to a longitudinal gradient
inds <- read.delim(("IndvNames.txt"), header=FALSE, stringsAsFactors=F)

# Then, re-order rows in alist
for (i in 1:4){
  alist[[i]]<-alist[[i]][order(match(row.names(alist[[i]]), inds$V1)), ]
}

# 3.- Add more data regarding samples

metadata<-read.csv("../../../meta/Placa_final_TMVB.csv", stringsAsFactors=F)
# Keep only individuals that were analysed 
metadata_cleaned<-metadata[metadata$key_comun %in% inds$V1, ]
# Re-order metadata_cleaned inds
metadata_order<-metadata_cleaned[order(match(metadata_cleaned$key_comun, inds$V1)), ]

#Make sure that the labels are character datatype
sapply(metadata_order, is.character)

#Select one of the columns in metadata_order to group the samples
onelabset1 <- metadata_order[,7,drop=FALSE] # Sierra

# 4.- Make plots (Figure 3c)

Guspalette =c("#21c0cc","#273253","#dd974a","#ffffb2")

pdf("ParFiltered_mac2_mmiss050_k3-4.pdf", width = 12)
p2 <- plotQ(alist[c(1,2)],imgoutput="join",returnplot=T,exportplot=F,quiet=T,basesize=11,
            grplab=onelabset1,grplabsize=4,linesize=0.8,pointsize=4, grplabangle = 45, 
            clustercol = Guspalette, barbordercolour = "black")

grid.arrange(p2$plot[[1]],nrow=2)
dev.off()

  Guspalette<-c("#21c0cc","#273253","#dd974a","#ffffb2","#2e828b","#d7db54")

pdf("ParFiltered_mac2_mmiss050_k5-6.pdf", width = 12)
p2 <- plotQ(alist[c(3,4)],imgoutput="join",returnplot=T,exportplot=F,quiet=T,basesize=11,
            grplab=onelabset1,grplabsize=4,linesize=0.8,pointsize=4, grplabangle = 45, 
            clustercol = Guspalette, barbordercolour = "black")

grid.arrange(p2$plot[[1]],nrow=2)
dev.off()
