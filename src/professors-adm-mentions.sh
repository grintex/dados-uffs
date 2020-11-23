#!/usr/bin/bash

NAMES_CSV_FILE_PATH=$1
SEARCH_DIR_PATH=$2
OUTPUT_DIR_PATH=$3

# https://stackoverflow.com/a/5947802
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

mkdir -p $OUTPUT_DIR_PATH

cd $SEARCH_DIR_PATH

cat $NAMES_CSV_FILE_PATH | while read name
do
    clean_name="${name// /_}"
    output_file="$OUTPUT_DIR_PATH/$clean_name.csv"

    printf "Checando ${YELLOW}$name${NC} "

    if [ -f "$output_file" ]; then
        printf "${RED}[NO]${NC} (existente ignorado)\n"
    else
        echo 'documento' > $output_file
        rg -w "$name" -g "*.plain" -l $SEARCH_DIR_PATH >> "$output_file"
        printf "${GREEN}[OK]${NC}\n"
    fi
done
