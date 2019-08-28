#!/bin/bash
#SBATCH --partition=shared
#SBATCH --ntasks=1
#SBATCH --job-name="pilon"
#SBATCH --output=pilon_illumina-polish.out 
##SBATCH --mem=512000

module purge
module load linuxbrew/colsa

PILON=~/pilon-1.23.jar
#use the jar downloaded from https://github.com/broadinstitute/pilon/releases
#otherwise memory is not easy to control
DIR=$HOME/neonectria_minion/MAT1_polish
cd $DIR
srun java -Xmx100G -jar $PILON --genome ~/neonectria_minion/Nf_canu_run1/Nf.contigs.polished.fasta --frags Nf1-illumina.sorted.bam --output pilon_

DIR=$HOME/neonectria_minion/MAT2_polish
cd $DIR
srun java -Xmx100G -jar $PILON --genome ~/neonectria_minion/Nf_canu_run1/Nf.contigs.polished.fasta --frags Nf1-illumina.sorted.bam --output pilon_

