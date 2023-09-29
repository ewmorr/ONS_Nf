#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J braker
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --output braker_test.out

module purge
module load anaconda/colsa
conda activate braker-3.0.3

cd ~/bin/gmes_linux_64_4
perl change_path_in_perl_scripts.pl /mnt/lustre/software/anaconda/colsa/envs/braker-3.0.3/bin/perl

cd ~/Nf_annotate/braker_test/
mkdir w_fungus
mkdir without_fungus

cd without_fungus
echo Starting without_fungus
srun braker.pl --threads=8 \
    --GENEMARK_PATH=/mnt/home/garnas/ericm/bin/gmes_linux_64_4 \
    --genome=/mnt/home/garnas/ericm/braker_test/genome.fa \
    --species=test2 \
    --prot_seq=/mnt/home/garnas/ericm/braker_test/proteins.fa

cd ~/Nf_annotate/braker_test/w_fungus

echo Starting w_fungus
srun braker.pl --fungus --threads=8 \
    --GENEMARK_PATH=/mnt/home/garnas/ericm/bin/gmes_linux_64_4 \
    --genome=/mnt/home/garnas/ericm/braker_test/genome.fa \
    --species=test2 \
    --prot_seq=/mnt/home/garnas/ericm/braker_test/proteins.fa

cd ~/bin/gmes_linux_64_4
perl change_path_in_perl_scripts.pl /usr/bin/perl

