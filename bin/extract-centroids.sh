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

while getopts i:o:h option
do 
    case "${option}" in 
        i)INPUT=${OPTARG};;
        o)OUTPUT=${OPTARG};;
        h)Help; exit 1;;
    esac
done

################################################################################

#·······  Argument ········#

## REQUIRED arguments
if [[ -z "${INPUT}" ]]; then echo -e "ERROR: -i/--input file is missing"; Help, exit 1; fi
if [[ -z "${OUTPUT}" ]]; then echo -e "ERROR: -i/--input file is missing"; Help, exit 1; fi

## OPTIONAL arguments

################################################################################

#······· Set up environment ········#

eval "$(conda shell.bash hook)"
conda activate fungal-18S

################################################################################

#······· Main ········#

seqkit split -p 2 ${INPUT}
seqkit range -r -1:-1 ${INPUT}.cluster_part_001.fasta -w 0 > centroids/${OUTPUT}.fasta