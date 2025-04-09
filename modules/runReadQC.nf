process runReadQC {

    tag "${sampleID}"

    conda "bioconda::nanofilt=2.3.0"

    input:
        tuple val(sampleID),
                val(type),
                path(reads)


    output:
        tuple val(sampleID),
                val(type),
                path("${sampleID}.qcreads.2.fastq.gz"), emit: qc_reads_ch

    script:
    
        """
        # Use NanoFilt to trim or remove reads with a quality less than minimum quality parameter
            zcat ${reads} | NanoFilt -q ${params.minQVal} \\
                    --headcrop ${params.headCrop} \\
                    --tailcrop ${params.tailCrop} \\
                    > ${sampleID}.qcreads.2.fastq.gz
        """
}