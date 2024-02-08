
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


echo "export FUNANNOTATE_DB=/mnt/home/garnas/ewj4/funannotate_db" > /mnt/home/garnas/ewj4/.conda/envs/funannotate/etc/conda/activate.d/funannotate.sh
echo "export PATH=$PATH:/mnt/home/garnas/ewj4/bin/gmes_linux_64_4" >> /mnt/home/garnas/ewj4/.conda/envs/funannotate/etc/conda/activate.d/funannotate.sh
#echo 'change_path_in_perl_scripts.pl "/usr/bin/env perl"' >> /mnt/home/garnas/ewj4/.conda/envs/funannotate/etc/conda/activate.d/funannotate.sh
echo "unset FUNANNOTATE_DB" > /mnt/home/garnas/ewj4/.conda/envs/funannotate/etc/conda/deactivate.d/funannotate.sh
#echo 'change_path_in_perl_scripts.pl "/usr/bin/perl"' >> /mnt/home/garnas/ewj4/.conda/envs/funannotate/etc/conda/activate.d/funannotate.sh


# Still neeed to add trininty, augustus, and databses on local install

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
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                        
