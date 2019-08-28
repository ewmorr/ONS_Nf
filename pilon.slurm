#!/bin/bash
#SBATCH --partition=shared
#SBATCH --ntasks=1
#SBATCH --job-name="pilon"
#SBATCH --output=pilon_illumina-polish.out 

module purge
module load linuxbrew/colsa

GENOME=$HOME/neonectria_minion/Nf_canu_run1/Nf.contigs.polished.fasta
FRAGS=Nf1-illumina.sorted.bam

DIR=$HOME/neonectria_minion/MAT1_polish
cd $DIR
srun pilon --genome $GENOME --frags $FRAG --outdir pilon_polishing

DIR=$HOME/neonectria_minion/MAT2_polish
srun pilon --genome $GENOME --frags $FRAGS --outdir pilon_polishing

