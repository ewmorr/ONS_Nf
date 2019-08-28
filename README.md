### Workflow for processing ***first run!*** of *Neonectria faginata* ONS reads from MinION.

MinION was run with no base-calling. Kit LSK-109; Flow cell MIN106.  
*All scripts run with slurm on UNH Premise*

#### Base-calling with albacore  
This takes a long time. ~24 h for 1,172,000 reads. 

	sbatch albacore.slurm

*Success rate of base calling from albacore was 82.05% (of reads).*

	grep "True" Nf1_basecalls_albacore/sequencing_summary.txt | wc -l
	grep "False" Nf1_basecalls_albacore/sequencing_summary.txt | wc -l

#### Assemble with canu.

	bash canu_Nf1.sh

This runs canu on the head node. Canu assembler then calls slurm all on its own (*neat*). If it is trying to suck up too many resources (and then waiting forever in the queue and/or being greedy) can limit available resources using 'gridOptions="<option>"' flag. For this assembly majority jobs ran on less than 8 CPUs and 40 G memory (45 Mb estimated genome size, 2.9 Gb high quality sequences; CPU req's are for single jobs – many multi-job arrays; cormhap required 44 job array; cor req 48 job array; obtovl 19 etc).

*Added stopOnQuality=F flag to call. This prevents termination at gatekeeper if there are many short reads (~50% reads were <1Kb).*

*Estimated coverage is 65.9x. May decrease correctedErrorRate to 0.134 from 0.144 (https://canu.readthedocs.io/en/latest/parameter-reference.html). This would increase assembly accuracy but decrease contiguity. May not be becessary with post-assembly nanopolish and or Illumina polishing.*


#### Polish assembly with nanopolish

	sbatch nanopolish.slurm

#### Quast assessment of contiguity

	sbatch quast_Nf.slurm

#### BUSCO assessment of completeness

busco needs config file copied to run dir and edited accordingly

	cp /mnt/lustre/software/linuxbrew/colsa/Cellar/busco/3.0.0/libexec/config/config.ini.default $HOME/Nf_canu_run0/config.ini
	
edit augustus paths if necessary

	sed -i 's/\/mnt\/lustre\/software\/linuxbrew\/colsa\/Cellar\/augustus\/3.2.2_2\/libexec\/scripts\//\/mnt\/lustre\/software\/linuxbrew\/colsa\/Cellar\/augustus\/3.3.2\/scripts\//g' config.ini

Run with one cpu `-c 1` unless legacy blast is available (i.e. blast 2.2.x). This is because busco throws an error with multiple threads using newer blast version.
other run options can be edited in the config.ini file or specified on the comand line (see .slurm script)

	sbatch busco_Nf.slurm

#### Genemark-es gene prediction
Genemark requires some perl modules that are not preinstalled on premise. Easiest work-around is a conda environment. See conda_envs.sh.

	sbatch genemark.slurm

genemark makes a bunch of generally named output files/dirs. To avoid hunting them down could run from a dir
Otherwise...

	mkdir Nf_canu_run0/gene_mark_output
	mv info/ Nf_canu_run0/gene_mark_output
	mv run Nf_canu_run0/gene_mark_output
	mv data Nf_canu_run0/gene_mark_output
	mv output Nf_canu_run0/gene_mark_output
	mv run.cfg Nf_canu_run0/gene_mark_output
	mv nuc_seq.fna Nf_canu_run0/gene_mark_output
	mv prot_seq.faa Nf_canu_run0/gene_mark_output

The files nuc_seq.fna and prot_seq.faa contain sequences of predicted proteins.

#### Compare predicted protein seqs to Swissprot reviewed fungal sequences

	sbatch blastp_swissprot_Nf.slurm


### SPAdes workflow for assembly of Illumina reads
### Illumina sequence data generated for Garnas N. faginata (MAT1; `Sample_GARNUS-NF` *on premise*) and Kasson lab N. faginata (MAT2; `Sample_SK113`) on 8/22/19

    cd neonectria_illumina

#### Read trimming and quality filtering

    sbatch trimmomatic.slurm
    sbatch bbduk.slurm

BBDuk is filtering out many more reads for GARNAS-NF than trimmomatic is

BBDuk GARNAS-NF output
```
Input:                          33620764 reads          8438811764 bases.
QTrimmed:                       943852 reads (2.81%)    17059690 bases (0.20%)
KTrimmed:                       30537026 reads (90.83%)         7307832980 bases (86.60%)
Trimmed by overlap:             170682 reads (0.51%)    949406 bases (0.01%)
Total Removed:                  28566136 reads (84.97%)         7325842076 bases (86.81%)
Result:                         5054628 reads (15.03%)  1112969688 bases (13.19%)
```
BBDuk SK113 output
```
Input:                          24944334 reads          6261027834 bases.
QTrimmed:                       4658746 reads (18.68%)  95430910 bases (1.52%)
KTrimmed:                       10335624 reads (41.43%)         944060646 bases (15.08%)
Trimmed by overlap:             778018 reads (3.12%)    4346586 bases (0.07%)
Total Removed:                  1396554 reads (5.60%)   1043838142 bases (16.67%)
Result:                         23547780 reads (94.40%)         5217189692 bases (83.33%)
```
trimmomatic GARNAS-NF output
```
Input Read Pairs: 16810382 Both Surviving: 14962475 (89.01%) Forward Only Surviving: 1693309 (10.07%) Reverse Only Surviving: 101990 (0.61%) Dropped: 52608 (0.31%)
```
trimmomatic SK113 output
```
Input Read Pairs: 12472167 Both Surviving: 7393782 (59.28%) Forward Only Surviving: 5013063 (40.19%) Reverse Only Surviving: 30455 (0.24%) Dropped: 34867 (0.28%)
```

trimmomatic outputs reads to fwd/rev only survinving category if there is adapter read-through found. This is because the pair of the read is assumed to be full reverse complement of the retained read. trimmomatic keeps ~99% of reads in both, wheraes bbduk is filtering out 85% of reads in GARNAS-NF sample. SK113 retains 95% of reads and 86% of bases on BBDuk. This could be (is likely?) becasue BBDuk is also performing phiX filtering. Proceeding with the BBDuk reads seems the best route.

#### SPAdes assembly and quast contiguity assessment

```
sbatch spades_quast.slurm
```
Contiguity is not as good as ONS assembly, but still looks good
N50 = 147594
L50 = 93
Total len (>500 bp scf) = 42.4 Mb
GC = 52.62%

#### BUSCO assembly completeness

```
sbatch illumina_only_spades_busco.slurm
```
better than ONS assembly (for GARNAS_Nf, but SK113 has similar quality), i.e., 98.4% complete single-copy USCOs in Illumina-only compared to 84% for ONS


