#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name="fcs-adaptor"
#SBATCH --output=fcs-adaptor.out
#SBATCH --partition=shared

module purge
module load anaconda/colsa singularity-ce/singularity-ce-3.11.4
conda activate fcs-adaptor-0.4.0

srun run_fcsadaptor.sh --fasta-input ~/Nf_SPANDx_all_seqs/ref.fasta --output-dir Nf_fcs-adaptor_out/ --euk
