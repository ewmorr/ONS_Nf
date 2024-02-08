#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J repMask
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --output repeatMasker.out
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa
conda activate funannotate

cd ~/Nf_annotate/funannotate_run/


srun funannotate mask -i /mnt/home/garnas/ewj4/Nf_SPANDx_all_seqs/ref.fasta \
    -o ref.sofmask.fasta \
    -m repeatmasker -l RepeatMaskerLib/fngrep.ref --cpus 12
