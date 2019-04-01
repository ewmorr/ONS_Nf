#!/bin/bash

module purge
module load anaconda/colsa

#initial setup to add bioconda
#conda config --add channels defaults
#conda config --add channels conda-forge
#conda config --add channels bioconda

{
#genemark perl env
conda create --name genemark-perl perl perl-app-cpanminus
source activate genemark-perl
#if cpan needs configure at run proceed with auto-configuration
cpan YAML
cpan Hash::Merge
cpan Logger::Simple
cpan Parallel::ForkManager

#genemark tar ball should be moved to bin (in home) and unpacked
#then change path to perl to reflect env (from which)
which perl
cd bin/gm_et_linux_64/gmes_petap/
perl change_path_in_perl_scripts.pl ~/.conda/envs/genemark-perl/bin/perl

#finally the file gm_key_xx must be moved to $HOME/.gm_key
cd
mv gm_key_64 .gm_key
}
