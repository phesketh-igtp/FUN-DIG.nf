# FUN-DIG.nf: Fungal diagnostics using ONT sequencing technology

### Introduction

A Nextflow pipeline for analysis of ONT-amplicon reads for the classification of fungal strains.This workflow has only been tested on data generated on R.10 ONT flowcells, sequenced on a Mk1D MinION.

The workflow is as follows:
1. Concatenate the reads into a single file (if the MinION data path is provided)
 2. Filter read to retain high-quality reads (default: Quality-score > 10, 97% accuracy) (seqkit)
 3. Cluster reads at 90% nucleotide identity (VSEARCH)
 4. Generate consensus for each cluster centroid (Medaka, MiniMap2, SAMtools)
 5. Taxonomically classify consensus sequences with BLASTn against RefSeq non-redundant database (BLAST)
 6. Produce summary results of the samples.

### Instalation

### Test data

### Troubleshooting

### Citations

Please cite the following studies if you have utilised this workflow.

- [Ohta *et al.*, (2023) "*Using nanopore sequencing to identify fungi from clinical samples with high phylogenetic resolution*"](https://www.nature.com/articles/s41598-023-37016-0)
- [Shen *et al.*, (2024) "*SeqKit2: A Swiss Army Knife for Sequence and Alignment Processing*"](https://onlinelibrary.wiley.com/doi/10.1002/imt2.191)
- [Rognes *et al.,* (2016) "*VSEARCH: a versatile open source tool for metagenomics*"](https://peerj.com/articles/2584/)
- [PoreChop: adapter trimmer for Oxford Nanopore reads ](https://github.com/rrwick/Porechop)
- [Medaka: Sequence correction provided by ONT Research](https://github.com/nanoporetech/medaka)
