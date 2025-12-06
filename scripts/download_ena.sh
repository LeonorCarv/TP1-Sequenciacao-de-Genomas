#!/usr/bin/env bash
# Script para descarregar leituras paired-end do ENA

# ---Verificar se o accession foi passado como argumento---
if [ -z "$1" ]; then
	echo "Erro: É necessário fornecer um Run Accession do ENA como argumento"
	echo "Uso: $0 <ENA_RUN_ACCESSION>"
	exit 1
fi

set -e

# ---Variáveis---
ACCESSION="$1"
VOLUME="$2"
PAIRED="$3"
DIR_SAIDA="data/raw"
ENA_FTP_BASE="ftp.sra.ebi.ac.uk/vol1/fastq" # URL base do FTP do ENA para ficheiros FASTQ
PREFIXO_DIR="${ACCESSION:0:6}"

# URL - Read 1
R1_OUT="${DIR_SAIDA}/${ACCESSION}_1.fastq.gz"
URL_R1="ftp://${ENA_FTP_BASE}/${PREFIXO_DIR}/${VOLUME}/${ACCESSION}/${ACCESSION}_1.fastq.gz"
if [ ! -f "$R1_OUT" ]; then
	echo "A iniciar o download para o accession: $ACCESSION (R1)"
	wget -O "$R1_OUT" "$URL_R1"
else
	echo "Ficheiro $R1_OUT já existe."
fi

#URL_R1="ftp://${ENA_FTP_BASE}/${PREFIXO_DIR}/${VOLUME}/${ACCESSION}/${ACCESSION}_1.fastq.gz"
#echo "A iniciar o download para o accession: $ACCESSION (R1)"
#wget -P "$DIR_SAIDA" "$URL_R1"

# Apenas se for paired-end -> URL - Read 2
if [ "$PAIRED" = "yes" ]; then
	URL_R2="ftp://${ENA_FTP_BASE}/${PREFIXO_DIR}/${VOLUME}/${ACCESSION}/${ACCESSION}_2.fastq.gz"
	R2_OUT="${DIR_SAIDA}/${ACCESSION}_2.fastq.gz"
	if [ ! -f "$R2_OUT" ]; then
		echo "A iniciar o download para o accession: $ACCESSION (R2)"
		wget -O "$R2_OUT" "$URL_R2"
	else
		echo "Ficheiro $R2_OUT já existe."
	fi
fi

echo "Download de $ACCESSION concluído."
