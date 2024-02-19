
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
Also trying conversion of gff from maker. Need to rm fasta from gff and convert tig names to match genome file
```
cd Nf_annotate/maker2_run
sed -n '/##FASTA/q;p' makerFINAL.all.gff > makerFINAL.all.noFasta.gff
sed 's/_pilon//g' makerFINAL.all.noFasta.gff > makerFINAL.all.noFasta.gff.clean
```
This only outputs 486 gene models.

Original maker BUSCO transcript scores
C:97.1%[S:96.7%,D:0.4%],F:2.4%,M:0.5%,n:3725 

Funannotate transcript scores
C:96.7%[S:96.5%,D:0.2%],F:2.5%,M:0.8%,n:3725 
