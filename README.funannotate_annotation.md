
# Funannotate v.1.8.15 attempt
RepeatMasker run outside of funann pipe
```
sbatch repeatMasker.slurm
```
contig names shortened to remove `_pilon` bc funann errors with >16 characters
```
cd Nf_annotate/funannotate_run/RepeatMasker
sed 's/_pilon//g' ref.fasta.masked > ref.fasta.masked.clean
grep ">" ref.fasta.masked.clean
```
predict
```
sbatch ~/repo/ONS_Nf/funannotate/funannotate_predict.slurm
```
