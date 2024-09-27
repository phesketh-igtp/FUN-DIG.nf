### Andreano *et al* 2023 - Rapid and real-time identification of fungi up to species level with long amplicon nanopore sequencing from clinical samples

- Tests the clinical suitability of using long-read-sequencing of samples from either of with clinical signs of infections
- Big problems with phylogenetic gaps in genetic knowledge to old species descriptions
- 

<u>**Methods:**</u>
- Primers:
    1. V3 region of 18S to D3 region of the 28S (~3,500 bp len)
    2. V1 region of 18S to D12 region of 28S  gene (~6000 bp len)
- 


### Ohta *et al* 2023 - Using nanopore sequencing to identify fungi from clinical samples with high phylogenetic resolution

- Pre-filtering reads
    ```{sh}
    seqkit seq -m ${MINLEN} -M ${MAXLEN} -q ${MINQ} raw-reads/${SAMPLEID}.fastq.gz | seqkit grep -vsif repetitive-sequences.fasta - > qc-reads/${SAMPLEID}.Q${MINQ}.m${MINLEN}.M${MAXLEN}.fastq.gz 
    ```
- Clustering reads
    ```{sh}
    vsearch --cluster_fast qc-reads/${SAMPLEID}.Q${MINQ}.m${MINLEN}.M${MAXLEN}.fastq.gz --id ${PAIRWISEID} --strand both --clusters vsearch/${SAMPLEID}.Q${MINQ}.m${MINLEN}.M${MAXLEN}.c${PAIRWISEID}.fastq.gz
    ```
- Extraction of a centroid per cluster
    ```{sh}
    seqkit split -p 2 vsearch/${SAMPLEID}.Q${MINQ}.m${MINLEN}.M${MAXLEN}.c${PAIRWISEID}.fastq.gz 
    seqkit range -r -1:-1 vsearch/${SAMPLEID}.cluster_part_001.fasta -w 0 > centroids/${SAMPLEID}.fasta
    ```
- Random subsampling / Even read sampling
    ```{sh}
    NUMREADS=$(grep -c '>' qc-reads/${SAMPLEID}.Q${MINQ}.m${MINLEN}.M${MAXLEN}.fastq.gz)

    if [[ ${READDEPTH} > ${NUMREADS} ]]; then echo -e "${red}ERROR: Target read depth greater than number of filtered reads for: ${SAMPLEID}.Q${MINQ}.m${MINLEN}.M${MAXLEN}.fastq.gz"

    seqkit shuffle -s ${RANDOM} [cluster.fasta] | seqkit head -n ${MINDEPTH} -w 0 > $
    ```
- Consensus calling
    ```{sh}
    medaka_consensus -d centroids/[centroid.fasta] -i [subread.fasta] -o [output directory] -m [model]
    ```
- Taxonimic classification
    ```{sh}
    makeblastdb -in [assemblies.fna] -out [database title] -dbtype nucl -hash_index -parse_seqids
    ```