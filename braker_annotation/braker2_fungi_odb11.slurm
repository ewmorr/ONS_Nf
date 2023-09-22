#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J braker
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --output braker.out

module purge
module load anaconda/colsa
conda activate braker-3.0.3

cd Nf_annotate/braker2_run/

gunzip ~/odb11_fungi.fa.gz

#braker.pl [OPTIONS] --genome=genome.fa \
#    --species=speciesname \
#    --prot_seq=proteins.fa

srun braker.pl --fungus --threads=8 \
    --GENEMARK_PATH=/mnt/home/garnas/ericm/bin/gm_et_linux_64/gmes_petap \
    --genome=/mnt/home/garnas/ericm/neonectria_minion/MAT1_polish_2/pilon_.fasta \
    --species=Neonectria_faginata \
    --prot_seq=/mnt/home/garnas/ericm/odb11_fungi.fa

gzip ~/odb11_fungi.fa
