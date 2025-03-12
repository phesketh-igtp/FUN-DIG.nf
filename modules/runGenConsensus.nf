process runGenConsensus {

        tag "${sampleID}"

        input:
                tuple val(sampleID),
                        path(reads),
                        path(centroids)

        output:
                tuple val(sampleID),
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