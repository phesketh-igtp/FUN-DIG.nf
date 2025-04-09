process runReadClustering {

    tag "${sampleID}"

    conda "bioconda::vsearch=2.30.0"
    
    input:
        tuple val(sampleID),
                val(type),
                path(reads)

    output:
        tuple val(sampleID),
            val(type),
            path(reads),
            path("${sampleID}.clusters.fasta"),
            path("${sampleID}.clusters.txt"), emit: clustered_reads_ch

    script:

        """
        # Cluster qc reads into centroids
            vsearch --cluster_fast ${reads} \\
                    --id ${params.clusteringPerc} \\
                    --strand both \\
                    --clusters ${sampleID}.clusters.txt \\
                    --centroids ${sampleID}.clusters.fasta \\
                    --threads ${params.cpu}
        """

}
