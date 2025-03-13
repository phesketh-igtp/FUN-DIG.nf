process genResultsTables {


    input:
        tuple val(sampleID),
            path(blastn)

    output:
        path("${sampleID}.tax.csv")

    script:

    """
        Rscript ${params_scriptDir}/R/summarise_blasn-results.R
        
    """

}