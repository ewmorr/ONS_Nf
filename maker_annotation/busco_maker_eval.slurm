#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J busco
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output busco.out
#SBATCH --exclude=node117,node118

module purge
module load linuxbrew/colsa

cd ~/Nf_annotate/maker2_run/


srun busco -i makerFINAL.transcripts.aed-1.0.fasta -l $HOME/augustus_config/lineage/sordariomyceta_odb9 -m tran -o busco_transcript_eval -f -c 24
