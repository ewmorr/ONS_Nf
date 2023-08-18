library(dplyr)

blast_res = read.table("data/fonseca_mt.blast", header = F)
scf_len = read.table("data/scaffold_lengths.txt", header = T)


colnames(blast_res) = c(
    "contig",
    "dbID",
    "perc_sim",
    "hit_length",
    "mismatch",
    "gapopen",
    "qstart",
    "qend",
    "sstart",
    "send",
    "e-val",
    "bitscore"
)

colnames(scf_len) = c("contig", "contig_len")

mt_hits = blast_res %>%
    group_by(contig) %>%
    summarize(tot_hit_len = sum(hit_length), n_hit = n()) %>%
    left_join(., scf_len, by = "contig") %>%
    mutate(perc_contig = tot_hit_len/contig_len*100)

write.table(mt_hits, "data/mt_hits_summary.txt", col.names = T, row.names = F, quote = F)    
