#!/bin/bash

module purge
module load linuxbrew/colsa

#stopOnReadQuality=F flag prevents from terminating when filtering reads <1000; this is fine with high coverage

canu \
-d $HOME/Nf_canu_run0 \
-p Nf \
-nanopore-raw $HOME/Nf1_basecalls_albacore/workspace/pass/*.fastq \
-genomesize=45m \
stopOnReadQuality=F \
gnuplotTested=true \
gridOptions="--partition=shared" \
gridOptionsJobName=EWM \
gnuplot=/usr/bin/gnuplot
