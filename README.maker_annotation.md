
## AUGUSTUS via BUSCO
### Generate BUSCO gene models using `busco --long`
Using the reference sequence at `SPANDx_Nf/ref.fasta`
```
cd
cp neonectria_minion/Nf_canu_run0/config.ini SPANDx_Nf/
cd neonectria_genome_reseq_10072020/
sbatch ~/repo/neonectria_genome_reseq_10072020/premise/busco_long_Nf.slurm
```
augustus parameters are  written to `$HOME/augustus_config/config/species/BUSCO_Nf_buscos_long_2292717447`

## GeneMark-ES
### genemark run (The genemark model generated below is used in the final run of maker)
### NOTE The GeneMark-ES liscense must be refreshed every 400 days. See ~/repo/ONS_Nf/conda_envs.sh or search for genemark-es on the web for download
```
cd
sbatch repo/ONS_Nf/genemark.pilon_polished.slurm

mkdir Nf_annotate/genemark_run
mv prot_seq.faa Nf_annotate/genemark_run
mv nuc_seq.fna Nf_annotate/genemark_run
mv genemark.gtf Nf_annotate/genemark_run
mv run/ Nf_annotate/genemark_run
mv data/ Nf_annotate/genemark_run
mv output/ Nf_annotate/genemark_run
```

## SNAP 
### Maker v3 throws an error at annotating transcripts step where some contigs fail. Trying maker v2. 
```
mkdir ~/Nf_annotate/maker2_run/
cd ~/Nf_annotate/
sbatch ~/repo/ONS_Nf/maker_annotation/maker2_snap_train_Nf.slurm
```

## Maker run with gene models from AUGUSTUS SNAP GeneMark
```
sbatch ~/repo/neonectria_genome_reseq_10072020/maker_annotation/maker2_final_run_Nf.slurm
sbatch ~/repo/neonectria_genome_reseq_10072020/maker_annotation/busco_maker_eval.slurm
```
Or instead of SNAP train and final run with dif models in final step, just run all at once (make sure it works before jumping here)
```
cd Nf_annotate/
sbatch ~/repo/ONS_Nf/maker_annotation/maker2_snap_train_plus_final_Nf.slurm
```

#### maker2 run was successful and is located at `neonectria_genome_reseq_10072020/maker2_run/` 
```
grep ">" makerFINAL.all.maker.transcripts.fasta | wc -l
#14064
grep ">" makerFINAL.transcripts.aed-1.0.fasta | wc -l
#9303
```

Results of BUSCO search of transcripts (running both AED<1.0 and all transcripts)
```
cd ~/Nf_annotate/
sbatch ~/repo/ONS_Nf/maker_annotation/busco_maker_eval.slurm 
sbatch ~/repo/ONS_Nf/maker_annotation/busco_maker_eval_all.slurm  
```

```
#AED<1.0
# Summarized benchmarking in BUSCO notation for file makerFINAL.transcripts.aed-1.0.fasta
# BUSCO was run in mode: transcriptome

        C:95.5%[S:95.2%,D:0.3%],F:3.0%,M:1.5%,n:3725

        3555    Complete BUSCOs (C)
        3545    Complete and single-copy BUSCOs (S)
        10      Complete and duplicated BUSCOs (D)
        113     Fragmented BUSCOs (F)
        57      Missing BUSCOs (M)
        3725    Total BUSCO groups searched
#all transcripts
# Summarized benchmarking in BUSCO notation for file makerFINAL.all.maker.transcripts.fasta
# BUSCO was run in mode: transcriptome

        C:96.2%[S:95.8%,D:0.4%],F:3.2%,M:0.6%,n:3725

        3582    Complete BUSCOs (C)
        3568    Complete and single-copy BUSCOs (S)
        14      Complete and duplicated BUSCOs (D)
        119     Fragmented BUSCOs (F)
        24      Missing BUSCOs (M)
        3725    Total BUSCO groups searched

```

### The first run was performed with Fusarium graminearum proteins only. We also ran a second time with Uniprot reviewed fungal proteins downloaded 07252022
### Retraining SNAP with UniProt fungi reviewed proteins and rerunning maker with AUGUSTUS, GeneMark and new SNAP

Count numbers of AED filter and total
```
grep ">" makerFINAL.all.maker.proteins.fasta | wc -l
#14740
grep ">" makerFINAL.transcripts.aed-1.0.fasta | wc -l
#4002
```
#### Tuan D has said that AED filter doesn't make sense if there is no RNA evidence from Nf (we provided alt organism assembled mRNA, i.e., F. graminearum)

