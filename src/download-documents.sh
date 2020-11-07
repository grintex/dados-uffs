#!/usr/bin/bash

SRC_DIR=$1
DATA_DIR=$2

years=(
    2010 2011 2012
    2013 2014 2015
    2016 2017 2018
    2019 2020
)

echo "Iterando documentos por ano:"

for year in "${years[@]}"; do
    $SRC_DIR/download-documents-year.sh $year $SRC_DIR $DATA_DIR &
    sleep 10
done
