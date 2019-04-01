#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J busco
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24 
#SBATCH --output Nf_buscos.out

module purge
module load linuxbrew/colsa

cd $HOME/Nf_canu_run0
#The lineage is copied from augustus config (or downloaded from website) so that augustus can write to this dir. Write-access to config dir was required when running with --long option with older version but may not be needed with newer version of BUSCO. Have not tested, this solution works either way.

srun busco -i Nf.contigs.polished.fasta -l $HOME/augustus_config/lineage/sordariomyceta_odb9 -m genome -o Nf_buscos -c 1 -f 
