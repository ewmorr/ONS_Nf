#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name="trimmomatic"
#SBATCH --output=trimmmatic.out
#SBATCH --partition=shared

module purge
module load linuxbrew/colsa

DIR=~/neonectria_illumina/Sample_GARNUS-NF
cd $DIR

cat *R1* > raw_reads_R1.fastq.gz
cat *R2* > raw_reads_R2.fastq.gz
FORWARD=raw_reads_R1.fastq.gz
REVERSE=raw_reads_R2.fastq.gz

srun trimmomatic PE -threads 24 $FORWARD $REVERSE\
        paired_$FORWARD unpaired_$FORWARD\
        paired_$REVERSE unpaired_$REVERSE\
        ILLUMINACLIP:/mnt/lustre/software/linuxbrew/colsa/Cellar/trimmomatic/0.39/share/trimmomatic/adapters/TruSeq3-PE.fa:2:30:10\
        SLIDINGWINDOW:4:15 MINLEN:36

DIR=~/neonectria_illumina/Sample_SK113
cd $DIR

cat *R1* > raw_reads_R1.fastq.gz
cat *R2* > raw_reads_R2.fastq.gz
FORWARD=raw_reads_R1.fastq.gz
REVERSE=raw_reads_R2.fastq.gz

srun trimmomatic PE -threads 24 $FORWARD $REVERSE\
        paired_$FORWARD unpaired_$FORWARD\
        paired_$REVERSE unpaired_$REVERSE\
        ILLUMINACLIP:/mnt/lustre/software/linuxbrew/colsa/Cellar/trimmomatic/0.39/share/trimmomatic/adapters/TruSeq3-PE.fa:2:30:10\
        SLIDINGWINDOW:4:15 MINLEN:36


