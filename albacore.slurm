#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --job-name="albacore"
#SBATCH --output=albacore.out
#SBATCH --partition=shared

module purge
module load linuxbrew/colsa

#Albacore does not handle multiple reads per fast5 so these need to be split.
echo "Splitting multi to single fast5"
srun multi_to_single_fast5 \
-i $HOME/minion/Nf_run1/Nf1/20190314_1659_MN24658_FAK20391_a29b81f5/fast5/ \
-s $HOME/Nf1_single_fast5

echo "basecalling..."
srun read_fast5_basecaller.py \
--input $HOME/Nf1_single_fast5 \
--worker_threads 24 \
--recursive \
--save_path $HOME/Nf1_basecalls_albacore \
--flowcell FLO-MIN106 \
--kit SQK-LSK109
#--debug

