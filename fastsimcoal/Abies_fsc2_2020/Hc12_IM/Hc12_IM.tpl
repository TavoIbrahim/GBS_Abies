//Parameters for the coalescence simulation program : fastsimcoal.exe: H12
7 samples to simulate :
//Population effective sizes (number of genes)
JAL
FLIN
COL
AZUF
MEZ
REL
PER
//Samples sizes and samples age 
6 0 0.60
6 0 0.60
6 0 0.50
6
8
8
6
//Growth rates : negative growth implies population expansion
0
0
0
0
0
0
0
//Number of migration matrices : 0 implies no migration between demes
3
//Migration matrix 0: Flujo génico facilitado por Glaciaciones
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
//Migration matrix 1: IM Ajaliscana-Aflinckii
0 MJF$ 0 0 0 0 0
MFJ$ 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
//Migration matrix 2: IM AncArel-Aflinckii
0 0 0 0 0 0 0
0 0 0 MFA$ 0 0 0
0 0 0 0 0 0 0
0 MAF$ 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
0 0 0 0 0 0 0
//historical event: time, source, sink, migrants, new deme size, new growth rate, migration matrix index
9 historical event
TEXP$ 6 5 1 1 0 1   //Colonización de Perote-Orizaba
TEXP$ 4 5 ADM 1 0 1  //Contacto secundario entre Arel y AncArel
TEXP$ 4 3 1 1 0 1   //Contacto secundario entre Arel y AncArel
TEXP$ 3 3 0 $RES_AZ 0 1 //Expansión demográfica de AncArel
TEXP$ 5 5 0 $RES_RE 0 1 //Expansión demográfica de Arel
TEXP$ 2 3 1 1 0 1 //Colonizacion de N de Colima
TBU$ 5 3 1 1 0 2 //Divergencia de Arel por colonización
TMU$ 0 1 1 $RES_FJ 0 2 //Divergencia de Ajaliscana por fragmentación
TTEC$ 1 3 1 $RES_AB 0 0 //Divergencia de Areligiosa por fragmentación
//Number of independent loci [chromosome]
1 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per gen recomb and mut rates
FREQ 1 0 2e-8

