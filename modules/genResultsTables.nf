process genResultsTables {

    conda params.main_R_env

    input:
        tuple val(sampleID),
            path(reads),
            val(type),
            path(centroids),
            path(centroids_file),
            path(consensus),
            path(blastn_out)

    output:
        path("${sampleID}.tax.csv")

    script:

    """
        Rscript ${params.scriptDir}/R/summarise_blasn-results.R
    """

}