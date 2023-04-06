#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J quast
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output Nf_quast.out

module purge
module load linuxbrew/colsa

cd $HOME/neonectria_minion/MAT1_polish_2

srun quast -o pilon_polished_quast -e -t 24 pilon_.fasta
