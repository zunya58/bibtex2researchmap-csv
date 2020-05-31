#!/bin/bash

BIBTEX=my-work.bib
if [ ! -f $BIBTEX ]; then
	echo "$BIBTEX missed" 1>&2
	exit 1
fi

work=`pwd`

cp -p $BIBTEX /

cd /
ruby $EXE $BIBTEX

for i in paper.csv presentation.csv misc.csv
do
	cp $i $work/
done
