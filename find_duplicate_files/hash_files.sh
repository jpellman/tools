#!/bin/bash
# hash_files.sh
# John Pellman, 2016
# This script recursively travels through a directory, finds files, hashes them, fetches other relevant info using ls (owner, group, date accessed), and saves hashes and info into a CSV file
# created in the directory the script is run from.  This CSV can be used to evaluate whether or not there are duplicate files on a volume by using a Python script (hash_compare.py) that
# takes in multiple CSVs produced from different volumes and writes out a summary CSV of duplicated hash values.
# This is done in bash because the checksum is much faster with the C implementation.

dir=${1}

echo "hash,permissions,links,owner,group,size,last_modification_date,last_modification_time,time_zone,file" >> $(pwd)/$(basename ${dir})_hashes.csv

OIFS="$IFS"
IFS=$'\n'
for f in $(find ${dir} -type f); 
do 
    echo ${f}
    # Make robust to the case where someone has included spaces.  Later translation from tilde back to space assumes no or minimal file names with a tilde in them.
    f_nospaces=$(echo ${f} | sed 's/ /~/g')
    echo "$(md5sum ${f} | awk '{print $1}'),$(ls -l --full-time ${f} | sed 's|'${f}'|'${f_nospaces}'|g' | tail -1 | tr ' ' ',' | tr '~' ' ')" >> $(pwd)/$(basename ${dir})_hashes.csv
done
IFS="$OIFS"
