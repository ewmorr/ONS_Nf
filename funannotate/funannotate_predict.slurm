#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J funannotate
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output funannotate_predict.out
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa
conda activate funannotate

gunzip ~/Nf_maker_reference_genome/*fasta.gz


cd ~/Nf_annotate/funannotate_run/


srun funannotate predict -i RepeatMasker/ref.fasta.masked.clean -s "Neonectria faginata" \
    -o output_funann_predict \
    --transcript_evidence $HOME/Nf_maker_reference_genome/Fusgr1_GeneCatalog_transcripts_20110524.nt.fasta \
    --protein_evidence $HOME/Nf_maker_reference_genome/Fusgr1_GeneCatalog_proteins_20110524.aa.fasta $FUNANNOTATE_DB/uniprot_sprot.fasta \
    --cpus 24
    
gzip ~/Nf_maker_reference_genome/*fasta
