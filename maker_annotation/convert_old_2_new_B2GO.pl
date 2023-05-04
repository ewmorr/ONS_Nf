#!/usr/bin/perl
# Usage: convert_old_2_new_B2GO.pl [sequence ID matches (new\tOld)] [new annotations] [old annotations]
#Eric Morrison
#05022023
#Description: We reran the final steps of the assembly and then reran gene prediction. Therefore we matched genes based on 97% sequence similarity, and then reran blast2GO annotation for any genes that either did not have a match in the old gene set, or that matched "old" genes with nultiple matches. These genes were rerun through B2GO (i.e., the new annotations). Now we will combine the annotation files by combining the new annotations with the old, and for the old set replace the gene ID from the old with the new gene ID that matches.
#The files as of 05022023 are new_old_transcript_matches.97.text
# Nf_new_seqs_for B2GO-1-GoSlim-Yeast.txt (new yeast slim) OR Nf_new_seqs_for_B2GO-1.txt (new granular)
# makerFINAL.all.maker.proteins-1_GOSlim_Yeast.txt (old yeast slim) OR makerFINAL.all.maker.proteins-1.txt (old granular)

use strict;
use warnings;

sub hash_matches{
    open(MAT, "$_[0]") || die "can't open match file\n";
    chomp(my @matches = <MAT>);
    my %new2old;
    my %old2new;
    
    foreach my $line (@matches){
        my @mat = split("\t", $line);
        #remove space bc b2go adds some weird spaces
        $mat[0] =~ s/\s//g;
        $mat[1] =~ s/\s//g;
        #we don't care about indexing the unmatched (they just get printed from the new ann file)
        if($mat[1] =~ /\*/){next;}
        
        $new2old{$mat[0]} = $mat[1];
        $old2new{$mat[1]} = $mat[0];
    }
    return(\%new2old, \%old2new);
}

sub hash_anns{
    open(IN, "$_[0]") || die "can't open annotation file\n";
    chomp(my @in = <IN>);
    my $header = shift(@in);
    my %in;
    foreach my $line (@in){
        my @line = split("\t", $line);
        #sequence name is the third column
        $in{$line[2]} = $line; #save the whole line as is
    }
    return($header, \%in);
}

#MAIN
{
    my $id_matches = $ARGV[0];
    my $new_anns = $ARGV[1];
    my $old_anns = $ARGV[2];
    
    #hash the matches for easy deletion of the new anns from the old anns
    my ($new2old_ref, $old2new_ref) = hash_matches($id_matches);
    
    #hash the annotations
    my ($header, $new_ann_ref) = hash_anns($new_anns);
    my ($header2, $old_ann_ref) = hash_anns($old_anns);
    
    #print the new anns
    print $header, "\n";
    foreach my $id ( sort {$a cmp $b} keys %$new_ann_ref){
        print $$new_ann_ref{$id}, "\n";
        #delete any of the printed anns from the old2new list which will be used for indexing the old anns
        #check if exists (for multi matchers and unmatched)
        if( exists($$new2old_ref{$id}) ){
            delete($$old2new_ref{ $$new2old_ref{$id} });
        }
    }
    
    #sub the new names into the old anns and print
    foreach my $id (sort {$a cmp $b} keys %$old2new_ref){
        my @line = split("\t", $$old_ann_ref{$id}); #pull ann lines
        $line[2] = $$old2new_ref{$id}; #replace old with new id
        print join("\t", @line), "\n";
    }
}
