process runConcatenateFastQ {

    tag "$sampleID"
    
    input:
    tuple val(sampleID), 
            path(reads)

    path(samplesheet)

    output:
    tuple val(newSampleID), path("${newSampleID}.fastq.gz"), emit: concatenated_fastq

    script:
    // Check if samplesheet exists and get new sample ID if it does
    
    def newSampleID = sampleID

    if (samplesheet.name != 'NO_FILE') {
        """
        # Extract new sample ID from samplesheet
        newSampleId=\$(awk -F ',' '\$1 == "${sampleID}" {print \$2}' ${samplesheet})
        
        # If newSampleId is empty, use the original sampleId
        if [ -z "\$newSampleId" ]; then
            newSampleId="${sampleID}"
        fi

        # Concatenate FASTQ files
        cat ${reads} | gzip > "\${newSampleId}.fastq.gz"
        """

    } else {

        """
        # Concatenate FASTQ files using original sample ID
        cat ${reads} | gzip > "${sampleID}.fastq.gz"
        """

    }
}