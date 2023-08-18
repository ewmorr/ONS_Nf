#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name="fcs-gx"
#SBATCH --output=fcs-gx.out
#SBATCH --partition=shared
#SBATCH --mem=512000

module purge
module load anaconda/colsa singularity-ce/singularity-ce-3.11.4
conda activate fcs-gx-0.4.0

fcs.py screen genome --fasta ~/Nf_SPANDx_all_seqs/ref.fasta --out-dir Nf_fcs-gx_out/ --tax-id 992199
