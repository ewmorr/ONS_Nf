
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
### Functional annotation with blast2GO was run on the original set, but the new assembly resulted in minor rearrangements and annotation of 225 new proteins. Can compare new to old based on sequence similarity to transfer functional annotations and save on rerunning all through B2GO. Comparing at 85,90,93,95,97,100% sequence similarity (of transcripts, vsearch does not have protein fuctionality). We use the old seqs as the DB and the new as the query, because there is one line reported per query including no hits so easy to filter. Also note that while there are some name matches most do not because of rearrangements.
```
cd Nf_annotate
grep ">" ~/neonectria_genome_reseq_10072020/maker2_run/makerFINAL.all.maker.transcripts.fasta > old_seqs_ids.txt
grep ">" maker2_run/makerFINAL.all.maker.transcripts.fasta > new_seqs_ids.txt
comm -13 <(sort old_seqs_ids.txt) <(sort new_seqs_ids.txt) | wc -l
#13893 unique names in new seq file
comm -23 <(sort old_seqs_ids.txt) <(sort new_seqs_ids.txt) | wc -l
#13668 unique names in old seq file
```
vsearch comparison
```
cd Nf_annotate
sbatch ~/repo/ONS_Nf/maker_annotation/derep_new_and_old_assembly_gene_predictions.slurm
```
Note that the number of matches reported in STOUT is the same as the number of hits. There is one line in the DB reported per query sequence.
```
grep "H" new_old_transcript_matches.95.uc
```
Matching seqs at dif simillirty
```
85  13460
90  13303
93  13111
95  12929
97  12600
100 10884
```
Count number unique matches
```
cut -f 9 new_old_transcript_matches.97.uc | sort | uniq | wc -l
#14289 (i.e., the number of queries)

#no match lines begin with N and contain an asterisk in the NA fields
grep "^N" new_old_transcript_matches.97.uc | wc -l
#1689
grep "\*" new_old_transcript_matches.97.uc | wc -l
#1689

#number of positive batches
grep "^H" new_old_transcript_matches.97.uc | wc -l
# 12600

#number positive matches to unique DB seqs
cut -f 10 new_old_transcript_matches.97.uc | sort | uniq | wc -l
# 12519 - 1 (subtract 1 for *)

#number of query seqs with only one match
cut -f 9 new_old_transcript_matches.97.uc | sort | uniq -c | sort | grep '^[[:space:]]*1' | wc -l
#14289
```
along all sims run
```
for i in 85 90 93 95 97 100
do(
    grep "^H" new_old_transcript_matches.$i.uc | wc -l
    cut -f 10 new_old_transcript_matches.$i.uc | sort | uniq | wc -l
    cut -f 10 new_old_transcript_matches.$i.uc | sort | uniq -c | sort | grep '^[[:space:]]*1' | grep -v \* | wc -l
)
done
```
Hits, number unique DB hits, and number of DB hits with one match in queries per similarity level. 
```
85  13460   13270   13107
90  13303   13142   12997
93  13111   12974   12850
95  12929   12810   12706
97  12600   12518   12441
100 10884   10872   10860
```
There are only 665 unique matches gained by reducing stringency from 97% to 85%, whereas from 100 to 97 we gain 1582. The 97% nt similarity is fully defensible as same gene, and so we will stick with that as a tradeoff between accuracy and rerunning minimal sequence set. Pull out the set of nonunique matches at 97% for filtering purposes and then pull the new seq IDs that hit those
```
    cut -f 10 new_old_transcript_matches.97.uc | sort | uniq -c | sort | grep -v '^[[:space:]]*1' | cut -d ' ' -f 8 > repeated_DB_seqs.97.txt
    wc -l repeated_DB_seqs.97.txt
    #77
    
    while IFS="" read -r p || [ -n "$p" ]
    do(
        grep ${p}$ new_old_transcript_matches.97.uc | cut -f 9 >> new_seq_matches_to_DB_repeats.txt
    )done < repeated_DB_seqs.97.txt
    wc -l new_seq_matches_to_DB_repeats.txt
    #159
    
```
also pull new seqs with no matches
```
grep \* new_old_transcript_matches.97.uc | cut -f 9 > no_match_new_seqs.97.txt
wc -l no_match_new_seqs.97.txt
#1689
```
1848 total (new) seqs with either no match or matching a multi matcher + 12441 good hits = 14289 original new seqs. Combine files for fasta search
```
cat new_seq_matches_to_DB_repeats.txt no_match_new_seqs.97.txt > fasta_IDs_for_B2GO.txt
perl ~/repo/neonectria_genome_reseq_10072020/perl_scripts/get_seqs_by_list_from_fasta.pl maker2_run/makerFINAL.all.maker.proteins.fasta fasta_IDs_for_B2GO.txt > Nf_new_seqs_for_B2GO.faa
grep ">" Nf_new_seqs_for_B2GO.faa | wc -l
```
Also pull the seq IDs of matches between new and old to substitute the gene names in the annotation files from blast2GO.
- Tuan D ran the blast2GO annotations for the new sequences above
- filter against this file (i.e., just use those annotations) and then assign annotations to the remaining sequences based on the matches in the .uc file

