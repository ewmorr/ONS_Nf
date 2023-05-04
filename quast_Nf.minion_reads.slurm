#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J quast
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output minion_reads_quast.out
#SBATCH --exclude=node117,node118

module purge
module load linuxbrew/colsa

cd $HOME/neonectria_minion/

srun quast -o minion_reads_quast -m 0 -e -t 24 Nf1_reads.fasta
