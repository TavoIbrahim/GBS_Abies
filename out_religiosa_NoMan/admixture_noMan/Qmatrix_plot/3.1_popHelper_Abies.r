###############################################
### Ancestry plot using pophelper R package ###
###############################################

# These command lines create the Figure S8 d & e and uses .Q files previously selected after run ../../../bin/2.1_Admixture_Abies.sh
library(ggplot2)
library(gridExtra)
library(gtable)
library(tidyr)
library(pophelper)

# 1.- Read all Q files

# use ADMIXTURE files (do not use this command to read local files)
    afiles<- list.files(pattern= ".Q", full.names=T)
    alist <- readQ(files=afiles)
    
    # 2.- Add individual names
    
    #Import file names
    inds <- read.delim(("IndvNames.txt"),#Con los nombres de los individuos en el orden en el que queremos que aparezcan en el plot
                       header=FALSE,
                       stringsAsFactors=F)
    
    # Add indlab to all runs
    if(length(unique(sapply(alist,nrow)))==1) alist <- lapply(alist,"rownames<-",inds$V1)
    
    # 3.- Add more data regarding samples
    
    metadata<-read.csv("../../../meta/Placa_final_TMVB.csv", 
                       stringsAsFactors=F)
    
    #Make sure that the labels are character datatype
    sapply(metadata_order, is.character)
    
    #And keep just individuals present in ADMIXTURE PLOT
    metadata_cleaned<-metadata[metadata$key_comun %in% inds$V1, ]
    
    #re order metadata_cleaned according to individual names in ADMIXTURE PLOT
    metadata_order<-metadata_cleaned[order(match(metadata_cleaned$key_comun, inds$V1)), ]
    
    #Select which criteria you want to use to group your samples
    onelabset1 <- metadata_order[,7,drop=FALSE]
    
    #Make and plot the graph
    
    Guspalette =c("#d7db54", "#21c0cc", "#2e828b")
    
    pdf("ParFiltered_mac2_mmiss050.pdf", width = 12)
    p2 <- plotQ(alist[c(1,2)],imgoutput="join",returnplot=T,exportplot=F,quiet=T,basesize=11,
                grplab=onelabset1,grplabsize=4,linesize=0.8,pointsize=4, grplabangle = 45, 
                clustercol = Guspalette, barbordercolour = "black")
    grid.arrange(p2$plot[[1]],nrow=2)
    dev.off()

