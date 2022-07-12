
# These command lines plot Cross validation results after an ADMIXTURE analysis 
data<-read.csv("CV.csv", sep=",", header=F)
colnames(data)<-c("K", "cv_value")

pdf("CV_value.pdf")
plot(as.factor(data$K), data$cv_value, xlab="K", ylab="CV value")
dev.off()
