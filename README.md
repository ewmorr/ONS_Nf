### Workflow for processing ***first run!*** of *Neonectria faginata* ONS reads from MinION.

Isolate MES1 34.1.1
MinION was run with no base-calling. Kit LSK-109; Flow cell MIN106.  
*All scripts run with slurm on UNH Premise*
Original minion output is in `~/minion` or `minion.tar.gz`
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

```
Assembly                    Nf.contigs.polished
# contigs (>= 0 bp)         25
# contigs (>= 1000 bp)      25
# contigs (>= 5000 bp)      24
# contigs (>= 10000 bp)     24
# contigs (>= 25000 bp)     21
# contigs (>= 50000 bp)     17
Total length (>= 0 bp)      42853006
Total length (>= 1000 bp)   42853006
Total length (>= 5000 bp)   42851999
Total length (>= 10000 bp)  42851999
Total length (>= 25000 bp)  42807002
Total length (>= 50000 bp)  42669650
# contigs                   25
Largest contig              5586860
Total length                42853006
GC (%)                      52.49
N50                         4406160
N75                         2665374
L50                         5
L75                         8
# N's per 100 kbp           0.00
```

#### BUSCO assessment of completeness

busco needs config file copied to run dir and edited accordingly

	cp /mnt/lustre/software/linuxbrew/colsa/Cellar/busco/3.0.0/libexec/config/config.ini.default $HOME/Nf_canu_run0/config.ini
	
edit augustus paths if necessary

	sed -i 's/\/mnt\/lustre\/software\/linuxbrew\/colsa\/Cellar\/augustus\/3.2.2_2\/libexec\/scripts\//\/mnt\/lustre\/software\/linuxbrew\/colsa\/Cellar\/augustus\/3.3.2\/scripts\//g' config.ini

Run with one cpu `-c 1` unless legacy blast is available (i.e. blast 2.2.x). This is because busco throws an error with multiple threads using newer blast version.
other run options can be edited in the config.ini file or specified on the comand line (see .slurm script)

	sbatch busco_Nf.slurm

output 
`C:84.1%[S:83.9%,D:0.2%],F:14.2%,M:1.7%,n:3725`

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

## ~
### SPAdes workflow for assembly of Illumina reads
#### Illumina sequence data generated for Garnas N. faginata (MAT1; `~/neonectria_illumina/Sample_GARNUS-NF` *on premise*) and Kasson lab N. faginata (MAT2; `~/neonectria_illumina/Sample_SK113`) on 8/22/19

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

trimmomatic outputs reads to fwd/rev only surviving category if there is adapter read-through found. This is because the pair of the retained read is assumed to be full reverse complement. trimmomatic keeps ~99% of reads in both samples (including paired and single-direction), whereas bbduk is filtering out 85% of reads in GARNAS-NF sample. SK113 retains 95% of reads and 86% of bases on BBDuk. The high read loss in GARNAS-NF sample could be (is likely) because BBDuk is also performing phiX filtering (i.e. the KTrimmed read loss). This interpretation could be checked by removing the phiX adapters AND filtering against only the phiX adapters in the ref file. However, proceeding with the BBDuk reads seems the best route.

#### SPAdes assembly and quast contiguity assessment

```
sbatch spades_quast.slurm
```
Contiguity is not as good as ONS assembly, but still looks good
* N50 = 147594
* L50 = 93
* Total len (>500 bp scf) = 42.4 Mb
* GC = 52.62%

#### BUSCO assembly completeness

```
sbatch illumina_only_spades_busco.slurm
```
better than ONS assembly (both GARNAS_Nf and SK113 have similar quality), i.e., 98.4% complete single-copy USCOs in Illumina-only compared to 84% for ONS

## ~
### SPAdes hybrid assembly workflow for assembly of Illumina + ONS minION reads

    cd neonectria_illumina

    sbatch ~/slurm_scripts/spades-hybrid_quast.slurm

GARNAS-NF quast report

