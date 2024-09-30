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

while getopts c:s:o:m:h option
do 
    case "${option}" in 
        c)CENTROIDS=${OPTARG};;
        s)SUBREADS=${OPTARG};;
        o)OUTPUT=${OPTARG};;
        m)MODEL=${OPTARG};;
        h)Help; exit;;
    esac
done

################################################################################

## REQUIRED arguments
if [[ -z "${CENTROIDS}" ]]; then echo -e "ERROR: -i/--input file is missing"; Help, exit 1; fi
if [[ -z "${SUBREADS}" ]]; then echo -e "ERROR: -m/--mindepth value is missing"; Help, exit 1; fi
if [[ -z "${OUTPUT}" ]]; then echo -e "ERROR: -o/--output file name is missing"; Help, exit 1; fi

## OPTIONAL arguments
if [[ -z "${MODEL}" ]]; then MODEL=model; echo -e "No model specified, defaulting to ${MODEL}"; fi

################################################################################

#······· Set up environment ········#

eval "$(conda shell.bash hook)"
conda activate fungal-18S

################################################################################

#······· Main ········#

medaka_consensus -d ${CENTROIDS} -i ${SUBREADS} -o ${OUTPUT} -m ${MODEL}

################################################################################

conda deactivate