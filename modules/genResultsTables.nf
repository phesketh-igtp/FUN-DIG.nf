process genResultsTables {


    input:
        tuple val(sampleID),
            path(blastn)

    output:
        path("${sampleID}.tax.csv")

    script:

    """
        Rscript ${params.scriptDir}/R/summarise_blasn-results.R
    """

}