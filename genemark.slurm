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

#for Nf_canu_run0 --mincontig 10k excludes one contig (default is 50k)
srun perl $GMPATH/gmes_petap.pl --ES --fungus --cores 24 -v \
--min_contig 10000 \
--sequence $HOME/Nf_canu_run0/Nf.contigs.polished.fasta

srun perl $GMPATH/get_sequence_from_GTF.pl genemark.gtf $HOME/Nf_canu_run0/Nf.contigs.polished.fasta
