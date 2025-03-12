process runReadClustering {

    tag "${sampleID}"
    
    input:
        tuple val(sampleID),
                path(reads),
                path(qc_reads)

    output:
        tuple val(sampleID),
                path(reads),
                path("${sampleID}.clusters.fasta"), emit: clustered_reads_ch

    script:

        """
        # Cluster qc reads into centroids
            vsearch --cluster_fast \\
                    --id ${params.clusteringPerc} \\
                    --strand both \\
                    --clusters ${sampleID}.clusters.txt \\
                    --centroids ${sampleID}.clusters.fasta \\
                    --threads ${params.cpu}
        """

}
