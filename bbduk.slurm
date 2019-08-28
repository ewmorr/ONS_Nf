#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name="bbduk"
#SBATCH --output=bbduk_2.out
#SBATCH --partition=shared

module purge
module load anaconda/colsa
conda activate qiime2-2019.4


FORWARD=raw_reads_R1.fastq.gz
REVERSE=raw_reads_R2.fastq.gz
ADAPTERS=/mnt/lustre/software/anaconda/colsa/envs/qiime2-2019.4/opt/bbmap-38.57-0/resources/adapters.fa

DIR=~/neonectria_illumina/Sample_GARNUS-NF
cd $DIR

srun bbduk.sh in=$FORWARD in2=$REVERSE \
	out=bbtrimmed_$FORWARD out2=bbtrimmed_$REVERSE \
	-ref=$ADAPTERS ktrim=r k=23 mink=11 hdist=1 tpe tbo \
	qtrim=r trimq=10 -minlength=36

#DIR=~/neonectria_illumina/Sample_SK113
#cd $DIR

#srun bbduk.sh in=$FORWARD in2=$REVERSE \
#	out=bbtrimmed_$FORWARD out2=bbtrimmed_$REVERSE \
#	-ref=$ADAPTERS ktrim=r k=23 mink=11 hdist=1 tpe tbo \
#	qtrim=r trimq=10 -minlength=36

