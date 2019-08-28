#!/bin/bash
#SBATCH --partition=shared
#SBATCH --ntasks=1
#SBATCH --job-name="bwa"
#SBATCH --output=bwa_illumina-polish.out 

module purge
module load linuxbrew/colsa

#fastq to fasta
#paste - - - - < Nf1_reads.fastq | cut -f 1,2 | sed 's/^@/>/' | tr "\t" "\n" > NF1_reads.fasta

echo "indexing..."
srun bwa index $HOME/neonectria_minion/Nf_canu_run1/Nf.contigs.polished.fasta

echo "mapping to assembly..."

cd $HOME/neonectria_minion
mkdir MAT1_polish
DIR=$HOME/neonectria_minion/MAT1_polish
srun bwa mem -t 24 \
	$HOME/neonectria_minion/Nf_canu_run1/Nf.contigs.polished.fasta \
	$HOME/neonectria_illumina/Sample_GARNUS-NF/raw_reads_R1.fastq.gz \
	$HOME/neonectria_illumina/Sample_GARNUS-NF/raw_reads_R2.fastq.gz |
	samtools sort -@ 24 -o $DIR/Nf1-illumina.sorted.bam
srun samtools index $DIR/Nf1-illumina.sorted.bam

mkdir MAT2_polish
DIR=$HOME/neonectria_minion/MAT2_polish
srun bwa mem -t 24 \
	$HOME/neonectria_minion/Nf_canu_run1/Nf.contigs.polished.fasta \
	$HOME/neonectria_illumina/Sample_SK113/raw_reads_R1.fastq.gz \
	$HOME/neonectria_illumina/Sample_SK113/raw_reads_R2.fastq.gz |
	samtools sort -@ 24 -o $DIR/Nf1-illumina.sorted.bam
srun samtools index $DIR/Nf1-illumina.sorted.bam

