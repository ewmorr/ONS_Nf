#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J blastn
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output Nf_blastn.out

module purge
module load linuxbrew/colsa

srun blastn -task blastn -db ~/reference_genomes/FuOx_mt/FuOx_CM010346.fasta \
-query ~/Nf_ref_blast_db/ref.fasta \
-evalue 0.00001
-outfmt 6 -culling_limit 1 -num_threads 24 \
-out ~/neonectria_genome_reseq_10072020/FuOx_mt.blast
