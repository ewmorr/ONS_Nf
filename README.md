### Workflow for processing ***first run!*** of *Neonectria faginata* ONS reads from MinION.

MinION was run with no base-calling. Kit LSK-109; Flow cell MIN106.  
*All scripts run with slurm on UNH Premise*

#### Base-calling with albacore  
This takes a long time. ~24 h for 1,172,000 reads. 

	sbatch albacore.slurm

*Success rate of base calling from albacore was 82.05%.*

	grep "True" Nf1_basecalls_albacore/sequencing_summary.txt | wc -l
	grep "False" Nf1_basecalls_albacore/sequencing_summary.txt | wc -l

#### Assemble with canu.

	bash canu_Nf1.sh

This runs canu on the head node. Canu assembler then calls slurm all on its own (*neat*). If it is trying to suck up too many resources (and then waiting forever in the queue and/or being greedy) can limit avaialble resources using 'gridOptions="<option>"' flag. For this assembly majority jobs ran on less than 8 CPUs and 40 G memory (45 Mb estimated genome size, 2.9 Gb high quality sequences; CPU req's are for single jobs – many multi-job arrays; cormhap required 44 job array; cor req 48 job array; obtovl 19 etc).

*Added stopOnQuality=F flag to call. This prevents termination at gatekeeper if there are many short reads (~50% reads were <1Kb).*

*Estimated coverage is 65.9x. May decrease correctedErrorRate to 0.134 from 0.144 (https://canu.readthedocs.io/en/latest/parameter-reference.html). This would increase assembly accuracy but decrease contiguity. May not be becessary with post-assembly nanopolish and or Illumina polishing.*


#### Polish assembly with nanopolish

	sbatch nanopolish.slurm


#### Genemark-es gene prediction
Genemark requires some perl modules that are not preinstalledo on premise. Easiest work-around is a conda environment. See conda_envs.sh.

	sbatch genemark.slurm

###### genemark makes a bunch of generally named output files/dirs. To avoid hunting them down could run from a dir
Otherwise...

	mkdir Nf_canu_run0/gnene_mark_output
	mv info/ Nf_canu_run0/gnene_mark_output
	mv run Nf_canu_run0/gnene_mark_output
	mv data Nf_canu_run0/gnene_mark_output
	mv output Nf_canu_run0/gnene_mark_output
	mv run.cfg Nf_canu_run0/gnene_mark_output
	mv nuc_seq.fna Nf_canu_run0/gnene_mark_output
	mv prot_seq.faa Nf_canu_run0/gnene_mark_output

The files nuc_seq.fna and prot_seq.faa contain sequences of predicted proteins.
