process runConsensusTax {

    tag "${sampleID}"

    conda params.main_env
    
    input:
        tuple val(sampleID),
            val(type),
            path(reads),
            path(centroids),
            path(centroids_file),
            path(consensus)

    output:
        tuple val(sampleID),
            path(reads),
            val(type),
            path(centroids),
            path(centroids_file),
            path(consensus),
            path("${sampleID}.blastn.out")

    script:

        """
        # Make BLASTn database of assemblies
        #    makeblastdb -in ${params.blastn_reference} -out reference.database -dbtype nucl -hash_index -parse_seqids

        # BLASTn consensus sequences against the reference database
            blastn \\
                -query ${consensus} \\
                -db ${params.blastn_reference} \\
                -out ${sampleID}.blastn.out \\
                -outfmt "6 saccver qcovs bitscore nident mismatch gaps pident evalue"
        """
}