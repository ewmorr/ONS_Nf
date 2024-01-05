module load anaconda/colsa
conda create --name funannotate_py --clone template
conda activate funannotate_py
#conda install "python>=3.6,<3.9" funannotate
conda install "python>=3.6,<3.9"
python -m pip install funannotate


funannotate check --show-versions

funannotate util gff2tbl
