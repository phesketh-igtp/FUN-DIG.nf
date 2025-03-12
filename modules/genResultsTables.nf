process genResultsTables {


    input:
        tuple val(sampleID),
            path(blastn)

    output:
        path("${sampleID}.tax.csv")

    script:

    """
        Rscript ${params_scriptDir}/R/compile_blasn-results
    """

}