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

    conda params.main_env
    
    input:
        tuple val(barcode), 
                path(sampleID),
                val(type)

    output:
        tuple val(sampleID),
            path("${sampleID}.fastq.gz"),
            val(type),          emit: concatened_fq

    script:
        """
        # Concatenate FASTQ files
            cat ${params.fastq_pass}/${barcode}/*fastq.gz > "${sampleID}.fastq.gz"
        """

}