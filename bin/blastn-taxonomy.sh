#!/usr/bin/env bash

################################################################################

#······· Help message ········#

Help()
{
echo -e "BLASTn classification of final assemblies"
echo -e "Required flags:"
echo -e "   -i, --input Final funal 18S assemblies for taxonomic classification"
echo -e "   -o, --output  Output file name"
}

################################################################################

#······· Define flags/arguments/parameters ········#

while getopts i:o:r:h option
do 
    case "${option}" in 
        i)INPUT=${OPTARG};;
        o)OUTPUT=${OPTARG};;
        r)REFERENCE
        h)Help; exit;;
    esac
done

################################################################################

## REQUIRED arguments
if [[ -z "${INPUT}" ]]; then echo -e "ERROR: -i/--input file is missing"; Help, exit 1; fi
if [[ -z "${OUTPUT}" ]]; then echo -e "ERROR: -o/--output file name is missing"; Help, exit 1; fi

## OPTIONAL arguments

################################################################################

#······· Set up environment ········#

eval "$(conda shell.bash hook)"
conda activate fungal-18S

################################################################################

#······· Main ········#

# Make BLASTn database of assemblies
rm reference.database
makeblastdb -in ${REFERENCE} -out reference.database -dbtype nucl -hash_index -parse_seqids

# BLASTn consensus sequences against the reference database
blastn -query ${INPUT} -db reference.database -out ${OUTPUT} -outfmt "6 saccver qcovs bitscore nident mismatch gaps pident evalue"

################################################################################

conda deactivate