#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

    /*
    ==========================================================================================
        F U N - D I G : Oxford Nanopore technology FUNgal DIagnostics OF ONT AMPLICON DATA
    ==========================================================================================

        A Nextflow pipeline for analysis of ONT-amplicon reads for the 
                classification of fungal strains.

        The workflow is as follows:
            1. Concatenate the reads into a single file (if the MinION data path is provided)
            2. Filter read to retain high-quality reads (default: Quality-score > 10, 97% accuracy) (seqkit)
            3. Cluster reads at 90% nucleotide identity (VSEARCH)
            5. Generate consensus for each cluster centroid (Medaka, MiniMap2, SAMtools)
            6. Taxonomically classify consensus sequences with BLASTn against RefSeq non-redundant database (BLAST)
            7. Produce summary results of the samples.

    ----------------------------------------------------------------------------------------
    */

    /*
        IMPORT MODULES
    */

    include { runConcatenateFastQ }   from './modules/runConcatenateFastQ.nf'
    include { runTrimAdaptors     }   from './modules/runTrimAdaptors.nf'
    include { runReadQC           }   from './modules/runReadQC.nf'
    include { runReadClustering   }   from './modules/runReadClustering.nf'
    include { runGenConsensus     }   from './modules/runGenConsensus.nf'
    include { runConsensusTax     }   from './modules/runConsensusTax.nf'
    include { genResultsTables    }   from './modules/genResultsTables.nf'

    /*
    ······································································································
        REQUIRED ARGUMENTS
    ······································································································
    */

    def helpMessage() {
        log.info"""

        ============================================================
                FUN-DIG.nf  ~  version:${params.version}
        ============================================================
        Usage:

        The typical command for running the pipeline is as follows:

            nextflow run HUGTiP-HIV-1.nf/main.nf --samplesheet <samplesheet> --runID <name of run>
        
        Mandatory arguments:
            --name                  [chr]   Name of the run (a unique identifier).
            --readsPath             [chr]   Path to directory contaiing reads (but be in their own directory i.e. barcode01/; barcode02/)

        Read QC arguments (optional):
            --amplicon_lengths      [tup]   Range of expected amplicon lengths (defaults: '[1500,1400,2000]')
            --minimumQuality        [num]   Minimum quality of ONT reads (default: 10)
            --samplesheet           [chr]   Path to input data samplesheet (must be a csv with 4 columns: sampleID,forward,reverse,type)
                                                barcode         - barcode number (i.e. barcode01, barcode02)
                                                sampleID        - name of sample
                                                type            - sample or control.

        Read clustering and centroid generation:
            --clusteringPerc        [num]   Percentage nucleotide identity for read clsutering (default: 0.95)
        
        """.stripIndent()
    }

    /*
    ······································································································
        WORKFLOW: main
    ······································································································
    */

    params.samplesheet = null
    params.fastq_pass = null

    workflow {

        def color_purple = '\u001B[35m'
        def color_green  = '\u001B[32m'
        def color_red    = '\u001B[31m'
        def color_reset  = '\u001B[0m'
        def color_cyan   = '\u001B[36m'

    log.info """
    ${color_purple}
    ==============================================================${color_red}
        ▗▄▄▄▖▗▖ ▗▖▗▖  ▗▖  ▗▄▄▄  ▗▄▄▄▖ ▗▄▄▖
        ▐▌   ▐▌ ▐▌▐▛▚▖▐▌  ▐▌  █   █  ▐▌   
        ▐▛▀▀▘▐▌ ▐▌▐▌ ▝▜▌▄▄▐▌  █   █  ▐▌▝▜▌
        ▐▌   ▝▚▄▞▘▐▌  ▐▌  ▐▙▄▄▀ ▗▄█▄▖▝▚▄▞▘ ${color_cyan}v.${params.version}${color_purple}
    ==============================================================${color_green}
    FUN-DIG.nf: A Nextflow pipeline for analysis of ONT-amplicon 
            reads for the classification of fungal strains.${color_purple}
    ==============================================================${color_reset}
    """

    // Define the parameter for the samplesheet


    // Create the channel from the samplesheet
        Channel
            .fromPath(params.samplesheet)
            .splitCsv(header:true)
            .map { row -> tuple(row.barcode, row.sampleID, row.type) }
            .set { samples_ch }

    // Validate that the samplesheet was provided
        if (params.samplesheet == null) {
            error "Please provide a samplesheet with the --samplesheet parameter"
        }

    // Concatenate reads and rename (if the samplesheet has been provided)
        runConcatenateFastQ( samples_ch, params.fastq_pass )

    // Perform adaptor trimming and QC
        runTrimAdaptors( runConcatenateFastQ.out.concatened_fq )
        runReadQC( runTrimAdaptors.out.trimmed_reads_ch )

    // Cluster reads 
        runReadClustering( runReadQC.out.qc_reads_ch )

    // Generate consensus sequences
        runGenConsensus( runReadClustering.out.clustered_reads_ch )

    // Taxonomically classify conensus sequences
        //runConsensusTax( runGenConsensus.out.conensus_sequences_ch )

    // Compile results summary
        //genResultsTables( runConsensusTax.out.blastn_out_ch )

    // Version control

    /*
    ······································································································
        CREATION OF CHANNELS
            The section creates the samples_ch and the controls_ch from the samplesheet. First the 
                sample sheet is imported and split by the 'type' column into sample or control, and these
                two sets of samples are directed into seperate workflows.
    ······································································································
    */

}