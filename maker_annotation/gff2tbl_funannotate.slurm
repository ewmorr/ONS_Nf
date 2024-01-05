#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J gff2tbl
#SBATCH --ntasks=1
##SBATCH --cpus-per-task=24
#SBATCH --output gff2tbl.out
#SBATCH --exclude=node117,node118
#SBATCH --share

module purge
module load anaconda/colsa
conda activate funannotate_py

cd ~/Nf_annotate/
fastaFile=/mnt/home/garnas/ericm/neonectria_minion/MAT1_polish_2/pilon_.fasta

funannotate util gff2tbl -g maker2_run/makerFINAL.all.gff -f $fastaFile > maker2_run/makerFINAL.all.tbl
