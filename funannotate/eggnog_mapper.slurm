#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J funannotate
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output eggnog.out
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa

conda actviate eggnog-mapper-2.1.12

#dbEggnog=/mnt/lz01/hcgs/shared/databases/eggnog-mapper

cd NEED TO CHANGE AND ADD INPUT

srun emapper.py -i \
    --cpu 24 \
    -m diamond
