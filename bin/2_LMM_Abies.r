################################
### Supplementary material 2 ###
################################

# These command lines fit three lmms to identify significant differences between summary statistics
# computed using SNP datasets with different levels of missing data 

library(ggplot2)
library(lme4)
library(lmerTest)
library(MuMIn) # to calculate coefficients of determination

##########################################
### Observed Heterozygosity (vcftools) ###
##########################################

# Read and prepare thet data (Tables were obtained from 1_SS_Abies.r)

# 0.50 missing data allowed
ho50<-read.table("../out_TMVB/Inbr_Hofreq.HET0.50.txt", header=T, sep="\t")
ho50$indv<-rownames(ho50)
colnames(ho50)<-c("Hobs", "gg", "SC", "sp", "inbr", "indv")
ho50$mmiss<-50
# 0.13 missing data allowed
ho13<-read.table("../out_TMVB/Inbr_Hofreq.HET0.87.txt", header=T, sep="\t")
ho13$indv<-rownames(ho13)
colnames(ho13)<-c("Hobs", "gg", "SC", "sp", "inbr", "indv")
ho13$mmiss<-13
# No missing data allowed
ho00<-read.table("../out_TMVB/Inbr_Hofreq.HET1.0.txt", header=T, sep="\t")
ho00$indv<-rownames(ho00)
colnames(ho00)<-c("Hobs", "gg", "SC", "sp", "inbr", "indv")
ho00$mmiss<-0
# Merge data
ho<-rbind(ho50, ho13, ho00)
rm(ho50, ho13, ho00)

# Fitting a linear mixed model: 
# Genomic groups and missing data explains Hobs variance. Samples IDs are considered as random factor. 
m5<-lmer(ho$Hobs ~ ho$mmiss + ho$gg + (1|ho$indv))

# Coefficients of determination
r.squaredGLMM(m5)

# Conditional and marginal coefficient of determination (R2)
#   R2m       R2c
#0.5422026 0.7588462

# where Marginal effect represents the variance explained by the fixed effects
# and the Conditional, for the complete model (fixedsummary(m5) and random effect)

summary(m5)
#Linear mixed model fit by REML. t-tests use
#Satterthwaite's method [lmerModLmerTest]
#Formula: ho$freq.HET ~ ho$mmiss + ho$Group + (1 | ho$INDV)

#REML criterion at convergence: -1840.6

#Scaled residuals: 
#    Min      1Q  Median      3Q     Max 
#-3.4460 -0.4512  0.0185  0.5272  2.4415 

#Random effects:
# Groups   Name        Variance  Std.Dev.
# ho$INDV  (Intercept) 0.0001247 0.01117 
# Residual             0.0001388 0.01178 
#Number of obs: 342, groups:  ho$INDV, 114

#Fixed effects:
#                     Estimate Std. Error         df t value
#(Intercept)         7.558e-02  4.182e-03  1.120e+02  18.071
#ho$mmiss            1.003e-04  3.007e-05  2.270e+02   3.336
#ho$Groupcolimensis -3.362e-02  5.712e-03  1.070e+02  -5.885
#ho$Groupflinckii   -3.572e-02  4.986e-03  1.070e+02  -7.163
#ho$Groupjaliscana  -3.677e-02  5.499e-03  1.070e+02  -6.687
#ho$Grouprel        -5.361e-04  4.754e-03  1.070e+02  -0.113
#ho$Grouprelm1      -5.982e-03  5.210e-03  1.070e+02  -1.148
#ho$GrouprelP        8.295e-03  5.847e-03  1.070e+02   1.419
#                   Pr(>|t|)    
#(Intercept)         < 2e-16 ***
#ho$mmiss           0.000993 ***
#ho$Groupcolimensis 4.62e-08 ***
#ho$Groupflinckii   1.05e-10 ***
#ho$Groupjaliscana  1.07e-09 ***
#ho$Grouprel        0.910436    
#ho$Grouprelm1      0.253473    
#ho$GrouprelP       0.158852    
#---
#Signif. codes:  
#0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Correlation of Fixed Effects:
#            (Intr) h$mmss h$Grpc h$Grpf h$Grpj h$Grpr h$Grp1
#ho$mmiss    -0.151                                          
#h$Grpclmnss -0.715  0.000                                   
#ho$Grpflnck -0.820  0.000  0.600                            
#ho$Grpjlscn -0.743  0.000  0.544  0.623                     
#ho$Grouprel -0.860  0.000  0.629  0.721  0.654              
#ho$Groprlm1 -0.784  0.000  0.574  0.658  0.597  0.690       
#ho$GrouprlP -0.699  0.000  0.512  0.586  0.532  0.615  0.561

