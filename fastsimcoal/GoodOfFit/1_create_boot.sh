#!/bin/bash

#SBATCH -p cluster
#SBATCH -w nodo7
#SBATCH --mem 150000
#SBATCH -n 6

# This command line creates 100 simulated Multi-SFSs based on the most likely parameters for the best supported model
./fsc26 -i Hc12_IM_boot.par -n 100 -j -m -s 0 -x -I --multiSFS