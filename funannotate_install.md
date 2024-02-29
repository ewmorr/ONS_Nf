### funannotate version on premise is installed with vanilla mamba install
```
conda create --name funannotate --clone template
conda activate funannotate
mamba install funannotate
#need to manual install gsl bc doesn't pick it up
conda install -c conda-forge gsl
#test the install
funannotate check --show-versions
```
The released version `funannotate predcit` faults on use of GC() from BioPython https://github.com/nextgenusfs/funannotate/issues/1000. changed to use `100*gc_fraction()` in `.conda/envs/funannotate/pkgs/funannotate-1.8.15-pyhdfd78af_2/site-packages/funannotate/library.py`
The released version `funannotate annotate` faults with 
```
-------------------------------------------------------
Traceback (most recent call last):
  File "/mnt/home/garnas/ewj4/.conda/envs/funannotate/bin/funannotate", line 10, in <module>
    sys.exit(main())
  File "/mnt/home/garnas/ewj4/.conda/envs/funannotate/lib/python3.8/site-packages/funannotate/funannotate.py", line 716, in main
    mod.main(arguments)
  File "/mnt/home/garnas/ewj4/.conda/envs/funannotate/lib/python3.8/site-packages/funannotate/annotate.py", line 807, in main
    GeneCounts = lib.gb2nucleotides(
  File "/mnt/home/garnas/ewj4/.conda/envs/funannotate/lib/python3.8/site-packages/funannotate/library.py", line 3967, in gb2nucleotides
    gb_feature_add2dict(f, record, genes)
  File "/mnt/home/garnas/ewj4/.conda/envs/funannotate/lib/python3.8/site-packages/funannotate/library.py", line 4133, in gb_feature_add2dict
    start = f.location.nofuzzy_start + 1
AttributeError: 'SimpleLocation' object has no attribute 'nofuzzy_start'
```
This appears to be related to [here](https://github.com/biopython/biopython/issues/2616) and check [here](https://stackoverflow.com/questions/73314517/how-to-use-update-a-modified-conda-package-offline) for fix. BUT there have been changes to Seqrecord that should handle this as an exception. We will modify funannotate library to catch this and print the problematic record name then exit

```
python  -c "import platform; print(platform.platform())"

https://stackoverflow.com/questions/76105751/why-does-the-python-installed-by-condas-defaults-report-the-wrong-mac-platform
cat /System/Library/CoreServices/SystemVersion.plist | grep string
SYSTEM_VERSION_COMPAT=1 

https://stackoverflow.com/questions/65290242/pythons-platform-mac-ver-reports-incorrect-macos-version

SYSTEM_VERSION_COMPAT=1 cat /System/Library/CoreServices/SystemVersion.plist | grep string
SYSTEM_VERSION_COMPAT=0 cat /System/Library/CoreServices/SystemVersion.plist | grep string

conda info
SYSTEM_VERSION_COMPAT=0 conda info
SYSTEM_VERSION_COMPAT=1 conda info

SYSTEM_VERSION_COMPAT=0 conda create -n funannotate "python>=3.6,<3.9" funannotate


echo "export FUNANNOTATE_DB=/mnt/home/garnas/ewj4/funannotate_new_db" > /mnt/home/garnas/ewj4/.conda/envs/funannotate_new/etc/conda/activate.d/funannotate.sh
echo "export PATH=$PATH:/mnt/home/garnas/ewj4/bin/gmes_linux_64_4" >> /mnt/home/garnas/ewj4/.conda/envs/funannotate_new/etc/conda/activate.d/funannotate.sh
#echo 'change_path_in_perl_scripts.pl "/usr/bin/env perl"' >> /mnt/home/garnas/ewj4/.conda/envs/funannotate/etc/conda/activate.d/funannotate.sh
echo "unset FUNANNOTATE_DB" > /mnt/home/garnas/ewj4/.conda/envs/funannotate_new/etc/conda/deactivate.d/funannotate.sh
#echo 'change_path_in_perl_scripts.pl "/usr/bin/perl"' >> /mnt/home/garnas/ewj4/.conda/envs/funannotate/etc/conda/activate.d/funannotate.sh


# Still need to add trininty, augustus, and databses on local install

```                                                             
All Users:                                                                                                                                                               
  You will need to setup the funannotate databases using funannotate setup.                                                                                              
  The location of these databases on the file system is your decision and the                                                                                            
  location can be defined using the FUNANNOTATE_DB environmental variable.                                                                                               
                                                                                                                                                                         
  To set this up in your conda environment you can run the following:                                                                                                    
    echo "export FUNANNOTATE_DB=/your/path" > /Users/ericmorrison/miniconda3/envs/funannotate/etc/conda/activate.d/funannotate.sh                                        
    echo "unset FUNANNOTATE_DB" > /Users/ericmorrison/miniconda3/envs/funannotate/etc/conda/deactivate.d/funannotate.sh                                                  
                                                                                                                                                                         
  You can then run your database setup using funannotate:                                                                                                                
    funannotate setup -i all                                                                                                                                             
                                                                                                                                                                         
  Due to licensing restrictions, if you want to use GeneMark-ES/ET, you will need to install manually:                                                                   
  download and follow directions at http://topaz.gatech.edu/GeneMark/license_download.cgi                                                                                
  ** note you will likely need to change shebang line for all perl scripts:                                                                                              
    change: #!/usr/bin/perl to #!/usr/bin/env perl                                                                                                                       
                                                                                                                                                                         
                                                                                                                                                                         
Mac OSX Users:                                                                                                                                                           
  Augustus and Trinity cannot be properly installed via conda/bioconda at this time. However,                                                                            
  they are able to be installed manually using a local copy of GCC (gcc-8 in example below).                                                                             
                                                                                                                                                                         
  Install augustus using this repo:                                                                                                                                      
    https://github.com/nextgenusfs/augustus                                                                                                                              
                                                                                                                                                                         
  To install Trinity v2.8.6, download the source code and compile using GCC/G++:                                                                                         
    wget https://github.com/trinityrnaseq/trinityrnaseq/releases/download/v2.8.6/trinityrnaseq-v2.8.6.FULL.tar.gz                                                        
    tar xzvf trinityrnaseq-v2.8.6.FULL.tar.gz                                                                                                                            
    cd trinityrnaseq-v2.8.6                                                                                                                                              
    make CC=gcc-8 CXX=g++-8                                                                                                                                              
    echo "export TRINITY_HOME=/your/path" > /Users/ericmorrison/miniconda3/envs/funannotate/etc/conda/activate.d/trinity.sh                                              
    echo "unset TRINITY_HOME" > /Users/ericmorrison/miniconda3/envs/funannotate/etc/conda/deactivate.d/trinity.sh                                                        
                                                                                                                                                                         
```                                                                            
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                        
