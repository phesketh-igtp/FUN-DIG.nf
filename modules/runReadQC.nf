process runReadQC {

    tag "${sampleID}"
    
    input:
        tuple val(sampleID), 
                path(reads)

    output:
        tuple val(sampleID),
                path(reads),
                path(${sampleID}.qcreads.fastq.gz), emit: trimmed_reads_ch

    script
        """

        # Use porechop to remove known ONT adaptors
            porechop -i ${reads} -o ${sampleID}.qcreads.1.fastq.gz --verbosity 2 

        # Use NanoFilt to trim or remove reads with a quality less than minimum quality parameter
            zcat ${sampleID}.qcreads.1.fastq.gz \\
                | NanoFilt -q 10 --headcrop ${params.headCrop} --tailcrop ${params.tailCrop} \\
                > ${sampleID}.qcreads.fastq.gz

        """
}