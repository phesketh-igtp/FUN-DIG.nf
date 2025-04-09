process runTrimBarcodes {

    tag "${sampleID}"

    conda "bioconda::porechop=0.2.4"

    input:
        tuple val(sampleID), 
                path(reads),
                val(type)

    output:
        tuple val(sampleID),
                val(type),
                path("${sampleID}.qcreads.1.fastq.gz"), emit: trimmed_reads_ch

    script:
    
        """
        # Use porechop to remove known ONT adaptors
            porechop -i ${reads} \\
                    -o ${sampleID}.qcreads.1.fastq.gz
        """

}