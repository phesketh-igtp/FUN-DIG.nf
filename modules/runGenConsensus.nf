process runGenConsensus {

        tag "${sampleID}"

        conda "bioconda::medaka=2.0.1"

        input:
                tuple val(sampleID),
                        val(type),
                        path(reads),
                        path(centroids),
                        path(centroids_file)

        output:
                tuple val(sampleID),
                        val(type),
                        path(reads),
                        path(centroids),
                        path(centroids_file),
                        path("${sampleID}.cns.fasta"), emit: conensus_sequences_ch

        script:

        """
        # Create consensus with medaka
                medaka_consensus \\
                        -d ${centroids} \\
                        -i ${reads} \\
                        -o ${sampleID}.cns.fasta \\
                        -m ${params.medaka_model}
        """

}