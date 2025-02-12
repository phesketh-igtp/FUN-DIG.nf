#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

    /*
    ========================================================================================
    O N - F U N - D I G : Oxford Nanopore technology FUNgal DIagnostics OF ONT AMPLICON DATA
    ========================================================================================
                
                A Nextflow pipeline for analysis of ONT-amplicon data for the 
                detection of fungal strains.

    Concatenate the reads into a single file
    Filter read to retain high-quality reads (Quality-score > 15, 97% accuracy) (seqkit)
    Cluster reads at 90% nucleotide identity (VSEARCH)
    Generate consensus for each cluster (Medaka, MiniMap2, SAMtools)
    Taxonomically classify each consensus sequences with BLASTn against RefSeq non-redundant database (BLAST)

    ----------------------------------------------------------------------------------------
    */

    /*
        IMPORT MODULES
    */
    include { runConcatenateFastQ   }   from './modules/runConcatenateFastQ.nf'
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
            --readsPath             [chr]   Path to directory contaiing reads (but be in their own directory i.e. barcode01/; barcode02/)
            --amplicon_lengths      [tup]   Range of expected amplicon lengths (defaults: '[1500,1400,2000]')

        Read QC arguments (optional):
            --minimumQuality        [num]   Minimum quality of ONT reads (default: 10)
            --samplesheet           [chr]   Path to input data samplesheet (must be a csv with 4 columns: sampleID,forward,reverse,type)
                                                barcode         - barcode number (i.e. barcode01, barcode02)
                                                sampleID        - name of sample
                                                type            - sample or control.

        Read clustering and centroid generation:
            --clusteringPercentage  [num]   Percentage nucleotide identity for read clsutering (default: 90)
        
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

    // Create channel with the paths to each directory containing fastQs
        Channel
            .fromPath("${params.readsPath}/*", type: 'dir')
            .map { dir ->
                def sampleID = dir.name
                def reads = file("${dir}/*.fastq*")
                return tuple(sampleID, reads)
            }
            .set { samples_ch }

        samples_ch.view()

    // Concatenate reads and rename (if the samplesheet has been provided)
        runConcatenateFastQ(samples_ch, params.samplesheet)
    
        // You can now use the concatenated_fastq channel in subsequent processes
        runConcatenateFastQ.out.concatenated_fastq.view()

    // Perform ReadQC
        runReadQC(runConcatenateFastQ.out.concatenated_fastq)

    // Cluster reads 
        runReadClustering(runReadQC.out.trimmed_reads_ch)

    // Generate consensus sequences
        runGenConsensus(runReadClustering.out.clustered_reads_ch)

    // Taxonomically classify conensus sequences
        runConsensusTax(runGenConsensus.out.conensus_sequences_ch)

    // Compile results summary
        genResultsTables(runConsensusTax.out.blastn_out_ch)

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