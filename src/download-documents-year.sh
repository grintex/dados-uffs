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

echo -e "Iterando documentos de ${YELLOW}$YEAR${NC}:"

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

        if [ -f "$SRC_DIR/.stop" ]; then
            echo -e "${RED}STOP${NC} ${YELLOW}$YEAR${NC} em $url"
            exit 1
        fi

        if [ -d "$output_folder" ]; then
            echo -e "${YELLOW}SKIP${NC} (existente) ${YELLOW}$YEAR${NC} $url"
        fi

        if [ ! -d "$output_folder" ]; then
            if curl --output /dev/null --silent --head --fail "$url"
            then
                # URL existe (HTTP 200)
                echo -e "${GREEN}OK${NC} (downloading) ${YELLOW}$YEAR${NC} $url"
                mkdir -p $output_folder
                scrapy runspider $SRC_DIR/download-document.py -a url="$url" -a output="$output_folder" --nolog                
            else
                # URL não existe (HTTP 404)
                echo -e "${RED}ERROR${NC} (404) ${YELLOW}$YEAR${NC} $url"
                break
            fi
        fi

        ((i++))
    done
done

echo -e "Finalizado com documentos de ${YELLOW}$YEAR${NC}!"