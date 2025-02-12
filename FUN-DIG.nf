#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

    /*
    ========================================================================================
    O N - F U N - D I G : Oxford Nanopore technology FUNgal DIagnostics OF ONT AMPLICON DATA
    ========================================================================================
                
                A Nextflow pipeline for analysis of ONT-amplicon data for the 
                detection of fungal strains.

    Filter read to retain high-quality reads (Quality-score > 15, 97% accuracy) (seqkit)
    Cluster reads at 90% nucleotide identity (VSEARCH)
    Generate consensus for each cluster (Medaka, MiniMap2, SAMtools)
    Taxonomically classify each consensus sequences with BLASTn against RefSeq non-redundant database (BLAST)

    ----------------------------------------------------------------------------------------
    */

    /*
        IMPORT MODULES
    */
    include { runReadQC             }   from './modules/runReadQC.nf'
    include { runReadClustering     }   from './modules/runReadClustering.nf'
    include { runGenConsensus       }   from './modules/runGenConsensus.nf'
    include { runConsensusTax       }   from './modules/runConsensusTax.nf'
    include { genResultsTables      }   from './modules/genResultsTables.nf'

    /*
    ······································································································
        REQUIRED ARGUMENTS
    ······································································································
    */

    def helpMessage() {
        log.info"""

        ============================================================
        onFUN-DIG.nf  ~  version ${params.version}
        ============================================================
        Usage:

        The typical command for running the pipeline is as follows:

            nextflow run HUGTiP-HIV-1.nf/main.nf --samplesheet <samplesheet> --runID <name of run>
        
        Mandatory arguments:
            --name                  [chr]   Name of the run.
            --samplesheet           [chr]   Path to input data samplesheet (must be a csv with 4 columns: sampleID,forward,reverse,type)
                                                sampleID        - name of sample
                                                forward/reverse - complete paths to the read files
                                                type            - sample or control.
            --amplicon_lengths      [tup]     

        Read QC arguments (optional):
            --mQ		            [num]   Minimum quality of ONT reads (default: 10)
            --reporting_threshold	[num]   Minimum mutation frequency percent to report (default: 1).
            --consensus_pct		    [num]   Minimum percentage a base needs to be incorporated into the consensus sequence (default: 20).
            --min_read_qual	        [num]   Minimum quality for a position in a read to be masked (default: 30).
            --length_cutoff	        [num]   Reads which fall short of the specified length will be filtered out (default: 50).
            --score_cutoff		    [num]   Reads that have a median or mean quality score (depending on the score type specified) less than the score cutoff value will be filtered out (default: 30).
            --min_variant_qual      [num]   Minimum quality for variant to be considered later on in the pipeline (default: 30).
            --min_dp                [num]   Minimum required read depth for variant to be considered later on in the pipeline (default: 100).
            --min_ac                [num]   The minimum required allele count for variant to be considered later on in the pipeline (default: 5).
            --min_freq              [num]   The minimum required frequency for mutation to be considered in drug resistance report (default: 0.2).

        Read clustering and centroid generation:
            --xml                           Path to HIVdb ASI2 XML.
            --apobec-tsv                    Path to tab-delimited (tsv) HIVdb APOBEC DRM file.
            --comments-tsv                  Path to tab-delimited (tsv) HIVdb comments file.
        
        """.stripIndent()
    }

    /*
    ······································································································
        WORKFLOW: main
    ······································································································
    */

    workflow {

        def color_purple = '\u001B[35m'
        def color_green  = '\u001B[32m'
        def color_red    = '\u001B[31m'
        def color_reset  = '\u001B[0m'
        def color_cyan   = '\u001B[36m'

    // Create channel from sample sheet

        

    /*
    ······································································································
        CREATION OF CHANNELS
            The section creates the samples_ch and the controls_ch from the samplesheet. First the 
                sample sheet is imported and split by the 'type' column into sample or control, and these
                two sets of samples are directed into seperate workflows.
    ······································································································
    */

    }