```
Assembly                    scaffolds
# contigs (>= 0 bp)         2353
# contigs (>= 1000 bp)      315
# contigs (>= 5000 bp)      176
# contigs (>= 10000 bp)     155
# contigs (>= 25000 bp)     136
# contigs (>= 50000 bp)     113
Total length (>= 0 bp)      43184400
Total length (>= 1000 bp)   42311296
Total length (>= 5000 bp)   42007391
Total length (>= 10000 bp)  41866221
Total length (>= 25000 bp)  41560188
Total length (>= 50000 bp)  40770512
# contigs                   649
Largest contig              1815702
Total length                42527272
GC (%)                      52.59
N50                         542999
N75                         288455
L50                         24
L75                         51
# N's per 100 kbp           1.68
```

SK113 quast report (more Illumina reads in this assembly -- see above bbduk filtering)

```
Assembly                    scaffolds
# contigs (>= 0 bp)         908
# contigs (>= 1000 bp)      90
# contigs (>= 5000 bp)      65
# contigs (>= 10000 bp)     60
# contigs (>= 25000 bp)     54
# contigs (>= 50000 bp)     50
Total length (>= 0 bp)      42873853
Total length (>= 1000 bp)   42639265
Total length (>= 5000 bp)   42575565
Total length (>= 10000 bp)  42539168
Total length (>= 25000 bp)  42439610
Total length (>= 50000 bp)  42305117
# contigs                   143
Largest contig              3151093
Total length                42673294
GC (%)                      52.39
N50                         1141390
N75                         838162
L50                         12
L75                         23
# N's per 100 kbp           0.52
```

    sbatch ~/slurm_scripts/busco_hybrid_spades.slurm
    
GARNAS-NF BUSCOs: C:98.6%[S:98.5%,D:0.1%],F:0.6%,M:0.8%,n:3725
SK113 BUSCOs: C:98.7%[S:98.6%,D:0.1%],F:0.5%,M:0.8%,n:3725

## ~
### Polishing of canu assemblies with Illumina reads
#### Illumina polishing performed with pilon on assembly that was previously polished once with ONS long reads using nanopolish (above)

    cd neonectria_minion
    sbatch bwa-pilon_mapping.slurm
    sbatch pilon.slurm

    sbatch quast_NF.slurm
    #edited for appropriate paths

GARNAS-NF (MAT1)
```
Assembly                    pilon_
# contigs (>= 0 bp)         24
# contigs (>= 1000 bp)      24
# contigs (>= 5000 bp)      24
# contigs (>= 10000 bp)     24
# contigs (>= 25000 bp)     23
# contigs (>= 50000 bp)     18
Total length (>= 0 bp)      42948967
Total length (>= 1000 bp)   42948967
Total length (>= 5000 bp)   42948967
Total length (>= 10000 bp)  42948967
Total length (>= 25000 bp)  42935779
Total length (>= 50000 bp)  42749761
# contigs                   24
Largest contig              5591867
Total length                42948967
GC (%)                      52.47
N50                         4408047
N75                         2666201
L50                         5
L75                         8
# N's per 100 kbp           0.00
```
SK113 (MAT2)
```
Assembly                    pilon_
# contigs (>= 0 bp)         24
# contigs (>= 1000 bp)      24
# contigs (>= 5000 bp)      24
# contigs (>= 10000 bp)     24
# contigs (>= 25000 bp)     23
# contigs (>= 50000 bp)     18
Total length (>= 0 bp)      42882112
Total length (>= 1000 bp)   42882112
Total length (>= 5000 bp)   42882112
Total length (>= 10000 bp)  42882112
Total length (>= 25000 bp)  42868835
Total length (>= 50000 bp)  42682667
# contigs                   24
Largest contig              5588975
Total length                42882112
GC (%)                      52.47
N50                         4405164
N75                         2665129
L50                         5
L75                         8
# N's per 100 kbp           0.00
```
GARNAS-NF (MAT1) (BUSCOs)
```
C:98.2%[S:98.0%,D:0.2%],F:0.8%,M:1.0%,n:3725
```
SK113 (MAT2) (BUSCOs)
```
C:98.6%[S:98.4%,D:0.2%],F:0.6%,M:0.8%,n:3725
```

### QUast minion reads for genome report
```
cd neonectria_minion/

```
