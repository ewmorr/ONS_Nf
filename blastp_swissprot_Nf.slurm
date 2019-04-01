#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J blastp
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output Nf_blastp.out

module purge
module load linuxbrew/colsa

srun blastp -task blastp -query $HOME/Nf_canu_run0/gene_mark_output/prot_seq.faa \
-db $HOME/blast_dbs/swiss-prot_fungi/swiss-prot_fungi_reviewed.fasta \
-outfmt 6 -culling_limit 1 -num_threads 24 -evalue 1e-25 \
-out $HOME/Nf_canu_run0/genemark_prot-swissprot_fungi_reviewed.blastp
