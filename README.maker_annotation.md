
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
sbatch ~/repo/ONS_Nf/maker_annotation/maker2_final_run_Nf.slurm
```
Or instead of SNAP train and final run with dif models in final step, just run all at once (make sure it works before jumping here)
```
cd Nf_annotate/
sbatch ~/repo/ONS_Nf/maker_annotation/maker2_snap_train_plus_final_Nf.slurm
```

#### maker2 run was successful and is located at `Nf_annotate/maker2_run/` 
```
grep ">" makerFINAL.all.maker.transcripts.fasta | wc -l
#14289
grep ">" makerFINAL.transcripts.aed-1.0.fasta | wc -l
#9375
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
        
INFO    C:96.3%[S:96.1%,D:0.2%],F:2.2%,M:1.5%,n:3725
INFO    3589 Complete BUSCOs (C)
INFO    3580 Complete and single-copy BUSCOs (S)
INFO    9 Complete and duplicated BUSCOs (D)
INFO    83 Fragmented BUSCOs (F)
INFO    53 Missing BUSCOs (M)
INFO    3725 Total BUSCO groups searched
INFO    BUSCO analysis done. Total running time: 413.388222933 seconds
INFO    Results written in /mnt/lz01/garnas/ericm/Nf_annotate/maker2_run/run_busco_transcript_eval/

#all transcripts
# Summarized benchmarking in BUSCO notation for file makerFINAL.all.maker.transcripts.fasta
# BUSCO was run in mode: transcriptome

INFO    C:97.1%[S:96.7%,D:0.4%],F:2.4%,M:0.5%,n:3725
INFO    3618 Complete BUSCOs (C)
INFO    3602 Complete and single-copy BUSCOs (S)
INFO    16 Complete and duplicated BUSCOs (D)
INFO    88 Fragmented BUSCOs (F)
INFO    19 Missing BUSCOs (M)
INFO    3725 Total BUSCO groups searched

```

### The first run was performed with Fusarium graminearum proteins only. We also ran a second time with Uniprot reviewed fungal proteins downloaded 07252022. The Fgra annotation was significantly better based on BUSCO scores

## Compare transcripts from new annotation versus annotation of older assembly (different reads for Pilon polishing)
### Functional annotation with blast2GO was run on the original set, but the new assembly resulted in minor rearrangements and annotation of 225 new proteins. Can compare new to old based on sequence similarity to transfer functional annotations and save on rerunning all through B2GO. Comparing at 85,90,93,95,97,100% sequence similarity (of transcripts, vsearch does not have protein fuctionality). We use the old seqs as the DB and the new as the query, because there is one line reported per query including no hits so easy to filter.

```
cd Nf_annotate
sbatch ~/repo/ONS_Nf/maker_annotation/derep_new_and_old_assembly_gene_predictions.slurm
```
Note that the number of matches reported in STOUT is the same as the number of hits. There is one line in the DB reported per query sequence.
```
grep "H" new_old_transcript_matches.95.uc
```
