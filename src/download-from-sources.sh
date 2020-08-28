#!/usr/bin/bash

SRC_DIR=$1
CSV_DATA_DIR=$2
JSON_DATA_DIR=$3

for row in $(cat $JSON_DATA_DIR/sources/cursos.json | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

    echo $(_jq '.id') $(_jq '.link')
    #scrapy runspider $(SRC_DIR)/download-source-programs.py -o $(JSON_DATA_DIR)/sources/cursos.json -a parameter1=value1 -a parameter2=value2
done