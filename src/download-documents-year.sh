#!/usr/bin/bash

YEAR=$1
SRC_DIR=$2
DATA_DIR=$3

YEAR_FMT="@Y"
NUMBER_FMT="@N"
MAX_ITEMS_YEAR=999

BASE_URL="https://www.uffs.edu.br/UFFS/"

base_urls=(
    "https://www.uffs.edu.br/UFFS/atos-normativos/edital/gr/@Y-@N"
)

echo "Iterando documentos de $YEAR:"

for url_fmt in "${base_urls[@]}"; do
    i=1

    while true; do
        if [[ "$i" -gt $MAX_ITEMS_YEAR ]]; then
            break
        fi

        leading_number=$(printf "%04d\n" $i)

        url=${url_fmt/$YEAR_FMT/$YEAR}
        url=${url/$NUMBER_FMT/$leading_number}

        output_folder=$DATA_DIR/text/$YEAR/${url/$BASE_URL/}

        if [ -d "$output_folder" ]; then
            echo " ignorando (existente) $url"
        fi

        if [ ! -d "$output_folder" ]; then
            echo " baixando $url"
            mkdir -p $output_folder
            scrapy runspider $SRC_DIR/download-document.py -a url="$url" -a output="$output_folder" --nolog
        fi

        ((i++))
    done
done
