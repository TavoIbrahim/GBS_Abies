####################
### pairwise FST ###
####################

# Required libraries
library(ggplot2)
library(plyr)
library(tidyverse)

# If reproductive isolation was favored during secondary contact, then, higher interspecific FST values are expected
# at contact zones when compared to pops distributed in allopatry

# We tested this hypothesis by contrasting pairwise FST estimates

# 1.- Read the data and re-order the levels
fst<-read.table("../out_TMVB/pairwiseFSTpopgenome2.txt", sep = "\t", header = T)
order<-c("jalisc_intra", "rel_intra","flinckii_intra", "J_R", "flinckii_rel", "J_F")
fst$Comparison<-factor(fst$Comparison, levels = order)
# This information was computed using the command lines of 1_SS_Abies.r (line 334)

# 2.- Create a nice FST plot 
# Compute average FST, considering all values
world_avg <- 
  fst %>%
  summarize(avg = mean(fst, na.rm = T)) %>%
  pull(avg)
# Compute average FST for each category (inter and intraspecific pairwise FST)
media<-ddply(fst, ~ Comparison, summarise, 
               mean_fst=mean(fst, na.rm = TRUE),
             sd_fst=sd(fst, na.rm = TRUE))

#     Comparison   mean_fst     sd_fst
#   jalisc_intra 0.03780786 0.07140704
#      rel_intra 0.16651429 0.10394646
# flinckii_intra 0.32990000 0.14832056
#            J_R 0.47551025 0.03932113
#   flinckii_rel 0.51209333 0.06900708
#            J_F 0.61320000 0.05526714

# Add mean_fst to fst dataframe 
fst$mean_comparison <- media$mean_fst[match(fst$Comparison, media$Comparison)]

# Create a nice FST plot
  pdf("../out_TMVB/pairwiseFSTpopgenome2.pdf")
  ggplot(fst, aes(x =Comparison, y = fst, color= location)) +
    coord_flip() +
    labs(x = NULL, y = expression(F["ST"])) +
    scale_y_continuous(limits = c(-0.01, 0.8))+
    scale_color_manual(values = c("black", "blue", "red"))+
    theme_bw()+
    theme(legend.position="none")+
    geom_jitter(position = position_jitter(seed = 1989, width = 0.2), size = 4, alpha = 0.35)+
    stat_summary(fun = mean, geom = "point", size = 5)+
    geom_hline(aes(yintercept = world_avg), color = "gray70", size = 0.6)+
    geom_segment(aes(x = Comparison, xend = Comparison,
          y = world_avg, yend = mean_comparison),size = 0.8)+ 
    scale_x_discrete(labels=c("A.jalis", "A.rel", "A.flin", "J-F", "F-R", "J-R"))
  dev.off()

## Now keep only A.flinckii-A.religiosa comparisons
fst_FR<-fst[fst$Comparison=="flinckii_rel",]
fst_FR$location<-factor(fst_FR$location, levels =c("W","C", "allopatric"))

# and FST for each geographic category
media<-ddply(fst_FR, ~ location, summarise, 
               mean_fst=mean(fst, na.rm = TRUE),
             sd_fst=sd(fst, na.rm = TRUE))

#   location  mean_fst     sd_fst
#          W 0.5975000 0.10852496
#          C 0.4910000 0.04682592
# allopatric 0.5082537 0.06496277

# Test significan differences
mm<-lm(fst_FR$fst~ fst_FR$location) # Normality was previously tested using performance library, in R


# Create a second plot (Figure 2b)
  pdf("../out_TMVB/PairwiseFST_popgenome.pdf")
  g<-ggplot(fst, aes(x = Comparison, y = fst, color = location)) +
    #coord_flip() + # Sirve para invertir las cajas
    scale_color_manual(labels = c("Allopatric", "C Contact", "W Contact" ),
      values =c("black", "blue","red")) +
    labs(x = NULL, y = expression(F["ST"])) +
    theme_bw()+
    guides(color=guide_legend(""))+
    theme(
      #legend.position = "none",
      axis.title = element_text(size = 16),
      axis.text.x = element_text(size = 12),
      axis.text.y = element_text(size = 12)
      #panel.grid = element_blank()
    )
  
  g + geom_boxplot(color = "gray40", outlier.alpha = 0) +
    geom_jitter(size = 4, alpha = 0.40, width = 0.2)
  dev.off()
