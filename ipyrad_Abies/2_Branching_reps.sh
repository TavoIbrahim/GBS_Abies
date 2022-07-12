#! /bin/sh

#SBATCH -p keri
#SBATCH --mem 10000
#SBATCH -n 4

#These command lines create 23 banches from params-Replicas_Abies.txt

# Create five branches to vary clust parameter
CLUST="070 075 080 085 090"

for i in $CLUST
do
ipyrad -p params-Replicas_Abies.txt -b clust_${i}_flinRel -f
done

# Then, create six branches to vary mindepth parameter
DEPTH="5 6 7 8 9 10"

for i in $DEPTH
do
ipyrad -p params-Replicas_Abies.txt -b mindepth_${i}_flinRel -f
done

# And finally, create nine branches to vary maxHs parameter
HS="2 3 4 5 6 7 8 9 10"

for i in $HS
do
ipyrad -p params-Replicas_Abies.txt -b maxHs_${i}_flinRel -f
done