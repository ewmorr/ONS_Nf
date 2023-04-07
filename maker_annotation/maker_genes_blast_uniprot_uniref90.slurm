#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J blast
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output blast.out
#SBATCH --exclude=node117,node118

module purge
module load linuxbrew/colsa

cd ~/neonectria_genome_reseq_10072020/maker2_run/

srun blastp -task blastp \
    -outfmt 6 \
    -num_threads 24 \
    -evalue 1e-25 \
    -max_target_seqs 10 \
    -query makerFINAL.all.maker.proteins.fasta \
    -db /mnt/oldhome/hcgs/shared/databases/uniref90/blast/uniref90.fasta \
    -out makerFINAL.all.maker.proteins.UNIPROT.uniref90.blast
