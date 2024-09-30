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

while getopts a:m:o:h option
do 
    case "${option}" in 
        i)INPUT=${OPTARG};;
        m)MINDEPTH=${OPTARG};;
        o)OUTPUT=${OPTARG};;
        h)Help; exit;;
    esac
done

################################################################################

## REQUIRED arguments
if [[ -z "${INPUT}" ]]; then echo -e "ERROR: -i/--input file is missing"; Help, exit 1; fi
if [[ -z "${MINDEPTH}" ]]; then echo -e "ERROR: -m/--mindepth value is missing"; Help, exit 1; fi
if [[ -z "${OUTPUT}" ]]; then echo -e "ERROR: -o/--output file name is missing"; Help, exit 1; fi

## OPTIONAL arguments

################################################################################

#······· Set up environment ········#

eval "$(conda shell.bash hook)"
conda activate fungal-18S

################################################################################

#······· Main ········#

seqkit shuffle -s ${RANDOM} ${INPUT} | seqkit head -n ${MINDEPTH} -w 0 > subsampling/${OUTPUT}