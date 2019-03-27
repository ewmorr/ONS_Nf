#!/bin/bash

module purge
module load linuxbrew/colsa

#Add minReadLength to call if testing small set of seqs 'minReadLength=500 \'
#canu is failing on gatekeeper becasue too few reads with small set after filtering 4000 reads

canu \
-d $HOME/Nf_canu_run0 \
-p Nf \
-nanopore-raw $HOME/Nf1_basecalls_albacore/workspace/pass/*.fastq \
-genomesize=45m \
gnuplotTested=true \
gridOptions="--partition=shared" \
gridOptionsJobName=EWM \
gnuplot=/usr/bin/gnuplot
