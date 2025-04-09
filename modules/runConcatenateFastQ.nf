process runConcatenateFastQ {

/*
    @author: Poppy J hesketh Best
    @date: 2025-04-08
    @version: 1.0.0
    @description:
        This module concatenates the fastq files from Nanopore outputs 
        from the fastq_pass output from the MinION
    @changelog:
        v1.0.0-2025-08: Initial versin
*/

    tag "$sampleID"
    
    input:
        tuple val(barcode), 
                val(sampleID),
                val(type)
        path(fastq_pass)

    output:
        tuple val(sampleID),
            path("${sampleID}.fastq.gz"),
            val(type),          emit: concatened_fq

    script:
        """
        # Concatenate FASTQ files
            cat ${fastq_pass}/${barcode}/*fastq.gz > "${sampleID}.fastq.gz"
        """

}