# Get an ANOVA-like table: Table S2 in Supplementary material 2 
step(m5)

# Figure S2 a in Supplementary material 2
Guspalette<-c("#d7db54","#fed976","#dd974a","#273253","#21c0cc","purple","#2e828b") # Color palette
pdf("../out_TMVB/LMobsHet_Abies_mm2_interaccion2.pdf")
ggplot(ho, aes(mmiss, Hobs, color = gg)) +
  geom_point(colour = "black", alpha=0.2, size=4) + # remove color to get points coloured by genomic group
  theme_bw()+
  scale_color_manual(values = Guspalette, labels=c("A.rel (W)", "A.rel (C)", "A.flinckii", "A.jaliscana", "A. rel (E)", "Admixture", "A.rel (P)"))+
  geom_smooth(method='lm',formula=y~x, alpha = 0.2)+ 
  theme(legend.position="right", axis.text.x=element_text(size=10), axis.text.y=element_text(size=10),
        axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))+ 
  labs(y="Ho", x="Missing data (%)")+
  annotate(geom="text", x=5, y=0.125, label=expression(R^2 == 0.549))
dev.off()

# Fit an lm to identify significant differences between species and pops with different patterns of geographic distribution (W, C and allopatric) 
# Notice that this lm considers only data from ho50 cause missing data seems to play a minor (but significan) effect. 
m2<-lm(formula = ho50$Hobs ~ ho50$sp + ho50$SC)

summary(m2)
#Call:
#  lm(formula = ho50$Hobs ~ ho50$sp + ho50$SC)
#
#Residuals:
#  Min        1Q    Median        3Q       Max 
#-0.043316 -0.006622  0.000467  0.006326  0.034295 
#
#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)
#(Intercept)          0.051073   0.003167  16.125  < 2e-16
#ho50$spA. jaliscana -0.002474   0.004504  -0.549    0.584
#ho50$spA. religiosa  0.026292   0.003051   8.617 5.97e-14
#ho50$SCblue         -0.002183   0.003088  -0.707    0.481
#ho50$SCred          -0.023159   0.003236  -7.157 1.01e-10
#
#(Intercept)         ***
#  ho50$spA. jaliscana    
#ho50$spA. religiosa ***
#  ho50$SCblue            
#ho50$SCred          ***
#  ---
#  Signif. codes:  
#  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#Residual standard error: 0.01155 on 109 degrees of freedom #0.01155 es el error estandar de los residuales
#Multiple R-squared:  0.6565,	Adjusted R-squared:  0.6439 
#F-statistic: 52.08 on 4 and 109 DF,  p-value: < 2.2e-16

# Create Figure 2a
ho50$sp <- factor(ho50$sp,levels = c('A. jaliscana','A. flinckii', 'A. religiosa'),ordered = TRUE) # Re-order the boxes

  pdf("../out_TMVB/Hobs_indv_050.pdf")
  g<-ggplot(ho50, aes(x = sp, y = Hobs, color = SC)) +
    scale_color_manual(labels = c("Allopatric", "C Contact", "W Contact"),values =c("black", "blue", "red")) +
    labs(x = NULL, y = expression(H["obs"])) +
    theme_bw()+
    guides(color=guide_legend(""))+
    theme(axis.title = element_text(size = 16),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12))  
  g + geom_boxplot(color = "gray40", outlier.alpha = 0) +
    geom_jitter(size = 4, alpha = 0.50, width = 0.2)
  dev.off()

