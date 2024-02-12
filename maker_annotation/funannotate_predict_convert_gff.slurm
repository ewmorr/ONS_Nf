#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J funannotate
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output funannotate_gff_conv.out
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa
conda activate funannotate

cd ~/Nf_annotate/

#sed -n '/##FASTA/q;p' makerFINAL.all.gff > makerFINAL.all.noFasta.gff

srun funannotate predict -i funannotate_run/RepeatMasker/ref.fasta.masked.clean -s "Neonectria faginata" \
    -o maker2_run/funann_conv \
    --maker_gff maker2_run/makerFINAL.all.noFasta.gff.clean \
    --cpus 24
    
