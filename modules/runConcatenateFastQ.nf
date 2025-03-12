process runConcatenateFastQ {

    tag "$sampleID"
    
    input:
        tuple val(sampleID), 
                path(reads)

    path(samplesheet)

    output:
        path("concatenated_tuple.csv"), emit: concatenated_csv

    script:
    // Check if samplesheet exists and get new sample ID if it does
    // TODO: moofy this for a shell IF argument to only perform the name change if the param.samplesheet exists
    /////// create a tuple with the old and new name and save that, and then create a tuple from the csv

        """
        if [[ ! -f ${params.samplesheet} ]]; then

            # Extract new sample ID from samplesheet
            newSampleId=\$(awk -F ',' '\$1 == "${sampleID}" {print \$2}' ${samplesheet})
            
            # If newSampleId is empty, use the original sampleId
            if [ -z "\$newSampleId" ]; then
                newSampleId="${sampleID}"
            fi

            # Concatenate FASTQ files
            cat ${reads}/*fastq.gz | gzip > "\${newSampleId}.fastq.gz"
            cat_read_path=\$(realpath \${newSampleId}.fastq.gz)

            echo -e "${sampleID},"${newSampleId};\${cat_read_path}" > concatenated_tuple.csv

            else

            # Concatenate FASTQ files using original sample ID
            cat ${reads}/*fastq.gz | gzip > "${sampleID}.fastq.gz"

            echo -e "${sampleID},"${sampleID};\${cat_read_path}" > concatenated_tuple.csv

        fi
        """

}