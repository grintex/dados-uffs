#!/usr/bin/bash

YEAR=$1
SRC_DIR=$2
CSV_DATA_DIR=$3
JSON_DATA_DIR=$4

YEAR_FMT="@Y"
NUMBER_FMT="@N"

base_urls=(
    "https://www.uffs.edu.br/UFFS/atos-normativos/edital/gr/@Y-@N"
)

echo "Baixando documentos de $YEAR:"

for url_fmt in "${base_urls[@]}"; do
    i=1

    while true; do
        if [[ "$i" -gt 600 ]]; then
            break
        fi

        leading_number=$(printf "%04d\n" $i)

        url=${url_fmt/$YEAR_FMT/$YEAR}
        url=${url/$NUMBER_FMT/$leading_number}

        echo " $url"

        ((i++))
    done
done
