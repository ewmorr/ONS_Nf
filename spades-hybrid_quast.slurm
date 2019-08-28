#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J spades
#SBATCH --output spades.out
#SBATCH --mem=512000
#SBATCH --ntasks=1

module purge
module load linuxbrew/colsa

DIR=~/neonectria_illumina/Sample_GARNUS-NF
cd $DIR

srun spades.py -1 bbtrimmed_raw_reads_R1.fastq.gz -2 bbtrimmed_raw_reads_R2.fastq.gz --nanopore ~/neonectria_minion/Nf1_reads.fastq \
	-o spades_hybrid_assmb -m 512 -t 24

cd spades_hybrid_assmb
srun quast -o quast_ctg_out -t 24 contigs.fasta
srun quast -o quast_scf_out -t 24 scaffolds.fasta

DIR=~/neonectria_illumina/Sample_SK113
cd $DIR

srun spades.py -1 bbtrimmed_raw_reads_R1.fastq.gz -2 bbtrimmed_raw_reads_R2.fastq.gz --nanopore ~/neonectria_minion/Nf1_reads.fastq \
	-o spades_hybrid_assmb -m 512 -t 24

cd spades_hybrid_assmb
srun quast -o quast_ctg_out -t 24 contigs.fasta
srun quast -o quast_scf_out -t 24 scaffolds.fasta

