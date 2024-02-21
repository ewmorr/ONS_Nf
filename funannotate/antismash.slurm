#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J antismash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output interproscan.out
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa

conda activate antismash-4.1.0

cd ~/Nf_annotate/funannotate_run/
mkdir output_antismash

gbkFile=/mnt/home/garnas/ewj4/Nf_annotate/funannotate_run/output_funann/predict_results/Neonectria_faginata.gbk

srun antismash --taxon fungi \
    --outputfolder output_antismash \
    $gbkFile
