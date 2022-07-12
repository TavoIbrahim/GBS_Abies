#######################################
### Population parameter estimation ###
#######################################

# These command lines compute confidence intervals for population parameters (Table 2)
library(Rmisc)

# 1.- Read the data
boot<-read.table("../out_TMVB/GoodnessOfFit_2022/Hc12_IM-Hc12_IM.txt", header=T, sep="\t")

# 2.- Compute confidence intervals
datos<-matrix(NA, 24, 3)
for(i in 1:24){
	datos[i,]<-t(CI(boot[,i], ci=0.95))
}

datos<-data.frame(datos)
datos$Param<-colnames(boot)

# Table 2. Please, consider 1 generation = 60 calendaric years
colnames(datos)<-c("upper", "mean", "lower", "Param") 

