#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name="genemark"
#SBATCH --output=genemark.out
#SBATCH --partition=shared

module purge
module load anaconda/colsa

#conda env must already be set up see conda_envs.sh
source activate genemark-perl

GMPATH=$HOME/bin/gm_et_linux_64/gmes_petap
#GENEMARK=$HOME/bin/gm_et_linux_64/gmes_petap/gmes_petap.pl

#for MAT2 pilon polished --mincontig 10k excludes no contig (default is 50k)
srun perl $GMPATH/gmes_petap.pl --ES --fungus --cores 24 -v \
--min_contig 10000 \
--sequence $HOME/neonectria_minion/MAT2_polish/pilon_.fasta

srun perl $GMPATH/get_sequence_from_GTF.pl genemark.gtf $HOME/neonectria_minion/MAT2_polish/pilon_.fasta
