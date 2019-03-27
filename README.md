### Workflow for processing ***first run!*** of *Neonectria faginata* ONS reads from MinION.

MinION was run with no base-calling. Kit LSK-109; Flow cell MIN106. 
*All scripts run with slurm on UNH Premise*

##### Base-calling with albacore
This takes a long time. ~24 h for 1,172,000 reads. 

	sbatch albacore.slurm

*Success rate of base calling from albacore was xx%.*

	grep "True" Nf1_basecalls_albacore/sequencing_summary.txt | wc -l
	grep "False" Nf1_basecalls_albacore/sequencing_summary.txt | wc -l

##### Assemble with canu.
This runs canu on the head node. Canu assembler then calls slurm all on its own. If it is trying to suck up too many resources (and then waiting forever in the queue and/or being greedy) can limit avaialble resources using 'gridOptions="<option>"' flag.

	bash canu_Nf1.sh
