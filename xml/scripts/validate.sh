#!/bin/sh
#
# validate
#
# Checks all .yags files in the specified directory to see if
# they are well formed. Any files which are not well formed
# will be listed as output.
#
# Later versions of this script may check for validity as
# well.
#
# Author:  Samuel Penn
# Version: $Revision: 1.2 $
# Date:    $Date: 2004/08/21 18:03:06 $
#

count=0
for x in `find $1 -name "*.yags"`
do
    xmllint $x 2>/dev/null >/dev/null
    if [ $? -ne 0 ]
    then
        echo $x
        count=`expr $count + 1`
    fi
done

exit $count