###########################
### Inbreeding (popkin) ###
###########################

# Fit a lmm for inbreeding
m5<-lmer(ho$inbr ~ ho$mmiss + ho$gg + (1|ho$indv))

r.squaredGLMM(m5)
#     R2m      R2c
# 0.5147538 0.7142132

summary(m5)
#Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#lmerModLmerTest]
#Formula: ho$inbr ~ ho$mmiss + ho$gg + (1 | ho$indv)

#REML criterion at convergence: -333.1

#Scaled residuals: 
#    Min      1Q  Median      3Q     Max 
#-3.2052 -0.3867  0.0694  0.5285  3.1530 

#Random effects:
# Groups   Name        Variance Std.Dev.
# ho$indv  (Intercept) 0.009353 0.09671 
# Residual             0.013402 0.11577 
#Number of obs: 342, groups:  ho$indv, 114

#Fixed effects:
#                  Estimate Std. Error         df t value Pr(>|t|)    
#(Intercept)      3.025e-01  3.769e-02  1.130e+02   8.026 1.05e-12 ***
#ho$mmiss         1.298e-03  2.955e-04  2.270e+02   4.391 1.73e-05 ***
#ho$ggcolimensis  2.957e-01  5.137e-02  1.070e+02   5.757 8.26e-08 ***
#ho$ggflinckii    3.052e-01  4.484e-02  1.070e+02   6.808 5.96e-10 ***
#ho$ggjaliscana   3.226e-01  4.945e-02  1.070e+02   6.524 2.33e-09 ***
#ho$ggrel         3.082e-03  4.275e-02  1.070e+02   0.072    0.943    
#ho$ggrelm1       5.223e-02  4.685e-02  1.070e+02   1.115    0.267    
#ho$ggrelP       -7.690e-02  5.257e-02  1.070e+02  -1.463    0.147    
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Correlation of Fixed Effects:
#            (Intr) h$mmss h$ggcl h$ggfl h$ggjl h$ggrl h$ggr1
#ho$mmiss    -0.165                                          
#ho$ggclmnss -0.714  0.000                                   
#ho$ggflinck -0.818  0.000  0.600                            
#ho$ggjalscn -0.742  0.000  0.544  0.623                     
#ho$ggrel    -0.858  0.000  0.629  0.721  0.654              
#ho$ggrelm1  -0.783  0.000  0.574  0.658  0.597  0.690       
#ho$ggrelP   -0.697  0.000  0.512  0.586  0.532  0.615  0.561

# Get an ANOVA-like table: Table S2 in Supplementary material 2 
step(m5)

# Figure S2 b in Supplementary material 2
pdf("../out_TMVB/LMinbreed_Abies_mm2_interaccion2.pdf")
ggplot(ho, aes(mmiss, inbr, color = gg)) +
  geom_point(colour = "black", alpha=0.2, size=4) +
  theme_bw()+
  scale_color_manual(values = Guspalette, labels=c("A.rel (W)", "A.rel (C)", "A.flinckii", "A.jaliscana", "A. rel (E)", "Admixture", "A.rel (P)"))+
  geom_smooth(method='lm',formula=y~x, alpha = 0.25)+ 
  theme(legend.position="right", axis.text.x=element_text(size=10), axis.text.y=element_text(size=10),
        axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))+ 
  labs(y="Inbreeding", x="Missing data (%)")+
  annotate(geom="text", x=5, y=1, label=expression(R^2 == 0.514))
dev.off()

# Use species and the geographic distribution of pops (SC) to predict inbreeding
# Again, only data from ho50 was analysed
m2<-lm(formula = ho50$inbr ~ ho50$sp + ho50$SC)
summary(m2)

#######################
### FST (PopGenome) ###
#######################

# Read FST data, which was previously computed with 1_SS_Abies.r 

fst50<-read.table("../out_TMVB/SS_abiesmmiss0.50.txt", sep="\t", header=T)
fst13<-read.table("../out_TMVB/SS_abiesmmiss0.87.txt", sep="\t", header=T)
fst00<-read.table("../out_TMVB/SS_abiesmmiss1.0.txt", sep="\t", header=T)

