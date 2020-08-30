
# Info:
# 	Makefile para automatizar scripts de criação/agregação de dados
# 	disponíveis nesse repositório. Rode "make help" para saber mais.
# Autor:
#	Fernando Bevilacqua <fernando.bevilacqua@uffs.edu.br>
# Data:
#	24/01/2020

# Configurações
CKAN_URL = https://dados.uffs.edu.br
API_URL = $(CKAN_URL)/api/3/action

# Variáveis do script
CURRENT_DIR := $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
DATA_DIR := $(CURRENT_DIR)/data
SRC_DIR := $(CURRENT_DIR)/src
CSV_DATA_DIR := $(DATA_DIR)/csv
JSON_DATA_DIR := $(DATA_DIR)/json
DATASETS := $(shell curl -s $(API_URL)/package_list | jq -r '.result[]')

help:           ## Mostra essa ajuda.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install-deps:   ## Instala todas as dependências para rodar os scripts dessa pasta.
	@echo Instalando dependencias...
	curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
	sudo apt install git git-lfs python3-pip jq curl wget
	git lfs install
	pip3 install csvs-to-sqlite scrapy
	@echo Pronto!

list:          ## Lista os datasets disponíveis para download. 
	@echo $(DATASETS) | tr ' ' '\n'

download-sources:     ## Baixa informações sobre cursos. 
	scrapy runspider $(SRC_DIR)/download-source-programs.py -o $(JSON_DATA_DIR)/sources/cursos.json

download-from-sources:     ## Baixa informações sobre cursos. 
	$(SRC_DIR)/download-from-sources.sh $(SRC_DIR) $(CSV_DATA_DIR) $(JSON_DATA_DIR)

download-documents:     ## Baixa informações sobre cursos. 
	$(SRC_DIR)/download-documents.sh 2020 $(SRC_DIR) $(CSV_DATA_DIR) $(JSON_DATA_DIR)

download:      ## Faz download da última versão de todos os datasets.
	@for d in $(DATASETS); do \
		echo "Baixando $$d..."; \
		mkdir -p $(CSV_DATA_DIR)/$$d; \
		curl -s $(API_URL)/package_show?id=$$d | jq . > $(CSV_DATA_DIR)/$$d/$$d.json; \
		wget -q --show-progress -O $(CSV_DATA_DIR)/$$d/$$d.csv $(CKAN_URL)/datastore/dump/$$d; \
	done

sqlite:       ## Gera um database sqlite cujas tabelas são os CSV da pasta "data/csv/".  
	csvs-to-sqlite $(CSV_DATA_DIR) $(DATA_DIR)/sqlite/dados-uffs.db