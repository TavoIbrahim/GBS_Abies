# This function compute genetic diversity statistics using PopGenome

SS_PopGenome<-function(path_vcf, poblacion){
    require(PopGenome)
    # 1.- Read the genomic data
    GENOME.class <- readData(path_vcf, format="VCF", include.unknown=T)
    
    # 2.- Create a list. Each element corresponds to a population (ID= number)
    pop<-list()
    for(i in 1:length(levels(factor(poblacion[,2])))){
    	pop[[i]]<-as.vector((poblacion[poblacion[,2]==i,])[,1])}
    
    # 3.- Set pop names to the genomic class
    GENOME.class<- set.populations(GENOME.class, pop, diploid=TRUE)
    
    # 4.- Nucleotide diversity and Tajimas D
    GENOME.class <- neutrality.stats(GENOME.class, FAST=TRUE) 
    D<-(data.frame(t(GENOME.class@Tajima.D))) # Tajimas D
    names(D)<-"D"

    S<-data.frame(t(GENOME.class@n.segregating.sites)) #No of segregant sites
    names(S)<-"S"

    a<-as.numeric(GENOME.class@n.sites2) # Total number of sites
    
    ThetaW<-data.frame(t(GENOME.class@theta_Watterson)) # Watterson theta
    names(ThetaW)<-"W"
    for(i in 1:length(ThetaW$W)){
    	ThetaW$TW[i] <- ThetaW$W[i]/a}

    ThetaT<-data.frame(t(GENOME.class@theta_Tajima)) # Nucleotide diversity (Pi)
    names(ThetaT)<-"T"
    for(i in 1:length(ThetaT$T)){
    	ThetaT$TT[i] <- ThetaT$T[i]/a}

    # 5.- FST (Hudson et al., 1992) and pairwise FST
    GENOME.class <- F_ST.stats(GENOME.class, new.populations = pop, detail = TRUE, mode = "nucleotide")
    Fst<-data.frame(t(GENOME.class@nuc.F_ST.vs.all))
    names(Fst)<-"Fst"

    # Pairwise FST
    pairwFst<-GENOME.class@nuc.F_ST.pairwise
    pair<-as.vector(pairwFst) #Create a vector
    pairwiseFST <- matrix(data= NA, length(levels(factor(poblacion[,2]))), length(levels(factor(poblacion[,2])))) # create a empty matrix
    pairwiseFST[lower.tri(pairwiseFST, diag=F)] <- pair # Fill the matrix
    rownames(pairwiseFST)<-c(1:length(levels(factor(poblacion[,2]))))
    colnames(pairwiseFST)<-c(1:length(levels(factor(poblacion[,2]))))

    # Final results of genetic diversity
    PopGenomeRes<-cbind((1:length(levels(factor(poblacion[,2])))), D, S, Fst, ThetaW, ThetaT)
    colnames(PopGenomeRes)<-c("Pop", "D", "S", "Fst", "ThetaW", "W", "ThetaT", "Pi")
    #Results<-merge(diversidad, PopGenomeRes, by="Pop")
    # Create a list with genetic diversity and pairwise FST estimates
    Resulta2<-list(PopGenomeRes, pairwiseFST)
    return(Resulta2)
}