BUSCO results of all genes
```
# BUSCO version is: 3.0.0 
# The lineage dataset is: sordariomyceta_odb9 (Creation date: 2016-02-13, number of species: 30, number of BUSCOs: 3725)
# To reproduce this run: python /mnt/lustre/software/linuxbrew/colsa/bin/busco -i makerFINAL.all.maker.transcripts.fasta -o busco_transcript_eval_all -l /mnt/home/garnas/ericm/augustus_config/lineage/sordariomyceta_odb9/ -m transcriptome -c 24
#
# Summarized benchmarking in BUSCO notation for file makerFINAL.all.maker.transcripts.fasta
# BUSCO was run in mode: transcriptome

        C:84.2%[S:83.8%,D:0.4%],F:12.4%,M:3.4%,n:3725

        3136    Complete BUSCOs (C)
        3121    Complete and single-copy BUSCOs (S)
        15      Complete and duplicated BUSCOs (D)
        463     Fragmented BUSCOs (F)
        126     Missing BUSCOs (M)
        3725    Total BUSCO groups searched
```
BUSCO results of AED<1.0
```
# BUSCO version is: 3.0.0 
# The lineage dataset is: sordariomyceta_odb9 (Creation date: 2016-02-13, number of species: 30, number of BUSCOs: 3725)
# To reproduce this run: python /mnt/lustre/software/linuxbrew/colsa/bin/busco -i makerFINAL.transcripts.aed-1.0.fasta -o busco_transcript_eval -l /mnt/home/garnas/ericm/augustus_config/lineage/sordariomyceta_odb9/ -m transcriptome -c 24
#
# Summarized benchmarking in BUSCO notation for file makerFINAL.transcripts.aed-1.0.fasta
# BUSCO was run in mode: transcriptome

        C:49.8%[S:49.6%,D:0.2%],F:3.2%,M:47.0%,n:3725

        1854    Complete BUSCOs (C)
        1848    Complete and single-copy BUSCOs (S)
        6       Complete and duplicated BUSCOs (D)
        118     Fragmented BUSCOs (F)
        1753    Missing BUSCOs (M)
        3725    Total BUSCO groups searched
```
The run with only F. graminearum was significantly better based on BUSCO results

## Annotate protein seqs against Uniprot
Uniporot taxonomic divisions https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/
Format blast db of reviewed (i.e., UniprotKB-Swissprot) nonredundant fungal proteins downloaded from Uniprot
```
module load linuxbrew/colsa
cd ~/blast_dbs
formatdb -i uniprot-fungi_reviewed_07252022.fasta -p T -o T 
mkdir uniprot-fungi_reviewed_07252022
mv uniprot-fungi_reviewed_07252022.fasta.* uniprot-fungi_reviewed_07252022
```
run blast
```
cd ~/neonectria_genome_reseq_10072020/
sbatch ~/repo/neonectria_genome_reseq_10072020/maker_annotation/maker_genes_blast_uniprot.slurm 
```
Number of annotations
```
cut -f1 makerFINAL.all.maker.proteins.UNIPROT.blast | sort | uniq | wc -l
```
5688. e value of e-25 is pretty stringent. Try lowering to 0.001
```
cd ~/neonectria_genome_reseq_10072020/
sbatch ~/repo/neonectria_genome_reseq_10072020/maker_annotation/maker_genes_blast_uniprot.slurm 
cd maker2_run
cut -f1 makerFINAL.all.maker.proteins.UNIPROT.e10-3.blast | sort | uniq | wc -l
```
8297
#### Try with both Uniprot-SwissProt and UniprotKBTrEMBL (machine annotations) at https://www.uniprot.org/uniprotkb?query=(taxonomy_id:4751)
```
curl -H "Accept: text/plain; format=list" "https://rest.uniprot.org/uniprotkb/search?query=reviewed:false+AND+taxonomy_id:4751" > uniprotKB.swissprot.trembl.fungi.list.txt
```
The above is only returning 25 records due to pagination, and can not get the curl command to abide. Instead parsing the sequences from the .dat files provided at https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/
```
curl https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/uniprot_trembl_fungi.dat.gz --output uniprot_trembl_fungi.dat.gz
curl https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/uniprot_sprot_fungi.dat.gz --output uniprot_sprot_fungi.dat.gz
gunzip -c uniprot_sprot_fungi.dat.gz | grep "//" | wc -l
#72137
gunzip -c uniprot_trembl_fungi.dat.gz | grep "//" | wc -l #should be
cat uniprot_sprot_fungi.dat.gz uniprot_trembl_fungi.dat.gz > uniprot.sprot.tremble.fungi.dat.gz
```
Perl script to parse. entries are separated by `//` use the second entry in AC. Have local copy of the sprot file so testing locally

