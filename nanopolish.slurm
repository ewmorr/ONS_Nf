#!/bin/bash
#SBATCH --partition=shared
#SBATCH --ntasks=1
#SBATCH --job-name="nanopolish"
#SBATCH --output=nanopolish.out 
#SBATCH --exclude=node117,node118
#These nodes were giving trouble with nanopolish but it may have been a parallelization problem

module purge
module load linuxbrew/colsa

#fastq to fasta
cat  Nf1_basecalls_albacore/workspace/pass/*.fastq > Nf1_reads.fastq
paste - - - - < Nf1_reads.fastq | cut -f 1,2 | sed 's/^@/>/' | tr "\t" "\n" > Nf1_reads.fasta

echo "indexing..."
srun nanopolish index -s Nf1_basecalls_albacore/sequencing_summary.txt -d $HOME/Nf1_single_fast5 $HOME/Nf1_reads.fasta

echo "mapping to assembly..."

srun minimap2 -ax map-ont -t 24 $HOME/Nf_canu_run0/Nf.contigs.fasta Nf1_reads.fasta | samtools sort -o Nf1_reads.sorted.bam -T Nf1_reads.tmp
srun samtools index Nf1_reads.sorted.bam

echo "polishing segments..."
#nanopolish seg faults if try more than 1 thread, so use one CPU per process

python $HOME/bin/nanopolish_makerange.py $HOME/Nf_canu_run0/Nf.contigs.fasta | parallel --results $HOME/Nf_canu_run0/nanopolish_results.out -P 24 \
nanopolish variants --consensus -o $HOME/Nf_canu_run0/polished.{1}.vcf -w {1} \
-r $HOME/Nf1_reads.fasta -b Nf1_reads.sorted.bam -g $HOME/Nf_canu_run0/Nf.contigs.fasta \
--min-candidate-frequency 0.1

#echo "merging segments..."
srun nanopolish vcf2fasta -g $HOME/Nf_canu_run0/Nf.contigs.fasta $HOME/Nf_canu_run0/polished.*.vcf > $HOME/Nf_canu_run0/Nf.contigs.polished.fasta
