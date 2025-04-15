#!/bin/bash

eval "$(conda shell.bash hook)"

## BLASTn and seqkit must be available in your PATH

##################################################################################################

# Download the most recent GenBank tsv file
wget https://ftp.ncbi.nlm.nih.gov/genomes/genbank/assembly_summary_genbank.txt

# Grep the list fungi and create the download script

grep -i "fungi" assembly_summary_genbank.txt | \
    grep -i "reference genome" | \
        grep -Ei "Complete Genome|Scaffold" > fungi_assembly_summary_genbank.txt


awk -F '\t' '{print $20}' fungi_assembly_summary_genbank.txt | \
    sed -E 's/^https(.*)(\/.*)/wget ftp\1\2\2_genomic.fna.gz/g' \
        > fungi.genomic.download.sh

sed -n '2p' assembly_summary_genbank.txt | sed 's@#@@g' > fungi-ncbi-metadata.tsv
cat fungi_assembly_summary_genbank.txt >> fungi-ncbi-metadata.tsv

# run the download script
mkdir -p fundig-genomes/
mv fungi.genomic.download.sh fundig-genomes/
cd genomes/; bash fungi.genomic.download.sh
cd ../

rm fungi.genomic.download.sh assembly_summary_genbank.txt

##################################################################################################

# 
