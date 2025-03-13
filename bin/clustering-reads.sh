#!/usr/bin/env bash

################################################################################

#······· Help message ········#

Help()
{
echo -e "prefiler-read.sh"
echo -e "Required flags:"
echo -e "   -a  The A thing"
echo -e "   -b  The B thing"
echo -e "Optional flags:"
echo -e "   -c  The C thing (default : -c 2)"
echo -e "   -h  Print this help message and exit."
echo -e "Example:"
echo -e "e.g. bash myscript.sh -a /path/to/A.thing -b "The B thing" -c 5 "
}

################################################################################

#······· Define flags/arguments/parameters ········#

while getopts a:p:o:h option
do 
    case "${option}" in 
        i)INPUT=${OPTARG};;
        p)PAIRWISEID=${OPTARG};;
        o)OUTPUT=${OPTARG};;
        h)Help; exit;;
    esac
done

################################################################################

## REQUIRED arguments
if [[ -z "${INPUT}" ]]; then echo -e "ERROR: -i/--input file is missing"; Help, exit 1; fi

## OPTIONAL arguments
if [[ -z "${REPETATIVEfasta}" ]]; then REPETATIVEfasta=references/qc-repetitive-sequence.fasta; fi
if [[ -z "${PAIRWISEID}" ]]; then PAIRWISEID=0.98; fi 

################################################################################

#······· Set up environment ········#

eval "$(conda shell.bash hook)"
conda activate fungal-18S

################################################################################

#······· Main ········#
vsearch --cluster_fast ${INPUT} --id ${PAIRWISEID} --strand both --clusters vsearch/${OUTPUT}
