#!/usr/bin/bash

FILE_PATH=$1

csvtool namedcol lista_docentes_ch $FILE_PATH | sed 's/""/"/g' | sed 's/"\[/\[/g' | sed 's/\]"/\]/g' | tail -n +2 | jq .[].docente -r | sort -u
