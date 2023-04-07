#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J blast
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output blast_reviewed.out
#SBATCH --exclude=node117,node118

module purge
module load linuxbrew/colsa

cd ~/neonectria_genome_reseq_10072020/maker2_run/

srun blastp -task blastp \
    -outfmt 6 \
    -num_threads 24 \
    -evalue 0.001 \
    -max_target_seqs 10 \
    -query makerFINAL.all.maker.proteins.fasta \
    -db ~/blast_dbs/uniprot-fungi_reviewed_07252022/uniprot-fungi_reviewed_07252022.fasta \
    -out makerFINAL.all.maker.proteins.UNIPROT.e10-3.blast
