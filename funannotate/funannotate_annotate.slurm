#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J funannotate
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --output funannotate_annotate.out
#SBATCH --exclude=node117,node118

module purge
module load anaconda/colsa
conda activate funannotate_new

cd ~/Nf_annotate/funannotate_run/

funannDir=/mnt/home/garnas/ewj4/Nf_annotate/funannotate_run/output_funann

eggnogPath=/mnt/home/garnas/ewj4/Nf_annotate/funannotate_run/output_eggnog_prot/Nf_.emapper.annotations
iprscanPath=/mnt/home/garnas/ewj4/Nf_annotate/funannotate_run/output_iprscan_prot/ipr_out.xml
antismashPath=/mnt/home/garnas/ewj4/Nf_annotate/funannotate_run/output_antismash/Neonectria_faginata.gbk

srun funannotate annotate -i $funannDir \
    -o $funannDir \
    --cpus 24 \
    --eggnog $eggnogPath \
    --iprscan $iprscanPath \
    --antismash $antismashPath \
    --sbt template.sbt
    
    
    

