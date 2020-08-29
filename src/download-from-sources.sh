#!/usr/bin/bash

SRC_DIR=$1
CSV_DATA_DIR=$2
JSON_DATA_DIR=$3

base_url="https://www.uffs.edu.br/campi/"

for row in $(cat $JSON_DATA_DIR/sources/cursos.json | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

    original_link=$(_jq '.link')
    base_link=$(python3 $SRC_DIR/fix-url.py $original_link)
    
    link="$base_link/docentes"

    if [[ $string == *"mestrado"* ]]; then
        link="$base_link/corpo-docente"
    fi

    echo $link

    folder_structure=${base_link/$base_url/}

    output_path_json="$JSON_DATA_DIR/professores/$folder_structure"
    output_path_csv="$CSV_DATA_DIR/professores/$folder_structure"

    mkdir -p $output_path_json
    mkdir -p $output_path_csv

    scrapy runspider $SRC_DIR/download-professors.py -o $output_path_json/professores.json -a link=$link --nolog
    scrapy runspider $SRC_DIR/download-professors.py -o $output_path_csv/professores.csv -a link=$link --nolog
done

# Adjust some peculiarities
mv $JSON_DATA_DIR/professores/laranjeiras-do-sul/cursos/cursos $JSON_DATA_DIR/professores/laranjeiras-do-sul/cursos/graduacao
