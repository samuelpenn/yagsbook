#!/bin/bash
#
# Convert Yagsbook document to PDF.
# Uses FOP from xml.apache.org
#
# Author:  Samuel Penn
# Version: $Revision: 1.1 $
# Date:    $Date: 2004/08/21 17:52:26 $
#

JAVA_HOME=/opt/java
export JAVA_HOME

stylesheet="/usr/share/xml/yagsbook/article/xslt/pdf/yagsbook.xsl"
outfile=""
outdir=""

which xsltproc > /dev/null
if [ $? -eq 1 ]
then
    echo "Cannot find 'xsltproc' - need this for processing"
    exit 1
fi

which fop > /dev/null
if [ $? -eq 1 ]
then
	echo "Cannot find 'fop' - need this for PDF conversion"
	exit 1
fi

TEMP=`getopt -o s:d: -n 'yags2pdf' -- "$@"`
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
    fo=`echo $xml | sed 's/\.yags/\.fo/' | sed 's/\.xml/\.fo/'`
    pdf=`echo $xml | sed 's/\.yags/\.pdf/' | sed 's/\.xml/\.pdf/'`

    if [ "$outdir" = "" ]
    then
        outfile=$pdf
    else
	mkdir -p $outdir
        outfile=$outdir/`basename $pdf`
    fi

    echo "$xml --> $outfile"
    xsltproc -o /tmp/$fo $stylesheet $xml 
    fop /tmp/$fo $outfile 1>/dev/null 2>/dev/null
    rm -f /tmp/$fo
done

exit 1

