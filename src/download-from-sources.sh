#!/usr/bin/bash

SRC_DIR=$1
CSV_DATA_DIR=$2
JSON_DATA_DIR=$3

for row in $(cat $JSON_DATA_DIR/sources/cursos.json | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

    original_link=$(_jq '.link')
    base_link=$(python3 $SRC_DIR/fix-url.py $original_link)
    link="$base_link/docentes"

    echo $link
    remove="https://www.uffs.edu.br/campi/"
    folder_structure=${base_link/$remove/}
    output_path="$JSON_DATA_DIR/professores/$folder_structure"

    echo $output_path
    mkdir -p $output_path
    scrapy runspider $SRC_DIR/download-professors.py -o $output_path/professores.json -a link=$link
done
