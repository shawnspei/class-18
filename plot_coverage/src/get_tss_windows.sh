#! /usr/bin/env bash

# supply knownGene_chr22.bed chr22_length.txt and output filename on
# command line

genes=$1
chroms=$2
output=$3

#get start sites 
awk ' {OFS="\t"} \
      $6 == "+" {print $1,$2,$2+1,$4,$5,$6} ;
      $6 == "-" {print $1,$3-1,$3,$4,$5,$6}' \
    $genes > $genes.tss.bed

#get +/- 2kbp
bedtools slop \
  -b 2000 \
  -i $genes.tss.bed \
  -g $chroms \
  > $genes.tss_slop.bed

# makewindows for forward strand TSSs 
awk '$6 == "+"' $genes.tss_slop.bed \
  | bedtools makewindows -b - -w 5 -i srcwinnum \
  | sort -k1,1 -k2,2n \
  | tr "_" "\t" \
  > $genes.tss_windows

# makewindows with reversed windows for reverse stranded TSSs 
awk '$6 == "-"' $genes.tss_slop.bed \
  | bedtools makewindows -reverse -b - -w 5 -i srcwinnum \
  | sort -k1,1 -k2,2n \
  | tr "_" "\t" \
  >> $genes.tss_windows

# sort the output
bedtools sort -i $genes.tss_windows > $output
