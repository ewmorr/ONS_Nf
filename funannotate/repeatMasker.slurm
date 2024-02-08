#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J repMask
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --output repeatMasker.out
#SBATCH --exclude=node117,node118

module purge
module load linuxbrew/colsa

cd ~/Nf_annotate/funannotate_run/


srun RepeatMasker -dir . -species fungi -xsmall -pa 12 -lib RepeatMaskerLib/fngrep.ref $HOME/Nf_SPANDx_all_seqs/ref.fasta
