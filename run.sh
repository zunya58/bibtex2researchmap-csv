#!/bin/bash

if [ ! -f $BIBTEX ]; then
	echo "$BIBTEX missed" 1>&2
	exit 1
fi

work=`pwd`

cp -p $BIBTEX /$SRC/

cd /$SRC
ruby $EXE $BIBTEX

for i in paper_e.csv paper_j.csv misc_e.csv misc_j.csv
do
	cp $i $work/
done
