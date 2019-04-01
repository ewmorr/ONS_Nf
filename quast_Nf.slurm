#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J quast
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output Nf_quast.out

module purge
module load linuxbrew/colsa

cd $HOME/Nf_canu_run0

srun quast -o Nf_polished_quast -e -t 24 Nf.contigs.polished.fasta 
