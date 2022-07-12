
##############################################################
### Likelihood ratio G-statistic test (CLR= log10(CLO/CLE) ###
##############################################################

# These command lines compute CLR distributions

# Observed CLR
# log10(-693.638/-783.766)= -0.05305354

# Read data
Hc12IM<-read.table("../out_TMVB/GoodnessOfFit_2022/Hc12_IM-Hc12_IM.txt", sep="\t", header=T)
Hc12rec<-read.table("../out_TMVB/GoodnessOfFit_2022/Hc12_IM-Hc12_recmig.txt", sep="\t", header=T)
Hc9rec<-read.table("../out_TMVB/GoodnessOfFit_2022/Hc12_IM-Hc9_recmig.txt", sep="\t", header=T)

# Hc12 IM
Hc12_IM<-matrix(NA, 100, 2)
for(i in 1:100){
		Hc12_IM[i,1]<- "Hc12 IM"
		Hc12_IM[i,2]<-log10(Hc12IM[i,ncol(Hc12IM)]/Hc12IM[i,ncol(Hc12IM)-1])
	}

# Hc12 recent migration
Hc12_rec<-matrix(NA, 100, 2)
for(i in 1:100){
		Hc12_rec[i,1]<- "Hc12 recmig"
		Hc12_rec[i,2]<-log10(Hc12rec[i,ncol(Hc12rec)]/Hc12rec[i,ncol(Hc12rec)-1])
	}

# Hc9 recent migration
Hc9_rec<-matrix(NA, 100, 2)
for(i in 1:100){
		Hc9_rec[i,1]<- "Hc9 recmig"
		Hc9_rec[i,2]<-log10(Hc9rec[i,ncol(Hc9rec)]/Hc9rec[i,ncol(Hc9rec)-1])
	}

# Fix the data frame
data<-rbind(Hc12_IM, Hc12_rec, Hc9_rec)
colnames(data)<-c("model", "CLR")
data$CLR <- sapply(data$CLR, as.numeric)


library(ggplot2)
# Density plots with semi-transparent fill
pdf("../out_TMVB/GoodnessOfFit_2022/GoodOfFit.pdf")
ggplot(data, aes(x=CLR, fill=model)) + geom_density(alpha=.3)+
    geom_vline(aes(xintercept=-0.05305354), color="red", linetype="dashed", size=1)
dev.off()
