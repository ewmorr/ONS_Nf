#!/bin/bash
#SBATCH --partition=shared
#SBATCH -J busco
#SBATCH --ntasks=1
##SBATCH --cpus-per-task=24 
#SBATCH --output buscos.out

module purge
module load linuxbrew/colsa

echo $BUSCO_CONFIG_FILE
cd $HOME/neonectria_illumina/Sample_GARNUS-NF/spades_assmb
cp ~/busco_config.ini ./config.ini

srun busco -i scaffolds.fasta -l $HOME/augustus_config/lineage/sordariomyceta_odb9 -m genome -o Nf_buscos -c 1 -f 

cd $HOME/neonectria_illumina/Sample_SK113/spades_assmb
cp ~/busco_config.ini ./config.ini

srun busco -i scaffolds.fasta -l $HOME/augustus_config/lineage/sordariomyceta_odb9 -m genome -o Nf_buscos -c 1 -f 