#### The Uniprot Uniref90 database (i.e., proteins clustered at 90% sim) is also on premise at `/mnt/oldhome/hcgs/shared/databases/uniref90/blast/uniref90.fasta` try a blast against this db (This is what is also used for Paladin)
```
cd ~/neonectria_genome_reseq_10072020/
sbatch ~/repo/neonectria_genome_reseq_10072020/maker_annotation/maker_genes_blast_uniprot_uniref90.slurm
cd maker2_run
cut -f1 makerFINAL.all.maker.proteins.UNIPROT.uniref90.blast | sort | uniq | wc -l
```
12274

#### Blast2GO (blast against all nr database with subsequent proprietary GO mapping)
Ran by Tuan
- 13039 blast hits (e-value default is 10^-6)
- 9631 annotated with GO terms (after filtering for annotation quality)

14064 total seqs = 92.7% hits, 68.5% GO annotation

 
## GO annotations
#### for the current releases of Uniprot to GOA mappings go here https://www.ebi.ac.uk/GOA/downloads and download goa_uniprot_all.gaf.gz
#### Note that the ftp links may need to be modified to http to access on Mac.
#### The file is quite large so if needed can download to the server
```
screen
curl http://ftp.ebi.ac.uk/pub/databases/GO/goa/UNIPROT/goa_uniprot_all.gaf.gz --output goa_uniprot_all.gaf.gz
#[detached from 31196.pts-2.login01]
```

## KEGG annotation
Can upload protein sequences here https://www.genome.jp/tools/kofamkoala/ OR https://www.kegg.jp/blastkoala/ but needs to be less than 10K or 5K sequences, respectively
```
#From local hd split to 5K per file
cd ~/repo/neonectria_genome_reseq_10072020/data/Nf_SPANDx_all_seqs/maker2_ann/
awk 'BEGIN {n_seq=0;} /^>/ {if(n_seq%5000==0){file=sprintf("makerFINAL.all.maker.proteins%d.fasta",n_seq);} print >> file; n_seq++; next;} { print >> file; }' < makerFINAL.all.maker.proteins.fasta
```
Then combine the results files (these from HMM search)
```
grep -v "^#" makerFINAL.all.maker.proteins.SET2.KEGG.result.txt > makerFINAL.all.maker.proteins.SET2.KEGG.result.txt.no_head
cat makerFINAL.all.maker.proteins.SET1.KEGG.result.txt makerFINAL.all.maker.proteins.SET2.KEGG.result.txt.no_head > makerFINAL.all.maker.proteins.HMM.KEGG.txt
rm makerFINAL.all.maker.proteins.SET2.KEGG.result.txt.no_head
```
How many annotation
```
grep -v "^#" makerFINAL.all.maker.proteins.HMM.KEGG.txt | wc -l
```
4,603 annotation out of 14064 genes. (yikes)

cut the KO ID line and append "KO:" to each entry
```
grep -v "^#" makerFINAL.all.maker.proteins.HMM.KEGG.txt | sed 's/^\*[[:space:]]//' | awk '{print $2}' | sort | uniq | sed 's/^/KO:/' > makerFINAL.all.maker.proteins.HMM.KEGG.uniq.txt
```
"Map up" the KO numbers based on the orthology map
```
cd ~/repo/neonectria_genome_reseq_10072020
perl KEGG_map/summarize_KEGG.pl data/ko00001-2.keg data/Nf_SPANDx_all_seqs/maker2_ann/makerFINAL.all.maker.proteins.HMM.KEGG.uniq.txt > data/Nf_SPANDx_all_seqs/maker2_ann/KEGG_map.txt
```
Also need to cut the KO to gene ID mappings. appending "KO:" to make it easy
```
cd ~/repo/neonectria_genome_reseq_10072020/data/Nf_SPANDx_all_seqs/maker2_ann/
grep -v "^#" makerFINAL.all.maker.proteins.HMM.KEGG.txt | sed 's/^\*[[:space:]]//' | awk '{print $2, $1}' > gene_id.KO.map
#sed -i '' -e 's/^/KO:/' gene_id.KO.map
```
