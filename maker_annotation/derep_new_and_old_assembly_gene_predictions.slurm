#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name="vsearch"
#SBATCH --output=vsearch.out
#SBATCH --partition=shared

module purge
module load linuxbrew/colsa

cd

newseqs=Nf_annotate/maker2_run/makerFINAL.all.maker.transcripts.fasta
oldseqs=neonectria_genome_reseq_10072020/maker2_run/makerFINAL.all.maker.transcripts.fasta

srun vsearch --usearch_global $oldseqs \
    --db $newseqs \
    --id 0.85 \
    --uc Nf_annotate/new_old_transcript_matches.85.uc \
    --threads 24

srun vsearch --usearch_global $oldseqs \
    --db $newseqs \
    --id 0.90 \
    --uc Nf_annotate/new_old_transcript_matches.90.uc \
    --threads 24

srun vsearch --usearch_global $oldseqs \
    --db $newseqs \
    --id 0.93 \
    --uc Nf_annotate/new_old_transcript_matches.93.uc \
    --threads 24

srun vsearch --usearch_global $oldseqs \
    --db $newseqs \
    --id 0.95 \
    --uc Nf_annotate/new_old_transcript_matches.95.uc \
    --threads 24

srun vsearch --usearch_global $oldseqs \
    --db $newseqs \
    --id 0.97 \
    --uc Nf_annotate/new_old_transcript_matches.97.uc \
    --threads 24

srun vsearch --usearch_global $oldseqs \
    --db $newseqs \
    --id 1 \
    --uc Nf_annotate/new_old_transcript_matches.100.uc \
    --threads 24
