#!/bin/bash
#
# Convert Yagsbook documents to HTML.
#
# Author:  Samuel Penn
# Version: $Revision: 1.1 $
# Date:    $Date: 2004/08/21 17:52:26 $
#

stylesheet=""
outfile=""
outdir=""

which xsltproc > /dev/null
if [ $? -eq 1 ]
then
    echo "Cannot find 'xsltproc' - need this for processing"
    exit 1
fi

TEMP=`getopt -o s:d: -n 'yags2html' -- "$@"`
if [ $? != 0 ]
then
    echo "Syntax error"
    exit 1
fi

eval set -- "$TEMP"

while true
do
    case "$1" in
        -s) stylesheet=$2; shift 2;;
        -d) outdir=$2; shift 2;;
        --) shift; break ;;
        *) echo "Syntax error"; exit 1;;
    esac
done

for xml do
    html=`echo $xml | sed 's/\.yags/\.html/' | sed 's/\.xml/\.html/'`

    if [ "$outdir" = "" ]
    then
        outfile=$html
    else
        outfile=$outdir/`basename $html`
    fi

    echo "$xml --> $outfile"
    xsltproc -o $outfile $stylesheet $xml 
done

exit 1