```
cut -f 9,10 new_old_transcript_matches.97.uc > new_old_transcript_matches.97.txt
```
pull down to local (where the B2GO files are)
```
lcd repo/neonectria_genome_reseq_10072020/data/blast2GO/
```
write the new annotations and old matches with new IDs
```
cd repo/neonectria_genome_reseq_10072020/data/blast2GO/
#granular annotations
perl ~/repo/ONS_Nf/maker_annotation/convert_old_2_new_B2GO.pl new_old_transcript_matches.97.txt Nf_new_seqs_for_B2GO-1.txt makerFINAL.all.maker.proteins-1.txt > Nf_granular_GO.txt
cut -f 3 Nf_granular_GO.txt | sort | uniq | wc -l
#14290 -1 (the header)
perl ~/repo/ONS_Nf/maker_annotation/convert_old_2_new_B2GO.pl new_old_transcript_matches.97.txt Nf_new_seqs_for_B2GO-1-GoSlim-Yeast.txt makerFINAL.all.maker.proteins-1_GOSlim_Yeast.txt > Nf_GOslim_Yeast.txt
cut -f 3 Nf_GOslim_Yeast.txt | sort | uniq | wc -l
#14290 -1 (the header)
```
Convert to long form. Use flag ANNOTATED for granular or GO-SLIM for slim terms
```
cd repo/neonectria_genome_reseq_10072020/data/blast2GO/
perl ~/repo/neonectria_genome_reseq_10072020/GO_slim_and_enrichment/B2GOslim2long.pl Nf_granular_GO.txt ANNOTATED > Nf_granular_GO.long.txt
perl ~/repo/neonectria_genome_reseq_10072020/GO_slim_and_enrichment/B2GOslim2long.pl Nf_GOslim_Yeast.txt GO-SLIM > Nf_GOslim_Yeast.long.txt
```
Need to sort to uniq becasue some grans may hit the same slim term in multiple pathways
```
sort Nf_granular_GO.long.txt | uniq > Nf_granular_GO.long.uniq.txt
sort Nf_GOslim_Yeast.long.txt | uniq > Nf_GOslim_Yeast.long.uniq.txt

wc -l Nf_granular_GO.long.txt
#38106
wc -l Nf_GOslim_Yeast.long.txt
#28277
wc -l Nf_granular_GO.long.uniq.txt
#38106
wc -l Nf_GOslim_Yeast.long.uniq.txt
#28277
```
### Count number of blast hits and GO annotations for the granular and the slim terms
```
grep "BLASTED" Nf_granular_GO.txt | wc -l
#13121
grep "NO-BLAST" Nf_granular_GO.txt | wc -l
#1168
grep "ANNOTATED" Nf_granular_GO.txt | wc -l
#9628
```
These are similar to the results from the first set of proteins where 14,064 total resulted in 13039 with blast hits and 9631 with GO annotations
```
grep "BLASTED" Nf_GOslim_Yeast.txt | wc -l
#13121
grep "NO-BLAST" Nf_GOslim_Yeast.txt | wc -l
#1168
grep "ANNOTATED" Nf_GOslim_Yeast.txt | wc -l
#5 (these are deprecated GO terms)
grep "GO-SLIM" Nf_GOslim_Yeast.txt | wc -l
#9623
```

## Compare assembly to mt genome of Nectriaceae from Fonseca et al.
```
sbatch repo/ONS_Nf/blastx_fonseca_mt_v_Nf_ref.slurm 
grep neonectria_genome_reseq_10072020 fonseca_mt.blast | wc -l
```
calculate statistics
```
mt_hits_stats.R
```
tig00000405_pilon has 60 hits at e-value >10^-5 against Fonseca Nectriaceae mt genomes constituting 63% of the total contig length. 14 total contis had hits, but no other contigs had more than 0.3% length coverage. 8 of the 14 >0.1% coverage.