# Add missing data information
fst50$mmiss<-50
fst13$mmiss<-13
fst00$mmiss<-0
FST<-rbind(fst50, fst13, fst00)

# Fit a lmm
m5<-lmer(FST$Fst ~ FST$mmiss + as.factor(FST$gg) + (1|FST$Pop))

summary(m5)
#Linear mixed model fit by REML. t-tests use Satterthwaite's method [
#lmerModLmerTest]
#Formula: FST$Fst ~ FST$mmiss + as.factor(FST$gg) + (1 | FST$Pop)

#REML criterion at convergence: -206.3

#Scaled residuals: 
#     Min       1Q   Median       3Q      Max 
#-2.41611 -0.55851 -0.04951  0.73911  1.42488 

#Random effects:
# Groups   Name        Variance  Std.Dev.
# FST$Pop  (Intercept) 0.0007609 0.02758 
# Residual             0.0009459 0.03076 
#Number of obs: 69, groups:  FST$Pop, 23

#Fixed effects:
#                     Estimate Std. Error         df t value Pr(>|t|)    
#(Intercept)         0.5119140  0.0192926 17.2159647  26.534 2.08e-15 ***
#FST$mmiss           0.0002691  0.0001748 45.0000004   1.539  0.13073    
#as.factor(FST$gg)2 -0.0080580  0.0239576 15.9999992  -0.336  0.74098    
#as.factor(FST$gg)3 -0.1150881  0.0299471 15.9999992  -3.843  0.00144 ** 
#as.factor(FST$gg)4 -0.1624960  0.0299471 15.9999992  -5.426 5.60e-05 ***
#as.factor(FST$gg)5 -0.2438924  0.0267855 15.9999992  -9.105 9.95e-08 ***
#as.factor(FST$gg)6 -0.2502807  0.0231969 15.9999992 -10.789 9.45e-09 ***
#as.factor(FST$gg)7 -0.2083321  0.0299471 15.9999992  -6.957 3.23e-06 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Correlation of Fixed Effects:
#            (Intr) FST$mm a.(FST$)2 a.(FST$)3 a.(FST$)4 a.(FST$)5 a.(FST$)6
#FST$mmiss   -0.190                                                         
#as.f(FST$)2 -0.776  0.000                                                  
#as.f(FST$)3 -0.621  0.000  0.500                                           
#as.f(FST$)4 -0.621  0.000  0.500     0.400                                 
#as.f(FST$)5 -0.694  0.000  0.559     0.447     0.447                       
#as.f(FST$)6 -0.802  0.000  0.645     0.516     0.516     0.577             
#as.f(FST$)7 -0.621  0.000  0.500     0.400     0.400     0.447     0.516

r.squaredGLMM(m5)
#     R2m       R2c
# 0.8719765 0.9290474

# Figure S2 c in Supplementary material 2
Guspalette<-c("#dd974a","#fed976","#d7db54","#273253","#21c0cc","purple","#2e828b")

  pdf("../out_TMVB/LMfst_Abies_mm2_interaccion2.pdf")
  ggplot(FST, aes(mmiss, Fst, color = as.factor(gg))) +
    geom_point(colour = "black", alpha=0.2, size=4) +
    theme_bw()+
    scale_color_manual(values = Guspalette, labels=c("A. flinckii", "A.rel (W)", "A.rel (C)", "A.jaliscana", "A. rel (E)", "A. rel (M)", "A.rel (P)"))+
    geom_smooth(method='lm',formula=y~x, alpha = 0.2)+ 
    theme(legend.position="right", axis.text.x=element_text(size=10), axis.text.y=element_text(size=10),
          axis.title.x=element_text(size=15), axis.title.y=element_text(size=15))+ 
    labs(y="Fst", x="Missing data (%)")+
    annotate(geom="text", x=5, y=0.6, label=expression(R^2 == 0.877))
  dev.off()
