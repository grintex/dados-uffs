#!/usr/bin/bash

YEAR=$1
SRC_DIR=$2
DATA_DIR=$3

YEAR_FMT="@Y"
NUMBER_FMT="@N"
MAX_ITEMS_YEAR=9999

BASE_URL="https://www.uffs.edu.br/UFFS/"

base_urls=(
    "https://www.uffs.edu.br/UFFS/atos-normativos/edital/gr/@Y-@N"
    "https://www.uffs.edu.br/UFFS/atos-normativos/portaria/gr/@Y-@N"
    "https://www.uffs.edu.br/UFFS/atos-normativos/portaria/dirch/@Y-@N"
    "https://www.uffs.edu.br/UFFS/atos-normativos/portaria/proad/@Y-@N"
)

# https://stackoverflow.com/a/5947802
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Iterando documentos de ${YELLOW}$YEAR${NC}:"

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
            echo " ignorando (existente) ${YELLOW}$url${NC}"
        fi

        if [ ! -d "$output_folder" ]; then
            if curl --output /dev/null --silent --head --fail "$url"
            then
                # URL existe (HTTP 200)
                echo " baixando ${GREEN}$url${NC}"
                mkdir -p $output_folder
                scrapy runspider $SRC_DIR/download-document.py -a url="$url" -a output="$output_folder" --nolog                
            else
                # URL não existe (HTTP 404)
                echo " erro 404 em ${RED}$YEAR${NC}$url, desistindo das buscas"
                break 2
            fi
        fi

        ((i++))
    done
done

echo "Finalizado com documentos de ${YELLOW}$YEAR${NC}!"